/// <summary>
/// [planning]
/// Modules: 
/// </summary>
table 5138639 "BET FN Planning Layout Tmplt"
{
    Caption = 'Planning Layout Template';
    DrillDownPageId = "BET FN Planning Layout Tmplts";
    LookupPageId = "BET FN Planning Layout Tmplts";
    DataClassification = CustomerContent;
    Access = Public;
    Extensible = true;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            ToolTip = 'Specifies the Code.';
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
            ToolTip = 'Specifies the Description.';
        }
        field(12010; "Plan Sales Amount"; Boolean)
        {
            Caption = 'Plan Sales Amount';
            ToolTip = 'Specifies the Plan Sales Amount.';
        }
        field(12011; "Plan Sal. Am. Difference %"; Boolean)
        {
            Caption = 'Plan Sal. Am. Difference %';
            ToolTip = 'Specifies the Plan Sal. Am. Difference %.';
        }
        field(12012; "Plan Sal. Am. incl. Discount"; Boolean)
        {
            Caption = 'Plan Sal. Am. incl. Discount';
            ToolTip = 'Specifies the Plan Sal. Am. incl. Discount.';
        }
        field(12013; "Plan Sales Percentage"; Boolean)
        {
            Caption = 'Plan Sales Percentage';
            ToolTip = 'Specifies the Plan Sales Percentage.';
        }
        field(12020; "Plan Sales Discount"; Boolean)
        {
            Caption = 'Plan Sales Discount';
            ToolTip = 'Specifies the Plan Sales Discount.';
        }
        field(12021; "Plan Sales Discount %"; Boolean)
        {
            Caption = 'Plan Sales Discount %';
            ToolTip = 'Specifies the Plan Sales Discount %.';
        }
        field(12030; "Plan Sales Init. Inv."; Boolean)
        {
            Caption = 'Plan Sales Init. Inv.';
            ToolTip = 'Specifies the Plan Sales Init. Inv.';
        }
        field(12031; "Plan Sales Closing Inv."; Boolean)
        {
            Caption = 'Plan Sales Closing Inv.';
            ToolTip = 'Specifies the Plan Sales Closing Inv.';
        }
        field(12032; "Plan Sales Inv. Change"; Boolean)
        {
            Caption = 'Plan Sales Inv. Change';
            ToolTip = 'Specifies the Plan Sales Inv. Change.';
        }
        field(12040; "Plan Gross Sales Pr. Reduction"; Boolean)
        {
            Caption = 'Plan Gross Sales Pr. Reduction';
            ToolTip = 'Specifies the Plan Gross Sales Pr. Reduction.';
        }
        field(12041; "Plan Gross Sales Pr. Red. %"; Boolean)
        {
            Caption = 'Plan Gross Sales Pr. Red. %';
        }
        field(12050; "Plan Sales Am. Purchase"; Boolean)
        {
            Caption = 'Plan Sales Am. Purchase';
            ToolTip = 'Specifies the Plan Sales Am. Purchase.';
        }
        field(12060; "Plan Sales Avg. Inv."; Boolean)
        {
            Caption = 'Plan Sales Avg. Inv.';
            ToolTip = 'Specifies the Plan Sales Avg. Inv.';
        }
        field(12110; "Plan Qty. Sale"; Boolean)
        {
            Caption = 'Plan Qty. Sale';
            ToolTip = 'Specifies the Plan Qty. Sale.';
        }
        field(12111; "Plan Qty. Sale Diff. %"; Boolean)
        {
            Caption = 'Plan Qty. Sale Diff. %';
            ToolTip = 'Specifies the Plan Qty. Sale Diff. %.';
        }
        field(12130; "Plan Qty. Init. Inv."; Boolean)
        {
            Caption = 'Plan Qty. Init. Inv.';
            ToolTip = 'Specifies the Plan Qty. Init. Inv.';
        }
        field(12131; "Plan Qty. Closing Inv."; Boolean)
        {
            Caption = 'Plan Qty. Closing Inv.';
            ToolTip = 'Specifies the Plan Qty. Closing Inv.';
        }
        field(12132; "Plan Qty. Inv. Change"; Boolean)
        {
            Caption = 'Plan Qty. Inv. Change';
            ToolTip = 'Specifies the Plan Qty. Inv. Change.';
        }
        field(12133; "Plan Qty. Closing Inv. %"; Boolean)
        {
            Caption = 'Plan Qty. Closing Inv. %';
            ToolTip = 'Specifies the Plan Qty. Closing Inv. %.';
        }
        field(12150; "Plan Qty. Purchase"; Boolean)
        {
            Caption = 'Plan Qty. Purchase';
            ToolTip = 'Specifies the Plan Qty. Purchase.';
        }
        field(12160; "Plan Qty. Avg. Inv."; Boolean)
        {
            Caption = 'Plan Qty. Avg. Inv.';
            ToolTip = 'Specifies the Plan Qty. Avg. Inv.';
        }
        field(12210; "Plan Cost of Sales"; Boolean)
        {
            Caption = 'Plan Cost of Sales';
            ToolTip = 'Specifies the Plan Cost of Sales.';
        }
        field(12211; "Plan Cost of Sales %"; Boolean)
        {
            Caption = 'Plan Cost of Sales %';
            ToolTip = 'Specifies the Plan Cost of Sales %.';
        }
        field(12230; "Plan Cost Init. Inv."; Boolean)
        {
            Caption = 'Plan Cost Init. Inv.';
            ToolTip = 'Specifies the Plan Cost Init. Inv.';
        }
        field(12231; "Plan Cost Closing Inv."; Boolean)
        {
            Caption = 'Plan Cost Closing Inv.';
            ToolTip = 'Specifies the Plan Cost Closing Inv.';
        }
        field(12232; "Plan Cost Inv. Change"; Boolean)
        {
            Caption = 'Plan Cost Inv. Change';
            ToolTip = 'Specifies the Plan Cost Inv. Change.';
        }
        field(12250; "Plan Cost Am. Purchase"; Boolean)
        {
            Caption = 'Plan Cost Val. Purchase';
            ToolTip = 'Specifies the Plan Cost Am. Purchase.';
        }
        field(12251; "Plan Cost Am. Purch. 1-5"; Boolean)
        {
            Caption = 'Plan Cost Am. Purch. 1-5';
            ToolTip = 'Specifies the Plan Cost Am. Purch. 1-5.';
        }
        field(12260; "Plan Cost Avg. Inv."; Boolean)
        {
            Caption = 'Plan Cost Avg. Inv.';
            ToolTip = 'Specifies the Plan Cost Avg. Inv.';
        }
        field(12310; "Plan S.Price Sales"; Boolean)
        {
            Caption = 'Plan S.Price Sales';
            ToolTip = 'Specifies the Plan S.Price Sales.';
        }
        field(12320; "Plan S.Price incl. Discount"; Boolean)
        {
            Caption = 'Plan S.Price incl. Discount';
            ToolTip = 'Specifies the Plan S.Price incl. Discount.';
        }
        field(12330; "Plan S.Price Purchase"; Boolean)
        {
            Caption = 'Plan S.Price Purchase';
            ToolTip = 'Specifies the Plan S.Price Purchase.';
        }
        field(12340; "Plan S.Price Init. Inv."; Boolean)
        {
            Caption = 'Plan S.Price Init. Inv.';
            ToolTip = 'Specifies the Plan S.Price Init. Inv.';
        }
        field(12350; "Plan S.Price Closing Inv."; Boolean)
        {
            Caption = 'Plan S.Price Closing Inv.';
            ToolTip = 'Specifies the Plan S.Price Closing Inv.';
        }
        field(12410; "Plan P.Price Sales"; Boolean)
        {
            Caption = 'Plan P.Price Sales';
            ToolTip = 'Specifies the Plan P.Price Sales.';
        }
        field(12430; "Plan P.Price Purchase"; Boolean)
        {
            Caption = 'Plan P.Price Purchase';
            ToolTip = 'Specifies the Plan P.Price Purchase.';
        }
        field(12440; "Plan P.Price Init. Inv."; Boolean)
        {
            Caption = 'Plan P.Price Init. Inv.';
            ToolTip = 'Specifies the Plan P.Price Init. Inv.';
        }
        field(12450; "Plan P.Price Closing Inv."; Boolean)
        {
            Caption = 'Plan P.Price Closing Inv.';
            ToolTip = 'Specifies the Plan P.Price Closing Inv.';
        }
        field(12510; "Plan Inv. Turnover"; Boolean)
        {
            Caption = 'Plan Inv. Turnover';
            ToolTip = 'Specifies the Plan Inv. Turnover.';
        }
        field(12520; "Plan Calc. Sales %"; Boolean)
        {
            Caption = 'Plan Calc. Sales %';
            ToolTip = 'Specifies the Plan Calc. Sales %.';
        }
        field(12530; "Plan Calc. Sales incl. Disc. %"; Boolean)
        {
            Caption = 'Plan Calc. Sales incl. Disc. %';
            ToolTip = 'Specifies the Plan Calc. Sales incl. Disc. %.';
        }
        field(12540; "Plan Calc. Purchase %"; Boolean)
        {
            Caption = 'Plan Calc. Purchase %';
            ToolTip = 'Specifies the Plan Calc. Purchase %.';
        }
        field(12550; "Plan Calc. Init. Inv. %"; Boolean)
        {
            Caption = 'Plan Calc. Init. Inv. %';
            ToolTip = 'Specifies the Plan Calc. Init. Inv. %.';
        }
        field(12560; "Plan Calc. Closing Inv. %"; Boolean)
        {
            Caption = 'Plan Calc. Closing Inv. %';
            ToolTip = 'Specifies the Plan Calc. Closing Inv. %.';
        }
        field(12570; "Plan Sales Order Amount"; Boolean)
        {
            Caption = 'Plan Sales Order Amount';
            ToolTip = 'Specifies the Plan Sales Order Amount';
        }
        field(12571; "Plan Sales Order Qty."; Boolean)
        {
            Caption = 'Plan Sales Order Qty.';
            ToolTip = 'Specifies the Plan Sales Order Qty.';
        }
        field(13010; "Ref. Sales Amount"; Boolean)
        {
            Caption = 'Ref. Sales Amount';
            ToolTip = 'Specifies the Ref. Sales Amount.';
        }
        field(13012; "Ref. Sal. Am. incl. Discount"; Boolean)
        {
            Caption = 'Ref. Sal. Am. incl. Discount';
            ToolTip = 'Specifies the Ref. Sal. Am. incl. Discount.';
        }
        field(13013; "Ref. Sales Percentage"; Boolean)
        {
            Caption = 'Ref. Sales Percentage';
            ToolTip = 'Specifies the Ref. Sales Percentage.';
        }
        field(13020; "Ref. Sales Discount"; Boolean)
        {
            Caption = 'Ref. Sales Discount';
            ToolTip = 'Specifies the Ref. Sales Discount.';
        }
        field(13021; "Ref. Sales Discount %"; Boolean)
        {
            Caption = 'Ref. Sales Discount %';
            ToolTip = 'Specifies the Ref. Sales Discount %.';
        }
        field(13030; "Ref. Sales Init. Inv."; Boolean)
        {
            Caption = 'Ref. Sales Init. Inv.';
            ToolTip = 'Specifies the Ref. Sales Init. Inv.';
        }
        field(13031; "Ref. Sales Closing Inv."; Boolean)
        {
            Caption = 'Ref. Sales Closing Inv.';
            ToolTip = 'Specifies the Ref. Sales Closing Inv.';
        }
        field(13032; "Ref. Sales Inv. Change"; Boolean)
        {
            Caption = 'Ref. Sales Inv. Change';
            ToolTip = 'Specifies the Ref. Sales Inv. Change.';
        }
        field(13040; "Ref. Gross Sales Pr. Reduction"; Boolean)
        {
            Caption = 'Ref. Gross Sales Pr. Reduction';
            ToolTip = 'Specifies the Ref. Gross Sales Pr. Reduction.';
        }
        field(13041; "Ref. Gross Sales Pr. Red. %"; Boolean)
        {
            Caption = 'Ref. Gross Sales Pr. Red. %';
        }
        field(13050; "Ref. Sales Am. Purchase"; Boolean)
        {
            Caption = 'Ref. Sales Am. Purchase';
            ToolTip = 'Specifies the Ref. Sales Am. Purchase.';
        }
        field(13060; "Ref. Sales Avg. Inv."; Boolean)
        {
            Caption = 'Ref. Sales Avg. Inv.';
            ToolTip = 'Specifies the Ref. Sales Avg. Inv.';
        }
        field(13110; "Ref. Qty. Sale"; Boolean)
        {
            Caption = 'Ref. Qty. Sale';
            ToolTip = 'Specifies the Ref. Qty. Sale.';
        }
        field(13130; "Ref. Qty. Init. Inv."; Boolean)
        {
            Caption = 'Ref. Qty. Init. Inv.';
            ToolTip = 'Specifies the Ref. Qty. Init. Inv.';
        }
        field(13131; "Ref. Qty. Closing Inv."; Boolean)
        {
            Caption = 'Ref. Qty. Closing Inv.';
            ToolTip = 'Specifies the Ref. Qty. Closing Inv.';
        }
        field(13132; "Ref. Qty. Inv. Change"; Boolean)
        {
            Caption = 'Ref. Qty. Inv. Change';
            ToolTip = 'Specifies the Ref. Qty. Inv. Change.';
        }
        field(13133; "Ref. Qty. Closing Inv. %"; Boolean)
        {
            Caption = 'Ref. Qty. Closing Inv. %';
            ToolTip = 'Specifies the Ref. Qty. Closing Inv. %.';
        }
        field(13150; "Ref. Qty. Purchase"; Boolean)
        {
            Caption = 'Ref. Qty. Purchase';
            ToolTip = 'Specifies the Ref. Qty. Purchase.';
        }
        field(13160; "Ref. Qty. Avg. Inv."; Boolean)
        {
            Caption = 'Ref. Qty. Avg. Inv.';
            ToolTip = 'Specifies the Ref. Qty. Avg. Inv.';
        }
        field(13210; "Ref. Cost of Sales"; Boolean)
        {
            Caption = 'Ref. Cost of Sales';
            ToolTip = 'Specifies the Ref. Cost of Sales.';
        }
        field(13230; "Ref. Cost Init. Inv."; Boolean)
        {
            Caption = 'Ref. Cost Init. Inv.';
            ToolTip = 'Specifies the Ref. Cost Init. Inv.';
        }
        field(13231; "Ref. Cost Closing Inv."; Boolean)
        {
            Caption = 'Ref. Cost Closing Inv.';
            ToolTip = 'Specifies the Ref. Cost Closing Inv.';
        }
        field(13232; "Ref. Cost Inv. Change"; Boolean)
        {
            Caption = 'Ref. Cost Inv. Change';
            ToolTip = 'Specifies the Ref. Cost Inv. Change.';
        }
        field(13250; "Ref. Cost Val. Purchase"; Boolean)
        {
            Caption = 'Ref. Cost Val. Purchase';
            ToolTip = 'Specifies the Ref. Cost Val. Purchase.';
        }
        field(13260; "Ref. Cost Avg. Inv."; Boolean)
        {
            Caption = 'Ref. Cost Avg. Inv.';
            ToolTip = 'Specifies the Ref. Cost Avg. Inv.';
        }
        field(13310; "Ref. S.Price Sales"; Boolean)
        {
            Caption = 'Ref. S.Price Sales';
            ToolTip = 'Specifies the Ref. S.Price Sales.';
        }
        field(13320; "Ref. S.Price incl. Discount"; Boolean)
        {
            Caption = 'Ref. S.Price incl. Discount';
            ToolTip = 'Specifies the Ref. S.Price incl. Discount.';
        }
        field(13330; "Ref. S.Price Purchase"; Boolean)
        {
            Caption = 'Ref. S.Price Purchase';
            ToolTip = 'Specifies the Ref. S.Price Purchase.';
        }
        field(13340; "Ref. S.Price Init. Inv."; Boolean)
        {
            Caption = 'Ref. S.Price Init. Inv.';
            ToolTip = 'Specifies the Ref. S.Price Init. Inv.';
        }
        field(13350; "Ref. S.Price Closing Inv."; Boolean)
        {
            Caption = 'Ref. S.Price Closing Inv.';
            ToolTip = 'Specifies the Ref. S.Price Closing Inv.';
        }
        field(13410; "Ref. P.Price Sales"; Boolean)
        {
            Caption = 'Ref. P.Price Sales';
            ToolTip = 'Specifies the Ref. P.Price Sales.';
        }
        field(13430; "Ref. P.Price Purchase"; Boolean)
        {
            Caption = 'Ref. P.Price Purchase';
            ToolTip = 'Specifies the Ref. P.Price Purchase.';
        }
        field(13440; "Ref. P.Price Init. Inv."; Boolean)
        {
            Caption = 'Ref. P.Price Init. Inv.';
            ToolTip = 'Specifies the Ref. P.Price Init. Inv.';
        }
        field(13450; "Ref. P.Price Closing Inv."; Boolean)
        {
            Caption = 'Ref. P.Price Closing Inv.';
            ToolTip = 'Specifies the Ref. P.Price Closing Inv.';
        }
        field(13510; "Ref. Inv. Turnover"; Boolean)
        {
            Caption = 'Ref. Inv. Turnover';
            ToolTip = 'Specifies the Ref. Inv. Turnover.';
        }
        field(13520; "Ref. Calc. Sales %"; Boolean)
        {
            Caption = 'Ref. Calc. Sales %';
            ToolTip = 'Specifies the Ref. Calc. Sales %.';
        }
        field(13530; "Ref. Calc. Sales incl. Disc. %"; Boolean)
        {
            Caption = 'Ref. Calc. Sales incl. Disc. %';
            ToolTip = 'Specifies the Ref. Calc. Sales incl. Disc. %.';
        }
        field(13540; "Ref. Calc. Purchase %"; Boolean)
        {
            Caption = 'Ref. Calc. Purchase %';
            ToolTip = 'Specifies the Ref. Calc. Purchase %.';
        }
        field(13550; "Ref. Calc. Init. Inv. %"; Boolean)
        {
            Caption = 'Ref. Calc. Init. Inv. %';
            ToolTip = 'Specifies the Ref. Calc. Init. Inv. %.';
        }
        field(13560; "Ref. Calc. Closing Inv. %"; Boolean)
        {
            Caption = 'Ref. Calc. Closing Inv. %';
            ToolTip = 'Specifies the Ref. Calc. Closing Inv. %.';
        }
        field(13570; "Ref. Sales Order Amount"; Boolean)
        {
            Caption = 'Ref. Sales Order Amount';
            ToolTip = 'Specifies the Ref. Sales Order Amount';
        }
        field(13571; "Ref. Sales Order Qty."; Boolean)
        {
            Caption = 'Ref. Sales Order Qty.';
            ToolTip = 'Specifies the Ref. Sales Order Qty.';
        }
        field(13900; "Actual Sales Amount"; Boolean)
        {
            Caption = 'Actual Sales Amount';
            ToolTip = 'Specifies the Actual Sales Amount.';
        }
        field(13901; "Actual Sales Discount"; Boolean)
        {
            Caption = 'Actual Sales Discount';
            ToolTip = 'Specifies the Actual Sales Discount.';
        }
        field(13902; "Actual Sales Init. Inv."; Boolean)
        {
            Caption = 'Actual Sales Init. Inv.';
            ToolTip = 'Specifies the Actual Sales Init. Inv.';
        }
        field(13903; "Actual Sales Closing Inv."; Boolean)
        {
            Caption = 'Actual Sales Closing Inv.';
            ToolTip = 'Specifies the Actual Sales Closing Inv.';
        }
        field(13904; "Actual Gross Sales Pr. Red."; Boolean)
        {
            Caption = 'Actual Gross Sales Pr. Red.';
            ToolTip = 'Specifies the Actual Gross Sales Pr. Red.';
        }
        field(13905; "Actual Sales Am. Purchase"; Boolean)
        {
            Caption = 'Actual Sales Am. Purchase';
            ToolTip = 'Specifies the Actual Sales Am. Purchase.';
        }
        field(13906; "Actual Qty. Sale"; Boolean)
        {
            Caption = 'Actual Qty. Sale';
            ToolTip = 'Specifies the Actual Qty. Sale.';
        }
        field(13907; "Actual Qty. Init. Inv."; Boolean)
        {
            Caption = 'Actual Qty. Init. Inv.';
            ToolTip = 'Specifies the Actual Qty. Init. Inv.';
        }
        field(13908; "Actual Qty. Closing Inv."; Boolean)
        {
            Caption = 'Actual Qty. Closing Inv.';
            ToolTip = 'Specifies the Actual Qty. Closing Inv.';
        }
        field(13909; "Actual Qty. Purchase"; Boolean)
        {
            Caption = 'Actual Qty. Purchase';
            ToolTip = 'Specifies the Actual Qty. Purchase.';
        }
        field(13910; "Actual Cost of Sales"; Boolean)
        {
            Caption = 'Actual Cost of Sales';
            ToolTip = 'Specifies the Actual Cost of Sales.';
        }
        field(13911; "Actual Cost Init. Inv."; Boolean)
        {
            Caption = 'Actual Cost Init. Inv.';
            ToolTip = 'Specifies the Actual Cost Init. Inv.';
        }
        field(13912; "Actual Cost Closing Inv."; Boolean)
        {
            Caption = 'Actual Cost Closing Inv.';
            ToolTip = 'Specifies the Actual Cost Closing Inv.';
        }
        field(13913; "Actual Cost Am. Purchase"; Boolean)
        {
            Caption = 'Actual Cost Am. Purchase';
            ToolTip = 'Specifies the Actual Cost Am. Purchase.';
        }
        field(13914; "Actual Sales Amount Net."; Boolean)
        {
            Caption = 'Actual Sales Amount';
        }
        field(13999; "Free Sales Limit"; Boolean)
        {
            Caption = 'Free Sales Limit';
            ToolTip = 'Specifies the Free Sales Limit.';
        }
        field(14000; "Free Purchase Limit"; Boolean)
        {
            Caption = 'Free Purchase Limit';
            ToolTip = 'Specifies the Free Purchase Limit.';
        }
        field(14001; "Purch. Order Outst. Qty."; Boolean)
        {
            Caption = 'Purch. Order Outst. Qty.';
            ToolTip = 'Specifies the Purch. Order Outst. Qty.';
        }
        field(14002; "Purch. Order Outst. Amt."; Boolean)
        {
            Caption = 'Purch. Order Outst. Amt.';
            ToolTip = 'Specifies the Purch. Order Outst. Amt.';
        }
        field(14003; "Purch. Order Outst. Amt. Net."; Boolean)
        {
            Caption = 'Purch. Order Outst. Amt. Net.';
            ToolTip = 'Specifies the Purch. Order Outst. Amt. Net.';
        }
        field(14200; "Plan Target Sales Amount"; Boolean)
        {
            Caption = 'Plan Target Sales Amount';
            ToolTip = 'Specifies the Plan Target Sales Amount.';
        }
        field(14201; "Plan Target Sales Discount"; Boolean)
        {
            Caption = 'Plan Target Sales Discount';
            ToolTip = 'Specifies the Plan Target Sales Discount.';
        }
        field(14202; "Plan Target Sales Init. Inv."; Boolean)
        {
            Caption = 'Plan Target Sales Init. Inv.';
            ToolTip = 'Specifies the Plan Target Sales Init. Inv.';
        }
        field(14203; "Plan Target Sales Closing Inv."; Boolean)
        {
            Caption = 'Plan Target Sales Inv.';
            ToolTip = 'Specifies the Plan Target Sales Closing Inv.';
        }
        field(14204; "Plan Target G.S.P. Reduction"; Boolean)
        {
            Caption = 'Plan Target G.S.P. Reduction';
            ToolTip = 'Specifies the Plan Target G.S.P. Reduction.';
        }
        field(14205; "Plan Target Sal. Am. Purch."; Boolean)
        {
            Caption = 'Plan Target Sal. Am. Purch.';
            ToolTip = 'Specifies the Plan Target Sal. Am. Purch.';
        }
        field(14210; "Plan Target Qty. Sale"; Boolean)
        {
            Caption = 'Plan Target Qty. Turnover';
            ToolTip = 'Specifies the Plan Target Qty. Sale.';
        }
        field(14211; "Plan Target Qty. Init. Inv."; Boolean)
        {
            Caption = 'Plan Target Qty. Init. Inv.';
            ToolTip = 'Specifies the Plan Target Qty. Init. Inv.';
        }
        field(14212; "Plan Target Qty. Closing Inv."; Boolean)
        {
            Caption = 'Plan Target Qty. Closing Inv.';
            ToolTip = 'Specifies the Plan Target Qty. Closing Inv.';
        }
        field(14213; "Plan Target Qty. Purchase"; Boolean)
        {
            Caption = 'Plan Target Qty. Purchase';
            ToolTip = 'Specifies the Plan Target Qty. Purchase.';
        }
        field(14220; "Plan Target Cost of Sales"; Boolean)
        {
            Caption = 'Plan Target Cost of Sales';
            ToolTip = 'Specifies the Plan Target Cost of Sales.';
        }
        field(14221; "Plan Target Cost Init. Inv."; Boolean)
        {
            Caption = 'Plan Target Cost Init. Inv.';
            ToolTip = 'Specifies the Plan Target Cost Init. Inv.';
        }
        field(14222; "Plan Target Cost Closing Inv."; Boolean)
        {
            Caption = 'Plan Target Cost Inv.';
            ToolTip = 'Specifies the Plan Target Cost Closing Inv.';
        }
        field(14223; "Plan Target Cost Am. Purch."; Boolean)
        {
            Caption = 'Plan Target Cost Val. Purch.';
            ToolTip = 'Specifies the Plan Target Cost Am. Purch.';
        }
        field(14224; "Plan Target Sales Am. Net."; Boolean)
        {
            Caption = 'Plan Target Sales Am. Net.';
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
}

