/// <summary>
/// [planning]
/// Modules: 
/// </summary>
page 5138658 "BET FN Planning Levels"
{
    ApplicationArea = All;
    Caption = 'Planning Levels';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "BET FN Planning Level";
    SourceTableView = sorting("Index Code");
    UsageCategory = Lists;
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
                field(Activated; Rec.Activated)
                {
                }
                field("Description in Document"; Rec."Description in Document")
                {
                }
                field("Index Table No."; Rec."Index Table No.")
                {
                }
                field("Assigned to Index"; Rec."Assigned to Index")
                {
                }
                field("Assigned to Index Field No."; Rec."Assigned to Index Field No.")
                {
                }
                field("Primary Key Field No."; Rec."Primary Key Field No.")
                {
                }
                field("Description Field No."; Rec."Description Field No.")
                {
                }
                field("Planning Statistic Field"; Rec."Planning Statistic Field")
                {
                }
                field("Fash. Stat. Entry Field"; Rec."Fash. Stat. Entry Field")
                {
                }
                field("Export Field No."; Rec."Export Field No.")
                {
                }
                field("Check Dim. Assign. Table"; Rec."Check Dim. Assign. Table")
                {
                }
                field("Dim. Assign. Field No."; Rec."Dim. Assign. Field No.")
                {
                }
                field("Use Dummy"; Rec."Use Dummy")
                {
                }
                field("Filter Field"; Rec."Filter Field")
                {
                }
                field("Filter Value"; Rec."Filter Value")
                {
                }
            }
        }
    }

    actions
    {
    }
}

