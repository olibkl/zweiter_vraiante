/// <summary>
/// [planning]
/// Modules: 
/// </summary>
page 5138651 "BET FN Planning Buffer Selctn"
{
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Planning Buffer Selection';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "BET FN Planning Doc Lvl Buf";
    Extensible = true;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Planning Document No."; Rec."Planning Document No.")
                {
                    Visible = false;
                }
                field("Planning Document Level"; Rec."Planning Document Level")
                {
                    Visible = false;
                }
                field("Index Code"; Rec."Index Code")
                {
                }
                field("Index Description"; Rec."Index Description")
                {
                }
                field(Active; Rec.Active)
                {
                }
                field(Dummy; Rec.Dummy)
                {
                }
            }
        }
    }

    actions
    {
    }
}

