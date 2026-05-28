/// <summary>
/// [planning]
/// Modules: 
/// </summary>
table 5138643 "BET FN Planning Document Level"
{
    // 090529 : Datumsebene ja/nein muß immer für alle Ebenen gleich sein

    Caption = 'Planning Document Level';
    DrillDownPageId = "BET FN Planning Document Lvls";
    LookupPageId = "BET FN Planning Document Lvls";
    DataClassification = CustomerContent;
    Access = Public;
    Extensible = true;

    fields
    {
        field(1; "Planning Document No."; Code[20])
        {
            Caption = 'Planning Document No.';
            TableRelation = "BET FN Planning Document Level";
        }
        field(2; "Planning Document Level Index"; Integer)
        {
            Caption = 'Planning Document Level';
            ToolTip = 'Specifies the Planning Document Level Index.';
        }
        field(4; "Planning Document Description"; Text[100])
        {

            CalcFormula = lookup("BET FN Planning Document".Description where("No." = field("Planning Document No.")));
            Caption = 'Planning Document Description';
            Editable = false;
            FieldClass = FlowField;

            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(5; "Layout Template Code"; Integer)
        {
            Caption = 'Layout Template Code';
            TableRelation = "BET FN Planning Layout Tmplt";

            ObsoleteState = Removed;
            ObsoleteTag = '22.4';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(6; "Layout Template"; Code[20])
        {
            Caption = 'Layout Template';
            TableRelation = "BET FN Planning Layout Tmplt";
            ToolTip = 'Specifies the Layout Template.';
        }
        field(321; "Timestamp Planning Values"; DateTime)
        {
            Caption = 'Timestamp Planning Values';
        }
        field(322; "Timestamp Reference Values"; DateTime)
        {
            Caption = 'Timestamp Reference Values';
        }
        field(1000; "Index Code"; Code[20])
        {
            Caption = 'Index Code';
            ToolTip = 'Specifies the Index Code.';
        }
        field(1001; "Index Description"; Text[30])
        {
            Caption = 'Index Description';
            ToolTip = 'Specifies the Index Description.';
        }
        field(1002; "Index Table No."; Integer)
        {
            ToolTip = 'Specifies the Index Table No.';
        }
        field(1010; "Index Code 1"; Code[20])
        {
        }
        field(1011; "Index Description 1"; Text[30])
        {
        }
        field(1012; "Index Table No. 1"; Integer)
        {
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(1013; "Index PD Level vert. 1"; Integer)
        {
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(1020; "Index Code 2"; Code[20])
        {
        }
        field(1021; "Index Description 2"; Text[30])
        {
        }
        field(1022; "Index Table No. 2"; Integer)
        {
            NotBlank = false;
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(1023; "Index PD Level vert. 2"; Integer)
        {
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(1030; "Index Code 3"; Code[20])
        {
        }
        field(1031; "Index Description 3"; Text[30])
        {
        }
        field(1032; "Index Table No. 3"; Integer)
        {
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(1033; "Index PD Level vert. 3"; Integer)
        {
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(1040; "Index Code 4"; Code[20])
        {
        }
        field(1041; "Index Description 4"; Text[30])
        {
        }
        field(1042; "Index Table No. 4"; Integer)
        {
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(1043; "Index PD Level vert. 4"; Integer)
        {
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(1050; "Index Code 5"; Code[20])
        {
        }
        field(1051; "Index Description 5"; Text[30])
        {
        }
        field(1052; "Index Table No. 5"; Integer)
        {
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(1053; "Index PD Level vert. 5"; Integer)
        {
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(1060; "Index Code 6"; Code[20])
        {
        }
        field(1061; "Index Description 6"; Text[30])
        {
        }
        field(1062; "Index Table No. 6"; Integer)
        {
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(1063; "Index PD Level vert. 6"; Integer)
        {
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(5001; "Path End"; Boolean)
        {
            Caption = 'Path End';
        }
        field(5003; "No. of Source-Records"; Integer)
        {
            Caption = 'No. of Source-Records';
            ToolTip = 'Specifies the number of Source-Records.';
        }
        field(5004; "No. of Records"; Integer)
        {
            Caption = 'No. of Records';
            ToolTip = 'Specifies the number of Records.';
        }
        field(5005; "Document Level Buffer Created"; Boolean)
        {
            Caption = 'Document Level Buffer Created';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(5010; "Activate Date Level"; Boolean)
        {
            Caption = 'Activate Date Level';
            ToolTip = 'Specifies the Activate Date Level.';
        }
        field(5011; "No. of Records on Date Level"; Integer)
        {
            Caption = 'No. of Records on Date Level';
            ToolTip = 'Specifies the number of Records on Date Level.';
        }
        field(12010; "Plan Sales Amount"; Boolean)
        {
            Caption = 'Plan Sales Amount';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Plan Sales Amount.';
        }
        field(12011; "Plan Sal. Am. Difference %"; Boolean)
        {
            Caption = 'Plan Sal. Am. Difference %';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Plan Sal. Am. Difference %.';
        }
        field(12012; "Plan Sal. Am. incl. Discount"; Boolean)
        {
            Caption = 'Plan Sal. Am. incl. Discount';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Plan Sal. Am. incl. Discount.';
        }
        field(12013; "Plan Sales Percentage"; Boolean)
        {
            Caption = 'Plan Sales Percentage';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Plan Sales Percentage.';
        }
        field(12020; "Plan Sales Discount"; Boolean)
        {
            Caption = 'Plan Sales Discount';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Plan Sales Discount.';
        }
        field(12021; "Plan Sales Discount %"; Boolean)
        {
            Caption = 'Plan Sales Discount %';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Plan Sales Discount %.';
        }
        field(12030; "Plan Sales Init. Inv."; Boolean)
        {
            Caption = 'Plan Sales Init. Inv.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Plan Sales Init. Inv.';
        }
        field(12031; "Plan Sales Closing Inv."; Boolean)
        {
            Caption = 'Plan Sales Closing Inv.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Plan Sales Closing Inv.';
        }
        field(12032; "Plan Sales Inv. Change"; Boolean)
        {
            Caption = 'Plan Sales Inv. Change';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Plan Sales Inv. Change.';
        }
        field(12040; "Plan Gross Sales Pr. Reduction"; Boolean)
        {
            Caption = 'Plan Gross Sales Pr. Reduction';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Plan Gross Sales Pr. Reduction.';
        }
        field(12041; "Plan Gross Sales Pr. Red. %"; Boolean)
        {
            Caption = 'Plan Gross Sales Pr. Red. %';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(12050; "Plan Sales Am. Purchase"; Boolean)
        {
            Caption = 'Plan Sales Am. Purchase';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Plan Sales Am. Purchase.';
        }
        field(12060; "Plan Sales Avg. Inv."; Boolean)
        {
            Caption = 'Plan Sales Avg. Inv.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Plan Sales Avg. Inv.';
        }
        field(12110; "Plan Qty. Sale"; Boolean)
        {
            Caption = 'Plan Qty. Sale';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Plan Qty. Sale.';
        }
        field(12111; "Plan Qty. Sale Diff. %"; Boolean)
        {
            Caption = 'Plan Qty. Sale Diff. %';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Plan Qty. Sale Diff. %.';
        }
        field(12130; "Plan Qty. Init. Inv."; Boolean)
        {
            Caption = 'Plan Qty. Init. Inv.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Plan Qty. Init. Inv.';
        }
        field(12131; "Plan Qty. Closing Inv."; Boolean)
        {
            Caption = 'Plan Qty. Closing Inv.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Plan Qty. Closing Inv.';
        }
        field(12132; "Plan Qty. Inv. Change"; Boolean)
        {
            Caption = 'Plan Qty. Inv. Change';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Plan Qty. Inv. Change.';
        }
        field(12133; "Plan Qty. Closing Inv. %"; Boolean)
        {
            Caption = 'Plan Qty. Closing Inv. %';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Plan Qty. Closing Inv. %.';
        }
        field(12150; "Plan Qty. Purchase"; Boolean)
        {
            Caption = 'Plan Qty. Purchase';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Plan Qty. Purchase.';
        }
        field(12160; "Plan Qty. Avg. Inv."; Boolean)
        {
            Caption = 'Plan Qty. Avg. Inv.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Plan Qty. Avg. Inv.';
        }
        field(12210; "Plan Cost of Sales"; Boolean)
        {
            Caption = 'Plan Cost of Sales';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Plan Cost of Sales.';
        }
        field(12211; "Plan Cost of Sales %"; Boolean)
        {
            Caption = 'Plan Cost of Sales %';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Plan Cost of Sales %.';
        }
        field(12230; "Plan Cost Init. Inv."; Boolean)
        {
            Caption = 'Plan Cost Init. Inv.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Plan Cost Init. Inv.';
        }
        field(12231; "Plan Cost Closing Inv."; Boolean)
        {
            Caption = 'Plan Cost Closing Inv.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Plan Cost Closing Inv.';
        }
        field(12232; "Plan Cost Inv. Change"; Boolean)
        {
            Caption = 'Plan Cost Inv. Change';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Plan Cost Inv. Change.';
        }
        field(12250; "Plan Cost Am. Purchase"; Boolean)
        {
            Caption = 'Plan Cost Val. Purchase';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Plan Cost Am. Purchase.';
        }
        field(12251; "Plan Cost Am. Purch. 1-5"; Boolean)
        {
            Caption = 'Plan Cost Am. Purch. 1-5';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Plan Cost Am. Purch. 1-5.';
        }
        field(12260; "Plan Cost Avg. Inv."; Boolean)
        {
            Caption = 'Plan Cost Avg. Inv.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Plan Cost Avg. Inv.';
        }
        field(12310; "Plan S.Price Sales"; Boolean)
        {
            Caption = 'Plan S.Price Sales';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Plan S.Price Sales.';
        }
        field(12320; "Plan S.Price incl. Discount"; Boolean)
        {
            Caption = 'Plan S.Price incl. Discount';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Plan S.Price incl. Discount.';
        }
        field(12330; "Plan S.Price Purchase"; Boolean)
        {
            Caption = 'Plan S.Price Purchase';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Plan S.Price Purchase.';
        }
        field(12340; "Plan S.Price Init. Inv."; Boolean)
        {
            Caption = 'Plan S.Price Init. Inv.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Plan S.Price Init. Inv.';
        }
        field(12350; "Plan S.Price Closing Inv."; Boolean)
        {
            Caption = 'Plan S.Price Closing Inv.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Plan S.Price Closing Inv.';
        }
        field(12410; "Plan P.Price Sales"; Boolean)
        {
            Caption = 'Plan P.Price Sales';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Plan P.Price Sales.';
        }
        field(12430; "Plan P.Price Purchase"; Boolean)
        {
            Caption = 'Plan P.Price Purchase';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Plan P.Price Purchase.';
        }
        field(12440; "Plan P.Price Init. Inv."; Boolean)
        {
            Caption = 'Plan P.Price Init. Inv.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Plan P.Price Init. Inv.';
        }
        field(12450; "Plan P.Price Closing Inv."; Boolean)
        {
            Caption = 'Plan P.Price Closing Inv.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Plan P.Price Closing Inv.';
        }
        field(12510; "Plan Inv. Turnover"; Boolean)
        {
            Caption = 'Plan Inv. Turnover';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Plan Inv. Turnover.';
        }
        field(12520; "Plan Calc. Sales %"; Boolean)
        {
            Caption = 'Plan Calc. Sales %';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Plan Calc. Sales %.';
        }
        field(12530; "Plan Calc. Sales incl. Disc. %"; Boolean)
        {
            Caption = 'Plan Calc. Sales incl. Disc. %';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Plan Calc. Sales incl. Disc. %.';
        }
        field(12540; "Plan Calc. Purchase %"; Boolean)
        {
            Caption = 'Plan Calc. Purchase %';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Plan Calc. Purchase %.';
        }
        field(12550; "Plan Calc. Init. Inv. %"; Boolean)
        {
            Caption = 'Plan Calc. Init. Inv. %';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Plan Calc. Init. Inv. %.';
        }
        field(12560; "Plan Calc. Closing Inv. %"; Boolean)
        {
            Caption = 'Plan Calc. Closing Inv. %';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Plan Calc. Closing Inv. %.';
        }
        field(13010; "Ref. Sales Amount"; Boolean)
        {
            Caption = 'Ref. Sales Amount';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Ref. Sales Amount.';
        }
        field(13012; "Ref. Sal. Am. incl. Discount"; Boolean)
        {
            Caption = 'Ref. Sal. Am. incl. Discount';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Ref. Sal. Am. incl. Discount.';
        }
        field(13013; "Ref. Sales Percentage"; Boolean)
        {
            Caption = 'Ref. Sales Percentage';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Ref. Sales Percentage.';
        }
        field(13020; "Ref. Sales Discount"; Boolean)
        {
            Caption = 'Ref. Sales Discount';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Ref. Sales Discount.';
        }
        field(13021; "Ref. Sales Discount %"; Boolean)
        {
            Caption = 'Ref. Sales Discount %';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Ref. Sales Discount %.';
        }
        field(13030; "Ref. Sales Init. Inv."; Boolean)
        {
            Caption = 'Ref. Sales Init. Inv.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Ref. Sales Init. Inv.';
        }
        field(13031; "Ref. Sales Closing Inv."; Boolean)
        {
            Caption = 'Ref. Sales Closing Inv.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Ref. Sales Closing Inv.';
        }
        field(13032; "Ref. Sales Inv. Change"; Boolean)
        {
            Caption = 'Ref. Sales Inv. Change';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Ref. Sales Inv. Change.';
        }
        field(13040; "Ref. Gross Sales Pr. Reduction"; Boolean)
        {
            Caption = 'Ref. Gross Sales Pr. Reduction';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Ref. Gross Sales Pr. Reduction.';
        }
        field(13041; "Ref. Gross Sales Pr. Red. %"; Boolean)
        {
            Caption = 'Ref. Gross Sales Pr. Red. %';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(13050; "Ref. Sales Am. Purchase"; Boolean)
        {
            Caption = 'Ref. Sales Am. Purchase';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Ref. Sales Am. Purchase.';
        }
        field(13060; "Ref. Sales Avg. Inv."; Boolean)
        {
            Caption = 'Ref. Sales Avg. Inv.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Ref. Sales Avg. Inv.';
        }
        field(13110; "Ref. Qty. Sale"; Boolean)
        {
            Caption = 'Ref. Qty. Sale';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Ref. Qty. Sale.';
        }
        field(13130; "Ref. Qty. Init. Inv."; Boolean)
        {
            Caption = 'Ref. Qty. Init. Inv.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Ref. Qty. Init. Inv.';
        }
        field(13131; "Ref. Qty. Closing Inv."; Boolean)
        {
            Caption = 'Ref. Qty. Closing Inv.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Ref. Qty. Closing Inv.';
        }
        field(13132; "Ref. Qty. Inv. Change"; Boolean)
        {
            Caption = 'Ref. Qty. Inv. Change';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Ref. Qty. Inv. Change.';
        }
        field(13133; "Ref. Qty. Closing Inv. %"; Boolean)
        {
            Caption = 'Ref. Qty. Closing Inv. %';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Ref. Qty. Closing Inv. %.';
        }
        field(13150; "Ref. Qty. Purchase"; Boolean)
        {
            Caption = 'Ref. Qty. Purchase';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Ref. Qty. Purchase.';
        }
        field(13160; "Ref. Qty. Avg. Inv."; Boolean)
        {
            Caption = 'Ref. Qty. Avg. Inv.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Ref. Qty. Avg. Inv.';
        }
        field(13210; "Ref. Cost of Sales"; Boolean)
        {
            Caption = 'Ref. Cost of Sales';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Ref. Cost of Sales.';
        }
        field(13230; "Ref. Cost Init. Inv."; Boolean)
        {
            Caption = 'Ref. Cost Init. Inv.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Ref. Cost Init. Inv.';
        }
        field(13231; "Ref. Cost Closing Inv."; Boolean)
        {
            Caption = 'Ref. Cost Closing Inv.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Ref. Cost Closing Inv.';
        }
        field(13232; "Ref. Cost Inv. Change"; Boolean)
        {
            Caption = 'Ref. Cost Inv. Change';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Ref. Cost Inv. Change.';
        }
        field(13250; "Ref. Cost Val. Purchase"; Boolean)
        {
            Caption = 'Ref. Cost Val. Purchase';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Ref. Cost Val. Purchase.';
        }
        field(13260; "Ref. Cost Avg. Inv."; Boolean)
        {
            Caption = 'Ref. Cost Avg. Inv.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Ref. Cost Avg. Inv.';
        }
        field(13310; "Ref. S.Price Sales"; Boolean)
        {
            Caption = 'Ref. S.Price Sales';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Ref. S.Price Sales.';
        }
        field(13320; "Ref. S.Price incl. Discount"; Boolean)
        {
            Caption = 'Ref. S.Price incl. Discount';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Ref. S.Price incl. Discount.';
        }
        field(13330; "Ref. S.Price Purchase"; Boolean)
        {
            Caption = 'Ref. S.Price Purchase';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Ref. S.Price Purchase.';
        }
        field(13340; "Ref. S.Price Init. Inv."; Boolean)
        {
            Caption = 'Ref. S.Price Init. Inv.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Ref. S.Price Init. Inv.';
        }
        field(13350; "Ref. S.Price Closing Inv."; Boolean)
        {
            Caption = 'Ref. S.Price Closing Inv.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Ref. S.Price Closing Inv.';
        }
        field(13410; "Ref. P.Price Sales"; Boolean)
        {
            Caption = 'Ref. P.Price Sales';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Ref. P.Price Sales.';
        }
        field(13430; "Ref. P.Price Purchase"; Boolean)
        {
            Caption = 'Ref. P.Price Purchase';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Ref. P.Price Purchase.';
        }
        field(13440; "Ref. P.Price Init. Inv."; Boolean)
        {
            Caption = 'Ref. P.Price Init. Inv.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Ref. P.Price Init. Inv.';
        }
        field(13450; "Ref. P.Price Closing Inv."; Boolean)
        {
            Caption = 'Ref. P.Price Closing Inv.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Ref. P.Price Closing Inv.';
        }
        field(13510; "Ref. Inv. Turnover"; Boolean)
        {
            Caption = 'Ref. Inv. Turnover';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Ref. Inv. Turnover.';
        }
        field(13520; "Ref. Calc. Sales %"; Boolean)
        {
            Caption = 'Ref. Calc. Sales %';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Ref. Calc. Sales %.';
        }
        field(13530; "Ref. Calc. Sales incl. Disc. %"; Boolean)
        {
            Caption = 'Ref. Calc. Sales incl. Disc. %';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Ref. Calc. Sales incl. Disc. %.';
        }
        field(13540; "Ref. Calc. Purchase %"; Boolean)
        {
            Caption = 'Ref. Calc. Purchase %';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Ref. Calc. Purchase %.';
        }
        field(13550; "Ref. Calc. Init. Inv. %"; Boolean)
        {
            Caption = 'Ref. Calc. Init. Inv. %';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Ref. Calc. Init. Inv. %.';
        }
        field(13560; "Ref. Calc. Closing Inv. %"; Boolean)
        {
            Caption = 'Ref. Calc. Closing Inv. %';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Ref. Calc. Closing Inv. %.';
        }
        field(13900; "Actual Sales Amount"; Boolean)
        {
            Caption = 'Actual Sales Amount';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Actual Sales Amount.';
        }
        field(13901; "Actual Sales Discount"; Boolean)
        {
            Caption = 'Actual Sales Discount';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Actual Sales Discount.';
        }
        field(13902; "Actual Sales Init. Inv."; Boolean)
        {
            Caption = 'Actual Sales Init. Inv.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Actual Sales Init. Inv.';
        }
        field(13903; "Actual Sales Closing Inv."; Boolean)
        {
            Caption = 'Actual Sales Closing Inv.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Actual Sales Closing Inv.';
        }
        field(13904; "Actual Gross Sales Pr. Red."; Boolean)
        {
            Caption = 'Actual Gross Sales Pr. Red.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Actual Gross Sales Pr. Red.';
        }
        field(13905; "Actual Sales Am. Purchase"; Boolean)
        {
            Caption = 'Actual Sales Am. Purchase';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Actual Sales Am. Purchase.';
        }
        field(13906; "Actual Qty. Sale"; Boolean)
        {
            Caption = 'Actual Qty. Sale';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Actual Qty. Sale.';
        }
        field(13907; "Actual Qty. Init. Inv."; Boolean)
        {
            Caption = 'Actual Qty. Init. Inv.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Actual Qty. Init. Inv.';
        }
        field(13908; "Actual Qty. Closing Inv."; Boolean)
        {
            Caption = 'Actual Qty. Closing Inv.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Actual Qty. Closing Inv.';
        }
        field(13909; "Actual Qty. Purchase"; Boolean)
        {
            Caption = 'Actual Qty. Purchase';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Actual Qty. Purchase.';
        }
        field(13910; "Actual Cost of Sales"; Boolean)
        {
            Caption = 'Actual Cost of Sales';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Actual Cost of Sales.';
        }
        field(13911; "Actual Cost Init. Inv."; Boolean)
        {
            Caption = 'Actual Cost Init. Inv.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Actual Cost Init. Inv.';
        }
        field(13912; "Actual Cost Closing Inv."; Boolean)
        {
            Caption = 'Actual Cost Closing Inv.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Actual Cost Closing Inv.';
        }
        field(13913; "Actual Cost Am. Purchase"; Boolean)
        {
            Caption = 'Actual Cost Am. Purchase';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Actual Cost Am. Purchase.';
        }
        field(13914; "Actual Sales Amount Net."; Boolean)
        {
            Caption = 'Actual Sales Amount';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(13999; "Free Sales Limit"; Boolean)
        {
            Caption = 'Free Sales Limit';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(14000; "Free Purchase Limit"; Boolean)
        {
            Caption = 'Free Purchase Limit';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Free Purchase Limit.';
        }
        field(14001; "Purch. Order Outst. Qty."; Boolean)
        {
            Caption = 'Purch. Order Outst. Qty.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Purch. Order Outst. Qty.';
        }
        field(14002; "Purch. Order Outst. Amt."; Boolean)
        {
            Caption = 'Purch. Order Outst. Amt.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Purch. Order Outst. Amt.';
        }
        field(14003; "Purch. Order Outst. Amt. Net."; Boolean)
        {
            Caption = 'Purch. Order Outst. Amt. Net.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Purch. Order Outst. Amt. Net.';
        }
        field(14200; "Plan Target Sales Amount"; Boolean)
        {
            Caption = 'Plan Target Sales Amount';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Plan Target Sales Amount.';
        }
        field(14201; "Plan Target Sales Discount"; Boolean)
        {
            Caption = 'Plan Target Sales Discount';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Plan Target Sales Discount.';
        }
        field(14202; "Plan Target Sales Init. Inv."; Boolean)
        {
            Caption = 'Plan Target Sales Init. Inv.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Plan Target Sales Init. Inv.';
        }
        field(14203; "Plan Target Sales Closing Inv."; Boolean)
        {
            Caption = 'Plan Target Sales Inv.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Plan Target Sales Closing Inv.';
        }
        field(14204; "Plan Target G.S.P. Reduction"; Boolean)
        {
            Caption = 'Plan Target G.S.P. Reduction';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Plan Target G.S.P. Reduction.';
        }
        field(14205; "Plan Target Sal. Am. Purch."; Boolean)
        {
            Caption = 'Plan Target Sal. Am. Purch.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Plan Target Sal. Am. Purch.';
        }
        field(14210; "Plan Target Qty. Sale"; Boolean)
        {
            Caption = 'Plan Target Qty. Turnover';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Plan Target Qty. Sale.';
        }
        field(14211; "Plan Target Qty. Init. Inv."; Boolean)
        {
            Caption = 'Plan Target Qty. Init. Inv.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Plan Target Qty. Init. Inv.';
        }
        field(14212; "Plan Target Qty. Closing Inv."; Boolean)
        {
            Caption = 'Plan Target Qty. Closing Inv.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Plan Target Qty. Closing Inv.';
        }
        field(14213; "Plan Target Qty. Purchase"; Boolean)
        {
            Caption = 'Plan Target Qty. Purchase';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Plan Target Qty. Purchase.';
        }
        field(14220; "Plan Target Cost of Sales"; Boolean)
        {
            Caption = 'Plan Target Cost of Sales';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Plan Target Cost of Sales.';
        }
        field(14221; "Plan Target Cost Init. Inv."; Boolean)
        {
            Caption = 'Plan Target Cost Init. Inv.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Plan Target Cost Init. Inv.';
        }
        field(14222; "Plan Target Cost Closing Inv."; Boolean)
        {
            Caption = 'Plan Target Cost Inv.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Plan Target Cost Closing Inv.';
        }
        field(14223; "Plan Target Cost Am. Purch."; Boolean)
        {
            Caption = 'Plan Target Cost Val. Purch.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Plan Target Cost Am. Purch.';
        }
        field(14224; "Plan Target Sales Am. Net."; Boolean)
        {
            Caption = 'Plan Target Sales Am. Net.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
    }

    keys
    {
        key(Key1; "Planning Document No.", "Planning Document Level Index")
        {
            Clustered = true;
            MaintainSiftIndex = false;
        }
        key(Key2; "Planning Document No.", "Path End")
        {
            MaintainSiftIndex = false;
        }
        key(Key3; "Timestamp Planning Values")
        {
            MaintainSiftIndex = false;
        }
        key(Key4; "Planning Document No.", "Activate Date Level")
        {
            MaintainSiftIndex = false;
        }
        key(Key5; "Activate Date Level")
        {
            MaintainSiftIndex = false;
        }
        key(Key6; "Planning Document No.", "Timestamp Planning Values")
        {
            MaintainSiftIndex = false;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Planning Document Level Index", "Index Code", "Index Description")
        {
        }
    }

    trigger OnDelete()
    var
        PlanDocLevel_LT: Record "BET FN Planning Document Level";
        BETFNPlanningDocumentMgt: Codeunit "BET FN Planning Document Mgt";
    begin
        if PlanDocLevel_LT.Get("Planning Document No.", "Planning Document Level Index" + 1) then
            BETFNPlanningDocumentMgt.CheckPathEnd(PlanDocLevel_LT);
    end;

    trigger OnInsert()
    var
        PlanDocLevel_LT: Record "BET FN Planning Document Level";
        BETFNPlanningDocumentMgt: Codeunit "BET FN Planning Document Mgt";
    begin
        BETFNPlanningDocumentMgt.CheckPathEnd(Rec);
        if Get("Planning Document No.", "Planning Document Level Index") then
            BETFNPlanningDocumentMgt.CheckPathEnd(PlanDocLevel_LT);
    end;

    trigger OnModify()
    var
        BETFNPlanningDocumentMgt: Codeunit "BET FN Planning Document Mgt";
    begin
        BETFNPlanningDocumentMgt.CheckPathEnd(Rec);
    end;

    /// <summary>
    /// SetLevelLayoutToGlobal.
    /// </summary>
    /// <param name="DocNo_P">Code[20].</param>
    [Obsolete('#35131 Pending removal - procedure will be removed in future', '25.2')]

    procedure SetLevelLayoutToGlobal(DocNo_P: Code[20])
    begin
    end;

    /// <summary>
    /// UpdateNoOfRecords.
    /// </summary>
    /// <param name="PlanDocLevel_RT">VAR Record "BET FN Planning Document Level".</param>
    [Obsolete('#35131 Pending removal - procedure will be removed in future', '25.2')]

    procedure UpdateNoOfRecords(var PlanDocLevel_RT: Record "BET FN Planning Document Level")
    begin
    end;
}

