/// <summary>
/// [fashion-statistic]
/// Modules: 
/// </summary>
#pragma warning disable AL0432
xmlport 5138632 "BET FN Fashion Statistic Entry"
{
    Caption = 'Fashion Statistic Entry';
    FileName = 'Planning_FSE';
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement("Fashion Statistic Entry"; "BET FN Fashion Statistic Entry")
            {
                XmlName = 'StatisticEntry';
                fieldelement(EntryNo; "Fashion Statistic Entry"."Entry No.")
                {
                }
                fieldelement(CompanyName; "Fashion Statistic Entry".Company)
                {
                }
                fieldelement(EntrySourceType; "Fashion Statistic Entry"."Entry Source Type")
                {
                }
                fieldelement(PostingDate; "Fashion Statistic Entry"."Posting Date")
                {
                }
                fieldelement(ContryCode; "Fashion Statistic Entry"."Country Code")
                {
                }
                fieldelement(LocationGroup; "Fashion Statistic Entry"."Location Group")
                {
                }
                fieldelement(LocationCode; "Fashion Statistic Entry"."Location Code")
                {
                }
                fieldelement(ItemCatCode; "Fashion Statistic Entry"."Item Category Code")
                {
                }
                fieldelement(MainWGCode; "Fashion Statistic Entry"."Main Waregroup")
                {
                }
                fieldelement(DivisionCode; "Fashion Statistic Entry".Division)
                {
                }
                fieldelement(VendorNo; "Fashion Statistic Entry"."Vendor No.")
                {
                }
                fieldelement(Brand; "Fashion Statistic Entry".Brand)
                {
                }
                fieldelement(Season; "Fashion Statistic Entry".Season)
                {
                }
                fieldelement(SeasonType; "Fashion Statistic Entry"."Season Type")
                {
                }
                fieldelement(FDim1; "Fashion Statistic Entry".FDim1)
                {
                }
                fieldelement(FDim2; "Fashion Statistic Entry".FDim2)
                {
                }
                fieldelement(FDim3; "Fashion Statistic Entry".FDim3)
                {
                }
                fieldelement(FDim4; "Fashion Statistic Entry".FDim4)
                {
                }
                fieldelement(FDim5; "Fashion Statistic Entry".FDim5)
                {
                }
                fieldelement(FDim6; "Fashion Statistic Entry".FDim6)
                {
                }
                fieldelement(FDim7; "Fashion Statistic Entry".FDim7)
                {
                }
                fieldelement(FDim8; "Fashion Statistic Entry".FDim8)
                {
                }
                fieldelement(FDim9; "Fashion Statistic Entry".FDim9)
                {
                }
                fieldelement(FDim10; "Fashion Statistic Entry".FDim10)
                {
                }
                fieldelement(S_Quantity; "Fashion Statistic Entry"."S Quantity")
                {
                }
                fieldelement(S_CostAmount; "Fashion Statistic Entry"."S Cost Amount")
                {
                }
                fieldelement(S_InventoryValueSales; "Fashion Statistic Entry"."S Inventory Value Sales")
                {
                }
                fieldelement(S_RealizedGrossSalesAmount; "Fashion Statistic Entry"."S Realized Gross Sales Amount")
                {
                }
                fieldelement(S_DiscountAmountGross; "Fashion Statistic Entry"."S Discount Amount Gross")
                {
                }
                fieldelement(S_DiscountAmountGrossSalesperson; "Fashion Statistic Entry"."S Discount Amount Gross S.")
                {
                }
                fieldelement(S_RealizedGSPReduction; "Fashion Statistic Entry"."S Realized GSP Reduction")
                {
                }
                fieldelement("S_ChangeInGS-Prices"; "Fashion Statistic Entry"."S Change in GS-Prices")
                {
                }
                fieldelement(S_RealNetSalesAmount; "Fashion Statistic Entry"."S Real. Net Sales Amount")
                {
                }
                fieldelement(S_DiscountAmount; "Fashion Statistic Entry"."S Discount Amount")
                {
                }
                fieldelement(P_Quantity; "Fashion Statistic Entry"."P Quantity")
                {
                }
                fieldelement(P_CostAmount; "Fashion Statistic Entry"."P Cost Amount")
                {
                }
                fieldelement(P_InventoryValueSales; "Fashion Statistic Entry"."P Inventory Value Sales")
                {
                }
                fieldelement(A_Quantity; "Fashion Statistic Entry"."A Quantity")
                {
                }
                fieldelement(A_CostAmount; "Fashion Statistic Entry"."A Cost Amount")
                {
                }
                fieldelement(A_InventoryValueSales; "Fashion Statistic Entry"."A Inventory Value Sales")
                {
                }
                fieldelement(T_Quantity; "Fashion Statistic Entry"."T Quantity")
                {
                }
                fieldelement(T_CostAmount; "Fashion Statistic Entry"."T Cost Amount")
                {
                }
                fieldelement(T_InventoryValueSales; "Fashion Statistic Entry"."T Inventory Value Sales")
                {
                }
                fieldelement(I_Quantity; "Fashion Statistic Entry"."I Quantity")
                {
                }
                fieldelement(I_CostAmount; "Fashion Statistic Entry"."I Cost Amount")
                {
                }
                fieldelement(I_InventoryValueSales; "Fashion Statistic Entry"."I Inventory Value Sales")
                {
                }
                fieldelement(D_InventoryValueSales; "Fashion Statistic Entry"."D Inventory Value Sales")
                {
                }
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }
}

