/// <summary>
/// [planning]
/// Modules: 
/// </summary>
page 5138641 "BET FN Planning Export Fld Ref"
{
    ApplicationArea = All;
    Caption = 'Planning Export Fieldreference';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "BET FN Planning Export Fld Ref";
    UsageCategory = Lists;
    Extensible = true;

    layout
    {
        area(Content)
        {
            repeater(Control1117300000)
            {
                ShowCaption = false;
                field("Cube Field No."; Rec."Cube Field No.")
                {
                }
                field("Export Field No."; Rec."Export Field No.")
                {
                }
                field("Cube Field Description"; Rec."Cube Field Description")
                {
                    Editable = false;
                }
                field("Export Field Description"; Rec."Export Field Description")
                {
                    Editable = false;
                }
                field("Reverse Sign"; Rec."Reverse Sign")
                {
                }
            }
        }
    }

    actions
    {
    }
}

