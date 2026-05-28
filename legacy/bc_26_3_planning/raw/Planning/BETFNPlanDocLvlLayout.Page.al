/// <summary>
/// 
/// 
/// Modules: [planning]
/// </summary>
page 5407584 "BET FN Plan Doc Lvl Layout"
{
    Caption = 'Planning Document Level Layout';
    DataCaptionFields = "Planning Document No.", "Planning Document Level Index";
    PageType = Worksheet;
    SourceTable = "BET FN Planning Document Level";
    UsageCategory = None;
    DeleteAllowed = false;
    InsertAllowed = false;
    ApplicationArea = All;
    Extensible = true;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'Planning Document';
                ShowCaption = false;

                field(GlobalLayoutTemplateCode; PlanDoc_GT."Layout Template")
                {
                    Caption = 'Global Layout';
                    TableRelation = "BET FN Planning Layout Tmplt";

                    trigger OnValidate()
                    begin
                        UpdatePlanDoc();
                    end;
                }
                field(UseGlobalLayout; PlanDoc_GT."Use Global Layout")
                {
                    Caption = 'Use Global Layout';

                    trigger OnValidate()
                    begin
                        UpdatePlanDoc();
                    end;
                }
            }
            group(Levels)
            {
                Caption = 'Document Levels';

                repeater(PlanDocLevels)
                {
                    field(PlanningDocumentLevelIndex; Rec."Planning Document Level Index")
                    {
                        Caption = 'Planning Document Level Index';
                    }
                    field(IndexCode; Rec."Index Code")
                    {
                        Caption = 'Index Code';
                    }
                    field(IndexDescription; Rec."Index Description")
                    {
                        Caption = 'Index Description';
                    }
                    field(LayoutTemplateCode; Rec."Layout Template")
                    {
                        Caption = 'Layout Template';
                    }
                }
            }
        }
    }

    trigger OnOpenPage()
    var
    begin
        Rec.Reset();
        Rec.FilterGroup(2);
        Rec.SetRange("Planning Document No.", PlanDoc_GT."No.");
    end;

    var
        PlanDoc_GT: Record "BET FN Planning Document";

    local procedure UpdatePlanDoc()
    var
        PlanDoc_LT: Record "BET FN Planning Document";
    begin
        PlanDoc_LT.Get(PlanDoc_GT."No.");
        PlanDoc_LT."Layout Template" := PlanDoc_GT."Layout Template";
        PlanDoc_LT."Use Global Layout" := PlanDoc_GT."Use Global Layout";
        PlanDoc_LT.Modify();
    end;

    /// <summary>
    /// SetDocumentNo.
    /// </summary>
    /// <param name="DocNo_P">Code[20].</param>
    procedure SetDocumentNo(DocNo_P: Code[20])
    begin
        PlanDoc_GT.Get(DocNo_P);
    end;
}

