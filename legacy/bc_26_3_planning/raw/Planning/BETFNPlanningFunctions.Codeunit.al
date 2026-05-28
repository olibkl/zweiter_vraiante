/// <summary>
/// [planning]
/// Modules: 
/// </summary>
#pragma warning disable AL0432
codeunit 5138647 "BET FN Planning Functions"
{
    Access = Public;

    var
        CancelFixationQst: Label 'Cancel fixation for %1?', Comment = '%1';
        FixateQst: Label 'fixate %1?', Comment = '%1';
        FixatingLinesLbl: Label 'Fixating lines...';
        FixationOnDateNotPossibleErr: Label 'Fixation not possible on date level. ';
        PlanningDocumentLevelNotFoundErr: Label 'Planning document level not found.';
        PlanningDocumentNotFoundErr: Label 'Planning document not found.';

    /// <summary>
    /// CountBufferRecords_obsolete.
    /// </summary>
    /// <param name="DocNo_P">Code[20].</param>
    procedure CountBufferRecords_obsolete(DocNo_P: Code[20])
    var
        LevelBuffer_LT: Record "BET FN Planning Doc Lvl Buf";
        PlanDoc_LT: Record "BET FN Planning Document";
        PlanDocLevel_LT: Record "BET FN Planning Document Level";
        PrevLevel_LT: Record "BET FN Planning Document Level";
    begin
        //### berechnet für alle Ebenen die Anzahl der aktive Elemente und zusätzlich die Anzahl der zu erwartenden
        //### Zeilen beim Aufbau des Beleges (Warengruppenhierarchie wird dabei nicht berücksichtigt!)

        if not PlanDoc_LT.Get(DocNo_P) then
            Error(PlanningDocumentNotFoundErr);

        //### durch alle Belegebenen gehen, wichtig: immer erst die Ebenen in einer Stufe betrachten (vert. Index aufsteigend)
        PlanDocLevel_LT.Reset();
        PlanDocLevel_LT.SetCurrentKey("Planning Document No.", "Planning Document Level Index");
        PlanDocLevel_LT.SetRange("Planning Document No.", DocNo_P);
        if PlanDocLevel_LT.FindSet(true) then
            repeat
                LevelBuffer_LT.Reset();
                LevelBuffer_LT.SetRange("Planning Document No.", DocNo_P);
                LevelBuffer_LT.SetRange("Planning Document Level", PlanDocLevel_LT."Planning Document Level Index");
                LevelBuffer_LT.SetRange(Active, true);
                PlanDocLevel_LT."No. of Source-Records" := LevelBuffer_LT.Count();      //### Anzahl aktiver Elemente

                //### Gesamtebene separat betrachten:
                case PlanDocLevel_LT."Planning Document Level Index" of
                    0:
                        begin
                            PlanDocLevel_LT."No. of Records" := 1;
                            PlanDocLevel_LT."No. of Records on Date Level" := PlanDoc_LT."No. of Date-Records";
                        end;

                    1:     // es gibt nur genau eine Vorgängerebene (= Gesamtebene)
                        begin
                            PrevLevel_LT.Reset();
                            PrevLevel_LT.SetRange("Planning Document No.", DocNo_P);
                            PrevLevel_LT.SetRange("Planning Document Level Index", PlanDocLevel_LT."Planning Document Level Index" - 1);
                            PrevLevel_LT.FindFirst();

                            PlanDocLevel_LT."No. of Records" := PrevLevel_LT."No. of Records" * LevelBuffer_LT.Count();
                            PlanDocLevel_LT."No. of Records on Date Level" := PrevLevel_LT."No. of Records on Date Level" * LevelBuffer_LT.Count();
                        end;

                    else      // es können mehrere Vorgängerebenen vorhanden sein (mehrere parallele Zweige!)
                      begin
                        PrevLevel_LT.Reset();
                        PrevLevel_LT.SetRange("Planning Document No.", DocNo_P);
                        PrevLevel_LT.SetRange("Planning Document Level Index", PlanDocLevel_LT."Planning Document Level Index" - 1);
                        PrevLevel_LT.FindFirst();

                        PlanDocLevel_LT."No. of Records" := PrevLevel_LT."No. of Records" * LevelBuffer_LT.Count();
                        PlanDocLevel_LT."No. of Records on Date Level" := PrevLevel_LT."No. of Records on Date Level" * LevelBuffer_LT.Count();
                    end;
                end;
                PlanDocLevel_LT.Modify();
            until PlanDocLevel_LT.Next() = 0;
    end;

    /// <summary>
    /// SetRelatedBufferLines.
    /// </summary>
    /// <param name="PlanDocLevelBuffer_PT">Record "BET FN Planning Doc Lvl Buf".</param>
    /// <param name="Active_P">Boolean.</param>
    procedure SetRelatedBufferLines(PlanDocLevelBuffer_PT: Record "BET FN Planning Doc Lvl Buf"; Active_P: Boolean)
    var
        LevelBuffer_LT: Record "BET FN Planning Doc Lvl Buf";
        PlanDocLevel_LT: Record "BET FN Planning Document Level";
        PlanDocLevelCurrent_LT: Record "BET FN Planning Document Level";
        PlanLevel_LT: Record "BET FN Planning Level";
        PlanLevelCurrent_LT: Record "BET FN Planning Level";
        SearchLevel_LT: Record "BET FN Planning Level";
        PlanDocMgmt_LC: Codeunit "BET FN Planning Document Mgt";
        RR_L: RecordRef;
        FR_L: FieldRef;
        ChangeBufferElement_L: Boolean;
        RelatedCode_L: Code[20];
    begin
        //### 080821

        //### Belegebene finden:
        PlanDocLevelCurrent_LT.Reset();
        PlanDocLevelCurrent_LT.SetRange("Planning Document No.", PlanDocLevelBuffer_PT."Planning Document No.");
        PlanDocLevelCurrent_LT.SetRange("Planning Document Level Index", PlanDocLevelBuffer_PT."Planning Document Level");
        if not PlanDocLevelCurrent_LT.FindFirst() then
            Error(PlanningDocumentLevelNotFoundErr);

        //### akt. Planungsebene:
        PlanLevelCurrent_LT.Get(PlanDocLevelCurrent_LT."Index Code");

        //### alle anderen (darunterliegenden!) Belegebenen durchlaufen und prüfen, ob
        //### diese der aktuellen Ebene zugeordnet sind:
        PlanDocLevel_LT.Reset();
        PlanDocLevel_LT.SetRange("Planning Document No.", PlanDocLevelBuffer_PT."Planning Document No.");
        PlanDocLevel_LT.SetFilter("Planning Document Level Index", '>%1', PlanDocLevelBuffer_PT."Planning Document Level");
        if PlanDocLevel_LT.FindSet() then
            repeat
                if PlanLevel_LT.Get(PlanDocLevel_LT."Index Code") and
                   (PlanLevel_LT."Assigned to Index" <> '') then     //### Zeile mit Zuordnung gefunden
                                                                     //### prüfen, ob die beiden Ebenen eine direkte Verbindung zueinander haben (z.B. Abt. --> Artikel)
                    if PlanDocMgmt_LC.LevelsAreInHierarchy(PlanDocLevelCurrent_LT, PlanDocLevel_LT) then begin

                        //### jetzt alle Elemente der gefundenen Ebene durchlaufen und feststellen, ob das entspr. Element betroffen ist:
                        LevelBuffer_LT.Reset();
                        LevelBuffer_LT.SetRange("Planning Document No.", PlanDocLevel_LT."Planning Document No.");
                        LevelBuffer_LT.SetRange("Planning Document Level", PlanDocLevel_LT."Planning Document Level Index");
                        if LevelBuffer_LT.FindSet(true) then
                            repeat     //### alle Elemente der gefundenen Ebene prüfen  (Bsp.: welche WG gehören zur geänderten Abt. ?)
                                ChangeBufferElement_L := false;
                                RelatedCode_L := LevelBuffer_LT."Index Code";
                                SearchLevel_LT.Get(PlanLevel_LT."Index Code");    // Startebene (unten, akt. gefundene Ebene)
                                repeat
                                    //### den jeweils zugehörigen Code weitergeben: (WG -> HWG -> Abt.)
                                    RR_L.Open(SearchLevel_LT."Index Table No.");
                                    FR_L := RR_L.Field(SearchLevel_LT."Primary Key Field No.");    //### Code-Feld
                                    FR_L.SetRange(RelatedCode_L);    //### auf akt. Element filtern
                                    if RR_L.FindFirst() then begin   //### ist das Element wirklich vorhanden?
                                        FR_L := RR_L.Field(SearchLevel_LT."Assigned to Index Field No.");    //### Feld d. höheren Ebene
                                        RelatedCode_L := FR_L.Value();   //### Bsp.: zugeornete HWG zur akt. WG merken
                                    end;
                                    RR_L.Close();

                                    //### ist der bisher übergebene Code identisch mit dem geänderten Element?
                                    if RelatedCode_L = PlanDocLevelBuffer_PT."Index Code" then
                                        ChangeBufferElement_L := true
                                    else
                                        if SearchLevel_LT."Assigned to Index" <> '' then
                                            SearchLevel_LT.Get(SearchLevel_LT."Assigned to Index");
                                until ChangeBufferElement_L or (SearchLevel_LT."Assigned to Index" = '');

                                //### Bsp.: WG aktiv/inaktiv, wenn wir entsprechende Abt. aktiv/inaktiv gesetzt haben
                                if ChangeBufferElement_L then begin
                                    LevelBuffer_LT.Active := Active_P;
                                    LevelBuffer_LT.Modify();
                                end;
                            until LevelBuffer_LT.Next() = 0;
                    end;
            until PlanDocLevel_LT.Next() = 0;
        //### ...080821
    end;

    /// <summary>
    /// PlanView_CheckForUnsavedLines.
    /// </summary>
    /// <param name="PlanDoc_PT">Record "BET FN Planning Document".</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure PlanView_CheckForUnsavedLines(PlanDoc_PT: Record "BET FN Planning Document"): Boolean
    var
        PlanDocMgt_LC: Codeunit "BET FN Planning Document Mgt";
    begin
        //### vor dem Exportieren des Belegs müssen nochmal alle Ebenen nach nicht gespeicherten
        //### Zeilen durchsucht werden. Wird eine gefunden, dann Nutzer informieren und abbrechen

        if PlanDocMgt_LC.ExistUnsavedLines(PlanDoc_PT."No.") then begin
            PlanDocMgt_LC.ShowUnsavedLines(PlanDoc_PT."No.");
            exit(true);
        end;
        exit(false);
    end;

    /// <summary>
    /// FillTablesWithPercentage.
    /// </summary>
    /// <param name="DocNo_P">Code[20].</param>
    [Obsolete('#35131 Pending removal - procedure will be removed in future', '25.2')]
    procedure FillTablesWithPercentage(DocNo_P: Code[20])
    begin

    end;

    /// <summary>
    /// InitPlanningStatistic.
    /// </summary>
    procedure InitPlanningStatistic()
    var
        PlanStat_LT: Record "BET FN Planning Statistic";
    begin
        if not PlanStat_LT.Get() then begin
            PlanStat_LT.Init();
            PlanStat_LT.Insert();
        end;
    end;

    /// <summary>
    /// CalcInvStockRotation.
    /// </summary>
    /// <param name="PlanView_RT">VAR Record "BET FN Planning View".</param>
    [Obsolete('#35131 Pending removal - procedure will be removed in future', '25.2')]
    procedure CalcInvStockRotation(var PlanView_RT: Record "BET FN Planning View")
    begin
    end;

    /// <summary>
    /// CalcInvStockRotationVJ.
    /// </summary>
    /// <param name="PlanView_RT">VAR Record "BET FN Planning View".</param>
    [Obsolete('#35131 Pending removal - procedure will be removed in future', '25.2')]
    procedure CalcInvStockRotationVJ(var PlanView_RT: Record "BET FN Planning View")
    begin
    end;

    /// <summary>
    /// GetMaxNoOfLevels.
    /// </summary>
    /// <returns>Return value of type Integer.</returns>
    procedure GetMaxNoOfLevels(): Integer
    begin
        //### 090528
        exit(6);
    end;

    /// <summary>
    /// InitDescriptionOptions.
    /// </summary>
    /// <param name="PlanDoc_PT">Record "BET FN Planning Document".</param>
    /// <param name="DescrOptions_R">VAR array[6] of Option "Code",Description,Both.</param>
    procedure InitDescriptionOptions(PlanDoc_PT: Record "BET FN Planning Document"; var DescrOptions_R: array[6] of Option "Code",Description,Both)
    var
        PlanDocLevel_LT: Record "BET FN Planning Document Level";
        PlanLevel_LT: Record "BET FN Planning Level";
    begin
        //### Funktion übernimmt für alle Belegebenen die Beschriftungsoptionen (Code/Beschr./Beides) in ein Array
        Clear(DescrOptions_R);

        PlanDocLevel_LT.Reset();
        PlanDocLevel_LT.SetRange("Planning Document No.", PlanDoc_PT."No.");
        if PlanDocLevel_LT.FindSet() then
            repeat
                if PlanLevel_LT.Get(PlanDocLevel_LT."Index Code") then
                    DescrOptions_R[PlanDocLevel_LT."Planning Document Level Index"] := PlanLevel_LT."Description in Document";
            until PlanDocLevel_LT.Next() = 0;
    end;

    /// <summary>
    /// GetDescriptionArray.
    /// </summary>
    /// <param name="PlanView_PT">Record "BET FN Planning View".</param>
    /// <param name="PlanDoc_PT">Record "BET FN Planning Document".</param>
    /// <param name="DescrArray_R">VAR array[6] of Text[50].</param>
    /// <param name="DescrOptions_P">array[6] of Option "Code",Description,Both.</param>
    /// <param name="LineInformation_R">VAR Text.</param>
    procedure GetDescriptionArray(PlanView_PT: Record "BET FN Planning View"; PlanDoc_PT: Record "BET FN Planning Document"; var DescrArray_R: array[6] of Text[50]; DescrOptions_P: array[6] of Option "Code",Description,Both; var LineInformation_R: Text)
    var
        Separator_L: Text;
    begin
        //### Funktion füllt für die übergebene Zeile die Indexfelder pro Ebene (im Array)
        //### entsprechend der Beschreibungseinstellungen der Ebenen

        Clear(DescrArray_R);

        if PlanView_PT."Index 1" <> '' then
            case DescrOptions_P[1] of
                DescrOptions_P::Code:
                    DescrArray_R[1] := PlanView_PT."Index 1";
                DescrOptions_P::Description:
                    DescrArray_R[1] := PlanView_PT."Description 1";
                DescrOptions_P::Both:
                    DescrArray_R[1] := CopyStr(PlanView_PT."Index 1" + ' ' + PlanView_PT."Description 1", 1, MaxStrLen(DescrArray_R[1]));
            end;

        if PlanView_PT."Index 2" <> '' then
            case DescrOptions_P[2] of
                DescrOptions_P::Code:
                    DescrArray_R[2] := PlanView_PT."Index 2";
                DescrOptions_P::Description:
                    DescrArray_R[2] := PlanView_PT."Description 2";
                DescrOptions_P::Both:
                    DescrArray_R[2] := CopyStr(PlanView_PT."Index 2" + ' ' + PlanView_PT."Description 2", 1, MaxStrLen(DescrArray_R[2]));
            end;

        if PlanView_PT."Index 3" <> '' then
            case DescrOptions_P[3] of
                DescrOptions_P::Code:
                    DescrArray_R[3] := PlanView_PT."Index 3";
                DescrOptions_P::Description:
                    DescrArray_R[3] := PlanView_PT."Description 3";
                DescrOptions_P::Both:
                    DescrArray_R[3] := CopyStr(PlanView_PT."Index 3" + ' ' + PlanView_PT."Description 3", 1, MaxStrLen(DescrArray_R[3]));
            end;

        if PlanView_PT."Index 4" <> '' then
            case DescrOptions_P[4] of
                DescrOptions_P::Code:
                    DescrArray_R[4] := PlanView_PT."Index 4";
                DescrOptions_P::Description:
                    DescrArray_R[4] := PlanView_PT."Description 4";
                DescrOptions_P::Both:
                    DescrArray_R[4] := CopyStr(PlanView_PT."Index 4" + ' ' + PlanView_PT."Description 4", 1, MaxStrLen(DescrArray_R[4]));
            end;

        if PlanView_PT."Index 5" <> '' then
            case DescrOptions_P[5] of
                DescrOptions_P::Code:
                    DescrArray_R[5] := PlanView_PT."Index 5";
                DescrOptions_P::Description:
                    DescrArray_R[5] := PlanView_PT."Description 5";
                DescrOptions_P::Both:
                    DescrArray_R[5] := CopyStr(PlanView_PT."Index 5" + ' ' + PlanView_PT."Description 5", 1, MaxStrLen(DescrArray_R[5]));
            end;

        if PlanView_PT."Index 6" <> '' then
            case DescrOptions_P[6] of
                DescrOptions_P::Code:
                    DescrArray_R[6] := PlanView_PT."Index 6";
                DescrOptions_P::Description:
                    DescrArray_R[6] := PlanView_PT."Description 6";
                DescrOptions_P::Both:
                    DescrArray_R[6] := CopyStr(PlanView_PT."Index 6" + ' ' + PlanView_PT."Description 6", 1, MaxStrLen(DescrArray_R[6]));
            end;
        Clear(LineInformation_R);
        Separator_L := ' - ';
        if DescrArray_R[1] <> '' then
            LineInformation_R := DescrArray_R[1];
        if DescrArray_R[2] <> '' then
            LineInformation_R := LineInformation_R + Separator_L + DescrArray_R[2];
        if DescrArray_R[3] <> '' then
            LineInformation_R := LineInformation_R + Separator_L + DescrArray_R[3];
        if DescrArray_R[4] <> '' then
            LineInformation_R := LineInformation_R + Separator_L + DescrArray_R[4];
        if DescrArray_R[5] <> '' then
            LineInformation_R := LineInformation_R + Separator_L + DescrArray_R[5];
        if DescrArray_R[6] <> '' then
            LineInformation_R := LineInformation_R + Separator_L + DescrArray_R[6];

        if PlanView_PT.Date <> 0D then
            if LineInformation_R <> '' then
                if PlanDoc_PT."Show Date Description" then
                    LineInformation_R := LineInformation_R + Separator_L + 'Monat'
                else
                    LineInformation_R := LineInformation_R + Separator_L + Format(PlanView_PT.Date)
            else
                if PlanDoc_PT."Show Date Description" then
                    LineInformation_R := 'Monat'
                else
                    LineInformation_R := Format(PlanView_PT.Date);
    end;

    /// <summary>
    /// SetLinesFixed.
    /// </summary>
    /// <param name="PlanView_PT">Record "BET FN Planning View".</param>
    procedure SetLinesFixed(PlanView_PT: Record "BET FN Planning View")
    var
        PlanDocLevel_LT: Record "BET FN Planning Document Level";
        PlanCube_LT: Record "BET FN Planning Value Cube";
        PlanView_LT: Record "BET FN Planning View";
        ConfirmManagement: Codeunit "Confirm Management";
        Window_L: Dialog;
        i_L: Integer;
        TotalLineLbl: Label 'Total line';
        MsgText_L: Text[250];
    begin

        //### Fixierung nur auf Gesamtebenen erlauben, nicht auf Monaten (Prüfungen zu aufwendig!)
        if PlanView_PT.Date <> 0D then
            Error(FixationOnDateNotPossibleErr);

        if PlanView_PT."Planning Document Level" = 0 then
            MsgText_L := TotalLineLbl
        else begin
            PlanDocLevel_LT.Reset();
            PlanDocLevel_LT.SetRange("Planning Document No.", PlanView_PT."Planning Document No.");
            PlanDocLevel_LT.SetFilter("Planning Document Level Index", '<=%1 & >%2', PlanView_PT."Planning Document Level", 0);
            if PlanDocLevel_LT.Find('-') then begin
                MsgText_L := '';
                i_L := 0;
                repeat
                    i_L += 1;

                    MsgText_L := CopyStr(MsgText_L + PlanDocLevel_LT."Index Description" + ': ', 1, MaxStrLen(MsgText_L));
                    case i_L of
                        1:
                            MsgText_L := CopyStr(MsgText_L + PlanView_PT."Index 1", 1, MaxStrLen(MsgText_L));
                        2:
                            MsgText_L := CopyStr(MsgText_L + PlanView_PT."Index 2", 1, MaxStrLen(MsgText_L));
                        3:
                            MsgText_L := CopyStr(MsgText_L + PlanView_PT."Index 3", 1, MaxStrLen(MsgText_L));
                        4:
                            MsgText_L := CopyStr(MsgText_L + PlanView_PT."Index 4", 1, MaxStrLen(MsgText_L));
                        5:
                            MsgText_L := CopyStr(MsgText_L + PlanView_PT."Index 5", 1, MaxStrLen(MsgText_L));
                        6:
                            MsgText_L := CopyStr(MsgText_L + PlanView_PT."Index 6", 1, MaxStrLen(MsgText_L));
                    end;
                    MsgText_L := CopyStr(MsgText_L + '\', 1, MaxStrLen(MsgText_L));
                until PlanDocLevel_LT.Next() = 0;
                MsgText_L := DelChr(MsgText_L, '>', '\');
            end;
        end;

        if PlanView_PT.Fixed then
            MsgText_L := StrSubstNo(FixateQst, MsgText_L)
        else
            MsgText_L := StrSubstNo(CancelFixationQst, MsgText_L);

        if not ConfirmManagement.GetResponse(MsgText_L, false) then
            exit;


        Window_L.Open(FixatingLinesLbl);

        //### alle darunter liegenden Ebenen fixieren (View):
        PlanView_LT.Reset();
        PlanView_LT.SetCurrentKey("Planning Document No.", "Planning Document Level", "Index 1", "Index 2", "Index 3", "Index 4", "Index 5", "Index 6", Date);
        PlanView_LT.SetRange("Planning Document No.", PlanView_PT."Planning Document No.");
        PlanView_LT.SetFilter("Planning Document Level", '>=%1', PlanView_PT."Planning Document Level");
        PlanView_LT.SetFilter("Index 1", PlanView_PT."Index 1");
        PlanView_LT.SetFilter("Index 2", PlanView_PT."Index 2");
        PlanView_LT.SetFilter("Index 3", PlanView_PT."Index 3");
        PlanView_LT.SetFilter("Index 4", PlanView_PT."Index 4");
        PlanView_LT.SetFilter("Index 5", PlanView_PT."Index 5");
        PlanView_LT.SetFilter("Index 6", PlanView_PT."Index 6");
        PlanView_LT.ModifyAll(Fixed, PlanView_PT.Fixed);

        //### zugehörige Cubezeilen fixieren:
        PlanCube_LT.Reset();
        PlanCube_LT.SetCurrentKey("Planning Document No.", "Index 1", "Index 2", "Index 3", "Index 4", "Index 5", "Index 6", Date);
        PlanCube_LT.SetRange("Planning Document No.", PlanView_PT."Planning Document No.");
        PlanCube_LT.SetFilter("Index 1", PlanView_PT."Index 1");
        PlanCube_LT.SetFilter("Index 2", PlanView_PT."Index 2");
        PlanCube_LT.SetFilter("Index 3", PlanView_PT."Index 3");
        PlanCube_LT.SetFilter("Index 4", PlanView_PT."Index 4");
        PlanCube_LT.SetFilter("Index 5", PlanView_PT."Index 5");
        PlanCube_LT.SetFilter("Index 6", PlanView_PT."Index 6");
        PlanCube_LT.ModifyAll(Fixed, PlanView_PT.Fixed);


        //### übergeordnete Viewzeilen auf Korrektheit prüfen und ggf. Fixieren/Fixierung aufheben:
        SetFixedLinesOnUpperLevels(PlanView_PT);

        Window_L.Close();
    end;

    /// <summary>
    /// SetFixedLinesOnUpperLevels.
    /// </summary>
    /// <param name="PlanView_PT">Record "BET FN Planning View".</param>
    procedure SetFixedLinesOnUpperLevels(PlanView_PT: Record "BET FN Planning View")
    var
        PlanView_LT: Record "BET FN Planning View";
        AllFixed_L: Boolean;
    begin
        //### rekursives Prüfen und Korrigieren von Fixiert-Kennzeichen auf übergeordneten Ebenen:

        //### Abbruch bei Gesamtebene:
        if PlanView_PT."Planning Document Level" = 0 then
            exit;

        //### sind alle Elemente der aktuellen Ebene fixiert:
        PlanView_LT.Reset();
        PlanView_LT.SetCurrentKey("Planning Document No.", "Planning Document Level", "Index 1", "Index 2", "Index 3", "Index 4", "Index 5", "Index 6", Date);
        PlanView_LT.SetRange("Planning Document No.", PlanView_PT."Planning Document No.");
        PlanView_LT.SetRange("Planning Document Level", PlanView_PT."Planning Document Level");
        PlanView_LT.SetRange(Date, 0D);
        if PlanView_PT."Planning Document Level" > 1 then
            PlanView_LT.SetRange("Index 1", PlanView_PT."Index 1");
        if PlanView_PT."Planning Document Level" > 2 then
            PlanView_LT.SetRange("Index 2", PlanView_PT."Index 2");
        if PlanView_PT."Planning Document Level" > 3 then
            PlanView_LT.SetRange("Index 3", PlanView_PT."Index 3");
        if PlanView_PT."Planning Document Level" > 4 then
            PlanView_LT.SetRange("Index 4", PlanView_PT."Index 4");
        if PlanView_PT."Planning Document Level" > 5 then
            PlanView_LT.SetRange("Index 5", PlanView_PT."Index 5");
        if PlanView_PT."Planning Document Level" > 6 then
            PlanView_LT.SetRange("Index 6", PlanView_PT."Index 6");
        PlanView_LT.SetRange(Fixed, false);
        AllFixed_L := PlanView_LT.IsEmpty();


        //### Elternzeile prüfen und ggf. korrigieren:
        PlanView_LT.SetRange(Fixed);
        PlanView_LT.SetRange("Planning Document Level", PlanView_PT."Planning Document Level" - 1);
        PlanView_LT.FindFirst();
        if PlanView_LT.Fixed <> AllFixed_L then begin
            PlanView_LT.Fixed := AllFixed_L;
            PlanView_LT.Modify();
            SetFixedLinesOnUpperLevels(PlanView_LT);    //### weiter nach oben
        end;
    end;

    /// <summary>
    /// CheckActualLine.
    /// </summary>
    /// <param name="PlanDoc_PT">Record "BET FN Planning Document".</param>
    /// <param name="Date_P">Date.</param>
    /// <returns>Return value of type Boolean.</returns>
    [Obsolete('#35131 Pending removal - procedure will be removed in future', '25.2')]

    procedure CheckActualLine(PlanDoc_PT: Record "BET FN Planning Document"; Date_P: Date): Boolean
    begin
    end;

    /// <summary>
    /// InitCaptionArrayRefValues.
    /// </summary>
    /// <param name="CaptionArray_R">VAR array[100] of Text[50].</param>
    /// <param name="PlanDoc_PT">Record "BET FN Planning Document".</param>
    procedure InitCaptionArrayRefValues(var CaptionArray_R: array[100] of Text[50]; PlanDoc_PT: Record "BET FN Planning Document")
    begin
        Clear(CaptionArray_R);

        begin
            CaptionArray_R[1] := '1,5,,' + 'Vorjahr VK Umsatz';
            //CaptionArray_R[2] := '1,5,,' + 'Vorjahr VK Teuerung %';
            CaptionArray_R[3] := '1,5,,' + 'Vorjahr VK Umsatz mit Rabatt';
            CaptionArray_R[4] := '1,5,,' + 'Vorjahr VK Umsatz Rabatt';
            CaptionArray_R[5] := '1,5,,' + 'Vorjahr VK Umsatz Rabatt %';
            CaptionArray_R[6] := '1,5,,' + 'Vorjahr VK Anfangsbestand';
            CaptionArray_R[7] := '1,5,,' + 'Vorjahr VK Endbestand';
            CaptionArray_R[8] := '1,5,,' + 'Vorjahr VK Lageränderung';
            CaptionArray_R[9] := '1,5,,' + 'Vorjahr VK BPA';
            CaptionArray_R[10] := '1,5,,' + 'Vorjahr VK BPA %';
            CaptionArray_R[11] := '1,5,,' + 'Vorjahr VK WE (Limit)';
            CaptionArray_R[12] := '1,5,,' + 'Vorjahr VK DS-Bestand';
            CaptionArray_R[13] := '1,5,,' + 'Vorjahr Menge Umsatz';
            CaptionArray_R[14] := '1,5,,' + 'Vorjahr Menge Umsatz Entw. %';
            CaptionArray_R[15] := '1,5,,' + 'Vorjahr Menge Anfangsbestand';
            CaptionArray_R[16] := '1,5,,' + 'Vorjahr Menge Endbestand';
            CaptionArray_R[17] := '1,5,,' + 'Vorjahr Menge Lageränderung';
            CaptionArray_R[18] := '1,5,,' + 'Vorjahr Menge Endbestand %';
            CaptionArray_R[19] := '1,5,,' + 'Vorjahr Menge WE (Limit)';
            CaptionArray_R[20] := '1,5,,' + 'Vorjahr Menge DS-Bestand';
            CaptionArray_R[21] := '1,5,,' + 'Vorjahr EK Umsatz';
            //CaptionArray_R[22] := '1,5,,' + 'Vorjahr EK Teuerung %';
            CaptionArray_R[23] := '1,5,,' + 'Vorjahr EK Anfangsbestand';
            CaptionArray_R[24] := '1,5,,' + 'Vorjahr EK Endbestand';
            CaptionArray_R[25] := '1,5,,' + 'Vorjahr EK Lageränderung';
            CaptionArray_R[26] := '1,5,,' + 'Vorjahr EK WE (Limit)';
            CaptionArray_R[27] := '1,5,,' + 'Vorjahr EK DS-Bestand';
            CaptionArray_R[28] := '1,5,,' + 'Vorjahr d.VKP Umsatz';
            CaptionArray_R[29] := '1,5,,' + 'Vorjahr d.VKP Umsatz mit PÄ';
            CaptionArray_R[30] := '1,5,,' + 'Vorjahr d.VKP WE (Limit)';
            CaptionArray_R[31] := '1,5,,' + 'Vorjahr d.VKP Anfangsbestand';
            CaptionArray_R[32] := '1,5,,' + 'Vorjahr d.VKP Endbestand';
            CaptionArray_R[33] := '1,5,,' + 'Vorjahr d.EKP Umsatz';
            CaptionArray_R[34] := '1,5,,' + 'Vorjahr d.EKP WE (Limit)';
            CaptionArray_R[35] := '1,5,,' + 'Vorjahr d.EKP Anfangsbestand';
            CaptionArray_R[36] := '1,5,,' + 'Vorjahr d.EKP Endbestand';
            CaptionArray_R[37] := '1,5,,' + 'Vorjahr LUG';
            CaptionArray_R[38] := '1,5,,' + 'Vorjahr Sp% Umsatz';
            CaptionArray_R[39] := '1,5,,' + 'Vorjahr Sp% Umsatz mit PÄ';
            CaptionArray_R[40] := '1,5,,' + 'Vorjahr Sp% WE (Limit)';
            CaptionArray_R[41] := '1,5,,' + 'Vorjahr Sp% Anfangsbestand';
            CaptionArray_R[42] := '1,5,,' + 'Vorjahr Sp% Endbestand';
            CaptionArray_R[43] := '1,5,,' + 'Vorjahr Menge off. Best.';
            CaptionArray_R[44] := '1,5,,' + 'Vorjahr VK off. Best.';
            CaptionArray_R[45] := '1,5,,' + 'Vorjahr EK off. Best.';
            CaptionArray_R[46] := '1,5,,';
            CaptionArray_R[47] := '1,5,,';
        end;
    end;


    /// <summary>
    /// ChangeLevel.
    /// </summary>
    /// <param name="Direction_P">Integer.</param>
    /// <param name="CurrentView_PT">VAR Record "BET FN Planning View".</param>
    /// <param name="PlanView_RT">VAR Record "BET FN Planning View".</param>
    /// <param name="PlanDoc_PT">Record "BET FN Planning Document".</param>
    /// <param name="IndexFilter1_R">VAR Text[1024].</param>
    /// <param name="IndexFilter2_R">VAR Text[1024].</param>
    /// <param name="IndexFilter3_R">VAR Text[1024].</param>
    /// <param name="IndexFilter4_R">VAR Text[1024].</param>
    /// <param name="IndexFilter5_R">VAR Text[1024].</param>
    /// <param name="IndexFilter6_R">VAR Text[1024].</param>
    /// <param name="DateFilterActivated_R">VAR Boolean.</param>
    /// <param name="DateFilter_P">Text[1024].</param>
    /// <param name="QuickAccess_R">VAR Option " ",Date,Index1,Index2,Index3,Index4,Index5,Index6.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure ChangeLevel(Direction_P: Integer; var CurrentView_PT: Record "BET FN Planning View"; var PlanView_RT: Record "BET FN Planning View"; PlanDoc_PT: Record "BET FN Planning Document"; var IndexFilter1_R: Text[1024]; var IndexFilter2_R: Text[1024]; var IndexFilter3_R: Text[1024]; var IndexFilter4_R: Text[1024]; var IndexFilter5_R: Text[1024]; var IndexFilter6_R: Text[1024]; var DateFilterActivated_R: Boolean; DateFilter_P: Text; var QuickAccess_R: Option " ",Date,Index1,Index2,Index3,Index4,Index5,Index6): Boolean
    var
        PlanDocLevel_LT: Record "BET FN Planning Document Level";
        DocNo_L: Code[20];
        Vert_L: Integer;
    begin
        //### Ebene wechseln
        //### Direction_P:
        //### -1 : Ebene runter
        //###  1 : Ebene hoch

        CurrentView_PT.FilterGroup(2);

        //### aktuelle Ebene und deren Elternebene ermitteln
        Evaluate(DocNo_L, CurrentView_PT.GetFilter("Planning Document No."));
        Evaluate(Vert_L, CurrentView_PT.GetFilter("Planning Document Level"));

        PlanDocLevel_LT.Get(DocNo_L, Vert_L);

        PlanView_RT.Reset();
        PlanView_RT.SetCurrentKey("Planning Document No.", "Planning Document Level", "Index 1", "Index 2", "Index 3", "Index 4", "Index 5", "Index 6", Date);

        PlanView_RT.FilterGroup(2);
        PlanView_RT.SetRange("Planning Document No.", DocNo_L);

        PlanView_RT.SetRange("Planning Document Level", Vert_L);

        if CurrentView_PT."Planning Document Level" > 0 then
            PlanView_RT.SetFilter("Index 1", IndexFilter1_R);
        if CurrentView_PT."Planning Document Level" > 1 then
            PlanView_RT.SetFilter("Index 2", IndexFilter2_R);
        if CurrentView_PT."Planning Document Level" > 2 then
            PlanView_RT.SetFilter("Index 3", IndexFilter3_R);
        if CurrentView_PT."Planning Document Level" > 3 then
            PlanView_RT.SetFilter("Index 4", IndexFilter4_R);
        if CurrentView_PT."Planning Document Level" > 4 then
            PlanView_RT.SetFilter("Index 5", IndexFilter5_R);
        if CurrentView_PT."Planning Document Level" > 5 then
            PlanView_RT.SetFilter("Index 6", IndexFilter6_R);

        case Direction_P of
            1:
                //### nächsthöhere Ebene
                begin
                    PlanView_RT.SetRange("Planning Document Level", Vert_L - Direction_P);

                    //### autom. Filterung bei Ebenenwechsel
                    if PlanDoc_PT."Auto Filter On Level Changing" then
                        case CurrentView_PT."Planning Document Level" of
                            1:
                                begin
                                    Clear(IndexFilter1_R);
                                    PlanView_RT.SetRange("Index 1");
                                end;
                            2:
                                if not DateFilterActivated_R then begin
                                    Clear(IndexFilter1_R);
                                    PlanView_RT.SetRange("Index 1");
                                    Clear(IndexFilter2_R);
                                    PlanView_RT.SetRange("Index 2");
                                end else begin
                                    Clear(IndexFilter2_R);
                                    PlanView_RT.SetRange("Index 2");
                                end;
                            3:
                                if not DateFilterActivated_R then begin
                                    Clear(IndexFilter2_R);
                                    PlanView_RT.SetRange("Index 2");
                                    Clear(IndexFilter3_R);
                                    PlanView_RT.SetRange("Index 3");
                                end else begin
                                    Clear(IndexFilter3_R);
                                    PlanView_RT.SetRange("Index 3");
                                end;
                            4:
                                if not DateFilterActivated_R then begin
                                    Clear(IndexFilter3_R);
                                    PlanView_RT.SetRange("Index 3");
                                    Clear(IndexFilter4_R);
                                    PlanView_RT.SetRange("Index 4");
                                end else begin
                                    Clear(IndexFilter4_R);
                                    PlanView_RT.SetRange("Index 4");
                                end;
                            5:
                                if not DateFilterActivated_R then begin
                                    Clear(IndexFilter4_R);
                                    PlanView_RT.SetRange("Index 4");
                                    Clear(IndexFilter5_R);
                                    PlanView_RT.SetRange("Index 5");
                                end else begin
                                    Clear(IndexFilter5_R);
                                    PlanView_RT.SetRange("Index 5");
                                end;
                            6:
                                begin
                                    Clear(IndexFilter5_R);
                                    PlanView_RT.SetRange("Index 5");
                                    Clear(IndexFilter6_R);
                                    PlanView_RT.SetRange("Index 6");
                                end;
                        end
                    else begin

                        //### alte Filter verwerfen
                        if CurrentView_PT."Planning Document Level" < 2 then begin
                            IndexFilter1_R := '';
                            PlanView_RT.SetRange("Index 1");
                            if QuickAccess_R = 2 then
                                QuickAccess_R := QuickAccess_R::" ";
                        end;
                        if CurrentView_PT."Planning Document Level" < 3 then begin
                            IndexFilter2_R := '';
                            PlanView_RT.SetRange("Index 2");
                            if QuickAccess_R = 3 then
                                QuickAccess_R := QuickAccess_R::" ";
                        end;
                        if CurrentView_PT."Planning Document Level" < 4 then begin
                            IndexFilter3_R := '';
                            PlanView_RT.SetRange("Index 3");
                            if QuickAccess_R = 4 then
                                QuickAccess_R := QuickAccess_R::" ";
                        end;
                        if CurrentView_PT."Planning Document Level" < 5 then begin
                            IndexFilter4_R := '';
                            PlanView_RT.SetRange("Index 4");
                            if QuickAccess_R = 5 then
                                QuickAccess_R := QuickAccess_R::" ";
                        end;
                        if CurrentView_PT."Planning Document Level" < 6 then begin
                            IndexFilter5_R := '';
                            PlanView_RT.SetRange("Index 5");
                            if QuickAccess_R = 6 then
                                QuickAccess_R := QuickAccess_R::" ";
                        end;
                        if CurrentView_PT."Planning Document Level" < 7 then begin
                            IndexFilter6_R := '';
                            PlanView_RT.SetRange("Index 6");
                            if QuickAccess_R = 7 then
                                QuickAccess_R := QuickAccess_R::" ";
                        end;
                    end;

                    PlanView_RT.SetRange("Planning Document Level", Vert_L - Direction_P);

                    //### ist die Ebene eine Datumsebene, dann wird der Datumsfilter übergeben
                    //### (alle Ebenen sind immer entweder mit Datum oder alle ohne Datum)
                    if DateFilterActivated_R then
                        if PlanDocLevel_LT."Activate Date Level" then
                            PlanView_RT.SetFilter(Date, '<>%1', 0D)
                        else begin
                            DateFilterActivated_R := false;
                            PlanView_RT.SetRange(Date, 0D);
                        end
                    else
                        PlanView_RT.SetRange(Date, 0D);
                end;
            0:
                //### Start
                if DateFilterActivated_R then
                    if DateFilter_P <> '' then
                        PlanView_RT.SetFilter(Date, DateFilter_P)
                    else
                        PlanView_RT.SetFilter(Date, '<>%1', 0D)
                else
                    PlanView_RT.SetRange(Date, 0D)
            else begin   //### drunterliegende Ebene

                //### autom. Filterung
                if PlanDoc_PT."Auto Filter On Level Changing" then begin
                    PlanView_RT.SetFilter("Index 1", CurrentView_PT."Index 1");
                    PlanView_RT.SetFilter("Index 2", CurrentView_PT."Index 2");
                    PlanView_RT.SetFilter("Index 3", CurrentView_PT."Index 3");
                    PlanView_RT.SetFilter("Index 4", CurrentView_PT."Index 4");
                    PlanView_RT.SetFilter("Index 5", CurrentView_PT."Index 5");
                    PlanView_RT.SetFilter("Index 6", CurrentView_PT."Index 6");
                    IndexFilter1_R := CurrentView_PT."Index 1";
                    IndexFilter2_R := CurrentView_PT."Index 2";
                    IndexFilter3_R := CurrentView_PT."Index 3";
                    IndexFilter4_R := CurrentView_PT."Index 4";
                    IndexFilter5_R := CurrentView_PT."Index 5";
                    IndexFilter6_R := CurrentView_PT."Index 6";
                end;

                PlanView_RT.SetRange("Planning Document Level", Vert_L - Direction_P);

                //### ist die Ebene eine Datumsebene, dann wird der Datumsfilter übergeben
                //### (alle Ebenen sind immer entweder mit Datum oder alle ohne Datum)
                if DateFilterActivated_R then
                    if PlanDocLevel_LT."Activate Date Level" then
                        PlanView_RT.SetFilter(Date, '<>%1', 0D)
                    else begin
                        DateFilterActivated_R := false;
                        PlanView_RT.SetRange(Date, 0D);
                    end
                else
                    PlanView_RT.SetRange(Date, 0D);
            end;
        end;
        // ### nur, wenn es auch wirklich diese Ebene gibt, werden die Filter auch gesetzt, damit
        // ### sparen wir uns das Zurücksetzen im Fehlerfall
        if PlanView_RT.FindFirst() then begin
            PlanView_RT.CopyFilter("Planning Document No.", CurrentView_PT."Planning Document No.");
            PlanView_RT.CopyFilter("Planning Document Level", CurrentView_PT."Planning Document Level");
            PlanView_RT.CopyFilter("Index 1", CurrentView_PT."Index 1");
            PlanView_RT.CopyFilter("Index 2", CurrentView_PT."Index 2");
            PlanView_RT.CopyFilter("Index 3", CurrentView_PT."Index 3");
            PlanView_RT.CopyFilter("Index 4", CurrentView_PT."Index 4");
            PlanView_RT.CopyFilter("Index 5", CurrentView_PT."Index 5");
            PlanView_RT.CopyFilter("Index 6", CurrentView_PT."Index 6");
            PlanView_RT.CopyFilter(Date, CurrentView_PT.Date);
            //PlanDocLevel_LT.Get(PlanView_RT."Planning Document No.", PlanView_RT."Planning Document Level vert.");
        end else
            // Error(Text001);
            Error('Filter:\ %1', PlanView_RT.GetFilters());

        PlanView_RT.FilterGroup(0);
        CurrentView_PT.FilterGroup(0);

        exit(true);
    end;

    /// <summary>
    /// ShowDim.
    /// </summary>
    /// <param name="DocNo_P">Code[20].</param>
    /// <param name="Level_P">Integer.</param>
    /// <param name="IndexCaption_R">VAR array[6] of Text[50].</param>
    procedure ShowDim(DocNo_P: Code[20]; Level_P: Integer; var IndexCaption_R: array[6] of Text[50])
    begin
        //### dynamische Captions der Indexspalten:
        IndexCaption_R[1] := '13,' + DocNo_P + ',' + Format(Level_P) + ',1';
        IndexCaption_R[2] := '13,' + DocNo_P + ',' + Format(Level_P) + ',2';
        IndexCaption_R[3] := '13,' + DocNo_P + ',' + Format(Level_P) + ',3';
        IndexCaption_R[4] := '13,' + DocNo_P + ',' + Format(Level_P) + ',4';
        IndexCaption_R[5] := '13,' + DocNo_P + ',' + Format(Level_P) + ',5';
        IndexCaption_R[6] := '13,' + DocNo_P + ',' + Format(Level_P) + ',6';
    end;

    /// <summary>
    /// UpdateFilterText.
    /// </summary>
    /// <param name="FilterText_R">VAR Text[1024].</param>
    /// <param name="IndexTextArray_P">array[10] of Text.</param>
    /// <param name="IndexFilterArray_P">array[10] of Text.</param>
    /// <param name="DateText_P">Text.</param>
    /// <param name="DateFilter_P">Text.</param>
    /// <param name="DateFilterActivated_P">Boolean.</param>
    procedure UpdateFilterText(var FilterText_R: Text[1024]; IndexTextArray_P: array[10] of Text; IndexFilterArray_P: array[10] of Text; DateText_P: Text; DateFilter_P: Text; DateFilterActivated_P: Boolean)
    begin
        //### Anzeige der Filtereinstellungen
        FilterText_R := '';

        if IndexFilterArray_P[1] <> '' then
            FilterText_R := CopyStr(FilterText_R + ' ' + IndexTextArray_P[1] + ': ' + IndexFilterArray_P[1] + ';', 1, 1024);
        if IndexFilterArray_P[2] <> '' then
            FilterText_R := CopyStr(FilterText_R + ' ' + IndexTextArray_P[2] + ': ' + IndexFilterArray_P[2] + ';', 1, 1024);
        if IndexFilterArray_P[3] <> '' then
            FilterText_R := CopyStr(FilterText_R + ' ' + IndexTextArray_P[3] + ': ' + IndexFilterArray_P[3] + ';', 1, 1024);
        if IndexFilterArray_P[4] <> '' then
            FilterText_R := CopyStr(FilterText_R + ' ' + IndexTextArray_P[4] + ': ' + IndexFilterArray_P[4] + ';', 1, 1024);
        if IndexFilterArray_P[5] <> '' then
            FilterText_R := CopyStr(FilterText_R + ' ' + IndexTextArray_P[5] + ': ' + IndexFilterArray_P[5] + ';', 1, 1024);
        if IndexFilterArray_P[6] <> '' then
            FilterText_R := CopyStr(FilterText_R + ' ' + IndexTextArray_P[6] + ': ' + IndexFilterArray_P[6] + ';', 1, 1024);

        if (DateFilter_P <> '') and DateFilterActivated_P then
            FilterText_R := CopyStr(FilterText_R + ' ' + DateText_P + ': ' + DateFilter_P + ';', 1, 1024);
    end;

    /// <summary>
    /// UpdateLevelText.
    /// </summary>
    /// <param name="LevelText_R">VAR Text.</param>
    /// <param name="IndexTextArray_P">array[10] of Text.</param>
    /// <param name="DateFilterActivated_P">Boolean.</param>
    /// <param name="QuickAccess_P">Option " ",Date,Index1,Index2,Index3,Index4,Index5,Index6.</param>
    /// <param name="DateText_P">Text.</param>
    procedure UpdateLevelText(var LevelText_R: Text; IndexTextArray_P: array[10] of Text; DateFilterActivated_P: Boolean; QuickAccess_P: Option " ",Date,Index1,Index2,Index3,Index4,Index5,Index6; DateText_P: Text)
    var
        TotalLbl: Label 'Total';
    begin
        //### Anzeige der aktuellen Ebene (inkl. Schnellzugriff):

        LevelText_R := '';
        LevelText_R += TotalLbl;
        if (IndexTextArray_P[1] <> '') or DateFilterActivated_P then
            LevelText_R += ', ';

        if QuickAccess_P = QuickAccess_P::Index1 then
            LevelText_R += '*';
        if IndexTextArray_P[1] <> '' then
            LevelText_R := CopyStr(LevelText_R + IndexTextArray_P[1] + ', ', 1, 1024);

        if QuickAccess_P = QuickAccess_P::Index2 then
            LevelText_R += '*';
        if IndexTextArray_P[2] <> '' then
            LevelText_R := CopyStr(LevelText_R + IndexTextArray_P[2] + ', ', 1, 1024);

        if QuickAccess_P = QuickAccess_P::Index3 then
            LevelText_R += '*';
        if IndexTextArray_P[3] <> '' then
            LevelText_R := CopyStr(LevelText_R + IndexTextArray_P[3] + ', ', 1, 1024);

        if QuickAccess_P = QuickAccess_P::Index4 then
            LevelText_R += '*';
        if IndexTextArray_P[4] <> '' then
            LevelText_R := CopyStr(LevelText_R + IndexTextArray_P[4] + ', ', 1, 1024);

        if QuickAccess_P = QuickAccess_P::Index5 then
            LevelText_R += '*';
        if IndexTextArray_P[5] <> '' then
            LevelText_R := CopyStr(LevelText_R + IndexTextArray_P[5] + ', ', 1, 1024);

        if QuickAccess_P = QuickAccess_P::Index6 then
            LevelText_R += '*';
        if IndexTextArray_P[6] <> '' then
            LevelText_R := CopyStr(LevelText_R + IndexTextArray_P[6] + ', ', 1, 1024);

        if QuickAccess_P = QuickAccess_P::Date then
            LevelText_R += '*';
        if DateFilterActivated_P then
            LevelText_R := CopyStr(LevelText_R + DateText_P + ', ', 1, 1024);

        LevelText_R := DelChr(LevelText_R, '>', ' ');
        LevelText_R := DelChr(LevelText_R, '>', ',');
        LevelText_R := DelChr(LevelText_R, '>', ' ');
        LevelText_R := DelChr(LevelText_R, '>', ';');
    end;

    /// <summary>
    /// SetCurrentFiltersToRec.
    /// </summary>
    /// <param name="PlanView_RT">VAR Record "BET FN Planning View".</param>
    /// <param name="IndexFilterArray_P">array[10] of Text.</param>
    /// <param name="DateFilterActivated_P">Boolean.</param>
    /// <param name="DateFilter_P">Text.</param>
    procedure SetCurrentFiltersToRec(var PlanView_RT: Record "BET FN Planning View"; IndexFilterArray_P: array[10] of Text; DateFilterActivated_P: Boolean; DateFilter_P: Text)
    var
        PlanDocLevelBuffer_LT: Record "BET FN Planning Doc Lvl Buf";
    begin

        PlanView_RT.FilterGroup(2);

        //### Prüfen, ob IndexFilterX ein einzelnes Element oder ein zusammengesetzter Filter ist!
        //### (wegen Marken mit Sonderzeichen (Klammern, Kaufmanns-Und), etc.)
        PlanDocLevelBuffer_LT.Reset();
        PlanDocLevelBuffer_LT.SetRange("Planning Document No.", PlanView_RT."Planning Document No.");
        PlanDocLevelBuffer_LT.SetRange("Planning Document Level", PlanView_RT."Planning Document Level");

        //### Index 1
        PlanDocLevelBuffer_LT.SetRange("Index Code", CopyStr(IndexFilterArray_P[1], 1, 20));
        if PlanDocLevelBuffer_LT.FindFirst() then
            PlanView_RT.SetRange("Index 1", IndexFilterArray_P[1])
        else
            PlanView_RT.SetFilter("Index 1", IndexFilterArray_P[1]);

        //### Index 2
        PlanDocLevelBuffer_LT.SetRange("Index Code", CopyStr(IndexFilterArray_P[2], 1, 20));
        if PlanDocLevelBuffer_LT.FindFirst() then
            PlanView_RT.SetRange("Index 2", IndexFilterArray_P[2])
        else
            PlanView_RT.SetFilter("Index 2", IndexFilterArray_P[2]);

        //### Index 3
        PlanDocLevelBuffer_LT.SetRange("Index Code", CopyStr(IndexFilterArray_P[3], 1, 20));
        if PlanDocLevelBuffer_LT.FindFirst() then
            PlanView_RT.SetRange("Index 3", IndexFilterArray_P[3])
        else
            PlanView_RT.SetFilter("Index 3", IndexFilterArray_P[3]);

        //### Index 4
        PlanDocLevelBuffer_LT.SetRange("Index Code", CopyStr(IndexFilterArray_P[4], 1, 20));
        if PlanDocLevelBuffer_LT.FindFirst() then
            PlanView_RT.SetRange("Index 4", IndexFilterArray_P[4])
        else
            PlanView_RT.SetFilter("Index 4", IndexFilterArray_P[4]);

        //### Index 5
        PlanDocLevelBuffer_LT.SetRange("Index Code", CopyStr(IndexFilterArray_P[5], 1, 20));
        if PlanDocLevelBuffer_LT.FindFirst() then
            PlanView_RT.SetRange("Index 5", IndexFilterArray_P[5])
        else
            PlanView_RT.SetFilter("Index 5", IndexFilterArray_P[5]);

        //### Index 6
        PlanDocLevelBuffer_LT.SetRange("Index Code", CopyStr(IndexFilterArray_P[6], 1, 20));
        if not PlanDocLevelBuffer_LT.IsEmpty() then
            PlanView_RT.SetRange("Index 6", IndexFilterArray_P[6])
        else
            PlanView_RT.SetFilter("Index 6", IndexFilterArray_P[6]);


        if DateFilterActivated_P then begin
            if DateFilter_P <> '' then
                PlanView_RT.SetFilter(Date, DateFilter_P)
            else
                PlanView_RT.SetFilter(Date, '<>%1', 0D)
        end else
            PlanView_RT.SetRange(Date, 0D);

        PlanView_RT.FilterGroup(0);
    end;

    /// <summary>
    /// SetQuickAccessFilter.
    /// </summary>
    /// <param name="PlanView_PT">Record "BET FN Planning View".</param>
    /// <param name="QuickAccess_P">Option " ",Date,Index1,Index2,Index3,Index4,Index5,Index6.</param>
    /// <param name="Direction_P">Integer.</param>
    /// <param name="IndexFilterArray_R">VAR array[10] of Text.</param>
    /// <param name="DateFilter_R">VAR Text.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure SetQuickAccessFilter(PlanView_PT: Record "BET FN Planning View"; QuickAccess_P: Option " ",Date,Index1,Index2,Index3,Index4,Index5,Index6; Direction_P: Integer; var IndexFilterArray_R: array[10] of Text; var DateFilter_R: Text): Boolean
    var
        PlanView_LT: Record "BET FN Planning View";
    begin
        // if PlanFunctions_LC.SetQuickAccessFilter(Rec, QuickAccess_G, Direction_P, IndexFilterArray_G, DateFilter_G) then ...

        PlanView_LT.Reset();
        PlanView_LT.SetCurrentKey("Planning Document No.", "Planning Document Level", "Index 1", "Index 2", "Index 3", "Index 4", "Index 5", "Index 6", Date);

        PlanView_LT.SetRange("Planning Document No.", PlanView_PT."Planning Document No.");
        PlanView_LT.SetRange("Planning Document Level", PlanView_PT."Planning Document Level");

        PlanView_PT.FilterGroup(2);
        if PlanView_PT.GetFilter("Index 1") <> '' then
            PlanView_LT.SetFilter("Index 1", PlanView_PT.GetFilter("Index 1"));
        if PlanView_PT.GetFilter("Index 2") <> '' then
            PlanView_LT.SetRange("Index 2", PlanView_PT.GetFilter("Index 2"));
        if PlanView_PT.GetFilter("Index 3") <> '' then
            PlanView_LT.SetRange("Index 3", PlanView_PT.GetFilter("Index 3"));
        if PlanView_PT.GetFilter("Index 4") <> '' then
            PlanView_LT.SetRange("Index 4", PlanView_PT.GetFilter("Index 4"));
        if PlanView_PT.GetFilter("Index 5") <> '' then
            PlanView_LT.SetRange("Index 5", PlanView_PT.GetFilter("Index 5"));
        if PlanView_PT.GetFilter("Index 6") <> '' then
            PlanView_LT.SetRange("Index 6", PlanView_PT.GetFilter("Index 6"));

        if PlanView_PT.GetFilter(Date) <> '' then
            PlanView_LT.SetFilter(Date, PlanView_PT.GetFilter(Date));
        PlanView_PT.FilterGroup(0);

        if PlanView_LT.IsEmpty() then
            exit(false);

        case QuickAccess_P of
            QuickAccess_P::" ":
                exit(false);


            QuickAccess_P::Index1:
                begin
                    case Direction_P of
                        1:
                            begin
                                PlanView_LT.SetFilter("Index 1", '>%1', PlanView_PT."Index 1");    // ### nächst größeres Element
                                if not PlanView_LT.FindFirst() then begin
                                    PlanView_LT.SetFilter("Index 1", '<%1', PlanView_PT."Index 1");    // ### wenn kein weiteres Element ex., wieder mit 1. anfangen
                                    PlanView_LT.FindFirst();
                                end;
                            end;
                        -1:
                            begin
                                PlanView_LT.SetFilter("Index 1", '<%1', PlanView_PT."Index 1");
                                if not PlanView_LT.FindLast() then begin
                                    PlanView_LT.SetFilter("Index 1", '>%1', PlanView_PT."Index 1");  // ### wenn kein vorh. Element ex., mit letztem weitermachen
                                    PlanView_LT.FindLast();
                                end;
                            end;
                    end;
                    IndexFilterArray_R[1] := PlanView_LT."Index 1";
                end;


            QuickAccess_P::Index2:
                begin
                    case Direction_P of
                        1:
                            begin
                                PlanView_LT.SetFilter("Index 2", '>%1', PlanView_PT."Index 2");    // ### nächst größeres Element
                                if not PlanView_LT.FindFirst() then begin
                                    PlanView_LT.SetFilter("Index 2", '<%1', PlanView_PT."Index 2");    // ### wenn kein weiteres Element ex., wieder mit 1. anfangen
                                    PlanView_LT.FindFirst();
                                end;
                            end;
                        -1:
                            begin
                                PlanView_LT.SetFilter("Index 2", '<%1', PlanView_PT."Index 2");
                                if not PlanView_LT.FindLast() then begin
                                    PlanView_LT.SetFilter("Index 2", '>%1', PlanView_PT."Index 2");  // ### wenn kein vorh. Element ex., mit letztem weitermachen
                                    PlanView_LT.FindLast();
                                end;
                            end;
                    end;
                    IndexFilterArray_R[2] := PlanView_LT."Index 2";
                end;


            QuickAccess_P::Index3:
                begin
                    case Direction_P of
                        1:
                            begin
                                PlanView_LT.SetFilter("Index 3", '>%1', PlanView_PT."Index 3");    // ### nächst größeres Element
                                if not PlanView_LT.FindFirst() then begin
                                    PlanView_LT.SetFilter("Index 3", '<%1', PlanView_PT."Index 3");    // ### wenn kein weiteres Element ex., wieder mit 1. anfangen
                                    PlanView_LT.FindFirst();
                                end;
                            end;
                        -1:
                            begin
                                PlanView_LT.SetFilter("Index 3", '<%1', PlanView_PT."Index 3");
                                if not PlanView_LT.FindLast() then begin
                                    PlanView_LT.SetFilter("Index 3", '>%1', PlanView_PT."Index 3");  // ### wenn kein vorh. Element ex., mit letztem weitermachen
                                    PlanView_LT.FindLast();
                                end;
                            end;
                    end;
                    IndexFilterArray_R[3] := PlanView_LT."Index 3";
                end;


            QuickAccess_P::Index4:
                begin
                    case Direction_P of
                        1:
                            begin
                                PlanView_LT.SetFilter("Index 4", '>%1', PlanView_PT."Index 4");    // ### nächst größeres Element
                                if not PlanView_LT.FindFirst() then begin
                                    PlanView_LT.SetFilter("Index 4", '<%1', PlanView_PT."Index 4");    // ### wenn kein weiteres Element ex., wieder mit 1. anfangen
                                    PlanView_LT.FindFirst();
                                end;
                            end;
                        -1:
                            begin
                                PlanView_LT.SetFilter("Index 4", '<%1', PlanView_PT."Index 4");
                                if not PlanView_LT.FindLast() then begin
                                    PlanView_LT.SetFilter("Index 4", '>%1', PlanView_PT."Index 4");  // ### wenn kein vorh. Element ex., mit letztem weitermachen
                                    PlanView_LT.FindLast();
                                end;
                            end;
                    end;
                    IndexFilterArray_R[4] := PlanView_LT."Index 4";
                end;


            QuickAccess_P::Index5:
                begin
                    case Direction_P of
                        1:
                            begin
                                PlanView_LT.SetFilter("Index 5", '>%1', PlanView_PT."Index 5");    // ### nächst größeres Element
                                if not PlanView_LT.FindFirst() then begin
                                    PlanView_LT.SetFilter("Index 5", '<%1', PlanView_PT."Index 5");    // ### wenn kein weiteres Element ex., wieder mit 1. anfangen
                                    PlanView_LT.FindFirst();
                                end;
                            end;
                        -1:
                            begin
                                PlanView_LT.SetFilter("Index 5", '<%1', PlanView_PT."Index 5");
                                if not PlanView_LT.FindLast() then begin
                                    PlanView_LT.SetFilter("Index 5", '>%1', PlanView_PT."Index 5");  // ### wenn kein vorh. Element ex., mit letztem weitermachen
                                    PlanView_LT.FindLast();
                                end;
                            end;
                    end;
                    IndexFilterArray_R[5] := PlanView_LT."Index 5";
                end;

            QuickAccess_P::Index6:
                begin
                    case Direction_P of
                        1:
                            begin
                                PlanView_LT.SetFilter("Index 6", '>%1', PlanView_PT."Index 6");    // ### nächst größeres Element
                                if not PlanView_LT.FindFirst() then begin
                                    PlanView_LT.SetFilter("Index 6", '<%1', PlanView_PT."Index 6");    // ### wenn kein weiteres Element ex., wieder mit 1. anfangen
                                    PlanView_LT.FindFirst();
                                end;
                            end;
                        -1:
                            begin
                                PlanView_LT.SetFilter("Index 6", '<%1', PlanView_PT."Index 6");
                                if not PlanView_LT.FindLast() then begin
                                    PlanView_LT.SetFilter("Index 6", '>%1', PlanView_PT."Index 6");  // ### wenn kein vorh. Element ex., mit letztem weitermachen
                                    PlanView_LT.FindLast();
                                end;
                            end;
                    end;
                    IndexFilterArray_R[6] := PlanView_LT."Index 6";
                end;

            QuickAccess_P::Date:
                begin
                    case Direction_P of
                        1:
                            begin
                                PlanView_LT.SetFilter(Date, '>%1', PlanView_PT.Date);    // ### nächst größeres Element
                                if not PlanView_LT.FindFirst() then begin
                                    PlanView_LT.SetFilter(Date, '<>%1', 0D);    // ### wenn kein weiteres Element ex., wieder mit 1. anfangen
                                    PlanView_LT.FindFirst();
                                end;
                            end;
                        -1:
                            begin
                                PlanView_LT.SetFilter(Date, '<%1 & <>%2', PlanView_PT.Date, 0D);
                                if not PlanView_LT.FindLast() then begin
                                    PlanView_LT.SetFilter(Date, '<>%1', 0D);  // ### wenn kein vorh. Element ex., mit letztem weitermachen
                                    PlanView_LT.FindLast();
                                end;
                            end;
                    end;
                    DateFilter_R := Format(PlanView_LT.Date);
                end;
        end;

        exit(true);
    end;

    /// <summary>
    /// CreateDateDescriptions.
    /// </summary>
    /// <param name="Date_RTT">Temporary VAR Record Date.</param>
    /// <param name="PlanDoc_PT">Record "BET FN Planning Document".</param>
    procedure CreateDateDescriptions(var Date_RTT: Record Date temporary; PlanDoc_PT: Record "BET FN Planning Document")
    var
        PlanDocDateRef_LT: Record "BET FN Planning Document D Ref";
        Date_LT: Record Date;
    begin
        //### Monatsbeschreibungen für optionale Anzeige im Planungsbeleg:
        Date_RTT.Reset();
        Date_RTT.DeleteAll();

        PlanDocDateRef_LT.Reset();
        PlanDocDateRef_LT.SetRange("Planning Document No.", PlanDoc_PT."No.");
        if PlanDocDateRef_LT.FindSet() then
            repeat
                Date_RTT.Init();
                Date_RTT."Period Type" := PlanDoc_PT."Date Unit";   // ?
                Date_RTT."Period Start" := PlanDocDateRef_LT.Date;  //### Datum für Referenzierung der Viewzeilen

                //### Monatsbeschreibungen ermitteln:
                if PlanDoc_PT."Date Unit" = PlanDoc_PT."Date Unit"::Month then begin
                    Date_LT.Reset();
                    Date_LT.SetRange("Period Type", Date_LT."Period Type"::Month);
                    Date_LT.SetRange("Period Start", PlanDocDateRef_LT.Date);
                    if Date_LT.FindFirst() then begin
                        Date_RTT."Period Name" := CopyStr(Date_LT."Period Name", 1, 3);     //### erste 3 Buchstaben des Monatsnamens
                        Date_RTT."Period Name" := CopyStr(Date_RTT."Period Name" + ' - ' + Format(Date2DMY(PlanDocDateRef_LT.Date, 3)), 1, MaxStrLen(Date_RTT."Period Name"));   //### + Jahreszahl
                    end;
                end;
                Date_RTT.Insert();
            until PlanDocDateRef_LT.Next() = 0;
    end;

    /// <summary>
    /// DeletePlanningEntries.
    /// </summary>
    /// <param name="DocNo_P">Code[20].</param>
    procedure DeletePlanningEntries(DocNo_P: Code[20])
    var
        PlanningEntry_LT: Record "BET FN Planning Entry (DWH)";
        Window_L: Dialog;
        DeletePlanningEntriesLbl: Label 'Deleting Planning Entries...';
    begin
        //### Löschen der Planungsposten (z.B. bei Rücksetzen oder Löschen der Belege)
        PlanningEntry_LT.Reset();
        PlanningEntry_LT.SetCurrentKey("Planning Document No.");
        PlanningEntry_LT.SetRange("Planning Document No.", DocNo_P);
        if not PlanningEntry_LT.IsEmpty() then begin
            Window_L.Open(DeletePlanningEntriesLbl);
            PlanningEntry_LT.DeleteAll();
            Window_L.Close();
        end;
    end;

    /// <summary>
    /// CreateTempBufferSelection.
    /// </summary>
    /// <param name="PlanView_PT">VAR Record "BET FN Planning View".</param>
    /// <param name="PlanBuffer_RTT">Temporary VAR Record "BET FN Planning Doc Lvl Buf".</param>
    procedure CreateTempBufferSelection(var PlanView_PT: Record "BET FN Planning View"; var PlanBuffer_RTT: Record "BET FN Planning Doc Lvl Buf" temporary)
    var
        Buffer_LT: Record "BET FN Planning Doc Lvl Buf";
        PlanView_LT: Record "BET FN Planning View";
        IndexCode_L: Code[20];
    begin
        //### gibt für eine Viewzeile eine temp. Buffertabelle zurück, in der alle gefilterten Ebenenelemente
        //### der gleichen Ebene (außer aktueller Zeile) enthalten sind (wird für Kopierfunktion benötigt)

        PlanView_LT.Reset();
        PlanView_LT.SetCurrentKey("Planning Document No.", "Planning Document Level", "Index 1", "Index 2", "Index 3", "Index 4", "Index 5", "Index 6", Date);
        PlanView_PT.FilterGroup(2);
        PlanView_LT.CopyFilters(PlanView_PT);
        PlanView_PT.FilterGroup(0);
        case PlanView_PT."Planning Document Level" of
            1:
                PlanView_LT.SetFilter("Index 1", '<>%1', PlanView_PT."Index 1");
            2:
                PlanView_LT.SetFilter("Index 2", '<>%1', PlanView_PT."Index 2");
            3:
                PlanView_LT.SetFilter("Index 3", '<>%1', PlanView_PT."Index 3");
            4:
                PlanView_LT.SetFilter("Index 4", '<>%1', PlanView_PT."Index 4");
            5:
                PlanView_LT.SetFilter("Index 5", '<>%1', PlanView_PT."Index 5");
            6:
                PlanView_LT.SetFilter("Index 6", '<>%1', PlanView_PT."Index 6");
        end;

        if PlanView_LT.FindSet() then
            repeat
                case PlanView_LT."Planning Document Level" of
                    1:
                        IndexCode_L := PlanView_LT."Index 1";
                    2:
                        IndexCode_L := PlanView_LT."Index 2";
                    3:
                        IndexCode_L := PlanView_LT."Index 3";
                    4:
                        IndexCode_L := PlanView_LT."Index 4";
                    5:
                        IndexCode_L := PlanView_LT."Index 5";
                    6:
                        IndexCode_L := PlanView_LT."Index 6";
                end;
                if Buffer_LT.Get(PlanView_LT."Planning Document No.", PlanView_LT."Planning Document Level", IndexCode_L) then begin
                    PlanBuffer_RTT.Init();
                    PlanBuffer_RTT.TransferFields(Buffer_LT);
                    PlanBuffer_RTT.Insert();
                end;
            until PlanView_LT.Next() = 0;
    end;

    /// <summary>
    /// CopyPlanningValuesWithinDocument.
    /// </summary>
    /// <param name="DocNo_P">Code[20].</param>
    /// <param name="Level_P">Integer.</param>
    /// <param name="SrcIndex_P">Code[20].</param>
    /// <param name="DestIndex_P">Code[20].</param>
    /// <param name="SrcView_PT">Record "BET FN Planning View".</param>
    procedure CopyPlanningValuesWithinDocument(DocNo_P: Code[20]; Level_P: Integer; SrcIndex_P: Code[20]; DestIndex_P: Code[20]; SrcView_PT: Record "BET FN Planning View")
    var
        PlanDoc_LT: Record "BET FN Planning Document";
        PlanDocLevel_LT: Record "BET FN Planning Document Level";
        DestCube_LT: Record "BET FN Planning Value Cube";
        SrcCube_LT: Record "BET FN Planning Value Cube";
        DestView_LT: Record "BET FN Planning View";
        PlanDocMgmt_LC: Codeunit "BET FN Planning Document Mgt";
        Dest_LRR: RecordRef;
        Source_LRR: RecordRef;
        Dest_LFR: FieldRef;
        Source_LFR: FieldRef;
        Terminate_L: Boolean;
        datetime_L: DateTime;
        CopyOption_L: Integer;
        i_L: Integer;
    begin
        //### Kopieren von Planwerten innerhalb eines Belegs (z.B. von Filiale A nach Filiale B)

        //### Fallunterscheidung:
        //### 1. Fall: homogene Ebenenstruktur (z.B. alle Filialen haben alle Warengruppen)
        //###   hier kann einfach auf PlanCube-Ebene kopiert werden

        //### 2. Fall: inhomogene Ebenenstruktur (z.B. HWG + WG)
        //###   dieser Fall wird erstmal nicht weiter betrachtet


        //### notwendige Prüfungen:
        //### - wenn COUNT A <> COUNT B, dann Fall 2
        //### - sonst weitere Prüfung:
        //###   - alle Cubezeilen von A durchlaufen und jeweils auf Existenz von zugehöriger B-Zeile prüfen
        //###     - wenn eine nicht gefunden wird, dann Fall 2 und Abbruch der Prüfung

        CopyOption_L := 1;
        datetime_L := CurrentDateTime();

        SrcCube_LT.Reset();
        SrcCube_LT.SetCurrentKey("Planning Document No.", "Index 1", "Index 2", "Index 3", "Index 4", "Index 5", "Index 6", Date);
        SrcCube_LT.SetRange("Planning Document No.", DocNo_P);

        DestCube_LT.Reset();
        DestCube_LT.SetCurrentKey("Planning Document No.", "Index 1", "Index 2", "Index 3", "Index 4", "Index 5", "Index 6", Date);
        DestCube_LT.SetRange("Planning Document No.", DocNo_P);

        //### erstmal alle Filter übernehmen:
        if SrcView_PT."Index 1" <> '' then begin
            SrcCube_LT.SetRange("Index 1", SrcView_PT."Index 1");
            DestCube_LT.SetRange("Index 1", SrcView_PT."Index 1");
        end;
        if SrcView_PT."Index 2" <> '' then begin
            SrcCube_LT.SetRange("Index 2", SrcView_PT."Index 2");
            DestCube_LT.SetRange("Index 2", SrcView_PT."Index 2");
        end;
        if SrcView_PT."Index 3" <> '' then begin
            SrcCube_LT.SetRange("Index 3", SrcView_PT."Index 3");
            DestCube_LT.SetRange("Index 3", SrcView_PT."Index 3");
        end;
        if SrcView_PT."Index 4" <> '' then begin
            SrcCube_LT.SetRange("Index 4", SrcView_PT."Index 4");
            DestCube_LT.SetRange("Index 4", SrcView_PT."Index 4");
        end;
        if SrcView_PT."Index 5" <> '' then begin
            SrcCube_LT.SetRange("Index 5", SrcView_PT."Index 5");
            DestCube_LT.SetRange("Index 5", SrcView_PT."Index 5");
        end;
        if SrcView_PT."Index 6" <> '' then begin
            SrcCube_LT.SetRange("Index 6", SrcView_PT."Index 6");
            DestCube_LT.SetRange("Index 6", SrcView_PT."Index 6");
        end;

        //### auf der Kopierebene separate Filter:
        case Level_P of
            1:
                begin
                    SrcCube_LT.SetRange("Index 1", SrcIndex_P);
                    DestCube_LT.SetRange("Index 1", DestIndex_P);
                end;
            2:
                begin
                    SrcCube_LT.SetRange("Index 2", SrcIndex_P);
                    DestCube_LT.SetRange("Index 2", DestIndex_P);
                end;
            3:
                begin
                    SrcCube_LT.SetRange("Index 3", SrcIndex_P);
                    DestCube_LT.SetRange("Index 3", DestIndex_P);
                end;
            4:
                begin
                    SrcCube_LT.SetRange("Index 4", SrcIndex_P);
                    DestCube_LT.SetRange("Index 4", DestIndex_P);
                end;
            5:
                begin
                    SrcCube_LT.SetRange("Index 5", SrcIndex_P);
                    DestCube_LT.SetRange("Index 5", DestIndex_P);
                end;
            6:
                begin
                    SrcCube_LT.SetRange("Index 6", SrcIndex_P);
                    DestCube_LT.SetRange("Index 6", DestIndex_P);
                end;
        end;


        if SrcCube_LT.Count() <> DestCube_LT.Count() then
            CopyOption_L := 2;

        //### weitere Prüfung: zeilenweises Prüfen ob Quellzeilen und Zielzeilen identisch sind
        if CopyOption_L = 1 then
            if SrcCube_LT.FindSet() then begin
                Terminate_L := false;
                repeat
                    DestCube_LT.SetRange("Index 1", SrcCube_LT."Index 1");
                    DestCube_LT.SetRange("Index 2", SrcCube_LT."Index 2");
                    DestCube_LT.SetRange("Index 3", SrcCube_LT."Index 3");
                    DestCube_LT.SetRange("Index 4", SrcCube_LT."Index 4");
                    DestCube_LT.SetRange("Index 5", SrcCube_LT."Index 5");
                    DestCube_LT.SetRange("Index 6", SrcCube_LT."Index 6");
                    DestCube_LT.SetRange(Date, SrcCube_LT.Date);
                    case Level_P of
                        1:
                            DestCube_LT.SetRange("Index 1", DestIndex_P);
                        2:
                            DestCube_LT.SetRange("Index 2", DestIndex_P);
                        3:
                            DestCube_LT.SetRange("Index 3", DestIndex_P);
                        4:
                            DestCube_LT.SetRange("Index 4", DestIndex_P);
                        5:
                            DestCube_LT.SetRange("Index 5", DestIndex_P);
                        6:
                            DestCube_LT.SetRange("Index 6", DestIndex_P);
                    end;

                    if DestCube_LT.IsEmpty() then begin
                        CopyOption_L := 2;
                        Terminate_L := true;
                    end;

                until (SrcCube_LT.Next() = 0) or Terminate_L;
            end;

        //### 1. Fall:
        if CopyOption_L = 1 then
            if SrcCube_LT.FindSet() then begin

                repeat
                    DestCube_LT.SetRange("Index 1", SrcCube_LT."Index 1");
                    DestCube_LT.SetRange("Index 2", SrcCube_LT."Index 2");
                    DestCube_LT.SetRange("Index 3", SrcCube_LT."Index 3");
                    DestCube_LT.SetRange("Index 4", SrcCube_LT."Index 4");
                    DestCube_LT.SetRange("Index 5", SrcCube_LT."Index 5");
                    DestCube_LT.SetRange("Index 6", SrcCube_LT."Index 6");
                    DestCube_LT.SetRange(Date, SrcCube_LT.Date);
                    case Level_P of
                        1:
                            DestCube_LT.SetRange("Index 1", DestIndex_P);
                        2:
                            DestCube_LT.SetRange("Index 2", DestIndex_P);
                        3:
                            DestCube_LT.SetRange("Index 3", DestIndex_P);
                        4:
                            DestCube_LT.SetRange("Index 4", DestIndex_P);
                        5:
                            DestCube_LT.SetRange("Index 5", DestIndex_P);
                        6:
                            DestCube_LT.SetRange("Index 6", DestIndex_P);
                    end;

                    DestCube_LT.FindFirst();

                    //### Kopieren der Planwerte (1:1)
                    DestCube_LT."Plan Sales Amount" := SrcCube_LT."Plan Sales Amount";
                    DestCube_LT."Plan Sal. Am. Discount" := SrcCube_LT."Plan Sal. Am. Discount";
                    DestCube_LT."Plan Sales Init. Inv." := SrcCube_LT."Plan Sales Init. Inv.";
                    DestCube_LT."Plan Sales Closing Inv." := SrcCube_LT."Plan Sales Closing Inv.";
                    DestCube_LT."Plan Gross Sales Pr. Reduction" := SrcCube_LT."Plan Gross Sales Pr. Reduction";
                    DestCube_LT."Plan Sales Am. Purchase" := SrcCube_LT."Plan Sales Am. Purchase";
                    DestCube_LT."Plan Qty. Sale" := SrcCube_LT."Plan Qty. Sale";
                    DestCube_LT."Plan Qty. Init. Inv." := SrcCube_LT."Plan Qty. Init. Inv.";
                    DestCube_LT."Plan Qty. Closing Inv." := SrcCube_LT."Plan Qty. Closing Inv.";
                    DestCube_LT."Plan Qty. Purchase" := SrcCube_LT."Plan Qty. Purchase";
                    DestCube_LT."Plan Cost of Sales" := SrcCube_LT."Plan Cost of Sales";
                    DestCube_LT."Plan Cost Init. Inv." := SrcCube_LT."Plan Cost Init. Inv.";
                    DestCube_LT."Plan Cost Closing Inv." := SrcCube_LT."Plan Cost Closing Inv.";
                    DestCube_LT."Plan Cost Am. Purchase" := SrcCube_LT."Plan Cost Am. Purchase";
                    DestCube_LT."Plan Cost Am. Purch. 1" := SrcCube_LT."Plan Cost Am. Purch. 1";
                    DestCube_LT."Plan Cost Am. Purch. 2" := SrcCube_LT."Plan Cost Am. Purch. 2";
                    DestCube_LT."Plan Cost Am. Purch. 3" := SrcCube_LT."Plan Cost Am. Purch. 3";
                    DestCube_LT."Plan Cost Am. Purch. 4" := SrcCube_LT."Plan Cost Am. Purch. 4";
                    DestCube_LT."Plan Cost Am. Purch. 5" := SrcCube_LT."Plan Cost Am. Purch. 5";

                    //### Zeitstempel aktualisieren:
                    DestCube_LT."Time-Stamp" := datetime_L;
                    DestCube_LT.Modify();
                until SrcCube_LT.Next() = 0;

                //### Zeitstempel im Beleg aktualisieren
                PlanDoc_LT.Get(DocNo_P);
                PlanDoc_LT."Timestamp Planning Values" := datetime_L;
                PlanDoc_LT.Modify();

                //### Zeitstempel der Ebenen aktualisieren
                PlanDocLevel_LT.Reset();
                PlanDocLevel_LT.SetRange("Planning Document No.", DocNo_P);
                PlanDocLevel_LT.ModifyAll("Timestamp Planning Values", datetime_L);
            end;



        //### 2. Fall:
        if CopyOption_L = 2 then begin
            //Error(Text001_L);

            //### wie muß man hier vorgehen?
            //### - Verteilung anhand VJ-Werte fällt aus, da evtl. nicht vorhanden (z.B. bei neuer Warengruppe) !
            //### - einfach alle Planwerte in der Viewzeile kopieren und manuell verteilen? --> führt zu Gleichverteilung

            //### Ziel-Viewzeile ermitteln:
            DestView_LT.Reset();
            DestView_LT.SetCurrentKey("Planning Document No.", "Planning Document Level", "Index 1", "Index 2", "Index 3", "Index 4", "Index 5", "Index 6", Date);
            DestView_LT.SetRange("Planning Document No.", DocNo_P);
            DestView_LT.SetRange("Planning Document Level", Level_P);
            DestView_LT.SetRange("Index 1", SrcView_PT."Index 1");
            DestView_LT.SetRange("Index 2", SrcView_PT."Index 2");
            DestView_LT.SetRange("Index 3", SrcView_PT."Index 3");
            DestView_LT.SetRange("Index 4", SrcView_PT."Index 4");
            DestView_LT.SetRange("Index 5", SrcView_PT."Index 5");
            DestView_LT.SetRange("Index 6", SrcView_PT."Index 6");
            case Level_P of
                1:
                    DestView_LT.SetRange("Index 1", DestIndex_P);
                2:
                    DestView_LT.SetRange("Index 2", DestIndex_P);
                3:
                    DestView_LT.SetRange("Index 3", DestIndex_P);
                4:
                    DestView_LT.SetRange("Index 4", DestIndex_P);
                5:
                    DestView_LT.SetRange("Index 5", DestIndex_P);
                6:
                    DestView_LT.SetRange("Index 6", DestIndex_P);
            end;
            DestView_LT.FindFirst();

            //### Planwerte kopieren:
            Source_LRR.GetTable(SrcView_PT);
            Dest_LRR.GetTable(DestView_LT);
            for i_L := 2000 to 2999 do
                if Source_LRR.FieldExist(i_L) then begin
                    Source_LFR := Source_LRR.Field(i_L);
                    Dest_LFR := Dest_LRR.Field(i_L);
                    Dest_LFR.Value(Source_LFR);
                end;
            Dest_LRR.SetTable(DestView_LT);

            DestView_LT.Changed := true;
            DestView_LT.Modify();

            //### Vewrteilung:
            PlanDocMgmt_LC.CheckViewDataValidity(DestView_LT);
            PlanDocMgmt_LC.UpdateViewData(DestView_LT);
        end;
    end;

    internal procedure InsertPlanDoc(var BETFNPlanningDocument: Record "BET FN Planning Document")
    var
        BETFNPlanningSetup: Record "BET FN Planning Setup";
        BETFNPlanningDocumentLevel: Record "BET FN Planning Document Level";
        NoSeries: Codeunit "No. Series";
        IsHandled: Boolean;
        TotalCodeLbl: Label 'TOTAL';
        TotalDescLbl: Label 'Total';
    begin
        OnBeforeInsertPlanDoc(BETFNPlanningDocument, IsHandled);

        if not IsHandled then begin
            // Nummer aus Nummernserie vergeben
            BETFNPlanningSetup.Get();
            BETFNPlanningSetup.TestField("No. Series");
            BETFNPlanningDocument."No." := NoSeries.GetNextNo(BETFNPlanningSetup."No. Series", 0D, true);
            BETFNPlanningDocument."Use Global Layout" := true;
            BETFNPlanningDocument."Layout Template" := BETFNPlanningSetup."Default Layout Template";
            BETFNPlanningDocument."Auto Filter On Level Changing" := BETFNPlanningSetup."Auto Filter On Level Changing";    // autom. Filterung bei Ebenenwechsel

            // Gesamtebene einf gen
            BETFNPlanningDocumentLevel.Init();
            BETFNPlanningDocumentLevel."Planning Document No." := BETFNPlanningDocument."No.";
            BETFNPlanningDocumentLevel."Planning Document Level Index" := 0;
            BETFNPlanningDocumentLevel."Index Code" := TotalCodeLbl;
            BETFNPlanningDocumentLevel."Index Description" := TotalDescLbl;
            BETFNPlanningDocumentLevel."Index Table No." := 0;
            BETFNPlanningDocumentLevel."Path End" := true;
            BETFNPlanningDocumentLevel."No. of Source-Records" := 0;
            BETFNPlanningDocumentLevel."No. of Records" := 1;
            BETFNPlanningDocumentLevel."Activate Date Level" := true;
            BETFNPlanningDocumentLevel."Timestamp Planning Values" := CreateDateTime(WorkDate(), Time);
            BETFNPlanningDocumentLevel."Timestamp Reference Values" := BETFNPlanningDocumentLevel."Timestamp Planning Values";
            BETFNPlanningDocumentLevel."Layout Template" := BETFNPlanningSetup."Default Layout Template";
            BETFNPlanningDocumentLevel.Insert();
        end;

        OnAfterInsertPlanDoc(BETFNPlanningDocument);
    end;

    internal procedure DeletePlanDoc(var BETFNPlanningDocument: Record "BET FN Planning Document")
    var
        BETFNPlanningDocumentLevel: Record "BET FN Planning Document Level";
        BETFNPlanningView: Record "BET FN Planning View";
        BETFNPlanningDocLvlBuf: Record "BET FN Planning Doc Lvl Buf";
        BETFNPlanningValueCube: Record "BET FN Planning Value Cube";
        BETFNPlanDocDateRef: Record "BET FN Planning Document D Ref";
        BETFNReferenceValueCube: Record "BET FN Reference Value Cube";
        BETFNPlanningEntryDWH: Record "BET FN Planning Entry (DWH)";
        BETFNDialogMgt: Codeunit "BET FN Dialog Mgt";
        IsHandled: Boolean;
        total: Integer;
        DeletePlanDocLbl: Label 'Delete Planning Document %1', Comment = '%1 = PlanDocNo';
    begin
        OnBeforeDeletePlanDoc(BETFNPlanningDocument, IsHandled);

        if not IsHandled then begin
            total := 7;
            BETFNDialogMgt.OpenDialog(total, StrSubstNo(DeletePlanDocLbl, BETFNPlanningDocument."No."));

            BETFNPlanningDocumentLevel.Reset();
            BETFNPlanningDocumentLevel.SetRange("Planning Document No.", BETFNPlanningDocument."No.");
            BETFNPlanningDocumentLevel.DeleteAll();
            BETFNDialogMgt.UpdateDialog(0);

            BETFNPlanningView.Reset();
            BETFNPlanningView.SetCurrentKey("Planning Document No.");
            BETFNPlanningView.SetRange("Planning Document No.", BETFNPlanningDocument."No.");
            BETFNPlanningView.DeleteAll();
            BETFNDialogMgt.UpdateDialog(0);

            BETFNPlanningDocLvlBuf.Reset();
            BETFNPlanningDocLvlBuf.SetRange("Planning Document No.", BETFNPlanningDocument."No.");
            BETFNPlanningDocLvlBuf.DeleteAll();
            BETFNDialogMgt.UpdateDialog(0);

            BETFNPlanningValueCube.Reset();
            BETFNPlanningValueCube.SetCurrentKey("Planning Document No.");
            BETFNPlanningValueCube.SetRange("Planning Document No.", BETFNPlanningDocument."No.");
            BETFNPlanningValueCube.DeleteAll();
            BETFNDialogMgt.UpdateDialog(0);

            BETFNPlanDocDateRef.Reset();
            BETFNPlanDocDateRef.SetRange("Planning Document No.", BETFNPlanningDocument."No.");
            BETFNPlanDocDateRef.DeleteAll();
            BETFNDialogMgt.UpdateDialog(0);

            BETFNReferenceValueCube.Reset();
            BETFNReferenceValueCube.SetCurrentKey("Planning Document No.");
            BETFNReferenceValueCube.SetRange("Planning Document No.", BETFNPlanningDocument."No.");
            BETFNReferenceValueCube.DeleteAll();
            BETFNDialogMgt.UpdateDialog(0);

            BETFNPlanningEntryDWH.Reset();
            BETFNPlanningEntryDWH.SetRange("Planning Document No.", BETFNPlanningDocument."No.");
            BETFNPlanningEntryDWH.DeleteAll();

            BETFNDialogMgt.CloseDialog();
        end;

    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertPlanDoc(BETFNPlanningDocument: Record "BET FN Planning Document"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInsertPlanDoc(BETFNPlanningDocument: Record "BET FN Planning Document")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeDeletePlanDoc(var BETFNPlanningDocument: Record "BET FN Planning Document"; var IsHandled: Boolean)
    begin
    end;
}

