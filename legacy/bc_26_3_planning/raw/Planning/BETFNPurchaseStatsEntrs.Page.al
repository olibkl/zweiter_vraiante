/// <summary>
/// [planning]
/// Modules: 
/// </summary>
page 5138636 "BET FN Purchase Stats Entrs"
{
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Purchase Statistic Entries';
    Editable = false;
    PageType = List;
    SourceTable = "BET FN Purchase Statistic Ent";
    Extensible = true;

    layout
    {
        area(Content)
        {
            repeater(Control1117300000)
            {
                ShowCaption = false;
                field("Entry No."; Rec."Entry No.")
                {
                }
                field("Expected Receipt Date"; Rec."Expected Receipt Date")
                {
                }
                field(Division; Rec.Division)
                {
                    Visible = DivisionVisible;
                }
                field("Main Waregroup"; Rec."Main Waregroup")
                {
                    Visible = MainWaregroupVisible;
                }
                field("Item Category Code"; Rec."Item Category Code")
                {
                    Visible = ItemCategoryCodeVisible;
                }
                field("Item No."; Rec."Item No.")
                {
                }
                field("Location Group"; Rec."Location Group")
                {
                }
                field("Location Code"; Rec."Location Code")
                {
                }
                field(Season; Rec.Season)
                {
                }
                field(Brand; Rec.Brand)
                {
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                }
                field(Agent; Rec.Agent)
                {
                }
                field(Customer; Rec.Customer)
                {
                }
                field(FDim1; Rec.FDim1)
                {
                }
                field(FDim2; Rec.FDim2)
                {
                }
                field(FDim3; Rec.FDim3)
                {
                }
                field(FDim4; Rec.FDim4)
                {
                }
                field(FDim5; Rec.FDim5)
                {
                }
                field(FDim6; Rec.FDim6)
                {
                }
                field(FDim7; Rec.FDim7)
                {
                }
                field(FDim8; Rec.FDim8)
                {
                }
                field(FDim9; Rec.FDim9)
                {
                }
                field(FDim10; Rec.FDim10)
                {
                }
                field("Outstanding Quantity"; Rec."Outstanding Quantity")
                {
                }
                field("Outst. Gross Sales Amt. (LCY)"; Rec."Outst. Gross Sales Amt. (LCY)")
                {
                }
                field("Net Outstanding Amount (LCY)"; Rec."Net Outstanding Amount (LCY)")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    var
        BETFNFashionCheckMgt: Codeunit "BET FN Fashion Check Mgt";
    begin
        ItemCategoryCodeVisible := BETFNFashionCheckMgt.GetItemCategoryFieldVisibility(Page::"BET FN Purchase Stats Entrs");
        MainWaregroupVisible := BETFNFashionCheckMgt.GetMainWaregroupFieldVisibility(Page::"BET FN Purchase Stats Entrs");
        DivisionVisible := BETFNFashionCheckMgt.GetDivisionFieldVisibility(Page::"BET FN Purchase Stats Entrs");
    end;

    var
        DivisionVisible: Boolean;
        MainWaregroupVisible: Boolean;
        ItemCategoryCodeVisible: Boolean;
}

