/// <summary>
/// [planning]
/// Modules: 
/// </summary>
page 5138644 "BET FN Planning Document Lvls"
{
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Planning Document Levels';
    DataCaptionExpression = Rec."Planning Document No.";
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    ShowFilter = false;
    SourceTable = "BET FN Planning Document Level";
    SourceTableView = sorting("Planning Document No.", "Planning Document Level Index");
    Extensible = true;

    layout
    {
        area(Content)
        {
            repeater(Control1117300000)
            {
                IndentationColumn = Rec."Planning Document Level Index";
                ShowCaption = false;
                field("Planning Document Level Index"; Rec."Planning Document Level Index")
                {
                    Caption = 'Level';
                    Editable = false;
                }
                field("Index Code"; Rec."Index Code")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Index Description"; Rec."Index Description")
                {
                    Editable = false;
                }
                field("Index Table No."; Rec."Index Table No.")
                {
                    Editable = false;
                    Visible = false;
                }
                field("No. of Source-Records"; Rec."No. of Source-Records")
                {
                    Editable = false;

                    trigger OnDrillDown()
                    var
                        PlanDoc_LT: Record "BET FN Planning Document";
                    begin
                        if PlanDoc_LT.Get(Rec."Planning Document No.") then begin
                            ShowSourceRecords(Rec, (PlanDoc_LT."Planning Document Created" = 0DT));
                            CalcBufferElements();
                            CurrPage.Update(false);
                        end;
                    end;
                }
                field("Activate Date Level"; Rec."Activate Date Level")
                {
                    Editable = FunctionEnable_G;

                    trigger OnValidate()
                    var
                        PlanDoc_LT: Record "BET FN Planning Document";
                        PlanDocLevel_LT: Record "BET FN Planning Document Level";
                    begin
                        if PlanDoc_LT.Get(Rec."Planning Document No.") then
                            if PlanDoc_LT."Planning Document Created" <> 0DT then
                                Error(NoAlterationOfLevelsPossibleErr);

                        if Rec."Activate Date Level" then
                            Rec."No. of Records on Date Level" := Rec."No. of Records" * PlanDoc_LT."No. of Date-Records"
                        else
                            Rec."No. of Records on Date Level" := 0;

                        PlanDocLevel_LT.Reset();
                        PlanDocLevel_LT.SetRange("Planning Document No.", Rec."Planning Document No.");
                        PlanDocLevel_LT.SetFilter("Index Code", '<>%1', Rec."Index Code");    //### alle anderen Ebenen mit anpassen
                        if PlanDocLevel_LT.Find('-') then
                            repeat
                                PlanDocLevel_LT."Activate Date Level" := Rec."Activate Date Level";
                                if Rec."Activate Date Level" then
                                    PlanDocLevel_LT."No. of Records on Date Level" := PlanDocLevel_LT."No. of Records" * PlanDoc_LT."No. of Date-Records"
                                else
                                    PlanDocLevel_LT."No. of Records on Date Level" := 0;
                                PlanDocLevel_LT.Modify();
                            until PlanDocLevel_LT.Next() = 0;

                        CurrPage.Update();
                    end;
                }
                field("No. of Records"; Rec."No. of Records")
                {
                    Editable = false;
                    Style = Strong;
                    StyleExpr = WarningStyle_G;
                }
                field("No. of Records on Date Level"; Rec."No. of Records on Date Level")
                {
                    Editable = false;
                    Style = Strong;
                    StyleExpr = WarningStyleDate_G;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group(Levels)
            {
                Caption = 'Levels';
                action("Copy Levels from Planning Document")
                {
                    Caption = 'Copy Levels from Planning Document';
                    ToolTip = 'Copy Levels from Planning Document';
                    Image = CopyBOM;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = true;
                    ShortcutKey = 'Ctrl+T';

                    trigger OnAction()
                    var
                        BETFNPlanningDocumentMgt: Codeunit "BET FN Planning Document Mgt";
                    begin
                        CopyLevelsFromPlanningDocument();
                        BETFNPlanningDocumentMgt.UpdateNoOfRecords(Rec);
                        CurrPage.Update();
                    end;
                }
                action("Insert Level")
                {
                    Caption = 'Insert Level';
                    ToolTip = 'Insert Level';
                    Image = Add;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = true;
                    ShortcutKey = 'Ctrl+N';

                    trigger OnAction()
                    begin
                        CreateNewLine();
                    end;
                }
                action("Delete Level")
                {
                    Caption = 'Delete Level';
                    ToolTip = 'Delete Level';
                    Image = Delete;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = true;
                    ShortcutKey = 'Ctrl+E';

                    trigger OnAction()
                    begin
                        DeleteLine();
                    end;
                }
            }
            group("Function")
            {
                Caption = 'Functions';
                action("Edit Source Records")
                {
                    Caption = 'Edit Source Records';
                    ToolTip = 'Edit Source Records';
                    Image = Edit;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = true;

                    trigger OnAction()
                    var
                        PlanDoc_LT: Record "BET FN Planning Document";
                    begin
                        if PlanDoc_LT.Get(Rec."Planning Document No.") and (PlanDoc_LT.Status = PlanDoc_LT.Status::Open) then
                            ShowSourceRecords(Rec, (PlanDoc_LT."Planning Document Created" = 0DT));
                    end;
                }
                action("Open Planning Document")
                {
                    Caption = 'Open Planning Document';
                    ToolTip = 'Open Planning Document';
                    Image = PlanningWorksheet;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        OpenPlanningView(Rec);
                    end;
                }
                action("Enter Percent Data for Date")
                {
                    Caption = 'Enter Percent Data for Date';
                    ToolTip = 'Enter Percent Data for Date';
                    Image = DataEntry;
                    Enabled = false;
                    RunObject = page "BET FN Planning Document D Ref";
                    RunPageLink = "Planning Document No." = field("Planning Document No.");
                    Visible = false;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if Rec."No. of Records" > PlanSetup_GT."No. of Records for Warning" then
            WarningStyle_G := 'Attention'
        else
            WarningStyle_G := 'None';

        if Rec."No. of Records on Date Level" > PlanSetup_GT."No. of Records for Warning" then
            WarningStyleDate_G := 'Attention'
        else
            WarningStyleDate_G := 'None';
    end;

    trigger OnInit()
    begin
        FunctionEnable_G := false;
    end;

    trigger OnOpenPage()
    var
        PlanDocLevel_LT: Record "BET FN Planning Document Level";
        PlanView_LT: Record "BET FN Planning View";
        LevelLbl: Label ' Levels';
    begin
        Rec.FilterGroup(2);
        if not PlanDoc_GT.Get(Rec.GetFilter("Planning Document No.")) then begin
            Rec.FilterGroup(0);
            PlanDoc_GT.Get(Rec.GetFilter("Planning Document No."));
        end;
        Rec.FilterGroup(0);

        FunctionEnable_G := PlanDoc_GT."Planning Document Created" = 0DT;
        CurrPage.Caption(PlanDoc_GT.TableCaption() + LevelLbl);

        PlanDocLevel_LT.Reset();

        // ### Gesamtebene: Datumszeilen berechnen
        //if PlanDocLevel_LT.Get(PlanDoc_GT."No.", 0) then
        //  UpdateNoOfRecords(PlanDocLevel_LT);

        PlanView_LT.Reset();
        PlanView_LT.SetRange("Planning Document No.", Rec.GetFilter("Planning Document No."));

        PlanSetup_GT.Get();
    end;

    var
        PlanDoc_GT: Record "BET FN Planning Document";
        PlanSetup_GT: Record "BET FN Planning Setup";
        FunctionEnable_G: Boolean;
        ChangingLevelsNotAllowedErr: Label 'Planning Document already created. Changing Levels not allowed.';
        NoAlterationOfLevelsPossibleErr: Label 'Planning Document already created. No alteration of Levels possible.';
        NoSourceRecordsFoundErr: Label 'No Source-Records found.';
        WarningStyle_G: Text;
        WarningStyleDate_G: Text;

    /// <summary>
    /// CreateNewLine.
    /// </summary>
    procedure CreateNewLine()
    var
        PlanDocLevel_LT: Record "BET FN Planning Document Level";
        PlanDocMgmt_LC: Codeunit "BET FN Planning Document Mgt";
    begin
        //### neue Ebene immer ganz unten einfügen:
        PlanDocLevel_LT.Reset();
        PlanDocLevel_LT.SetRange("Planning Document No.", Rec."Planning Document No.");
        PlanDocLevel_LT.FindLast();

        PlanDocMgmt_LC.CreateNewLevelLine(PlanDocLevel_LT);
    end;

    /// <summary>
    /// DeleteLine.
    /// </summary>
    procedure DeleteLine()
    var
        PlanDocLevel_LT: Record "BET FN Planning Document Level";
        PlanDocMgmt_LC: Codeunit "BET FN Planning Document Mgt";
    begin
        //### immer unterste Ebene löschen:
        //PlanDocMgmt_LC.DeleteLevelLine(Rec);
        PlanDocLevel_LT.Reset();
        PlanDocLevel_LT.SetRange("Planning Document No.", Rec."Planning Document No.");
        PlanDocLevel_LT.SetRange("Path End", true);
        PlanDocLevel_LT.FindLast();
        PlanDocMgmt_LC.DeleteLevelLine(PlanDocLevel_LT);

        CurrPage.Update(false);
    end;

    /// <summary>
    /// ShowSourceRecords.
    /// </summary>
    /// <param name="PlanDocLevel_PT">Record "BET FN Planning Document Level".</param>
    /// <param name="EditYN_P">Boolean.</param>
    procedure ShowSourceRecords(PlanDocLevel_PT: Record "BET FN Planning Document Level"; EditYN_P: Boolean)
    var
        PlanDocLevelBuffer_LT: Record "BET FN Planning Doc Lvl Buf";
    begin
        PlanDocLevelBuffer_LT.FilterGroup(2);
        PlanDocLevelBuffer_LT.SetRange("Planning Document No.", PlanDocLevel_PT."Planning Document No.");
        PlanDocLevelBuffer_LT.SetRange("Planning Document Level", PlanDocLevel_PT."Planning Document Level Index");

        PlanDocLevelBuffer_LT.FilterGroup(0);
        if not PlanDocLevelBuffer_LT.Find('-') then
            Error(NoSourceRecordsFoundErr);
        if EditYN_P then
            Page.RunModal(Page::"BET FN Plng Doc Lvl Buf Edit", PlanDocLevelBuffer_LT)
        else
            Page.RunModal(Page::"BET FN Planning Doc Lvl Buf", PlanDocLevelBuffer_LT);

        CurrPage.Update();
    end;

    /// <summary>
    /// OpenLevelForm.
    /// </summary>
    procedure OpenLevelForm()
    var
        LevelBuffer_LT: Record "BET FN Planning Doc Lvl Buf";
    begin
        LevelBuffer_LT.Reset();
        LevelBuffer_LT.FilterGroup(2);
        LevelBuffer_LT.SetRange("Planning Document No.", Rec."Planning Document No.");
        LevelBuffer_LT.SetRange("Planning Document Level", Rec."Planning Document Level Index");
        LevelBuffer_LT.FilterGroup(0);
#pragma warning disable LC0039
        Page.RunModal(Page::"BET FN Planning Type", LevelBuffer_LT);
#pragma warning restore LC0039
    end;

    /// <summary>
    /// CopyLevelsFromPlanningDocument.
    /// </summary>
    procedure CopyLevelsFromPlanningDocument()
    var
        PlanDoc_LT: Record "BET FN Planning Document";
        PlanDocMgmt_LC: Codeunit "BET FN Planning Document Mgt";
    begin
        if PlanDoc_LT.Get(Rec."Planning Document No.") and (PlanDoc_LT."Planning Document Created" = 0DT) then
            PlanDocMgmt_LC.CopyLevelsFromPlanningDocument(PlanDoc_LT, true)   // true: Confirm + händische Belegauswahl
        else
            Error(ChangingLevelsNotAllowedErr);
    end;

    /// <summary>
    /// CalcBufferElements.
    /// </summary>
    procedure CalcBufferElements()
    var
        PlanDocMgmt_LC: Codeunit "BET FN Planning Document Mgt";
    begin
        PlanDocMgmt_LC.CountBufferPerLevel(PlanDoc_GT."No.");
    end;

    /// <summary>
    /// OpenPlanningView.
    /// </summary>
    /// <param name="PlanDocLevel_PT">Record "BET FN Planning Document Level".</param>
    procedure OpenPlanningView(PlanDocLevel_PT: Record "BET FN Planning Document Level")
    var
        PlanView_LT: Record "BET FN Planning View";
    begin
        PlanView_LT.Reset();
        PlanView_LT.SetCurrentKey("Planning Document No.", "Planning Document Level", "Index 1", "Index 2", "Index 3", "Index 4", "Index 5", "Index 6", Date);
        PlanView_LT.SetRange("Planning Document No.", PlanDocLevel_PT."Planning Document No.");
        PlanView_LT.SetRange("Planning Document Level", PlanDocLevel_PT."Planning Document Level Index");
        Page.Run(Page::"BET FN Planning View", PlanView_LT);
    end;
}

