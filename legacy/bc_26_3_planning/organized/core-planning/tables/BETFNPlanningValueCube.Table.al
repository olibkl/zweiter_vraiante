/// <summary>
/// [planning]
/// Modules: 
/// </summary>
table 5138650 "BET FN Planning Value Cube"
{
    DataClassification = CustomerContent;
    Access = Public;
    Extensible = true;

    fields
    {
        field(1; "Index 1"; Code[20])
        {
            NotBlank = false;
        }
        field(2; "Index 2"; Code[20])
        {
            NotBlank = false;
        }
        field(3; "Index 3"; Code[20])
        {
            NotBlank = false;
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
        field(11; Date; Date)
        {
            Caption = 'Date';
        }
        field(12; "Entry No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Cube Entry No.';
        }
        field(101; "Planning Document No."; Code[20])
        {
            Caption = 'Planning Document No.';
            NotBlank = true;
            TableRelation = "BET FN Planning Document";
        }
        field(206; "Line Type"; Option)
        {
            Caption = 'Line Type';
            OptionCaption = 'Plan,Actual';
            OptionMembers = Plan,Actual;
        }
        field(302; "Fixed"; Boolean)
        {
            Caption = 'Fixed';
        }
        field(310; "First Month"; Boolean)
        {
            Caption = 'First Month';
        }
        field(311; "Last Month"; Boolean)
        {
            Caption = 'Last Month';
        }
        field(321; "Time-Stamp"; DateTime)
        {
            Caption = 'Time-Stamp';
            Editable = false;
        }
        field(2010; "Plan Sales Amount"; Decimal)
        {
            Caption = 'Plan Sales Amount';
            DecimalPlaces = 0 : 5;
        }
        field(2011; "Plan Sales Amount Net"; Decimal)
        {
            Caption = 'Plan Sales Amount Net';
        }
        field(2020; "Plan Sal. Am. Discount"; Decimal)
        {
            Caption = 'Plan Sal. Am. Discount';
            DecimalPlaces = 0 : 5;
        }
        field(2021; "Plan Discount Net"; Decimal)
        {
            Caption = 'Plan Discount Net';
        }
        field(2030; "Plan Sales Init. Inv."; Decimal)
        {
            Caption = 'Plan Sales Init. Inv.';
        }
        field(2035; "Plan Sales Closing Inv."; Decimal)
        {
            Caption = 'Plan Sales Closing Inv.';
        }
        field(2040; "Plan Gross Sales Pr. Reduction"; Decimal)
        {
            Caption = 'Plan Gross Sales Pr. Reduction';
        }
        field(2050; "Plan Sales Am. Purchase"; Decimal)
        {
            Caption = 'Plan Sales Am. Purchase';
        }
        field(2051; "Plan Sales Am. Purch. 1"; Decimal)
        {
            Caption = 'Plan Sales Am. Purchase 1';
        }
        field(2052; "Plan Sales Am. Purch. 2"; Decimal)
        {
            Caption = 'Plan Sales Am. Purchase 2';
        }
        field(2053; "Plan Sales Am. Purch. 3"; Decimal)
        {
            Caption = 'Plan Sales Am. Purchase 3';
        }
        field(2054; "Plan Sales Am. Purch. 4"; Decimal)
        {
            Caption = 'Plan Sales Am. Purchase 4';
        }
        field(2055; "Plan Sales Am. Purch. 5"; Decimal)
        {
            Caption = 'Plan Sales Am. Purchase 5';
        }
        field(2110; "Plan Qty. Sale"; Decimal)
        {
            Caption = 'Plan Qty. Sale';
        }
        field(2130; "Plan Qty. Init. Inv."; Decimal)
        {
            Caption = 'Plan Qty. Init. Inv.';
        }
        field(2135; "Plan Qty. Closing Inv."; Decimal)
        {
            Caption = 'Plan Qty. Closing Inv.';
        }
        field(2150; "Plan Qty. Purchase"; Decimal)
        {
            Caption = 'Plan Qty. Purchase';
        }
        field(2210; "Plan Cost of Sales"; Decimal)
        {
            Caption = 'Plan Cost of Sales';
        }
        field(2230; "Plan Cost Init. Inv."; Decimal)
        {
            Caption = 'Plan Cost Init. Inv.';
        }
        field(2235; "Plan Cost Closing Inv."; Decimal)
        {
            Caption = 'Plan Cost Closing Inv.';
        }
        field(2250; "Plan Cost Am. Purchase"; Decimal)
        {
            Caption = 'Plan Cost Val. Purchase';
        }
        field(2251; "Plan Cost Am. Purch. 1"; Decimal)
        {
            Caption = 'Plan Cost Amount Purchase 1';
        }
        field(2252; "Plan Cost Am. Purch. 2"; Decimal)
        {
            Caption = 'Plan Cost Amount Purchase 2';
        }
        field(2253; "Plan Cost Am. Purch. 3"; Decimal)
        {
            Caption = 'Plan Cost Amount Purchase 3';
        }
        field(2254; "Plan Cost Am. Purch. 4"; Decimal)
        {
            Caption = 'Plan Cost Amount Purchase 4';
        }
        field(2255; "Plan Cost Am. Purch. 5"; Decimal)
        {
            Caption = 'Plan Cost Amount Purchase 5';
        }
        field(2260; "Plan Sales Order Amount"; Decimal)
        {
            Caption = 'Plan Sales Order Amount';
        }
        field(2261; "Plan Sales Order Qty."; Decimal)
        {
            Caption = 'Plan Sales Order Quantity';
        }
        field(2514; "Plan Purch. Limit 1"; Decimal)
        {
            ObsoleteState = Pending;
            ObsoleteTag = '25.2';
            ObsoleteReason = '#35131 Pending removal - field will be removed in future updates';

            Caption = 'Plan Purch. Limit 1';
        }
        field(2515; "Plan Purch. Limit 2"; Decimal)
        {
            ObsoleteState = Pending;
            ObsoleteTag = '25.2';
            ObsoleteReason = '#35131 Pending removal - field will be removed in future updates';

            Caption = 'Plan Purch. Limit 2';
        }
        field(2516; "Plan Purch. Limit 3"; Decimal)
        {
            ObsoleteState = Pending;
            ObsoleteTag = '25.2';
            ObsoleteReason = '#35131 Pending removal - field will be removed in future updates';

            Caption = 'Plan Purch. Limit 3';
        }
        field(2517; "Plan Purch. Limit 4"; Decimal)
        {
            ObsoleteState = Pending;
            ObsoleteTag = '25.2';
            ObsoleteReason = '#35131 Pending removal - field will be removed in future updates';

            Caption = 'Plan Purch. Limit 4';
        }
        field(2518; "Plan Purch. Limit 5"; Decimal)
        {
            ObsoleteState = Pending;
            ObsoleteTag = '25.2';
            ObsoleteReason = '#35131 Pending removal - field will be removed in future updates';

            Caption = 'Plan Purch. Limit 5';
        }
        field(5000; "Free Purchase Limit"; Decimal)
        {
            Caption = 'Open To Buy';
        }
        field(6000; "Plan Target Sales Amount"; Decimal)
        {
            Caption = 'Plan Target Sales Amount';
        }
        field(6001; "Plan Target Sales Am. Net"; Decimal)
        {
            Caption = 'Plan Target Sales Am. Net';
        }
        field(6002; "Plan Target Discount"; Decimal)
        {
            Caption = 'Plan Target Discount';
        }
        field(6003; "Plan Target Discount Net"; Decimal)
        {
            Caption = 'Plan Target Discount Net';
        }
        field(6004; "Plan Target Sales Init. Inv."; Decimal)
        {
            Caption = 'Plan Target Sales Init. Inv.';
        }
        field(6005; "Plan Target Sales Closing Inv."; Decimal)
        {
            Caption = 'Plan Target Sales Closing Inv.';
        }
        field(6006; "Plan Target G.S.P. Reduction"; Decimal)
        {
            Caption = 'Plan Target G.S.P. Reduction';
        }
        field(6007; "Plan Target Sal. Am. Purch."; Decimal)
        {
            Caption = 'Plan Target Sal. Am. Purch.';
        }
        field(6010; "Plan Target Qty. Sale"; Decimal)
        {
            Caption = 'Plan Target Qty. Turnover';
        }
        field(6011; "Plan Target Qty. Init. Inv."; Decimal)
        {
            Caption = 'Plan Target Qty. Init. Inv.';
        }
        field(6012; "Plan Target Qty. Closing Inv."; Decimal)
        {
            Caption = 'Plan Target Qty. Closing Inv.';
        }
        field(6013; "Plan Target Qty. Purchase"; Decimal)
        {
            Caption = 'Plan Target Qty. Purchase';
        }
        field(6020; "Plan Target Cost of Sales"; Decimal)
        {
            Caption = 'Plan Target Cost of Sales';
        }
        field(6021; "Plan Target Cost Init. Inv."; Decimal)
        {
            Caption = 'Plan Target Cost Init. Inv.';
        }
        field(6022; "Plan Target Cost Closing Inv."; Decimal)
        {
            Caption = 'Plan Target Cost Closing Inv.';
        }
        field(6023; "Plan Target Cost Am. Purch."; Decimal)
        {
            Caption = 'Plan Target Cost Val. Purch.';
        }
        field(6024; "Plan Target Purch. Limit 1"; Decimal)
        {
            Caption = 'Plan Target Purch. Limit 1';
        }
        field(6025; "Plan Target Purch. Limit 2"; Decimal)
        {
            Caption = 'Plan Target Purch. Limit 2';
        }
        field(6026; "Plan Target Purch. Limit 3"; Decimal)
        {
            Caption = 'Plan Target Purch. Limit 3';
        }
        field(6027; "Plan Target Purch. Limit 4"; Decimal)
        {
            Caption = 'Plan Target Purch. Limit 4';
        }
        field(6028; "Plan Target Purch. Limit 5"; Decimal)
        {
            Caption = 'Plan Target Purch. Limit 5';
        }
        field(10000; "Proj. Sales Closing Inv."; Decimal)
        {
            Caption = 'Proj. Sales Closing Inv.';
        }
        field(10001; "Proj. Cost Closing Inv."; Decimal)
        {
            Caption = 'Proj. Cost Closing Inv.';
        }
        field(10002; "Proj. Qty. Closing Inv."; Decimal)
        {
            Caption = 'Proj. Qty. Closing Inv.';
        }
        field(10003; "Proj. Sales Amount"; Decimal)
        {
            Caption = 'Proj. Sales Amount';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Planning Document No.", "Index 1", "Index 2", "Index 3", "Index 4", "Index 5", "Index 6", Date, "Time-Stamp")
        {
        }
        key(Key3; "Planning Document No.", "Index 1", "Index 2", "Index 3", "Index 4", "Index 5", "Index 6", Date)
        {
            SqlIndex = "Planning Document No.", "Index 1", "Index 2", "Index 3", "Index 4", "Index 5", "Index 6", Date;
            IncludedFields = "Plan Sales Amount", "Plan Sal. Am. Discount", "Plan Sales Init. Inv.", "Plan Gross Sales Pr. Reduction", "Plan Sales Am. Purchase", "Plan Qty. Sale";
        }
        key(Key4; "Planning Document No.", "Index 2", "Index 1", "Index 3", "Index 4", "Index 5", "Index 6", Date)
        {
            SqlIndex = "Planning Document No.", "Index 1", "Index 2", "Index 3", "Index 4", "Index 5", "Index 6", Date;
            IncludedFields = "Plan Qty. Init. Inv.", "Plan Qty. Purchase", "Plan Cost of Sales", "Plan Cost Init. Inv.", "Plan Cost Am. Purchase", "Proj. Sales Closing Inv.", "Proj. Cost Closing Inv.", "Proj. Qty. Closing Inv.", "Proj. Sales Amount";
        }
        key(Key5; "Planning Document No.", "Time-Stamp")
        {
        }
        key(Key6; "Planning Document No.", Date, "Index 1", "Index 2", "Index 3", "Index 4", "Index 5", "Index 6")
        {
            IncludedFields = "Plan Target Cost Am. Purch.", "Plan Target Cost of Sales", "Plan Target Cost Closing Inv.", "Free Purchase Limit", "Plan Cost Closing Inv.", "Plan Target Sal. Am. Purch.";
        }
        key(Key7; "Planning Document No.", "Index 1", Date, "Index 2", "Index 3", "Index 4", "Index 5", "Index 6")
        {
            IncludedFields = "Plan Target Sales Amount", "Plan Target Sales Am. Net", "Plan Target Discount", "Plan Target Discount Net", "Plan Target G.S.P. Reduction", "Plan Target Qty. Purchase", "Plan Target Qty. Sale", "Plan Target Cost Init. Inv.";
        }
        key(Key8; "Planning Document No.", "Index 2", Date, "Index 1", "Index 3", "Index 4", "Index 5", "Index 6")
        {
            IncludedFields = "Plan Target Sales Init. Inv.", "Plan Target Qty. Init. Inv.", "Plan Sales Closing Inv.", "Plan Qty. Closing Inv.";
        }
        key(Key9; "Planning Document No.", "Fixed", "Index 1", "Index 2", "Index 3", "Index 4", "Index 5", "Index 6", Date)
        {
            IncludedFields = "Plan Sales Amount", "Plan Sales Init. Inv.", "Plan Sales Am. Purchase", "Plan Qty. Sale", "Plan Qty. Init. Inv.", "Plan Qty. Purchase";
        }
        key(Key10; "Planning Document No.", "Index 1", "Fixed", "Index 2", "Index 3", "Index 4", "Index 5", "Index 6", Date)
        {
            IncludedFields = "Plan Sal. Am. Discount", "Plan Gross Sales Pr. Reduction", "Plan Cost Am. Purchase", "Plan Cost Init. Inv.", "Plan Cost of Sales";
        }
        key(Key11; "Planning Document No.", "Fixed", "Index 1", "Index 2", "Index 3", "Index 4", "Index 5", "Index 6", Date, "Time-Stamp")
        {
#pragma warning disable AL0432
            IncludedFields = "Plan Purch. Limit 1", "Plan Purch. Limit 2", "Plan Purch. Limit 3", "Plan Purch. Limit 4", "Plan Purch. Limit 5";
#pragma warning restore AL0432
        }
        key(Key12; "Planning Document No.", "Line Type", Date)
        {
        }
        key(Key13; "Planning Document No.")
        {
        }
    }

    fieldgroups
    {
    }
}

