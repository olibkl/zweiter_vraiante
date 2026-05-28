/// <summary>
/// [planning]
/// Modules: 
/// </summary>
page 5138643 "BET FN Planning Documents"
{
    ApplicationArea = All;
    Caption = 'Planning Documents';
    CardPageId = "BET FN Planning Document";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "BET FN Planning Document";
    UsageCategory = Lists;
    Extensible = true;

    layout
    {
        area(Content)
        {
            repeater(Control1117300000)
            {
                ShowCaption = false;
                field("No."; Rec."No.")
                {
                }

                field(Description; Rec.Description)
                {
                }
                field("Financial Year"; Rec."Financial Year")
                {
                }
                field("Planning Type"; Rec."Planning Type")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("Is Copy"; Rec."Is Copy")
                {
                }
                field("Copy From Document No."; Rec."Copy From Document No.")
                {
                }
                field("Document Type"; Rec."Document Type")
                {
                    ObsoleteState = Pending;
                    ObsoleteTag = '25.2';
                    ObsoleteReason = '#19247 Pending removal - will be removed in future updates';

                    Visible = false;
                    Editable = false;
                    Enabled = false;
                }
            }
        }
        area(FactBoxes)
        {
            systempart(Control1900383207; Links)
            {
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
    }
}

