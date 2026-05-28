/// <summary>
/// Codeunit BET FN Plan. Dim. Assign. Mgt. (ID 5079354).
/// </summary>
codeunit 5079354 "BET FN Plan. Dim. Assign. Mgt."
{
    Access = Public;

    /// <summary>
    /// CheckSingleBufferIndex.
    /// </summary>
    /// <param name="IndexOK_P">VAR Boolean.</param>
    /// <param name="PlanDoc_PT">Record "BET FN Planning Document".</param>
    /// <param name="PlanLevel_PT">Record "BET FN Planning Level".</param>
    /// <param name="PlanType_PT">Record "BET FN Planning Type".</param>
    /// <param name="Index_P">Code[20].</param>
    procedure CheckSingleBufferIndex(var IndexOK_P: Boolean; PlanDoc_PT: Record "BET FN Planning Document"; PlanLevel_PT: Record "BET FN Planning Level"; PlanType_PT: Record "BET FN Planning Type"; Index_P: Code[20])
    var
        PlanDimAssign_LT: Record "BET FN Plan. Dim. Assign.";
        RecRef_LRR: RecordRef;
        FieldRef_LFR: FieldRef;
    begin
        // prüft für ein einzufügendes Bufferelement, ob es laut Zuordnungstabelle gültig ist (optional Filter auf Einkäufercode)

        // Element ist bereits ungültig:
        if not IndexOK_P then
            exit;

        // Planungstyp benötigt keine Prüfung der Zuordnung:
        if not PlanType_PT."Check Dim. Assign. Table" then
            exit;

        // Ebene benötigt keine Prüfung der Zuordnung:
        if not PlanLevel_PT."Check Dim. Assign. Table" then
            exit;

        // Feld muß hinterlegt sein:
        PlanLevel_PT.TestField("Dim. Assign. Field No.");

        Clear(PlanDimAssign_LT);
        if PlanType_PT."Dim. Assign. per Purchaser" then begin
            PlanDoc_PT.TestField("Purchaser Code");
            PlanDimAssign_LT.SetRange("Purchaser Code", PlanDoc_PT."Purchaser Code");
        end;

        RecRef_LRR.GetTable(PlanDimAssign_LT);

        FieldRef_LFR := RecRef_LRR.Field(PlanLevel_PT."Dim. Assign. Field No.");
        FieldRef_LFR.SetRange(Index_P);

        IndexOK_P := RecRef_LRR.FindFirst();
    end;

    /// <summary>
    /// CheckBufferIndexComplete.
    /// </summary>
    /// <param name="PlanDoc_PT">Record "BET FN Planning Document".</param>
    /// <param name="PlanDocLevel_PT">Record "BET FN Planning Document Level".</param>
    /// <param name="PlanDocLevelBuffer_PT">Record "BET FN Planning Doc Lvl Buf".</param>
    /// <param name="PlanView_PT">Record "BET FN Planning View".</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure CheckBufferIndexComplete(PlanDoc_PT: Record "BET FN Planning Document"; PlanDocLevel_PT: Record "BET FN Planning Document Level"; PlanDocLevelBuffer_PT: Record "BET FN Planning Doc Lvl Buf"; PlanView_PT: Record "BET FN Planning View"): Boolean
    var
        PlanDimAssign_LT: Record "BET FN Plan. Dim. Assign.";
        PlanDocLevelBuffer_LT: Record "BET FN Planning Doc Lvl Buf";
        PlanDocLevel_LT: Record "BET FN Planning Document Level";
        CurrentLevel_LT: Record "BET FN Planning Level";
        PlanLevel_LT: Record "BET FN Planning Level";
        PlanType_LT: Record "BET FN Planning Type";
        RecRef_LRR: RecordRef;
        RecRefView_LRR: RecordRef;
        FieldRef_LFR: FieldRef;
        FieldRefView_LFR: FieldRef;
        InsertLine_L: Boolean;
        IndexCode_L: Code[20];
        i_L: Integer;
    begin
        // Prüfung bei Belegaufbau

        // Ebene benötigt keine Prüfung der Zuordnung:
        CurrentLevel_LT.Get(PlanDocLevel_PT."Index Code");
        if not CurrentLevel_LT."Check Dim. Assign. Table" then
            exit(true);

        // Feld muß hinterlegt sein:
        CurrentLevel_LT.TestField("Dim. Assign. Field No.");

        // optionaler Filter auf Einkäufer:
        Clear(PlanDimAssign_LT);
        if PlanType_LT.Get(PlanDoc_PT."Planning Type") then
            if PlanType_LT."Dim. Assign. per Purchaser" then begin
                PlanDoc_PT.TestField("Purchaser Code");
                PlanDimAssign_LT.SetRange("Purchaser Code", PlanDoc_PT."Purchaser Code");
            end;

        RecRef_LRR.GetTable(PlanDimAssign_LT);
        RecRefView_LRR.GetTable(PlanView_PT);

        // Sonderbehandlung bei Dummy (und aktiver Zuordnungsprüfung):
        if PlanDocLevelBuffer_PT.Dummy then begin
            InsertLine_L := true;
            PlanDocLevel_LT.Reset();
            PlanDocLevel_LT.SetRange("Planning Document No.", PlanDoc_PT."No.");
            PlanDocLevel_LT.SetFilter("Planning Document Level Index", '<%1 & >%2', PlanDocLevel_PT."Planning Document Level Index", 0);
            if PlanDocLevel_LT.FindSet(false) then begin
                i_L := 0;
                repeat
                    i_L += 1;
                    PlanLevel_LT.Get(PlanDocLevel_LT."Index Code");
                    if PlanLevel_LT."Check Dim. Assign. Table" then begin
                        PlanLevel_LT.TestField("Dim. Assign. Field No.");

                        // Feld in Viewtabelle:
                        FieldRefView_LFR := RecRefView_LRR.Field(i_L);

                        IndexCode_L := FieldRefView_LFR.Value;
                        PlanDocLevelBuffer_LT.Get(PlanDocLevel_LT."Planning Document No.", PlanDocLevel_LT."Planning Document Level Index", IndexCode_L);

                        // bei Zuordnungen darf Dummy nur an Dummy angefügt werden, nicht aber an normale Elemente:  
                        if PlanLevel_LT."Use Dummy" and (not PlanDocLevelBuffer_LT.Dummy) then
                            InsertLine_L := false;
                    end;
                until (PlanDocLevel_LT.Next() = 0) or (InsertLine_L = false);
            end;
            exit(InsertLine_L);
        end;

        // bisherige Indizes filtern:
        PlanDocLevel_LT.Reset();
        PlanDocLevel_LT.SetRange("Planning Document No.", PlanDoc_PT."No.");
        PlanDocLevel_LT.SetFilter("Planning Document Level Index", '<%1 & >%2', PlanDocLevel_PT."Planning Document Level Index", 0);
        if PlanDocLevel_LT.FindSet(false) then begin
            i_L := 0;
            repeat
                i_L += 1;
                PlanLevel_LT.Get(PlanDocLevel_LT."Index Code");
                if PlanLevel_LT."Check Dim. Assign. Table" then begin
                    PlanLevel_LT.TestField("Dim. Assign. Field No.");

                    // Feld in Viewtabelle:
                    FieldRefView_LFR := RecRefView_LRR.Field(i_L);

                    IndexCode_L := FieldRefView_LFR.Value;
                    PlanDocLevelBuffer_LT.Get(PlanDocLevel_LT."Planning Document No.", PlanDocLevel_LT."Planning Document Level Index", IndexCode_L);
                    // echte Elemende prüfen:
                    if not PlanDocLevelBuffer_LT.Dummy then begin
                        // Feld in Zuordnungstabelle:
                        FieldRef_LFR := RecRef_LRR.Field(PlanLevel_LT."Dim. Assign. Field No.");
                        FieldRef_LFR.SetRange(FieldRefView_LFR.Value);
                    end else
                        // wenn in oberer Ebene Dummy und in aktueller Ebene Verwendung von Dummy, dann dürfen keine normalen Elemente eingefügt werden
                        // z.B. Kreditor=DUMMY ---> Marke=NIKE
                        if CurrentLevel_LT."Use Dummy" then
                            exit(false);

                end else
                    // noch zu behandeln: was passiert, wenn keine Zuordnungstabelle verwendet wird, aber Dummy???
                    exit(true);
            until PlanDocLevel_LT.Next() = 0;
        end;

        // noch aktuellen Index filtern:
        FieldRef_LFR := RecRef_LRR.Field(CurrentLevel_LT."Dim. Assign. Field No.");
        FieldRef_LFR.SetRange(PlanDocLevelBuffer_PT."Index Code");

        exit(not RecRef_LRR.IsEmpty);
    end;

    /// <summary>
    /// InitFromItemLedgerEntry.
    /// </summary>
    /// <param name="ShowConfirm_P">Boolean.</param>
    procedure InitFromItemLedgerEntry(ShowConfirm_P: Boolean)
    var
        PlanDimAss2_LT: Record "BET FN Plan. Dim. Assign.";
        PlanDimAss_LT: Record "BET FN Plan. Dim. Assign.";
        PlanSetup_LT: Record "BET FN Planning Setup";
        DialogMgt_LC: Codeunit "BET FN Dialog Mgt";
        ConfirmManagement: Codeunit "Confirm Management";
        PlanDimAss_LQ: Query "BET FN Plan. Dim. Assign.";
        IsHandled: Boolean;
        SourceType: Enum "Analysis Source Type";
        Counter_L, EntryNo_L : Integer;
        AnalyzeLbl: Label 'Analyze Data...';
        ConfirmLbl: Label 'ATTENTION: All planning dimension assignments will be deleted! Recreate assignments?';
        ProcessLbl: Label 'Get valid assignments';
    begin
        // Zuordnungstabelle initial leeren und aus Posten neu befüllen (über Query)

        OnBeforeInitPlanDimAssignment(IsHandled);
        if IsHandled then
            exit;

        PlanSetup_LT.Get();

        if ShowConfirm_P then
            if not ConfirmManagement.GetResponse(ConfirmLbl, false) then
                exit;

        PlanDimAss_LT.Reset();
        PlanDimAss_LT.DeleteAll();

        EntryNo_L := 0;

        Clear(PlanDimAss_LQ);
        PlanDimAss_LQ.SetRange(SourceTypeFilter, SourceType::Vendor);
        // PlanDimAss_LQ.SetFilter(PostingDateFilter, ...??);

        // erster Durchlauf zum Ermitteln der Anzahl (für Laufbalken):
        PlanDimAss_LQ.Open();
        Counter_L := 0;
        DialogMgt_LC.OpenQueryDialog(AnalyzeLbl);
        while PlanDimAss_LQ.Read() do begin
            Counter_L += 1;
            DialogMgt_LC.UpdateQueryDialogAsDonut(500);
        end;
        DialogMgt_LC.CloseDialog();

        PlanDimAss_LQ.Open();
        DialogMgt_LC.OpenDialog(Counter_L, ProcessLbl);
        PlanDimAss_LT.Reset();

        IsHandled := false;
        OnBeforePlanDimAssSetKey(PlanDimAss_LT, IsHandled);   // Publisher für Schlüsselwechsel
        if not IsHandled then
            PlanDimAss_LT.SetCurrentKey("Purchaser Code", "Vendor No.", Brand, "Main Waregroup");

        while PlanDimAss_LQ.Read() do begin
            DialogMgt_LC.UpdateDialog(0);
            Clear(PlanDimAss2_LT);

            // definierte Felder filtern und zuweisen (nur wenn alle benötigten Felder <> leer sind):
            if SetFiltersFromSetup(PlanSetup_LT, PlanDimAss_LT, PlanDimAss2_LT, PlanDimAss_LQ) then
                if PlanDimAss_LT.IsEmpty then begin
                    EntryNo_L += 1;
                    PlanDimAss2_LT."Entry No." := EntryNo_L;
                    PlanDimAss2_LT.Insert();
                end;

        end;
        DialogMgt_LC.CloseDialog();
    end;

    local procedure SetFiltersFromSetup(PlanSetup_PT: Record "BET FN Planning Setup"; var PlanDimAss_PT: Record "BET FN Plan. Dim. Assign."; var PlanDimAss2_PT: Record "BET FN Plan. Dim. Assign."; PlanDimAss_PQ: Query "BET FN Plan. Dim. Assign."): Boolean
    var
        PlanningLevel_LT: Record "BET FN Planning Level";
        RecRef_LRR: RecordRef;
        FieldRef_LFR: FieldRef;
        FieldNo_L: Integer;
    begin
        RecRef_LRR.GetTable(PlanSetup_PT);

        for FieldNo_L := PlanSetup_PT.FieldNo("Dimension Assignment 1") to PlanSetup_PT.FieldNo("Dimension Assignment 4") do begin
            FieldRef_LFR := RecRef_LRR.Field(FieldNo_L);
            if PlanningLevel_LT.Get(FieldRef_LFR.Value) then    // Code eingetragen
                case PlanningLevel_LT."Index Table No." of
                    Database::Vendor:
                        begin
                            if PlanDimAss_PQ.SourceNo = '' then
                                exit(false);
                            PlanDimAss_PT.SetRange("Vendor No.", PlanDimAss_PQ.SourceNo);
                            PlanDimAss2_PT."Vendor No." := PlanDimAss_PQ.SourceNo;
                        end;
                    Database::"BET FN Brand":
                        begin
                            if PlanDimAss_PQ.Brand = '' then
                                exit(false);
                            PlanDimAss_PT.SetRange(Brand, PlanDimAss_PQ.Brand);
                            PlanDimAss2_PT.Brand := PlanDimAss_PQ.Brand;
                        end;
                    Database::"BET FN Main Waregroup":
                        begin
                            if PlanDimAss_PQ.MainWareGroup = '' then
                                exit(false);
                            PlanDimAss_PT.SetRange("Main Waregroup", PlanDimAss_PQ.MainWareGroup);
                            PlanDimAss2_PT."Main Waregroup" := PlanDimAss_PQ.MainWareGroup;
                        end;
                end;
        end;
        exit(true);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInitPlanDimAssignment(var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePlanDimAssSetKey(BETFNPlanDimAssign: Record "BET FN Plan. Dim. Assign."; var IsHandled: Boolean)
    begin
    end;
}