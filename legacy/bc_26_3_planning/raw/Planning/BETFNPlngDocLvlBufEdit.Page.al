/// <summary>
/// [planning]
/// Modules: 
/// </summary>
#pragma warning disable AL0432
page 5138647 "BET FN Plng Doc Lvl Buf Edit"
{
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Planning Document Level';
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "BET FN Planning Doc Lvl Buf";
    SourceTableView = sorting("Planning Document No.", "Planning Document Level", "Index Code");
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
                field(Active; Rec.Active)
                {
                    trigger OnValidate()
                    begin
                        SetActive();
                    end;
                }
                field("Index Description"; Rec."Index Description")
                {
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Activate all")
            {
                Caption = 'Activate all';
                ToolTip = 'Activate all';
                Image = Start;

                trigger OnAction()
                begin
                    SetAllActive();
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';

                actionref("Activate all_Promoted"; "Activate all")
                {
                }
            }
        }
    }

    trigger OnClosePage()
    var
        LevelBuffer_LT: Record "BET FN Planning Doc Lvl Buf";
        OneElementMustbeActivatedMsg: Label 'At least one element per level must be activated.';
    begin
        LevelBuffer_LT.Reset();
        LevelBuffer_LT.SetRange("Planning Document No.", Rec."Planning Document No.");
        LevelBuffer_LT.SetRange("Planning Document Level", Rec."Planning Document Level");
        LevelBuffer_LT.SetRange(Active, true);
        if LevelBuffer_LT.Count() < 1 then
            Message(OneElementMustbeActivatedMsg);
    end;

    trigger OnOpenPage()
    var
        PlanDoc_LT: Record "BET FN Planning Document";
        PlanDocLevel_LT: Record "BET FN Planning Document Level";
        vert_L: Integer;
        PlanDocNotFoundErr: Label 'Planning Document not found.';
        DocNo_L: Text[30];
    begin
        Rec.FilterGroup(2);
        if not Evaluate(DocNo_L, Rec.GetFilter("Planning Document No.")) then
            exit;
        if not Evaluate(vert_L, Rec.GetFilter("Planning Document Level")) then
            exit;
        Rec.FilterGroup(0);

        AllActive_G := false;

        if not PlanDoc_LT.Get(DocNo_L) then
            Error(PlanDocNotFoundErr);

        if vert_L = 0 then
            CurrPage.Editable(false);

        //### Ebene in Fenstercaption anzeigen:
        if PlanDocLevel_LT.Get(DocNo_L, vert_L) then
            CurrPage.Caption(CurrPage.Caption() + ' - ' + PlanDocLevel_LT."Index Description");
    end;

    var
        AllActive_G: Boolean;

    /// <summary>
    /// SetActive.
    /// </summary>
    procedure SetActive()
    var
        PlanDocLevel_LT: Record "BET FN Planning Document Level";
        PlanFunctions_LC: Codeunit "BET FN Planning Functions";
        BETFNPlanningDocumentMgt: Codeunit "BET FN Planning Document Mgt";
    begin
        PlanFunctions_LC.SetRelatedBufferLines(Rec, Rec.Active);

        if PlanDocLevel_LT.Get(Rec."Planning Document No.", 0) then
            BETFNPlanningDocumentMgt.UpdateNoOfRecords(PlanDocLevel_LT);

        CurrPage.Update();
    end;

    /// <summary>
    /// SetAllActive.
    /// </summary>
    procedure SetAllActive()
    var
        LevelBuffer_LT: Record "BET FN Planning Doc Lvl Buf";
        PlanDocLevelBuffer_LT: Record "BET FN Planning Doc Lvl Buf";
        PlanFunctions_LC: Codeunit "BET FN Planning Functions";
    begin
        //### wenn nicht alle aktiv sind: setze nur inaktive aktiv und bearbeite nur diese Zeilen
        //### wenn alle aktiv sind: bearbeite alle Zeilen
        PlanDocLevelBuffer_LT.Reset();
        PlanDocLevelBuffer_LT.CopyFilters(Rec);
        PlanDocLevelBuffer_LT.SetRange("Planning Document No.", Rec."Planning Document No.");
        PlanDocLevelBuffer_LT.SetRange("Planning Document Level", Rec."Planning Document Level");
        PlanDocLevelBuffer_LT.SetRange(Active, false);
        if PlanDocLevelBuffer_LT.FindFirst() then
            AllActive_G := false
        else
            AllActive_G := true;

        PlanDocLevelBuffer_LT.SetRange(Active);
        PlanDocLevelBuffer_LT.ModifyAll(Active, not AllActive_G);

        LevelBuffer_LT.Reset();
        LevelBuffer_LT.SetRange("Planning Document No.", Rec."Planning Document No.");
        LevelBuffer_LT.SetRange("Planning Document Level", Rec."Planning Document Level");

        if LevelBuffer_LT.Find('-') then
            repeat
                PlanFunctions_LC.SetRelatedBufferLines(LevelBuffer_LT, not AllActive_G);
            until LevelBuffer_LT.Next() = 0;
    end;
}

