/// <summary>
/// [planning]
/// Modules: 
/// </summary>
page 5138649 "BET FN Planning Type"
{
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Planning Type';
    PageType = List;
    SourceTable = "BET FN Planning Type";
    Extensible = true;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Write Planning Entries"; Rec."Write Planning Entries")
                {
                }
                field("Layout Template"; Rec."Layout Template")
                {
                }
#pragma warning disable AL0432
                field("Company Plan"; Rec."Company Plan")
                {
                    ObsoleteState = Pending;
                    ObsoleteReason = '#37755 Pending - not needed anymore (29.0)';
                    ObsoleteTag = '26.0';
                    Visible = false;
                    Editable = false;
                }
                field("Purchase Plan"; Rec."Purchase Plan")
                {
                    ObsoleteState = Pending;
                    ObsoleteReason = '#37755 Pending - not needed anymore (29.0)';
                    ObsoleteTag = '26.0';
                    Visible = false;
                    Editable = false;
                }
#pragma warning restore AL0432
                field(Level1; Rec.Level1)
                {
                }
                field(Level2; Rec.Level2)
                {
                }
                field(Level3; Rec.Level3)
                {
                }
                field(Level4; Rec.Level4)
                {
                }
                field(Level5; Rec.Level5)
                {
                }
                field(Level6; Rec.Level6)
                {
                }
                field("Use Date Level"; Rec."Use Date Level")
                {
                }
                field("Starting Level"; Rec."Starting Level")
                {
                }
                field("Auto Filter On Level Changing"; Rec."Auto Filter On Level Changing")
                {
                }
                field("Dim. Assign. per Purchaser"; Rec."Dim. Assign. per Purchaser")
                {
                }
                field("Check Dim. Assign. Table"; Rec."Check Dim. Assign. Table")
                {
                }
                field("Type of Calculation"; Rec."Type of Calculation")
                {
                    Visible = false;
                    Enabled = false;

                    ObsoleteState = Pending;
                    ObsoleteTag = '25.2';
                    ObsoleteReason = '#35131 Pending removal - field will be removed in future updates';
                }
                field("Planning Process Type"; Rec."Planning Process Type")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        CurrPage.Editable(not CurrPage.LookupMode());
    end;
}

