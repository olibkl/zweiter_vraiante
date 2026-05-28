/// <summary>
/// 
/// 
/// Modules: [planning]
/// </summary>
#pragma warning disable AL0432
page 5138640 "BET FN Planning Document"
{

    UsageCategory = None;
    Caption = 'Planning Document';
    DataCaptionFields = Description;
    PageType = Card;
    SourceTable = "BET FN Planning Document";
    ApplicationArea = All;
    Extensible = true;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    trigger OnAssistEdit()
                    var
                        PlanDoc_LT: Record "BET FN Planning Document";
                    begin
                        PlanDoc_LT := xRec;
                        if Rec.AssistEdit(PlanDoc_LT) then
                            CurrPage.Update();
                    end;
                }
                field(Description; Rec.Description)
                {
                }

                field("Planning Type"; Rec."Planning Type")
                {
                    Editable = DocNotCreated_G;

                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }

                field("Document Type"; Rec."Document Type")
                {
                    ObsoleteState = Pending;
                    ObsoleteTag = '25.2';
                    ObsoleteReason = '#35131 Pending removal - will be removed in future updates';

                    Visible = false;
                    Editable = false;
                    Enabled = false;
                }
                field("Last Update Control Doc."; Rec."Last Update Control Doc.")
                {
                    ObsoleteState = Pending;
                    ObsoleteTag = '25.2';
                    ObsoleteReason = '#35131 Pending removal - will be removed in future updates';

                    Visible = false;
                    Editable = false;
                    Enabled = false;
                }
            }
            group(Periods)
            {
                Caption = 'Period';
                group(PlanningPeriod)
                {
                    Caption = 'Planning Period';
                    field("Financial Year"; Rec."Financial Year")
                    {
                        Editable = DocNotCreated_G;

                        trigger OnValidate()
                        begin
                            CurrPage.Update();
                        end;
                    }
                    field("Start Date"; Rec."Start Date")
                    {
                        Caption = 'Start Date';
                        Editable = DocNotCreated_G;

                        trigger OnValidate()
                        begin
                            CurrPage.Update();
                        end;
                    }
                    field("End Date"; Rec."End Date")
                    {
                        Editable = DocNotCreated_G;

                        trigger OnValidate()
                        begin
                            CurrPage.Update();
                        end;
                    }
                    field("No. of Date-Records"; Rec."No. of Date-Records")
                    {
                        Caption = 'No. of Months';
                        Editable = false;
                        Enabled = false;
                        StyleExpr = NoOfMonthStyle_G;
                    }
                    field("Planning Season"; Rec."Planning Season")
                    {
                        Caption = 'Season Code';
                        Editable = DocNotCreated_G;
                    }
                }
                group(ReferencePeriod)
                {
                    Caption = 'Reference Period';
                    field("Financial Year Ref. Period"; Rec."Financial Year Ref. Period")
                    {
                        Editable = DocNotCreated_G;

                        trigger OnValidate()
                        begin
                            CurrPage.Update();
                        end;
                    }
                    field("Start Date Ref. Period"; Rec."Start Date Ref. Period")
                    {
                        Editable = DocNotCreated_G;

                        trigger OnValidate()
                        begin
                            CurrPage.Update();
                        end;
                    }
                    field("End Date Ref. Period"; Rec."End Date Ref. Period")
                    {
                        Editable = DocNotCreated_G;

                        trigger OnValidate()
                        begin
                            CurrPage.Update();
                        end;
                    }
                    field("No. of Ref.-Records"; Rec."No. of Ref.-Records")
                    {
                        Editable = false;
                        Enabled = false;
                        StyleExpr = NoOfMonthStyle_G;
                    }
                    field("Comparing Season"; Rec."Comparing Season")
                    {
                        Editable = DocNotCreated_G;
                        Lookup = true;
                    }
                }
            }
            group(DocumentStatus)
            {
                Caption = 'Status';
                field(Status; Rec.Status)
                {
                    Editable = false;
                }
                field("Is Copy"; Rec."Is Copy")
                {
                    Editable = false;
                }
                field("Copy From Document No."; Rec."Copy From Document No.")
                {
                    Editable = false;
                }
                field("Related Planning Document No."; Rec."Related Planning Document No.")
                {
                    Editable = false;
                }
                group(TimeStamps)
                {
                    Caption = 'Time Stamps';
                    field("Planning Document Created"; Rec."Planning Document Created")
                    {
                        Editable = false;
                    }
                    field("Timestamp Reference Values"; Rec."Timestamp Reference Values")
                    {
                        Caption = 'Reference Values Created';
                        Editable = false;
                    }
                    field("Timestamp Planning Values"; Rec."Timestamp Planning Values")
                    {
                        Editable = false;
                    }
                    field("Planning Values Exported"; Rec."Planning Values Exported")
                    {
                        Editable = false;
                    }
                }
            }
            group(Extra)
            {
                Caption = 'Extra';
                field("Layout Template"; Rec."Layout Template")
                {
                    ToolTip = 'Specifies the Layout Template.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        LayoutTemplate_LT: Record "BET FN Planning Layout Tmplt";
                        RecRefDoc_L: RecordRef;
                        RecRefTemplate_L: RecordRef;
                        FieldRefDoc_L: FieldRef;
                        FieldRefTemplate_L: FieldRef;
                        i_L: Integer;
                    begin
                        LayoutTemplate_LT.Reset();
                        if Page.RunModal(0, LayoutTemplate_LT) = Action::LookupOK then begin
                            if LayoutTemplate_LT.Get(LayoutTemplate_LT.Code) then begin
                                Rec."Layout Template" := LayoutTemplate_LT.Code;
                                RecRefTemplate_L.GetTable(LayoutTemplate_LT);
                                RecRefDoc_L.GetTable(Rec);
                                for i_L := 12000 to 15000 do
                                    if RecRefTemplate_L.FieldExist(i_L) and RecRefDoc_L.FieldExist(i_L) then begin
                                        FieldRefTemplate_L := RecRefTemplate_L.Field(i_L);
                                        FieldRefDoc_L := RecRefDoc_L.Field(i_L);
                                        FieldRefDoc_L.Value := FieldRefTemplate_L.Value();
                                    end;
                                RecRefDoc_L.Modify();
                            end;
                            CurrPage.Update(false);
                        end;
                    end;
                }
                field("Use Global Layout"; Rec."Use Global Layout")
                {
                    ToolTip = 'Specifies the Use Global Layout.';
                }
                field("Calculation Type"; Rec."Calculation Type")
                {
                    Importance = Additional;
                }
                field("Distribution Type"; Rec."Distribution Type")
                {
                }
                field("Auto Filter On Level Changing"; Rec."Auto Filter On Level Changing")
                {
                }
                field("Starting Level"; Rec."Starting Level")
                {
                }
                field("Show Date Description"; Rec."Show Date Description")
                {
                }
                field("Purchaser Code"; Rec."Purchaser Code")
                {
                }
                field("Purchaser Name"; Rec."Purchaser Name")
                {
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
        area(Processing)
        {
            group(Prepare)
            {
                Caption = 'Prepare Planning';
                action(DefineLevels)
                {
                    Caption = 'Define Planning Levels';
                    ToolTip = 'Define Planning Levels';
                    Image = CheckList;

                    trigger OnAction()
                    begin
                        ShowPlanningLevels();
                    end;
                }
                action(CreateDocument)
                {
                    Caption = 'Create Planning Document';
                    ToolTip = 'Create Planning Document';
                    Image = CreateDocument;

                    trigger OnAction()
                    begin
                        CreatePlanningDocument();
                    end;
                }
                action(CalcRefValues)
                {
                    Caption = 'Get Reference Values';
                    ToolTip = 'Get Reference Values';
                    Image = Statistics;

                    trigger OnAction()
                    begin
                        GetReferenceValues();
                    end;
                }
                action(ResetDoc)
                {
                    Caption = 'Reset Planning Document';
                    ToolTip = 'Reset Planning Document';
                    Image = Delete;

                    trigger OnAction()
                    begin
                        ResetPlanningDocument();
                    end;
                }
            }
            group(DocumentMenu)
            {
                Caption = 'Document';
                action(OpenPlanDoc)
                {
                    Caption = 'Open Planning View';
                    ToolTip = 'Open Planning View';
                    Image = PlanningWorksheet;

                    trigger OnAction()
                    begin
                        OpenPlanningView();
                    end;
                }
                action(CopyPlanDoc)
                {
                    Caption = 'Copy Document';
                    ToolTip = 'Copy Document';
                    Image = CopyDocument;
                    ShortcutKey = 'Ctrl+D';

                    trigger OnAction()
                    begin
                        CopyPlanningDocument();
                    end;
                }

                action(UpdateDescriptionsAction)
                {
                    Caption = 'Update Descriptions';
                    ToolTip = 'Update Descriptions';
                    Image = RefreshText;

                    trigger OnAction()
                    begin
                        UpdateDescriptions();
                    end;
                }
                action(PrintDocument)
                {
                    Caption = 'Beleg Drucken';
                    ToolTip = 'Beleg Drucken';
                    Image = PrintDocument;
                    Visible = false;

                    trigger OnAction()
                    begin
                        PrintDoc();
                    end;
                }
            }
            group(Release)
            {
                Caption = 'Status';
                action(ReleaseDoc)
                {
                    Caption = 'Release planning document';
                    ToolTip = 'Release planning document';
                    Image = ReleaseDoc;

                    trigger OnAction()
                    begin
                        ReleaseDocument();
                    end;
                }
                action(ResetStatus)
                {
                    Caption = 'Reset status';
                    ToolTip = 'Reset status';
                    Image = ResetStatus;

                    trigger OnAction()
                    begin
                        ReopenPlanDoc();
                    end;
                }
                action(ImportPlanningValues)
                {
                    Caption = 'Import Planning Data...';
                    ToolTip = 'Import Planning Data...';
                    Image = ImportLog;
                    Visible = false;

                    trigger OnAction()
                    begin
                        GetValuesFromPlanningEntries();
                    end;
                }
            }
        }
        area(Navigation)
        {
            group(TEST)
            {
                Caption = 'TEST';
                Visible = false;
                action(DeleteInvalidLines)
                {
                    Caption = 'Delete invalid Records';
                    ToolTip = 'Delete invalid Records';
                    Image = DeleteRow;

                    trigger OnAction()
                    var
                        PlanDocMgmt_LC: Codeunit "BET FN Planning Document Mgt";
                    begin
                        PlanDocMgmt_LC.DeleteInvalidCombinations(Rec);
                    end;
                }
                action(FindUnsavedLines)
                {
                    Caption = 'Find not saved views';
                    ToolTip = 'Find not saved views';
                    Image = Find;
                    Visible = false;

                    trigger OnAction()
                    var
                        PL3_LC: Codeunit "BET FN Planning Functions";
                    begin
                        PL3_LC.PlanView_CheckForUnsavedLines(Rec);
                    end;
                }
            }
        }
        area(Promoted)
        {
            group(PreparePlanning)
            {
                Caption = 'Prepare Planning';

                actionref(DefineLevels_Promoted; DefineLevels)
                {
                }
                actionref(CreateDocument_Promoted; CreateDocument)
                {
                }
                actionref(CalcRefValues_Promoted; CalcRefValues)
                {
                }
                actionref(ResetDoc_Promoted; ResetDoc)
                {
                }
            }


            group(Category_Process)
            {
                Caption = 'Process';

                actionref(OpenPlanDoc_Promoted; OpenPlanDoc)
                {
                }
                actionref(PrintDocument_Promoted; PrintDocument)
                {
                }
                actionref(UpdateDescriptionsAction_Promoted; UpdateDescriptionsAction)
                {
                    Visible = false;
                }
            }
            group(Release_Promoted)
            {
                Caption = 'Release';

                actionref(ReleaseDoc_Promoted; ReleaseDoc)
                {
                }
                actionref(ResetStatus_Promoted; ResetStatus)
                {
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        if Rec."No. of Date-Records" = Rec."No. of Ref.-Records" then
            NoOfMonthStyle_G := 'None'
        else
            NoOfMonthStyle_G := 'Attention';

        DocNotCreated_G := (Rec."Planning Document Created" = 0DT);   //### Editierbarkeit der Felder bei offenem/erstelltem Beleg
    end;


    var
        DocNotCreated_G: Boolean;
        DocumentNotCreatedErr: Label 'Document not yet created.';
        PlanningDocumentMsg: Label 'Planning Document';
        NoOfMonthStyle_G: Text;

    /// <summary>
    /// ShowPlanningLevels.
    /// </summary>
    procedure ShowPlanningLevels()
    var
        PlanDocMgt_LC: Codeunit "BET FN Planning Document Mgt";
    begin
        PlanDocMgt_LC.ShowPlanDocLevels(Rec);
    end;

    /// <summary>
    /// OpenPlanningView.
    /// </summary>
    procedure OpenPlanningView()
    var
        PlanDocMgt_LC: Codeunit "BET FN Planning Document Mgt";
    begin
        PlanDocMgt_LC.OpenPlanningView(Rec);
    end;

    /// <summary>
    /// CopyPlanningDocument.
    /// </summary>
    procedure CopyPlanningDocument()
    var
        PlanDocMgmt_LC: Codeunit "BET FN Planning Document Mgt";
    begin
        PlanDocMgmt_LC.CopyPlanningDocument(Rec, true, false);
    end;

    /// <summary>
    /// CreatePlanningDocument.
    /// </summary>
    procedure CreatePlanningDocument()
    var
        PlanDocMgmt_LC: Codeunit "BET FN Planning Document Mgt";
    begin
        PlanDocMgmt_LC.CreatePlanningDocumentLevels(Rec, true);
    end;

    /// <summary>
    /// GetReferenceValues.
    /// </summary>
    procedure GetReferenceValues()
    var
        CalcRefValue_LC: Codeunit "BET FN Reference Value Mgt";
        ConfirmManagement: Codeunit "Confirm Management";
        CalcRefValuesQst: Label 'Calculate Reference Values?';
    begin
        if Rec."Planning Document Created" = 0DT then
            Error(DocumentNotCreatedErr);
        if ConfirmManagement.GetResponse(CalcRefValuesQst, false) then
            CalcRefValue_LC.CalcReferenceValueCube(Rec);
    end;

    /// <summary>
    /// ResetPlanningDocument.
    /// </summary>
    procedure ResetPlanningDocument()
    var
        PlanDocMgmt_LC: Codeunit "BET FN Planning Document Mgt";
        ConfirmManagement: Codeunit "Confirm Management";
        DeleteLevelsForPlanDocQst: Label 'Delete Levels for %1?', Comment = '%1';
    begin
        if ConfirmManagement.GetResponse(StrSubstNo(DeleteLevelsForPlanDocQst, PlanningDocumentMsg), false) then
            PlanDocMgmt_LC.ResetPlanningDocument(Rec);
    end;

    /// <summary>
    /// ReleaseDocument.
    /// </summary>
    procedure ReleaseDocument()
    var
        PlanDocMgmt_LC: Codeunit "BET FN Planning Document Mgt";
    begin
        PlanDocMgmt_LC.ReleasePlanDoc(Rec, true);
    end;

    /// <summary>
    /// ReopenPlanDoc.
    /// </summary>
    procedure ReopenPlanDoc()
    var
        PlanDocMgmt_LC: Codeunit "BET FN Planning Document Mgt";
    begin
        PlanDocMgmt_LC.ReopenPlanDoc(Rec, true);
    end;

    /// <summary>
    /// GetValuesFromPlanningEntries.
    /// </summary>
    procedure GetValuesFromPlanningEntries()
    var
        PlanDocMgmt_LC: Codeunit "BET FN Planning Document Mgt";
    begin
        PlanDocMgmt_LC.ImportPlanningValues(Rec);
    end;

    /// <summary>
    /// UpdateDescriptions.
    /// </summary>
    procedure UpdateDescriptions()
    var
        PlanDocMgt_LC: Codeunit "BET FN Planning Document Mgt";
        ConfirmManagement: Codeunit "Confirm Management";
        UpdateDescriptionsQst: Label 'Update descriptions in this document?';
    begin
        if not ConfirmManagement.GetResponse(UpdateDescriptionsQst, false) then
            exit;

        PlanDocMgt_LC.UpdateDescriptions(Rec."No.");
    end;

    /// <summary>
    /// PrintDoc.
    /// </summary>
    procedure PrintDoc()
    var
        PrintPlanDoc_LR: Report "BET FN Planning Fin Yr 12 Mths";
    begin

        PrintPlanDoc_LR.SetDocumentNo(Rec."No.");
        PrintPlanDoc_LR.Run();
    end;
}

