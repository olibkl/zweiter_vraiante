/// <summary>
/// [planning]
/// Modules: 
/// </summary>
page 5138657 "BET FN Planning Levels List"
{
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Planning Levels List';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "BET FN Planning Level";
    SourceTableView = sorting("Index Code");
    Extensible = true;

    layout
    {
        area(Content)
        {
            repeater(Control1117300000)
            {
                ShowCaption = false;
                field("Index Code"; Rec."Index Code")
                {
                }
                field("Index Description"; Rec."Index Description")
                {
                }
                field("Index Table No."; Rec."Index Table No.")
                {
                }
                field("Assigned to Index"; Rec."Assigned to Index")
                {
                }
            }
        }
    }

    actions
    {
    }
}

