/// <summary>
/// [planning]
/// Modules: 
/// </summary>
page 5138666 "BET FN Planning Entry Analysis"
{
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Planning Entry Analysis';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Worksheet;
    SourceTable = "BET FN Planning Ent Info Temp";
    SourceTableTemporary = true;
    SourceTableView = sorting(Level1, Level2, Level3, Level4);
    Extensible = true;

    layout
    {
        area(Content)
        {
            group(Levels)
            {
                Caption = 'Levels';
                field(SetupLevel1; PlanSetup_GT."OTB Level 1")
                {
                    Caption = 'Level1';
                    TableRelation = "BET FN Planning Level"."Index Code" where(Activated = const(true));

                    trigger OnValidate()
                    begin
                        UpdatePlanSetup(1);
                    end;
                }
                field(SetupLevel2; PlanSetup_GT."OTB Level 2")
                {
                    Caption = 'Level2';
                    TableRelation = "BET FN Planning Level"."Index Code" where(Activated = const(true));

                    trigger OnValidate()
                    begin
                        UpdatePlanSetup(2);
                    end;
                }
                field(SetupLevel3; PlanSetup_GT."OTB Level 3")
                {
                    Caption = 'Level3';
                    TableRelation = "BET FN Planning Level"."Index Code" where(Activated = const(true));

                    trigger OnValidate()
                    begin
                        UpdatePlanSetup(3);
                    end;
                }
                field(SetupLevel4; PlanSetup_GT."OTB Level 4")
                {
                    Caption = 'Level4';
                    TableRelation = "BET FN Planning Level"."Index Code" where(Activated = const(true));

                    trigger OnValidate()
                    begin
                        UpdatePlanSetup(4);
                    end;
                }
            }
            group("Filter")
            {
                Caption = 'Filter';
                field(DateFilter; FilterArray_G[1])
                {
                    ToolTip = 'Specifies the DateFilter.';
                    Caption = 'Date Filter';
                }
                field(LocFilter; FilterArray_G[2])
                {
                    ToolTip = 'Specifies the LocFilter.';
                    Caption = 'Location Filter';
                    TableRelation = Location;
                }
                field(ItemCatFilter; FilterArray_G[3])
                {
                    ToolTip = 'Specifies the ItemCatFilter.';
                    Caption = 'Item Category Filter';
                    TableRelation = "Item Category";
                }
                field(MainWGFilter; FilterArray_G[4])
                {
                    ToolTip = 'Specifies the MainWGFilter.';
                    Caption = 'Main Waregroup Filter';
                    TableRelation = "BET FN Main Waregroup";
                    Visible = false;
                }
                field(DivisionFilter; FilterArray_G[5])
                {
                    ToolTip = 'Specifies the DivisionFilter.';
                    Caption = 'Division Filter';
                    TableRelation = "BET FN Division";
                    Visible = false;
                }
                field(BrandFilter; FilterArray_G[6])
                {
                    ToolTip = 'Specifies the BrandFilter.';
                    Caption = 'Brand Filter';
                    TableRelation = "BET FN Brand";
                    Visible = false;
                }
                field(VendorFilter; FilterArray_G[7])
                {
                    ToolTip = 'Specifies the Vendor Filter.';
                    Caption = 'Vendor Filter';
                    TableRelation = Vendor;
                    Visible = false;
                }
                field(AgentFilter; FilterArray_G[8])
                {
                    ToolTip = 'Specifies the AgentFilter.';
                    Caption = 'Agent Filter';
                    TableRelation = "BET FN Agent";
                    Visible = false;
                }
                field(CustomerFilter; FilterArray_G[9])
                {
                    ToolTip = 'Specifies the CustomerFilter.';
                    Caption = 'Customer Filter';
                    TableRelation = Customer;
                    Visible = false;
                }
                field(SeasonFilter; FilterArray_G[10])
                {
                    ToolTip = 'Specifies the SeasonFilter.';
                    Caption = 'Season Filter';
                    TableRelation = "BET FN Season";
                    Visible = false;
                }
                field(FDim1Filter; FilterArray_G[11])
                {
                    ToolTip = 'Specifies the FDim1Filter.';
                    Caption = 'FDim1 Filter';
                    TableRelation = "BET FN Fashion Dimension 1";
                    Visible = false;
                }
                field(FDim2Filter; FilterArray_G[12])
                {
                    ToolTip = 'Specifies the FDim2Filter.';
                    Caption = 'FDim2 Filter';
                    TableRelation = "BET FN Fashion Dimension 2";
                    Visible = false;
                }
                field(FDim3Filter; FilterArray_G[13])
                {
                    ToolTip = 'Specifies the FDim3Filter.';
                    Caption = 'FDim3 Filter';
                    TableRelation = "BET FN Fashion Dimension 3";
                    Visible = false;
                }
                field(FDim4Filter; FilterArray_G[14])
                {
                    ToolTip = 'Specifies the FDim4Filter.';
                    Caption = 'FDim4 Filter';
                    TableRelation = "BET FN Fashion Dimension 4";
                    Visible = false;
                }
                field(FDim5Filter; FilterArray_G[15])
                {
                    ToolTip = 'Specifies the FDim5Filter.';
                    Caption = 'FDim5 Filter';
                    TableRelation = "BET FN Fashion Dimension 5";
                    Visible = false;
                }
                field(FDim6Filter; FilterArray_G[16])
                {
                    ToolTip = 'Specifies the FDim6Filter.';
                    Caption = 'FDim6 Filter';
                    TableRelation = "BET FN Fashion Dimension 6";
                    Visible = false;
                }
                field(FDim7Filter; FilterArray_G[17])
                {
                    ToolTip = 'Specifies the Fashion Dimension 7Filter.';
                    Caption = 'FDim7 Filter';
                    TableRelation = "BET FN Fashion Dimension 7";
                    Visible = false;
                }
                field(FDim8Filter; FilterArray_G[18])
                {
                    ToolTip = 'Specifies the Fashion Dimension 8Filter.';
                    Caption = 'FDim8 Filter';
                    TableRelation = "BET FN Fashion Dimension 8";
                    Visible = false;
                }
                field(FDim9Filter; FilterArray_G[19])
                {
                    ToolTip = 'Specifies the Fashion Dimension 9Filter.';
                    Caption = 'FDim9 Filter';
                    TableRelation = "BET FN Fashion Dimension 9";
                    Visible = false;
                }
                field(FDim10Filter; FilterArray_G[20])
                {
                    ToolTip = 'Specifies the Fashion Dimension 10Filter.';
                    Caption = 'FDim10 Filter';
                    TableRelation = "BET FN Fashion Dimension 10";
                    Visible = false;
                }
                field(HideEmptyLines; HideEmptyLines_G)
                {
                    ToolTip = 'Specifies the HideEmptyLines.';
                    Caption = 'Hide empty lines';
                }
                field(CreateByQuery; CreateByQuery_G)
                {
                    ToolTip = 'Specifies the CreateByQuery.';
                    Caption = 'Create by Query';
                }
            }
            repeater(Group)
            {
                Editable = false;
                IndentationColumn = Rec.Indentation;
                IndentationControls = Indentation, "Level 1 Description", "Level 2 Description", "Level 3 Description", "Level 4 Description";
                ShowAsTree = true;
                field(Indentation; Rec.Indentation)
                {
                    Caption = 'Level';
                    Editable = false;
                    Enabled = false;
                    HideValue = true;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    Visible = false;
                }
                field("Line Type"; Rec."Line Type")
                {
                    Visible = false;
                }
                field(Description; Rec.Description)
                {
                    StyleExpr = Style_G;
                }
                field("Level 1 Description"; Rec."Level 1 Description")
                {
                    Caption = 'Level 1';
                    StyleExpr = Style_G;
                    Visible = false;
                }
                field("Level 2 Description"; Rec."Level 2 Description")
                {
                    Caption = 'Level 2';
                    StyleExpr = Style_G;
                    Visible = false;
                }
                field("Level 3 Description"; Rec."Level 3 Description")
                {
                    Caption = 'Level 3';
                    StyleExpr = Style_G;
                    Visible = false;
                }
                field("Level 4 Description"; Rec."Level 4 Description")
                {
                    Caption = 'Level 4';
                    StyleExpr = Style_G;
                    Visible = false;
                }
                field(Level1; Rec.Level1)
                {
                    StyleExpr = Style_G;
                    Visible = false;
                }
                field(Level2; Rec.Level2)
                {
                    StyleExpr = Style_G;
                    Visible = false;
                }
                field(Level3; Rec.Level3)
                {
                    StyleExpr = Style_G;
                    Visible = false;
                }
                field(Level4; Rec.Level4)
                {
                    StyleExpr = Style_G;
                    Visible = false;
                }
                field("Plan Sales Amount"; Rec."Plan Sales Amount")
                {
                    DecimalPlaces = 0 : 0;
                    StyleExpr = Style_G;
                }
                field("Purchase Value Sales"; Rec."Purchase Value Sales")
                {
                    DecimalPlaces = 0 : 0;
                    StyleExpr = Style_G;
                }
                field("Purchase Value"; Rec."Purchase Value")
                {
                    DecimalPlaces = 0 : 0;
                    StyleExpr = Style_G;
                }
                field("Purchase Quantity"; Rec."Purchase Quantity")
                {
                    DecimalPlaces = 0 : 0;
                    StyleExpr = Style_G;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Calculate)
            {
                Caption = 'Calculate';
                ToolTip = 'Calculate';
                Image = Calculate;

                trigger OnAction()
                begin
                    CalculateValues();
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';

                actionref(Calculate_Promoted; Calculate)
                {
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        /*
        case "Line Type" of
          "Line Type"::Total : Style_G := 'StrongAccent';    //### Gesamt
          "Line Type"::L1 : Style_G := 'Favorable';           //### Ebene 1
          "Line Type"::L2 : Style_G := 'Strong';              //### Ebene 2
          "Line Type"::L3 : Style_G := 'StandardAccent';      //### Ebene 3
          "Line Type"::L4 : Style_G := 'None';                //### Ebene 4
        end;
        */

        case Rec."Line Type" of
            Rec."Line Type"::Total:
                Style_G := 'Favorable';    //### Gesamt
            Rec."Line Type"::L1:
                Style_G := 'StrongAccent';      //### Ebene 1
            Rec."Line Type"::L2:
                Style_G := 'StandardAccent';    //### Ebene 2
            Rec."Line Type"::L3:
                Style_G := 'Strong';      //### Ebene 3
            Rec."Line Type"::L4:
                Style_G := 'None';          //### Ebene 4
        end;

    end;

    trigger OnOpenPage()
    begin
        // TEST:
        //FilterArray_G[1] := '010115..311215';
        //FilterArray_G[2] := '2848..2860';

        PlanSetup_GT.Get();
    end;

    var
        PlanSetup_GT: Record "BET FN Planning Setup";
        CreateByQuery_G: Boolean;
        HideEmptyLines_G: Boolean;
        FilterArray_G: array[20] of Text;
        Style_G: Text;

    /// <summary>
    /// CalculateValues.
    /// </summary>
    procedure CalculateValues()
    var
        PlanningAnalysisMgt_LC: Codeunit "BET FN Planning Analysis Mgt";
    begin
        PlanningAnalysisMgt_LC.CreateTempPlanningEntryTable(Rec, FilterArray_G, HideEmptyLines_G, CreateByQuery_G);

        Rec.FindSet();
        CurrPage.Update(false);
    end;

    /// <summary>
    /// UpdatePlanSetup.
    /// </summary>
    /// <param name="Level_P">Integer.</param>
    procedure UpdatePlanSetup(Level_P: Integer)
    var
        PlanSetup_LT: Record "BET FN Planning Setup";
    begin
        PlanSetup_LT.Get();
        case Level_P of
            1:
                PlanSetup_LT.Validate("OTB Level 1", PlanSetup_GT."OTB Level 1");
            2:
                PlanSetup_LT.Validate("OTB Level 2", PlanSetup_GT."OTB Level 2");
            3:
                PlanSetup_LT.Validate("OTB Level 3", PlanSetup_GT."OTB Level 3");
            4:
                PlanSetup_LT.Validate("OTB Level 4", PlanSetup_GT."OTB Level 4");
        end;

        PlanSetup_LT.Modify();
    end;
}

