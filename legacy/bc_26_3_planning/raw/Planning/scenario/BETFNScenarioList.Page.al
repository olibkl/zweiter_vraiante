page 5407640 "BET FN Scenario List"
{
    ApplicationArea = All;
    Caption = 'Scenario List';
    PageType = List;
    SourceTable = "BET FN Scenario";
    UsageCategory = Lists;
    CardPageId = "BET FN Scenario";
    Extensible = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field("Start Date"; Rec."Start Date")
                {
                    ToolTip = 'Specifies the value of the Start Date field.', Comment = '%';
                }
                field("End Date"; Rec."End Date")
                {
                    ToolTip = 'Specifies the value of the End Date field.', Comment = '%';
                }
                field(Active; Rec.Active)
                {
                    ToolTip = 'Specifies the value of the Active field.', Comment = '%';
                }
                field("Real. Sal. Am. per Year"; Rec."Real. Sal. Am. per Year")
                {
                    ToolTip = 'Specifies the value of the Real. Sal. Am. per Year field.', Comment = '%';
                    DecimalPlaces = 0;
                }
            }
        }
    }
}
