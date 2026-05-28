/// <summary>
/// 
/// 
/// Modules: [planning]
/// </summary>
page 5138639 "BET FN Planning Layout Tmplt"
{
    UsageCategory = None;
    Caption = 'Planning Layout Template';
    PageType = Card;
    SourceTable = "BET FN Planning Layout Tmplt";
    ApplicationArea = All;
    Extensible = true;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("Code"; Rec.Code)
                {
                }
                field(Description; Rec.Description)
                {
                }
            }
            group("Planning Values")
            {
                Caption = 'Planning Values';
                group("Plan Sales Values")
                {
                    Caption = 'Plan Sales Values';
                    field("Plan Sales Amount"; Rec."Plan Sales Amount")
                    {
                    }
                    field("Plan Sal. Am. incl. Discount"; Rec."Plan Sal. Am. incl. Discount")
                    {
                    }
                    field("Plan Sales Percentage"; Rec."Plan Sales Percentage")
                    {
                    }
                    field("Plan Sales Discount"; Rec."Plan Sales Discount")
                    {
                    }
                    field("Plan Sales Discount %"; Rec."Plan Sales Discount %")
                    {
                    }
                    field("Plan Sal. Am. Difference %"; Rec."Plan Sal. Am. Difference %")
                    {
                    }
                    field("Plan Sales Init. Inv."; Rec."Plan Sales Init. Inv.")
                    {
                    }
                    field("Plan Sales Closing Inv."; Rec."Plan Sales Closing Inv.")
                    {
                    }
                    field("Plan Sales Inv. Change"; Rec."Plan Sales Inv. Change")
                    {
                    }
                    field("Plan Gross Sales Pr. Reduction"; Rec."Plan Gross Sales Pr. Reduction")
                    {
                    }
                    field("Plan Sales Am. Purchase"; Rec."Plan Sales Am. Purchase")
                    {
                    }
                    field("Plan Sales Avg. Inv."; Rec."Plan Sales Avg. Inv.")
                    {
                    }
                    field("Plan Sales Order Amount"; Rec."Plan Sales Order Amount")
                    {
                    }
                }
                group("Plan Purchase Values")
                {
                    Caption = 'Plan Purchase Values';
                    field("Plan Cost of Sales"; Rec."Plan Cost of Sales")
                    {
                    }
                    field("Plan Cost of Sales %"; Rec."Plan Cost of Sales %")
                    {
                    }
                    field("Plan Cost Init. Inv."; Rec."Plan Cost Init. Inv.")
                    {
                    }
                    field("Plan Cost Closing Inv."; Rec."Plan Cost Closing Inv.")
                    {
                    }
                    field("Plan Cost Inv. Change"; Rec."Plan Cost Inv. Change")
                    {
                    }
                    field("Plan Cost Am. Purchase"; Rec."Plan Cost Am. Purchase")
                    {
                    }
                    field("Plan Cost Avg. Inv."; Rec."Plan Cost Avg. Inv.")
                    {
                    }
                    field("Plan Cost Am. Purch. 1-5"; Rec."Plan Cost Am. Purch. 1-5")
                    {
                    }
                }
                group("Plan Quantities")
                {
                    Caption = 'Plan Quantities';
                    field("Plan Qty. Sale"; Rec."Plan Qty. Sale")
                    {
                    }
                    field("Plan Qty. Sale Diff. %"; Rec."Plan Qty. Sale Diff. %")
                    {
                    }
                    field("Plan Qty. Init. Inv."; Rec."Plan Qty. Init. Inv.")
                    {
                    }
                    field("Plan Qty. Closing Inv."; Rec."Plan Qty. Closing Inv.")
                    {
                    }
                    field("Plan Qty. Inv. Change"; Rec."Plan Qty. Inv. Change")
                    {
                    }
                    field("Plan Qty. Closing Inv. %"; Rec."Plan Qty. Closing Inv. %")
                    {
                    }
                    field("Plan Qty. Purchase"; Rec."Plan Qty. Purchase")
                    {
                    }
                    field("Plan Qty. Avg. Inv."; Rec."Plan Qty. Avg. Inv.")
                    {
                    }
                    field("Plan Sales Order Qty."; Rec."Plan Sales Order Qty.")
                    {
                    }
                }
                group("Plan Avg. Prices")
                {
                    Caption = 'Plan Avg. Prices';
                    field("Plan S.Price Sales"; Rec."Plan S.Price Sales")
                    {
                    }
                    field("Plan S.Price incl. Discount"; Rec."Plan S.Price incl. Discount")
                    {
                    }
                    field("Plan S.Price Purchase"; Rec."Plan S.Price Purchase")
                    {
                    }
                    field("Plan S.Price Init. Inv."; Rec."Plan S.Price Init. Inv.")
                    {
                    }
                    field("Plan S.Price Closing Inv."; Rec."Plan S.Price Closing Inv.")
                    {
                    }
                    field("Plan P.Price Sales"; Rec."Plan P.Price Sales")
                    {
                    }
                    field("Plan P.Price Purchase"; Rec."Plan P.Price Purchase")
                    {
                    }
                    field("Plan P.Price Init. Inv."; Rec."Plan P.Price Init. Inv.")
                    {
                    }
                    field("Plan P.Price Closing Inv."; Rec."Plan P.Price Closing Inv.")
                    {
                    }
                }
                group("Plan Calculations")
                {
                    Caption = 'Plan Calculations';
                    field("Plan Inv. Turnover"; Rec."Plan Inv. Turnover")
                    {
                    }
                    field("Plan Calc. Sales %"; Rec."Plan Calc. Sales %")
                    {
                    }
                    field("Plan Calc. Sales incl. Disc. %"; Rec."Plan Calc. Sales incl. Disc. %")
                    {
                    }
                    field("Plan Calc. Purchase %"; Rec."Plan Calc. Purchase %")
                    {
                    }
                    field("Plan Calc. Init. Inv. %"; Rec."Plan Calc. Init. Inv. %")
                    {
                    }
                    field("Plan Calc. Closing Inv. %"; Rec."Plan Calc. Closing Inv. %")
                    {
                    }
                }
            }
            group("Reference Values")
            {
                Caption = 'Reference Values';
                group("Reference Sales Values")
                {
                    Caption = 'Reference Sales Values';
                    field("Ref. Sales Amount"; Rec."Ref. Sales Amount")
                    {
                    }
                    field("Ref. Sal. Am. incl. Discount"; Rec."Ref. Sal. Am. incl. Discount")
                    {
                    }
                    field("Ref. Sales Percentage"; Rec."Ref. Sales Percentage")
                    {
                    }
                    field("Ref. Sales Discount"; Rec."Ref. Sales Discount")
                    {
                    }
                    field("Ref. Sales Discount %"; Rec."Ref. Sales Discount %")
                    {
                    }
                    field("Ref. Sales Init. Inv."; Rec."Ref. Sales Init. Inv.")
                    {
                    }
                    field("Ref. Sales Closing Inv."; Rec."Ref. Sales Closing Inv.")
                    {
                    }
                    field("Ref. Sales Inv. Change"; Rec."Ref. Sales Inv. Change")
                    {
                    }
                    field("Ref. Gross Sales Pr. Reduction"; Rec."Ref. Gross Sales Pr. Reduction")
                    {
                    }
                    field("Ref. Sales Am. Purchase"; Rec."Ref. Sales Am. Purchase")
                    {
                    }
                    field("Ref. Sales Avg. Inv."; Rec."Ref. Sales Avg. Inv.")
                    {
                    }
                    field("Ref. Sales Order Amount"; Rec."Ref. Sales Order Amount")
                    {
                    }
                }
                group("Reference Purchase Values")
                {
                    Caption = 'Reference Purchase Values';
                    field("Ref. Cost of Sales"; Rec."Ref. Cost of Sales")
                    {
                    }
                    field("Ref. Cost Init. Inv."; Rec."Ref. Cost Init. Inv.")
                    {
                    }
                    field("Ref. Cost Closing Inv."; Rec."Ref. Cost Closing Inv.")
                    {
                    }
                    field("Ref. Cost Inv. Change"; Rec."Ref. Cost Inv. Change")
                    {
                    }
                    field("Ref. Cost Val. Purchase"; Rec."Ref. Cost Val. Purchase")
                    {
                    }
                    field("Ref. Cost Avg. Inv."; Rec."Ref. Cost Avg. Inv.")
                    {
                    }
                }
                group("Reference Quantities")
                {
                    Caption = 'Reference Quantities';
                    field("Ref. Qty. Sale"; Rec."Ref. Qty. Sale")
                    {
                    }
                    field("Ref. Qty. Init. Inv."; Rec."Ref. Qty. Init. Inv.")
                    {
                    }
                    field("Ref. Qty. Closing Inv."; Rec."Ref. Qty. Closing Inv.")
                    {
                    }
                    field("Ref. Qty. Inv. Change"; Rec."Ref. Qty. Inv. Change")
                    {
                    }
                    field("Ref. Qty. Closing Inv. %"; Rec."Ref. Qty. Closing Inv. %")
                    {
                    }
                    field("Ref. Qty. Purchase"; Rec."Ref. Qty. Purchase")
                    {
                    }
                    field("Ref. Qty. Avg. Inv."; Rec."Ref. Qty. Avg. Inv.")
                    {
                    }
                    field("Ref. Sales Order Qty."; Rec."Ref. Sales Order Qty.")
                    {
                    }
                }
                group("Reference Avg. Prices")
                {
                    Caption = 'Reference Avg. Prices';
                    field("Ref. S.Price Sales"; Rec."Ref. S.Price Sales")
                    {
                    }
                    field("Ref. S.Price incl. Discount"; Rec."Ref. S.Price incl. Discount")
                    {
                    }
                    field("Ref. S.Price Purchase"; Rec."Ref. S.Price Purchase")
                    {
                    }
                    field("Ref. S.Price Init. Inv."; Rec."Ref. S.Price Init. Inv.")
                    {
                    }
                    field("Ref. S.Price Closing Inv."; Rec."Ref. S.Price Closing Inv.")
                    {
                    }
                    field("Ref. P.Price Sales"; Rec."Ref. P.Price Sales")
                    {
                    }
                    field("Ref. P.Price Purchase"; Rec."Ref. P.Price Purchase")
                    {
                    }
                    field("Ref. P.Price Init. Inv."; Rec."Ref. P.Price Init. Inv.")
                    {
                    }
                    field("Ref. P.Price Closing Inv."; Rec."Ref. P.Price Closing Inv.")
                    {
                    }
                }
                group("Reference Calculations")
                {
                    Caption = 'Reference Calculations';
                    field("Ref. Inv. Turnover"; Rec."Ref. Inv. Turnover")
                    {
                    }
                    field("Ref. Calc. Sales %"; Rec."Ref. Calc. Sales %")
                    {
                    }
                    field("Ref. Calc. Sales incl. Disc. %"; Rec."Ref. Calc. Sales incl. Disc. %")
                    {
                    }
                    field("Ref. Calc. Purchase %"; Rec."Ref. Calc. Purchase %")
                    {
                    }
                    field("Ref. Calc. Init. Inv. %"; Rec."Ref. Calc. Init. Inv. %")
                    {
                    }
                    field("Ref. Calc. Closing Inv. %"; Rec."Ref. Calc. Closing Inv. %")
                    {
                    }
                }
            }
            group("Planning Target")
            {
                Caption = 'Planning Target';
                group("Target Sales Values")
                {
                    Caption = 'Target Sales Values';
                    field("Plan Target Sales Amount"; Rec."Plan Target Sales Amount")
                    {
                    }
                    field("Plan Target Sales Discount"; Rec."Plan Target Sales Discount")
                    {
                    }
                    field("Plan Target G.S.P. Reduction"; Rec."Plan Target G.S.P. Reduction")
                    {
                    }
                    field("Plan Target Sal. Am. Purch."; Rec."Plan Target Sal. Am. Purch.")
                    {
                    }
                    field("Plan Target Sales Init. Inv."; Rec."Plan Target Sales Init. Inv.")
                    {
                    }
                    field("Plan Target Sales Closing Inv."; Rec."Plan Target Sales Closing Inv.")
                    {
                    }
                }
                group("Target Purchase Values")
                {
                    Caption = 'Target Purchase Values';
                    field("Plan Target Cost of Sales"; Rec."Plan Target Cost of Sales")
                    {
                    }
                    field("Plan Target Cost Am. Purch."; Rec."Plan Target Cost Am. Purch.")
                    {
                    }
                    field("Plan Target Cost Init. Inv."; Rec."Plan Target Cost Init. Inv.")
                    {
                    }
                    field("Plan Target Cost Closing Inv."; Rec."Plan Target Cost Closing Inv.")
                    {
                    }
                }
                group("Target Quantity")
                {
                    Caption = 'Target Quantity';
                    field("Plan Target Qty. Sale"; Rec."Plan Target Qty. Sale")
                    {
                    }
                    field("Plan Target Qty. Purchase"; Rec."Plan Target Qty. Purchase")
                    {
                    }
                    field("Plan Target Qty. Init. Inv."; Rec."Plan Target Qty. Init. Inv.")
                    {
                    }
                    field("Plan Target Qty. Closing Inv."; Rec."Plan Target Qty. Closing Inv.")
                    {
                    }
                }
            }
            group("Actual Values")
            {
                Caption = 'Actual Values';
                group("Free Limit")
                {
                    Caption = 'Free Limit';
                    field("Free Sales Limit"; Rec."Free Sales Limit")
                    {
                    }
                    field("Free Purchase Limit"; Rec."Free Purchase Limit")
                    {
                    }
                }
                group("Actual Sales Values")
                {
                    Caption = 'Actual Sales Values';
                    field("Actual Sales Amount"; Rec."Actual Sales Amount")
                    {
                    }
                    field("Actual Sales Discount"; Rec."Actual Sales Discount")
                    {
                    }
                    field("Actual Gross Sales Pr. Red."; Rec."Actual Gross Sales Pr. Red.")
                    {
                    }
                    field("Actual Sales Am. Purchase"; Rec."Actual Sales Am. Purchase")
                    {
                    }
                    field("Actual Sales Init. Inv."; Rec."Actual Sales Init. Inv.")
                    {
                    }
                    field("Actual Sales Closing Inv."; Rec."Actual Sales Closing Inv.")
                    {
                    }
                }
                group("Actual Purchase Values")
                {
                    Caption = 'Actual Purchase Values';
                    field("Actual Cost of Sales"; Rec."Actual Cost of Sales")
                    {
                    }
                    field("Actual Cost Am. Purchase"; Rec."Actual Cost Am. Purchase")
                    {
                    }
                    field("Actual Cost Init. Inv."; Rec."Actual Cost Init. Inv.")
                    {
                    }
                    field("Actual Cost Closing Inv."; Rec."Actual Cost Closing Inv.")
                    {
                    }
                }
                group("Actual Quantity")
                {
                    Caption = 'Actual Quantity';
                    field("Actual Qty. Sale"; Rec."Actual Qty. Sale")
                    {
                    }
                    field("Actual Qty. Purchase"; Rec."Actual Qty. Purchase")
                    {
                    }
                    field("Actual Qty. Init. Inv."; Rec."Actual Qty. Init. Inv.")
                    {
                    }
                    field("Actual Qty. Closing Inv."; Rec."Actual Qty. Closing Inv.")
                    {
                    }
                }
                group("offene Bestellungen")
                {
                    Caption = 'offene Bestellungen';
                    field("Purch. Order Outst. Amt."; Rec."Purch. Order Outst. Amt.")
                    {
                    }
                    field("Purch. Order Outst. Amt. Net."; Rec."Purch. Order Outst. Amt. Net.")
                    {
                    }
                    field("Purch. Order Outst. Qty."; Rec."Purch. Order Outst. Qty.")
                    {
                    }
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
        }
    }
}

