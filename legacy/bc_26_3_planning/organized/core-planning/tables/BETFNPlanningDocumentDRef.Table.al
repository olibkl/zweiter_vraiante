/// <summary>
/// [planning]
/// Modules: 
/// </summary>
table 5138647 "BET FN Planning Document D Ref"
{
    Caption = 'Planning Doc. Date Reference';
    DrillDownPageId = "BET FN Planning Document D Ref";
    LookupPageId = "BET FN Planning Document D Ref";
    DataClassification = CustomerContent;
    Access = Public;
    Extensible = true;

    fields
    {
        field(1; "Planning Document No."; Code[20])
        {
            Caption = 'Planning Document No.';
            NotBlank = true;
            TableRelation = "BET FN Planning Document";
            ToolTip = 'Specifies the Planning Document No.';
        }
        field(2; Date; Date)
        {
            Caption = 'Date';
            ToolTip = 'Specifies the Date.';
        }
        field(3; "Reference Date"; Date)
        {
            Caption = 'Reference Date';
            ToolTip = 'Specifies the Reference Date.';
        }
        field(1003; Percentage; Decimal)
        {
            Caption = 'Percentage';

            ObsoleteState = Pending;
            ObsoleteTag = '26.0';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Percentage.';
        }
        field(1005; Weight; Decimal)
        {
            Caption = 'Weight';

            ObsoleteState = Pending;
            ObsoleteTag = '26.0';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Weight.';
        }
    }

    keys
    {
        key(Key1; "Planning Document No.", Date)
        {
            Clustered = true;
        }
    }
}

