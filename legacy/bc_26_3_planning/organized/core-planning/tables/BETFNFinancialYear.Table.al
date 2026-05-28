/// <summary>
/// [planning]
/// Modules: 
/// </summary>
table 5138636 "BET FN Financial Year"
{
    Caption = 'Planning Period';
    DrillDownPageId = "BET FN Financial Year";
    LookupPageId = "BET FN Financial Year";
    DataClassification = CustomerContent;
    Access = Public;
    Extensible = true;

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
            NotBlank = true;
            ToolTip = 'Specifies the Code.';
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
            ToolTip = 'Specifies the Description.';
        }
        field(10; "Start Date"; Date)
        {
            Caption = 'Start Date';
            ToolTip = 'Specifies the Start Date.';
        }
        field(11; "End Date"; Date)
        {
            Caption = 'End Date';
            ToolTip = 'Specifies the End Date.';
        }
        field(12; "Reference Period"; Code[10])
        {
            Caption = 'Reference Period';
            TableRelation = "BET FN Financial Year";
            ToolTip = 'Specifies the Reference Period.';
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

