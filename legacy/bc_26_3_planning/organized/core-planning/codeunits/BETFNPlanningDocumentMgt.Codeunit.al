/// <summary>
/// [planning]
/// Modules: 
/// </summary>
#pragma warning disable AL0432
codeunit 5138633 "BET FN Planning Document Mgt"
{
    Access = Public;

    /// <summary>
    /// CreateRefDateTab.
    /// </summary>
    /// <param name="PlanDoc_PT">Record "BET FN Planning Document".</param>
    procedure CreateRefDateTab(PlanDoc_PT: Record "BET FN Planning Document")
    var
        PlanDocDateRef_LT: Record "BET FN Planning Document D Ref";
        Date2_LT: Record Date;
        Date_LT: Record Date;
        Counter_L: Integer;
        NoOfDateLinesMustBeEqualErr: Label 'No of date lines in planning period and reference period must be equal.';
    begin
        //### erzeugt Datums-Tabelle mit Zuordnung von:
        //###      Datum Saison <---> Datum Vergleichssaison
        PlanDoc_PT.TestField("Start Date");
        PlanDoc_PT.TestField("End Date");
        PlanDoc_PT.TestField("Start Date Ref. Period");
        PlanDoc_PT.TestField("End Date Ref. Period");

        PlanDocDateRef_LT.Reset();
        PlanDocDateRef_LT.SetRange("Planning Document No.", PlanDoc_PT."No.");
        PlanDocDateRef_LT.DeleteAll();
        Date_LT.Reset();
        Date_LT.SetRange("Period Type", PlanDoc_PT."Date Unit");
        Date_LT.SetRange("Period Start", PlanDoc_PT."Start Date", PlanDoc_PT."End Date");

        Date2_LT.Reset();
        Date2_LT.SetRange("Period Type", PlanDoc_PT."Date Unit");                                                       //### Planperiode
        Date2_LT.SetRange("Period Start", PlanDoc_PT."Start Date Ref. Period", PlanDoc_PT."End Date Ref. Period");      //### VJ-Periode
        if Date_LT.Count() <> Date2_LT.Count() then
            Error(NoOfDateLinesMustBeEqualErr);
        if (Date_LT.FindSet()) and (Date2_LT.FindSet()) then
            repeat
                PlanDocDateRef_LT.Init();
                PlanDocDateRef_LT."Planning Document No." := PlanDoc_PT."No.";
                PlanDocDateRef_LT.Date := Date_LT."Period Start";
                PlanDocDateRef_LT."Reference Date" := Date2_LT."Period Start";
                PlanDocDateRef_LT.Insert();
            until (Date_LT.Next() = 0) or (Date2_LT.Next() = 0);

        //### Gleichverteilung der Prozente:
        PlanDocDateRef_LT.Reset();
        PlanDocDateRef_LT.SetRange("Planning Document No.", PlanDoc_PT."No.");
        if PlanDocDateRef_LT.FindSet(true) then begin
            Counter_L := PlanDocDateRef_LT.Count();
            repeat
                PlanDocDateRef_LT.Percentage := 100 / Counter_L;
                PlanDocDateRef_LT.Modify();
            until PlanDocDateRef_LT.Next() = 0;
        end;
    end;

    /// <summary>
    /// CreateBufferNew.
    /// </summary>
    /// <param name="PlanningDocumentNo_P">Code[20].</param>
    /// <param name="Level_P">Integer.</param>
    procedure CreateBufferNew(PlanningDocumentNo_P: Code[20]; Level_P: Integer)
    var
        PlanDocLevelBuffer_LT: Record "BET FN Planning Doc Lvl Buf";
        PlanDoc_LT: Record "BET FN Planning Document";
        PlanDocLevel_LT: Record "BET FN Planning Document Level";
        PlanLevel_LT: Record "BET FN Planning Level";
        PlanType_LT: Record "BET FN Planning Type";
        PlanDimAssignMgt_LC: Codeunit "BET FN Plan. Dim. Assign. Mgt.";
        RecRef_L: RecordRef;
        FieldRef_L: FieldRef;
        IndexOK_L: Boolean;
        Index_L: Code[20];
        Description_L: Text[50];
    begin
        PlanDocLevel_LT.Reset();
        PlanDocLevel_LT.SetRange("Planning Document No.", PlanningDocumentNo_P);
        PlanDocLevel_LT.SetRange("Planning Document Level Index", Level_P);
        PlanDocLevel_LT.SetFilter("Index Code", '<>%1', '');

        PlanDocLevelBuffer_LT.Reset();
        PlanDocLevelBuffer_LT.SetRange("Planning Document No.", PlanningDocumentNo_P);

        PlanDoc_LT.Get(PlanningDocumentNo_P);
        if PlanType_LT.Get(PlanDoc_LT."Planning Type") then;

        if PlanDocLevel_LT.FindSet(true) then
            repeat
                PlanLevel_LT.Get(PlanDocLevel_LT."Index Code");

                PlanDocLevelBuffer_LT.SetRange("Planning Document Level", PlanDocLevel_LT."Planning Document Level Index");
                PlanDocLevelBuffer_LT.DeleteAll();
                RecRef_L.Open(PlanLevel_LT."Index Table No.");
                FieldRef_L := RecRef_L.Field(PlanLevel_LT."Primary Key Field No.");
                FieldRef_L.SetFilter('<>%1', '');       // keine leeren Stammdatensätze zulassen

                // weitere Filterung (z.B. Auftragsart --> nur Einkauf)
                if PlanLevel_LT."Filter Field" <> 0 then begin
                    FieldRef_L := RecRef_L.Field(PlanLevel_LT."Filter Field");
                    FieldRef_L.SetFilter(PlanLevel_LT."Filter Value");
                end;

                if RecRef_L.FindSet() then
                    repeat
                        FieldRef_L := RecRef_L.Field(PlanLevel_LT."Primary Key Field No.");
                        Index_L := CopyStr(Format(FieldRef_L.Value()), 1, 20);

                        FieldRef_L := RecRef_L.Field(PlanLevel_LT."Description Field No.");
                        Description_L := CopyStr(Format(FieldRef_L.Value()), 1, 50);

                        IndexOK_L := true;

                        // Prüfung einzelner Elemente:
                        CheckSingleBufferIndex(IndexOK_L, PlanLevel_LT, Index_L);

                        // noch gegen Zuordnungstabelle prüfen, wenn eingerichtet (nur bei Verwendung von Planungstyp):
                        if (PlanType_LT.Code <> '') and IndexOK_L and PlanLevel_LT."Check Dim. Assign. Table" then
                            PlanDimAssignMgt_LC.CheckSingleBufferIndex(IndexOK_L, PlanDoc_LT, PlanLevel_LT, PlanType_LT, Index_L);


                        if (not PlanDocLevelBuffer_LT.Get(PlanDocLevel_LT."Planning Document No.",
                                                         PlanDocLevel_LT."Planning Document Level Index",
                                                         Index_L))
                                                           and IndexOK_L then begin
                            PlanDocLevelBuffer_LT.Init();
                            PlanDocLevelBuffer_LT."Planning Document No." := PlanDocLevel_LT."Planning Document No.";
                            PlanDocLevelBuffer_LT."Planning Document Level" := PlanDocLevel_LT."Planning Document Level Index";
                            PlanDocLevelBuffer_LT."Index Code" := Index_L;
                            PlanDocLevelBuffer_LT."Index Description" := Description_L;

                            PlanDocLevelBuffer_LT.Active := true;
                            //### schon vorher nicht gültige Kombinationen ausschließen:
                            if BufferElementIsValid(PlanDocLevel_LT, Index_L) then
                                PlanDocLevelBuffer_LT.Insert();
                        end;
                    until RecRef_L.Next() = 0;
                RecRef_L.Close();

                // Dummy einfügen:
                InsertDummyElement(PlanLevel_LT, PlanDoc_LT."No.", PlanDocLevel_LT."Planning Document Level Index");

                PlanDocLevel_LT.Modify();
            until PlanDocLevel_LT.Next() = 0;
    end;

    local procedure InsertDummyElement(PlanLevel_PT: Record "BET FN Planning Level"; PlanDocNo_P: Code[20]; LevelIndex_P: Integer)
    var
        PlanDocLevelBuffer_LT: Record "BET FN Planning Doc Lvl Buf";
        DummyDescriptionLbl: Label 'Dummy - ';
        DummyIndexLbl: Label 'DUMMY';
    begin
        // Einfügen von Dummy-Elementen in die Buffer-Tabelle:
        if PlanLevel_PT."Use Dummy" then begin
            PlanDocLevelBuffer_LT.Init();
            PlanDocLevelBuffer_LT."Planning Document No." := PlanDocNo_P;
            PlanDocLevelBuffer_LT."Planning Document Level" := LevelIndex_P;
            PlanDocLevelBuffer_LT."Index Code" := DummyIndexLbl;
            PlanDocLevelBuffer_LT."Index Description" := (DummyDescriptionLbl + PlanLevel_PT."Index Description");
            PlanDocLevelBuffer_LT.Active := true;
            PlanDocLevelBuffer_LT.Dummy := true;      // damit entfällt die Prüfung in der Zuordnungstabelle
            PlanDocLevelBuffer_LT.Insert();
        end;
    end;

    local procedure CheckSingleBufferIndex(var IndexOK_P: Boolean; PlanLevel_PT: Record "BET FN Planning Level"; Index_P: Code[20])
    var
        Location_LT: Record Location;
    begin
        case PlanLevel_PT."Index Table No." of
            Database::Location:
                // nur aktive Filialen und kein Zentrallager  
                if Location_LT.Get(Index_P) then
                    if (not Location_LT."BET FN Active") or (Location_LT."BET FN Main Warehouse") or (not Location_LT."BET FN Shop") then
                        IndexOK_P := false;
        end;
    end;

    /// <summary>
    /// BufferElementIsValid.
    /// </summary>
    /// <param name="PlanDocLevel_PT">Record "BET FN Planning Document Level".</param>
    /// <param name="IndexCode_P">Code[20].</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure BufferElementIsValid(PlanDocLevel_PT: Record "BET FN Planning Document Level"; IndexCode_P: Code[20]): Boolean
    var
        PlanDocLevelBuffer_LT: Record "BET FN Planning Doc Lvl Buf";
        PlanDocLevel_LT: Record "BET FN Planning Document Level";
        PlanLevel_LT: Record "BET FN Planning Level";
        PlanLevelCurrent_LT: Record "BET FN Planning Level";
        RR_L: RecordRef;
        FR_L: FieldRef;
        FoundLevel_L: Boolean;
        RelatedCode_L: Code[20];
    begin
        //### akt Ebene holen:
        PlanLevelCurrent_LT.Get(PlanDocLevel_PT."Index Code");

        //### wenn Planungsebene keine Zuordnung zu einer anderen Ebene besitzt, dann true zurückgeben
        if PlanLevelCurrent_LT."Assigned to Index" = '' then
            exit(true)

        else begin
            //### Prüfen, ob die zugeordnete Ebene in diesem Beleg oberhalb der akt. Ebene liegt:
            PlanDocLevel_LT.Reset();
            PlanDocLevel_LT.SetRange("Planning Document No.", PlanDocLevel_PT."Planning Document No.");
            PlanDocLevel_LT.SetRange("Index Code", PlanLevelCurrent_LT."Assigned to Index");

            //### 080819
            //### hier in Schleife solange prüfen, bis alle Ebenen durchlaufen sind bzw. bis die gesuchte
            //### Ebene gefunden wurde; dabei immer den zugehörigen Index-Code mitgeben

            //### den jeweils zugehörigen Code weitergeben: (WG -> HWG -> Abt.)
            RR_L.Open(PlanLevelCurrent_LT."Index Table No.");
            FR_L := RR_L.Field(PlanLevelCurrent_LT."Primary Key Field No.");    //### Code-Feld
            FR_L.SetRange(IndexCode_P);    //### auf akt. Element filtern
            if RR_L.FindFirst() then begin   //### ist das Element wirklich vorhanden?
                FR_L := RR_L.Field(PlanLevelCurrent_LT."Assigned to Index Field No.");    //### Feld d. höheren Ebene
                RelatedCode_L := FR_L.Value();   //### Bsp.: zugeornete HWG zur akt. WG merken
            end;
            RR_L.Close();

            if not PlanDocLevel_LT.FindFirst() then begin      //### zugeordnete Ebene ist bisher noch nicht vorhanden
                FoundLevel_L := false;
                //### also nacheinander alle in der Ebenen-Einrichtung verknüpften Ebenen durchsuchen:
                PlanLevel_LT.Reset();
                PlanLevel_LT.SetRange("Index Code", PlanLevelCurrent_LT."Assigned to Index");
                if PlanLevel_LT.FindFirst() then
                    repeat
                        //### ist die zugeordnete Ebene dieser Ebene vllt. im Beleg enthalten?
                        if PlanLevel_LT."Assigned to Index" <> '' then begin

                            //### akt. Element merken (z.B. WG 101  --> HWG 10)
                            RR_L.Open(PlanLevel_LT."Index Table No.");
                            FR_L := RR_L.Field(PlanLevel_LT."Primary Key Field No.");    //### Code-Feld
                            FR_L.SetRange(RelatedCode_L);    //### auf weitergegebenes Element filtern
                            if RR_L.FindFirst() then begin   //### ist das Element wirklich vorhanden?
                                FR_L := RR_L.Field(PlanLevel_LT."Assigned to Index Field No.");    //### Feld d. höheren Ebene
                                RelatedCode_L := FR_L.Value();   //### Bsp.: zugeornete HWG zur akt. WG merken
                            end;
                            RR_L.Close();

                            PlanDocLevel_LT.SetRange("Index Code", PlanLevel_LT."Assigned to Index");
                            if PlanDocLevel_LT.FindFirst() then
                                FoundLevel_L := true     //### Ebene wird bereits im Beleg verwendet
                            else begin     //### diese Ebene ist nicht im Beleg enthalten
                                PlanLevel_LT.SetRange("Index Code", PlanLevel_LT."Assigned to Index");
                                PlanLevel_LT.FindFirst();
                            end;
                        end;
                    until (PlanLevel_LT."Assigned to Index" = '') or FoundLevel_L;      //### Abbruch, wenn Verknüpfungskette unterbrochen
            end else
                FoundLevel_L := true;

            //### jetzt einfach prüfen, ob in der Puffertabelle der gefundenen Ebene das gemerkte Element (RelatedCode) aktiv ist
            if FoundLevel_L then begin
                PlanDocLevelBuffer_LT.Reset();
                PlanDocLevelBuffer_LT.SetRange("Planning Document No.", PlanDocLevel_PT."Planning Document No.");
                PlanDocLevelBuffer_LT.SetRange("Planning Document Level", PlanDocLevel_LT."Planning Document Level Index");
                PlanDocLevelBuffer_LT.SetRange(Active, true);
                PlanDocLevelBuffer_LT.SetRange("Index Code", RelatedCode_L);     //### hier den gemerkten Index verwenden
                exit(not PlanDocLevelBuffer_LT.IsEmpty());
            end else
                exit(true);
            //### ...080819
        end;
    end;

    /// <summary>
    /// BufferIsValid.
    /// </summary>
    /// <param name="PlanDocLevelBuffer_PT">Record "BET FN Planning Doc Lvl Buf".</param>
    /// <param name="PlanView_PT">Record "BET FN Planning View".</param>
    /// <param name="PlanDoc_PT">Record "BET FN Planning Document".</param>
    /// <param name="PlanDocLevel_PT">Record "BET FN Planning Document Level".</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure BufferIsValid(PlanDocLevelBuffer_PT: Record "BET FN Planning Doc Lvl Buf"; PlanView_PT: Record "BET FN Planning View"; PlanDoc_PT: Record "BET FN Planning Document"; PlanDocLevel_PT: Record "BET FN Planning Document Level"): Boolean
    var
        PlanDocLevel_LT: Record "BET FN Planning Document Level";
        PlanDocLevelNew_LT: Record "BET FN Planning Document Level";
        PlanLevel_LT: Record "BET FN Planning Level";
        PlanLevelCurrent_LT: Record "BET FN Planning Level";
        PlanDimAssignMgt_LC: Codeunit "BET FN Plan. Dim. Assign. Mgt.";
        RR_L: RecordRef;
        FR_L: FieldRef;
        BufferIsValidResult: Boolean;
        CheckAgain_L: Boolean;
        FoundLevel_L: Boolean;
        IsHandled: Boolean;
        RelatedCode_L: Code[20];
    begin
        OnBeforeBufferIsValid(PlanDocLevelBuffer_PT, PlanView_PT, PlanDoc_PT, PlanDocLevel_PT, BufferIsValidResult, IsHandled);
        if IsHandled then
            exit(BufferIsValidResult);

        //### durchlaufe alle höheren ebenen (vert. > akt. vert.) von UNTEN nach OBEN
        //### nimm jeweils PlanLevel der Ebene und PlanLevel der akt. Ebene
        //### prüfe, ob Zuordnung vorliegt; wenn ja: nimm diese Ebene zum Prüfen

        //### akt. Ebene:
        PlanDocLevelNew_LT.Get(PlanDocLevelBuffer_PT."Planning Document No.", PlanDocLevelBuffer_PT."Planning Document Level");

        PlanLevelCurrent_LT.Get(PlanDocLevelNew_LT."Index Code");

        //### oberste Ebene (vert. = 1) : Elemente immer einfügen
        if PlanDocLevelBuffer_PT."Planning Document Level" = 1 then
            exit(true);

        if PlanLevelCurrent_LT."Check Dim. Assign. Table" then
            exit(PlanDimAssignMgt_LC.CheckBufferIndexComplete(PlanDoc_PT, PlanDocLevel_PT, PlanDocLevelBuffer_PT, PlanView_PT));

        //### Ebene des akt. Bufferelements ist einer anderen Ebene zugeordnet, also nächsthöhere Ebene suchen:
        if PlanLevelCurrent_LT."Assigned to Index" <> '' then begin
            //### hier in Schleife solange prüfen, bis alle Ebenen durchlaufen sind bzw. bis die gesuchte
            //### Ebene gefunden wurde; dabei immer den zugehörigen Index-Code mitgeben
            PlanDocLevel_LT.Reset();
            PlanDocLevel_LT.SetRange("Planning Document No.", PlanDocLevelBuffer_PT."Planning Document No.");
            PlanDocLevel_LT.SetRange("Index Code", PlanLevelCurrent_LT."Assigned to Index");

            //### den jeweils zugehörigen Code weitergeben: (WG -> HWG -> Abt.)
            RR_L.Open(PlanLevelCurrent_LT."Index Table No.");
            RR_L.Reset();
            FR_L := RR_L.Field(PlanLevelCurrent_LT."Primary Key Field No.");    //### Code-Feld
            FR_L.SetRange(PlanDocLevelBuffer_PT."Index Code");    //### auf akt. Element filtern
            if RR_L.FindFirst() then begin   //### ist das Element wirklich vorhanden?
                FR_L := RR_L.Field(PlanLevelCurrent_LT."Assigned to Index Field No.");    //### Feld d. höheren Ebene
                RelatedCode_L := FR_L.Value();   //### Bsp.: zugeornete HWG zur akt. WG merken
            end;
            RR_L.Close();

            CheckAgain_L := false;

            if PlanDocLevel_LT.FindFirst() then
                FoundLevel_L := true
            else
                CheckAgain_L := true;

            if CheckAgain_L then begin  // nach anderer Ebene zum Prüfen des neuen Elements suchen  (z.B. Ebene HWG bei neuem ARTIKEL)
                FoundLevel_L := false;
                //### also nacheinander alle in der Ebenen-Einrichtung verknüpften Ebenen durchsuchen:
                PlanLevel_LT.Reset();
                PlanLevel_LT.SetRange("Index Code", PlanLevelCurrent_LT."Assigned to Index");
                if PlanLevel_LT.FindFirst() then
                    repeat
                        //### ist die zugeordnete Ebene dieser Ebene vllt. im Beleg enthalten?
                        if PlanLevel_LT."Assigned to Index" <> '' then begin
                            //### akt. Element merken (z.B. WG 101  --> HWG 10)
                            RR_L.Open(PlanLevel_LT."Index Table No.");
                            FR_L := RR_L.Field(PlanLevel_LT."Primary Key Field No.");    //### Code-Feld
                            FR_L.SetRange(RelatedCode_L);    //### auf weitergegebenes Element filtern
                            if RR_L.FindFirst() then begin   //### ist das Element wirklich vorhanden?
                                FR_L := RR_L.Field(PlanLevel_LT."Assigned to Index Field No.");    //### Feld d. höheren Ebene
                                RelatedCode_L := FR_L.Value();   //### Bsp.: zugeornete HWG zur akt. WG merken
                            end;
                            RR_L.Close();

                            PlanDocLevel_LT.SetRange("Index Code", PlanLevel_LT."Assigned to Index");
                            if PlanDocLevel_LT.FindFirst() then
                                FoundLevel_L := true     //### Ebene wird bereits im Beleg verwendet
                            else begin     //### diese Ebene ist nicht im Beleg enthalten
                                PlanLevel_LT.SetRange("Index Code", PlanLevel_LT."Assigned to Index");
                                PlanLevel_LT.FindFirst();
                            end;
                        end;
                    until (PlanLevel_LT."Assigned to Index" = '') or FoundLevel_L;      //### Abbruch, wenn Verknüpfungskette unterbrochen
            end else
                FoundLevel_L := true;

            //### hier gehn wir nur rein, wenn wirklich eine Verbindung beider Ebenen besteht
            //### UND sich beide im selben Zweig befinden !
            if FoundLevel_L then
                case PlanDocLevel_LT."Planning Document Level Index" of
                    1:
                        exit(PlanView_PT."Index 1" = RelatedCode_L);
                    2:
                        exit(PlanView_PT."Index 2" = RelatedCode_L);
                    3:
                        exit(PlanView_PT."Index 3" = RelatedCode_L);
                    4:
                        exit(PlanView_PT."Index 4" = RelatedCode_L);
                    5:
                        exit(PlanView_PT."Index 5" = RelatedCode_L);
                    6:
                        exit(PlanView_PT."Index 6" = RelatedCode_L);
                end
            else
                exit(true);

        end else
            //### Ebene des akt. Bufferelements ist keiner weiteren Ebene zugeordnet, also OK
            exit(true);
    end;

    /// <summary>
    /// LevelIsNotAllowed.
    /// </summary>
    /// <param name="NewLevel_PT">Record "BET FN Planning Level".</param>
    /// <param name="ExistingLevel_PT">Record "BET FN Planning Level".</param>
    /// <param name="DocNo_P">Code[20].</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure LevelIsNotAllowed(NewLevel_PT: Record "BET FN Planning Level"; ExistingLevel_PT: Record "BET FN Planning Level"; DocNo_P: Code[20]): Boolean
    var
        PlanLevel_LT: Record "BET FN Planning Level";
    begin
        //### 070810
        //### geg.: 2 Ebenen und Belegnummer
        //### ges.: sind die beiden Ebenen in der richtigen Reihenfolge angeordnet?
        //          Bsp.: Abt-HWG: richtig,  WG-Abt.: falsch!

        if ExistingLevel_PT."Assigned to Index" = '' then
            exit(false)
        else
            if ExistingLevel_PT."Assigned to Index" = NewLevel_PT."Index Code" then
                exit(true)
            else
                if PlanLevel_LT.Get(ExistingLevel_PT."Assigned to Index") then
                    exit(LevelIsNotAllowed(NewLevel_PT, PlanLevel_LT, DocNo_P))
                else
                    exit(false);
    end;

    /// <summary>
    /// CreateNewLevelLine.
    /// </summary>
    /// <param name="PlanDocLevel_PT">Record "BET FN Planning Document Level".</param>
    procedure CreateNewLevelLine(PlanDocLevel_PT: Record "BET FN Planning Document Level")
    var
        PlanDoc_LT: Record "BET FN Planning Document";
        PlanDocLevel_LT: Record "BET FN Planning Document Level";
        PlanLevel_LT: Record "BET FN Planning Level";
        ConfirmManagement: Codeunit "Confirm Management";
        ChangingLevelsNotAllowedErr: Label 'Planning document already created.\Changing levels is not allowed.';
        InsertNewLevelBelowQst: Label 'Insert New Level Below %1 ?', Comment = '%1';
    begin
        //### Ebenenübersicht direkt aufrufen
        if PlanDoc_LT.Get(PlanDocLevel_PT."Planning Document No.") and (PlanDoc_LT."Planning Document Created" = 0DT) then begin
            if ConfirmManagement.GetResponse(StrSubstNo(InsertNewLevelBelowQst, PlanDocLevel_PT."Index Description"), true) then begin
                PlanLevel_LT.Reset();
                PlanLevel_LT.SetRange(Activated, true);

                PlanDocLevel_LT.Get(PlanDocLevel_PT."Planning Document No.", PlanDocLevel_PT."Planning Document Level Index");

                if Page.RunModal(0, PlanLevel_LT) = Action::LookupOK then
                    CreateLevel(PlanDoc_LT."Timestamp Planning Values",
                                PlanLevel_LT."Index Code",
                                PlanLevel_LT."Index Table No.",
                                PlanLevel_LT."Index Description",
                                PlanDocLevel_LT."Planning Document No.",
                                PlanDocLevel_LT."Planning Document Level Index" + 1);
            end;
        end
        else
            Error(ChangingLevelsNotAllowedErr);
    end;

    /// <summary>
    /// CreateStructureTemplate.
    /// </summary>
    /// <param name="PlanDoc_RT">VAR Record "BET FN Planning Document".</param>
    /// <param name="PlanType_P">Code[20].</param>
    /// <param name="ShowDialog_P">Boolean.</param>
    procedure CreateStructureTemplate(var PlanDoc_RT: Record "BET FN Planning Document"; PlanType_P: Code[20]; ShowDialog_P: Boolean)
    var
        TotalDocLevel_LT: Record "BET FN Planning Document Level";
        PlanLevelInsert_LT: Record "BET FN Planning Level";
        PlanType_LT: Record "BET FN Planning Type";
        Window: Dialog;
        CouldNotCreateReceiptLevelErr: Label 'Document levels could not be created.';
        CreateLevelTxt: Label 'Create level #1#######', Comment = '%1';
    begin
        //### Funktion zum automatischen Anlegen der Ebenen (laut Einstellung im Planungstyp)

        if PlanType_LT.Get(PlanType_P) then begin
            if ShowDialog_P then
                Window.Open(CreateLevelTxt);

            PlanDoc_RT."Auto Filter On Level Changing" := PlanType_LT."Auto Filter On Level Changing";    //### autom. Filterung bei Ebenenwechsel

            //### Datum optional auch auf Gesamtebene übertragen!
            TotalDocLevel_LT.Reset();
            TotalDocLevel_LT.SetRange("Planning Document No.", PlanDoc_RT."No.");
            TotalDocLevel_LT.SetRange("Planning Document Level Index", 0);
            if TotalDocLevel_LT.FindFirst() then begin
                TotalDocLevel_LT."Activate Date Level" := PlanType_LT."Use Date Level";
                TotalDocLevel_LT.Modify();
            end;

            if PlanLevelInsert_LT.Get(PlanType_LT.Level1) then begin
                if ShowDialog_P then
                    Window.Update(1, PlanLevelInsert_LT."Index Description");

                CreateLevel(CreateDateTime(WorkDate(), Time()),
                            PlanLevelInsert_LT."Index Code",
                            PlanLevelInsert_LT."Index Table No.",
                            PlanLevelInsert_LT."Index Description",
                            PlanDoc_RT."No.",
                            1   // Ebene 
                            );
            end;

            if PlanLevelInsert_LT.Get(PlanType_LT.Level2) then begin
                if ShowDialog_P then
                    Window.Update(1, PlanLevelInsert_LT."Index Description");

                CreateLevel(CreateDateTime(WorkDate(), Time()),
                            PlanLevelInsert_LT."Index Code",
                            PlanLevelInsert_LT."Index Table No.",
                            PlanLevelInsert_LT."Index Description",
                            PlanDoc_RT."No.",
                            2   // Ebene 
                            );
            end;

            if PlanLevelInsert_LT.Get(PlanType_LT.Level3) then begin
                if ShowDialog_P then
                    Window.Update(1, PlanLevelInsert_LT."Index Description");

                CreateLevel(CreateDateTime(WorkDate(), Time()),
                            PlanLevelInsert_LT."Index Code",
                            PlanLevelInsert_LT."Index Table No.",
                            PlanLevelInsert_LT."Index Description",
                            PlanDoc_RT."No.",
                            3   // Ebene 
                            );
            end;

            if PlanLevelInsert_LT.Get(PlanType_LT.Level4) then begin
                if ShowDialog_P then
                    Window.Update(1, PlanLevelInsert_LT."Index Description");

                CreateLevel(CreateDateTime(WorkDate(), Time()),
                            PlanLevelInsert_LT."Index Code",
                            PlanLevelInsert_LT."Index Table No.",
                            PlanLevelInsert_LT."Index Description",
                            PlanDoc_RT."No.",
                            4   // Ebene 
                            );
            end;

            if PlanLevelInsert_LT.Get(PlanType_LT.Level5) then begin
                if ShowDialog_P then
                    Window.Update(1, PlanLevelInsert_LT."Index Description");

                CreateLevel(CreateDateTime(WorkDate(), Time()),
                            PlanLevelInsert_LT."Index Code",
                            PlanLevelInsert_LT."Index Table No.",
                            PlanLevelInsert_LT."Index Description",
                            PlanDoc_RT."No.",
                            5   // Ebene 
                            );
            end;

            if PlanLevelInsert_LT.Get(PlanType_LT.Level6) then begin
                if ShowDialog_P then
                    Window.Update(1, PlanLevelInsert_LT."Index Description");

                CreateLevel(CreateDateTime(WorkDate(), Time()),
                            PlanLevelInsert_LT."Index Code",
                            PlanLevelInsert_LT."Index Table No.",
                            PlanLevelInsert_LT."Index Description",
                            PlanDoc_RT."No.",
                            6   // Ebene 
                            );
            end;

            if ShowDialog_P then
                Window.Close();
        end else
            Error(CouldNotCreateReceiptLevelErr);
    end;

    /// <summary>
    /// CreateLevel.
    /// </summary>
    /// <param name="DateTime_P">DateTime.</param>
    /// <param name="IndexCode_P">Code[20].</param>
    /// <param name="IndexTableNo_P">Integer.</param>
    /// <param name="IndexDescription_P">Text[30].</param>
    /// <param name="DocNo_P">Code[20].</param>
    /// <param name="Level_P">Integer.</param>
    procedure CreateLevel(DateTime_P: DateTime; IndexCode_P: Code[20]; IndexTableNo_P: Integer; IndexDescription_P: Text[30]; DocNo_P: Code[20]; Level_P: Integer)
    var
        ParentPlanDocLevel_LT: Record "BET FN Planning Document Level";
        PlanDocLevel_LT: Record "BET FN Planning Document Level";
        PlanLevel2_LT: Record "BET FN Planning Level";
        PlanLevel_LT: Record "BET FN Planning Level";
        RR1_L: RecordRef;
        RR2_L: RecordRef;
        FR1_L: FieldRef;
        FR2_L: FieldRef;
        FieldNoVar_L: Integer;
        IndexAlreadyInUseErr: Label 'Index is already in use.';
        LevelCannotBeInsertedBelowLevelErr: Label 'Level %1 can not be inserted below level %2.\Please check level setup.', Comment = '%1 %2';
    begin
        PlanDocLevel_LT.Reset();
        PlanDocLevel_LT.SetRange("Planning Document No.", DocNo_P);
        PlanDocLevel_LT.SetRange("Index Code", IndexCode_P);
        if PlanDocLevel_LT.FindFirst() then
            Error(IndexAlreadyInUseErr);

        if PlanLevel_LT.Get(IndexCode_P) then
            if PlanDocLevel_LT.Get(DocNo_P, Level_P - 1) and (Level_P > 1) then
                repeat
                    if PlanLevel2_LT.Get(PlanDocLevel_LT."Index Code") and LevelIsNotAllowed(PlanLevel_LT, PlanLevel2_LT, DocNo_P) then
                        Error(LevelCannotBeInsertedBelowLevelErr, PlanLevel_LT."Index Code", PlanDocLevel_LT."Index Code");

                    PlanDocLevel_LT.Get(DocNo_P, PlanDocLevel_LT."Planning Document Level Index" - 1);
                until PlanDocLevel_LT."Planning Document Level Index" = 0;

        if not PlanDocLevel_LT.Get(DocNo_P, Level_P) then begin
            ParentPlanDocLevel_LT.Get(DocNo_P, Level_P - 1);

            PlanDocLevel_LT.Init();
            PlanDocLevel_LT := ParentPlanDocLevel_LT;
            PlanDocLevel_LT."Planning Document Level Index" := Level_P;
            PlanDocLevel_LT."Index Code" := IndexCode_P;
            PlanDocLevel_LT."Index Description" := IndexDescription_P;
            PlanDocLevel_LT."Timestamp Planning Values" := DateTime_P;
            PlanDocLevel_LT."Timestamp Reference Values" := DateTime_P;
            PlanDocLevel_LT."Index Table No." := IndexTableNo_P;
            PlanDocLevel_LT.Insert();
            RR1_L.Open(Database::"BET FN Planning Document Level");
            RR1_L.GetTable(PlanDocLevel_LT);
            RR2_L.Open(Database::"BET FN Planning Document Level");
            RR2_L.GetTable(ParentPlanDocLevel_LT);
            FieldNoVar_L := 1010;
            FR1_L := RR1_L.Field(FieldNoVar_L);
            FR2_L := RR2_L.Field(FieldNoVar_L);
            while Format(FR2_L.Value()) <> '' do begin
                FR1_L.Value := FR2_L.Value();
                FR1_L := RR1_L.Field(FieldNoVar_L + 1);
                FR2_L := RR2_L.Field(FieldNoVar_L + 1);
                FR1_L.Value := FR2_L.Value();
                FieldNoVar_L := FieldNoVar_L + 10;
                FR1_L := RR1_L.Field(FieldNoVar_L);
                FR2_L := RR2_L.Field(FieldNoVar_L);
            end;
            FR1_L := RR1_L.Field(FieldNoVar_L);
            FR1_L.Value := IndexCode_P;
            FR1_L := RR1_L.Field(FieldNoVar_L + 1);
            FR1_L.Value := IndexDescription_P;
            RR1_L.Modify();
            RR1_L.Close();
            RR2_L.Close();
        end;

        PlanDocLevel_LT.Get(PlanDocLevel_LT."Planning Document No.", PlanDocLevel_LT."Planning Document Level Index");
        CheckPathEnd(PlanDocLevel_LT);
        PlanDocLevel_LT.Modify();
        CheckPathEnd(ParentPlanDocLevel_LT);
        ParentPlanDocLevel_LT.Modify();
        PlanDocLevel_LT.Get(PlanDocLevel_LT."Planning Document No.", PlanDocLevel_LT."Planning Document Level Index");
        PlanDocLevel_LT."No. of Source-Records" := 0;
        PlanDocLevel_LT."No. of Records" := 0;
        PlanDocLevel_LT.Modify();

        CreateBufferNew(DocNo_P, Level_P);
        UpdateNoOfRecords(PlanDocLevel_LT);
    end;

    /// <summary>
    /// CheckPathEnd.
    /// </summary>
    /// <param name="PlanDocLevel_RT">VAR Record "BET FN Planning Document Level".</param>
    procedure CheckPathEnd(var PlanDocLevel_RT: Record "BET FN Planning Document Level")
    var
        PlanDocLevel_LT: Record "BET FN Planning Document Level";
    begin
        PlanDocLevel_LT.Reset();
        PlanDocLevel_LT.SetRange("Planning Document No.", PlanDocLevel_RT."Planning Document No.");
        PlanDocLevel_LT.SetRange("Planning Document Level Index", PlanDocLevel_RT."Planning Document Level Index" + 1);
        if PlanDocLevel_LT.IsEmpty() then
            PlanDocLevel_RT."Path End" := true
        else
            PlanDocLevel_RT."Path End" := false;
    end;

    /// <summary>
    /// DeleteLevelLine.
    /// </summary>
    /// <param name="PlanDocLevel_PT">Record "BET FN Planning Document Level".</param>
    procedure DeleteLevelLine(PlanDocLevel_PT: Record "BET FN Planning Document Level")
    var
        LevelBuffer_LT: Record "BET FN Planning Doc Lvl Buf";
        PlanDoc_LT: Record "BET FN Planning Document";
        PlanDocLevel_LT: Record "BET FN Planning Document Level";
        ConfirmManagement: Codeunit "Confirm Management";
        DeleteLevelQst: Label 'Really delete level %1 ?', Comment = '%1';
        DeleteLowestLevelFirstErr: Label 'Delete lowest level first.';
        LevelChangeNotAllowedErr: Label 'Planning document already created.\Changing levels is not allowed.';
        LevelZeroCannotBeDeletedErr: Label 'Level 0 can not be deleted.';
    begin
        if PlanDoc_LT.Get(PlanDocLevel_PT."Planning Document No.") and (PlanDoc_LT."Planning Document Created" = 0DT) then begin
            if not PlanDocLevel_PT."Path End" then
                Error(DeleteLowestLevelFirstErr);

            if PlanDocLevel_PT."Planning Document Level Index" = 0 then
                Error(LevelZeroCannotBeDeletedErr);

            if ConfirmManagement.GetResponse(StrSubstNo(DeleteLevelQst, PlanDocLevel_PT."Index Description"), false) then begin
                PlanDocLevel_PT.Delete(true);

                //### und Einträge in der Puffertabelle löschen:
                LevelBuffer_LT.Reset();
                LevelBuffer_LT.SetRange("Planning Document No.", PlanDocLevel_PT."Planning Document No.");
                LevelBuffer_LT.SetRange("Planning Document Level", PlanDocLevel_PT."Planning Document Level Index");
                LevelBuffer_LT.DeleteAll();
            end;
            if PlanDocLevel_LT.Get(PlanDocLevel_PT."Planning Document No.", PlanDocLevel_PT."Planning Document Level Index" - 1) then begin
                //### Parenttabelle aktualisieren:
                CheckPathEnd(PlanDocLevel_LT);
                PlanDocLevel_LT.Modify();
            end;
        end
        else
            Error(LevelChangeNotAllowedErr);
    end;

    /// <summary>
    /// DeleteInvalidCombinations.
    /// </summary>
    /// <param name="PlanDoc_PT">Record "BET FN Planning Document".</param>
    procedure DeleteInvalidCombinations(PlanDoc_PT: Record "BET FN Planning Document")
    var
        PlanDocLevelBuffer_LT: Record "BET FN Planning Doc Lvl Buf";
        PlanDocLevel_LT: Record "BET FN Planning Document Level";
        PlanDocLevelPathend_LT: Record "BET FN Planning Document Level";
        PlanView_LT: Record "BET FN Planning View";
        PlanViewDelete_LT: Record "BET FN Planning View";
        PlanViewPathend_LT: Record "BET FN Planning View";
        Window_L: Dialog;
        counterA_L: Integer;
        counterB_L: Integer;
        TotalA_L: Integer;
        TotalB_L: Integer;
        DeleteInvalidLinesLbl: Label 'Delete invalid lines\@1@@@@@@@@@@@@@@@@\@2@@@@@@@@@@@@@@@@';
    begin
        //### 070814
        Window_L.Open(DeleteInvalidLinesLbl);

        PlanDocLevel_LT.Reset();
        PlanDocLevel_LT.SetRange("Planning Document No.", PlanDoc_PT."No.");
        PlanDocLevel_LT.SetFilter("Planning Document Level Index", '<>%1', 0);    // alle außer der Gesamtebene!
        PlanDocLevel_LT.SetRange("Path End", false);
        TotalA_L := PlanDocLevel_LT.Count();
        counterA_L := 0;

        PlanDocLevelPathend_LT.Reset();
        PlanDocLevelPathend_LT.SetRange("Planning Document No.", PlanDoc_PT."No.");
        PlanDocLevelPathend_LT.SetRange("Path End", true);
        PlanDocLevelPathend_LT.FindLast();

        PlanViewPathend_LT.Reset();
        PlanViewPathend_LT.SetRange("Planning Document No.", PlanDocLevelPathend_LT."Planning Document No.");
        PlanViewPathend_LT.SetRange("Planning Document Level", PlanDocLevelPathend_LT."Planning Document Level Index");

        if PlanDocLevel_LT.FindSet() then
            repeat
                Window_L.Update(1, Round(counterA_L / TotalA_L * 9999, 1));
                Window_L.Update(2, 0);
                counterA_L += 1;

                PlanView_LT.Reset();
                PlanView_LT.SetCurrentKey("Planning Document No.", "Planning Document Level", "Index 1", "Index 2", "Index 3", "Index 4", "Index 5", "Index 6");
                PlanView_LT.SetRange("Planning Document No.", PlanDocLevel_LT."Planning Document No.");
                PlanView_LT.SetRange("Planning Document Level", PlanDocLevel_LT."Planning Document Level Index");
                PlanView_LT.SetRange(Date, 0D);
                TotalB_L := PlanView_LT.Count();
                counterB_L := 0;

                if PlanView_LT.FindSet() then
                    repeat
                        Window_L.Update(2, Round(counterB_L / TotalB_L * 9999, 1));
                        counterB_L += 1;

                        PlanViewPathend_LT.SetRange("Index 1");
                        PlanViewPathend_LT.SetRange("Index 2");
                        PlanViewPathend_LT.SetRange("Index 3");
                        PlanViewPathend_LT.SetRange("Index 4");
                        PlanViewPathend_LT.SetRange("Index 5");
                        PlanViewPathend_LT.SetRange("Index 6");

                        if PlanView_LT."Index 1" <> '' then
                            PlanViewPathend_LT.SetRange("Index 1", PlanView_LT."Index 1");
                        if PlanView_LT."Index 2" <> '' then
                            PlanViewPathend_LT.SetRange("Index 2", PlanView_LT."Index 2");
                        if PlanView_LT."Index 3" <> '' then
                            PlanViewPathend_LT.SetRange("Index 3", PlanView_LT."Index 3");
                        if PlanView_LT."Index 4" <> '' then
                            PlanViewPathend_LT.SetRange("Index 4", PlanView_LT."Index 4");
                        if PlanView_LT."Index 5" <> '' then
                            PlanViewPathend_LT.SetRange("Index 5", PlanView_LT."Index 5");
                        if PlanView_LT."Index 6" <> '' then
                            PlanViewPathend_LT.SetRange("Index 6", PlanView_LT."Index 6");

                        if PlanViewPathend_LT.IsEmpty() then begin   //### ungültige Zeile gefunden (z.B. HWG ohne WG)
                                                                     //### Zeile und alle zugehörigen Datumszeilen löschen:
                            PlanViewDelete_LT.Reset();
                            PlanViewDelete_LT.SetRange("Planning Document No.", PlanView_LT."Planning Document No.");
                            PlanViewDelete_LT.SetRange("Planning Document Level", PlanView_LT."Planning Document Level");
                            PlanViewDelete_LT.SetRange("Index 1", PlanView_LT."Index 1");
                            PlanViewDelete_LT.SetRange("Index 2", PlanView_LT."Index 2");
                            PlanViewDelete_LT.SetRange("Index 3", PlanView_LT."Index 3");
                            PlanViewDelete_LT.SetRange("Index 4", PlanView_LT."Index 4");
                            PlanViewDelete_LT.SetRange("Index 5", PlanView_LT."Index 5");
                            PlanViewDelete_LT.SetRange("Index 6", PlanView_LT."Index 6");
                            PlanViewDelete_LT.DeleteAll();

                            //### noch das entsprechende Bufferelement auf inaktiv setzen:
                            PlanDocLevelBuffer_LT.Reset();
                            PlanDocLevelBuffer_LT.SetRange("Planning Document No.", PlanView_LT."Planning Document No.");
                            PlanDocLevelBuffer_LT.SetRange("Planning Document Level", PlanView_LT."Planning Document Level");
                            case PlanView_LT."Planning Document Level" of
                                1:
                                    PlanDocLevelBuffer_LT.SetRange("Index Code", PlanView_LT."Index 1");
                                2:
                                    PlanDocLevelBuffer_LT.SetRange("Index Code", PlanView_LT."Index 2");
                                3:
                                    PlanDocLevelBuffer_LT.SetRange("Index Code", PlanView_LT."Index 3");
                                4:
                                    PlanDocLevelBuffer_LT.SetRange("Index Code", PlanView_LT."Index 4");
                                5:
                                    PlanDocLevelBuffer_LT.SetRange("Index Code", PlanView_LT."Index 5");
                                6:
                                    PlanDocLevelBuffer_LT.SetRange("Index Code", PlanView_LT."Index 6");
                            end;

                            if PlanDocLevelBuffer_LT.FindFirst() then
                                if PlanDocLevelBuffer_LT.Active then begin
                                    PlanDocLevelBuffer_LT.Active := false;
                                    PlanDocLevelBuffer_LT.Modify();
                                end;
                        end;
                    until PlanView_LT.Next() = 0;
            until PlanDocLevel_LT.Next() = 0;

        Window_L.Close();
    end;

    /// <summary>
    /// CountLinesPerLevel.
    /// </summary>
    /// <param name="PlanDoc_PT">Record "BET FN Planning Document".</param>
    procedure CountLinesPerLevel(PlanDoc_PT: Record "BET FN Planning Document")
    var
        PlanDocLevelBuffer_LT: Record "BET FN Planning Doc Lvl Buf";
        PlanDocLevel_LT: Record "BET FN Planning Document Level";
        PlanView_LT: Record "BET FN Planning View";
    begin
        PlanDocLevel_LT.Reset();
        PlanDocLevel_LT.SetRange("Planning Document No.", PlanDoc_PT."No.");
        if PlanDocLevel_LT.FindSet(true) then
            repeat
                PlanView_LT.Reset();
                PlanView_LT.SetRange("Planning Document No.", PlanDocLevel_LT."Planning Document No.");
                PlanView_LT.SetRange("Planning Document Level", PlanDocLevel_LT."Planning Document Level Index");
                PlanView_LT.SetRange(Date, 0D);
                PlanDocLevel_LT."No. of Records" := PlanView_LT.Count();    //### Anzahl Datensätze ohne Datum

                PlanView_LT.SetFilter(Date, '<>%1', 0D);
                PlanDocLevel_LT."No. of Records on Date Level" := PlanView_LT.Count();  //### Anzahl Datensätze mit Datum

                PlanDocLevelBuffer_LT.Reset();
                PlanDocLevelBuffer_LT.SetRange("Planning Document No.", PlanDocLevel_LT."Planning Document No.");
                PlanDocLevelBuffer_LT.SetRange("Planning Document Level", PlanDocLevel_LT."Planning Document Level Index");
                PlanDocLevelBuffer_LT.SetRange(Active, true);
                PlanDocLevel_LT."No. of Source-Records" := PlanDocLevelBuffer_LT.Count();     //### Pufferzeilen

                PlanDocLevel_LT.Modify();
            until PlanDocLevel_LT.Next() = 0;
    end;

    /// <summary>
    /// CountBufferPerLevel.
    /// </summary>
    /// <param name="DocNo_P">Code[20].</param>
    procedure CountBufferPerLevel(DocNo_P: Code[20])
    var
        LevelBuffer_LT: Record "BET FN Planning Doc Lvl Buf";
        PlanDocLevel_LT: Record "BET FN Planning Document Level";
    begin
        //### 080820 : Anzahl der aktiven Elemente pro Ebene ermitteln
        PlanDocLevel_LT.Reset();
        PlanDocLevel_LT.SetRange("Planning Document No.", DocNo_P);
        if PlanDocLevel_LT.FindSet(true) then
            repeat
                LevelBuffer_LT.Reset();
                LevelBuffer_LT.SetRange("Planning Document No.", PlanDocLevel_LT."Planning Document No.");
                LevelBuffer_LT.SetRange("Planning Document Level", PlanDocLevel_LT."Planning Document Level Index");
                LevelBuffer_LT.SetRange(Active, true);
                PlanDocLevel_LT."No. of Source-Records" := LevelBuffer_LT.Count();
                PlanDocLevel_LT.Modify();
            until PlanDocLevel_LT.Next() = 0;
    end;

    /// <summary>
    /// InsertFirstView.
    /// </summary>
    /// <param name="PlanDocLevel_PT">Record "BET FN Planning Document Level".</param>
    /// <param name="DateVar_P">Date.</param>
    /// <param name="firstmonth_P">Boolean.</param>
    /// <param name="LastDatePlan_P">Date.</param>
    procedure InsertFirstView(PlanDocLevel_PT: Record "BET FN Planning Document Level"; DateVar_P: Date; firstmonth_P: Boolean; LastDatePlan_P: Date)
    var
        PlanDoc_LT: Record "BET FN Planning Document";
        PlanView1_LT: Record "BET FN Planning View";
    begin
        PlanDoc_LT.Get(PlanDocLevel_PT."Planning Document No.");
        PlanView1_LT.Reset();
        PlanView1_LT.SetCurrentKey("Planning Document No.", "Planning Document Level", "Index 1", "Index 2", "Index 3", "Index 4", "Index 5", "Index 6", Date);
        PlanView1_LT.SetRange("Planning Document No.", PlanDocLevel_PT."Planning Document No.");
        PlanView1_LT.SetRange("Planning Document Level", PlanDocLevel_PT."Planning Document Level Index");
        PlanView1_LT.SetRange("Index 1", '');
        PlanView1_LT.SetRange("Index 2", '');
        PlanView1_LT.SetRange("Index 3", '');
        PlanView1_LT.SetRange("Index 4", '');
        PlanView1_LT.SetRange("Index 5", '');
        PlanView1_LT.SetRange("Index 6", '');
        PlanView1_LT.SetRange(Date, DateVar_P);
        if PlanView1_LT.IsEmpty() then begin
            PlanView1_LT.Init();
            PlanView1_LT."Planning Document No." := PlanDocLevel_PT."Planning Document No.";
            PlanView1_LT."Planning Document Level" := PlanDocLevel_PT."Planning Document Level Index";
            PlanView1_LT.Date := DateVar_P;
            PlanView1_LT."Line Type" := PlanView1_LT."Line Type"::Plan;
            PlanView1_LT.Fixed := false;
            PlanView1_LT.Changed := false;
            if firstmonth_P then
                PlanView1_LT."First Month" := true;

            if PlanView1_LT.Date = LastDatePlan_P then
                PlanView1_LT."Last Month" := true;

            PlanView1_LT."Timestamp Planning Values" := PlanDoc_LT."Timestamp Planning Values";
            PlanView1_LT.Insert();
        end;
    end;

    /// <summary>
    /// InsertAdditionalView.
    /// </summary>
    /// <param name="PlanView_PT">Record "BET FN Planning View".</param>
    /// <param name="PlanDocLevelBuffer_PT">Record "BET FN Planning Doc Lvl Buf".</param>
    /// <param name="DateVar_P">Date.</param>
    /// <param name="firstmonth_P">Boolean.</param>
    /// <param name="LastDatePlan_P">Date.</param>
    procedure InsertAdditionalView(PlanView_PT: Record "BET FN Planning View"; PlanDocLevelBuffer_PT: Record "BET FN Planning Doc Lvl Buf"; DateVar_P: Date; firstmonth_P: Boolean; LastDatePlan_P: Date)
    var
        PlanView_LT: Record "BET FN Planning View";
    begin
        case PlanDocLevelBuffer_PT."Planning Document Level" of
            1:
                begin
                    PlanView_PT."Index 1" := PlanDocLevelBuffer_PT."Index Code";
                    PlanView_PT."Description 1" := PlanDocLevelBuffer_PT."Index Description";
                end;
            2:
                begin
                    PlanView_PT."Index 2" := PlanDocLevelBuffer_PT."Index Code";
                    PlanView_PT."Description 2" := PlanDocLevelBuffer_PT."Index Description";
                end;
            3:
                begin
                    PlanView_PT."Index 3" := PlanDocLevelBuffer_PT."Index Code";
                    PlanView_PT."Description 3" := PlanDocLevelBuffer_PT."Index Description";
                end;
            4:
                begin
                    PlanView_PT."Index 4" := PlanDocLevelBuffer_PT."Index Code";
                    PlanView_PT."Description 4" := PlanDocLevelBuffer_PT."Index Description";
                end;
            5:
                begin
                    PlanView_PT."Index 5" := PlanDocLevelBuffer_PT."Index Code";
                    PlanView_PT."Description 5" := PlanDocLevelBuffer_PT."Index Description";
                end;
            6:
                begin
                    PlanView_PT."Index 6" := PlanDocLevelBuffer_PT."Index Code";
                    PlanView_PT."Description 6" := PlanDocLevelBuffer_PT."Index Description";
                end;
        end;

        PlanView_LT.Reset();
        PlanView_LT.SetCurrentKey("Planning Document No.", "Planning Document Level", "Index 1", "Index 2", "Index 3", "Index 4", "Index 5", "Index 6", Date);
        PlanView_LT.SetRange("Planning Document No.", PlanDocLevelBuffer_PT."Planning Document No.");
        PlanView_LT.SetRange("Planning Document Level", PlanDocLevelBuffer_PT."Planning Document Level");
        PlanView_LT.SetRange(Date, DateVar_P);
        PlanView_LT.SetRange("Index 1", PlanView_PT."Index 1");
        PlanView_LT.SetRange("Index 2", PlanView_PT."Index 2");
        PlanView_LT.SetRange("Index 3", PlanView_PT."Index 3");
        PlanView_LT.SetRange("Index 4", PlanView_PT."Index 4");
        PlanView_LT.SetRange("Index 5", PlanView_PT."Index 5");
        PlanView_LT.SetRange("Index 6", PlanView_PT."Index 6");
        if PlanView_LT.IsEmpty() then begin
            PlanView_LT.Init();
            PlanView_LT := PlanView_PT;
            Clear(PlanView_LT."View Entry No.");
            PlanView_LT."Planning Document Level" := PlanDocLevelBuffer_PT."Planning Document Level";
            PlanView_LT.Date := DateVar_P;
            if firstmonth_P then
                PlanView_LT."First Month" := true
            else
                PlanView_LT."First Month" := false;

            if PlanView_LT.Date = LastDatePlan_P then
                PlanView_LT."Last Month" := true;

            PlanView_LT.Insert();
        end;
    end;

    /// <summary>
    /// InsertIntoPlanningValueCube.
    /// </summary>
    /// <param name="PlanView_PT">Record "BET FN Planning View".</param>
    /// <param name="PlanDocLevelBuffer_PT">Record "BET FN Planning Doc Lvl Buf".</param>
    /// <param name="DateVar_P">Date.</param>
    /// <param name="firstmonth_P">Boolean.</param>
    /// <param name="LastDatePlan_P">Date.</param>
    /// <param name="PlanCubeEntryNo_R">VAR Integer.</param>
    procedure InsertIntoPlanningValueCube(PlanView_PT: Record "BET FN Planning View"; PlanDocLevelBuffer_PT: Record "BET FN Planning Doc Lvl Buf"; DateVar_P: Date; firstmonth_P: Boolean; LastDatePlan_P: Date; var PlanCubeEntryNo_R: Integer)
    var
        PlanDoc_LT: Record "BET FN Planning Document";
        PlanCube_LT: Record "BET FN Planning Value Cube";
    begin
        case PlanDocLevelBuffer_PT."Planning Document Level" of
            //### Sonderfall Gesamtzeile:
            0:
                begin
                    PlanView_PT."Index 1" := '';
                    PlanView_PT."Description 1" := '';
                end;
            1:
                PlanView_PT."Index 1" := PlanDocLevelBuffer_PT."Index Code";
            2:
                PlanView_PT."Index 2" := PlanDocLevelBuffer_PT."Index Code";
            3:
                PlanView_PT."Index 3" := PlanDocLevelBuffer_PT."Index Code";
            4:
                PlanView_PT."Index 4" := PlanDocLevelBuffer_PT."Index Code";
            5:
                PlanView_PT."Index 5" := PlanDocLevelBuffer_PT."Index Code";
            6:
                PlanView_PT."Index 6" := PlanDocLevelBuffer_PT."Index Code";
        end;

        PlanCube_LT.Reset();
        PlanCube_LT.SetCurrentKey("Planning Document No.", Date, "Index 1", "Index 2", "Index 3", "Index 4", "Index 5", "Index 6");
        PlanCube_LT.SetRange("Planning Document No.", PlanDocLevelBuffer_PT."Planning Document No.");
        PlanCube_LT.SetRange("Index 1", PlanView_PT."Index 1");
        PlanCube_LT.SetRange("Index 2", PlanView_PT."Index 2");
        PlanCube_LT.SetRange("Index 3", PlanView_PT."Index 3");
        PlanCube_LT.SetRange("Index 4", PlanView_PT."Index 4");
        PlanCube_LT.SetRange("Index 5", PlanView_PT."Index 5");
        PlanCube_LT.SetRange("Index 6", PlanView_PT."Index 6");
        PlanCube_LT.SetRange(Date, DateVar_P);
        if PlanCube_LT.IsEmpty() then begin
            PlanCube_LT.Reset();
            PlanCube_LT.Init();
            PlanCube_LT.TransferFields(PlanView_PT);
            Clear(PlanCube_LT."Entry No.");
            PlanCube_LT.Date := DateVar_P;
            PlanCube_LT."Time-Stamp" := PlanView_PT."Timestamp Planning Values";
            if firstmonth_P then
                PlanCube_LT."First Month" := true
            else
                PlanCube_LT."First Month" := false;

            if PlanCube_LT.Date = LastDatePlan_P then
                PlanCube_LT."Last Month" := true;

            PlanDoc_LT.Get(PlanView_PT."Planning Document No.");
            PlanCube_LT.Insert();

            PlanCubeEntryNo_R := PlanCube_LT."Entry No.";    //### gleiche Zeilennummer für RefCube verwenden
        end;
    end;

    /// <summary>
    /// InsertIntoReferenceValueCube.
    /// </summary>
    /// <param name="PlanView_PT">Record "BET FN Planning View".</param>
    /// <param name="PlanDocLevelBuffer_PT">Record "BET FN Planning Doc Lvl Buf".</param>
    /// <param name="DateVar_P">Date.</param>
    /// <param name="firstmonth_P">Boolean.</param>
    /// <param name="LastDateRef_P">Date.</param>
    /// <param name="PlanCubeEntryNo_P">Integer.</param>
    procedure InsertIntoReferenceValueCube(PlanView_PT: Record "BET FN Planning View"; PlanDocLevelBuffer_PT: Record "BET FN Planning Doc Lvl Buf"; DateVar_P: Date; firstmonth_P: Boolean; LastDateRef_P: Date; PlanCubeEntryNo_P: Integer)
    var
        RefCube_LT: Record "BET FN Reference Value Cube";
    begin
        case PlanDocLevelBuffer_PT."Planning Document Level" of
            //### Sonderfall Gesamtzeile:
            0:
                begin
                    PlanView_PT."Index 1" := '';
                    PlanView_PT."Description 1" := '';
                end;
            1:
                PlanView_PT."Index 1" := PlanDocLevelBuffer_PT."Index Code";
            2:
                PlanView_PT."Index 2" := PlanDocLevelBuffer_PT."Index Code";
            3:
                PlanView_PT."Index 3" := PlanDocLevelBuffer_PT."Index Code";
            4:
                PlanView_PT."Index 4" := PlanDocLevelBuffer_PT."Index Code";
            5:
                PlanView_PT."Index 5" := PlanDocLevelBuffer_PT."Index Code";
            6:
                PlanView_PT."Index 6" := PlanDocLevelBuffer_PT."Index Code";
        end;

        RefCube_LT.Reset();
        RefCube_LT.SetCurrentKey("Planning Document No.", Date, "Index 1", "Index 2", "Index 3", "Index 4", "Index 5", "Index 6");    //### gleiche Sortierung wie PlanCube!
        RefCube_LT.SetRange("Planning Document No.", PlanView_PT."Planning Document No.");
        RefCube_LT.SetRange("Index 1", PlanView_PT."Index 1");
        RefCube_LT.SetRange("Index 2", PlanView_PT."Index 2");
        RefCube_LT.SetRange("Index 3", PlanView_PT."Index 3");
        RefCube_LT.SetRange("Index 4", PlanView_PT."Index 4");
        RefCube_LT.SetRange("Index 5", PlanView_PT."Index 5");
        RefCube_LT.SetRange("Index 6", PlanView_PT."Index 6");
        RefCube_LT.SetRange(Date, DateVar_P);
        if RefCube_LT.IsEmpty() then begin
            RefCube_LT.Reset();
            RefCube_LT.Init();
            RefCube_LT.TransferFields(PlanView_PT);
            Clear(RefCube_LT."Entry No.");
            RefCube_LT.Date := DateVar_P;
            RefCube_LT."First Month" := firstmonth_P;
            if RefCube_LT.Date = LastDateRef_P then
                RefCube_LT."Last Month" := true;
            RefCube_LT."Entry No." := PlanCubeEntryNo_P;    //### gleiche Zeilennummer wie PlanCube
            RefCube_LT.Insert();
        end;
    end;

    /// <summary>
    /// CheckViewDataValidity.
    /// </summary>
    /// <param name="PlanView_RT">VAR Record "BET FN Planning View".</param>
    procedure CheckViewDataValidity(var PlanView_RT: Record "BET FN Planning View")
    var
        PlanDoc_LT: Record "BET FN Planning Document";
        PlanDocLevel_LT: Record "BET FN Planning Document Level";
        PlanCube_LT: Record "BET FN Planning Value Cube";
        PlanView1_LT: Record "BET FN Planning View";
        PlanView2_LT: Record "BET FN Planning View";
        updatefromdatelevel_L: Boolean;
        dec_var_L: Decimal;
        Window_L: Dialog;
        counter_L: Integer;
        i_L: Integer;
        CheckActualityLbl: Label 'Check actuality\@1@@@@@@@@@@@@@@';
    begin
        PlanView1_LT.Reset();
        PlanView1_LT.SetCurrentKey("Planning Document No.", "Planning Document Level", "To Update (Plan)", Date, "Timestamp Planning Values");

        //### Filter und Daten vom übergebenen Record übernehmen
        PlanView1_LT.CopyFilters(PlanView_RT);

        //### veraltete Viewdaten raussuchen
        PlanDoc_LT.Get(PlanView_RT.GetFilter("Planning Document No."));

        //### Vergleich mit Planwert-Cube
        PlanView1_LT.SetRange("To Update (Plan)", false);
        PlanView1_LT.SetFilter("Timestamp Planning Values", '<%1', PlanDoc_LT."Timestamp Planning Values");

        if not PlanView1_LT.IsEmpty() then begin   //### veraltete Viewdaten gefunden (Gesamtbeleg)
            PlanView1_LT.FindFirst();
            PlanDocLevel_LT.Reset();
            //### befinden sich veraltete Daten in unserer Ebene? (Views mit Datum älter als Ebenendatum)
            if PlanDocLevel_LT.Get(PlanView1_LT."Planning Document No.", PlanView1_LT."Planning Document Level") then begin
                //### Viewdaten älter als Ebene?
                PlanView1_LT.SetFilter("Timestamp Planning Values", '<=%1', PlanDocLevel_LT."Timestamp Planning Values");

                if not PlanView1_LT.IsEmpty() then begin
                    PlanView1_LT.FindFirst();

                    //### jetzt den ältesten Stempel der Viewelemente mit dem jüngsten Stempel
                    //### der gefilterten Cubeelemente vergleichen
                    PlanCube_LT.Reset();
                    PlanCube_LT.SetCurrentKey("Planning Document No.", "Time-Stamp");
                    PlanCube_LT.SetRange("Planning Document No.", PlanDoc_LT."No.");

                    //### jüngstes gefiltertes Cubeelement
                    if not PlanCube_LT.IsEmpty() then begin
                        PlanCube_LT.FindLast();

                        if (PlanView1_LT."Timestamp Planning Values" < PlanCube_LT."Time-Stamp") then begin
                            //### merken, ob aus Datumsebene aktualisiert werden soll
                            if PlanCube_LT.Date <> 0D then
                                updatefromdatelevel_L := true
                            else
                                updatefromdatelevel_L := false;

                            //### jetzt Viewelemente und Cubeelemente vergleichen
                            if PlanView1_LT.FindSet() then begin
                                PlanCube_LT.Reset();
                                PlanCube_LT.SetCurrentKey("Planning Document No.", "Index 1", "Index 2", "Index 3", "Index 4", "Index 5", "Index 6", Date, "Time-Stamp");
                                PlanCube_LT.SetRange("Planning Document No.", PlanView1_LT."Planning Document No.");

                                //### jetzt für alle betroffenen Sätze prüfen, ob die Daten noch aktuell sind
                                Window_L.Open(CheckActualityLbl);
                                i_L := 1;
                                dec_var_L := Round(PlanView1_LT.Count() / 100, 1);
                                Evaluate(counter_L, Format(dec_var_L));
                                if counter_L = 0 then
                                    counter_L := 1;
                                repeat
                                    Window_L.Update(1, Round(i_L / counter_L * 9999, 1));

                                    //### zugehörigen Cube-Datensatz holen
                                    if PlanView1_LT."Index 1" <> '' then
                                        PlanCube_LT.SetRange("Index 1", PlanView1_LT."Index 1");
                                    if PlanView1_LT."Index 2" <> '' then
                                        PlanCube_LT.SetRange("Index 2", PlanView1_LT."Index 2");
                                    if PlanView1_LT."Index 3" <> '' then
                                        PlanCube_LT.SetRange("Index 3", PlanView1_LT."Index 3");
                                    if PlanView1_LT."Index 4" <> '' then
                                        PlanCube_LT.SetRange("Index 4", PlanView1_LT."Index 4");
                                    if PlanView1_LT."Index 5" <> '' then
                                        PlanCube_LT.SetRange("Index 5", PlanView1_LT."Index 5");
                                    if PlanView1_LT."Index 6" <> '' then
                                        PlanCube_LT.SetRange("Index 6", PlanView1_LT."Index 6");

                                    //### Unterscheidung Datumsebene
                                    if updatefromdatelevel_L then
                                        PlanCube_LT.SetFilter(Date, '<>%1', 0D)
                                    else
                                        PlanCube_LT.SetFilter(Date, Format(PlanView1_LT.Date));

                                    //### hier auf aktualisierte Cubedaten filtern
                                    PlanCube_LT.SetFilter("Time-Stamp", '>%1', PlanView1_LT."Timestamp Planning Values");

                                    //### alle Datensätze des Views mit denen des Cubes vergleichen...
                                    //### wenn Daten gleich, dann aktualisiere View-Timestamp mit Beleg-Timestamp,
                                    //### sonst kennzeichne View als unaktuell (To Update = true)
                                    PlanView2_LT.ReadIsolation := PlanView2_LT.ReadIsolation::UpdLock;
                                    PlanView2_LT.Get(PlanView1_LT."View Entry No.");

                                    if not PlanCube_LT.IsEmpty() then    //### Cube ist aktueller als View: View markieren
                                        PlanView2_LT."To Update (Plan)" := true
                                    else
                                        PlanView2_LT."Timestamp Planning Values" := PlanDoc_LT."Timestamp Planning Values";

                                    PlanView2_LT.Modify();

                                    i_L += 1;
                                until PlanView1_LT.Next() = 0;
                                Window_L.Close();
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;

    /// <summary>
    /// UpdateViewData.
    /// </summary>
    /// <param name="PlanView_RT">VAR Record "BET FN Planning View".</param>
    procedure UpdateViewData(var PlanView_RT: Record "BET FN Planning View")
    var
        PlanDoc_LT: Record "BET FN Planning Document";
        PlanDocLevel_LT: Record "BET FN Planning Document Level";
        PlanLayoutTemplate_LT: Record "BET FN Planning Layout Tmplt";
        PlanStat_LT: Record "BET FN Planning Statistic";
        PlanView1_LT: Record "BET FN Planning View";
        PlanView2_LT: Record "BET FN Planning View";
        CalcPlanValues_LC: Codeunit "BET FN Calculate Planning Vals";
        Window_L: Dialog;
        i_L: Integer;
        total_L: Integer;
        VertLevel_L: Integer;
        UpdateValuesLbl: Label 'Update values\@1@@@@@@@@@@@@@@';
    begin
        //### Aktualisierung nur für Planungsbelege

        PlanDoc_LT.Get(PlanView_RT.GetFilter("Planning Document No."));

        Evaluate(VertLevel_L, PlanView_RT.GetFilter("Planning Document Level"));

        PlanStat_LT.Get();

        //### Aktualisierung der View-Planwerte ("To Update (Plan)")
        PlanView1_LT.Reset();
        PlanView1_LT.SetCurrentKey("Planning Document No.", "Planning Document Level", "To Update (Plan)", Date, "Timestamp Planning Values");
        PlanView1_LT.SetRange("Planning Document No.", PlanDoc_LT."No.");
        PlanView1_LT.SetRange("Planning Document Level", VertLevel_L);
        PlanView1_LT.SetRange("To Update (Plan)", true);

        //### alle Elemente der aktuellen Ebene filtern, welche aktualisiert werden sollen
        if PlanView1_LT.FindSet() then begin
            Window_L.Open(UpdateValuesLbl);
            i_L := 1;
            total_L := PlanView1_LT.Count();

            PlanDocLevel_LT.Reset();
            PlanDocLevel_LT.Get(PlanView1_LT."Planning Document No.", PlanView1_LT."Planning Document Level");

            // wenn Umsatz-Anteil % angezeigt wird, dann diesen auch berechnen:
            if PlanDocLevel_LT."Layout Template" <> '' then
                PlanLayoutTemplate_LT.Get(PlanDocLevel_LT."Layout Template")
            else
                if PlanDoc_LT."Layout Template" <> '' then
                    PlanLayoutTemplate_LT.Get(PlanDoc_LT."Layout Template")
                else
                    PlanLayoutTemplate_LT.Init();

            repeat
                Window_L.Update(1, Round(i_L / total_L * 9999, 1));
                i_L += 1;

                PlanStat_LT.Reset();
                PlanStat_LT.SetRange("Planning Document No.", PlanView1_LT."Planning Document No.");

                if PlanView1_LT."Index 1" <> '' then
                    PlanStat_LT.SetRange("Index 1", PlanView1_LT."Index 1");
                if PlanView1_LT."Index 2" <> '' then
                    PlanStat_LT.SetRange("Index 2", PlanView1_LT."Index 2");
                if PlanView1_LT."Index 3" <> '' then
                    PlanStat_LT.SetRange("Index 3", PlanView1_LT."Index 3");
                if PlanView1_LT."Index 4" <> '' then
                    PlanStat_LT.SetRange("Index 4", PlanView1_LT."Index 4");
                if PlanView1_LT."Index 5" <> '' then
                    PlanStat_LT.SetRange("Index 5", PlanView1_LT."Index 5");
                if PlanView1_LT."Index 6" <> '' then
                    PlanStat_LT.SetRange("Index 6", PlanView1_LT."Index 6");

                //### Datumsebene oder nicht
                if PlanDocLevel_LT."Activate Date Level" then begin
                    if PlanView1_LT.Date <> 0D then
                        PlanStat_LT.SetRange(DateFilter, PlanView1_LT.Date)
                    else
                        PlanStat_LT.SetFilter(DateFilter, '<>%1', 0D);
                end
                else
                    PlanStat_LT.SetRange(DateFilter, 0D);

                PlanView2_LT.ReadIsolation := PlanView2_LT.ReadIsolation::UpdLock;
                PlanView2_LT.Get(PlanView1_LT."View Entry No.");

                PlanStat_LT.CalcFields("Plan VK Umsatz"
                                      , "Plan VK Rabatt"
                                      , "Plan VK Anfangsbestand"
                                      , "Plan VK Abschrift"
                                      , "Plan VK WE (Limit)"
                                      , "Plan Menge Umsatz"
                                      , "Plan Menge Anfangsbestand"
                                      , "Plan Menge WE (Limit)"
                                      , "Plan EK Umsatz"
                                      , "Plan EK Anfangsbestand"
                                      , "Plan EK WE (Limit)"
                                      , "Plan EK Limit 1"
                                      , "Plan EK Limit 2"
                                      , "Plan EK Limit 3"
                                      , "Plan EK Limit 4"
                                      , "Plan EK Limit 5"
                                      , "Plan VK Endbestand"
                                      , "Plan EK Endbestand"
                                      , "Plan Menge Endbestand"
                                      );
                PlanView2_LT."Plan Sales Amount" := PlanStat_LT."Plan VK Umsatz";
                PlanView2_LT."Plan Sales Discount" := PlanStat_LT."Plan VK Rabatt";
                PlanView2_LT."Plan Sales Init. Inv." := PlanStat_LT."Plan VK Anfangsbestand";
                PlanView2_LT."Plan Gross Sales Pr. Reduction" := PlanStat_LT."Plan VK Abschrift";
                PlanView2_LT."Plan Sales Am. Purchase" := PlanStat_LT."Plan VK WE (Limit)";
                PlanView2_LT."Plan Qty. Sale" := PlanStat_LT."Plan Menge Umsatz";
                PlanView2_LT."Plan Qty. Init. Inv." := PlanStat_LT."Plan Menge Anfangsbestand";
                PlanView2_LT."Plan Qty. Purchase" := PlanStat_LT."Plan Menge WE (Limit)";
                PlanView2_LT."Plan Cost of Sales" := PlanStat_LT."Plan EK Umsatz";
                PlanView2_LT."Plan Cost Init. Inv." := PlanStat_LT."Plan EK Anfangsbestand";
                PlanView2_LT."Plan Cost Am. Purchase" := PlanStat_LT."Plan EK WE (Limit)";
                PlanView2_LT."Plan Cost Am. Purch. 1" := PlanStat_LT."Plan EK Limit 1";
                PlanView2_LT."Plan Cost Am. Purch. 2" := PlanStat_LT."Plan EK Limit 2";
                PlanView2_LT."Plan Cost Am. Purch. 3" := PlanStat_LT."Plan EK Limit 3";
                PlanView2_LT."Plan Cost Am. Purch. 4" := PlanStat_LT."Plan EK Limit 4";
                PlanView2_LT."Plan Cost Am. Purch. 5" := PlanStat_LT."Plan EK Limit 5";

                //### Anfangsbestände für Nichtdatumsebenen berechnen, wenn Datum im Cube aktiviert ist
                if (PlanView2_LT.Date = 0D) and PlanDocLevel_LT."Activate Date Level" then begin
                    PlanStat_LT.SetRange(DateFilter, PlanDoc_LT."Start Date");
                    PlanStat_LT.CalcFields("Plan VK Anfangsbestand", "Plan Menge Anfangsbestand", "Plan EK Anfangsbestand");
                    PlanView2_LT."Plan Sales Init. Inv." := PlanStat_LT."Plan VK Anfangsbestand";
                    PlanView2_LT."Plan Qty. Init. Inv." := PlanStat_LT."Plan Menge Anfangsbestand";
                    PlanView2_LT."Plan Cost Init. Inv." := PlanStat_LT."Plan EK Anfangsbestand";
                    PlanView2_LT."Plan Sales Closing Inv." := PlanView2_LT."Plan Sales Init. Inv." + PlanStat_LT."Plan VK Endbestand";
                    PlanView2_LT."Plan Qty. Closing Inv." := PlanView2_LT."Plan Qty. Init. Inv." + PlanStat_LT."Plan Menge Endbestand";
                    PlanView2_LT."Plan Cost Closing Inv." := PlanView2_LT."Plan Cost Init. Inv." + PlanStat_LT."Plan EK Endbestand";
                end;



                //### Endbestand des ersten Monats berechnen, damit bestandsberechnung in weiteren Monaten stattfinden kann:
                //if (PlanView2_LT.Date = PlanDoc_LT."Start Date") then
                //    CalcPlanValues_LC.CalcClosingInventory(PlanView2_LT);



                //### Zeitstempel aktualisieren und Markierung entfernen
                PlanView2_LT."Timestamp Planning Values" := PlanDoc_LT."Timestamp Planning Values";
                PlanView2_LT."To Update (Plan)" := false;
                PlanView2_LT.Changed := false;

                CalcPlanValues_LC.CalcLinePercentage(PlanView2_LT, PlanDoc_LT, true);

                CalcPlanValues_LC.CalcSalesAmountDiffToRef(PlanView2_LT);

                CalcPlanValues_LC.CalcRealizedMargin(PlanView2_LT, PlanDoc_LT);
                CalcPlanValues_LC.CalcWhsRcptMargin(PlanView2_LT, PlanDoc_LT);
                CalcPlanValues_LC.GetLimitPercentageFromPurchValue(PlanView2_LT);

                PlanView2_LT.Modify();
            until PlanView1_LT.Next() = 0;

            CalcPlanValues_LC.UpdatePercentages(PlanView1_LT, PlanDoc_LT);          // %-Anteile neu berechnen

            Window_L.Close();

            //### noch den Zeitstempel in die Ebene eintragen
            if PlanDocLevel_LT.Get(PlanView1_LT."Planning Document No.", PlanView1_LT."Planning Document Level") then begin
                PlanDocLevel_LT."Timestamp Planning Values" := CreateDateTime(WorkDate(), Time());
                PlanDocLevel_LT.Modify();
            end;
        end;
    end;

    /// <summary>
    /// ExistUnsavedLines.
    /// </summary>
    /// <param name="DocNo_P">Code[20].</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure ExistUnsavedLines(DocNo_P: Code[20]): Boolean
    var
        PlanView_LT: Record "BET FN Planning View";
    begin
        //### wenn nicht gespeicherte Views existieren, dann Warnmeldung bringen!
        PlanView_LT.Reset();
        PlanView_LT.SetRange("Planning Document No.", DocNo_P);
        PlanView_LT.SetRange(Changed, true);
        exit(not PlanView_LT.IsEmpty());
    end;

    /// <summary>
    /// ShowUnsavedLines.
    /// </summary>
    /// <param name="DocNo_P">Code[20].</param>
    procedure ShowUnsavedLines(DocNo_P: Code[20])
    var
        PlanDoc_LT: Record "BET FN Planning Document";
        PlanDocLevel_LT: Record "BET FN Planning Document Level";
        PlanView_LT: Record "BET FN Planning View";
        Window_L: Dialog;
        selection_L: Integer;
        SearchUnsavedLinesLbl: Label 'Search for unsaved lines...';
        StrMenuText_L: Text[1024];
    begin
        PlanDoc_LT.Get(DocNo_P);

        //### vor dem Exportieren des Belegs müssen nochmal alle Ebenen nach nicht gespeicherten
        //### Zeilen durchsucht werden. Wird eine gefunden, dann Nutzer informieren und abbrechen
        Window_L.Open(SearchUnsavedLinesLbl);
        PlanDocLevel_LT.Reset();
        PlanDocLevel_LT.SetRange("Planning Document No.", DocNo_P);
        PlanView_LT.Reset();
        PlanView_LT.SetCurrentKey("Planning Document No.", "Planning Document Level", "Timestamp Planning Values", Changed);
        PlanView_LT.SetRange("Planning Document No.", DocNo_P);
        PlanView_LT.SetRange(Changed, true);
        StrMenuText_L := '';

        //### wenn Views existieren, die neuer sind als der letzte Cubeeintrag, dann Ebene merken
        //strmenu bauen und nutzer fragen:
        //es wurden ungespeicherte zeilen gefunden, dahin wechseln?
        //in welche ebene ? --> strmenu
        if PlanDocLevel_LT.FindSet() then
            repeat
                PlanView_LT.SetRange("Planning Document Level", PlanDocLevel_LT."Planning Document Level Index");
                if not PlanView_LT.IsEmpty() then
                    //### StrMenu bauen:
                    StrMenuText_L += PlanDocLevel_LT."Index Code" + ',';
            until PlanDocLevel_LT.Next() = 0;
        Window_L.Close();
        if StrMenuText_L <> '' then begin
            StrMenuText_L := DelChr(StrMenuText_L, '>', ',');
            if StrPos(StrMenuText_L, ',') <> 0 then begin   // mehr als eine Unterebene
                selection_L := StrMenu(StrMenuText_L, 1);
                if selection_L = 0 then     // bei 'Abbrechen' Ebene nicht wechseln
                    exit
                else begin
                    while selection_L > 1 do begin
                        StrMenuText_L := CopyStr(CopyStr(StrMenuText_L, StrPos(StrMenuText_L, ',') + 1), 1, MaxStrLen(StrMenuText_L));
                        selection_L -= 1;
                    end;
                    if StrPos(StrMenuText_L, ',') <> 0 then
                        StrMenuText_L := CopyStr(PadStr(StrMenuText_L, StrPos(StrMenuText_L, ',') - 1), 1, MaxStrLen(StrMenuText_L));
                end;
            end;
            PlanDocLevel_LT.Reset();
            PlanDocLevel_LT.SetRange("Planning Document No.", DocNo_P);
            PlanDocLevel_LT.SetRange("Index Code", StrMenuText_L);
            if PlanDocLevel_LT.FindFirst() then begin
                PlanView_LT.Reset();
                PlanView_LT.SetCurrentKey("Planning Document No.", "Planning Document Level", "Index 1", "Index 2", "Index 3", "Index 4", "Index 5", "Index 6", Date);
                PlanView_LT.SetRange("Planning Document No.", PlanDocLevel_LT."Planning Document No.");
                PlanView_LT.SetRange("Planning Document Level", PlanDocLevel_LT."Planning Document Level Index");
                Page.Run(Page::"BET FN Planning View", PlanView_LT);
            end;
        end;
    end;

    /// <summary>
    /// UpdateDescriptions.
    /// </summary>
    /// <param name="DocNo_P">Code[20].</param>
    procedure UpdateDescriptions(DocNo_P: Code[20])
    var
        LevelBuffer_LT: Record "BET FN Planning Doc Lvl Buf";
        PlanDocLevel_LT: Record "BET FN Planning Document Level";
        PlanLevel_LT: Record "BET FN Planning Level";
        PlanView_LT: Record "BET FN Planning View";
        RecRef_L: RecordRef;
        FieldRef_L: FieldRef;
        Window_L: Dialog;
        i_L: Integer;
        total_L: Integer;
        UpdateDescriptionsLbl: Label 'Update descriptions\@1@@@@@@@@@@@@@@@@@@@@@';
    begin
        i_L := 0;
        PlanDocLevel_LT.Reset();
        PlanDocLevel_LT.SetRange("Planning Document No.", DocNo_P);
        PlanDocLevel_LT.SetFilter("Planning Document Level Index", '>0');
        if PlanDocLevel_LT.FindSet() then begin
            LevelBuffer_LT.Reset();
            LevelBuffer_LT.SetRange("Planning Document No.", DocNo_P);
            total_L := LevelBuffer_LT.Count();
            Window_L.Open(UpdateDescriptionsLbl);
            repeat
                //### Buffertabelle aktualisieren:
                PlanLevel_LT.Get(PlanDocLevel_LT."Index Code");
                LevelBuffer_LT.Reset();
                LevelBuffer_LT.SetRange("Planning Document No.", DocNo_P);
                LevelBuffer_LT.SetRange("Planning Document Level", PlanDocLevel_LT."Planning Document Level Index");
                if LevelBuffer_LT.FindSet(true) then begin
                    RecRef_L.Open(PlanLevel_LT."Index Table No.");
                    repeat
                        Window_L.Update(1, Round(i_L / total_L * 9999, 1));
                        i_L += 1;

                        FieldRef_L := RecRef_L.Field(PlanLevel_LT."Primary Key Field No.");
                        FieldRef_L.SetRange(LevelBuffer_LT."Index Code");
                        if RecRef_L.FindFirst() then begin
                            FieldRef_L := RecRef_L.Field(PlanLevel_LT."Description Field No.");
                            LevelBuffer_LT."Index Description" := Format(FieldRef_L.Value());
                            LevelBuffer_LT.Modify();

                            //### View-Tabelle aktualisieren:
                            PlanView_LT.Reset();
                            PlanView_LT.SetCurrentKey("Planning Document No.", "Planning Document Level", "Index 1", "Index 2", "Index 3", "Index 4", "Index 5", "Index 6", Date);
                            PlanView_LT.SetRange("Planning Document No.", DocNo_P);
                            case LevelBuffer_LT."Planning Document Level" of
                                1:
                                    PlanView_LT.SetRange("Index 1", LevelBuffer_LT."Index Code");
                                2:
                                    PlanView_LT.SetRange("Index 2", LevelBuffer_LT."Index Code");
                                3:
                                    PlanView_LT.SetRange("Index 3", LevelBuffer_LT."Index Code");
                                4:
                                    PlanView_LT.SetRange("Index 4", LevelBuffer_LT."Index Code");
                                5:
                                    PlanView_LT.SetRange("Index 5", LevelBuffer_LT."Index Code");
                                6:
                                    PlanView_LT.SetRange("Index 6", LevelBuffer_LT."Index Code");
                            end;

                            if not PlanView_LT.IsEmpty() then
                                case LevelBuffer_LT."Planning Document Level" of
                                    1:
                                        PlanView_LT.ModifyAll("Description 1", LevelBuffer_LT."Index Description");
                                    2:
                                        PlanView_LT.ModifyAll("Description 2", LevelBuffer_LT."Index Description");
                                    3:
                                        PlanView_LT.ModifyAll("Description 3", LevelBuffer_LT."Index Description");
                                    4:
                                        PlanView_LT.ModifyAll("Description 4", LevelBuffer_LT."Index Description");
                                    5:
                                        PlanView_LT.ModifyAll("Description 5", LevelBuffer_LT."Index Description");
                                    6:
                                        PlanView_LT.ModifyAll("Description 6", LevelBuffer_LT."Index Description");
                                end;
                        end;
                    until LevelBuffer_LT.Next() = 0;
                    RecRef_L.Close();
                end;
            until PlanDocLevel_LT.Next() = 0;
        end;
    end;

    /// <summary>
    /// LevelsAreInHierarchy.
    /// </summary>
    /// <param name="CurrentLevel_PT">Record "BET FN Planning Document Level".</param>
    /// <param name="FoundLevel_PT">Record "BET FN Planning Document Level".</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure LevelsAreInHierarchy(CurrentLevel_PT: Record "BET FN Planning Document Level"; FoundLevel_PT: Record "BET FN Planning Document Level"): Boolean
    var
        PlanLevel_LT: Record "BET FN Planning Level";
        LevelFound_L: Boolean;
    begin
        //### gibt true zurück, wenn beide Ebenen in in der Ebeneneinrichtung eine
        //### Beziehung zueinander haben (bspw. Abt. --> Artikel)

        PlanLevel_LT.Get(FoundLevel_PT."Index Code");

        //### Ebene der zu prüfenden Planungsbelegebene ist keiner anderen Ebene (hierarchisch) zugeordnet:
        if PlanLevel_LT."Assigned to Index" = '' then
            exit(false)
        else begin
            //### Zuordnung zu anderer Ebene besteht, jetzt weiter prüfen
            LevelFound_L := false;
            repeat
                if PlanLevel_LT."Assigned to Index" = CurrentLevel_PT."Index Code" then
                    LevelFound_L := true                       //### zu prüfende Ebene ist mit akt. Ebene verbunden
                else
                    PlanLevel_LT.Get(PlanLevel_LT."Assigned to Index");   //### ansonsten weitersuchen
            until (PlanLevel_LT."Assigned to Index" = '') or LevelFound_L;
            exit(LevelFound_L);
        end;
    end;

    /// <summary>
    /// ResetPlanningDocument.
    /// </summary>
    /// <param name="PlanDoc_PT">Record "BET FN Planning Document".</param>
    procedure ResetPlanningDocument(PlanDoc_PT: Record "BET FN Planning Document")
    var
        DateRef_LT: Record "BET FN Planning Document D Ref";
        OTB_LT: Record "BET FN Planning Entry (DWH)";
        PlanCube_LT: Record "BET FN Planning Value Cube";
        PlanView_LT: Record "BET FN Planning View";
        RefCube_LT: Record "BET FN Reference Value Cube";
        Window_L: Dialog;
        DeletingPlanningDocumentLevelsLbl: Label 'Deleting Planning Document Levels';
    begin
        Window_L.Open(DeletingPlanningDocumentLevelsLbl);

        PlanView_LT.Reset();
        PlanView_LT.SetCurrentKey("Planning Document No.");
        PlanView_LT.SetRange("Planning Document No.", PlanDoc_PT."No.");
        PlanView_LT.DeleteAll();

        PlanCube_LT.Reset();
        PlanCube_LT.SetCurrentKey("Planning Document No.");
        PlanCube_LT.SetRange("Planning Document No.", PlanDoc_PT."No.");
        PlanCube_LT.DeleteAll();

        RefCube_LT.Reset();
        PlanCube_LT.SetCurrentKey("Planning Document No.");
        RefCube_LT.SetRange("Planning Document No.", PlanDoc_PT."No.");
        RefCube_LT.DeleteAll();

        //### freigegebene Planzahlen ebenfalls löschen (da kein Bezug zum Beleg mehr möglich):
        OTB_LT.Reset();
        OTB_LT.SetCurrentKey("Planning Document No.");
        OTB_LT.SetRange("Planning Document No.", PlanDoc_PT."No.");
        OTB_LT.DeleteAll();

        DateRef_LT.Reset();
        DateRef_LT.SetRange("Planning Document No.", PlanDoc_PT."No.");
        DateRef_LT.DeleteAll();

        PlanDoc_PT."Planning Document Created" := 0DT;
        PlanDoc_PT."Timestamp Reference Values" := 0DT;
        PlanDoc_PT."Timestamp Planning Values" := 0DT;
        PlanDoc_PT."Planning Values Exported" := 0DT;
        PlanDoc_PT."Last Alteration" := 0DT;
        PlanDoc_PT."Distribution Type" := PlanDoc_PT."Distribution Type"::Vergleichswerte;
        PlanDoc_PT.Status := PlanDoc_PT.Status::Open;
        PlanDoc_PT.Modify();
        Window_L.Close();
    end;

    /// <summary>
    /// CopyLevelsFromPlanningDocument.
    /// </summary>
    /// <param name="PlanDoc_PT">Record "BET FN Planning Document".</param>
    /// <param name="ShowConfirm_P">Boolean.</param>
    procedure CopyLevelsFromPlanningDocument(PlanDoc_PT: Record "BET FN Planning Document"; ShowConfirm_P: Boolean)
    var
        PlanDocLevelBuffer_LT: Record "BET FN Planning Doc Lvl Buf";
        PlanDocLevelBufferNew_LT: Record "BET FN Planning Doc Lvl Buf";
        PlanDoc_LT: Record "BET FN Planning Document";
        PlanDocLevel2_LT: Record "BET FN Planning Document Level";
        PlanDocLevel_LT: Record "BET FN Planning Document Level";
        PlanDocLevelNew_LT: Record "BET FN Planning Document Level";
        ConfirmManagement: Codeunit "Confirm Management";
        UseLevelSettingsFromOtherPlanningDocumentQst: Label 'Use level settings from other planning document?\Existing levels will be deleted.';
    begin
        //### Kopieren einer Ebenenstruktur in einen anderen Beleg
        if not ConfirmManagement.GetResponse(UseLevelSettingsFromOtherPlanningDocumentQst, false) then
            exit;

        //### dann Beleg zum Kopieren aussuchen und Ebenen kopieren:
        PlanDoc_LT.Reset();
        PlanDoc_LT.SetFilter("No.", '<>%1', PlanDoc_PT."No.");
        if Page.RunModal(Page::"BET FN Planning Documents", PlanDoc_LT) = Action::LookupOK then begin

            //### erstmal die bisher erstellten Ebenen löschen:
            PlanDocLevel_LT.Reset();
            PlanDocLevel_LT.SetRange("Planning Document No.", PlanDoc_PT."No.");
            PlanDocLevel_LT.SetFilter("Planning Document Level Index", '>%1', 0);
            if PlanDocLevel_LT.FindSet(true) then
                repeat
                    PlanDocLevel_LT.Delete(true);
                    //### und bisherige Einträge in der Puffertabelle deaktivieren:
                    PlanDocLevelBuffer_LT.Reset();
                    PlanDocLevelBuffer_LT.SetRange("Planning Document No.", PlanDocLevel_LT."Planning Document No.");
                    PlanDocLevelBuffer_LT.SetRange("Planning Document Level", PlanDocLevel_LT."Planning Document Level Index");
                    PlanDocLevelBuffer_LT.ModifyAll(Active, false);
                until PlanDocLevel_LT.Next() = 0;

            PlanDocLevel_LT.Reset();
            PlanDocLevel_LT.SetRange("Planning Document No.", PlanDoc_LT."No.");    //### ausgewählter Beleg
            PlanDocLevel_LT.SetFilter("Planning Document Level Index", '>%1', 0);
            if PlanDocLevel_LT.FindSet() then
                repeat
                    //### Ebene kopieren:
                    PlanDocLevelNew_LT.Init();
                    PlanDocLevelNew_LT.TransferFields(PlanDocLevel_LT);
                    PlanDocLevelNew_LT."Planning Document No." := PlanDoc_PT."No.";
                    PlanDocLevelNew_LT.Insert();
                    CheckPathEnd(PlanDocLevelNew_LT);
                    PlanDocLevelNew_LT.Modify();

                    PlanDocLevel2_LT.Reset();
                    PlanDocLevel2_LT.SetRange("Planning Document No.", PlanDoc_PT."No.");
                    PlanDocLevel2_LT.SetRange("Planning Document Level Index", PlanDocLevel_LT."Planning Document Level Index" - 1);
                    if PlanDocLevel2_LT.FindSet(true) then begin
                        CheckPathEnd(PlanDocLevel2_LT);
                        PlanDocLevel2_LT.Modify();
                    end;

                    //### Einträge aus der Puffertabelle kopieren:
                    PlanDocLevelBuffer_LT.Reset();
                    PlanDocLevelBuffer_LT.SetRange("Planning Document No.", PlanDocLevel_LT."Planning Document No.");
                    PlanDocLevelBuffer_LT.SetRange("Planning Document Level", PlanDocLevel_LT."Planning Document Level Index");
                    if PlanDocLevelBuffer_LT.FindSet() then
                        repeat
                            PlanDocLevelBufferNew_LT.Init();
                            PlanDocLevelBufferNew_LT.TransferFields(PlanDocLevelBuffer_LT);
                            PlanDocLevelBufferNew_LT."Planning Document No." := PlanDoc_PT."No.";
                            if not PlanDocLevelBufferNew_LT.Insert() then
                                if PlanDocLevelBuffer_LT.Active then begin
                                    //### bereits vorhandene Bufferelemente werden aktiv gesetzt, wenn
                                    PlanDocLevelBufferNew_LT.Reset();
                                    PlanDocLevelBufferNew_LT.SetRange("Planning Document No.", PlanDoc_PT."No.");
                                    PlanDocLevelBufferNew_LT.SetRange("Planning Document Level", PlanDocLevel_LT."Planning Document Level Index");
                                    PlanDocLevelBufferNew_LT.SetRange("Index Code", PlanDocLevelBufferNew_LT."Index Code");
                                    if PlanDocLevelBufferNew_LT.FindSet(true) then begin
                                        PlanDocLevelBufferNew_LT.Active := true;
                                        PlanDocLevelBufferNew_LT.Modify();
                                    end;
                                end;
                        until PlanDocLevelBuffer_LT.Next() = 0;
                until PlanDocLevel_LT.Next() = 0;

            PlanDocLevel_LT.Reset();
            PlanDocLevel_LT.SetRange("Planning Document No.", PlanDoc_PT."No.");
            if PlanDocLevel_LT.FindSet(true) then
                repeat
                    UpdateNoOfRecords(PlanDocLevel_LT);
                until PlanDocLevel_LT.Next() = 0;
        end;
    end;

    /// <summary>
    /// CheckLevelExist.
    /// </summary>
    /// <param name="PlanView_PT">VAR Record "BET FN Planning View".</param>
    /// <param name="Direction_P">Integer.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure CheckLevelExist(var PlanView_PT: Record "BET FN Planning View"; Direction_P: Integer): Boolean
    var
        PlanDocLevel_LT: Record "BET FN Planning Document Level";
        DocNo_L: Code[20];
        Vert_L: Integer;
    begin
        //### prüft, ob es zur übergebenen Ebene eine übergeordnete (1) oder untergeordnete (-1) Ebene gibt

        PlanView_PT.FilterGroup(2);
        Evaluate(DocNo_L, PlanView_PT.GetFilter("Planning Document No."));
        Evaluate(Vert_L, PlanView_PT.GetFilter("Planning Document Level"));
        PlanView_PT.FilterGroup(0);

        PlanDocLevel_LT.Reset();
        PlanDocLevel_LT.SetRange("Planning Document No.", DocNo_L);
        PlanDocLevel_LT.SetRange("Planning Document Level Index", Vert_L - Direction_P);
        exit(not PlanDocLevel_LT.IsEmpty());
    end;

    /// <summary>
    /// CheckPlanDocCreated.
    /// </summary>
    /// <param name="PlanDoc_PT">Record "BET FN Planning Document".</param>
    /// <param name="ShowError_P">Boolean.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure CheckPlanDocCreated(PlanDoc_PT: Record "BET FN Planning Document"; ShowError_P: Boolean): Boolean
    var
        DocumentNotCreatedErr: Label 'Document not yet created.';
    begin
        if PlanDoc_PT."Planning Document Created" = 0DT then begin
            if ShowError_P then
                Error(DocumentNotCreatedErr)
            else
                exit(false);
        end else
            exit(true);
    end;

    /// <summary>
    /// ShowPlanDocLevels.
    /// </summary>
    /// <param name="PlanDoc_PT">Record "BET FN Planning Document".</param>
    procedure ShowPlanDocLevels(PlanDoc_PT: Record "BET FN Planning Document")
    var
        PlanDocLevel_LT: Record "BET FN Planning Document Level";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeShowPlanDocLevels(PlanDoc_PT, IsHandled);
        if not IsHandled then begin
            PlanDocLevel_LT.Reset();
            PlanDocLevel_LT.FilterGroup := 2;
            PlanDocLevel_LT.SetRange("Planning Document No.", PlanDoc_PT."No.");
            PlanDocLevel_LT.FilterGroup := 0;
            Page.RunModal(Page::"BET FN Planning Document Lvls", PlanDocLevel_LT);
        end;
    end;

    /// <summary>
    /// OpenPlanningView.
    /// </summary>
    /// <param name="PlanDoc_PT">Record "BET FN Planning Document".</param>
    procedure OpenPlanningView(PlanDoc_PT: Record "BET FN Planning Document")
    var
        PlanDocLevel_LT: Record "BET FN Planning Document Level";
        PlanView_LT: Record "BET FN Planning View";
        IsHandled: Boolean;
    begin
        OnBeforeOpenPlanningView(PlanDoc_PT, IsHandled);
        if not IsHandled then begin
            CheckPlanDocCreated(PlanDoc_PT, true);

            PlanView_LT.Reset();
            PlanView_LT.SetRange("Planning Document No.", PlanDoc_PT."No.");
            PlanView_LT.SetRange("Planning Document Level", 0);

            PlanDocLevel_LT.Reset();
            PlanDocLevel_LT.SetRange("Planning Document No.", PlanDoc_PT."No.");
            PlanDocLevel_LT.SetRange("Index Code", PlanDoc_PT."Starting Level");
            if PlanDocLevel_LT.FindFirst() then
                PlanView_LT.SetRange("Planning Document Level", PlanDocLevel_LT."Planning Document Level Index");

            IsHandled := false;
            OnBeforeRunPagePlanningView(PlanDoc_PT, PlanView_LT, IsHandled);
            if not IsHandled then
                Page.Run(Page::"BET FN Planning View", PlanView_LT);
        end;
    end;

    /// <summary>
    /// CreatePlanningDocumentLevels.
    /// </summary>
    /// <param name="PlanDoc_PT">Record "BET FN Planning Document".</param>
    /// <param name="ShowConfirm_P">Boolean.</param>
    procedure CreatePlanningDocumentLevels(PlanDoc_PT: Record "BET FN Planning Document"; ShowConfirm_P: Boolean)
    var
        PlanDocLevelBuffer_LT: Record "BET FN Planning Doc Lvl Buf";
        PlanDocDateRef_LT: Record "BET FN Planning Document D Ref";
        ParentLevel_LT: Record "BET FN Planning Document Level";
        PlanDocLevel_LT: Record "BET FN Planning Document Level";
        PlanSetup_LT: Record "BET FN Planning Setup";
        PlanView_LT: Record "BET FN Planning View";
        Date_LT: Record Date;
        DialogMgt_LC: Codeunit "BET FN Dialog Mgt";
        ConfirmManagement: Codeunit "Confirm Management";
        firstmonth_L: Boolean;
        IsHandled: Boolean;
        LastDatePlan_L: Date;
        LastDateRef_L: Date;
        PlanCubeEntryNo_L: Integer;
        TotalLevels_L: Integer;
        CreateLevelsForPlanDocQst: Label 'Create Levels for Planning Document ?';
        CreatingPlanDocLbl: Label 'Creating planning document';
        LevelHasNoActiveElementErr: Label 'Level %1 has no active elements.', Comment = '%1';
        LevelTextLbl: Label 'Level';
        LineTextLbl: Label 'Lines';
        DialogArray_L: array[2] of Text;
    begin
        IsHandled := false;
        OnBeforeCreatePlanningDocumentLevels(PlanDoc_PT, ShowConfirm_P, IsHandled);
        if not IsHandled then begin
            PlanDoc_PT.TestField("Planning Document Created", 0DT);

            if ShowConfirm_P then
                if not ConfirmManagement.GetResponse(CreateLevelsForPlanDocQst, true) then
                    exit;

            //### Datumstabelle anlegen
            CreateRefDateTab(PlanDoc_PT);

            //### Endedatum für PlanCube und RefCube ermitteln:
            PlanDocDateRef_LT.Reset();
            PlanDocDateRef_LT.SetRange("Planning Document No.", PlanDoc_PT."No.");
            Clear(LastDatePlan_L);
            Clear(LastDateRef_L);
            if PlanDocDateRef_LT.FindLast() then begin
                LastDatePlan_L := PlanDocDateRef_LT.Date;
                LastDateRef_L := PlanDocDateRef_LT."Reference Date";
            end;

            PlanDoc_PT.TestField("Start Date");
            PlanDoc_PT.TestField("End Date");
            PlanDoc_PT."Timestamp Planning Values" := CreateDateTime(WorkDate(), Time);
            PlanDoc_PT."Planning Document Created" := CreateDateTime(WorkDate(), Time);
            PlanDoc_PT.Modify();

            PlanDocLevel_LT.Reset();
            PlanDocLevel_LT.SetRange("Planning Document No.", PlanDoc_PT."No.");
            if PlanDocLevel_LT.Find('-') then begin
                PlanDocLevel_LT.ModifyAll("Timestamp Planning Values", PlanDoc_PT."Timestamp Planning Values");
                PlanDocLevel_LT.ModifyAll("Timestamp Reference Values", PlanDoc_PT."Timestamp Reference Values");
            end;

            //### Planungsebenen für Cube und Views ermitteln
            PlanSetup_LT.Get();

            PlanDocLevelBuffer_LT.Reset();
            PlanDocLevelBuffer_LT.SetRange("Planning Document No.", PlanDoc_PT."No.");
            PlanView_LT.Reset();
            PlanView_LT.SetRange("Planning Document No.", PlanDoc_PT."No.");

            TotalLevels_L := PlanDocLevel_LT.Count;

            DialogArray_L[1] := LevelTextLbl;
            DialogArray_L[2] := LineTextLbl;
            DialogMgt_LC.OpenDialogMultiLine(2, DialogArray_L, CreatingPlanDocLbl);

            PlanDocLevel_LT.Reset();
            PlanDocLevel_LT.SetRange("Planning Document No.", PlanDoc_PT."No.");
            if PlanDocLevel_LT.FindSet() then begin
                DialogMgt_LC.UpdateCountArray(1, PlanDocLevel_LT.Count, false);
                repeat
                    PlanDocLevelBuffer_LT.SetRange("Planning Document Level", PlanDocLevel_LT."Planning Document Level Index");
                    PlanDocLevelBuffer_LT.SetRange(Active, true);
                    PlanView_LT.SetRange("Planning Document Level", PlanDocLevel_LT."Planning Document Level Index" - 1);

                    //### filtere Attributtabelle
                    if PlanDocLevel_LT."Planning Document Level Index" > 0 then begin

                        //### hole Elternelemente um Views aufzubauen
                        ParentLevel_LT.Get(PlanDocLevel_LT."Planning Document No.", PlanDocLevel_LT."Planning Document Level Index" - 1);

                        if PlanView_LT.FindSet(true) then begin
                            DialogMgt_LC.UpdateCountArray(2, PlanView_LT.Count, false);
                            repeat
                                if PlanDocLevelBuffer_LT.FindSet() then
                                    repeat
                                        //### für jeden Puffereintrag prüfen, ob eine gültige Kombination mit den anderen
                                        //### Buffer-Ebenen erfolgt; wenn nicht: Bufferelement überspringen
                                        //### (z.B.: Abt. 1 - HWG 110: OK,   Abt. 1 - HWG 900: ungültige Kombination)
                                        if BufferIsValid(PlanDocLevelBuffer_LT, PlanView_LT, PlanDoc_PT, PlanDocLevel_LT) then begin

                                            //### View einfügen
                                            InsertAdditionalView(PlanView_LT, PlanDocLevelBuffer_LT, 0D, true, LastDatePlan_L);
                                            if PlanDocLevel_LT."Activate Date Level" then begin
                                                Date_LT.Reset();
                                                Date_LT.SetRange("Period Type", PlanDoc_PT."Date Unit");
                                                Date_LT.SetRange("Period Start", PlanDoc_PT."Start Date", PlanDoc_PT."End Date");
                                                firstmonth_L := true;
                                                if Date_LT.FindSet() then
                                                    repeat
                                                        InsertAdditionalView(PlanView_LT, PlanDocLevelBuffer_LT, Date_LT."Period Start", firstmonth_L, LastDatePlan_L);
                                                        firstmonth_L := false;
                                                    until Date_LT.Next() = 0;
                                            end;
                                            //### Wenn Pfadende erreicht, dann Cube-Tabelle aufbauen
                                            if (PlanDocLevel_LT."Path End") then
                                                if PlanDocLevel_LT."Activate Date Level" then begin
                                                    Date_LT.Reset();
                                                    Date_LT.SetRange("Period Type", PlanDoc_PT."Date Unit");
                                                    Date_LT.SetRange("Period Start", PlanDoc_PT."Start Date", PlanDoc_PT."End Date");
                                                    firstmonth_L := true;
                                                    if Date_LT.FindSet() then
                                                        repeat
                                                            InsertIntoPlanningValueCube(PlanView_LT, PlanDocLevelBuffer_LT, Date_LT."Period Start", firstmonth_L,
                                                                                        LastDatePlan_L, PlanCubeEntryNo_L);
                                                            PlanDocDateRef_LT.Get(PlanDoc_PT."No.", Date_LT."Period Start");
                                                            InsertIntoReferenceValueCube(PlanView_LT, PlanDocLevelBuffer_LT, PlanDocDateRef_LT."Reference Date",
                                                                                        firstmonth_L, LastDateRef_L, PlanCubeEntryNo_L);
                                                            firstmonth_L := false;
                                                        until Date_LT.Next() = 0;
                                                end else begin
                                                    InsertIntoPlanningValueCube(PlanView_LT, PlanDocLevelBuffer_LT, 0D, true, 0D, PlanCubeEntryNo_L);
                                                    InsertIntoReferenceValueCube(PlanView_LT, PlanDocLevelBuffer_LT, 0D, true, 0D, PlanCubeEntryNo_L);
                                                end;

                                        end;
                                    until PlanDocLevelBuffer_LT.Next() = 0
                                else
                                    Error(LevelHasNoActiveElementErr, PlanDocLevel_LT."Index Description");

                                DialogMgt_LC.UpdateDialogMultiLine(2, 0);
                            until PlanView_LT.Next() = 0;
                        end;
                    end else begin

                        //### View einfügen
                        InsertFirstView(PlanDocLevel_LT, 0D, true, LastDatePlan_L);
                        if PlanDocLevel_LT."Activate Date Level" then begin

                            Date_LT.Reset();
                            Date_LT.SetRange("Period Type", PlanDoc_PT."Date Unit");
                            Date_LT.SetRange("Period Start", PlanDoc_PT."Start Date", PlanDoc_PT."End Date");
                            firstmonth_L := true;
                            if Date_LT.FindSet() then begin
                                DialogMgt_LC.UpdateCountArray(2, Date_LT.Count, false);
                                repeat
                                    InsertFirstView(PlanDocLevel_LT, Date_LT."Period Start", firstmonth_L, LastDatePlan_L);
                                    //### Datumsebene 'Gesamt' in Cubes einfügen, wenn keine anderen Datumsebenen vorhanden
                                    PlanView_LT."Planning Document No." := PlanDoc_PT."No.";
                                    PlanView_LT."Line Type" := PlanView_LT."Line Type"::Plan;
                                    PlanView_LT."Timestamp Planning Values" := PlanDoc_PT."Timestamp Planning Values";
                                    PlanDocLevelBuffer_LT."Planning Document Level" := 0;

                                    //### Cubezeilen für Gesamt nur anlegen, wenn keine weiteren Ebenen vorhanden:
                                    if TotalLevels_L = 1 then begin
                                        InsertIntoPlanningValueCube(PlanView_LT, PlanDocLevelBuffer_LT, Date_LT."Period Start", firstmonth_L, LastDatePlan_L, PlanCubeEntryNo_L);
                                        PlanDocDateRef_LT.Get(PlanDoc_PT."No.", Date_LT."Period Start");
                                        InsertIntoReferenceValueCube(PlanView_LT, PlanDocLevelBuffer_LT, PlanDocDateRef_LT."Reference Date",
                                                                    firstmonth_L, LastDateRef_L, PlanCubeEntryNo_L);
                                    end;
                                    firstmonth_L := false;
                                    DialogMgt_LC.UpdateDialogMultiLine(2, 0);
                                until Date_LT.Next() = 0;
                            end;
                        end;

                    end;
                    DialogMgt_LC.UpdateDialogMultiLine(1, 0);
                until PlanDocLevel_LT.Next() = 0;
            end;

            DialogMgt_LC.CloseDialog();

            // nach dem Erstellen nochmal die Zeilen aller Ebenen (außer der untersten) prüfen, ob auch eine entsprechende Zeile in der untersten Ebene (zum Speichern) existiert:
            DeleteInvalidCombinations(PlanDoc_PT);

            //### korrekte Anzahl Zeilen/Datumszeilen für jede Ebene berechnen:
            CountLinesPerLevel(PlanDoc_PT);

            PlanDoc_PT.Modify();
        end;

        IsHandled := false;
        OnAfterCreatePlanningDocumentLevels(PlanDoc_PT, ShowConfirm_P, IsHandled);
    end;

    /// <summary>
    /// ReleasePlanDoc.
    /// </summary>
    /// <param name="PlanDoc_PT">Record "BET FN Planning Document".</param>
    /// <param name="ShowConfirm_P">Boolean.</param>
    procedure ReleasePlanDoc(PlanDoc_PT: Record "BET FN Planning Document"; ShowConfirm_P: Boolean);
    var
        PlanSetup_LT: Record "BET FN Planning Setup";
        PlanType_LT: Record "BET FN Planning Type";
        ExportPlanResult_LC: Codeunit "BET FN Export Planning Result";
        PlanFunctions_LC: Codeunit "BET FN Planning Functions";
        ConfirmManagement: Codeunit "Confirm Management";
        IsHandled: Boolean;
        ExportPlanningDataQst: Label 'Release document and export planning values?';
    begin
        IsHandled := false;
        OnBeforeReleasePlanDoc(PlanDoc_PT, IsHandled);
        if not IsHandled then begin
            if ShowConfirm_P then
                if not ConfirmManagement.GetResponse(ExportPlanningDataQst, true) then
                    exit;

            CheckPlanDocCreated(PlanDoc_PT, true);

            PlanSetup_LT.Get();
            // Prüfung auf nicht gespeicherte Daten 
            if PlanSetup_LT."Check For Unsaved Lines" then
                PlanFunctions_LC.PlanView_CheckForUnsavedLines(PlanDoc_PT);

            // Planungsposten schreiben
            if PlanType_LT.Get(PlanDoc_PT."Planning Type") and PlanType_LT."Write Planning Entries" then
                ExportPlanResult_LC.ExportDocument(PlanDoc_PT);

            // autom. Forecast-Beleg erstellen:
            if (PlanDoc_PT."Planning Version" = PlanDoc_PT."Planning Version"::Origin) and PlanSetup_LT."Auto Create Forecast" then
                CreateForecastPlan(PlanDoc_PT);

            PlanDoc_PT."Planning Values Exported" := CreateDateTime(WorkDate(), Time);
            PlanDoc_PT.Status := PlanDoc_PT.Status::Released;
            PlanDoc_PT.Modify();
        end;
    end;

    /// <summary>
    /// CreateForecastPlan.
    /// </summary>
    /// <param name="PlanDoc_PT">Record "BET FN Planning Document".</param>
    procedure CreateForecastPlan(PlanDoc_PT: Record "BET FN Planning Document")
    var
        PlanDoc_LT: Record "BET FN Planning Document";
    begin
        //### bei Freigabe eines Ursprungsbelegs den Forecast-Plan erstellen

        if PlanDoc_PT."Planning Version" <> PlanDoc_PT."Planning Version"::Origin then
            exit;

        //### bereits Forecast-Beleg vorhanden? --> EXIT
        PlanDoc_LT.Reset();
        PlanDoc_LT.SetRange("Planning Version", PlanDoc_LT."Planning Version"::Forecast);
        PlanDoc_LT.SetRange("Related Planning Document No.", PlanDoc_PT."No.");
        if not PlanDoc_LT.IsEmpty then
            exit;

        CopyPlanningDocument(PlanDoc_PT, false, true);
    end;

    /// <summary>
    /// CopyPlanningDocument.
    /// </summary>
    /// <param name="PlanDocSrc_PT">Record "BET FN Planning Document".</param>
    /// <param name="UseConfirm_P">Boolean.</param>
    /// <param name="CreateForecast_P">Boolean.</param>
    /// <returns>Return value of type Code[20].</returns>
    procedure CopyPlanningDocument(PlanDocSrc_PT: Record "BET FN Planning Document"; UseConfirm_P: Boolean; CreateForecast_P: Boolean): Code[20]
    var
        LevelBufferDest_LT: Record "BET FN Planning Doc Lvl Buf";
        LevelBufferSrc_LT: Record "BET FN Planning Doc Lvl Buf";
        PlanDocDest_LT: Record "BET FN Planning Document";
        PlanDocDateRefDest_LT: Record "BET FN Planning Document D Ref";
        PlanDocDateRefSrc_LT: Record "BET FN Planning Document D Ref";
        PlanDocLevelDest_LT: Record "BET FN Planning Document Level";
        PlanDocLevelSrc_LT: Record "BET FN Planning Document Level";
        PlanSetup_LT: Record "BET FN Planning Setup";
        PlanCubeDest_LT: Record "BET FN Planning Value Cube";
        PlanCubeSrc_LT: Record "BET FN Planning Value Cube";
        PlanViewDest_LT: Record "BET FN Planning View";
        PlanViewSrc_LT: Record "BET FN Planning View";
        RefCubeDest_LT: Record "BET FN Reference Value Cube";
        RefCubeSrc_LT: Record "BET FN Reference Value Cube";
        DialogMgt_LC: Codeunit "BET FN Dialog Mgt";
        ConfirmManagement: Codeunit "Confirm Management";
        NoSeries: Codeunit "No. Series";
        BETFNHelpersSetup: Codeunit "BET FN Helpers - Setup";
        IsHandled: Boolean;
        PlanDocNoNew_L: Code[20];
        LastNo_L: Integer;
        lines_L: Integer;
        TotalLines_L: Integer;
        ConfirmCreateCopyLbl: Label 'Create copy of this planning document?';
        CountCopyLinesLbl: Label 'Count lines to copy...';
        ProgressCopyLbl: Label 'Copy planning document';
    begin
        //### Kopieren eines kompletten Belegs

        IsHandled := false;
        OnBeforeCopyPlanningDocument(PlanDocSrc_PT, UseConfirm_P, CreateForecast_P, IsHandled);
        if IsHandled then
            exit;

        if UseConfirm_P then
            if not ConfirmManagement.GetResponse(ConfirmCreateCopyLbl, false) then
                exit;

        //### Anzahl der Datensätze für Fortschrittsbalken ermitteln:
        DialogMgt_LC.OpenDialog(1, CountCopyLinesLbl);
        TotalLines_L := 1;

        PlanDocLevelSrc_LT.Reset();
        PlanDocLevelSrc_LT.SetRange("Planning Document No.", PlanDocSrc_PT."No.");
        lines_L := PlanDocLevelSrc_LT.Count();
        TotalLines_L += lines_L;

        LevelBufferSrc_LT.Reset();
        LevelBufferSrc_LT.SetRange("Planning Document No.", PlanDocSrc_PT."No.");
        lines_L := LevelBufferSrc_LT.Count();
        TotalLines_L += lines_L;

        PlanViewSrc_LT.Reset();
        PlanViewSrc_LT.SetRange("Planning Document No.", PlanDocSrc_PT."No.");
        lines_L := PlanViewSrc_LT.Count();
        TotalLines_L += lines_L;

        PlanCubeSrc_LT.Reset();
        PlanCubeSrc_LT.SetRange("Planning Document No.", PlanDocSrc_PT."No.");
        lines_L := PlanCubeSrc_LT.Count();
        TotalLines_L += lines_L;

        RefCubeSrc_LT.Reset();
        RefCubeSrc_LT.SetRange("Planning Document No.", PlanDocSrc_PT."No.");
        lines_L := RefCubeSrc_LT.Count();
        TotalLines_L += lines_L;

        PlanDocDateRefSrc_LT.Reset();
        PlanDocDateRefSrc_LT.SetRange("Planning Document No.", PlanDocSrc_PT."No.");
        lines_L := PlanDocDateRefSrc_LT.Count();
        TotalLines_L += lines_L;

        DialogMgt_LC.CloseDialog();

        DialogMgt_LC.OpenDialog(TotalLines_L, ProgressCopyLbl);


        //### Nummer aus Nummernserie vergeben
        PlanSetup_LT.Get();
        if PlanSetup_LT."No. Series" = '' then
            BETFNHelpersSetup.TestSetupFields(Database::"BET FN Planning Setup", PlanSetup_LT.FieldNo("No. Series"));
        PlanDocNoNew_L := NoSeries.GetNextNo(PlanSetup_LT."No. Series", WorkDate(), true);

        //### Beleg selber erstellen:
        DialogMgt_LC.UpdateDialog(0);
        PlanDocDest_LT.Init();
        PlanDocDest_LT.TransferFields(PlanDocSrc_PT);
        PlanDocDest_LT."No." := PlanDocNoNew_L;
        PlanDocDest_LT.Status := PlanDocDest_LT.Status::Open;
        PlanDocDest_LT."Planning Values Exported" := 0DT;

        //### optional: Forecast-Beleg
        if CreateForecast_P and (PlanDocSrc_PT."Planning Version" = PlanDocSrc_PT."Planning Version"::Origin) then begin
            PlanDocDest_LT."Planning Version" := PlanDocDest_LT."Planning Version"::Forecast;
            PlanDocDest_LT."Related Planning Document No." := PlanDocSrc_PT."No.";
        end else begin
            //### normale Kopie:
            PlanDocDest_LT.Description := '';  // 'Kopie von Beleg ' + PlanDocSrc_PT."No.";
            PlanDocDest_LT."Is Copy" := true;
            PlanDocDest_LT."Copy From Document No." := PlanDocSrc_PT."No.";
        end;

        PlanDocDest_LT.Insert();

        //### Planungsebenen:
        PlanDocLevelSrc_LT.Reset();
        PlanDocLevelSrc_LT.SetRange("Planning Document No.", PlanDocSrc_PT."No.");
        if PlanDocLevelSrc_LT.FindSet() then
            repeat
                DialogMgt_LC.UpdateDialog(0);
                PlanDocLevelDest_LT.Init();
                PlanDocLevelDest_LT.TransferFields(PlanDocLevelSrc_LT);
                PlanDocLevelDest_LT."Planning Document No." := PlanDocNoNew_L;
                PlanDocLevelDest_LT.Insert();
            until PlanDocLevelSrc_LT.Next() = 0;

        //### Puffertabelle:
        LevelBufferSrc_LT.Reset();
        LevelBufferSrc_LT.SetRange("Planning Document No.", PlanDocSrc_PT."No.");
        if LevelBufferSrc_LT.FindSet() then
            repeat
                DialogMgt_LC.UpdateDialog(0);
                LevelBufferDest_LT.Init();
                LevelBufferDest_LT.TransferFields(LevelBufferSrc_LT);
                LevelBufferDest_LT."Planning Document No." := PlanDocNoNew_L;
                LevelBufferDest_LT.Insert();
            until LevelBufferSrc_LT.Next() = 0;

        //### View:
        LastNo_L := 0;
        PlanViewSrc_LT.Reset();
        if PlanViewSrc_LT.FindLast() then
            LastNo_L := PlanViewSrc_LT."View Entry No.";
        PlanViewSrc_LT.Reset();
        PlanViewSrc_LT.SetRange("Planning Document No.", PlanDocSrc_PT."No.");
        if PlanViewSrc_LT.FindSet() then
            repeat
                DialogMgt_LC.UpdateDialog(0);
                LastNo_L += 1;
                PlanViewDest_LT.Init();
                PlanViewDest_LT.TransferFields(PlanViewSrc_LT);
                PlanViewDest_LT."View Entry No." := LastNo_L;
                PlanViewDest_LT."Planning Document No." := PlanDocNoNew_L;
                // gleich Aktualisierung erzwingen:
                PlanViewDest_LT."Timestamp Planning Values" := PlanViewDest_LT."Timestamp Planning Values" - 10000;
                PlanViewDest_LT.Insert();
            until PlanViewSrc_LT.Next() = 0;

        //### PlanCube:
        LastNo_L := 0;
        PlanCubeSrc_LT.Reset();
        if PlanCubeSrc_LT.FindLast() then
            LastNo_L := PlanCubeSrc_LT."Entry No.";
        PlanCubeSrc_LT.Reset();
        PlanCubeSrc_LT.SetRange("Planning Document No.", PlanDocSrc_PT."No.");
        if PlanCubeSrc_LT.FindSet() then
            repeat
                DialogMgt_LC.UpdateDialog(0);
                LastNo_L += 1;
                PlanCubeDest_LT.Init();
                PlanCubeDest_LT.TransferFields(PlanCubeSrc_LT);
                PlanCubeDest_LT."Entry No." := LastNo_L;
                PlanCubeDest_LT."Planning Document No." := PlanDocNoNew_L;
                PlanCubeDest_LT.Insert();

                // RefCube gleich hier erstellen wegen gleicher Zeilennummer (PK):
                RefCubeSrc_LT.Get(PlanCubeSrc_LT."Entry No.");
                RefCubeDest_LT.Init();
                RefCubeDest_LT.TransferFields(RefCubeSrc_LT);
                RefCubeDest_LT."Entry No." := PlanCubeDest_LT."Entry No.";
                RefCubeDest_LT."Planning Document No." := PlanDocNoNew_L;
                RefCubeDest_LT.Insert();
            until PlanCubeSrc_LT.Next() = 0;

        //### Date Ref.:
        PlanDocDateRefSrc_LT.Reset();
        PlanDocDateRefSrc_LT.SetRange("Planning Document No.", PlanDocSrc_PT."No.");
        if PlanDocDateRefSrc_LT.FindSet() then
            repeat
                DialogMgt_LC.UpdateDialog(0);
                PlanDocDateRefDest_LT.Init();
                PlanDocDateRefDest_LT.TransferFields(PlanDocDateRefSrc_LT);
                PlanDocDateRefDest_LT."Planning Document No." := PlanDocNoNew_L;
                PlanDocDateRefDest_LT.Insert();
            until PlanDocDateRefSrc_LT.Next() = 0;

        exit(PlanDocNoNew_L);
    end;

    /// <summary>
    /// ReopenPlanDoc.
    /// </summary>
    /// <param name="PlanDoc_PT">Record "BET FN Planning Document".</param>
    /// <param name="ShowConfirm_P">Boolean.</param>
    procedure ReopenPlanDoc(PlanDoc_PT: Record "BET FN Planning Document"; ShowConfirm_P: Boolean)
    var
        PlanDoc_LT: Record "BET FN Planning Document";
        PlanFunctions_LC: Codeunit "BET FN Planning Functions";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeReopenPlanDoc(PlanDoc_PT, IsHandled);
        if IsHandled then
            exit;

        PlanDoc_PT.TestField(Status, PlanDoc_PT.Status::Released);
        PlanDoc_LT.Get(PlanDoc_PT."No.");
        PlanDoc_LT.Status := PlanDoc_LT.Status::Open;
        PlanDoc_LT."Planning Values Exported" := 0DT;
        PlanDoc_LT.Modify();

        // noch zugehörige Planungsposten löschen:
        PlanFunctions_LC.DeletePlanningEntries(PlanDoc_LT."No.");
    end;

    /// <summary>
    /// ImportPlanningValues.
    /// </summary>
    /// <param name="PlanDoc_PT">Record "BET FN Planning Document".</param>
    procedure ImportPlanningValues(PlanDoc_PT: Record "BET FN Planning Document")
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeImportPlanningValues(PlanDoc_PT, IsHandled);
        if IsHandled then
            exit;
    end;

    internal procedure SetLevelLayoutToGlobal(DocNo_P: Code[20])
    var
        PlanDocLevel_LT: Record "BET FN Planning Document Level";
        PlanSetup_LT: Record "BET FN Planning Setup";
    begin
        PlanSetup_LT.Get();

        PlanDocLevel_LT.Reset();
        PlanDocLevel_LT.SetRange("Planning Document No.", DocNo_P);
        if PlanDocLevel_LT.FindFirst() then
            repeat
                PlanDocLevel_LT.TransferFields(PlanSetup_LT, false);
                PlanDocLevel_LT.Modify();
            until PlanDocLevel_LT.Next() = 0;
    end;

    internal procedure UpdateNoOfRecords(var PlanDocLevel_RT: Record "BET FN Planning Document Level")
    var
        PlanDocLevelBuffer_LT: Record "BET FN Planning Doc Lvl Buf";
        PlanDoc_LT: Record "BET FN Planning Document";
        ParentPlanDocLevel_LT: Record "BET FN Planning Document Level";
        PlanDocLevel_LT: Record "BET FN Planning Document Level";
        PlanFunctions_LC: Codeunit "BET FN Planning Functions";
        i_L: Integer;
    begin
        // Gesamtebene:
        if PlanDocLevel_LT.Get(PlanDocLevel_RT."Planning Document No.", PlanDocLevel_RT."Planning Document Level Index") and
          (PlanDocLevel_LT."Planning Document Level Index" = 0) and
          PlanDoc_LT.Get(PlanDocLevel_RT."Planning Document No.") then begin
            if PlanDocLevel_LT."Activate Date Level" then begin
                PlanDocLevel_LT."No. of Records" := 1;
                PlanDocLevel_LT."No. of Records on Date Level" := PlanDocLevel_LT."No. of Records" *
                                                                  PlanDoc_LT."No. of Date-Records";
            end;
            PlanDocLevel_LT.Modify();
        end;

        // alle anderen Ebenen:
        // Anzahl der Datensätze immer für alle Ebenen berechnen! (oder rekursiv für die geänderten)
        PlanDocLevel_LT.Reset();
        PlanDocLevel_LT.SetRange("Planning Document No.", PlanDocLevel_RT."Planning Document No.");
        for i_L := 1 to PlanFunctions_LC.GetMaxNoOfLevels() do begin
            PlanDocLevel_LT.SetRange("Planning Document Level Index", i_L);
            if PlanDocLevel_LT.Find('-') then
                repeat

                    PlanDocLevelBuffer_LT.Reset();
                    PlanDocLevelBuffer_LT.SetRange("Planning Document No.", PlanDocLevel_LT."Planning Document No.");
                    PlanDocLevelBuffer_LT.SetRange("Planning Document Level", PlanDocLevel_LT."Planning Document Level Index");
                    PlanDocLevelBuffer_LT.SetRange(Active, true);    // alle aktiven
                    PlanDocLevel_LT."No. of Source-Records" := PlanDocLevelBuffer_LT.Count();
                    PlanDocLevel_LT."No. of Records" := PlanDocLevelBuffer_LT.Count();

                    ParentPlanDocLevel_LT.Get(PlanDocLevel_LT."Planning Document No.", PlanDocLevel_LT."Planning Document Level Index" - 1);
                    PlanDocLevel_LT."No. of Records" := ParentPlanDocLevel_LT."No. of Records" * PlanDocLevel_LT."No. of Records";
                    if PlanDocLevel_LT."Activate Date Level" then begin
                        PlanDoc_LT.Get(PlanDocLevel_LT."Planning Document No.");
                        PlanDocLevel_LT."No. of Records on Date Level" := PlanDocLevel_LT."No. of Records" * PlanDoc_LT."No. of Date-Records";
                    end;
                    PlanDocLevel_LT.Modify();

                until PlanDocLevel_LT.Next() = 0;
        end;
    end;

    // PUBLISHERS //
    [IntegrationEvent(false, false)]
    local procedure OnBeforeShowPlanDocLevels(BETFNPlanningDocument: Record "BET FN Planning Document"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeOpenPlanningView(BETFNPlanningDocument: Record "BET FN Planning Document"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeRunPagePlanningView(BETFNPlanningDocument: Record "BET FN Planning Document"; BETFNPlanningView: Record "BET FN Planning View"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreatePlanningDocumentLevels(BETFNPlanningDocument: Record "BET FN Planning Document"; ShowConfirm: Boolean; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreatePlanningDocumentLevels(BETFNPlanningDocument: Record "BET FN Planning Document"; ShowConfirm: Boolean; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeReleasePlanDoc(BETFNPlanningDocument: Record "BET FN Planning Document"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCopyPlanningDocument(BETFNPlanningDocument: Record "BET FN Planning Document"; UseConfirm: Boolean; CreateForecast: Boolean; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeReopenPlanDoc(BETFNPlanningDocument: Record "BET FN Planning Document"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeImportPlanningValues(BETFNPlanningDocument: Record "BET FN Planning Document"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeBufferIsValid(BETFNPlanningDocLvlBuf: Record "BET FN Planning Doc Lvl Buf"; BETFNPlanningView: Record "BET FN Planning View"; BETFNPlanningDocument: Record "BET FN Planning Document"; BETFNPlanningDocumentLevel: Record "BET FN Planning Document Level"; var BufferIsValidResult: Boolean; var IsHandled: Boolean)
    begin
    end;
}