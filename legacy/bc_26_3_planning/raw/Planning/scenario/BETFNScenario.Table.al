/// <summary>
/// [scenario]
/// Modules: 
/// </summary>
table 5138656 "BET FN Scenario"
{
    Caption = 'Scenario';
    DataClassification = CustomerContent;
    LookupPageId = "BET FN Scenario List";
    DrillDownPageId = "BET FN Scenario List";
    Access = Public;
    Extensible = true;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
            ToolTip = 'Specifies the Code.';
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
            ToolTip = 'Specifies the Description.';
        }
        field(3; Active; Boolean)
        {
            Caption = 'Active';
            ToolTip = 'Specifies the Active.';
        }
        field(10; "Start Date"; Date)
        {
            Caption = 'Start Date';
            ToolTip = 'Specifies the Start Date.';
            trigger OnValidate()
            begin
                "Start Date" := CalcDate('<-CM>', "Start Date");
                InsertDateLine();
            end;
        }
        field(11; "End Date"; Date)
        {
            Caption = 'End Date';
            ToolTip = 'Specifies the End Date.';
            trigger OnValidate()
            begin
                "End Date" := CalcDate('<+CM>', "End Date");
                InsertDateLine();
            end;
        }
        field(60; "Real. Sal. Am. per Year"; Decimal)
        {
            Caption = 'Real. Sal. Am. per Year';
            ToolTip = 'Specifies the Real. Sal. Am. per Year.';
            trigger OnValidate()
            begin
                CalcValues();
            end;
        }
        field(61; "Opening Stock"; Decimal)
        {
            Caption = 'Opening Stock';
            ToolTip = 'Specifies the Opening Stock.';
            trigger OnValidate()
            begin
                CalcValues();
            end;
        }
        field(62; Deduction; Decimal)
        {
            Caption = 'Deduction';
            ToolTip = 'Specifies the Deduction.';
            trigger OnValidate()
            begin
                CalcValues();
            end;
        }
        field(63; "Purchase Value Gross"; Decimal)
        {
            Caption = 'Purchase Value Gross';
            ToolTip = 'Specifies the Purchase Value Gross.';
        }
        field(64; "Closing Stock"; Decimal)
        {
            Caption = 'Closing Stock';
            ToolTip = 'Specifies the Closing Stock.';
            trigger OnValidate()
            begin
                CalcValues();
            end;
        }
        field(65; "Closing Stock Rate"; Decimal)
        {
            Caption = 'Closing Stock Rate';
            ToolTip = 'Specifies the Closing Stock Rate.';
            trigger OnValidate()
            begin
                "Closing Stock" := "Real. Sal. Am. per Year" / 100 * "Closing Stock Rate";
                CalcValues();
            end;
        }
        field(66; Discount; Decimal)
        {
            Caption = 'Discount';
            ToolTip = 'Specifies the Discount.';
            trigger OnValidate()
            begin
                CalcValues();
            end;
        }
        field(70; "Calculation (act.)"; Decimal)
        {
            Caption = 'Calculation';
            ToolTip = 'Specifies the Calculation (act.).';
        }
        field(71; "Calculation (WR)"; Decimal)
        {
            Caption = 'Calculation (WR)';
        }
        field(100; Fluctuation; Decimal)
        {
            Caption = 'Fluctuation';
            ToolTip = 'Specifies the Fluctuation.';
        }
        field(101; "Purch. Val. in Purch. Order %"; Decimal)
        {
            Caption = 'Purch. Val. in Purch. Order %';
            ToolTip = 'Specifies the Purch. Val. in Purch. Order %.';
        }
        field(102; "VAT %"; Decimal)
        {
            Caption = 'MwSt. %';
            ToolTip = 'Specifies the VAT %.';
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        ScenarioDimension_LT: Record "BET FN Scenario Dimension";
        ScenarioDimLine_LT: Record "BET FN Scenario Dimension Line";
    begin
        ScenarioDimension_LT.Reset();
        ScenarioDimension_LT.SetRange("Scenario Code", Code);
        ScenarioDimension_LT.DeleteAll();

        ScenarioDimLine_LT.Reset();
        ScenarioDimLine_LT.SetRange("Scenario Code", Code);
        ScenarioDimLine_LT.DeleteAll();
    end;

    trigger OnInsert()
    begin
        if Code = '' then
            exit;
    end;

    procedure InsertDateLine()
    var
        ScenarioDimension_LT: Record "BET FN Scenario Dimension";
        ScenarioDimLine_LT: Record "BET FN Scenario Dimension Line";
        Date_LT: Record Date;
        ScenarioMgmt_LC: Codeunit "BET FN Scenario Mgt";
        SortingNo_L: Integer;
        DateText_L: Text[30];
    begin
        if ("Start Date" <> 0D) and
           ("End Date" <> 0D) and
           ("Start Date" < "End Date") then begin
            //### Dimension Datum (Monat) erstellen:
            ScenarioDimension_LT.Reset();
            ScenarioDimension_LT.SetRange("Scenario Code", Code);
            ScenarioDimension_LT.SetRange(Dateline, true);
            if ScenarioDimension_LT.IsEmpty() then begin
                ScenarioDimension_LT.Init();
                ScenarioDimension_LT."Scenario Code" := Code;
                ScenarioDimension_LT.Dateline := true;
                ScenarioDimension_LT.Code := 'DATUM';
                ScenarioDimension_LT.Description := 'Monate';
                ScenarioDimension_LT.Insert();
            end else begin
                //### Dimension Datum/Monat existiert bereits; bei Änderung der Monate:
                ScenarioDimLine_LT.Reset();
                ScenarioDimLine_LT.SetRange("Scenario Code", Code);
                ScenarioDimLine_LT.SetRange("Dimension Code", 'DATUM');
                ScenarioDimLine_LT.DeleteAll();
            end;

            //### zugehörige Dimensionszeilen (einzelne Monate) erstellen:
            ScenarioDimLine_LT.Init();
            ScenarioDimLine_LT."Scenario Code" := Code;
            ScenarioDimLine_LT."Dimension Code" := 'DATUM';
            Date_LT.Reset();
            Date_LT.SetRange("Period Type", Date_LT."Period Type"::Month);
            Date_LT.SetRange("Period Start", "Start Date", "End Date");
            if Date_LT.Find('-') then begin
                SortingNo_L := 0;
                repeat
                    SortingNo_L += 1;
                    DateText_L := CopyStr(Date_LT."Period Name" + ' ' + Format(Date2DMY(Date_LT."Period Start", 3)), 1, 30);
                    ScenarioDimLine_LT.Code := Format(Date_LT."Period Start");
                    ScenarioDimLine_LT.Description := DateText_L;
                    ScenarioDimLine_LT.Active := true;

                    //### Vorbelegung der einzelnen Monate mit Gewichtung:
                    ScenarioDimLine_LT.Weight := ScenarioMgmt_LC.InitPercentPerMonthFSE(Date_LT."Period No.");
                    ScenarioDimLine_LT.Percentage := ScenarioDimLine_LT.Weight;

                    ScenarioDimLine_LT."Sorting No." := SortingNo_L;
                    ScenarioDimLine_LT.Insert();
                until Date_LT.Next() = 0;
            end;
        end;
    end;

    procedure CalcValues()
    begin
        if "Real. Sal. Am. per Year" <> 0 then
            "Closing Stock Rate" := "Closing Stock" / "Real. Sal. Am. per Year" * 100
        else
            "Closing Stock Rate" := 0;

        //### Wareneinsatz aus AB, Umsatz, Abschrift und EB ermitteln:
        // WE := EB - AB + U + A
        "Purchase Value Gross" := "Closing Stock" - "Opening Stock" + "Real. Sal. Am. per Year" + Deduction + Discount;
    end;
}

