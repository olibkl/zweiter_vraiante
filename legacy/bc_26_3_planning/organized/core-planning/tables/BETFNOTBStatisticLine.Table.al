/// <summary>
/// [planning]
/// Modules: 
/// </summary>
table 5138635 "BET FN OTB Statistic Line"
{
    Caption = 'OTB Statistic Line';
    DataClassification = CustomerContent;
    Access = Public;
    Extensible = true;

    fields
    {
        field(1; Level1; Code[20])
        {
            Caption = 'Level1';
            ToolTip = 'Specifies the LevelControl1.';
        }
        field(2; Level2; Code[20])
        {
            Caption = 'Level2';
            ToolTip = 'Specifies the LevelControl2.';
        }
        field(3; Level3; Code[20])
        {
            Caption = 'Level3';
            ToolTip = 'Specifies the LevelControl3.';
        }
        field(4; Level4; Code[20])
        {
            Caption = 'Level4';
            ToolTip = 'Specifies the LevelControl4.';
        }
        field(6; Season; Code[10])
        {
            Caption = 'Season Code';
            TableRelation = "BET FN Season";
        }
        field(8; "Order Date"; Date)
        {
            Caption = 'Order Date';
        }
        field(9; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;
        }
        field(11; "Limit Plan Purchase"; Decimal)
        {
            Caption = 'Limit Plan Purchase';
            ToolTip = 'Specifies the Limit Plan Purchase.';
        }
        field(12; "Limit Plan Quantity"; Decimal)
        {
            Caption = 'Limit Plan Quantity';
            ToolTip = 'Specifies the Limit Plan Quantity.';
        }
        field(13; "Limit Plan Sale"; Decimal)
        {
            Caption = 'Limit Plan Sale';
            ToolTip = 'Specifies the Limit Plan Sale.';
        }
        field(14; "Limit Plan Calc."; Decimal)
        {
            Caption = 'Limit Plan Calc.';
            ToolTip = 'Specifies the Limit Plan Calc.';
        }
        field(21; "Limit Act. Purchase"; Decimal)
        {
            Caption = 'Limit Act. Purchase';
            ToolTip = 'Specifies the Limit Act. Purchase.';
        }
        field(22; "Limit Act. Quantity"; Decimal)
        {
            Caption = 'Limit Act. Quantity';
            ToolTip = 'Specifies the Limit Act. Quantity.';
        }
        field(23; "Limit Act. Sale"; Decimal)
        {
            Caption = 'Limit Act. Sale';
            ToolTip = 'Specifies the Limit Act. Sale.';
        }
        field(24; "Limit Act. Calc."; Decimal)
        {
            Caption = 'Limit Act. Calc.';
            ToolTip = 'Specifies the Limit Act. Calc.';
        }
        field(31; "Limit Rest Purchase"; Decimal)
        {
            Caption = 'Limit Rest Purchase';
            ToolTip = 'Specifies the Limit Rest Purchase.';
        }
        field(32; "Limit Rest Quantity"; Decimal)
        {
            Caption = 'Limit Rest Quantity';
            ToolTip = 'Specifies the Limit Rest Quantity.';
        }
        field(33; "Limit Rest Sale"; Decimal)
        {
            Caption = 'Limit Rest Sale';
            ToolTip = 'Specifies the Limit Rest Sale.';
        }
        field(34; "Limit Rest Calc."; Decimal)
        {
            Caption = 'Limit Rest Calc.';
            ToolTip = 'Specifies the Limit Rest Calc.';
        }
        field(41; "This Order Purchase"; Decimal)
        {
            Caption = 'This Order Purchase';
            ToolTip = 'Specifies the This Order Purchase.';
        }
        field(42; "This Order Quantity"; Decimal)
        {
            Caption = 'This Order Quantity';
            ToolTip = 'Specifies the This Order Quantity.';
        }
        field(43; "This Order Sale"; Decimal)
        {
            Caption = 'This Order Sale';
            ToolTip = 'Specifies the This Order Sale.';
        }
        field(44; "This Order Calc."; Decimal)
        {
            Caption = 'This Order Calc.';
            ToolTip = 'Specifies the This Order Calc.';
        }
    }

    keys
    {
        key(Key1; Level1, Level2, Level3, Level4, "Order Date")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

