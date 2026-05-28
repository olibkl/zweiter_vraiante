/// <summary>
/// [planning]
/// Modules: 
/// </summary>
#pragma warning disable AL0432
page 5138650 "BET FN Planning View Filters"
{

    Caption = 'Planning View Filters';
    DataCaptionExpression = '';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "BET FN Planning View";
    UsageCategory = None;
    ApplicationArea = All;
    Extensible = true;

    layout
    {
        area(Content)
        {
            group("Filter")
            {
                group(Filters)
                {
                    Caption = 'Filters';
                    field(IF1; IndexFilterArray_G[1])
                    {
                        ToolTip = 'Specifies the IF1.';
                        CaptionClass = IndexCaption_G[1];
                        Enabled = IF1Enable_G;
                        Visible = IF1Visible_G;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            PlanDocLevelBuffer_GT.SetRange(Active, true);
                            if Page.RunModal(0, PlanDocLevelBuffer_GT) = Action::LookupOK then begin
                                IndexFilterArray_G[1] := PlanDocLevelBuffer_GT."Index Code";
                                SetFilters();
                            end;
                        end;

                        trigger OnValidate()
                        begin
                            SetFilters();
                        end;
                    }
                    field(IF2; IndexFilterArray_G[2])
                    {
                        ToolTip = 'Specifies the IF2.';
                        CaptionClass = IndexCaption_G[2];
                        Enabled = IF2Enable_G;
                        Visible = IF2Visible_G;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            PlanDocLevelBuffer_GT.SetRange(Active, true);
                            if Page.RunModal(0, PlanDocLevelBuffer_GT) = Action::LookupOK then begin
                                IndexFilterArray_G[2] := PlanDocLevelBuffer_GT."Index Code";
                                SetFilters();
                            end;
                        end;

                        trigger OnValidate()
                        begin
                            SetFilters();
                        end;
                    }
                    field(IF3; IndexFilterArray_G[3])
                    {
                        ToolTip = 'Specifies the IF3.';
                        CaptionClass = IndexCaption_G[3];
                        Enabled = IF3Enable_G;
                        Visible = IF3Visible_G;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            PlanDocLevelBuffer_GT.SetRange(Active, true);
                            if Page.RunModal(0, PlanDocLevelBuffer_GT) = Action::LookupOK then begin
                                IndexFilterArray_G[3] := PlanDocLevelBuffer_GT."Index Code";
                                SetFilters();
                            end;
                        end;

                        trigger OnValidate()
                        begin
                            SetFilters();
                        end;
                    }
                    field(IF4; IndexFilterArray_G[4])
                    {
                        ToolTip = 'Specifies the IF4.';
                        CaptionClass = IndexCaption_G[4];
                        Enabled = IF4Enable_G;
                        Visible = IF4Visible_G;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            PlanDocLevelBuffer_GT.SetRange(Active, true);
                            if Page.RunModal(0, PlanDocLevelBuffer_GT) = Action::LookupOK then begin
                                IndexFilterArray_G[4] := PlanDocLevelBuffer_GT."Index Code";
                                SetFilters();
                            end;
                        end;

                        trigger OnValidate()
                        begin
                            SetFilters();
                        end;
                    }
                    field(IF5; IndexFilterArray_G[5])
                    {
                        ToolTip = 'Specifies the IF5.';
                        CaptionClass = IndexCaption_G[5];
                        Enabled = IF5Enable_G;
                        Visible = IF5Visible_G;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            PlanDocLevelBuffer_GT.SetRange(Active, true);
                            if Page.RunModal(0, PlanDocLevelBuffer_GT) = Action::LookupOK then begin
                                IndexFilterArray_G[5] := PlanDocLevelBuffer_GT."Index Code";
                                SetFilters();
                            end;
                        end;

                        trigger OnValidate()
                        begin
                            SetFilters();
                        end;
                    }
                    field(IF6; IndexFilterArray_G[6])
                    {
                        ToolTip = 'Specifies the IF6.';
                        CaptionClass = IndexCaption_G[6];
                        Enabled = IF6Enable_G;
                        Visible = IF6Visible_G;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            PlanDocLevelBuffer_GT.SetRange(Active, true);
                            if Page.RunModal(0, PlanDocLevelBuffer_GT) = Action::LookupOK then begin
                                IndexFilterArray_G[6] := PlanDocLevelBuffer_GT."Index Code";
                                SetFilters();
                            end;
                        end;

                        trigger OnValidate()
                        begin
                            SetFilters();
                        end;
                    }
                }
                group("Quick access")
                {
                    Caption = 'Quick access';
                    field("QuickAccessArray_G[1]"; QuickAccessArray_G[1])
                    {
                        ToolTip = 'Specifies the QuickAccessArray_G[1].';
                        CaptionClass = QACaption_G[1];
                        Visible = IF1Visible_G;

                        trigger OnValidate()
                        begin
                            SetQuickAccess(1);
                        end;
                    }
                    field("QuickAccessArray_G[2]"; QuickAccessArray_G[2])
                    {
                        ToolTip = 'Specifies the QuickAccessArray_G[2].';
                        CaptionClass = QACaption_G[2];
                        Visible = IF2Visible_G;

                        trigger OnValidate()
                        begin
                            SetQuickAccess(2);
                        end;
                    }
                    field("QuickAccessArray_G[3]"; QuickAccessArray_G[3])
                    {
                        ToolTip = 'Specifies the QuickAccessArray_G[3].';
                        CaptionClass = QACaption_G[3];
                        Visible = IF3Visible_G;

                        trigger OnValidate()
                        begin
                            SetQuickAccess(3);
                        end;
                    }
                    field("QuickAccessArray_G[4]"; QuickAccessArray_G[4])
                    {
                        ToolTip = 'Specifies the QuickAccessArray_G[4].';
                        CaptionClass = QACaption_G[4];
                        Visible = IF4Visible_G;

                        trigger OnValidate()
                        begin
                            SetQuickAccess(4);
                        end;
                    }
                    field("QuickAccessArray_G[5]"; QuickAccessArray_G[5])
                    {
                        ToolTip = 'Specifies the QuickAccessArray_G[5].';
                        CaptionClass = QACaption_G[5];
                        Visible = IF5Visible_G;

                        trigger OnValidate()
                        begin
                            SetQuickAccess(5);
                        end;
                    }
                    field("QuickAccessArray_G[6]"; QuickAccessArray_G[6])
                    {
                        ToolTip = 'Specifies the QuickAccessArray_G[6].';
                        CaptionClass = QACaption_G[6];
                        Visible = IF6Visible_G;

                        trigger OnValidate()
                        begin
                            SetQuickAccess(6);
                        end;
                    }
                }
            }
            group(Control5079209)
            {
                ShowCaption = false;
                field(Control_DateFilter; DateFilter_G)
                {
                    ToolTip = 'Specifies the date filter.';
                    Caption = 'Date Filter';
                    Enabled = Control_DateFilterEnable_G;

                    trigger OnValidate()
                    begin
                        SetFilters();
                    end;
                }
                field("Date Filter Activated"; DateFilterActivated_G)
                {
                    ToolTip = 'Specifies if the date filter is activated.';
                    Caption = 'Show Date Level';
                    Editable = DateFilterEditable_G;

                    trigger OnValidate()
                    begin
                        DateFilterActivatedOnAfterVali();
                    end;
                }
                field("QuickAccessArray_G[7]"; QuickAccessArray_G[7])
                {
                    ToolTip = 'Specifies the QuickAccessArray_G[7].';
                    Caption = 'Quick access date';
                    Enabled = Control_DateFilterEnable_G;

                    trigger OnValidate()
                    begin
                        SetQuickAccess(7);
                    end;
                }
                field("QuickAccessArray_G[8]"; QuickAccessArray_G[8])
                {
                    ToolTip = 'Specifies the QuickAccessArray_G[8].';
                    Caption = 'No quick access';

                    trigger OnValidate()
                    begin
                        SetQuickAccess(8);
                    end;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ResetFiltersAction)
            {
                Caption = 'Reset filters';
                ToolTip = 'Reset filters';
                Image = RemoveFilterLines;

                trigger OnAction()
                begin
                    ResetFilters();
                end;
            }
        }
        area(Promoted)
        {
            group(Category_New)
            {
                Caption = 'New';

                actionref(ResetFiltersAction_Promoted; ResetFiltersAction)
                {
                }
            }
        }
    }

    trigger OnInit()
    begin
        IF6Enable_G := true;
        IF5Enable_G := true;
        IF4Enable_G := true;
        IF3Enable_G := true;
        IF2Enable_G := true;
        IF1Enable_G := true;
        Control_DateFilterEnable_G := true;
    end;

    trigger OnOpenPage()
    var
        DocNo_L: Code[10];
        Vert_L: Integer;
        EvaluatePlanningDocumentLevelErr: Label 'Error while evaluating "Planning Document Level vert.".';
        EvaluatePlanningDocumentNoErr: Label 'Error while evaluating "Planning Document No.".';
    begin
        Rec.FilterGroup(2);
        if not Evaluate(DocNo_L, Rec.GetFilter("Planning Document No.")) then
            Error(EvaluatePlanningDocumentNoErr);
        if not Evaluate(Vert_L, Rec.GetFilter("Planning Document Level")) then
            Error(EvaluatePlanningDocumentLevelErr);

        PlanDocLevelBuffer_GT.Reset();
        PlanDocLevelBuffer_GT.SetRange("Planning Document No.", DocNo_L);
        PlanDocLevel_GT.Get(DocNo_L, Vert_L);

        DateFilterEditable_G := PlanDocLevel_GT."Activate Date Level";     //### Datumsfilter deaktivieren bei Belegen ohne Datum

        PlanDocFilterMgmt_GC.GetFilterValues(IndexFilterArray_G,
                                             DateFilterActivated_G,
                                             DateFilter_G,
                                             QuickAccess_G);

        case QuickAccess_G of
            QuickAccess_G::" ":
                QuickAccessArray_G[8] := true;
            QuickAccess_G::Date:
                QuickAccessArray_G[7] := true;
            QuickAccess_G::Index1:
                QuickAccessArray_G[1] := true;
            QuickAccess_G::Index2:
                QuickAccessArray_G[2] := true;
            QuickAccess_G::Index3:
                QuickAccessArray_G[3] := true;
            QuickAccess_G::Index4:
                QuickAccessArray_G[4] := true;
            QuickAccess_G::Index5:
                QuickAccessArray_G[5] := true;
            QuickAccess_G::Index6:
                QuickAccessArray_G[6] := true;
        end;

        GetIndex();
        SetFilters();
        Rec.FilterGroup(0);
    end;

    var
        PlanDocLevelBuffer_GT: Record "BET FN Planning Doc Lvl Buf";
        PlanDocLevel_GT: Record "BET FN Planning Document Level";
        PlanDocFilterMgmt_GC: Codeunit "BET FN Planning Doc Fltr Mgt";
        Control_DateFilterEnable_G: Boolean;
        DateFilterActivated_G: Boolean;
        DateFilterEditable_G: Boolean;
        IF1Enable_G: Boolean;
        IF1Visible_G: Boolean;
        IF2Enable_G: Boolean;
        IF2Visible_G: Boolean;
        IF3Enable_G: Boolean;
        IF3Visible_G: Boolean;
        IF4Enable_G: Boolean;
        IF4Visible_G: Boolean;
        IF5Enable_G: Boolean;
        IF5Visible_G: Boolean;
        IF6Enable_G: Boolean;
        IF6Visible_G: Boolean;
        QuickAccessArray_G: array[8] of Boolean;
        QuickAccess_G: Option " ",Date,Index1,Index2,Index3,Index4,Index5,Index6;
        IndexFilterArray_G: array[10] of Text;
        IndexCaption_G: array[6] of Text[50];
        QACaption_G: array[6] of Text[50];
        DateFilter_G: Text[1024];

    /// <summary>
    /// GetIndex.
    /// </summary>
    procedure GetIndex()
    var
        QuickAccessLbl: Label 'Quick access ';
    begin
        IndexCaption_G[1] := PlanDocLevel_GT."Index Description 1";
        IndexCaption_G[2] := PlanDocLevel_GT."Index Description 2";
        IndexCaption_G[3] := PlanDocLevel_GT."Index Description 3";
        IndexCaption_G[4] := PlanDocLevel_GT."Index Description 4";
        IndexCaption_G[5] := PlanDocLevel_GT."Index Description 5";
        IndexCaption_G[6] := PlanDocLevel_GT."Index Description 6";

        if IndexCaption_G[1] <> '' then begin
            QACaption_G[1] := QuickAccessLbl + IndexCaption_G[1];
            IndexCaption_G[1] := 'Filter ' + IndexCaption_G[1];
        end;
        if IndexCaption_G[2] <> '' then begin
            QACaption_G[2] := QuickAccessLbl + IndexCaption_G[2];
            IndexCaption_G[2] := 'Filter ' + IndexCaption_G[2];
        end;
        if IndexCaption_G[3] <> '' then begin
            QACaption_G[3] := QuickAccessLbl + IndexCaption_G[3];
            IndexCaption_G[3] := 'Filter ' + IndexCaption_G[3];
        end;
        if IndexCaption_G[4] <> '' then begin
            QACaption_G[4] := QuickAccessLbl + IndexCaption_G[4];
            IndexCaption_G[4] := 'Filter ' + IndexCaption_G[4];
        end;
        if IndexCaption_G[5] <> '' then begin
            QACaption_G[5] := QuickAccessLbl + IndexCaption_G[5];
            IndexCaption_G[5] := 'Filter ' + IndexCaption_G[5];
        end;
        if IndexCaption_G[6] <> '' then begin
            QACaption_G[6] := QuickAccessLbl + IndexCaption_G[6];
            IndexCaption_G[6] := 'Filter ' + IndexCaption_G[6];
        end;

        IF1Visible_G := IndexCaption_G[1] <> '';
        IF2Visible_G := IndexCaption_G[2] <> '';
        IF3Visible_G := IndexCaption_G[3] <> '';
        IF4Visible_G := IndexCaption_G[4] <> '';
        IF5Visible_G := IndexCaption_G[5] <> '';
        IF6Visible_G := IndexCaption_G[6] <> '';

        IF1Enable_G := PlanDocLevel_GT."Index Code 1" <> '';
        IF2Enable_G := PlanDocLevel_GT."Index Code 2" <> '';
        IF3Enable_G := PlanDocLevel_GT."Index Code 3" <> '';
        IF4Enable_G := PlanDocLevel_GT."Index Code 4" <> '';
        IF5Enable_G := PlanDocLevel_GT."Index Code 5" <> '';
        IF6Enable_G := PlanDocLevel_GT."Index Code 6" <> '';

        IF1Visible_G := IndexCaption_G[1] <> '';
    end;

    /// <summary>
    /// SetFilters.
    /// </summary>
    procedure SetFilters()
    begin
        PlanDocFilterMgmt_GC.SetFilterValues(IndexFilterArray_G,
                                             DateFilterActivated_G,
                                             DateFilter_G,
                                             QuickAccess_G);

        Control_DateFilterEnable_G := DateFilterActivated_G;
        CurrPage.Update(false);
    end;

    local procedure DateFilterActivatedOnAfterVali()
    begin
        SetFilters();
        if (QuickAccess_G = QuickAccess_G::Date) and
           (not DateFilterActivated_G) then
            QuickAccess_G := QuickAccess_G::" ";
    end;

    /// <summary>
    /// SetQuickAccess.
    /// </summary>
    /// <param name="QAOption_P">Integer.</param>
    procedure SetQuickAccess(QAOption_P: Integer)
    begin
        Clear(QuickAccessArray_G);

        QuickAccessArray_G[QAOption_P] := true;

        case QAOption_P of
            1:
                QuickAccess_G := QuickAccess_G::Index1;
            2:
                QuickAccess_G := QuickAccess_G::Index2;
            3:
                QuickAccess_G := QuickAccess_G::Index3;
            4:
                QuickAccess_G := QuickAccess_G::Index4;
            5:
                QuickAccess_G := QuickAccess_G::Index5;
            6:
                QuickAccess_G := QuickAccess_G::Index6;
            7:
                QuickAccess_G := QuickAccess_G::Date;
            8:
                QuickAccess_G := QuickAccess_G::" ";
        end;

        SetFilters();
    end;

    /// <summary>
    /// ResetFilters.
    /// </summary>
    procedure ResetFilters()
    begin
        Clear(QuickAccessArray_G);
        QuickAccessArray_G[8] := true;

        QuickAccess_G := QuickAccess_G::" ";

        Clear(IndexFilterArray_G);
        Clear(DateFilter_G);

        SetFilters();

        CurrPage.Update(false);
    end;
}

