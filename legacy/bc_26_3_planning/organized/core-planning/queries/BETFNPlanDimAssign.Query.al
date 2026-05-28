/// <summary>
/// Query BET FN Plan. Dim. Assign. (ID 5138635).
/// </summary>
query 5138635 "BET FN Plan. Dim. Assign."
{
    Caption = 'Planning Dimension Assignment';
    QueryType = Normal;
    ReadState = ReadUncommitted;
    DataAccessIntent = ReadOnly;
    Access = Public;

    elements
    {
        dataitem(ItemLedgerEntry; "Item Ledger Entry")
        {
            filter(PostingDateFilter; "Posting Date")
            { }
            filter(EntryTypeFilter; "Entry Type")
            { }

            filter(SourceTypeFilter; "Source Type")
            { }

            column(SourceNo; "Source No.")
            { }

            column(SumQuantity; Quantity)
            {
                Method = Sum;
            }

            dataitem(Item; Item)
            {
                DataItemLink = "No." = ItemLedgerEntry."Item No.";
                column(Brand; "BET FN Brand")
                { }

                column(MainWareGroup; "BET FN Main Waregroup")
                { }
            }
        }
    }

}
