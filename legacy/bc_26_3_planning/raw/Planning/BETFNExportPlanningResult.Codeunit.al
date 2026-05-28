/// <summary>
/// [planning]
/// Modules: 
/// </summary>
codeunit 5138638 "BET FN Export Planning Result"
{
    Access = Public;

    var
        ExportingPlanningDataLbl: Label 'Exporting Planning data';

    /// <summary>
    /// ExportDocument.
    /// </summary>
    /// <param name="PlanDoc_PT">Record "BET FN Planning Document".</param>
    procedure ExportDocument(PlanDoc_PT: Record "BET FN Planning Document")
    var
        PlanDocLevel_LT: Record "BET FN Planning Document Level";
        PlanEntry_LT: Record "BET FN Planning Entry (DWH)";
        PlanSetup_LT: Record "BET FN Planning Setup";
        PlanCube_LT: Record "BET FN Planning Value Cube";
        BETFNDialogMgt: Codeunit "BET FN Dialog Mgt";
        RR_L: RecordRef;
        IsHandled: Boolean;
        LastEntry_L: Integer;
    begin
        IsHandled := false;
        OnBeforeExportDocument(PlanDoc_PT, IsHandled);
        if IsHandled then
            exit;

        PlanEntry_LT.Reset();
        PlanEntry_LT.ReadIsolation := PlanEntry_LT.ReadIsolation::UpdLock;

        if PlanEntry_LT.FindLast() then
            LastEntry_L := PlanEntry_LT."Entry No."
        else
            LastEntry_L := 0;

        PlanSetup_LT.FindFirst();
        PlanSetup_LT.TestField("Export Table No.");

        RR_L.Open(PlanSetup_LT."Export Table No.");

        PlanDocLevel_LT.Reset();
        PlanDocLevel_LT.SetCurrentKey("Planning Document No.", "Planning Document Level Index");
        PlanDocLevel_LT.SetRange("Planning Document No.", PlanDoc_PT."No.");

        PlanCube_LT.Reset();
        PlanCube_LT.SetCurrentKey("Planning Document No.", "Index 1", "Index 2", "Index 3", "Index 4", "Index 5", "Index 6", Date);
        PlanCube_LT.SetRange("Planning Document No.", PlanDoc_PT."No.");

        // ---------- Schleife über Cube-Entries
        if PlanCube_LT.FindSet() then begin
            BETFNDialogMgt.OpenDialog(PlanCube_LT.Count, ExportingPlanningDataLbl);
            PlanDocLevel_LT.FindLast();
            repeat
                BETFNDialogMgt.UpdateDialog(0);

                // nur Zeilen mit Planwerten exportieren:
                if LineHasPlanningValues(PlanCube_LT) then begin

                    // Setze Indexfilter
                    SetFilters(PlanCube_LT, PlanDocLevel_LT, RR_L);

                    // Prüfe, ob bereits Zeile in Exporttabelle existiert
                    if RR_L.FindFirst() then begin

                        // Übertrage Werte
                        TransferValuesToEntry(PlanCube_LT, RR_L, PlanDoc_PT);
                        RR_L.Modify();
                    end else begin
                        // Erzeuge neue Postenzeile
                        RR_L.Init();
                        LastEntry_L := LastEntry_L + 1;
                        TransferIndexToEntry(PlanCube_LT, PlanDocLevel_LT, RR_L, LastEntry_L);
                        TransferValuesToEntry(PlanCube_LT, RR_L, PlanDoc_PT);
                        RR_L.Insert();
                    end;
                end;
            until PlanCube_LT.Next() = 0;
            BETFNDialogMgt.CloseDialog();
        end;
    end;

    local procedure LineHasPlanningValues(BETFNPlanningValueCube: Record "BET FN Planning Value Cube"): Boolean
    var
        LineHasPlanningValues_L: Boolean;
    begin
        // nur exportieren, wenn mind. ein Wert gefüllt ist
        LineHasPlanningValues_L := false;

        if (Round(BETFNPlanningValueCube."Plan Sales Amount", 1) <> 0)
          or (Round(BETFNPlanningValueCube."Plan Sal. Am. Discount", 1) <> 0)
          or (Round(BETFNPlanningValueCube."Plan Sales Init. Inv.", 1) <> 0)
          or (Round(BETFNPlanningValueCube."Plan Sales Closing Inv.", 1) <> 0)
          or (Round(BETFNPlanningValueCube."Plan Gross Sales Pr. Reduction", 1) <> 0)
          or (Round(BETFNPlanningValueCube."Plan Sales Am. Purchase", 1) <> 0)
          or (Round(BETFNPlanningValueCube."Plan Qty. Sale", 1) <> 0)
          or (Round(BETFNPlanningValueCube."Plan Qty. Init. Inv.", 1) <> 0)
          or (Round(BETFNPlanningValueCube."Plan Qty. Closing Inv.", 1) <> 0)
          or (Round(BETFNPlanningValueCube."Plan Qty. Purchase", 1) <> 0)
          or (Round(BETFNPlanningValueCube."Plan Cost of Sales", 1) <> 0)
          or (Round(BETFNPlanningValueCube."Plan Cost Init. Inv.", 1) <> 0)
          or (Round(BETFNPlanningValueCube."Plan Cost Closing Inv.", 1) <> 0)
          or (Round(BETFNPlanningValueCube."Plan Cost Am. Purchase", 1) <> 0)
          or (Round(BETFNPlanningValueCube."Plan Sales Order Amount", 1) <> 0)
          or CheckOtherValues(BETFNPlanningValueCube)
        then
            LineHasPlanningValues_L := true;

        exit(LineHasPlanningValues_L);
    end;

    local procedure CheckOtherValues(BETFNPlanningValueCube: Record "BET FN Planning Value Cube"): Boolean
    var
        CheckResult: Boolean;
    begin
        OnBeforeExportCheckValues(BETFNPlanningValueCube, CheckResult);
    end;

    /// <summary>
    /// SetFilters.
    /// </summary>
    /// <param name="PlanCube_PT">Record "BET FN Planning Value Cube".</param>
    /// <param name="PlanDocLevel_PT">Record "BET FN Planning Document Level".</param>
    /// <param name="RREntry_P">VAR RecordRef.</param>
    procedure SetFilters(PlanCube_PT: Record "BET FN Planning Value Cube"; PlanDocLevel_PT: Record "BET FN Planning Document Level"; var RREntry_P: RecordRef)
    var
        PlanDoc_LT: Record "BET FN Planning Document";
        PlanLevel_LT: Record "BET FN Planning Level";
        PlanSetup_LT: Record "BET FN Planning Setup";
        PL_Functions_LC: Codeunit "BET FN Planning Functions";
        RRCube_L: RecordRef;
        RRLevel_L: RecordRef;
        FRCube_L: FieldRef;
        FREntry_L: FieldRef;
        FRLevel_L: FieldRef;
        Count_L: Integer;
        FilterText_L: Text[1024];
    begin
        // ---------- Übertrage Index auf Setview
        RRCube_L.GetTable(PlanCube_PT);
        RRLevel_L.GetTable(PlanDocLevel_PT);
        for Count_L := 1 to PL_Functions_LC.GetMaxNoOfLevels() do begin
            FRCube_L := RRCube_L.Field(Count_L);
            FRLevel_L := RRLevel_L.Field(Count_L * 10 + 1000);

            // ---------- Prüfe, ob Index belegt ist
            if (Format(FRLevel_L.Value()) <> '') and
               (PlanLevel_LT.Get(Format(FRLevel_L.Value()))) and
               (PlanLevel_LT."Export Field No." <> 0) then begin
                FREntry_L := RREntry_P.Field(PlanLevel_LT."Export Field No.");

                // ---------- Setze Indexfilter
                if Format(FRCube_L.Value()) <> '' then
                    FilterText_L := FilterText_L + FREntry_L.Caption() + '=FILTER(' + Format(FRCube_L.Value()) + '),'
                else
                    FilterText_L := FilterText_L + FREntry_L.Caption() + '=CONST(''''),';
            end;
        end;
        PlanSetup_LT.FindFirst();
        PlanSetup_LT.TestField("Date Field in Export Table");

        // ---------- Datumsfeld
        FREntry_L := RREntry_P.Field(PlanSetup_LT."Date Field in Export Table");
        FRCube_L := RRCube_L.Field(PlanCube_PT.FieldNo(PlanCube_PT.Date));
        if Format(FRCube_L.Value()) <> '' then
            FilterText_L := FilterText_L + FREntry_L.Caption() + '=FILTER(' + Format(FRCube_L.Value()) + '),'
        else
            FilterText_L := FilterText_L + FREntry_L.Caption() + '=FILTER(=''''),';

        // ---------- Saison
        if PlanSetup_LT."Export Season" then begin
            PlanSetup_LT.TestField("Season Field in Export Table");
            FREntry_L := RREntry_P.Field(PlanSetup_LT."Season Field in Export Table");
            PlanDoc_LT.Get(PlanCube_PT."Planning Document No.");
            if PlanDoc_LT."Planning Season" <> '' then
                FilterText_L := FilterText_L + FREntry_L.Caption() + '=FILTER(' + PlanDoc_LT."Planning Season" + '),'
            else
                FilterText_L := FilterText_L + FREntry_L.Caption() + '=FILTER(=''''),';
        end;
        FilterText_L := DelChr(FilterText_L, '>', ',');

        RREntry_P.SetView('WHERE(' + FilterText_L + ')');
    end;

    /// <summary>
    /// TransferIndexToEntry.
    /// </summary>
    /// <param name="PlanCube_PT">Record "BET FN Planning Value Cube".</param>
    /// <param name="PlanDocLevel_PT">Record "BET FN Planning Document Level".</param>
    /// <param name="RREntry_P">VAR RecordRef.</param>
    /// <param name="EntryNo_P">Integer.</param>
    procedure TransferIndexToEntry(PlanCube_PT: Record "BET FN Planning Value Cube"; PlanDocLevel_PT: Record "BET FN Planning Document Level"; var RREntry_P: RecordRef; EntryNo_P: Integer)
    var
        PlanDoc_LT: Record "BET FN Planning Document";
        PlanLevel_LT: Record "BET FN Planning Level";
        PlanSetup_LT: Record "BET FN Planning Setup";
        PlanFunctions_LC: Codeunit "BET FN Planning Functions";
        RRCube_L: RecordRef;
        RRLevel_L: RecordRef;
        FRCube_L: FieldRef;
        FREntry_L: FieldRef;
        FRLevel_L: FieldRef;
        Count_L: Integer;
    begin
        // ---------- Übertrage Indexfelder
        RRCube_L.GetTable(PlanCube_PT);
        RRLevel_L.GetTable(PlanDocLevel_PT);
        for Count_L := 1 to PlanFunctions_LC.GetMaxNoOfLevels() do begin
            FRCube_L := RRCube_L.Field(Count_L);
            FRLevel_L := RRLevel_L.Field(Count_L * 10 + 1000);
            // ---------- Prüfe, ob Index belegt ist
            if (Format(FRLevel_L.Value()) <> '') and
               (PlanLevel_LT.Get(Format(FRLevel_L.Value()))) and
               (PlanLevel_LT."Export Field No." <> 0) then begin
                FREntry_L := RREntry_P.Field(PlanLevel_LT."Export Field No.");
                FREntry_L.Value(FRCube_L.Value());
            end;
        end;
        PlanSetup_LT.FindFirst();
        PlanSetup_LT.TestField("Date Field in Export Table");

        // ---------- Datumsfeld
        FREntry_L := RREntry_P.Field(PlanSetup_LT."Date Field in Export Table");
        FRCube_L := RRCube_L.Field(PlanCube_PT.FieldNo(PlanCube_PT.Date));
        FREntry_L.Value := FRCube_L.Value();

        // ---------- Saison
        if PlanSetup_LT."Export Season" then begin
            PlanSetup_LT.TestField("Season Field in Export Table");
            FREntry_L := RREntry_P.Field(PlanSetup_LT."Season Field in Export Table");
            PlanDoc_LT.Get(PlanCube_PT."Planning Document No.");
            FREntry_L.Value(PlanDoc_LT."Planning Season");
        end;

        // ---------- Primärschlüsselfeld
        FREntry_L := RREntry_P.Field(PlanSetup_LT."PK Field in Export Table");
        FREntry_L.Value(EntryNo_P);
    end;

    /// <summary>
    /// TransferValuesToEntry.
    /// </summary>
    /// <param name="PlanCube_PT">Record "BET FN Planning Value Cube".</param>
    /// <param name="RREntry_P">VAR RecordRef.</param>
    /// <param name="PlanDoc_PT">Record "BET FN Planning Document".</param>
    procedure TransferValuesToEntry(PlanCube_PT: Record "BET FN Planning Value Cube"; var RREntry_P: RecordRef; PlanDoc_PT: Record "BET FN Planning Document")
    var
        PlanningEntry_LT: Record "BET FN Planning Entry (DWH)";
        ExportFieldref_LT: Record "BET FN Planning Export Fld Ref";
        PlanSetup_LT: Record "BET FN Planning Setup";
        RRCube_L: RecordRef;
        FRCube_L: FieldRef;
        FREntry_L: FieldRef;
        Temp1_L: Decimal;
        Temp2_L: Decimal;
        LastField_L: Integer;
    begin
        // ---------- Übertrage Wertefelder
        RRCube_L.GetTable(PlanCube_PT);
        ExportFieldref_LT.Reset();
        LastField_L := 0;
        if ExportFieldref_LT.Find('-') then
            repeat
                // ---------- Hole Feldzuweisung
                FREntry_L := RREntry_P.Field(ExportFieldref_LT."Export Field No.");
                FRCube_L := RRCube_L.Field(ExportFieldref_LT."Cube Field No.");
                // ---------- Leere Feld vor erster Zuweisung
                if LastField_L <> ExportFieldref_LT."Export Field No." then
                    FREntry_L.Value(0);
                Temp1_L := FREntry_L.Value();
                Temp2_L := FRCube_L.Value();
                // ---------- Addition/Subtraktion bei mehrfacher Zuweisung
                if ExportFieldref_LT."Reverse Sign" then
                    FREntry_L.Value(Temp1_L - Temp2_L)
                else
                    FREntry_L.Value(Temp1_L + Temp2_L);
                LastField_L := ExportFieldref_LT."Export Field No.";
            until ExportFieldref_LT.Next() = 0;
        PlanSetup_LT.FindFirst();
        PlanSetup_LT.TestField("Doc. No. Field in Export Table");
        // ---------- Planungsbelegnr. Speichern
        FREntry_L := RREntry_P.Field(PlanSetup_LT."Doc. No. Field in Export Table");
        FRCube_L := RRCube_L.Field(PlanCube_PT.FieldNo(PlanCube_PT."Planning Document No."));
        FREntry_L.Value(FRCube_L.Value());

        //### Geschäftsjahr speichern:
        FREntry_L := RREntry_P.Field(15);
        FREntry_L.Value(PlanDoc_PT."Financial Year");

        //### Planungstyp speichern:
        FREntry_L := RREntry_P.Field(PlanningEntry_LT.FieldNo("Planning Type"));
        FREntry_L.Value(PlanDoc_PT."Planning Type");

        //### Planungsversion:
        FREntry_L := RREntry_P.Field(PlanningEntry_LT.FieldNo("Planning Version"));
        FREntry_L.Value(PlanDoc_PT."Planning Version");
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeExportCheckValues(BETFNPlanningValueCube: Record "BET FN Planning Value Cube"; var CheckResult: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeExportDocument(BETFNPlanningDocument: Record "BET FN Planning Document"; var IsHandled: Boolean)
    begin
    end;
}

