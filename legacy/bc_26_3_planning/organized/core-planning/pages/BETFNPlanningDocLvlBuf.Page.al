/// <summary>
/// [planning]
/// Modules: 
/// </summary>
page 5138646 "BET FN Planning Doc Lvl Buf"
{
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Planning Document Level';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "BET FN Planning Doc Lvl Buf";
    Extensible = true;

    layout
    {
        area(Content)
        {
            repeater(Control1117300000)
            {
                ShowCaption = false;
                field("Planning Document No."; Rec."Planning Document No.")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Planning Document Level"; Rec."Planning Document Level")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Index Code"; Rec."Index Code")
                {
                    Editable = false;
                }
                field("Index Description"; Rec."Index Description")
                {
                    Editable = false;
                }
                field(Active; Rec.Active)
                {
                    Editable = false;
                }
                field(Dummy; Rec.Dummy)
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    var
        PlanDocLevel_LT: Record "BET FN Planning Document Level";
        vert_L: Integer;
        DocNo_L: Text[30];
    begin
        Rec.FilterGroup(2);
        if not Evaluate(DocNo_L, Rec.GetFilter("Planning Document No.")) then
            exit;
        if not Evaluate(vert_L, Rec.GetFilter("Planning Document Level")) then
            exit;
        Rec.FilterGroup(0);

        // ### Ebene in Fenstercaption anzeigen:
        if PlanDocLevel_LT.Get(DocNo_L, vert_L) then
            CurrPage.Caption(CurrPage.Caption() + ' - ' + PlanDocLevel_LT."Index Description");

        CurrPage.Editable(not CurrPage.LookupMode());
    end;
}

