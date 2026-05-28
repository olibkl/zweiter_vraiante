/// <summary>
/// [planning]
/// Modules: 
/// </summary>
page 5138637 "BET FN Planning Layout Tmplts"
{
    ApplicationArea = All;
    Caption = 'Planning Layout Templates';
    CardPageId = "BET FN Planning Layout Tmplt";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "BET FN Planning Layout Tmplt";
    UsageCategory = Lists;
    Extensible = true;

    layout
    {
        area(Content)
        {
            repeater(Control1117300000)
            {
                ShowCaption = false;
                field("Code"; Rec.Code)
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Plan Sales Amount"; Rec."Plan Sales Amount")
                {
                }
                field("Plan Sal. Am. Difference %"; Rec."Plan Sal. Am. Difference %")
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
    }

    actions
    {
    }
}

