/// <summary>
/// [fashion-statistic]
/// Modules: 
/// </summary>
#pragma warning disable AL0432
page 5138632 "BET FN Fashion Statistic Entrs"
{
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Fashion Statistic Entries';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "BET FN Fashion Statistic Entry";
    SourceTableView = sorting("Entry No.");
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
                field(Company; Rec.Company)
                {
                    Visible = false;
                }
                field("Entry Source Type"; Rec."Entry Source Type")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Country Code"; Rec."Country Code")
                {
                }
                field("Location Code"; Rec."Location Code")
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
                }
                field(Customer; Rec.Customer)
                {
                }
                field(Brand; Rec.Brand)
                {
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                }
                field(Season; Rec.Season)
                {
                }
                field("S Quantity"; Rec."S Quantity")
                {
                }
                field("S Cost Amount"; Rec."S Cost Amount")
                {
                }
                field("S Inventory Value Sales"; Rec."S Inventory Value Sales")
                {
                }
                field("S Realized Gross Sales Amount"; Rec."S Realized Gross Sales Amount")
                {
                }
                field("S Discount Amount Gross"; Rec."S Discount Amount Gross")
                {
                }
                field("S Discount Amount Gross S."; Rec."S Discount Amount Gross S.")
                {
                }
                field("S Realized GSP Reduction"; Rec."S Realized GSP Reduction")
                {
                }
                field("S Change in GS-Prices"; Rec."S Change in GS-Prices")
                {
                }
                field("S Real. Net Sales Amount"; Rec."S Real. Net Sales Amount")
                {
                }
                field("P Quantity"; Rec."P Quantity")
                {
                }
                field("P Cost Amount"; Rec."P Cost Amount")
                {
                }
                field("P Inventory Value Sales"; Rec."P Inventory Value Sales")
                {
                }
                field("A Quantity"; Rec."A Quantity")
                {
                }
                field("A Cost Amount"; Rec."A Cost Amount")
                {
                }
                field("A Inventory Value Sales"; Rec."A Inventory Value Sales")
                {
                }
                field("T Quantity"; Rec."T Quantity")
                {
                }
                field("T Cost Amount"; Rec."T Cost Amount")
                {
                }
                field("T Inventory Value Sales"; Rec."T Inventory Value Sales")
                {
                }
                field("I Quantity"; Rec."I Quantity")
                {
                }
                field("I Cost Amount"; Rec."I Cost Amount")
                {
                }
                field("I Inventory Value Sales"; Rec."I Inventory Value Sales")
                {
                }
                field("D Inventory Value Sales"; Rec."D Inventory Value Sales")
                {
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group(Functions)
            {
                Caption = 'Functions';
            }
        }
    }

    trigger OnOpenPage()
    var
        BETFNFashionCheckMgt: Codeunit "BET FN Fashion Check Mgt";
    begin
        MainWaregroupVisible := BETFNFashionCheckMgt.GetMainWaregroupFieldVisibility(Page::"BET FN Fashion Statistic Entrs");
        DivisionVisible := BETFNFashionCheckMgt.GetDivisionFieldVisibility(Page::"BET FN Fashion Statistic Entrs");
    end;

    var
        DivisionVisible: Boolean;
        MainWaregroupVisible: Boolean;
}

