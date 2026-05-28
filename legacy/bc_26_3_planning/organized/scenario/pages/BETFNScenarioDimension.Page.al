/// <summary>
/// [scenario]
/// Modules: 
/// </summary>
page 5138655 "BET FN Scenario Dimension"
{
    Caption = 'Scenario Dimension';
    PageType = ListPart;
    SourceTable = "BET FN Scenario Dimension";
    ApplicationArea = All;
    Extensible = true;

    layout
    {
        area(Content)
        {
            repeater(Control1117300000)
            {
                ShowCaption = false;
                field("Scenario Code"; Rec."Scenario Code")
                {
                    Visible = false;
                }
                field("Code"; Rec.Code)
                {
                    Editable = CodeEditable;
                }
                field(Description; Rec.Description)
                {
                    Editable = false;
                }
                field("Table No."; Rec."Table No.")
                {
                    Editable = false;
                }
                field(Lines; Rec.Lines)
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        DoOnAfterGetCurrRecord();
    end;

    trigger OnInit()
    begin
        CodeEditable := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        DoOnAfterGetCurrRecord();
    end;

    local procedure DoOnAfterGetCurrRecord()
    begin
        xRec := Rec;
        CodeEditable := not Rec.Dateline;
    end;

    var
        CodeEditable: Boolean;

    procedure UpdateSubform1()
    begin
        CurrPage.Update(false);
    end;
}

