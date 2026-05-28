/// <summary>
/// [planning]
/// Modules: 
/// </summary>
#pragma warning disable AL0432
table 5138649 "BET FN Planning View"
{
    DrillDownPageId = "BET FN Planning View";
    DataClassification = CustomerContent;
    Access = Public;
    Extensible = true;

    fields
    {
        field(1; "Index 1"; Code[20])
        {
        }
        field(2; "Index 2"; Code[20])
        {
        }
        field(3; "Index 3"; Code[20])
        {
        }
        field(4; "Index 4"; Code[20])
        {
        }
        field(5; "Index 5"; Code[20])
        {
        }
        field(6; "Index 6"; Code[20])
        {
        }
        field(11; "Date"; Date)
        {
            Caption = 'Date';
            ToolTip = 'Specifies the Date.';
        }
        field(12; "View Entry No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'View Entry No.';
            ToolTip = 'Specifies the View Entry No.';
        }
        field(101; "Planning Document No."; Code[20])
        {
            Caption = 'Planning Document No.';
            NotBlank = true;
            TableRelation = "BET FN Planning Document";
            ToolTip = 'Specifies the Planning Document No.';
        }
        field(102; "Planning Document Level"; Integer)
        {
            Caption = 'Planning Level';
            NotBlank = false;
        }
        field(206; "Line Type"; Option)
        {
            Caption = 'Line Type';
            OptionMembers = Plan,Ist;
        }
        field(302; Fixed; Boolean)
        {
            Caption = 'Fixed';
            ToolTip = 'Specifies the Fixed.';
        }
        field(303; Changed; Boolean)
        {
            Caption = 'Changed';
        }
        field(310; "First Month"; Boolean)
        {
            Caption = 'First Month';
        }
        field(311; "Last Month"; Boolean)
        {
            Caption = 'Last Month';
        }
        field(321; "Timestamp Planning Values"; DateTime)
        {
            Caption = 'Timestamp Planning Values';
        }
        field(322; "Timestamp Reference Values"; DateTime)
        {
            Caption = 'Timestamp Reference Values';

            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(325; "To Update (Plan)"; Boolean)
        {
            Caption = 'To Update (Plan)';
        }
        field(326; "To Update (Ref)"; Boolean)
        {
            Caption = 'To Update (Ref)';

            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(501; "Description 1"; Text[50])
        {
            Caption = 'Description 1';
            NotBlank = false;
            ToolTip = 'Specifies the Description.';
        }
        field(502; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
            NotBlank = false;
        }
        field(503; "Description 3"; Text[50])
        {
            Caption = 'Description 3';
            NotBlank = false;
        }
        field(504; "Description 4"; Text[50])
        {
            Caption = 'Description 4';
            NotBlank = false;
        }
        field(505; "Description 5"; Text[50])
        {
            Caption = 'Description 5';
            NotBlank = false;
        }
        field(506; "Description 6"; Text[50])
        {
            Caption = 'Description 6';
            NotBlank = false;
        }
        field(600; Comment; Text[100])
        {
            Caption = 'Comment';
        }
        field(2010; "Plan Sales Amount"; Decimal)
        {
            Caption = 'Plan Sales Amount';
            DecimalPlaces = 2 : 2;
            ToolTip = 'Specifies the Plan Sales Amount.';
            trigger OnValidate()
            begin
                CalcPlanValues_GC.EnterFromViewTable(Rec, FieldNo("Plan Sales Amount"), FieldNo("Plan Sales Amount"), xRec);
            end;
        }
        field(2011; "Plan Sal. Am. Difference %"; Decimal)
        {
            Caption = 'Plan Sal. Am. Difference %';
            ToolTip = 'Specifies the Plan Sal. Am. Difference %.';
            trigger OnValidate()
            begin
                CalcPlanValues_GC.EnterFromViewTable(Rec, FieldNo("Plan Sal. Am. Difference %"), FieldNo("Plan Sal. Am. Difference %"), xRec);
            end;
        }
        field(2012; "Plan Sal. Am. incl. Discount"; Decimal)
        {
            Caption = 'Plan Sal. Am. incl. Discount';
            ToolTip = 'Specifies the Plan Sal. Am. incl. Discount.';
            trigger OnValidate()
            begin
                CalcPlanValues_GC.EnterFromViewTable(Rec, FieldNo("Plan Sal. Am. incl. Discount"), FieldNo("Plan Sal. Am. incl. Discount"), xRec);
            end;
        }
        field(2013; "Plan Sales Amount Net"; Decimal)
        {
            Caption = 'Plan Sales Amount Net';
        }
        field(2014; "Plan Gross Profit"; Decimal)
        {
            Caption = 'Plan Gross Profit';
        }
        field(2015; "Plan Gross Profit Rate %"; Decimal)
        {
            Caption = 'Plan Gross Profit Rate %';
        }
        field(2016; "Plan Sales Percentage"; Decimal)
        {
            Caption = 'Plan Sales Percentage';
            ToolTip = 'Specifies the Plan Sales Percentage.';
            trigger OnValidate()
            begin
                CalcPlanValues_GC.EnterFromViewTable(Rec, FieldNo("Plan Sales Percentage"), FieldNo("Plan Sales Percentage"), xRec);
            end;
        }
        field(2020; "Plan Sales Discount"; Decimal)
        {
            Caption = 'Plan Sales Discount';
            DecimalPlaces = 2 : 2;
            ToolTip = 'Specifies the Plan Sales Discount.';
            trigger OnValidate()
            begin
                CalcPlanValues_GC.EnterFromViewTable(Rec, FieldNo("Plan Sales Discount"), FieldNo("Plan Sales Discount"), xRec);
            end;
        }
        field(2021; "Plan Sales Discount %"; Decimal)
        {
            Caption = 'Plan Sales Discount %';
            ToolTip = 'Specifies the Plan Sales Discount %.';
            trigger OnValidate()
            begin
                CalcPlanValues_GC.EnterFromViewTable(Rec, FieldNo("Plan Sales Discount %"), FieldNo("Plan Sales Discount %"), xRec);
            end;
        }
        field(2030; "Plan Sales Init. Inv."; Decimal)
        {
            Caption = 'Plan Sales Init. Inv.';
            ToolTip = 'Specifies the Plan Sales Init. Inv.';
            trigger OnValidate()
            begin
                CalcPlanValues_GC.EnterFromViewTable(Rec, FieldNo("Plan Sales Init. Inv."), FieldNo("Plan Sales Init. Inv."), xRec);
            end;
        }
        field(2031; "Plan Sales Closing Inv."; Decimal)
        {
            Caption = 'Plan Sales Closing Inv.';
            ToolTip = 'Specifies the Plan Sales Closing Inv.';
            trigger OnValidate()
            begin
                CalcPlanValues_GC.EnterFromViewTable(Rec, FieldNo("Plan Sales Closing Inv."), FieldNo("Plan Sales Closing Inv."), xRec);
            end;
        }
        field(2032; "Plan Sales Inv. Change"; Decimal)
        {
            Caption = 'Plan Sales Inv. Change';
            ToolTip = 'Specifies the Plan Sales Inv. Change.';
            trigger OnValidate()
            begin
                CalcPlanValues_GC.EnterFromViewTable(Rec, FieldNo("Plan Sales Inv. Change"), FieldNo("Plan Sales Inv. Change"), xRec);
            end;
        }
        field(2040; "Plan Gross Sales Pr. Reduction"; Decimal)
        {
            Caption = 'Plan Gross Sales Pr. Reduction';
            ToolTip = 'Specifies the Plan Gross Sales Pr. Reduction.';
            trigger OnValidate()
            begin
                CalcPlanValues_GC.EnterFromViewTable(Rec, FieldNo("Plan Gross Sales Pr. Reduction"), FieldNo("Plan Gross Sales Pr. Reduction"), xRec);
            end;
        }
        field(2041; "Plan Gross Sales Pr. Red. %"; Decimal)
        {
            Caption = 'Plan Gross Sales Pr. Red. %';
            ToolTip = 'Specifies the Plan VK BPA %.';
            trigger OnValidate()
            begin
                CalcPlanValues_GC.EnterFromViewTable(Rec, FieldNo("Plan Gross Sales Pr. Red. %"), FieldNo("Plan Gross Sales Pr. Red. %"), xRec);
            end;
        }
        field(2050; "Plan Sales Am. Purchase"; Decimal)
        {
            Caption = 'Plan Sales Am. Purchase';
            ToolTip = 'Specifies the Plan Sales Am. Purchase.';
            trigger OnValidate()
            begin
                CalcPlanValues_GC.EnterFromViewTable(Rec, FieldNo("Plan Sales Am. Purchase"), FieldNo("Plan Sales Am. Purchase"), xRec);
            end;
        }
        field(2051; "Plan Sales Am. Purch. 1"; Decimal)
        {
            Caption = 'Plan Sales Am. Purch. 1';

            trigger OnValidate()
            begin
                CalcPlanValues_GC.EnterFromViewTable(Rec, FieldNo("Plan Sales Am. Purch. 1"), FieldNo("Plan Sales Am. Purch. 1"), xRec);
            end;
        }
        field(2052; "Plan Sales Am. Purch. 2"; Decimal)
        {
            Caption = 'Plan Sales Am. Purch. 2';

            trigger OnValidate()
            begin
                CalcPlanValues_GC.EnterFromViewTable(Rec, FieldNo("Plan Sales Am. Purch. 2"), FieldNo("Plan Sales Am. Purch. 2"), xRec);
            end;
        }
        field(2053; "Plan Sales Am. Purch. 3"; Decimal)
        {
            Caption = 'Plan Sales Am. Purch. 3';

            trigger OnValidate()
            begin
                CalcPlanValues_GC.EnterFromViewTable(Rec, FieldNo("Plan Sales Am. Purch. 3"), FieldNo("Plan Sales Am. Purch. 3"), xRec);
            end;
        }
        field(2054; "Plan Sales Am. Purch. 4"; Decimal)
        {
            Caption = 'Plan Sales Am. Purch. 4';

            trigger OnValidate()
            begin
                CalcPlanValues_GC.EnterFromViewTable(Rec, FieldNo("Plan Sales Am. Purch. 4"), FieldNo("Plan Sales Am. Purch. 4"), xRec);
            end;
        }
        field(2055; "Plan Sales Am. Purch. 5"; Decimal)
        {
            Caption = 'Plan Sales Am. Purch. 5';

            trigger OnValidate()
            begin
                CalcPlanValues_GC.EnterFromViewTable(Rec, FieldNo("Plan Sales Am. Purch. 5"), FieldNo("Plan Sales Am. Purch. 5"), xRec);
            end;
        }
        field(2060; "Plan Sales Avg. Inv."; Decimal)
        {
            Caption = 'Plan Sales Avg. Inv.';
            ToolTip = 'Specifies the Plan Sales Avg. Inv.';
        }
        field(2061; "Plan Limit 1 %"; Decimal)
        {
            Caption = 'Plan Limit 1 %';
            ToolTip = 'Plan Limit 1 %';

            trigger OnValidate()
            begin
                CalcPlanValues_GC.EnterFromViewTable(Rec, FieldNo("Plan Limit 1 %"), FieldNo("Plan Limit 1 %"), xRec);
            end;
        }
        field(2062; "Plan Limit 2 %"; Decimal)
        {
            Caption = 'Plan Limit 2 %';
            ToolTip = 'Plan Limit 2 %';

            trigger OnValidate()
            begin
                CalcPlanValues_GC.EnterFromViewTable(Rec, FieldNo("Plan Limit 2 %"), FieldNo("Plan Limit 2 %"), xRec);
            end;
        }
        field(2063; "Plan Limit 3 %"; Decimal)
        {
            Caption = 'Plan Limit 3 %';
            ToolTip = 'Plan Limit 3 %';

            trigger OnValidate()
            begin
                CalcPlanValues_GC.EnterFromViewTable(Rec, FieldNo("Plan Limit 3 %"), FieldNo("Plan Limit 3 %"), xRec);
            end;
        }
        field(2064; "Plan Limit 4 %"; Decimal)
        {
            Caption = 'Plan Limit 4 %';
            ToolTip = 'Plan Limit 4 %';

            trigger OnValidate()
            begin
                CalcPlanValues_GC.EnterFromViewTable(Rec, FieldNo("Plan Limit 4 %"), FieldNo("Plan Limit 4 %"), xRec);
            end;
        }
        field(2065; "Plan Limit 5 %"; Decimal)
        {
            Caption = 'Plan Limit 5 %';
            ToolTip = 'Plan Limit 5 %';

            trigger OnValidate()
            begin
                CalcPlanValues_GC.EnterFromViewTable(Rec, FieldNo("Plan Limit 5 %"), FieldNo("Plan Limit 5 %"), xRec);
            end;
        }
        field(2110; "Plan Qty. Sale"; Decimal)
        {
            Caption = 'Plan Qty. Sale';
            ToolTip = 'Specifies the Plan Qty. Sale.';
            trigger OnValidate()
            begin
                CalcPlanValues_GC.EnterFromViewTable(Rec, FieldNo("Plan Qty. Sale"), FieldNo("Plan Qty. Sale"), xRec);
            end;
        }
        field(2111; "Plan Qty. Sale Diff. %"; Decimal)
        {
            Caption = 'Plan Qty. Sale Diff. %';
            ToolTip = 'Specifies the Plan Qty. Sale Diff. %.';
            trigger OnValidate()
            begin
                CalcPlanValues_GC.EnterFromViewTable(Rec, FieldNo("Plan Qty. Sale Diff. %"), FieldNo("Plan Qty. Sale Diff. %"), xRec);
            end;
        }
        field(2130; "Plan Qty. Init. Inv."; Decimal)
        {
            Caption = 'Plan Qty. Init. Inv.';
            ToolTip = 'Specifies the Plan Qty. Init. Inv.';
            trigger OnValidate()
            begin
                CalcPlanValues_GC.EnterFromViewTable(Rec, FieldNo("Plan Qty. Init. Inv."), FieldNo("Plan Qty. Init. Inv."), xRec);
            end;
        }
        field(2131; "Plan Qty. Closing Inv."; Decimal)
        {
            Caption = 'Plan Qty. Closing Inv.';
            ToolTip = 'Specifies the Plan Qty. Closing Inv.';
            trigger OnValidate()
            begin
                CalcPlanValues_GC.EnterFromViewTable(Rec, FieldNo("Plan Qty. Closing Inv."), FieldNo("Plan Qty. Closing Inv."), xRec);
            end;
        }
        field(2132; "Plan Qty. Inv. Change"; Decimal)
        {
            Caption = 'Plan Qty. Inv. Change';
            ToolTip = 'Specifies the Plan Qty. Inv. Change.';
            trigger OnValidate()
            begin
                CalcPlanValues_GC.EnterFromViewTable(Rec, FieldNo("Plan Qty. Inv. Change"), FieldNo("Plan Qty. Inv. Change"), xRec);
            end;
        }
        field(2133; "Plan Qty. Closing Inv. %"; Decimal)
        {
            Caption = 'Plan Qty. Closing Inv. %';
            ToolTip = 'Specifies the Plan Qty. Closing Inv. %.';
            trigger OnValidate()
            begin
                CalcPlanValues_GC.EnterFromViewTable(Rec, FieldNo("Plan Qty. Closing Inv. %"), FieldNo("Plan Qty. Closing Inv. %"), xRec);
            end;
        }
        field(2150; "Plan Qty. Purchase"; Decimal)
        {
            Caption = 'Plan Qty. Purchase';
            ToolTip = 'Specifies the Plan Qty. Purchase.';
            trigger OnValidate()
            begin
                CalcPlanValues_GC.EnterFromViewTable(Rec, FieldNo("Plan Qty. Purchase"), FieldNo("Plan Qty. Purchase"), xRec);
            end;
        }
        field(2160; "Plan Qty. Avg. Inv."; Decimal)
        {
            Caption = 'Plan Qty. Avg. Inv.';
            ToolTip = 'Specifies the Plan Qty. Avg. Inv.';
        }
        field(2210; "Plan Cost of Sales"; Decimal)
        {
            Caption = 'Plan Cost of Sales';
            ToolTip = 'Specifies the Plan Cost of Sales.';
            trigger OnValidate()
            begin
                CalcPlanValues_GC.EnterFromViewTable(Rec, FieldNo("Plan Cost of Sales"), FieldNo("Plan Cost of Sales"), xRec);
            end;
        }
        field(2211; "Plan Cost of Sales %"; Decimal)
        {
            Caption = 'Plan Cost of Sales %';
            ToolTip = 'Specifies the Plan Cost of Sales %.';
            trigger OnValidate()
            begin
                CalcPlanValues_GC.EnterFromViewTable(Rec, FieldNo("Plan Cost of Sales %"), FieldNo("Plan Cost of Sales %"), xRec);
            end;
        }
        field(2230; "Plan Cost Init. Inv."; Decimal)
        {
            Caption = 'Plan Cost Init. Inv.';
            ToolTip = 'Specifies the Plan Cost Init. Inv.';
            trigger OnValidate()
            begin
                CalcPlanValues_GC.EnterFromViewTable(Rec, FieldNo("Plan Cost Init. Inv."), FieldNo("Plan Cost Init. Inv."), xRec);
            end;
        }
        field(2231; "Plan Cost Closing Inv."; Decimal)
        {
            Caption = 'Plan Cost Closing Inv.';
            ToolTip = 'Specifies the Plan Cost Closing Inv.';
            trigger OnValidate()
            begin
                CalcPlanValues_GC.EnterFromViewTable(Rec, FieldNo("Plan Cost Closing Inv."), FieldNo("Plan Cost Closing Inv."), xRec);
            end;
        }
        field(2232; "Plan Cost Inv. Change"; Decimal)
        {
            Caption = 'Plan Cost Inv. Change';
            ToolTip = 'Specifies the Plan Cost Inv. Change.';
            trigger OnValidate()
            begin
                CalcPlanValues_GC.EnterFromViewTable(Rec, FieldNo("Plan Cost Inv. Change"), FieldNo("Plan Cost Inv. Change"), xRec);
            end;
        }
        field(2250; "Plan Cost Am. Purchase"; Decimal)
        {
            Caption = 'Plan Cost Amount Purchase';
            ToolTip = 'Specifies the Plan Cost Am. Purchase.';
            trigger OnValidate()
            begin
                CalcPlanValues_GC.EnterFromViewTable(Rec, FieldNo("Plan Cost Am. Purchase"), FieldNo("Plan Cost Am. Purchase"), xRec);
            end;
        }
        field(2251; "Plan Cost Am. Purch. 1"; Decimal)
        {
            Caption = 'Plan Cost Amount Purchase 1';
            ToolTip = 'Plan Cost Amount Purchase 1';

            trigger OnValidate()
            begin
                CalcPlanValues_GC.EnterFromViewTable(Rec, FieldNo("Plan Cost Am. Purch. 1"), FieldNo("Plan Cost Am. Purch. 1"), xRec);
            end;
        }
        field(2252; "Plan Cost Am. Purch. 2"; Decimal)
        {
            Caption = 'Plan Cost Amount Purchase 2';
            ToolTip = 'Plan Cost Amount Purchase 2';

            trigger OnValidate()
            begin
                CalcPlanValues_GC.EnterFromViewTable(Rec, FieldNo("Plan Cost Am. Purch. 2"), FieldNo("Plan Cost Am. Purch. 2"), xRec);
            end;
        }
        field(2253; "Plan Cost Am. Purch. 3"; Decimal)
        {
            Caption = 'Plan Cost Amount Purchase 3';
            ToolTip = 'Plan Cost Amount Purchase 3';

            trigger OnValidate()
            begin
                CalcPlanValues_GC.EnterFromViewTable(Rec, FieldNo("Plan Cost Am. Purch. 3"), FieldNo("Plan Cost Am. Purch. 3"), xRec);
            end;
        }
        field(2254; "Plan Cost Am. Purch. 4"; Decimal)
        {
            Caption = 'Plan Cost Amount Purchase 4';
            ToolTip = 'Plan Cost Amount Purchase 4';

            trigger OnValidate()
            begin
                CalcPlanValues_GC.EnterFromViewTable(Rec, FieldNo("Plan Cost Am. Purch. 4"), FieldNo("Plan Cost Am. Purch. 4"), xRec);
            end;
        }
        field(2255; "Plan Cost Am. Purch. 5"; Decimal)
        {
            Caption = 'Plan Cost Amount Purchase 5';
            ToolTip = 'Plan Cost Amount Purchase 5';

            trigger OnValidate()
            begin
                CalcPlanValues_GC.EnterFromViewTable(Rec, FieldNo("Plan Cost Am. Purch. 5"), FieldNo("Plan Cost Am. Purch. 5"), xRec);
            end;
        }
        field(2260; "Plan Cost Avg. Inv."; Decimal)
        {
            Caption = 'Plan Cost Avg. Inv.';
            ToolTip = 'Specifies the Plan Cost Avg. Inv.';
        }
        field(2310; "Plan S.Price Sales"; Decimal)
        {
            Caption = 'Plan S.Price Sales';
            ToolTip = 'Specifies the Plan S.Price Sales.';
            trigger OnValidate()
            begin
                CalcPlanValues_GC.EnterFromViewTable(Rec, FieldNo("Plan S.Price Sales"), FieldNo("Plan S.Price Sales"), xRec);
            end;
        }
        field(2320; "Plan S.Price incl. Discount"; Decimal)
        {
            Caption = 'Plan S.Price incl. Discount';
            ToolTip = 'Specifies the Plan S.Price incl. Discount.';
            trigger OnValidate()
            begin
                CalcPlanValues_GC.EnterFromViewTable(Rec, FieldNo("Plan S.Price incl. Discount"), FieldNo("Plan S.Price incl. Discount"), xRec);
            end;
        }
        field(2330; "Plan S.Price Purchase"; Decimal)
        {
            Caption = 'Plan S.Price Purchase';
            ToolTip = 'Specifies the Plan S.Price Purchase.';
            trigger OnValidate()
            begin
                CalcPlanValues_GC.EnterFromViewTable(Rec, FieldNo("Plan S.Price Purchase"), FieldNo("Plan S.Price Purchase"), xRec);
            end;
        }
        field(2340; "Plan S.Price Init. Inv."; Decimal)
        {
            Caption = 'Plan S.Price Init. Inv.';

            ObsoleteState = Pending;
            ObsoleteTag = '22.4';
            ObsoleteReason = '#19247 Pending removal - field will be removed in future updates';
            ToolTip = 'Specifies the Plan S.Price Init. Inv.';
            trigger OnValidate()
            begin
                CalcPlanValues_GC.EnterFromViewTable(Rec, FieldNo("Plan S.Price Init. Inv."), FieldNo("Plan S.Price Init. Inv."), xRec);
            end;
        }
        field(2350; "Plan S.Price Closing Inv."; Decimal)
        {
            Caption = 'Plan S.Price Closing Inv.';

            ObsoleteState = Pending;
            ObsoleteTag = '22.4';
            ObsoleteReason = '#19247 Pending removal - field will be removed in future updates';
            ToolTip = 'Specifies the Plan S.Price Closing Inv.';
        }
        field(2410; "Plan P.Price Sales"; Decimal)
        {
            Caption = 'Plan P.Price Sales';
            ToolTip = 'Specifies the Plan P.Price Sales.';
            trigger OnValidate()
            begin
                CalcPlanValues_GC.EnterFromViewTable(Rec, FieldNo("Plan P.Price Sales"), FieldNo("Plan P.Price Sales"), xRec);
            end;
        }
        field(2430; "Plan P.Price Purchase"; Decimal)
        {
            Caption = 'Plan P.Price Purchase';
            ToolTip = 'Specifies the Plan P.Price Purchase.';
            trigger OnValidate()
            begin
                CalcPlanValues_GC.EnterFromViewTable(Rec, FieldNo("Plan P.Price Purchase"), FieldNo("Plan P.Price Purchase"), xRec);
            end;
        }
        field(2440; "Plan P.Price Init. Inv."; Decimal)
        {
            Caption = 'Plan P.Price Init. Inv.';

            ObsoleteState = Pending;
            ObsoleteTag = '22.4';
            ObsoleteReason = '#19247 Pending removal - field will be removed in future updates';
            ToolTip = 'Specifies the Plan P.Price Init. Inv.';
            trigger OnValidate()
            begin
                CalcPlanValues_GC.EnterFromViewTable(Rec, FieldNo("Plan P.Price Init. Inv."), FieldNo("Plan P.Price Init. Inv."), xRec);
            end;
        }
        field(2450; "Plan P.Price Closing Inv."; Decimal)
        {
            Caption = 'Plan P.Price Closing Inv.';

            ObsoleteState = Pending;
            ObsoleteTag = '22.4';
            ObsoleteReason = '#19247 Pending removal - field will be removed in future updates';
            ToolTip = 'Specifies the Plan P.Price Closing Inv.';
        }
        field(2510; "Plan Inv. Turnover"; Decimal)
        {
            Caption = 'Plan Inv. Turnover';
            ToolTip = 'Specifies the Plan Inv. Turnover.';
        }
        field(2514; "Plan Purch. Limit 1"; Decimal)
        {
            ObsoleteState = Pending;
            ObsoleteTag = '25.2';
            ObsoleteReason = '#35131 Pending removal - field will be removed in future updates';

            Caption = 'Plan Purch. Limit 1';
            ToolTip = 'Specifies the Plan Purch. Limit 1.';
        }
        field(2515; "Plan Purch. Limit 2"; Decimal)
        {
            ObsoleteState = Pending;
            ObsoleteTag = '25.2';
            ObsoleteReason = '#35131 Pending removal - field will be removed in future updates';

            Caption = 'Plan Purch. Limit 2';
            ToolTip = 'Specifies the Plan Purch. Limit 2.';
        }
        field(2516; "Plan Purch. Limit 3"; Decimal)
        {
            ObsoleteState = Pending;
            ObsoleteTag = '25.2';
            ObsoleteReason = '#35131 Pending removal - field will be removed in future updates';

            Caption = 'Plan Purch. Limit 3';
            ToolTip = 'Specifies the Plan Purch. Limit 3.';
        }
        field(2517; "Plan Purch. Limit 4"; Decimal)
        {
            ObsoleteState = Pending;
            ObsoleteTag = '25.2';
            ObsoleteReason = '#35131 Pending removal - field will be removed in future updates';

            Caption = 'Plan Purch. Limit 4';
            ToolTip = 'Specifies the Plan Purch. Limit 4.';
        }
        field(2518; "Plan Purch. Limit 5"; Decimal)
        {
            ObsoleteState = Pending;
            ObsoleteTag = '25.2';
            ObsoleteReason = '#35131 Pending removal - field will be removed in future updates';

            Caption = 'Plan Purch. Limit 5';
            ToolTip = 'Specifies the Plan Purch. Limit 5.';
        }
        field(2520; "Plan Calc. Sales %"; Decimal)
        {
            Caption = 'Plan Calc. Sales %';
            ToolTip = 'Specifies the Plan Calc. Sales %.';
            trigger OnValidate()
            begin
                CalcPlanValues_GC.EnterFromViewTable(Rec, FieldNo("Plan Calc. Sales %"), FieldNo("Plan Calc. Sales %"), xRec);
            end;
        }
        field(2530; "Plan Calc. Sales incl. Disc. %"; Decimal)
        {
            Caption = 'Plan Calc. Sales incl. Disc. %';
            ToolTip = 'Specifies the Plan Calc. Sales incl. Disc. %.';
            trigger OnValidate()
            begin
                CalcPlanValues_GC.EnterFromViewTable(Rec, FieldNo("Plan Calc. Sales incl. Disc. %"), FieldNo("Plan Calc. Sales incl. Disc. %"), xRec);
            end;
        }
        field(2540; "Plan Calc. Purchase %"; Decimal)
        {
            Caption = 'Plan Calc. Purchase %';
            ToolTip = 'Specifies the Plan Calc. Purchase %.';
            trigger OnValidate()
            begin
                CalcPlanValues_GC.EnterFromViewTable(Rec, FieldNo("Plan Calc. Purchase %"), FieldNo("Plan Calc. Purchase %"), xRec);
            end;
        }
        field(2550; "Plan Calc. Init. Inv. %"; Decimal)
        {
            Caption = 'Plan Calc. Init. Inv. %';

            ObsoleteState = Pending;
            ObsoleteTag = '22.4';
            ObsoleteReason = '#19247 Pending removal - field will be removed in future updates';
            ToolTip = 'Specifies the Plan Calc. Init. Inv. %.';
            trigger OnValidate()
            begin
                CalcPlanValues_GC.EnterFromViewTable(Rec, FieldNo("Plan Calc. Init. Inv. %"), FieldNo("Plan Calc. Init. Inv. %"), xRec);
            end;
        }
        field(2560; "Plan Calc. Closing Inv. %"; Decimal)
        {
            Caption = 'Plan Calc. Closing Inv. %';

            ObsoleteState = Pending;
            ObsoleteTag = '22.4';
            ObsoleteReason = '#19247 Pending removal - field will be removed in future updates';
            ToolTip = 'Specifies the Plan Calc. Closing Inv. %.';
            trigger OnValidate()
            begin
                CalcPlanValues_GC.EnterFromViewTable(Rec, FieldNo("Plan Calc. Closing Inv. %"), FieldNo("Plan Calc. Closing Inv. %"), xRec);
            end;
        }
        field(2660; "Plan Sales Order Amount"; Decimal)
        {
            Caption = 'Plan Sales Order Amount';
        }
        field(2661; "Plan Sales Order Qty."; Decimal)
        {
            Caption = 'Plan Sales Order Qty.';
        }
        field(3010; "Ref. Sales Amount"; Decimal)
        {
            Caption = 'Ref. Sales Amount';
            DecimalPlaces = 0 : 5;
            ToolTip = 'Specifies the Ref. Sales Amount.';
        }
        field(3012; "Ref. Sal. Am. incl. Discount"; Decimal)
        {
            Caption = 'Ref. Sal. Am. incl. Discount';
            ToolTip = 'Specifies the Ref. Sal. Am. incl. Discount.';
        }
        field(3013; "Ref. Sales Amount Net"; Decimal)
        {
            Caption = 'Ref. Sales Amount Net';
        }
        field(3014; "Ref. Gross Profit"; Decimal)
        {
            Caption = 'Ref. Gross Profit';
        }
        field(3015; "Ref. Gross Profit Rate %"; Decimal)
        {
            Caption = 'Ref. Gross Profit Rate %';
        }
        field(3016; "Ref. Sales Percentage"; Decimal)
        {
            Caption = 'Ref. Sales Percentage';
            ToolTip = 'Specifies the Ref. Sales Percentage.';
        }
        field(3020; "Ref. Sales Discount"; Decimal)
        {
            Caption = 'Ref. Sales Discount';
            DecimalPlaces = 0 : 5;
            ToolTip = 'Specifies the Ref. Sales Discount.';
        }
        field(3021; "Ref. Sales Discount %"; Decimal)
        {
            Caption = 'Ref. Sales Discount %';
            ToolTip = 'Specifies the Ref. Sales Discount %.';
        }
        field(3030; "Ref. Sales Init. Inv."; Decimal)
        {
            Caption = 'Ref. Sales Init. Inv.';
            ToolTip = 'Specifies the Ref. Sales Init. Inv.';
        }
        field(3031; "Ref. Sales Closing Inv."; Decimal)
        {
            Caption = 'Ref. Sales Closing Inv.';
            ToolTip = 'Specifies the Ref. Sales Closing Inv.';
        }
        field(3032; "Ref. Sales Inv. Change"; Decimal)
        {
            Caption = 'Ref. Sales Inv. Change';
            ToolTip = 'Specifies the Ref. Sales Inv. Change.';
        }
        field(3040; "Ref. Gross Sales Pr. Reduction"; Decimal)
        {
            Caption = 'Ref. Gross Sales Pr. Reduction';
            ToolTip = 'Specifies the Ref. Gross Sales Pr. Reduction.';
        }
        field(3041; "Ref. Gross Sales Pr. Red. %"; Decimal)
        {
            Caption = 'Ref. Gross Sales Pr. Red. %';
            ToolTip = 'Specifies the Ref. Gross Sales Pr. Red. %.';
        }
        field(3050; "Ref. Sales Am. Purchase"; Decimal)
        {
            Caption = 'Ref. Sales Am. Purchase';
            ToolTip = 'Specifies the Ref. Sales Am. Purchase.';
        }
        field(3060; "Ref. Sales Avg. Inv."; Decimal)
        {
            Caption = 'Ref. Sales Avg. Inv.';
            ToolTip = 'Specifies the Ref. Sales Avg. Inv.';
        }
        field(3110; "Ref. Qty. Sale"; Decimal)
        {
            Caption = 'Ref. Qty. Sale';
            ToolTip = 'Specifies the Ref. Qty. Sale.';
        }
        field(3130; "Ref. Qty. Init. Inv."; Decimal)
        {
            Caption = 'Ref. Qty. Init. Inv.';
            ToolTip = 'Specifies the Ref. Qty. Init. Inv.';
        }
        field(3131; "Ref. Qty. Closing Inv."; Decimal)
        {
            Caption = 'Ref. Qty. Closing Inv.';
            ToolTip = 'Specifies the Ref. Qty. Closing Inv.';
        }
        field(3132; "Ref. Qty. Inv. Change"; Decimal)
        {
            Caption = 'Ref. Qty. Inv. Change';
            ToolTip = 'Specifies the Ref. Qty. Inv. Change.';
        }
        field(3133; "Ref. Qty. Closing Inv. %"; Decimal)
        {
            Caption = 'Ref. Qty. Closing Inv. %';
            ToolTip = 'Specifies the Ref. Qty. Closing Inv. %.';
        }
        field(3150; "Ref. Qty. Purchase"; Decimal)
        {
            Caption = 'Ref. Qty. Purchase';
            ToolTip = 'Specifies the Ref. Qty. Purchase.';
        }
        field(3160; "Ref. Qty. Avg. Inv."; Decimal)
        {
            Caption = 'Ref. Qty. Avg. Inv.';
            ToolTip = 'Specifies the Ref. Qty. Avg. Inv.';
        }
        field(3210; "Ref. Cost of Sales"; Decimal)
        {
            Caption = 'Ref. Cost of Sales';
            ToolTip = 'Specifies the Ref. Cost of Sales.';
        }
        field(3230; "Ref. Cost Init. Inv."; Decimal)
        {
            Caption = 'Ref. Cost Init. Inv.';
            ToolTip = 'Specifies the Ref. Cost Init. Inv.';
        }
        field(3231; "Ref. Cost Closing Inv."; Decimal)
        {
            Caption = 'Ref. Cost Closing Inv.';
            ToolTip = 'Specifies the Ref. Cost Closing Inv.';
        }
        field(3232; "Ref. Cost Inv. Change"; Decimal)
        {
            Caption = 'Ref. Cost Inv. Change';
            ToolTip = 'Specifies the Ref. Cost Inv. Change.';
        }
        field(3250; "Ref. Cost Am. Purchase"; Decimal)
        {
            Caption = 'Ref. Cost Val. Purchase';
            ToolTip = 'Specifies the Ref. Cost Am. Purchase.';
        }
        field(3260; "Ref. Cost Avg. Inv."; Decimal)
        {
            Caption = 'Ref. Cost Avg. Inv.';
            ToolTip = 'Specifies the Ref. Cost Avg. Inv.';
        }
        field(3310; "Ref. S.Price Sales"; Decimal)
        {
            Caption = 'Ref. S.Price Sales';
            ToolTip = 'Specifies the Ref. S.Price Sales.';
        }
        field(3320; "Ref. S.Price incl. Discount"; Decimal)
        {
            Caption = 'Ref. S.Price incl. Discount';
            ToolTip = 'Specifies the Ref. S.Price incl. Discount.';
        }
        field(3330; "Ref. S.Price Purchase"; Decimal)
        {
            Caption = 'Ref. S.Price Purchase';
            ToolTip = 'Specifies the Ref. S.Price Purchase.';
        }
        field(3340; "Ref. S.Price Init. Inv."; Decimal)
        {
            Caption = 'Ref. S.Price Init. Inv.';

            ObsoleteState = Pending;
            ObsoleteTag = '22.4';
            ObsoleteReason = '#19247 Pending removal - field will be removed in future updates';
            ToolTip = 'Specifies the Ref. S.Price Init. Inv.';
        }
        field(3350; "Ref. S.Price Closing Inv."; Decimal)
        {
            Caption = 'Ref. S.Price Closing Inv.';

            ObsoleteState = Pending;
            ObsoleteTag = '22.4';
            ObsoleteReason = '#19247 Pending removal - field will be removed in future updates';
            ToolTip = 'Specifies the Ref. S.Price Closing Inv.';
        }
        field(3410; "Ref. P.Price Sales"; Decimal)
        {
            Caption = 'Ref. P.Price Sales';
            ToolTip = 'Specifies the Ref. P.Price Sales.';
        }
        field(3430; "Ref. P.Price Purchase"; Decimal)
        {
            Caption = 'Ref. P.Price Purchase';
            ToolTip = 'Specifies the Ref. P.Price Purchase.';
        }
        field(3440; "Ref. P.Price Init. Inv."; Decimal)
        {
            Caption = 'Ref. P.Price Init. Inv.';

            ObsoleteState = Pending;
            ObsoleteTag = '22.4';
            ObsoleteReason = '#19247 Pending removal - field will be removed in future updates';
            ToolTip = 'Specifies the Ref. P.Price Init. Inv.';
        }
        field(3450; "Ref. P.Price Closing Inv."; Decimal)
        {
            Caption = 'Ref. P.Price Closing Inv.';

            ObsoleteState = Pending;
            ObsoleteTag = '22.4';
            ObsoleteReason = '#19247 Pending removal - field will be removed in future updates';
            ToolTip = 'Specifies the Ref. P.Price Closing Inv.';
        }
        field(3510; "Ref. Inv. Turnover"; Decimal)
        {
            Caption = 'Ref. Inv. Turnover';
            ToolTip = 'Specifies the Ref. Inv. Turnover.';
        }
        field(3520; "Ref. Calc. Sales %"; Decimal)
        {
            Caption = 'Ref. Calc. Sales %';
            ToolTip = 'Specifies the Ref. Calc. Sales %.';
        }
        field(3530; "Ref. Calc. Sales incl. Disc. %"; Decimal)
        {
            Caption = 'Ref. Calc. Sales incl. Disc. %';
            ToolTip = 'Specifies the Ref. Calc. Sales incl. Disc. %.';
        }
        field(3540; "Ref. Calc. Purchase %"; Decimal)
        {
            Caption = 'Ref. Calc. Purchase %';
            ToolTip = 'Specifies the Ref. Calc. Purchase %.';
        }
        field(3550; "Ref. Calc. Init. Inv. %"; Decimal)
        {
            Caption = 'Ref. Calc. Init. Inv. %';

            ObsoleteState = Pending;
            ObsoleteTag = '22.4';
            ObsoleteReason = '#19247 Pending removal - field will be removed in future updates';
            ToolTip = 'Specifies the Ref. Calc. Init. Inv. %.';
        }
        field(3560; "Ref. Calc. Closing Inv. %"; Decimal)
        {
            Caption = 'Ref. Calc. Closing Inv. %';

            ObsoleteState = Pending;
            ObsoleteTag = '22.4';
            ObsoleteReason = '#19247 Pending removal - field will be removed in future updates';
            ToolTip = 'Specifies the Ref. Calc. Closing Inv. %.';
        }
        field(3570; "Ref. Sales Order Amount"; Decimal)
        {
            Caption = 'Ref. Sales Order Amount';
        }
        field(3571; "Ref. Sales Order Qty."; Decimal)
        {
            Caption = 'Ref. Sales Order Qty.';
        }
        field(3700; "Purch. Order Outst. Qty."; Decimal)
        {
            Caption = 'Purch. Order Outst. Qty.';
            ToolTip = 'Specifies the Purch. Order Outst. Qty.';
        }
        field(3710; "Purch. Order Outst. Amt."; Decimal)
        {
            Caption = 'Purch. Order Outst. Amt.';
            ToolTip = 'Specifies the Purch. Order Outst. Amt.';
        }
        field(3720; "Purch. Order Outst. Amt. Net."; Decimal)
        {
            Caption = 'Purch. Order Outst. Amt. Net.';
            ToolTip = 'Specifies the Purch. Order Outst. Amt. Net.';
        }
        field(4000; "Actual Sales Amount"; Decimal)
        {
            Caption = 'Actual Sales Amount';
            ToolTip = 'Specifies the Actual Sales Amount.';
        }
        field(4001; "Actual Sal. Am. Discount"; Decimal)
        {
            Caption = 'Actual Sal. Am. Discount';
            ToolTip = 'Specifies the Actual Sal. Am. Discount.';
        }
        field(4002; "Actual Gross Sales Pr. Red."; Decimal)
        {
            Caption = 'Actual Gross Sales Pr. Red.';
            ToolTip = 'Specifies the Actual Gross Sales Pr. Red.';
        }
        field(4003; "Actual Sales Am. Purchase"; Decimal)
        {
            Caption = 'Actual Sal. Am. Purch.';
            ToolTip = 'Specifies the Actual Sales Am. Purchase.';
        }
        field(4004; "Actual Sales Init. Inv."; Decimal)
        {
            Caption = 'Actual Sales Init. Inv.';
            ToolTip = 'Specifies the Actual Sales Init. Inv.';
        }
        field(4005; "Actual Sales Closing Inv."; Decimal)
        {
            Caption = 'Actual Sales Closing Inv.';
            ToolTip = 'Specifies the Actual Sales Closing Inv.';
        }
        field(4006; "Actual Sales Amount Net"; Decimal)
        {
            Caption = 'Actual Sales Amount Net';
            ToolTip = 'Specifies the Actual Sales Amount Net.';
        }
        field(4010; "Actual Cost of Sales"; Decimal)
        {
            Caption = 'Actual Cost of Sales';
            ToolTip = 'Specifies the Actual Cost of Sales.';
        }
        field(4011; "Actual Cost Am. Purchase"; Decimal)
        {
            Caption = 'Actual Cost Am. Purchase';
            ToolTip = 'Specifies the Actual Cost Am. Purchase.';
        }
        field(4012; "Actual Cost Init. Inv."; Decimal)
        {
            Caption = 'Actual Cost Init. Inv.';
            ToolTip = 'Specifies the Actual Cost Init. Inv.';
        }
        field(4013; "Actual Cost Closing Inv."; Decimal)
        {
            Caption = 'Actual Cost Inv.';
            ToolTip = 'Specifies the Actual Cost Closing Inv.';
        }
        field(4020; "Actual Qty. Sale"; Decimal)
        {
            Caption = 'Actual Qty. Turnover';
            ToolTip = 'Specifies the Actual Qty. Sale.';
        }
        field(4021; "Actual Qty. Purchase"; Decimal)
        {
            Caption = 'Actual Qty. Purchase';
            ToolTip = 'Specifies the Actual Qty. Purchase.';
        }
        field(4022; "Actual Qty. Init. Inv."; Decimal)
        {
            Caption = 'Actual Qty. Init. Inv.';
            ToolTip = 'Specifies the Actual Qty. Init. Inv.';
        }
        field(4023; "Actual Qty. Closing Inv."; Decimal)
        {
            Caption = 'Actual Qty. Closing Inv.';
            ToolTip = 'Specifies the Actual Qty. Closing Inv.';
        }
        field(5000; "Free Purchase Limit"; Decimal)
        {
            Caption = 'Free Purchase Limit';

            ObsoleteState = Removed;
            ObsoleteTag = '22.4';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the LimitEK_Control.';
        }
        field(6000; "Plan Target Sales Amount"; Decimal)
        {
            Caption = 'Plan Target Sales Amount';
            ToolTip = 'Specifies the Plan Target Sales Amount.';
        }
        field(6001; "Plan Target Sales Am. Net"; Decimal)
        {
            Caption = 'Plan Target Sales Am. Net';
        }
        field(6002; "Plan Target Discount"; Decimal)
        {
            Caption = 'Plan Target Discount';
            ToolTip = 'Specifies the Plan Target Discount.';
        }
        field(6003; "Plan Target Discount Net"; Decimal)
        {
            Caption = 'Plan Target Discount Net';
        }
        field(6004; "Plan Target Sales Init. Inv."; Decimal)
        {
            Caption = 'Plan Target Sales Init. Inv.';
            ToolTip = 'Specifies the Plan Target Sales Init. Inv.';
        }
        field(6005; "Plan Target Sales Closing Inv."; Decimal)
        {
            Caption = 'Plan Target Sales Inv.';
            ToolTip = 'Specifies the Plan Target Sales Closing Inv.';
        }
        field(6006; "Plan Target G.S.P. Reduction"; Decimal)
        {
            Caption = 'Plan Target G.S.P. Reduction';
            ToolTip = 'Specifies the Plan Target G.S.P. Reduction.';
        }
        field(6007; "Plan Target Sal. Am. Purch."; Decimal)
        {
            Caption = 'Plan Target Sal. Am. Purch.';
            ToolTip = 'Specifies the Plan Target Sal. Am. Purch.';
        }
        field(6010; "Plan Target Qty. Sale"; Decimal)
        {
            Caption = 'Plan Target Qty. Turnover';
            ToolTip = 'Specifies the Plan Target Qty. Sale.';
        }
        field(6011; "Plan Target Qty. Init. Inv."; Decimal)
        {
            Caption = 'Plan Target Qty. Init. Inv.';
            ToolTip = 'Specifies the Plan Target Qty. Init. Inv.';
        }
        field(6012; "Plan Target Qty. Closing Inv."; Decimal)
        {
            Caption = 'Plan Target Qty. Closing Inv.';
            ToolTip = 'Specifies the Plan Target Qty. Closing Inv.';
        }
        field(6013; "Plan Target Qty. Purchase"; Decimal)
        {
            Caption = 'Plan Target Qty. Purchase';
            ToolTip = 'Specifies the Plan Target Qty. Purchase.';
        }
        field(6020; "Plan Target Cost of Sales"; Decimal)
        {
            Caption = 'Plan Target Cost of Sales';
            ToolTip = 'Specifies the Plan Target Cost of Sales.';
        }
        field(6021; "Plan Target Cost Init. Inv."; Decimal)
        {
            Caption = 'Plan Target Cost Init. Inv.';
            ToolTip = 'Specifies the Plan Target Cost Init. Inv.';
        }
        field(6022; "Plan Target Cost Closing Inv."; Decimal)
        {
            Caption = 'Plan Target Cost Inv.';
            ToolTip = 'Specifies the Plan Target Cost Closing Inv.';
        }
        field(6023; "Plan Target Cost Am. Purch."; Decimal)
        {
            Caption = 'Plan Target Cost Val. Purch.';
            ToolTip = 'Specifies the Plan Target Cost Am. Purch.';
        }
        field(10000; "Proj. Sales Closing Inv."; Decimal)
        {
            Caption = 'Proj. Sales Closing Inv.';
        }
        field(10001; "Proj. Cost Closing Inv."; Decimal)
        {
            Caption = 'Proj. Cost Closing Inv.';
            ToolTip = 'Specifies the Proj. Cost Closing Inv.';
        }
        field(10002; "Proj. Qty. Closing Inv."; Decimal)
        {
            Caption = 'Proj. Qty. Closing Inv.';
        }
        field(10003; "Proj. Sales Amount"; Decimal)
        {
            Caption = 'Proj. Sales Amount';
            ToolTip = 'Specifies the Proj. Sales Amount.';
        }
    }

    keys
    {
        key(Key1; "View Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Planning Document No.")
        {
        }
        key(Key3; "Planning Document No.", "Line Type")
        {
        }
        key(Key4; "Planning Document No.", Date, "Fixed")
        {
        }
        key(Key5; "Planning Document No.", "Planning Document Level", "Index 1", "Index 2", "Index 3", "Index 4", "Index 5", "Index 6", Date)
        {
            IncludedFields = "Plan Sales Amount", "Plan Sal. Am. incl. Discount", "Plan Sales Amount Net", "Plan Gross Profit", "Plan Sales Discount", "Plan Sales Init. Inv.", "Plan Sales Closing Inv.", "Plan Gross Sales Pr. Reduction", "Plan Sales Am. Purchase", "Plan Qty. Sale", "Plan Qty. Init. Inv.", "Plan Qty. Closing Inv.", "Plan Qty. Purchase", "Plan Cost of Sales", "Plan Cost Init. Inv.", "Plan Cost Closing Inv.", "Plan Cost Am. Purchase";
        }
        key(Key6; "Planning Document Level", "Planning Document No.", "Index 1", "Index 2", "Index 3", "Index 4", "Index 5", "Index 6", Date)
        {
            IncludedFields = "Ref. Sales Amount", "Ref. Sal. Am. incl. Discount", "Ref. Sales Amount Net", "Ref. Gross Profit", "Ref. Sales Discount", "Ref. Sales Init. Inv.", "Ref. Sales Closing Inv.", "Ref. Gross Sales Pr. Reduction", "Ref. Sales Am. Purchase", "Ref. Qty. Sale", "Ref. Qty. Init. Inv.", "Ref. Qty. Closing Inv.", "Ref. Qty. Purchase", "Ref. Cost of Sales", "Ref. Cost Init. Inv.", "Ref. Cost Closing Inv.", "Ref. Cost Am. Purchase";
        }
        key(Key7; "Planning Document No.", "Planning Document Level", "Timestamp Planning Values", Changed)
        {
        }
        key(Key8; "Planning Document No.", "Planning Document Level", "To Update (Plan)", Date, "Timestamp Planning Values")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnModify()
    var
        PlanDoc_LT: Record "BET FN Planning Document";
        PlanFunctions_LC: Codeunit "BET FN Planning Functions";
        IsHandled: Boolean;
        AlterationOfFixedLinesNotAllowedErr: Label 'Alteration of fixed lines not allowed.';
    begin
        OnBeforeModify(Rec, xRec, IsHandled);
        if IsHandled then
            exit;

        // Ändern von Ist-Zeilen unterbinden
        PlanDoc_LT.Get("Planning Document No.");

        if PlanFunctions_LC.CheckActualLine(PlanDoc_LT, Date) then begin
            Rec := xRec;
            exit;
        end;

        if xRec.Fixed = Fixed then
            if Fixed then begin
                Message(AlterationOfFixedLinesNotAllowedErr);
                Rec := xRec;
            end else
                Changed := true;

    end;

    var
        CalcPlanValues_GC: Codeunit "BET FN Calculate Planning Vals";

    [IntegrationEvent(false, false)]
    local procedure OnBeforeModify(var BETFNPlanningView: Record "BET FN Planning View"; xBETFNPlanningView: Record "BET FN Planning View"; var IsHandled: Boolean)
    var
    begin

    end;
}

