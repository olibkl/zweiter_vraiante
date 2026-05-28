/// <summary>
/// [scenario]
/// Modules: 
/// </summary>
page 5138656 "BET FN Scenario Dimension Line"
{
    ApplicationArea = All;
    UsageCategory = None;
    Caption = 'Scenario Dimension Line';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "BET FN Scenario Dimension Line";
    SourceTableView = sorting("Sorting No.");
    Extensible = true;

    layout
    {
        area(Content)
        {
            repeater(Control1117300000)
            {
                ShowCaption = false;
                field("Dimension Code"; Rec."Dimension Code")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Code"; Rec.Code)
                {
                    Editable = false;
                }
                field(Active; Rec.Active)
                {
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field(Description; Rec.Description)
                {
                    Editable = false;
                }
                field(Weight; Rec.Weight)
                {
                    Editable = WeightEditable;

                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field(Percentage; Rec.Percentage)
                {
                    Editable = PercentageEditable;
                }
                field("Avg. Price"; Rec."Avg. Price")
                {
                    Editable = "Avg. PriceEditable";
                    Visible = "Avg. PriceVisible";
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(SelectAllLines)
            {
                Caption = 'Select all lines';
                ToolTip = 'Select all lines';
                Image = AllLines;

                trigger OnAction()
                begin
                    SetAllActive();
                end;
            }
            action(SelectMarkedLines)
            {
                Caption = 'Select marked lines';
                ToolTip = 'Select marked lines';
                Image = Allocations;

                trigger OnAction()
                begin
                    SetMarkedActive();
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';

                actionref(SelectAllLines_Promoted; SelectAllLines)
                {
                }
                actionref(SelectMarkedLines_Promoted; SelectMarkedLines)
                {
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        Editable_L: Boolean;
    begin
        xRec := Rec;
        Editable_L := Rec.Active and not DateLine_G;
        WeightEditable := Editable_L;
        CalcSumPercent();
    end;

    trigger OnInit()
    begin
        "Avg. PriceEditable" := true;
        "Avg. PriceVisible" := true;
        WeightEditable := true;
    end;

    trigger OnOpenPage()
    var
        ScenarioDimension_LT: Record "BET FN Scenario Dimension";
        FilterText: Text[250];
    begin
        // ### wenn Datum, dann Wichtung nicht editierbar (da <> 12 Monate möglich); Prozente editierbar
        ScenarioDimension_LT.Reset();
        ScenarioDimension_LT.SetFilter("Scenario Code", Rec.GetFilter("Scenario Code"));
        ScenarioDimension_LT.SetFilter(Code, Rec.GetFilter("Dimension Code"));
        ScenarioDimension_LT.FindFirst();

        // ### bei Verwendung von WG/HWG/Abteilung DS-Preis-Spalte anzeigen:
        case ScenarioDimension_LT."Table No." of
            Database::"Item Category", Database::"BET FN Division", Database::"BET FN Main Waregroup":
                begin
                    "Avg. PriceEditable" := true;
                    "Avg. PriceVisible" := true;
                end;

            else begin
                "Avg. PriceEditable" := false;
                "Avg. PriceVisible" := false;
            end;
        end;

        DateLine_G := ScenarioDimension_LT.Dateline;
        PercentageEditable := DateLine_G;

        // ### Filter dürfen nicht aufgehoben werden:
        FilterText := CopyStr(Rec.GetView(), 1, 250);
        Rec.FilterGroup(2);
        Rec.SetView(FilterText);
        Rec.FilterGroup(0);
    end;

    var
        "Avg. PriceEditable": Boolean;
        "Avg. PriceVisible": Boolean;
        DateLine_G: Boolean;
        PercentageEditable: Boolean;
        WeightEditable: Boolean;

    procedure CalcSumPercent()
    var
        ScenarioDimLine_LT: Record "BET FN Scenario Dimension Line";
    begin
        ScenarioDimLine_LT.Reset();
        ScenarioDimLine_LT.SetRange("Scenario Code", Rec."Scenario Code");
        ScenarioDimLine_LT.SetRange("Dimension Code", Rec."Dimension Code");
        ScenarioDimLine_LT.CalcSums(Percentage);
    end;

    procedure SetAllActive()
    var
        ScenarioDimensionLine_LT: Record "BET FN Scenario Dimension Line";
        WeightTotal_L: Decimal;
    begin
        ScenarioDimensionLine_LT.Reset();
        ScenarioDimensionLine_LT.SetCurrentKey(Active);
        ScenarioDimensionLine_LT.SetRange("Scenario Code", Rec."Scenario Code");
        ScenarioDimensionLine_LT.SetRange("Dimension Code", Rec."Dimension Code");
        ScenarioDimensionLine_LT.SetRange(Active, false);
        if ScenarioDimensionLine_LT.IsEmpty() then begin
            //### es sind bereits alle Zeilen aktiv: alle inaktiv schalten
            ScenarioDimensionLine_LT.SetRange(Active);
            ScenarioDimensionLine_LT.ModifyAll(Percentage, 0);
            ScenarioDimensionLine_LT.ModifyAll(Active, false);
        end else begin
            //### es sind noch nicht alle Zeilen aktiv: alle Zeilen aktiv schalten
            ScenarioDimensionLine_LT.SetRange(Active);
            ScenarioDimensionLine_LT.ModifyAll(Active, true);

            //### Prozente neu berechnen:
            ScenarioDimensionLine_LT.CalcSums(Weight);
            WeightTotal_L := ScenarioDimensionLine_LT.Weight;
            if ScenarioDimensionLine_LT.Find('-') then
                repeat
                    if WeightTotal_L = 0 then
                        ScenarioDimensionLine_LT.Percentage := 0
                    else
                        ScenarioDimensionLine_LT.Percentage := ScenarioDimensionLine_LT.Weight / WeightTotal_L * 100;
                    ScenarioDimensionLine_LT.Modify();
                until ScenarioDimensionLine_LT.Next() = 0;
        end;

        CalcSumPercent();
    end;

    procedure SetMarkedActive()
    var
        ScenarioDimensionLine_LT: Record "BET FN Scenario Dimension Line";
        WeightTotal_L: Decimal;
    begin
        /*
        CurrForm.SetSelectionFilter(Rec);
        MarkedOnly(true);
        Message('markiert: \%1', COUNT);
        MarkedOnly(false);
        ClearMarks();
        */

        ScenarioDimensionLine_LT.Reset();
        CurrPage.SetSelectionFilter(ScenarioDimensionLine_LT);
        ScenarioDimensionLine_LT.CopyFilters(Rec);
        ScenarioDimensionLine_LT.MarkedOnly(true);
        //Message('markiert: \%1', ScenarioDimensionLine_LT.Count());

        ScenarioDimensionLine_LT.SetRange(Active, false);
        if ScenarioDimensionLine_LT.IsEmpty() then begin
            //### es sind bereits alle markierten Zeilen aktiv: alle markierten inaktiv schalten
            ScenarioDimensionLine_LT.SetRange(Active);
            ScenarioDimensionLine_LT.ModifyAll(Percentage, 0);
            ScenarioDimensionLine_LT.ModifyAll(Active, false);
        end else begin
            //### es sind noch nicht alle markierten Zeilen aktiv: alle markierten Zeilen aktiv schalten
            ScenarioDimensionLine_LT.SetRange(Active);
            ScenarioDimensionLine_LT.ModifyAll(Active, true);
        end;

        ScenarioDimensionLine_LT.MarkedOnly(false);
        ScenarioDimensionLine_LT.ClearMarks();

        //### Prozente neu berechnen:
        ScenarioDimensionLine_LT.SetCurrentKey(Active);
        ScenarioDimensionLine_LT.SetRange(Active, true);
        ScenarioDimensionLine_LT.CalcSums(Weight);
        WeightTotal_L := ScenarioDimensionLine_LT.Weight;
        if ScenarioDimensionLine_LT.Find('-') then
            repeat
                if WeightTotal_L = 0 then
                    ScenarioDimensionLine_LT.Percentage := 0
                else
                    ScenarioDimensionLine_LT.Percentage := ScenarioDimensionLine_LT.Weight / WeightTotal_L * 100;
                ScenarioDimensionLine_LT.Modify();
            until ScenarioDimensionLine_LT.Next() = 0;

    end;
}

