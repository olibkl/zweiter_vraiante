/// <summary>
/// [planning]
/// Modules: 
/// </summary>
table 5138653 "BET FN Planning Ent Info Temp"
{
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
        field(2; "Line Type"; Option)
        {
            Caption = 'Line Type';
            OptionCaption = 'Level1,Level2,Level3,Level4,Empty,Total';
            OptionMembers = L1,L2,L3,L4,Empty,Total;
            ToolTip = 'Specifies the Line Type.';
        }
        field(3; Indentation; Integer)
        {
            Caption = 'Indentation';
            ToolTip = 'Specifies the Indentation.';
        }
        field(4; Description; Text[250])
        {
            Caption = 'Description';
            ToolTip = 'Specifies the Description.';
        }
        field(10; Level1; Code[20])
        {
            Caption = 'Level1';
            ToolTip = 'Specifies the Level1.';
        }
        field(11; Level2; Code[20])
        {
            Caption = 'Level2';
            ToolTip = 'Specifies the Level2.';
        }
        field(12; Level3; Code[20])
        {
            Caption = 'Level3';
            ToolTip = 'Specifies the Level3.';
        }
        field(13; Level4; Code[20])
        {
            Caption = 'Level4';
            ToolTip = 'Specifies the Level4.';
        }
        field(20; "Level 1 Description"; Text[50])
        {
            Caption = 'Level 1 Description';
            ToolTip = 'Specifies the Level 1 Description.';
        }
        field(21; "Level 2 Description"; Text[50])
        {
            Caption = 'Level 2 Description';
            ToolTip = 'Specifies the Level 2 Description.';
        }
        field(22; "Level 3 Description"; Text[50])
        {
            Caption = 'Level 3 Description';
            ToolTip = 'Specifies the Level 3 Description.';
        }
        field(23; "Level 4 Description"; Text[50])
        {
            Caption = 'Level 4 Description';
            ToolTip = 'Specifies the Level 4 Description.';
        }
        field(1000; "Purchase Quantity"; Decimal)
        {
            Caption = 'Purchase Quantity';
            ToolTip = 'Specifies the Purchase Quantity.';
        }
        field(1001; "Purchase Value"; Decimal)
        {
            Caption = 'Purchase Value';
            ToolTip = 'Specifies the Purchase Value.';
        }
        field(1002; "Purchase Value Sales"; Decimal)
        {
            Caption = 'Purchase Value Sales';
            ToolTip = 'Specifies the Purchase Value Sales.';
        }
        field(1010; "Plan Sales Amount"; Decimal)
        {
            Caption = 'Plan Sales Amount';
            ToolTip = 'Specifies the Plan Sales Amount.';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; Level1, Level2, Level3, Level4)
        {
        }
    }

    fieldgroups
    {
    }
}

