/// <summary>
/// [planning]
/// Modules: 
/// </summary>
page 5138638 "BET FN Planning Setup"
{
    ApplicationArea = All;
    Caption = 'Planning Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "BET FN Planning Setup";
    UsageCategory = Administration;
    DataCaptionExpression = '';
    Extensible = true;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("No. Series"; Rec."No. Series")
                {
                    TableRelation = "No. Series";
                }
                field("No. of Records for Warning"; Rec."No. of Records for Warning")
                {
                }
                field("Default Layout Template"; Rec."Default Layout Template")
                {
                }
                field("Auto Filter On Level Changing"; Rec."Auto Filter On Level Changing")
                {
                }
                field("Show Fixed Column"; Rec."Show Fixed Column")
                {
                }
                field("Dateformula Outst. Orders"; Rec."Dateformula Outst. Orders")
                {
                }
                field("Show Line Information"; Rec."Show Line Information")
                {
                }
            }
            group(Export)
            {
                Caption = 'Export';
                field("Check For Unsaved Lines"; Rec."Check For Unsaved Lines")
                {
                }
                field("Export Table No."; Rec."Export Table No.")
                {
                }
                field("Date Field in Export Table"; Rec."Date Field in Export Table")
                {
                }
                field("PK Field in Export Table"; Rec."PK Field in Export Table")
                {
                }
                field("Doc. No. Field in Export Table"; Rec."Doc. No. Field in Export Table")
                {
                }
                field("Export Season"; Rec."Export Season")
                {
                }
                field("Season Field in Export Table"; Rec."Season Field in Export Table")
                {
                }
            }
            group("Dimension Assignments")
            {
                Caption = 'Dimension Assignments';
                field("Dimension Assignment 1"; Rec."Dimension Assignment 1")
                {
                }
                field("Dimension Assignment 2"; Rec."Dimension Assignment 2")
                {
                }
                field("Dimension Assignment 3"; Rec."Dimension Assignment 3")
                {
                }
                field("Dimension Assignment 4"; Rec."Dimension Assignment 4")
                {
                }
            }
            group("OTB Levels:")
            {
                Caption = 'OTB Levels';
                field("OTB Level 1"; Rec."OTB Level 1")
                {
                    ToolTip = 'Specifies the OTB Level 1.';
                }
                field("OTB Level 2"; Rec."OTB Level 2")
                {
                    ToolTip = 'Specifies the OTB Level 2.';
                }
                field("OTB Level 3"; Rec."OTB Level 3")
                {
                    ToolTip = 'Specifies the OTB Level 3.';
                }
                field("OTB Level 4"; Rec."OTB Level 4")
                {
                    ToolTip = 'Specifies the OTB Level 4.';
                }
            }
            group(Update)
            {
                Caption = 'Update';
                Visible = false;

            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(UpdateStatistic)
            {
                Caption = 'Update Statistic Table';
                ToolTip = 'Update Statistic Table';
                Image = CalculateLines;

                trigger OnAction()
                var
                    BETFNPlanningCreateStat: Codeunit "BET FN Planning Create Stat.";
                begin
                    BETFNPlanningCreateStat.CreateStatistics(true);
                end;
            }
            action(InitPlanningSetup)
            {
                Caption = 'Init Planning Setup';
                ToolTip = 'Init Planning Setup';
                Image = Setup;

                trigger OnAction()
                var
                    BETFNInitPlanningSetup: Codeunit "BET FN Init Planning Setup";
                begin
                    BETFNInitPlanningSetup.Run();
                end;
            }
        }
    }
}