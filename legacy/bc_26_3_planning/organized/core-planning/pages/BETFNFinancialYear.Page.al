/// <summary>
/// [planning]
/// Modules: 
/// </summary>
page 5138648 "BET FN Financial Year"
{
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Financial Year';
    PageType = List;
    SourceTable = "BET FN Financial Year";
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
                field("Start Date"; Rec."Start Date")
                {
                }
                field("End Date"; Rec."End Date")
                {
                }
                field("Reference Period"; Rec."Reference Period")
                {
                }
            }
        }
    }

    actions
    {
    }
}

