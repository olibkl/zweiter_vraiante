page 5407581 "BET FN Plan. Dim. Assign."
{
    ApplicationArea = All;
    Caption = 'Planning Dimension Assignment';
    PageType = List;
    SourceTable = "BET FN Plan. Dim. Assign.";
    UsageCategory = Lists;
    Extensible = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                }
                field("Purchaser Code"; Rec."Purchaser Code")
                {
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                }
                field(Brand; Rec.Brand)
                {
                }
                field("Main Waregroup"; Rec."Main Waregroup")
                {
                }
            }
        }
    }
}
