/// <summary>
/// [planning]
/// Modules: 
/// </summary>
codeunit 5138634 "BET FN Planning Doc Fltr Mgt"
{
    SingleInstance = true;
    Access = Public;


    var
        DateFilterActivated_G: Boolean;
        ViewEntryNoStack_G: array[10] of Integer;
        QuickAccess_G: Option " ",Date,Index1,Index2,Index3,Index4,Index5,Index6;
        IndexFilterArray_G: array[10] of Text;
        DateFilter_G: Text[1024];

    /// <summary>
    /// SetFilterValues.
    /// </summary>
    /// <param name="IndexFilterArray_P">array[10] of Text.</param>
    /// <param name="DateFilterActivated_P">Boolean.</param>
    /// <param name="DateFilter_P">Text[1024].</param>
    /// <param name="QuickAccess_P">Option " ",Date,Index1,Index2,Index3,Index4,Index5,Index6.</param>
    procedure SetFilterValues(IndexFilterArray_P: array[10] of Text; DateFilterActivated_P: Boolean; DateFilter_P: Text[1024]; QuickAccess_P: Option " ",Date,Index1,Index2,Index3,Index4,Index5,Index6)
    var
        i_L: Integer;
    begin
        for i_L := 1 to ArrayLen(IndexFilterArray_P) do
            IndexFilterArray_G[i_L] := IndexFilterArray_P[i_L];

        DateFilterActivated_G := DateFilterActivated_P;
        DateFilter_G := DateFilter_P;
        QuickAccess_G := QuickAccess_P;
    end;

    /// <summary>
    /// GetFilterValues.
    /// </summary>
    /// <param name="IndexFilterArray_R">VAR array[10] of Text.</param>
    /// <param name="DateFilterActivated_R">VAR Boolean.</param>
    /// <param name="DateFilter_R">VAR Text[1024].</param>
    /// <param name="QuickAccess_R">VAR Option " ",Date,Index1,Index2,Index3,Index4,Index5,Index6.</param>
    procedure GetFilterValues(var IndexFilterArray_R: array[10] of Text; var DateFilterActivated_R: Boolean; var DateFilter_R: Text[1024]; var QuickAccess_R: Option " ",Date,Index1,Index2,Index3,Index4,Index5,Index6)
    var
        i_L: Integer;
    begin
        for i_L := 1 to ArrayLen(IndexFilterArray_G) do
            IndexFilterArray_R[i_L] := IndexFilterArray_G[i_L];

        DateFilterActivated_R := DateFilterActivated_G;
        DateFilter_R := DateFilter_G;
        QuickAccess_R := QuickAccess_G;
    end;

    /// <summary>
    /// SetViewEntryNoToStack.
    /// </summary>
    /// <param name="ViewEntryNo_P">Integer.</param>
    procedure SetViewEntryNoToStack(ViewEntryNo_P: Integer)
    var
        Continue: Boolean;
        i: Integer;
    begin
        Continue := true;
        i := 0;
        while Continue do begin
            i += 1;
            if i > ArrayLen(ViewEntryNoStack_G) then      // Abbruch, wenn Arrayende erreicht
                exit;

            if ViewEntryNoStack_G[i] = 0 then begin
                ViewEntryNoStack_G[i] := ViewEntryNo_P;
                Continue := false;
            end;
        end;
    end;

    /// <summary>
    /// GetViewEntryNoFromStack.
    /// </summary>
    /// <returns>Return value of type Integer.</returns>
    procedure GetViewEntryNoFromStack(): Integer
    var
        Continue: Boolean;
        i, ViewEntryNo : Integer;
    begin
        Continue := true;
        i := ArrayLen(ViewEntryNoStack_G);
        repeat
            if ViewEntryNoStack_G[i] <> 0 then begin
                ViewEntryNo := ViewEntryNoStack_G[i];
                ViewEntryNoStack_G[i] := 0;             // Zeilennr. wieder aus Stapel löschen
                exit(ViewEntryNo);
            end;
            i -= 1;
            // Sonderfall beim ersten Planbeleg mit Zeilennummer 0:
            if i = 0 then
                exit(0);
        until Continue = false;
    end;

}

