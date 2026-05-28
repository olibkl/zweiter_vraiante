/// <summary>
/// [fashion-statistic]
/// Modules: 
/// </summary>
#pragma warning disable AL0432
table 5138632 "BET FN Fashion Statistic Entry"
{

    Caption = 'Fashion Statistic Entries';
    DrillDownPageId = "BET FN Fashion Statistic Entrs";
    LookupPageId = "BET FN Fashion Statistic Entrs";
    DataClassification = CustomerContent;
    Access = Public;
    Extensible = true;

    fields
    {
        field(1; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            ToolTip = 'Specifies the Posting Date.';
        }
        field(2; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;
            ToolTip = 'Specifies the Location Code.';
        }
        field(3; Season; Code[10])
        {
            Caption = 'Season Code';
            TableRelation = "BET FN Season";
            ToolTip = 'Specifies the Season.';
        }
        field(4; "Item Category Code"; Code[20])
        {
            Caption = 'Item Category Code';
            TableRelation = "Item Category";
            ToolTip = 'Specifies the Item Category Code.';
        }
        field(5; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            ToolTip = 'Specifies the Vendor No.';
        }
        field(6; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
        }
        field(7; "Size Run"; Code[10])
        {
            Caption = 'Size Run Code';
            TableRelation = "BET FN Size Runs Total";
        }
        field(8; Size; Code[10])
        {
            Caption = 'Size Code';
            TableRelation = "BET FN Sizes Assigned".Size where("Size Run" = field("Size Run"));
        }
        field(9; "Season Type"; Option)
        {
            Caption = 'Season Type';
            OptionCaption = 'Complete Year,Summer,Winter';
            OptionMembers = "Complete Year",Summer,Winter;
        }
        field(10; "Location Group"; Code[10])
        {
            Caption = 'Location Group';
            TableRelation = "BET FN Location Group";
        }
        field(11; "Country Code"; Code[10])
        {
            Caption = 'Country Code';
            TableRelation = "Country/Region";
            ToolTip = 'Specifies the Country Code.';
        }
        field(22; "Price Range"; Code[10])
        {
            Caption = 'Price Range';
            TableRelation = "BET FN Sizes Assigned";
        }
        field(24; "Fashion Grade"; Code[10])
        {
            Caption = 'Fashion Grade';
        }
        field(50; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            ToolTip = 'Specifies the Entry No.';
        }
        field(51; "Entry Source Type"; Option)
        {
            Caption = 'Posten Herkunft';
            OptionCaption = ' ,Historical,Value Entry,Stock Value Entry';
            OptionMembers = " ",historical,valueentry,stockvalue;
            ToolTip = 'Specifies the Entry Source Type.';
        }
        field(52; Company; Text[30])
        {
            Caption = 'Company';
            ToolTip = 'Specifies the Company.';
        }
        field(101; Division; Code[10])
        {
            Caption = 'Division';
            TableRelation = "BET FN Division";
            ToolTip = 'Specifies the Division.';
        }
        field(102; "Main Waregroup"; Code[10])
        {
            Caption = 'Main Waregroup';
            TableRelation = "BET FN Main Waregroup";
            ToolTip = 'Specifies the Main Waregroup.';
        }
        field(103; Brand; Text[30])
        {
            Caption = 'Brand Code';
            TableRelation = "BET FN Brand";
            ToolTip = 'Specifies the Brand.';
        }
        field(110; Customer; Code[20])
        {
            Caption = 'Customer';
            TableRelation = Customer;
            ToolTip = 'Specifies the Customer.';
        }
        field(111; Agent; Code[20])
        {
            Caption = 'Agent';
            TableRelation = "BET FN Agent";
        }
        field(201; FDim1; Code[20])
        {
        }
        field(202; FDim2; Code[20])
        {
        }
        field(203; FDim3; Code[20])
        {
        }
        field(204; FDim4; Code[20])
        {
        }
        field(205; FDim5; Code[20])
        {
        }
        field(206; FDim6; Code[20])
        {
        }
        field(207; FDim7; Code[20])
        {
        }
        field(208; FDim8; Code[20])
        {
        }
        field(209; FDim9; Code[20])
        {
        }
        field(210; FDim10; Code[20])
        {
        }
        field(1001; "S Quantity"; Decimal)
        {
            Caption = 'S Quantity';
            ToolTip = 'Specifies the S Quantity.';
        }
        field(1002; "S Cost Amount"; Decimal)
        {
            Caption = 'S Cost Amount';
            ToolTip = 'Specifies the S Cost Amount.';
        }
        field(1003; "S Inventory Value Sales"; Decimal)
        {
            Caption = 'S Inventory Value Sales (LCY)';
            ToolTip = 'Specifies the S Inventory Value Sales.';
        }
        field(1004; "S Realized Gross Sales Amount"; Decimal)
        {
            Caption = 'S Realized Gross Sales Amount';
            ToolTip = 'Specifies the S Realized Gross Sales Amount.';
        }
        field(1005; "S Discount Amount Gross"; Decimal)
        {
            Caption = 'S Discount Amount Gross (LCY)';
            ToolTip = 'Specifies the S Discount Amount Gross.';
        }
        field(1006; "S Discount Amount Gross S."; Decimal)
        {
            Caption = 'S Discount Amount Gross (LCY)';
            DecimalPlaces = 2 : 2;
            ToolTip = 'Specifies the S Discount Amount Gross S..';
        }
        field(1007; "S Realized GSP Reduction"; Decimal)
        {
            Caption = 'S Realized GSPR-Amount';
            ToolTip = 'Specifies the S Realized GSP Reduction.';
        }
        field(1008; "S Change in GS-Prices"; Decimal)
        {
            Caption = 'S Change in GS-Prices';
            ToolTip = 'Specifies the S Change in GS-Prices.';
        }
        field(1009; "S Real. Net Sales Amount"; Decimal)
        {
            Caption = 'S Real. Net Sales Amount';
            ToolTip = 'Specifies the S Real. Net Sales Amount.';
        }
        field(1010; "S Discount Amount"; Decimal)
        {
            Caption = 'Rabattbetrag VK Netto';
        }
        field(2001; "P Quantity"; Decimal)
        {
            Caption = 'P Quantity';
            ToolTip = 'Specifies the P Quantity.';
        }
        field(2002; "P Cost Amount"; Decimal)
        {
            Caption = 'P Cost Amount';
            ToolTip = 'Specifies the P Cost Amount.';
        }
        field(2003; "P Inventory Value Sales"; Decimal)
        {
            Caption = 'P Inventory Value Sales (LCY)';
            ToolTip = 'Specifies the P Inventory Value Sales.';
        }
        field(3001; "A Quantity"; Decimal)
        {
            Caption = 'A Quantity';
            ToolTip = 'Specifies the A Quantity.';
        }
        field(3002; "A Cost Amount"; Decimal)
        {
            Caption = 'A Cost Amount';
            ToolTip = 'Specifies the A Cost Amount.';
        }
        field(3003; "A Inventory Value Sales"; Decimal)
        {
            Caption = 'A Inventory Value Sales (LCY)';
            ToolTip = 'Specifies the A Inventory Value Sales.';
        }
        field(4001; "T Quantity"; Decimal)
        {
            Caption = 'T Quantity';
            ToolTip = 'Specifies the T Quantity.';
        }
        field(4002; "T Cost Amount"; Decimal)
        {
            Caption = 'T Cost Amount';
            ToolTip = 'Specifies the T Cost Amount.';
        }
        field(4003; "T Inventory Value Sales"; Decimal)
        {
            Caption = 'T Inventory Value Sales (LCY)';
            ToolTip = 'Specifies the T Inventory Value Sales.';
        }
        field(5001; "I Quantity"; Decimal)
        {
            Caption = 'I Quantity';
            ToolTip = 'Specifies the I Quantity.';
        }
        field(5002; "I Cost Amount"; Decimal)
        {
            Caption = 'I Cost Amount';
            ToolTip = 'Specifies the I Cost Amount.';
        }
        field(5003; "I Inventory Value Sales"; Decimal)
        {
            Caption = 'I Inventory Value Sales (LCY)';
            ToolTip = 'Specifies the I Inventory Value Sales.';
        }
        field(6001; "D Inventory Value Sales"; Decimal)
        {
            Caption = 'D Inventory Value Sales (LCY)';
            ToolTip = 'Specifies the D Inventory Value Sales.';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
            MaintainSiftIndex = false;
        }
        key(Key2; "Posting Date", "Location Code", Season, "Item Category Code", "Vendor No.", Brand, "Item No.", "Size Run", Size)
        {
            IncludedFields = "S Quantity", "S Cost Amount", "S Realized Gross Sales Amount", "I Quantity", "I Cost Amount", "P Quantity", "P Cost Amount";
        }
        key(Key3; "Location Code", Season, "Item Category Code", "Posting Date")
        {
        }
        key(Key4; "Posting Date")
        {
        }
        key(Key5; Season, "Location Code", "Main Waregroup", "Item Category Code", "Posting Date")
        {
            IncludedFields = "S Quantity", "S Cost Amount", "S Realized Gross Sales Amount", "S Discount Amount Gross", "I Quantity", "I Cost Amount", "P Quantity", "P Cost Amount", "P Inventory Value Sales", "I Inventory Value Sales", "S Inventory Value Sales", "D Inventory Value Sales";
        }
        key(Key6; "Location Code", "Main Waregroup", Brand, "Posting Date")
        {
            IncludedFields = "S Quantity", "S Cost Amount", "S Realized Gross Sales Amount", "S Discount Amount Gross", "I Quantity", "I Cost Amount", "P Quantity", "P Cost Amount", "P Inventory Value Sales", "I Inventory Value Sales", "S Inventory Value Sales", "D Inventory Value Sales";
        }
        key(Key7; Division, "Main Waregroup", "Item Category Code", "Location Code", Brand, Season, "Posting Date")
        {
            IncludedFields = "A Quantity", "A Cost Amount", "A Inventory Value Sales", "S Change in GS-Prices";
        }
        key(Key8; "Location Code", "Item Category Code", "Vendor No.", Brand, "Posting Date")
        {
        }
        key(Key9; "Item No.", "Item Category Code", "Posting Date")
        {
            IncludedFields = "S Quantity", "S Cost Amount", "S Realized Gross Sales Amount", "S Discount Amount Gross", "I Quantity", "I Cost Amount", "P Quantity", "P Cost Amount", "P Inventory Value Sales", "I Inventory Value Sales", "S Inventory Value Sales", "D Inventory Value Sales", "S Change in GS-Prices";
        }
        key(Key10; "Location Code", "Country Code", "Location Group", "Posting Date")
        {
            IncludedFields = "S Quantity", "S Cost Amount", "S Realized Gross Sales Amount", "S Discount Amount Gross", "I Quantity", "I Cost Amount", "P Quantity", "P Cost Amount", "P Inventory Value Sales", "I Inventory Value Sales", "S Inventory Value Sales", "D Inventory Value Sales", "S Change in GS-Prices";
        }
        key(Key11; "Item Category Code", "Price Range", "Main Waregroup", "Posting Date")
        {
            IncludedFields = "S Quantity", "S Cost Amount", "S Realized Gross Sales Amount", "S Discount Amount Gross", "I Quantity", "I Cost Amount", "P Quantity", "P Cost Amount", "P Inventory Value Sales", "I Inventory Value Sales", "S Inventory Value Sales", "D Inventory Value Sales", "S Change in GS-Prices";
        }
    }

    fieldgroups
    {
    }
}

