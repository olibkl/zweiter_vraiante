/// <summary>
/// [planning]
/// Modules: 
/// </summary>
query 5138632 "BET FN Planning Entry"
{
    Access = Public;

    elements
    {
        dataitem(Planning_Entry_DWH; "BET FN Planning Entry (DWH)")
        {
            filter(PostingDateFilter; "Posting Date")
            {
            }
            filter(LocationCodeFilter; "Location Code")
            {
            }
            filter(ItemCategoryFilter; "Item Category")
            {
            }
            filter(MainWaregroupFilter; "Main Waregroup")
            {
            }
            filter(DivisionFilter; Division)
            {
            }
            filter(BrandFilter; Brand)
            {
            }
            filter(VendorFilter; "Vendor No.")
            {
            }
            filter(FDim1Filter; FDim1)
            {
            }
            filter(FDim2Filter; FDim2)
            {
            }
            filter(FDim3Filter; FDim3)
            {
            }
            filter(FDim4Filter; FDim4)
            {
            }
            filter(FDim5Filter; FDim5)
            {
            }
            filter(FDim6Filter; FDim6)
            {
            }
            filter(FDim7Filter; FDim7)
            {
            }
            filter(FDim8Filter; FDim8)
            {
            }
            filter(FDim9Filter; FDim9)
            {
            }
            filter(FDim10Filter; FDim10)
            {
            }
            filter(PurchQtyFilter; "Plan Qty. Purchase")
            {
            }
            column(Location_Code; "Location Code")
            {
            }
            column(Item_Category; "Item Category")
            {
            }
            column(Sum_Plan_Qty_Sale; "Plan Qty. Sale")
            {
                Method = Sum;
            }
            column(Sum_Plan_Cost_of_Sales; "Plan Cost of Sales")
            {
                Method = Sum;
            }
            column(Sum_Plan_Sales_Amount; "Plan Sales Amount")
            {
                Method = Sum;
            }
            column(Sum_Plan_Qty_Purchase; "Plan Qty. Purchase")
            {
                Method = Sum;
            }
            column(Sum_Plan_Cost_Am_Purchase; "Plan Cost Am. Purchase")
            {
                Method = Sum;
            }
            column(Sum_Plan_Sales_Am_Purchase; "Plan Sales Am. Purchase")
            {
                Method = Sum;
            }
        }
    }
}

