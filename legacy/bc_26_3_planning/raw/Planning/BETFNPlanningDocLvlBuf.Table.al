/// <summary>
/// [planning]
/// Modules: 
/// </summary>
table 5138645 "BET FN Planning Doc Lvl Buf"
{
    Caption = 'Planning Document Level Buffer';
    DrillDownPageId = "BET FN Planning Doc Lvl Buf";
    LookupPageId = "BET FN Planning Doc Lvl Buf";
    DataClassification = CustomerContent;
    Access = Public;
    Extensible = true;

    fields
    {
        field(1; "Planning Document No."; Code[20])
        {
            Caption = 'Planning Document No.';
            TableRelation = "BET FN Planning Document";
            ToolTip = 'Specifies the Planning Document No.';
        }
        field(2; "Planning Document Level"; Integer)
        {
            Caption = 'Planning Document Level';
            ToolTip = 'Specifies the Planning Document Level.';
        }
        field(1000; "Index Code"; Code[20])
        {
            Caption = 'Index Code';
            ToolTip = 'Specifies the Index Code.';
        }
        field(1001; "Index Description"; Text[50])
        {
            Caption = 'Index Description';
            ToolTip = 'Specifies the Index Description.';
        }
        field(1003; Percentage; Decimal)
        {
            Caption = 'Percentage';

            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(1007; Active; Boolean)
        {
            Caption = 'Active';
            ToolTip = 'Specifies the Active.';
        }
        field(1008; Weight; Decimal)
        {
            Caption = 'Weight';

            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(1009; Dummy; Boolean)
        {
            Caption = 'Dummy';
            ToolTip = 'Specifies the Dummy.';
        }
    }

    keys
    {
#pragma warning disable AL0432
        key(Key1; "Planning Document No.", "Planning Document Level", "Index Code")
        {
            Clustered = true;
        }
#pragma warning restore AL0432
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        TestField("Index Code");
    end;
}

