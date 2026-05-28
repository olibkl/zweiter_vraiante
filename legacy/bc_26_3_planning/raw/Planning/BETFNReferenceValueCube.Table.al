/// <summary>
/// [planning]
/// Modules: 
/// </summary>
table 5138651 "BET FN Reference Value Cube"
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
            Caption = 'Entry No.';
        }
        field(101; "Planning Document No."; Code[20])
        {
            Caption = 'Planning Document No.';
            NotBlank = true;
            TableRelation = "BET FN Planning Document";
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
            Caption = 'Time Stamp';
            Editable = false;
        }
        field(2010; "Ref. Sales Amount"; Decimal)
        {
            Caption = 'Ref. Sales Amount';
            DecimalPlaces = 0 : 5;
        }
        field(2011; "Ref. Sales Amount Net"; Decimal)
        {
            Caption = 'Ref. Sales Amount Net';
        }
        field(2020; "Ref. Sal. Am. Discount"; Decimal)
        {
            Caption = 'Ref. Sal. Am. Discount';
            DecimalPlaces = 0 : 5;
        }
        field(2021; "Ref. Discount Net"; Decimal)
        {
            Caption = 'Ref. Discount Net';
        }
        field(2030; "Ref. Sales Init. Inv."; Decimal)
        {
            Caption = 'Ref. Sales Init. Inv.';
        }
        field(2035; "Ref. Sales Closing Inv."; Decimal)
        {
            Caption = 'Ref. Sales Closing Inv.';
        }
        field(2040; "Ref. Gross Sales Pr. Reduction"; Decimal)
        {
            Caption = 'Ref. Gross Sales Pr. Reduction';
        }
        field(2050; "Ref. Sales Am. Purchase"; Decimal)
        {
            Caption = 'Ref. Sales Am. Purchase';
        }
        field(2110; "Ref. Qty. Sale"; Decimal)
        {
            Caption = 'Ref. Qty. Sale';
        }
        field(2130; "Ref. Qty. Init. Inv."; Decimal)
        {
            Caption = 'Ref. Qty. Init. Inv.';
        }
        field(2135; "Ref. Qty. Closing Inv."; Decimal)
        {
            Caption = 'Ref. Qty. Closing Inv.';
        }
        field(2150; "Ref. Qty. Purchase"; Decimal)
        {
            Caption = 'Ref. Qty. Purchase';
        }
        field(2210; "Ref. Cost of Sales"; Decimal)
        {
            Caption = 'Ref. Cost of Sales';
        }
        field(2230; "Ref. Cost Init. Inv."; Decimal)
        {
            Caption = 'Ref. Cost Init. Inv.';
        }
        field(2235; "Ref. Cost Closing Inv."; Decimal)
        {
            Caption = 'Ref. Cost Closing Inv.';
        }
        field(2250; "Ref. Cost Val. Purchase"; Decimal)
        {
            Caption = 'Ref. Cost Val. Purchase';
        }
        field(2400; "Purch. Order Outst. Qty."; Decimal)
        {
            Caption = 'Purch. Order Outst. Qty.';
        }
        field(2410; "Purch. Order Outst. Amt."; Decimal)
        {
            Caption = 'Purch. Order Outst. Amt.';
        }
        field(2420; "Purch. Order Outst. Amt. Net."; Decimal)
        {
            Caption = 'Purch. Order Outst. Amt. Net.';
        }
        field(3010; "Actual Sales Amount"; Decimal)
        {
            Caption = 'Ref. Sales Amount';
            DecimalPlaces = 0 : 5;
        }
        field(3011; "Actual Sales Amount Net"; Decimal)
        {
            Caption = 'Ref. Sales Amount Net';
        }
        field(3020; "Actual Sal. Am. Discount"; Decimal)
        {
            Caption = 'Ref. Sal. Am. Discount';
            DecimalPlaces = 0 : 5;
        }
        field(3021; "Actual Discount Net"; Decimal)
        {
            Caption = 'Ref. Discount Net';
        }
        field(3030; "Actual Sales Init. Inv."; Decimal)
        {
            Caption = 'Ref. Sales Init. Inv.';
        }
        field(3035; "Actual Sales Closing Inv."; Decimal)
        {
            Caption = 'Ref. Sales Closing Inv.';
        }
        field(3040; "Actual Gross Sales Pr. Red."; Decimal)
        {
            Caption = 'Ref. Gross Sales Pr. Reduction';
        }
        field(3050; "Actual Sales Am. Purchase"; Decimal)
        {
            Caption = 'Ref. Sales Am. Purchase';
        }
        field(3110; "Actual Qty. Sale"; Decimal)
        {
            Caption = 'Ref. Qty. Sale';
        }
        field(3130; "Actual Qty. Init. Inv."; Decimal)
        {
            Caption = 'Ref. Qty. Init. Inv.';
        }
        field(3135; "Actual Qty. Closing Inv."; Decimal)
        {
            Caption = 'Ref. Qty. Closing Inv.';
        }
        field(3150; "Actual Qty. Purchase"; Decimal)
        {
            Caption = 'Ref. Qty. Purchase';
        }
        field(3210; "Actual Cost of Sales"; Decimal)
        {
            Caption = 'Ref. Cost of Sales';
        }
        field(3230; "Actual Cost Init. Inv."; Decimal)
        {
            Caption = 'Ref. Cost Init. Inv.';
        }
        field(3235; "Actual Cost Closing Inv."; Decimal)
        {
            Caption = 'Ref. Cost Closing Inv.';
        }
        field(3250; "Actual Cost Am. Purchase"; Decimal)
        {
            Caption = 'Ref. Cost Val. Purchase';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Planning Document No.", Date, "Index 1", "Index 2", "Index 3", "Index 4", "Index 5", "Index 6")
        {
            IncludedFields = "Ref. Sales Amount", "Ref. Sal. Am. Discount", "Ref. Sales Init. Inv.", "Ref. Gross Sales Pr. Reduction", "Ref. Sales Am. Purchase", "Ref. Qty. Sale";
        }
        key(Key3; "Planning Document No.", "Index 1", "Index 2", "Index 3", "Index 4", "Index 5", "Index 6", Date)
        {
            IncludedFields = "Ref. Cost of Sales", "Ref. Cost Init. Inv.", "Ref. Cost Val. Purchase", "Purch. Order Outst. Qty.", "Purch. Order Outst. Amt.", "Purch. Order Outst. Amt. Net.";
        }
        key(Key4; "Planning Document No.", "Index 2", "Index 1", "Index 3", "Index 4", "Index 5", "Index 6", Date)
        {
            IncludedFields = "Ref. Qty. Init. Inv.", "Ref. Qty. Purchase", "Ref. Sales Closing Inv.", "Ref. Qty. Closing Inv.", "Ref. Cost Closing Inv.";
        }
        key(Key5; "Planning Document No.", Date, "Index 2", "Index 1", "Index 3", "Index 4", "Index 5", "Index 6")
        {
        }
        key(Key6; "Planning Document No.")
        {
        }
    }

    fieldgroups
    {
    }
}

