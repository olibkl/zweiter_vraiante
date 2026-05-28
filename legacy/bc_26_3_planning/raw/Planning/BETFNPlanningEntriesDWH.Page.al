/// <summary>
/// [planning]
/// Modules: 
/// </summary>
page 5138633 "BET FN Planning Entries DWH"
{
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Planning Entries (DWH)';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "BET FN Planning Entry (DWH)";
    Extensible = true;

    layout
    {
        area(Content)
        {
            repeater(Control1117300000)
            {
                ShowCaption = false;
                field("Entry No."; Rec."Entry No.")
                {
                }
                field("Planning Document No."; Rec."Planning Document No.")
                {
                }
                field("Planning Type"; Rec."Planning Type")
                {
                }
                field("Planning Version"; Rec."Planning Version")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field(Division; Rec.Division)
                {
                }
                field("Main Waregroup"; Rec."Main Waregroup")
                {
                }
                field("Item Category"; Rec."Item Category")
                {
                }
                field("Location Code"; Rec."Location Code")
                {
                }
                field(Brand; Rec.Brand)
                {
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                }
                field(Season; Rec.Season)
                {
                }
                field("Plan Qty. Closing Inv."; Rec."Plan Qty. Closing Inv.")
                {
                }
                field("Plan Qty. Purchase"; Rec."Plan Qty. Purchase")
                {
                }
                field("Plan Qty. Sale"; Rec."Plan Qty. Sale")
                {
                }
                field("Plan Cost Closing Inv."; Rec."Plan Cost Closing Inv.")
                {
                    DecimalPlaces = 0 : 0;
                }
                field("Plan Cost Am. Purchase"; Rec."Plan Cost Am. Purchase")
                {
                    DecimalPlaces = 0 : 0;
                }
                field("Plan Cost of Sales"; Rec."Plan Cost of Sales")
                {
                    DecimalPlaces = 0 : 0;
                }
                field("Plan Sales Closing Inv."; Rec."Plan Sales Closing Inv.")
                {
                    DecimalPlaces = 0 : 0;
                }
                field("Plan Sales Am. Purchase"; Rec."Plan Sales Am. Purchase")
                {
                    DecimalPlaces = 0 : 0;
                }
                field("Plan Sales Amount"; Rec."Plan Sales Amount")
                {
                    DecimalPlaces = 0 : 0;
                }
                field("Plan Sales Amount Net"; Rec."Plan Sales Amount Net")
                {
                }
                field("Plan Sal. Am. Discount"; Rec."Plan Sal. Am. Discount")
                {
                }
                field("Plan Gross Sales Pr. Reduction"; Rec."Plan Gross Sales Pr. Reduction")
                {
                }
                field("Customer No."; Rec."Customer No.")
                {
                    Visible = false;
                }
                field(Agent; Rec.Agent)
                {
                    Visible = false;
                }
                field("Location Group"; Rec."Location Group")
                {
                    Visible = false;
                }
                field("Item No."; Rec."Item No.")
                {
                    Visible = false;
                }
                field("Price Class"; Rec."Price Class")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(PlanningStatistic)
            {
                Caption = 'Planning Statistic';
                ToolTip = 'Planning Statistic';
                Image = Statistics;
                RunObject = page "BET FN Planning Statistic Card";
            }
            action(PlanningAnalysis)
            {
                Caption = 'Planning Results';
                ToolTip = 'Planning Results';
                Image = AnalysisView;
                RunObject = page "BET FN Planning Entry Analysis";
            }
        }
        area(Promoted)
        {
            group(Category_Report)
            {
                Caption = 'Reports';

                actionref(PlanningStatistic_Promoted; PlanningStatistic)
                {
                }
                actionref(PlanningAnalysis_Promoted; PlanningAnalysis)
                {
                }
            }
        }
    }
}

