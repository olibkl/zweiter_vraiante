/// <summary>
/// [planning]
/// Modules: 
/// </summary>
table 5138633 "BET FN Purchase Statistic Ent"
{

    Caption = 'Purchase Statistic Entries';
    DrillDownPageId = "BET FN Purchase Stats Entrs";
    LookupPageId = "BET FN Purchase Stats Entrs";
    DataClassification = CustomerContent;
    Access = Public;
    Extensible = true;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            ToolTip = 'Specifies the Entry No.';
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
            ToolTip = 'Specifies the Item No.';
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
            ToolTip = 'Specifies the Location Group.';
        }
        field(11; "Expected Receipt Date"; Date)
        {
            Caption = 'Expected Receipt Date';
            ToolTip = 'Specifies the Expected Receipt Date.';
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
            ToolTip = 'Specifies the Customer.';
        }
        field(111; Agent; Code[20])
        {
            Caption = 'Agent';
            ToolTip = 'Specifies the Agent.';
        }
        field(201; FDim1; Code[20])
        {
            ToolTip = 'Specifies the Fashion Dimension 1.';
        }
        field(202; FDim2; Code[20])
        {
            ToolTip = 'Specifies the Fashion Dimension 2.';
        }
        field(203; FDim3; Code[20])
        {
            ToolTip = 'Specifies the Fashion Dimension 3.';
        }
        field(204; FDim4; Code[20])
        {
            ToolTip = 'Specifies the Fashion Dimension 4.';
        }
        field(205; FDim5; Code[20])
        {
            ToolTip = 'Specifies the Fashion Dimension 5.';
        }
        field(206; FDim6; Code[20])
        {
            ToolTip = 'Specifies the Fashion Dimension 6.';
        }
        field(207; FDim7; Code[20])
        {
            ToolTip = 'Specifies the Fashion Dimension 7.';
        }
        field(208; FDim8; Code[20])
        {
            ToolTip = 'Specifies the Fashion Dimension 8.';
        }
        field(209; FDim9; Code[20])
        {
            ToolTip = 'Specifies the Fashion Dimension 9.';
        }
        field(210; FDim10; Code[20])
        {
            ToolTip = 'Specifies the Fashion Dimension 10.';
        }
        field(1001; "Outstanding Quantity"; Decimal)
        {
            Caption = 'S Quantity';
            ToolTip = 'Specifies the Outstanding Quantity.';
        }
        field(1002; "Outst. Gross Sales Amt. (LCY)"; Decimal)
        {
            Caption = 'S Cost Amount';
            ToolTip = 'Specifies the Outstanding Gross Sales Amount (LCY).';
        }
        field(1003; "Net Outstanding Amount (LCY)"; Decimal)
        {
            Caption = 'S Inventory Value Sales (LCY)';
            ToolTip = 'Specifies the Net Outstanding Amount (LCY).';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Expected Receipt Date")
        {
        }
        key(Key3; Season, "Location Code", Division, "Main Waregroup", "Item Category Code", Brand, "Expected Receipt Date")
        {
            IncludedFields = "Outstanding Quantity", "Outst. Gross Sales Amt. (LCY)", "Net Outstanding Amount (LCY)";
        }
        key(Key4; Division, "Main Waregroup", "Item Category Code", "Location Code", Brand, "Expected Receipt Date")
        {
            IncludedFields = "Outstanding Quantity", "Outst. Gross Sales Amt. (LCY)", "Net Outstanding Amount (LCY)";
        }
        key(Key5; "Main Waregroup", "Location Code", Brand, "Expected Receipt Date")
        {
        }
        key(Key6; "Item Category Code", "Location Code", Brand, "Expected Receipt Date")
        {
        }
    }

    fieldgroups
    {
    }
}

