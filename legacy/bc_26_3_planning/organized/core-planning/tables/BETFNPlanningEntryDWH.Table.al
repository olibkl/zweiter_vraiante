/// <summary>
/// [planning]
/// Modules: 
/// </summary>
table 5138634 "BET FN Planning Entry (DWH)"
{

    Caption = 'Planning Entry (DWH)';
    DrillDownPageId = "BET FN Planning Entries DWH";
    LookupPageId = "BET FN Planning Entries DWH";
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
        field(2; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            ToolTip = 'Specifies the Posting Date.';
        }
        field(3; Division; Code[10])
        {
            Caption = 'Division';
            TableRelation = "BET FN Division";
            ToolTip = 'Specifies the Division.';
        }
        field(4; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
            ToolTip = 'Specifies the Item No.';
        }
        field(6; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;
            ToolTip = 'Specifies the Location Code.';
        }
        field(7; Size; Code[10])
        {
            Caption = 'Size Code';
            TableRelation = "BET FN Sizes Total";
        }
        field(8; "Main Waregroup"; Code[10])
        {
            Caption = 'Main Waregroup';
            TableRelation = "BET FN Main Waregroup";
            ToolTip = 'Specifies the Main Waregroup.';
        }
        field(9; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;
            ToolTip = 'Specifies the Customer No.';
        }
        field(10; "Country Code"; Code[10])
        {
            Caption = 'Country Code';
            TableRelation = "Country/Region";
        }
        field(11; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;
            ToolTip = 'Specifies the Vendor No.';
        }
        field(12; Brand; Text[30])
        {
            Caption = 'Brand Code';
            TableRelation = "BET FN Brand";
            ToolTip = 'Specifies the Brand.';
        }
        field(13; "Location Group"; Code[10])
        {
            Caption = 'Location Group';
            TableRelation = "BET FN Location Group";
            ToolTip = 'Specifies the Location Group.';
        }
        field(14; "Price Class"; Code[10])
        {
            Caption = 'Price Class';
            TableRelation = "BET FN Price Classification".Code;
            ToolTip = 'Specifies the Price Class.';
        }
        field(15; "Financial Year"; Code[10])
        {
            Caption = 'Financial Year';
            TableRelation = "BET FN Financial Year";
        }
        field(16; Season; Code[10])
        {
            Caption = 'Season Code';
            TableRelation = "BET FN Season";
            ToolTip = 'Specifies the Season.';
        }
        field(18; Agent; Code[20])
        {
            Caption = 'Agent';
            TableRelation = "Salesperson/Purchaser";
            ToolTip = 'Specifies the Agent.';
        }
        field(19; "Item Category"; Code[20])
        {
            Caption = 'Item Category Code';
            TableRelation = "Item Category";
            ToolTip = 'Specifies the Item Category.';
        }
        field(22; "Price Range"; Code[10])
        {
            Caption = 'Price Range';
            TableRelation = "BET FN Price Classification";
        }
        field(24; "Fashion Grade"; Code[10])
        {
            Caption = 'Fashion Grade';
        }
        field(101; "Planning Document No."; Code[20])
        {
            Caption = 'Planning Document No.';
            TableRelation = "BET FN Planning Document";
            ToolTip = 'Specifies the Planning Document No.';
        }
        field(102; "Planning Type"; Code[20])
        {
            Caption = 'Planning Type';
            TableRelation = "BET FN Planning Type";
            ToolTip = 'Specifies the Planning Type';
        }
        field(103; "Planning Version"; Option)
        {
            Caption = 'Planning Version';
            OptionMembers = Origin,Forecast;
            OptionCaption = 'Origin,Forecast';
            ToolTip = 'Specifies the Planning Version';
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
        field(2010; "Plan Sales Amount"; Decimal)
        {
            Caption = 'Plan Sales Amount';
            DecimalPlaces = 0 : 5;
            ToolTip = 'Specifies the Plan Sales Amount.';
        }
        field(2011; "Plan Sales Amount Net"; Decimal)
        {
            Caption = 'Plan Sales Amount Net';
            ToolTip = 'Specifies the Plan Sales Amount Net.';
        }
        field(2020; "Plan Sal. Am. Discount"; Decimal)
        {
            Caption = 'Plan Sal. Am. Discount';
            DecimalPlaces = 0 : 5;
            ToolTip = 'Specifies the Plan Sal. Am. Discount.';
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
            ToolTip = 'Specifies the Plan Sales Closing Inv.';
        }
        field(2040; "Plan Gross Sales Pr. Reduction"; Decimal)
        {
            Caption = 'Plan Gross Sales Pr. Reduction';
            ToolTip = 'Specifies the Plan Gross Sales Pr. Reduction.';
        }
        field(2050; "Plan Sales Am. Purchase"; Decimal)
        {
            Caption = 'Plan Sales Am. Purchase';
            ToolTip = 'Specifies the Plan Sales Am. Purchase.';
        }
        field(2110; "Plan Qty. Sale"; Decimal)
        {
            Caption = 'Plan Qty. Sale';
            ToolTip = 'Specifies the Plan Qty. Sale.';
        }
        field(2130; "Plan Qty. Init. Inv."; Decimal)
        {
            Caption = 'Plan Qty. Init. Inv.';
        }
        field(2135; "Plan Qty. Closing Inv."; Decimal)
        {
            Caption = 'Plan Qty. Closing Inv.';
            ToolTip = 'Specifies the Plan Qty. Closing Inv.';
        }
        field(2150; "Plan Qty. Purchase"; Decimal)
        {
            Caption = 'Plan Qty. Purchase';
            ToolTip = 'Specifies the Plan Qty. Purchase.';
        }
        field(2210; "Plan Cost of Sales"; Decimal)
        {
            Caption = 'Plan Cost of Sales';
            ToolTip = 'Specifies the Plan Cost of Sales.';
        }
        field(2230; "Plan Cost Init. Inv."; Decimal)
        {
            Caption = 'Plan Cost Init. Inv.';
        }
        field(2235; "Plan Cost Closing Inv."; Decimal)
        {
            Caption = 'Plan Cost Closing Inv.';
            ToolTip = 'Specifies the Plan Cost Closing Inv.';
        }
        field(2250; "Plan Cost Am. Purchase"; Decimal)
        {
            Caption = 'Plan Cost Val. Purchase';
            ToolTip = 'Specifies the Plan Cost Am. Purchase.';
        }
        field(2514; "Plan Purch. Limit 1"; Decimal)
        {
            Caption = 'Plan Purch. Limit 1';
        }
        field(2515; "Plan Purch. Limit 2"; Decimal)
        {
            Caption = 'Plan Purch. Limit 2';
        }
        field(2516; "Plan Purch. Limit 3"; Decimal)
        {
            Caption = 'Plan Purch. Limit 3';
        }
        field(2517; "Plan Purch. Limit 4"; Decimal)
        {
            Caption = 'Plan Purch. Limit 4';
        }
        field(2518; "Plan Purch. Limit 5"; Decimal)
        {
            Caption = 'Plan Purch. Limit 5';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
            MaintainSiftIndex = false;
        }
        key(Key2; Season, "Item Category", "Main Waregroup", Division, "Location Code", Brand, "Posting Date")
        {
            MaintainSiftIndex = false;
        }
        key(Key3; Season, "Item Category", "Main Waregroup", Division, "Location Code", Brand, "Posting Date", "Vendor No.")
        {
            MaintainSiftIndex = false;
        }
        key(Key4; Season, "Item Category", "Main Waregroup", Division, "Location Code", Brand, "Vendor No.", "Posting Date")
        {
            MaintainSiftIndex = false;
        }
        key(Key5; "Planning Document No.")
        {
            MaintainSiftIndex = false;
        }
    }

    fieldgroups
    {
    }
}

