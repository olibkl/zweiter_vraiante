/// <summary>
/// [planning]
/// Modules: 
/// </summary>
page 5138661 "BET FN Planning Input Page"
{
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Planning Input Page';
    Extensible = true;

    layout
    {
        area(Content)
        {
            field(InputText; InputText_G)
            {
                ToolTip = 'Specifies the InputText.';
                Caption = 'Input';
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        CurrPage.Caption(Description_G);
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        InputMustNotBeMptyErr: Label 'Input must not be empty.';
    begin
        if (CloseAction = Action::OK) and (InputText_G = '') then
            Error(InputMustNotBeMptyErr);
    end;

    var
        Description_G: Text;
        InputText_G: Text;

    /// <summary>
    /// SetPageDescription.
    /// </summary>
    /// <param name="Description_P">Text.</param>
    procedure SetPageDescription(Description_P: Text)
    begin
        Description_G := Description_P;
    end;

    /// <summary>
    /// GetInputText.
    /// </summary>
    /// <returns>Return value of type Text.</returns>
    procedure GetInputText(): Text
    begin
        exit(InputText_G);
    end;
}

