/// <summary>
/// [planning]
/// Modules: 
/// </summary>
codeunit 5138642 "BET FN Planning Analysis Mgt"
{
    Access = Public;

    /// <summary>
    /// CreateTempPlanningEntryTable.
    /// </summary>
    /// <param name="PlanEntryInfoTemp_RTT">Temporary VAR Record "BET FN Planning Ent Info Temp".</param>
    /// <param name="FilterArray_P">array[100] of Text.</param>
    /// <param name="HideEmptyLines_P">Boolean.</param>
    /// <param name="CreateByQuery_P">Boolean.</param>
    procedure CreateTempPlanningEntryTable(var PlanEntryInfoTemp_RTT: Record "BET FN Planning Ent Info Temp" temporary; FilterArray_P: array[100] of Text; HideEmptyLines_P: Boolean; CreateByQuery_P: Boolean)
    var
        TempPlanEntryInfo_LTT: Record "BET FN Planning Ent Info Temp" temporary;
        TempTotalLines_LTT: Record "BET FN Planning Ent Info Temp" temporary;
        TempValueTable_LTT: Record "BET FN Planning Ent Info Temp" temporary;
        Window_L: Dialog;
        LineNo_L: Integer;
        CalculateLinesTxt: Label 'Calculate lines...';
        TotalTxt: Label 'Total';
    begin

        Window_L.Open(CalculateLinesTxt);

        //### finale Zieltabelle:
        PlanEntryInfoTemp_RTT.Reset();
        PlanEntryInfoTemp_RTT.DeleteAll();

        //### Zwischentabelle:
        TempPlanEntryInfo_LTT.Reset();
        TempPlanEntryInfo_LTT.DeleteAll();

        Clear(LineNo_L);

        //###########################################################
        //### STEP 1: Detailzeilen sammeln:

        if CreateByQuery_P then
            FillDetailTableByQuery(TempPlanEntryInfo_LTT, TempValueTable_LTT, FilterArray_P, LineNo_L, HideEmptyLines_P)        //### statisch befüllen über Query (schneller)
        else
            FillDetailTableCustomized(TempPlanEntryInfo_LTT, TempValueTable_LTT, FilterArray_P, LineNo_L, HideEmptyLines_P);    //### dynamisch efüllen (langsamer)


        // TEST...
        //MergeTempTables(PlanEntryInfoTemp_RTT, TempPlanEntryInfo_LTT, TempTotalLines_LTT);
        //exit;



        //###################################################################################
        //### STEP 2: Zwischensummen und Summenzeilen einfügen:

        LineNo_L += 1000;    //### Zeilen später einfach zu bestehender Tabelle hinzufügen

        //### alle Detailzeilen der temp. Tab. durchlaufen und pro Zeile die passenden übergeordneten Summenzeilen REKURSIV anlegen (wenn noch nicht vorhanden):
        TempPlanEntryInfo_LTT.Reset();
        if TempPlanEntryInfo_LTT.FindSet() then
            repeat
                //### prüfe, ob übergeordnete Zeile existiert (in TempTotalLines_LTT), falls nicht, dann anlegen und Summe aus TempTableForCalcTotals_LTT:
                CheckAddTotalLinesRecursive(TempPlanEntryInfo_LTT, TempTotalLines_LTT, TempValueTable_LTT, LineNo_L);
            until TempPlanEntryInfo_LTT.Next() = 0;


        //###################################################################################
        //### STEP 3: temp. Tabellen (Basistabelle aus Query und generierte Tabelle mit Summenzeilen) zusammenfügen:

        MergeTempTables(PlanEntryInfoTemp_RTT, TempPlanEntryInfo_LTT, TempTotalLines_LTT);



        //###################################################################################
        //### STEP 4: Gesamtzeile einfügen

        PlanEntryInfoTemp_RTT.Init();
        LineNo_L += 10000;
        PlanEntryInfoTemp_RTT."Entry No." := LineNo_L;
        PlanEntryInfoTemp_RTT."Line Type" := PlanEntryInfoTemp_RTT."Line Type"::Total;
        PlanEntryInfoTemp_RTT.Indentation := GetIndentation(PlanEntryInfoTemp_RTT);
        PlanEntryInfoTemp_RTT.Level4 := '';
        PlanEntryInfoTemp_RTT.Level3 := '';
        PlanEntryInfoTemp_RTT.Level2 := '';
        PlanEntryInfoTemp_RTT.Level1 := '';
        PlanEntryInfoTemp_RTT.Description := TotalTxt;

        TempValueTable_LTT.Reset();
        TempValueTable_LTT.CalcSums("Purchase Quantity", "Purchase Value", "Purchase Value Sales", "Plan Sales Amount");

        PlanEntryInfoTemp_RTT."Purchase Quantity" := TempValueTable_LTT."Purchase Quantity";
        PlanEntryInfoTemp_RTT."Purchase Value" := TempValueTable_LTT."Purchase Value";
        PlanEntryInfoTemp_RTT."Purchase Value Sales" := TempValueTable_LTT."Purchase Value Sales";
        PlanEntryInfoTemp_RTT."Plan Sales Amount" := TempValueTable_LTT."Plan Sales Amount";

        PlanEntryInfoTemp_RTT.Insert();


        //###################################################################################
        //### STEP 5: Tabelle noch einmal umdrehen (oben <--> unten), damit Indentation funktioniert (Summen oben):
        InvertTempTable(PlanEntryInfoTemp_RTT);

        Window_L.Close();
    end;

    /// <summary>
    /// FillDetailTableByQuery.
    /// </summary>
    /// <param name="PlanEntryInfoTemp_RTT">Temporary VAR Record "BET FN Planning Ent Info Temp".</param>
    /// <param name="TempValueTable_RTT">Temporary VAR Record "BET FN Planning Ent Info Temp".</param>
    /// <param name="FilterArray_P">array[100] of Text.</param>
    /// <param name="LineNo_R">VAR Integer.</param>
    /// <param name="HideEmptyLines_P">Boolean.</param>
    procedure FillDetailTableByQuery(var PlanEntryInfoTemp_RTT: Record "BET FN Planning Ent Info Temp" temporary; var TempValueTable_RTT: Record "BET FN Planning Ent Info Temp" temporary; FilterArray_P: array[100] of Text; var LineNo_R: Integer; HideEmptyLines_P: Boolean)
    var
        ItemCat_LT: Record "Item Category";
        Location_LT: Record Location;
        PlanningEntry_LQ: Query "BET FN Planning Entry";
    begin
        //### Erstellung der Detailtabelle mit Hilfe von QUERY:

        Clear(PlanningEntry_LQ);

        //### Filter:
        PlanningEntry_LQ.SetFilter(PostingDateFilter, FilterArray_P[1]);
        PlanningEntry_LQ.SetFilter(LocationCodeFilter, FilterArray_P[2]);
        PlanningEntry_LQ.SetFilter(ItemCategoryFilter, FilterArray_P[3]);
        PlanningEntry_LQ.SetFilter(MainWaregroupFilter, FilterArray_P[4]);
        PlanningEntry_LQ.SetFilter(DivisionFilter, FilterArray_P[5]);
        PlanningEntry_LQ.SetFilter(BrandFilter, FilterArray_P[6]);
        PlanningEntry_LQ.SetFilter(VendorFilter, FilterArray_P[7]);

        //### FN (Demo): explizit zugeschnitten auf Lagerort + Warengruppe:
        if FilterArray_P[2] = '' then
            PlanningEntry_LQ.SetFilter(LocationCodeFilter, '<>%1', '');
        if FilterArray_P[3] = '' then
            PlanningEntry_LQ.SetFilter(ItemCategoryFilter, '<>%1', '');

        //### optional Leerzeilen ausblenden:
        if HideEmptyLines_P then
            PlanningEntry_LQ.SetFilter(PurchQtyFilter, '>0');

        PlanningEntry_LQ.Open();

        while PlanningEntry_LQ.Read() do begin
            PlanEntryInfoTemp_RTT.Init();
            LineNo_R += 1;
            PlanEntryInfoTemp_RTT."Entry No." := LineNo_R;

            //### FN (Demo): Filiale + Warengruppe
            PlanEntryInfoTemp_RTT.Level1 := PlanningEntry_LQ.Location_Code;
            if Location_LT.Get(PlanningEntry_LQ.Location_Code) then
                PlanEntryInfoTemp_RTT."Level 1 Description" := CopyStr(Location_LT.Name, 1, MaxStrLen(PlanEntryInfoTemp_RTT."Level 1 Description"));
            PlanEntryInfoTemp_RTT.Level2 := PlanningEntry_LQ.Item_Category;
            if ItemCat_LT.Get(PlanningEntry_LQ.Item_Category) then
                PlanEntryInfoTemp_RTT."Level 2 Description" := CopyStr(ItemCat_LT.Description, 1, MaxStrLen(PlanEntryInfoTemp_RTT."Level 2 Description"));

            /*
            //### OL:
            PlanEntryInfoTemp_RTT.Level1 := PlanningEntry_LQ.Location_Code;
            PlanEntryInfoTemp_RTT.Level2 := PlanningEntry_LQ.Item_Category;
            PlanEntryInfoTemp_RTT.Level3 := PlanningEntry_LQ.FDim10;
            PlanEntryInfoTemp_RTT.Level4 := PlanningEntry_LQ.FDim6;
            */

            PlanEntryInfoTemp_RTT."Purchase Quantity" := PlanningEntry_LQ.Sum_Plan_Qty_Purchase;
            PlanEntryInfoTemp_RTT."Purchase Value" := PlanningEntry_LQ.Sum_Plan_Cost_Am_Purchase;
            PlanEntryInfoTemp_RTT."Purchase Value Sales" := PlanningEntry_LQ.Sum_Plan_Sales_Am_Purchase;
            PlanEntryInfoTemp_RTT."Plan Sales Amount" := PlanningEntry_LQ.Sum_Plan_Sales_Amount;

            if PlanEntryInfoTemp_RTT.Level1 <> '' then
                PlanEntryInfoTemp_RTT."Line Type" := PlanEntryInfoTemp_RTT."Line Type"::L1;
            if PlanEntryInfoTemp_RTT.Level2 <> '' then
                PlanEntryInfoTemp_RTT."Line Type" := PlanEntryInfoTemp_RTT."Line Type"::L2;
            if PlanEntryInfoTemp_RTT.Level3 <> '' then
                PlanEntryInfoTemp_RTT."Line Type" := PlanEntryInfoTemp_RTT."Line Type"::L3;
            if PlanEntryInfoTemp_RTT.Level4 <> '' then
                PlanEntryInfoTemp_RTT."Line Type" := PlanEntryInfoTemp_RTT."Line Type"::L4;

            PlanEntryInfoTemp_RTT.Indentation := GetIndentation(PlanEntryInfoTemp_RTT);
            CreateDescription(PlanEntryInfoTemp_RTT);

            PlanEntryInfoTemp_RTT.Insert();

            //### separate Tabelle für die Summenberechnung:
            TempValueTable_RTT := PlanEntryInfoTemp_RTT;
            TempValueTable_RTT.Insert();
        end;

    end;

    /// <summary>
    /// FillDetailTableCustomized.
    /// </summary>
    /// <param name="PlanEntryInfoTemp_RTT">Temporary VAR Record "BET FN Planning Ent Info Temp".</param>
    /// <param name="TempValueTable_RTT">Temporary VAR Record "BET FN Planning Ent Info Temp".</param>
    /// <param name="FilterArray_P">array[100] of Text.</param>
    /// <param name="LineNo_R">VAR Integer.</param>
    /// <param name="HideEmptyLines_P">Boolean.</param>
    procedure FillDetailTableCustomized(var PlanEntryInfoTemp_RTT: Record "BET FN Planning Ent Info Temp" temporary; var TempValueTable_RTT: Record "BET FN Planning Ent Info Temp" temporary; FilterArray_P: array[100] of Text; var LineNo_R: Integer; HideEmptyLines_P: Boolean)
    var
        PlanEntry_LT: Record "BET FN Planning Entry (DWH)";
        PlanSetup_LT: Record "BET FN Planning Setup";
        UseEntry_L: Boolean;
        LevelCodeArray_L: array[10] of Code[20];
        DescriptionArray_L: array[10] of Text;
    begin
        //### flexible

        PlanSetup_LT.Get();

        //### Planungsposten durchlaufen und Werte addieren:
        PlanEntry_LT.Reset();

        //### Filter:
        PlanEntry_LT.SetFilter("Posting Date", FilterArray_P[1]);
        PlanEntry_LT.SetFilter("Location Code", FilterArray_P[2]);
        PlanEntry_LT.SetFilter("Item Category", FilterArray_P[3]);
        PlanEntry_LT.SetFilter("Main Waregroup", FilterArray_P[4]);
        PlanEntry_LT.SetFilter(Division, FilterArray_P[5]);
        PlanEntry_LT.SetFilter(Brand, FilterArray_P[6]);
        PlanEntry_LT.SetFilter("Vendor No.", FilterArray_P[7]);

        //### optional Leerzeilen ausblenden:
        if HideEmptyLines_P then
            PlanEntry_LT.SetFilter(PlanEntry_LT."Plan Qty. Purchase", '>0');

        if PlanEntry_LT.FindSet(true) then
            repeat
                //### alternativ Leerezeilen hier ausblenden:

                //### Ebenenzuordnung dynamisch ermitteln (laut Setup):
                LevelCodeArray_L[1] := GetLevelCode(PlanEntry_LT, PlanSetup_LT."OTB Level 1", DescriptionArray_L[1]);
                LevelCodeArray_L[2] := GetLevelCode(PlanEntry_LT, PlanSetup_LT."OTB Level 2", DescriptionArray_L[2]);
                LevelCodeArray_L[3] := GetLevelCode(PlanEntry_LT, PlanSetup_LT."OTB Level 3", DescriptionArray_L[3]);
                LevelCodeArray_L[4] := GetLevelCode(PlanEntry_LT, PlanSetup_LT."OTB Level 4", DescriptionArray_L[4]);

                //### Prüfen, ob Postenzeile überhaupt alle auszuwertenden Dimensionen enthält:
                UseEntry_L := true;
                if (PlanSetup_LT."OTB Level 1" <> '') and (LevelCodeArray_L[1] = '') then
                    UseEntry_L := false;
                if (PlanSetup_LT."OTB Level 2" <> '') and (LevelCodeArray_L[2] = '') then
                    UseEntry_L := false;
                if (PlanSetup_LT."OTB Level 3" <> '') and (LevelCodeArray_L[3] = '') then
                    UseEntry_L := false;
                if (PlanSetup_LT."OTB Level 4" <> '') and (LevelCodeArray_L[4] = '') then
                    UseEntry_L := false;

                if UseEntry_L then begin

                    PlanEntryInfoTemp_RTT.Reset();
                    PlanEntryInfoTemp_RTT.SetRange(Level1, LevelCodeArray_L[1]);
                    PlanEntryInfoTemp_RTT.SetRange(Level2, LevelCodeArray_L[2]);
                    PlanEntryInfoTemp_RTT.SetRange(Level3, LevelCodeArray_L[3]);
                    PlanEntryInfoTemp_RTT.SetRange(Level4, LevelCodeArray_L[4]);

                    if PlanEntryInfoTemp_RTT.IsEmpty() then begin
                        //### neue Detailzeile einfügen:
                        PlanEntryInfoTemp_RTT.Init();
                        LineNo_R += 1;
                        PlanEntryInfoTemp_RTT."Entry No." := LineNo_R;

                        PlanEntryInfoTemp_RTT.Level1 := LevelCodeArray_L[1];
                        PlanEntryInfoTemp_RTT.Level2 := LevelCodeArray_L[2];
                        PlanEntryInfoTemp_RTT.Level3 := LevelCodeArray_L[3];
                        PlanEntryInfoTemp_RTT.Level4 := LevelCodeArray_L[4];

                        PlanEntryInfoTemp_RTT."Level 1 Description" := DescriptionArray_L[1];
                        PlanEntryInfoTemp_RTT."Level 2 Description" := DescriptionArray_L[2];
                        PlanEntryInfoTemp_RTT."Level 3 Description" := DescriptionArray_L[3];
                        PlanEntryInfoTemp_RTT."Level 4 Description" := DescriptionArray_L[4];

                        if PlanEntryInfoTemp_RTT.Level1 <> '' then
                            PlanEntryInfoTemp_RTT."Line Type" := PlanEntryInfoTemp_RTT."Line Type"::L1;
                        if PlanEntryInfoTemp_RTT.Level2 <> '' then
                            PlanEntryInfoTemp_RTT."Line Type" := PlanEntryInfoTemp_RTT."Line Type"::L2;
                        if PlanEntryInfoTemp_RTT.Level3 <> '' then
                            PlanEntryInfoTemp_RTT."Line Type" := PlanEntryInfoTemp_RTT."Line Type"::L3;
                        if PlanEntryInfoTemp_RTT.Level4 <> '' then
                            PlanEntryInfoTemp_RTT."Line Type" := PlanEntryInfoTemp_RTT."Line Type"::L4;

                        PlanEntryInfoTemp_RTT.Indentation := GetIndentation(PlanEntryInfoTemp_RTT);
                        CreateDescription(PlanEntryInfoTemp_RTT);

                        PlanEntryInfoTemp_RTT.Insert();
                    end else
                        PlanEntryInfoTemp_RTT.FindSet(true);

                    //### Werte addieren:
                    PlanEntryInfoTemp_RTT."Purchase Quantity" += PlanEntry_LT."Plan Qty. Purchase";
                    PlanEntryInfoTemp_RTT."Purchase Value" += PlanEntry_LT."Plan Cost Am. Purchase";
                    PlanEntryInfoTemp_RTT."Purchase Value Sales" += PlanEntry_LT."Plan Sales Am. Purchase";
                    PlanEntryInfoTemp_RTT."Plan Sales Amount" += PlanEntry_LT."Plan Sales Amount";

                    PlanEntryInfoTemp_RTT.Modify();
                end;
            until PlanEntry_LT.Next() = 0;

        //### Tabelle kopieren für Summenberechnung:
        PlanEntryInfoTemp_RTT.Reset();
        if PlanEntryInfoTemp_RTT.FindSet() then
            repeat
                //### separate Tabelle für die Summenberechnung:
                TempValueTable_RTT := PlanEntryInfoTemp_RTT;
                TempValueTable_RTT.Insert();
            until PlanEntryInfoTemp_RTT.Next() = 0;
    end;

    /// <summary>
    /// GetLevelCode.
    /// </summary>
    /// <param name="PlanEntry_PT">Record "BET FN Planning Entry (DWH)".</param>
    /// <param name="LevelCode_P">Code[20].</param>
    /// <param name="Description_R">VAR Text.</param>
    /// <returns>Return value of type Code[20].</returns>
    procedure GetLevelCode(PlanEntry_PT: Record "BET FN Planning Entry (DWH)"; LevelCode_P: Code[20]; var Description_R: Text): Code[20]
    var
        PlanLevel_LT: Record "BET FN Planning Level";
        RecRef2_LRR: RecordRef;
        RecRef_LRR: RecordRef;
        FieldRef2_LFR: FieldRef;
        FieldRef_LFR: FieldRef;
    begin
        //### Matching der Postenfelder laut Setup und Ebenentabelle: jeweils Code und Beschreibung zurückgeben
        Description_R := '';

        if LevelCode_P = '' then
            exit('');

        PlanLevel_LT.Get(LevelCode_P);

        RecRef_LRR.GetTable(PlanEntry_PT);
        FieldRef_LFR := RecRef_LRR.Field(PlanLevel_LT."Export Field No.");
        if Evaluate(LevelCode_P, Format(FieldRef_LFR.Value())) then begin

            //### Beschreibung aus Stammdatentabelle ermitteln:

            if LevelCode_P <> '' then begin
                //### Datensatz holen:
                RecRef2_LRR.Open(PlanLevel_LT."Index Table No.");
                FieldRef2_LFR := RecRef2_LRR.Field(PlanLevel_LT."Primary Key Field No.");
                FieldRef2_LFR.SetRange(LevelCode_P);
                RecRef2_LRR.FindFirst();

                //### Beschreibung:
                FieldRef2_LFR := RecRef2_LRR.Field(PlanLevel_LT."Description Field No.");
                if Evaluate(Description_R, Format(FieldRef2_LFR.Value())) then;

                RecRef2_LRR.Close();
            end;

            exit(LevelCode_P);    //### Code
        end else
            exit('');
    end;

    /// <summary>
    /// CreateDescription.
    /// </summary>
    /// <param name="PlanningEntryInfoTemp_RTT">Temporary VAR Record "BET FN Planning Ent Info Temp".</param>
    /// <returns>Return value of type Text.</returns>
    procedure CreateDescription(var PlanningEntryInfoTemp_RTT: Record "BET FN Planning Ent Info Temp" temporary): Text
    var
        IndentationSpace_L: Text;
    begin
        IndentationSpace_L := '   ';

        case PlanningEntryInfoTemp_RTT."Line Type" of

            PlanningEntryInfoTemp_RTT."Line Type"::L1:
                PlanningEntryInfoTemp_RTT.Description := IndentationSpace_L
                                                            + PlanningEntryInfoTemp_RTT."Level 1 Description";

            PlanningEntryInfoTemp_RTT."Line Type"::L2:
                PlanningEntryInfoTemp_RTT.Description := IndentationSpace_L
                                                            + IndentationSpace_L
                                                            + PlanningEntryInfoTemp_RTT."Level 2 Description";

            PlanningEntryInfoTemp_RTT."Line Type"::L3:
                PlanningEntryInfoTemp_RTT.Description := IndentationSpace_L
                                                            + IndentationSpace_L
                                                            + IndentationSpace_L
                                                            + PlanningEntryInfoTemp_RTT."Level 3 Description";

            PlanningEntryInfoTemp_RTT."Line Type"::L4:
                PlanningEntryInfoTemp_RTT.Description := IndentationSpace_L
                                                            + IndentationSpace_L
                                                            + IndentationSpace_L
                                                            + IndentationSpace_L
                                                            + PlanningEntryInfoTemp_RTT."Level 4 Description";
        end;
    end;

    /// <summary>
    /// InvertTempTable.
    /// </summary>
    /// <param name="PlanEntryInfoTemp_RTT">Temporary VAR Record "BET FN Planning Ent Info Temp".</param>
    procedure InvertTempTable(var PlanEntryInfoTemp_RTT: Record "BET FN Planning Ent Info Temp" temporary)
    var
        TempLine_LTT: Record "BET FN Planning Ent Info Temp" temporary;
        i_L: Integer;
    begin

        PlanEntryInfoTemp_RTT.Reset();
        PlanEntryInfoTemp_RTT.SetCurrentKey(Level1, Level2, Level3, Level4);
        //PlanEntryInfoTemp_RTT.ASCENDING(false);
        if PlanEntryInfoTemp_RTT.FindSet(true) then begin
            i_L := 0;
            repeat
                TempLine_LTT.Init();
                TempLine_LTT.TransferFields(PlanEntryInfoTemp_RTT);
                i_L += 1;
                TempLine_LTT."Entry No." := i_L;
                TempLine_LTT.Insert();

                //### und gleich löschen:
                PlanEntryInfoTemp_RTT.Delete();
            until PlanEntryInfoTemp_RTT.Next() = 0;
        end;

        //### und wieder zurückschreiben:
        TempLine_LTT.Reset();
        if TempLine_LTT.FindSet() then
            repeat
                PlanEntryInfoTemp_RTT.Init();
                PlanEntryInfoTemp_RTT.TransferFields(TempLine_LTT);
                PlanEntryInfoTemp_RTT.Insert();
            until TempLine_LTT.Next() = 0;
    end;

    /// <summary>
    /// CheckAddTotalLinesRecursive.
    /// </summary>
    /// <param name="PlanEntryInfoTemp_PTT">Temporary Record "BET FN Planning Ent Info Temp".</param>
    /// <param name="TotalLines_RTT">Temporary VAR Record "BET FN Planning Ent Info Temp".</param>
    /// <param name="TempValueTable_PTT">Temporary VAR Record "BET FN Planning Ent Info Temp".</param>
    /// <param name="LineNo_R">VAR Integer.</param>
    procedure CheckAddTotalLinesRecursive(PlanEntryInfoTemp_PTT: Record "BET FN Planning Ent Info Temp" temporary; var TotalLines_RTT: Record "BET FN Planning Ent Info Temp" temporary; var TempValueTable_PTT: Record "BET FN Planning Ent Info Temp" temporary; var LineNo_R: Integer)
    begin
        //### Abbruchbedingung: oberste Ebene erreicht
        if PlanEntryInfoTemp_PTT."Line Type" = PlanEntryInfoTemp_PTT."Line Type"::L1 then
            exit;

        TotalLines_RTT.Reset();
        TotalLines_RTT.SetRange("Line Type", PlanEntryInfoTemp_PTT."Line Type" - 1);    //### übergeordnete Ebene
        TotalLines_RTT.SetRange(Level1, PlanEntryInfoTemp_PTT.Level1);

        if PlanEntryInfoTemp_PTT.Level3 <> '' then
            TotalLines_RTT.SetRange(Level2, PlanEntryInfoTemp_PTT.Level2);
        if PlanEntryInfoTemp_PTT.Level4 <> '' then
            TotalLines_RTT.SetRange(Level3, PlanEntryInfoTemp_PTT.Level3);
        if PlanEntryInfoTemp_PTT.Level4 <> '' then
            TotalLines_RTT.SetRange(Level3, PlanEntryInfoTemp_PTT.Level3);

        if not TotalLines_RTT.IsEmpty() then
            //### Abbruchbedingung: übergrordnetes Element existiert bereits
            exit
        else begin
            //### übergeordnetes Element existiert noch nicht --> anlegen und rekursiv Fkt. aufrufen
            TotalLines_RTT.Init();
            LineNo_R += 1;
            TotalLines_RTT."Entry No." := LineNo_R;
            TotalLines_RTT."Line Type" := PlanEntryInfoTemp_PTT."Line Type" - 1;
            TotalLines_RTT.Indentation := GetIndentation(TotalLines_RTT);

            TotalLines_RTT.Level1 := PlanEntryInfoTemp_PTT.Level1;
            if TotalLines_RTT."Line Type" > TotalLines_RTT."Line Type"::L1 then
                TotalLines_RTT.Level2 := PlanEntryInfoTemp_PTT.Level2;
            if TotalLines_RTT."Line Type" > TotalLines_RTT."Line Type"::L2 then
                TotalLines_RTT.Level3 := PlanEntryInfoTemp_PTT.Level3;
            if TotalLines_RTT."Line Type" > TotalLines_RTT."Line Type"::L3 then
                TotalLines_RTT.Level4 := PlanEntryInfoTemp_PTT.Level4;

            //### Beschreibungen 1-4 'wandern' nach vorn:
            TotalLines_RTT."Level 1 Description" := PlanEntryInfoTemp_PTT."Level 1 Description";
            TotalLines_RTT."Level 2 Description" := PlanEntryInfoTemp_PTT."Level 2 Description";
            TotalLines_RTT."Level 3 Description" := PlanEntryInfoTemp_PTT."Level 3 Description";
            TotalLines_RTT."Level 4 Description" := PlanEntryInfoTemp_PTT."Level 4 Description";

            CreateDescription(TotalLines_RTT);

            //### Mengen berechnen:
            TempValueTable_PTT.Reset();
            TempValueTable_PTT.SetFilter(Level1, TotalLines_RTT.Level1);
            TempValueTable_PTT.SetFilter(Level2, TotalLines_RTT.Level2);
            TempValueTable_PTT.SetFilter(Level3, TotalLines_RTT.Level3);
            TempValueTable_PTT.SetFilter(Level4, TotalLines_RTT.Level4);
            TempValueTable_PTT.CalcSums("Purchase Quantity", "Purchase Value", "Purchase Value Sales", "Plan Sales Amount");

            TotalLines_RTT."Purchase Quantity" := TempValueTable_PTT."Purchase Quantity";
            TotalLines_RTT."Purchase Value" := TempValueTable_PTT."Purchase Value";
            TotalLines_RTT."Purchase Value Sales" := TempValueTable_PTT."Purchase Value Sales";
            TotalLines_RTT."Plan Sales Amount" := TempValueTable_PTT."Plan Sales Amount";

            TotalLines_RTT.Insert();

            //### rekursiver Aufruf für neu angelegte Zeile:
            CheckAddTotalLinesRecursive(TotalLines_RTT, TotalLines_RTT, TempValueTable_PTT, LineNo_R);
        end;
    end;

    /// <summary>
    /// GetIndentation.
    /// </summary>
    /// <param name="PlanEntryInfoTemp_PTT">Temporary VAR Record "BET FN Planning Ent Info Temp".</param>
    /// <returns>Return value of type Integer.</returns>
    procedure GetIndentation(var PlanEntryInfoTemp_PTT: Record "BET FN Planning Ent Info Temp" temporary): Integer
    var
        Indentation_L: Integer;
    begin
        Indentation_L := 0;

        case PlanEntryInfoTemp_PTT."Line Type" of
            PlanEntryInfoTemp_PTT."Line Type"::Total:
                Indentation_L := 1;
            PlanEntryInfoTemp_PTT."Line Type"::L1:
                Indentation_L := 2;
            PlanEntryInfoTemp_PTT."Line Type"::L2:
                Indentation_L := 3;
            PlanEntryInfoTemp_PTT."Line Type"::L3:
                Indentation_L := 4;
            PlanEntryInfoTemp_PTT."Line Type"::L4:
                Indentation_L := 5;
        //PlanEntryInfoTemp_PTT."Line Type"::L5 : Indentation_L := 6;
        end;

        exit(Indentation_L);
    end;

    /// <summary>
    /// MergeTempTables.
    /// </summary>
    /// <param name="TargetTable_RTT">Temporary VAR Record "BET FN Planning Ent Info Temp".</param>
    /// <param name="BaseTable_PTT">Temporary VAR Record "BET FN Planning Ent Info Temp".</param>
    /// <param name="TotalsTable_PTT">Temporary VAR Record "BET FN Planning Ent Info Temp".</param>
    procedure MergeTempTables(var TargetTable_RTT: Record "BET FN Planning Ent Info Temp" temporary; var BaseTable_PTT: Record "BET FN Planning Ent Info Temp" temporary; var TotalsTable_PTT: Record "BET FN Planning Ent Info Temp" temporary)
    begin
        //### Zieltabelle aus beiden Quelltabellen befüllen:
        TargetTable_RTT.Reset();
        TargetTable_RTT.DeleteAll();

        //### Basistabelle (Query):
        BaseTable_PTT.Reset();
        if BaseTable_PTT.FindSet() then
            repeat
                TargetTable_RTT.Init();
                TargetTable_RTT.TransferFields(BaseTable_PTT);
                TargetTable_RTT.Insert();
            until BaseTable_PTT.Next() = 0;

        //### Summentabelle :
        TotalsTable_PTT.Reset();
        if TotalsTable_PTT.FindSet() then
            repeat
                TargetTable_RTT.Init();
                TargetTable_RTT.TransferFields(TotalsTable_PTT);
                TargetTable_RTT.Insert();
            until TotalsTable_PTT.Next() = 0;
    end;
}

