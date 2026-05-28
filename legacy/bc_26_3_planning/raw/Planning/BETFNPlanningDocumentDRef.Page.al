/// <summary>
/// [planning]
/// Modules: 
/// </summary>
page 5138642 "BET FN Planning Document D Ref"
{
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Planning Doc. Date Ref.';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "BET FN Planning Document D Ref";
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
                }
                field(Date; Rec.Date)
                {
                    Editable = false;
                }
                field("Reference Date"; Rec."Reference Date")
                {
                    Editable = false;
                }
#pragma warning disable AL0432
                field(Weight; Rec.Weight)
                {
                    ObsoleteState = Pending;
                    ObsoleteReason = '#37755 Pending - not needed anymore (29.0)';
                    ObsoleteTag = '26.0';
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
#pragma warning restore AL0432
#pragma warning disable AL0432
                field(Percentage; Rec.Percentage)
                {
                    Editable = false;

                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
#pragma warning restore AL0432
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    var
        PlanDoc_LT: Record "BET FN Planning Document";
        PlanDocNotFoundErr: Label 'Planning Document not found.';
        FilterText_L: Text[250];
    begin
        if not PlanDoc_LT.Get(Rec."Planning Document No.") then
            Error(PlanDocNotFoundErr);

        // ### Filter dürfen nicht aufgehoben werden:
        FilterText_L := CopyStr(Rec.GetView(), 1, MaxStrLen(FilterText_L));
        Rec.FilterGroup(2);
        Rec.SetView(FilterText_L);
        Rec.FilterGroup(0);
    end;
}

