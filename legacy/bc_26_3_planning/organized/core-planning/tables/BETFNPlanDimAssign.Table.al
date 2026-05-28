table 5079371 "BET FN Plan. Dim. Assign."
{
    Caption = 'Planning Dimension Assignment';
    DataClassification = CustomerContent;
    DrillDownPageId = "BET FN Plan. Dim. Assign.";
    LookupPageId = "BET FN Plan. Dim. Assign.";
    Access = Public;
    Extensible = true;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            ToolTip = 'Specifies the value of the Entry No. field.';
        }
        field(9; "Purchaser Code"; Code[20])
        {
            Caption = 'Purchaser Code';
            TableRelation = "Salesperson/Purchaser".Code where("BET FN Purchaser Yes No" = const(true));
            ToolTip = 'Specifies the value of the Purchaser Code field.';
        }
        field(10; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;
            ToolTip = 'Specifies the value of the Vendor No. field.';
        }
        field(11; Brand; Code[20])
        {
            Caption = 'Brand';
            TableRelation = "BET FN Brand";
            ToolTip = 'Specifies the value of the Brand field.';
        }
        field(12; "Main Waregroup"; Code[10])
        {
            Caption = 'Main Waregroup';
            TableRelation = "BET FN Main Waregroup";
            ToolTip = 'Specifies the value of the Main Waregroup field.';
        }

    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
}
