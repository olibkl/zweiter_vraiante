/// <summary>
/// [planning]
/// Modules: 
/// </summary>
codeunit 5138639 "BET FN Calculate Top Down"
{
    Access = Public;

    var
        RR_G: RecordRef;
        FR_G: FieldRef;
        BaseValue_G: Decimal;
        Window_G: Dialog;
        NoOfLines_G: Integer;
        Filtertext_G: Text[1024];

    /// <summary>
    /// CalcTopDown.
    /// </summary>
    /// <param name="PlanView_RT">VAR Record "BET FN Planning View".</param>
    procedure CalcTopDown(var PlanView_RT: Record "BET FN Planning View")
    var
        PlanDoc_LT: Record "BET FN Planning Document";
        PlanDocLevel_LT: Record "BET FN Planning Document Level";
        BETFNPlanningType: Record "BET FN Planning Type";
        PlanView2_LT: Record "BET FN Planning View";
        CalcPlanValues_LC: Codeunit "BET FN Calculate Planning Vals";
        ConfirmManagement: Codeunit "Confirm Management";
        datetime_L: DateTime;
        Count_L: Integer;
        i_L: Integer;
        NoOfLines_L: Integer;
        CalculateTopDown2Txt: Label 'Calculate top down\@1@@@@@@@@@@@@@@@@@\@2@@@@@@@@@@@@@@@@@';
        CalculateTopDownTxt: Label 'Calculate top down\@2@@@@@@@@@@@@@@@@@';
        DistributeQst: Label 'Distribute %1 ?\Attention: manually added values on lower levels will be overwritten.', Comment = '%1';
        PlanningDocumentNotFoundErr: Label 'Planning document not found.';
    begin
        datetime_L := CurrentDateTime();
        i_L := 0;

        //### alle geänderten Views runterbrechen
        PlanView_RT.SetRange(Changed, true);
        PlanView_RT.SetRange(Fixed, false);

        //### bei allen Verteilungsarten (außer nach Plan) muß gewarnt werden, um ein versehentliches
        //### Überschreiben der bereits eingegebenen Planzahlen auf unteren Ebenen zu vermeiden:
        //### 070731
        if PlanDoc_LT.Get(PlanView_RT.GetFilter("Planning Document No.")) and
          (PlanDoc_LT."Distribution Type" <> PlanDoc_LT."Distribution Type"::Planwerte) then
            if not ConfirmManagement.GetResponse(StrSubstNo(DistributeQst, PlanDoc_LT."Distribution Type"), false) then
                exit;
        NoOfLines_G := 0;
        if PlanDoc_LT."Distribution Type" = PlanDoc_LT."Distribution Type"::Vergleichswerte then begin
            PlanView_RT.SetRange(Changed);    //### alle Zeilen dieser Ebene verteilen
            NoOfLines_G := PlanView_RT.Count();
            BaseValue_G := 0.1;
        end;

        if PlanView_RT.FindSet() then begin
            NoOfLines_L := PlanView_RT.Count();
            if NoOfLines_L > 1 then
                Window_G.Open(CalculateTopDown2Txt)
            else
                Window_G.Open(CalculateTopDownTxt);

            //### wird im Beleg Datumsebene verwendet oder nicht?
            PlanDocLevel_LT.Reset();
            PlanDocLevel_LT.SetRange("Planning Document No.", PlanDoc_LT."No.");
            PlanDocLevel_LT.FindLast();

            repeat
                Evaluate(Count_L, Format(Round(i_L / NoOfLines_L * 100, 1)));
                if NoOfLines_L > 1 then
                    Window_G.Update(1, Count_L * 100);

                //### Top-Down berechnen
                BreakTopDown(PlanView_RT, PlanDoc_LT, datetime_L, PlanDocLevel_LT."Activate Date Level");

                //### Zeitstempel und 'geändert' in View setzen
                PlanView2_LT.Get(PlanView_RT."View Entry No.");
                PlanView2_LT.Changed := false;
                PlanView2_LT."Timestamp Planning Values" := datetime_L;
                PlanView2_LT.Modify();

                i_L += 1;
            until PlanView_RT.Next() = 0;

            //### Zeitstempel der geänderten Ebene hochsetzen (für Aktualisierung)
            PlanDocLevel_LT.Reset();
            PlanDocLevel_LT.SetRange("Planning Document No.", PlanView_RT."Planning Document No.");
            PlanDocLevel_LT.ModifyAll("Timestamp Planning Values", datetime_L);

            //### Zeitstempel im Beleg aktualisieren
            if not PlanDoc_LT.Get(PlanView_RT."Planning Document No.") then
                Error(PlanningDocumentNotFoundErr);
            PlanDoc_LT."Timestamp Planning Values" := datetime_L;
            PlanDoc_LT.Modify();

        end;

        //### bei allen Verteilungsarten (außer nach Plan) muß nach dem ersten Top-Down auf Plan umgestellt werden
        if PlanDoc_LT.Get(PlanView_RT.GetFilter("Planning Document No.")) and
          (PlanDoc_LT."Distribution Type" <> PlanDoc_LT."Distribution Type"::Planwerte) then begin
            PlanDoc_LT."Distribution Type" := PlanDoc_LT."Distribution Type"::Planwerte;
            PlanDoc_LT.Modify();
        end;


        //### Umsatzanteile aller Viewzeilen  neu berechnen
        if BETFNPlanningType.Get(PlanDoc_LT."Planning Type") and
            (BETFNPlanningType."Planning Process Type" = BETFNPlanningType."Planning Process Type"::SalesPlan) then begin
            PlanView_RT.SetRange(Changed);
            if PlanView_RT.FindSet(true) then
                repeat
                    CalcPlanValues_LC.CalcLinePercentage(PlanView_RT, PlanDoc_LT, true);
                    PlanView_RT.Modify();
                until PlanView_RT.Next() = 0;
        end;
    end;

    /// <summary>
    /// BreakTopDown.
    /// </summary>
    /// <param name="PlanView_PT">Record "BET FN Planning View".</param>
    /// <param name="PlanDoc_PT">Record "BET FN Planning Document".</param>
    /// <param name="datetime_P">DateTime.</param>
    /// <param name="UseDateLevel_P">Boolean.</param>
    procedure BreakTopDown(PlanView_PT: Record "BET FN Planning View"; PlanDoc_PT: Record "BET FN Planning Document"; datetime_P: DateTime; UseDateLevel_P: Boolean)
    var
        PlanSetup_LT: Record "BET FN Planning Setup";
        PlanStat_LT: Record "BET FN Planning Statistic";
        PlanCube_LT: Record "BET FN Planning Value Cube";
        RefCube_LT: Record "BET FN Reference Value Cube";
        SumArray_L: array[30] of Decimal;
        SumArrayDelta_L: array[30] of Decimal;
        SumArrayDistr_L: array[30] of Decimal;
        SumArrayFixed_L: array[30] of Decimal;
        count_L: Integer;
        i_L: Integer;
        lines_L: Integer;
        PlanCubeNotFoundErr: Label 'PlanCube not found';
        FilterText_L: Text[1024];
    begin
        PlanSetup_LT.Get();

        RR_G.Open(Database::"BET FN Planning Statistic");
        PlanCube_LT.Reset();
        PlanCube_LT.SetRange("Planning Document No.", PlanView_PT."Planning Document No.");

        if PlanSetup_LT."Show Fixed Column" then
            PlanCube_LT.SetRange(Fixed, false);

        FilterText_L := '';
        FilterText_L := FilterText_L + PlanStat_LT.FieldCaption("Planning Document No.") + '=FILTER(' +
                                               PlanView_PT."Planning Document No." + '),';

        //### zugehörige Cube-Datensätze finden:

        if PlanView_PT."Index 1" <> '' then begin
            PlanCube_LT.SetRange("Index 1", PlanView_PT."Index 1");
            FilterText_L := FilterText_L + PlanStat_LT.FieldCaption("Index 1") + '=FILTER(' + '''' + PlanView_PT."Index 1" + '''' + '),';
        end;
        if PlanView_PT."Index 2" <> '' then begin
            PlanCube_LT.SetRange("Index 2", PlanView_PT."Index 2");
            FilterText_L := FilterText_L + PlanStat_LT.FieldCaption("Index 2") + '=FILTER(' + '''' + PlanView_PT."Index 2" + '''' + '),';
        end;
        if PlanView_PT."Index 3" <> '' then begin
            PlanCube_LT.SetRange("Index 3", PlanView_PT."Index 3");
            FilterText_L := FilterText_L + PlanStat_LT.FieldCaption("Index 3") + '=FILTER(' + '''' + PlanView_PT."Index 3" + '''' + '),';
        end;
        if PlanView_PT."Index 4" <> '' then begin
            PlanCube_LT.SetRange("Index 4", PlanView_PT."Index 4");
            FilterText_L := FilterText_L + PlanStat_LT.FieldCaption("Index 4") + '=FILTER(' + '''' + PlanView_PT."Index 4" + '''' + '),';
        end;
        if PlanView_PT."Index 5" <> '' then begin
            PlanCube_LT.SetRange("Index 5", PlanView_PT."Index 5");
            FilterText_L := FilterText_L + PlanStat_LT.FieldCaption("Index 5") + '=FILTER(' + '''' + PlanView_PT."Index 5" + '''' + '),';
        end;
        if PlanView_PT."Index 6" <> '' then begin
            PlanCube_LT.SetRange("Index 6", PlanView_PT."Index 6");
            FilterText_L := FilterText_L + PlanStat_LT.FieldCaption("Index 6") + '=FILTER(' + '''' + PlanView_PT."Index 6" + '''' + '),';
        end;


        //### Datum
        if UseDateLevel_P then begin
            if PlanView_PT.Date = 0D then begin   // auf alle verteilen
                PlanCube_LT.SetFilter(Date, '<>%1', 0D);
                FilterText_L := CopyStr(FilterText_L + PlanStat_LT.FieldCaption(DateFilter) + '=FILTER(' + PlanCube_LT.GetFilter(Date) + '),', 1, MaxStrLen(FilterText_L));
            end
            else begin                         // nur auf ein Datum
                PlanCube_LT.SetFilter(Date, Format(PlanView_PT.Date));
                FilterText_L := FilterText_L + PlanStat_LT.FieldCaption(DateFilter) + '=FILTER(' + Format(PlanView_PT.Date) + '),';
            end;
        end
        else begin
            PlanCube_LT.SetRange(Date, 0D);
            FilterText_L := CopyStr(FilterText_L + PlanStat_LT.FieldCaption(DateFilter) + '=FILTER(' + PlanCube_LT.GetFilter(Date) + '),', 1, MaxStrLen(FilterText_L));
        end;

        FilterText_L := DelChr(FilterText_L, '>', ',');
        Filtertext_G := FilterText_L;
        RR_G.SetView('WHERE(' + FilterText_L + ')');

        case PlanView_PT."Planning Document Level" of
            0:
                PlanCube_LT.SetCurrentKey("Planning Document No.", Date);
            1:
                PlanCube_LT.SetCurrentKey("Planning Document No.", Date, "Index 1");
            2:
                PlanCube_LT.SetCurrentKey("Planning Document No.", Date, "Index 1", "Index 2");
            3:
                PlanCube_LT.SetCurrentKey("Planning Document No.", Date, "Index 1", "Index 2", "Index 3");
            4:
                PlanCube_LT.SetCurrentKey("Planning Document No.", Date, "Index 1", "Index 2", "Index 3", "Index 4");
            else
                PlanCube_LT.SetCurrentKey("Planning Document No.", Date, "Index 1", "Index 2", "Index 3", "Index 4", "Index 5");
        end;


        //### Berechnungsvorschrift aus dem Beleg ermitteln

        i_L := 1;
        //### Summen berechnen
        if PlanCube_LT.FindFirst() then
            case PlanDoc_PT."Distribution Type" of
                PlanDoc_PT."Distribution Type"::Vergleichswerte:
                    CalcTotalsPreviousYear(PlanCube_LT, PlanDoc_PT, PlanView_PT, SumArray_L);
                PlanDoc_PT."Distribution Type"::Planwerte:
                    begin
                        CalcTotalsPlan(PlanCube_LT, PlanDoc_PT, PlanView_PT, SumArray_L);
                        if PlanSetup_LT."Show Fixed Column" then begin
                            CalcTotalsPlanFixed(PlanCube_LT, PlanDoc_PT, PlanView_PT, SumArrayFixed_L);
                            CalcTotalsDeltaAndDistr(SumArray_L, SumArrayFixed_L, SumArrayDelta_L, SumArrayDistr_L, PlanView_PT);
                        end;
                    end;
            end
        else
            Error(PlanCubeNotFoundErr);

        //### jetzt Daten runterrechnen (Summen verteilen)
        RefCube_LT.Reset();
        RefCube_LT.SetCurrentKey("Planning Document No.", Date, "Index 1", "Index 2", "Index 3", "Index 4", "Index 5");
        RefCube_LT.SetRange("Planning Document No.", PlanCube_LT."Planning Document No.");

        if PlanCube_LT.FindSet(true) then begin
            lines_L := PlanCube_LT.Count();
            repeat
                Evaluate(count_L, Format(Round(i_L / lines_L * 100, 1)));

                Window_G.Update(2, count_L * 100);
                case PlanDoc_PT."Distribution Type" of
                    PlanDoc_PT."Distribution Type"::Vergleichswerte:
                        DistributePreviousYear(PlanCube_LT, RefCube_LT, PlanView_PT, SumArray_L, lines_L, datetime_P, PlanDoc_PT."No. of Date-Records");
                    PlanDoc_PT."Distribution Type"::Planwerte:
                        if PlanSetup_LT."Show Fixed Column" then
                            DistributePlanFixed(PlanCube_LT, PlanView_PT, lines_L, datetime_P,
                                                PlanDoc_PT."No. of Date-Records", SumArrayDelta_L, SumArrayDistr_L)
                        else
                            DistributePlan(PlanCube_LT, PlanView_PT, SumArray_L, lines_L, datetime_P, PlanDoc_PT."No. of Date-Records");
                end;

                i_L += 1;
            until PlanCube_LT.Next() = 0;
        end;
        RR_G.Close();
    end;

    /// <summary>
    /// CalcTotalsPreviousYear.
    /// </summary>
    /// <param name="PlanCube_PT">Record "BET FN Planning Value Cube".</param>
    /// <param name="PlanDoc_PT">Record "BET FN Planning Document".</param>
    /// <param name="PlanView_PT">Record "BET FN Planning View".</param>
    /// <param name="Sum_Array_R">VAR array[30] of Decimal.</param>
    procedure CalcTotalsPreviousYear(PlanCube_PT: Record "BET FN Planning Value Cube"; PlanDoc_PT: Record "BET FN Planning Document"; PlanView_PT: Record "BET FN Planning View"; var Sum_Array_R: array[30] of Decimal)
    var
        PlanDocDateRef_LT: Record "BET FN Planning Document D Ref";
        PlanStat_LT: Record "BET FN Planning Statistic";
        pos_L: Integer;
        Filtertext2_L: Text[1024];
        Filtertext_L: Text[1024];
    begin

        Filtertext_L := Filtertext_G;

        //### bei Berechnung auf Datumsebene: Filter auf Vorjahresdatum setzen!
        if (PlanView_PT.Date <> 0D) and (PlanCube_PT.Date <> 0D) then begin
            PlanDocDateRef_LT.Reset();
            PlanDocDateRef_LT.SetRange("Planning Document No.", PlanView_PT."Planning Document No.");
            PlanDocDateRef_LT.SetRange(Date, PlanView_PT.Date);
            if PlanDocDateRef_LT.FindFirst() then begin
                pos_L := StrPos(Filtertext_L, PlanStat_LT.FieldCaption(DateFilter));
                if pos_L > 0 then
                    Filtertext_L := CopyStr(PadStr(Filtertext_L, pos_L - 1), 1, MaxStrLen(Filtertext_L));
                Filtertext_L := Filtertext_L + PlanStat_LT.FieldCaption(DateFilter) + '=FILTER(' +
                                    Format(PlanDocDateRef_LT."Reference Date") + '),';
                Filtertext_L := DelChr(Filtertext_L, '>', ',');
                RR_G.SetView('WHERE(' + Filtertext_L + ')');
            end;
        end;

        if PlanCube_PT.Date = 0D then begin
            FR_G := RR_G.Field(PlanStat_LT.FieldNo("Vgl. VK Anfangsbestand"));
            FR_G.CalcField();
            Sum_Array_R[1] := FR_G.Value();
            FR_G := RR_G.Field(PlanStat_LT.FieldNo("Vgl. Menge Anfangsbestand"));
            FR_G.CalcField();
            Sum_Array_R[2] := FR_G.Value();
            FR_G := RR_G.Field(PlanStat_LT.FieldNo("Vgl. EK Anfangsbestand"));
            FR_G.CalcField();
            Sum_Array_R[3] := FR_G.Value();
        end
        else begin
            //### AB-Summe aus den ersten Monaten bilden:
            Filtertext2_L := Filtertext_L;     // Filter merken
                                               //### Filter neu erstellen
            pos_L := StrPos(Filtertext2_L, PlanStat_LT.FieldCaption(DateFilter));
            if pos_L > 0 then
                Filtertext2_L := CopyStr(PadStr(Filtertext2_L, pos_L - 1), 1, MaxStrLen(Filtertext2_L));
            Filtertext2_L := Filtertext2_L + PlanStat_LT.FieldCaption(DateFilter) + '=FILTER(' +
                                Format(PlanDoc_PT."Start Date Ref. Period") + '),';
            Filtertext2_L := DelChr(Filtertext2_L, '>', ',');
            RR_G.SetView('WHERE(' + Filtertext2_L + ')');
            //### jetzt Bestände berechnen
            FR_G := RR_G.Field(PlanStat_LT.FieldNo("Vgl. VK Anfangsbestand"));
            FR_G.CalcField();
            Sum_Array_R[1] := FR_G.Value();
            FR_G := RR_G.Field(PlanStat_LT.FieldNo("Vgl. Menge Anfangsbestand"));
            FR_G.CalcField();
            Sum_Array_R[2] := FR_G.Value();
            FR_G := RR_G.Field(PlanStat_LT.FieldNo("Vgl. EK Anfangsbestand"));
            FR_G.CalcField();
            Sum_Array_R[3] := FR_G.Value();
            //### Filter wieder zurücksetzen
            RR_G.SetView('WHERE(' + Filtertext_L + ')');
        end;

        FR_G := RR_G.Field(PlanStat_LT.FieldNo("Vgl. VK Umsatz"));
        FR_G.CalcField();
        Sum_Array_R[4] := FR_G.Value();

        FR_G := RR_G.Field(PlanStat_LT.FieldNo("Vgl. VK Rabatt"));
        FR_G.CalcField();
        Sum_Array_R[5] := FR_G.Value();

        FR_G := RR_G.Field(PlanStat_LT.FieldNo("Vgl. VK Abschrift"));
        FR_G.CalcField();
        Sum_Array_R[6] := FR_G.Value();

        FR_G := RR_G.Field(PlanStat_LT.FieldNo("Vgl. VK WE (Limit)"));
        FR_G.CalcField();
        Sum_Array_R[7] := FR_G.Value();
        FR_G := RR_G.Field(PlanStat_LT.FieldNo("Vgl. Menge Umsatz"));
        FR_G.CalcField();
        Sum_Array_R[9] := FR_G.Value();
        FR_G := RR_G.Field(PlanStat_LT.FieldNo("Vgl. Menge WE (Limit)"));
        FR_G.CalcField();
        Sum_Array_R[10] := FR_G.Value();
        FR_G := RR_G.Field(PlanStat_LT.FieldNo("Vgl. EK Umsatz"));
        FR_G.CalcField();
        Sum_Array_R[12] := FR_G.Value();
        FR_G := RR_G.Field(PlanStat_LT.FieldNo("Vgl. EK WE (Limit)"));
        FR_G.CalcField();
        Sum_Array_R[13] := FR_G.Value();

        // TODO: Felder fehlen noch
        //FR_G := RR_G.FIELD(PlanStat_LT.FIELDNO("Ref. Sales Order Amount"));
        //FR_G.CALCFIELD;
        //Sum_Array_R[14] := FR_G.VALUE;

        //FR_G := RR_G.FIELD(PlanStat_LT.FIELDNO("Ref. Sales Order Qty."));
        //FR_G.CALCFIELD;
        //Sum_Array_R[15] := FR_G.VALUE;
    end;

    /// <summary>
    /// DistributePreviousYear.
    /// </summary>
    /// <param name="PlanCube_RT">VAR Record "BET FN Planning Value Cube".</param>
    /// <param name="RefCube_RT">VAR Record "BET FN Reference Value Cube".</param>
    /// <param name="PlanView_PT">Record "BET FN Planning View".</param>
    /// <param name="Sum_Array_P">array[30] of Decimal.</param>
    /// <param name="lines_P">Integer.</param>
    /// <param name="datetime_P">DateTime.</param>
    /// <param name="NoOfDateRecords_P">Integer.</param>
    procedure DistributePreviousYear(var PlanCube_RT: Record "BET FN Planning Value Cube"; var RefCube_RT: Record "BET FN Reference Value Cube"; PlanView_PT: Record "BET FN Planning View"; Sum_Array_P: array[30] of Decimal; lines_P: Integer; datetime_P: DateTime; NoOfDateRecords_P: Integer)
    var
        PlanDocDateRef_LT: Record "BET FN Planning Document D Ref";
        PlanViewSum_LT: Record "BET FN Planning View";
        DefaultValue_L: Decimal;
        RefRecNotFoundErr: Label 'Ref.-Record not found';
    begin
#pragma warning disable AL0432
        PlanViewSum_LT.Init();


        PlanViewSum_LT := PlanView_PT;

        RefCube_RT.SetRange("Index 1", PlanCube_RT."Index 1");
        if PlanCube_RT."Index 2" <> '' then
            RefCube_RT.SetRange("Index 2", PlanCube_RT."Index 2");
        if PlanCube_RT."Index 3" <> '' then
            RefCube_RT.SetRange("Index 3", PlanCube_RT."Index 3");
        if PlanCube_RT."Index 4" <> '' then
            RefCube_RT.SetRange("Index 4", PlanCube_RT."Index 4");
        if PlanCube_RT."Index 5" <> '' then
            RefCube_RT.SetRange("Index 5", PlanCube_RT."Index 5");
        if PlanCube_RT."Index 6" <> '' then
            RefCube_RT.SetRange("Index 6", PlanCube_RT."Index 6");

        if (PlanDocDateRef_LT.Get(PlanCube_RT."Planning Document No.", PlanCube_RT.Date)) and
           (PlanDocDateRef_LT."Reference Date" <> 0D) then
            RefCube_RT.SetRange(Date, PlanDocDateRef_LT."Reference Date")
        else
            RefCube_RT.SetRange(Date);

        if not RefCube_RT.Find('-') then
            Error(RefRecNotFoundErr)
        else begin

            //#################################
            //### Bestand für View mit Datum:
            if PlanView_PT.Date <> 0D then begin
                if PlanCube_RT.Date = 0D then begin             //### "Plan N VK Anfangsbestand"
                    if Sum_Array_P[1] = 0 then
                        PlanCube_RT."Plan Sales Init. Inv." := PlanViewSum_LT."Plan Sales Init. Inv." / lines_P
                    else begin
                        //PlanCube_RT."Plan VK Anfangsbestand" := RefCube_RT."Vgl. VK Anfangsbestand" / Sum_Array_P[1]
                        //                                         * PlanViewSum_LT."Plan VK Anfangsbestand";
                        if PlanViewSum_LT."Plan Sales Init. Inv." = 0 then
                            DefaultValue_L := BaseValue_G / NoOfLines_G
                        else
                            DefaultValue_L := PlanViewSum_LT."Plan Sales Init. Inv.";
                        PlanCube_RT."Plan Sales Init. Inv." := RefCube_RT."Ref. Sales Init. Inv." / Sum_Array_P[1]
                                                                 * DefaultValue_L;
                    end;
                end
                else
                    if PlanCube_RT."First Month" then begin
                        if Sum_Array_P[1] = 0 then
                            PlanCube_RT."Plan Sales Init. Inv." := PlanViewSum_LT."Plan Sales Init. Inv." / lines_P  // * NoOfDateRecords_P
                        else begin
                            //PlanCube_RT."Plan VK Anfangsbestand" := RefCube_RT."Vgl. VK Anfangsbestand" / Sum_Array_P[1]
                            //                                         * PlanViewSum_LT."Plan VK Anfangsbestand";
                            if PlanViewSum_LT."Plan Sales Init. Inv." = 0 then
                                DefaultValue_L := BaseValue_G / NoOfLines_G
                            else
                                DefaultValue_L := PlanViewSum_LT."Plan Sales Init. Inv.";
                            PlanCube_RT."Plan Sales Init. Inv." := RefCube_RT."Ref. Sales Init. Inv." / Sum_Array_P[1]
                                                                     * DefaultValue_L;
                        end;
                    end
                    else
                        PlanCube_RT."Plan Sales Init. Inv." := 0;

                if PlanCube_RT.Date = 0D then begin             //### "Plan N Menge Anfangsbestand"
                    if Sum_Array_P[2] = 0 then
                        PlanCube_RT."Plan Qty. Init. Inv." := PlanViewSum_LT."Plan Qty. Init. Inv." / lines_P
                    else begin
                        //PlanCube_RT."Plan Menge Anfangsbestand" := RefCube_RT."Vgl. Menge Anfangsbestand" / Sum_Array_P[2]
                        //                                         * PlanViewSum_LT."Plan Menge Anfangsbestand";
                        if PlanViewSum_LT."Plan Qty. Init. Inv." = 0 then
                            DefaultValue_L := BaseValue_G / NoOfLines_G
                        else
                            DefaultValue_L := PlanViewSum_LT."Plan Qty. Init. Inv.";
                        PlanCube_RT."Plan Qty. Init. Inv." := RefCube_RT."Ref. Qty. Init. Inv." / Sum_Array_P[2]
                                                                 * DefaultValue_L;
                    end;
                end
                else
                    if PlanCube_RT."First Month" then begin
                        if Sum_Array_P[2] = 0 then
                            PlanCube_RT."Plan Qty. Init. Inv." := PlanViewSum_LT."Plan Qty. Init. Inv." / lines_P //  * NoOfDateRecords_P
                        else begin
                            //PlanCube_RT."Plan Menge Anfangsbestand" := RefCube_RT."Vgl. Menge Anfangsbestand" / Sum_Array_P[2]
                            //                                         * PlanViewSum_LT."Plan Menge Anfangsbestand";
                            if PlanViewSum_LT."Plan Qty. Init. Inv." = 0 then
                                DefaultValue_L := BaseValue_G / NoOfLines_G
                            else
                                DefaultValue_L := PlanViewSum_LT."Plan Qty. Init. Inv.";
                            PlanCube_RT."Plan Qty. Init. Inv." := RefCube_RT."Ref. Qty. Init. Inv." / Sum_Array_P[2]
                                                                     * DefaultValue_L;
                        end;
                    end
                    else
                        PlanCube_RT."Plan Qty. Init. Inv." := 0;

                if PlanCube_RT.Date = 0D then begin              //### "Plan N EK Anfangsbestand"
                    if Sum_Array_P[3] = 0 then
                        PlanCube_RT."Plan Cost Init. Inv." := PlanViewSum_LT."Plan Cost Init. Inv." / lines_P
                    else begin
                        //PlanCube_RT."Plan EK Anfangsbestand" := RefCube_RT."Vgl. EK Anfangsbestand" / Sum_Array_P[3]
                        //                                         * PlanViewSum_LT."Plan EK Anfangsbestand";
                        if PlanViewSum_LT."Plan Cost Init. Inv." = 0 then
                            DefaultValue_L := BaseValue_G / NoOfLines_G
                        else
                            DefaultValue_L := PlanViewSum_LT."Plan Cost Init. Inv.";
                        PlanCube_RT."Plan Cost Init. Inv." := RefCube_RT."Ref. Cost Init. Inv." / Sum_Array_P[3]
                                                                 * DefaultValue_L;
                    end;
                end
                else
                    if PlanCube_RT."First Month" then begin
                        if Sum_Array_P[3] = 0 then
                            PlanCube_RT."Plan Cost Init. Inv." := PlanViewSum_LT."Plan Cost Init. Inv." / lines_P //  * NoOfDateRecords_P
                        else begin
                            //PlanCube_RT."Plan EK Anfangsbestand" := RefCube_RT."Vgl. EK Anfangsbestand" / Sum_Array_P[3]
                            //                                         * PlanViewSum_LT."Plan EK Anfangsbestand";
                            if PlanViewSum_LT."Plan Cost Init. Inv." = 0 then
                                DefaultValue_L := BaseValue_G / NoOfLines_G
                            else
                                DefaultValue_L := PlanViewSum_LT."Plan Cost Init. Inv.";
                            PlanCube_RT."Plan Cost Init. Inv." := RefCube_RT."Ref. Cost Init. Inv." / Sum_Array_P[3]
                                                                     * DefaultValue_L;
                        end;
                    end
                    else
                        PlanCube_RT."Plan Cost Init. Inv." := 0;

            end else begin

                //### "Plan VK Anfangsbestand"
                if PlanCube_RT.Date = 0D then begin
                    if Sum_Array_P[1] = 0 then
                        PlanCube_RT."Plan Sales Init. Inv." := PlanViewSum_LT."Plan Sales Init. Inv." / lines_P // * NoOfDateRecords_P
                    else begin
                        //PlanCube_RT."Plan VK Anfangsbestand" := RefCube_RT."Vgl. VK Anfangsbestand" / Sum_Array_P[1]
                        //                                         * PlanViewSum_LT."Plan VK Anfangsbestand";
                        if PlanViewSum_LT."Plan Sales Init. Inv." = 0 then
                            DefaultValue_L := BaseValue_G / NoOfLines_G
                        else
                            DefaultValue_L := PlanViewSum_LT."Plan Sales Init. Inv.";
                        PlanCube_RT."Plan Sales Init. Inv." := RefCube_RT."Ref. Sales Init. Inv." / Sum_Array_P[1]
                                                                 * DefaultValue_L;
                    end;
                end
                else
                    if PlanCube_RT."First Month" then begin
                        if Sum_Array_P[1] = 0 then
                            PlanCube_RT."Plan Sales Init. Inv." := PlanViewSum_LT."Plan Sales Init. Inv." / lines_P * NoOfDateRecords_P
                        else begin
                            //PlanCube_RT."Plan VK Anfangsbestand" := RefCube_RT."Vgl. VK Anfangsbestand" / Sum_Array_P[1]
                            //                                         * PlanViewSum_LT."Plan VK Anfangsbestand";
                            if PlanViewSum_LT."Plan Sales Init. Inv." = 0 then
                                DefaultValue_L := BaseValue_G / NoOfLines_G
                            else
                                DefaultValue_L := PlanViewSum_LT."Plan Sales Init. Inv.";
                            PlanCube_RT."Plan Sales Init. Inv." := RefCube_RT."Ref. Sales Init. Inv." / Sum_Array_P[1]
                                                                     * DefaultValue_L;
                        end;
                    end
                    else
                        PlanCube_RT."Plan Sales Init. Inv." := 0;

                //### "Plan Menge Anfangsbestand"
                if PlanCube_RT.Date = 0D then begin
                    if Sum_Array_P[2] = 0 then
                        PlanCube_RT."Plan Qty. Init. Inv." := PlanViewSum_LT."Plan Qty. Init. Inv." / lines_P // * NoOfDateRecords_P
                    else begin
                        //PlanCube_RT."Plan Menge Anfangsbestand" := RefCube_RT."Vgl. Menge Anfangsbestand" / Sum_Array_P[2]
                        //                                         * PlanViewSum_LT."Plan Menge Anfangsbestand";
                        if PlanViewSum_LT."Plan Qty. Init. Inv." = 0 then
                            DefaultValue_L := BaseValue_G / NoOfLines_G
                        else
                            DefaultValue_L := PlanViewSum_LT."Plan Qty. Init. Inv.";
                        PlanCube_RT."Plan Qty. Init. Inv." := RefCube_RT."Ref. Qty. Init. Inv." / Sum_Array_P[2]
                                                                 * DefaultValue_L;
                    end;
                end
                else
                    if PlanCube_RT."First Month" then begin
                        if Sum_Array_P[2] = 0 then
                            PlanCube_RT."Plan Qty. Init. Inv." := PlanViewSum_LT."Plan Qty. Init. Inv." / lines_P * NoOfDateRecords_P
                        else begin
                            //PlanCube_RT."Plan Menge Anfangsbestand" := RefCube_RT."Vgl. Menge Anfangsbestand" / Sum_Array_P[2]
                            //                                         * PlanViewSum_LT."Plan Menge Anfangsbestand";
                            if PlanViewSum_LT."Plan Qty. Init. Inv." = 0 then
                                DefaultValue_L := BaseValue_G / NoOfLines_G
                            else
                                DefaultValue_L := PlanViewSum_LT."Plan Qty. Init. Inv.";
                            PlanCube_RT."Plan Qty. Init. Inv." := RefCube_RT."Ref. Qty. Init. Inv." / Sum_Array_P[2]
                                                                     * DefaultValue_L;
                        end;
                    end
                    else
                        PlanCube_RT."Plan Qty. Init. Inv." := 0;

                //### "Plan EK Anfangsbestand"
                if PlanCube_RT.Date = 0D then begin
                    if Sum_Array_P[3] = 0 then
                        PlanCube_RT."Plan Cost Init. Inv." := PlanViewSum_LT."Plan Cost Init. Inv." / lines_P // * NoOfDateRecords_P
                    else begin
                        //PlanCube_RT."Plan EK Anfangsbestand" := RefCube_RT."Vgl. EK Anfangsbestand" / Sum_Array_P[3]
                        //                                         * PlanViewSum_LT."Plan EK Anfangsbestand";
                        if PlanViewSum_LT."Plan Cost Init. Inv." = 0 then
                            DefaultValue_L := BaseValue_G / NoOfLines_G
                        else
                            DefaultValue_L := PlanViewSum_LT."Plan Cost Init. Inv.";
                        PlanCube_RT."Plan Cost Init. Inv." := RefCube_RT."Ref. Cost Init. Inv." / Sum_Array_P[3]
                                                                 * DefaultValue_L;
                    end;
                end
                else
                    if PlanCube_RT."First Month" then begin
                        if Sum_Array_P[3] = 0 then
                            PlanCube_RT."Plan Cost Init. Inv." := PlanViewSum_LT."Plan Cost Init. Inv." / lines_P * NoOfDateRecords_P
                        else begin
                            //PlanCube_RT."Plan EK Anfangsbestand" := RefCube_RT."Vgl. EK Anfangsbestand" / Sum_Array_P[3]
                            //                                         * PlanViewSum_LT."Plan EK Anfangsbestand";
                            if PlanViewSum_LT."Plan Cost Init. Inv." = 0 then
                                DefaultValue_L := BaseValue_G / NoOfLines_G
                            else
                                DefaultValue_L := PlanViewSum_LT."Plan Cost Init. Inv.";
                            PlanCube_RT."Plan Cost Init. Inv." := RefCube_RT."Ref. Cost Init. Inv." / Sum_Array_P[3]
                                                                     * DefaultValue_L;
                        end;
                    end
                    else
                        PlanCube_RT."Plan Cost Init. Inv." := 0;
            end;


            //### "Plan VK Umsatz"
            if Sum_Array_P[4] = 0 then
                PlanCube_RT."Plan Sales Amount" := PlanViewSum_LT."Plan Sales Amount" / lines_P
            else begin
                //PlanCube_RT."Plan VK Umsatz" := RefCube_RT."Vgl. VK Umsatz" / Sum_Array_P[4] * PlanViewSum_LT."Plan VK Umsatz";
                if PlanViewSum_LT."Plan Sales Amount" = 0 then
                    DefaultValue_L := BaseValue_G / NoOfLines_G
                else
                    DefaultValue_L := PlanViewSum_LT."Plan Sales Amount";
                PlanCube_RT."Plan Sales Amount" := RefCube_RT."Ref. Sales Amount" / Sum_Array_P[4] * DefaultValue_L;
            end;

            //### "Plan VK Rabatt"
            if Sum_Array_P[5] = 0 then
                PlanCube_RT."Plan Sal. Am. Discount" := PlanViewSum_LT."Plan Sales Discount" / lines_P
            else begin
                //PlanCube_RT."Plan VK Rabatt" := RefCube_RT."Vgl. VK Rabatt" / Sum_Array_P[5]
                //                                     * PlanViewSum_LT."Plan VK Rabatt";
                if PlanViewSum_LT."Plan Sales Discount" = 0 then
                    DefaultValue_L := BaseValue_G / NoOfLines_G
                else
                    DefaultValue_L := PlanViewSum_LT."Plan Sales Discount";
                PlanCube_RT."Plan Sal. Am. Discount" := RefCube_RT."Ref. Sal. Am. Discount" / Sum_Array_P[5] * DefaultValue_L;
            end;


            //### "Plan VK Abschrift"
            if Sum_Array_P[6] = 0 then
                PlanCube_RT."Plan Gross Sales Pr. Reduction" := PlanViewSum_LT."Plan Gross Sales Pr. Reduction" / lines_P
            else begin
                //PlanCube_RT."Plan VK BPA" := RefCube_RT."Vgl. VK BPA" / Sum_Array_P[6] * PlanViewSum_LT."Plan VK BPA";
                if PlanViewSum_LT."Plan Gross Sales Pr. Reduction" = 0 then
                    DefaultValue_L := BaseValue_G / NoOfLines_G
                else
                    DefaultValue_L := PlanViewSum_LT."Plan Gross Sales Pr. Reduction";
                PlanCube_RT."Plan Gross Sales Pr. Reduction" := RefCube_RT."Ref. Gross Sales Pr. Reduction" / Sum_Array_P[6] * DefaultValue_L;
            end;


            //### "Plan VK WE (Limit)"
            if Sum_Array_P[7] = 0 then begin
                PlanCube_RT."Plan Sales Am. Purchase" := PlanViewSum_LT."Plan Sales Am. Purchase" / lines_P;

                //### VK-Limite 1-5:
                PlanCube_RT."Plan Sales Am. Purch. 1" := PlanViewSum_LT."Plan Sales Am. Purch. 1" / lines_P;
                PlanCube_RT."Plan Sales Am. Purch. 2" := PlanViewSum_LT."Plan Sales Am. Purch. 2" / lines_P;
                PlanCube_RT."Plan Sales Am. Purch. 3" := PlanViewSum_LT."Plan Sales Am. Purch. 3" / lines_P;
                PlanCube_RT."Plan Sales Am. Purch. 4" := PlanViewSum_LT."Plan Sales Am. Purch. 4" / lines_P;
                PlanCube_RT."Plan Sales Am. Purch. 5" := PlanViewSum_LT."Plan Sales Am. Purch. 5" / lines_P;
            end else begin
                //PlanCube_RT."Plan VK WE (Limit)" := RefCube_RT."Vgl. VK WE (Limit)" / Sum_Array_P[7]
                //                                      * PlanViewSum_LT."Plan VK WE (Limit)";
                if PlanViewSum_LT."Plan Sales Am. Purchase" = 0 then
                    DefaultValue_L := BaseValue_G / NoOfLines_G
                else
                    DefaultValue_L := PlanViewSum_LT."Plan Sales Am. Purchase";
                PlanCube_RT."Plan Sales Am. Purchase" := RefCube_RT."Ref. Sales Am. Purchase" / Sum_Array_P[7] * DefaultValue_L;

                //### VK-Limite 1-5:
                if PlanViewSum_LT."Plan Sales Am. Purch. 1" = 0 then
                    DefaultValue_L := BaseValue_G / NoOfLines_G
                else
                    DefaultValue_L := PlanViewSum_LT."Plan Sales Am. Purch. 1";
                PlanCube_RT."Plan Sales Am. Purch. 1" := RefCube_RT."Ref. Sales Am. Purchase" / Sum_Array_P[7] * DefaultValue_L;

                if PlanViewSum_LT."Plan Sales Am. Purch. 2" = 0 then
                    DefaultValue_L := BaseValue_G / NoOfLines_G
                else
                    DefaultValue_L := PlanViewSum_LT."Plan Sales Am. Purch. 2";
                PlanCube_RT."Plan Sales Am. Purch. 2" := RefCube_RT."Ref. Sales Am. Purchase" / Sum_Array_P[7] * DefaultValue_L;

                if PlanViewSum_LT."Plan Sales Am. Purch. 3" = 0 then
                    DefaultValue_L := BaseValue_G / NoOfLines_G
                else
                    DefaultValue_L := PlanViewSum_LT."Plan Sales Am. Purch. 3";
                PlanCube_RT."Plan Sales Am. Purch. 3" := RefCube_RT."Ref. Sales Am. Purchase" / Sum_Array_P[7] * DefaultValue_L;

                if PlanViewSum_LT."Plan Sales Am. Purch. 4" = 0 then
                    DefaultValue_L := BaseValue_G / NoOfLines_G
                else
                    DefaultValue_L := PlanViewSum_LT."Plan Sales Am. Purch. 4";
                PlanCube_RT."Plan Sales Am. Purch. 4" := RefCube_RT."Ref. Sales Am. Purchase" / Sum_Array_P[7] * DefaultValue_L;

                if PlanViewSum_LT."Plan Sales Am. Purch. 5" = 0 then
                    DefaultValue_L := BaseValue_G / NoOfLines_G
                else
                    DefaultValue_L := PlanViewSum_LT."Plan Sales Am. Purch. 5";
                PlanCube_RT."Plan Sales Am. Purch. 5" := RefCube_RT."Ref. Sales Am. Purchase" / Sum_Array_P[7] * DefaultValue_L;
            end;


            if Sum_Array_P[9] = 0 then                     //### "Plan N Menge Umsatz"
                PlanCube_RT."Plan Qty. Sale" := PlanViewSum_LT."Plan Qty. Sale" / lines_P
            else begin
                //PlanCube_RT."Plan Menge Umsatz" := RefCube_RT."Vgl. Menge Umsatz" / Sum_Array_P[9] * PlanViewSum_LT."Plan Menge Umsatz";
                if PlanViewSum_LT."Plan Qty. Sale" = 0 then
                    DefaultValue_L := BaseValue_G / NoOfLines_G
                else
                    DefaultValue_L := PlanViewSum_LT."Plan Qty. Sale";
                PlanCube_RT."Plan Qty. Sale" := RefCube_RT."Ref. Qty. Sale" / Sum_Array_P[9] * DefaultValue_L;
            end;

            if Sum_Array_P[10] = 0 then                    //### "Plan N Menge WE (Limit)"
                PlanCube_RT."Plan Qty. Purchase" := PlanViewSum_LT."Plan Qty. Purchase" / lines_P
            else begin
                //PlanCube_RT."Plan Menge WE (Limit)" := RefCube_RT."Vgl. Menge WE (Limit)" / Sum_Array_P[10]
                //                                      * PlanViewSum_LT."Plan Menge WE (Limit)";
                if PlanViewSum_LT."Plan Qty. Purchase" = 0 then
                    DefaultValue_L := BaseValue_G / NoOfLines_G
                else
                    DefaultValue_L := PlanViewSum_LT."Plan Qty. Purchase";
                PlanCube_RT."Plan Qty. Purchase" := RefCube_RT."Ref. Qty. Purchase" / Sum_Array_P[10] * DefaultValue_L;
            end;


            if Sum_Array_P[12] = 0 then                   //### "Plan N EK Umsatz"
                PlanCube_RT."Plan Cost of Sales" := PlanViewSum_LT."Plan Cost of Sales" / lines_P
            else begin
                //PlanCube_RT."Plan EK Umsatz" := RefCube_RT."Vgl. EK Umsatz" / Sum_Array_P[12] * PlanViewSum_LT."Plan EK Umsatz";
                if PlanViewSum_LT."Plan Cost of Sales" = 0 then
                    DefaultValue_L := BaseValue_G / NoOfLines_G
                else
                    DefaultValue_L := PlanViewSum_LT."Plan Cost of Sales";
                PlanCube_RT."Plan Cost of Sales" := RefCube_RT."Ref. Cost of Sales" / Sum_Array_P[12] * DefaultValue_L;
            end;

            //### "Plan EK WE (Limit)" (EK-Limite 1 bis 5 werden wie EK-Limit verteilt !)
            if Sum_Array_P[13] = 0 then begin
                PlanCube_RT."Plan Cost Am. Purchase" := PlanViewSum_LT."Plan Cost Am. Purchase" / lines_P;

                //### EK-Limite 1-5:
                PlanCube_RT."Plan Cost Am. Purch. 1" := PlanViewSum_LT."Plan Cost Am. Purch. 1" / lines_P;
                PlanCube_RT."Plan Cost Am. Purch. 2" := PlanViewSum_LT."Plan Cost Am. Purch. 2" / lines_P;
                PlanCube_RT."Plan Cost Am. Purch. 3" := PlanViewSum_LT."Plan Cost Am. Purch. 3" / lines_P;
                PlanCube_RT."Plan Cost Am. Purch. 4" := PlanViewSum_LT."Plan Cost Am. Purch. 4" / lines_P;
                PlanCube_RT."Plan Cost Am. Purch. 5" := PlanViewSum_LT."Plan Cost Am. Purch. 5" / lines_P;
            end else begin
                if PlanViewSum_LT."Plan Cost Am. Purchase" = 0 then
                    DefaultValue_L := BaseValue_G / NoOfLines_G
                else
                    DefaultValue_L := PlanViewSum_LT."Plan Cost Am. Purchase";
                PlanCube_RT."Plan Cost Am. Purchase" := RefCube_RT."Ref. Cost Val. Purchase" / Sum_Array_P[13] * DefaultValue_L;

                //### EK-Limite 1-5:
                if PlanViewSum_LT."Plan Cost Am. Purch. 1" = 0 then
                    DefaultValue_L := BaseValue_G / NoOfLines_G
                else
                    DefaultValue_L := PlanViewSum_LT."Plan Cost Am. Purch. 1";
                PlanCube_RT."Plan Cost Am. Purch. 1" := RefCube_RT."Ref. Cost Val. Purchase" / Sum_Array_P[13] * DefaultValue_L;

                if PlanViewSum_LT."Plan Cost Am. Purch. 2" = 0 then
                    DefaultValue_L := BaseValue_G / NoOfLines_G
                else
                    DefaultValue_L := PlanViewSum_LT."Plan Cost Am. Purch. 2";
                PlanCube_RT."Plan Cost Am. Purch. 2" := RefCube_RT."Ref. Cost Val. Purchase" / Sum_Array_P[13] * DefaultValue_L;

                if PlanViewSum_LT."Plan Cost Am. Purch. 3" = 0 then
                    DefaultValue_L := BaseValue_G / NoOfLines_G
                else
                    DefaultValue_L := PlanViewSum_LT."Plan Cost Am. Purch. 3";
                PlanCube_RT."Plan Cost Am. Purch. 3" := RefCube_RT."Ref. Cost Val. Purchase" / Sum_Array_P[13] * DefaultValue_L;

                if PlanViewSum_LT."Plan Cost Am. Purch. 4" = 0 then
                    DefaultValue_L := BaseValue_G / NoOfLines_G
                else
                    DefaultValue_L := PlanViewSum_LT."Plan Cost Am. Purch. 4";
                PlanCube_RT."Plan Cost Am. Purch. 4" := RefCube_RT."Ref. Cost Val. Purchase" / Sum_Array_P[13] * DefaultValue_L;

                if PlanViewSum_LT."Plan Cost Am. Purch. 5" = 0 then
                    DefaultValue_L := BaseValue_G / NoOfLines_G
                else
                    DefaultValue_L := PlanViewSum_LT."Plan Cost Am. Purch. 5";
                PlanCube_RT."Plan Cost Am. Purch. 5" := RefCube_RT."Ref. Cost Val. Purchase" / Sum_Array_P[13] * DefaultValue_L;
            end;
            PlanCube_RT."Plan Sales Closing Inv." := PlanCube_RT."Plan Sales Am. Purchase" -
                                                     PlanCube_RT."Plan Sales Amount" -
                                                     PlanCube_RT."Plan Sal. Am. Discount" -
                                                     PlanCube_RT."Plan Gross Sales Pr. Reduction";

            PlanCube_RT."Plan Cost Closing Inv." := PlanCube_RT."Plan Cost Am. Purchase" -
                                                    PlanCube_RT."Plan Cost of Sales";

            PlanCube_RT."Plan Qty. Closing Inv." := PlanCube_RT."Plan Qty. Purchase" -
                                                    PlanCube_RT."Plan Qty. Sale";

            PlanCube_RT."Time-Stamp" := datetime_P;
            PlanCube_RT.Modify();
            if RefCube_RT.Next() = 0 then;
        end;
#pragma warning restore AL0432
    end;

    /// <summary>
    /// CalcTotalsPlan.
    /// </summary>
    /// <param name="PlanCube_PT">Record "BET FN Planning Value Cube".</param>
    /// <param name="PlanDoc_PT">Record "BET FN Planning Document".</param>
    /// <param name="PlanView_PT">Record "BET FN Planning View".</param>
    /// <param name="Sum_Array_R">VAR array[30] of Decimal.</param>
    procedure CalcTotalsPlan(PlanCube_PT: Record "BET FN Planning Value Cube"; PlanDoc_PT: Record "BET FN Planning Document"; PlanView_PT: Record "BET FN Planning View"; var Sum_Array_R: array[30] of Decimal)
    var
        PlanStat_LT: Record "BET FN Planning Statistic";
        pos_L: Integer;
        Filtertext2_L: Text[1024];
        Filtertext_L: Text[1024];
    begin
        if PlanCube_PT.Date = 0D then begin
            FR_G := RR_G.Field(PlanStat_LT.FieldNo("Plan VK Anfangsbestand"));
            FR_G.CalcField();
            Sum_Array_R[1] := FR_G.Value();
            FR_G := RR_G.Field(PlanStat_LT.FieldNo("Plan Menge Anfangsbestand"));
            FR_G.CalcField();
            Sum_Array_R[2] := FR_G.Value();
            FR_G := RR_G.Field(PlanStat_LT.FieldNo("Plan EK Anfangsbestand"));
            FR_G.CalcField();
            Sum_Array_R[3] := FR_G.Value();
        end

        else begin
            //### AB-Summe aus den ersten Monaten bilden:
            Filtertext2_L := Filtertext_G;    // Filter merken
                                              //### Filter neu erstellen
            Filtertext_L := Filtertext2_L;
            pos_L := StrPos(Filtertext_L, PlanStat_LT.FieldCaption(DateFilter));
            if pos_L > 0 then
                Filtertext_L := CopyStr(PadStr(Filtertext_L, pos_L - 1), 1, MaxStrLen(Filtertext_L));

            Filtertext_L := Filtertext_L + PlanStat_LT.FieldCaption(DateFilter) + '=FILTER(' + Format(PlanDoc_PT."Start Date") + '),';
            Filtertext_L := DelChr(Filtertext_L, '>', ',');
            RR_G.SetView('WHERE(' + Filtertext_L + ')');

            //### jetzt Bestände berechnen
            FR_G := RR_G.Field(PlanStat_LT.FieldNo("Plan VK Anfangsbestand"));
            FR_G.CalcField();
            Sum_Array_R[1] := FR_G.Value();
            FR_G := RR_G.Field(PlanStat_LT.FieldNo("Plan Menge Anfangsbestand"));
            FR_G.CalcField();
            Sum_Array_R[2] := FR_G.Value();
            FR_G := RR_G.Field(PlanStat_LT.FieldNo("Plan EK Anfangsbestand"));
            FR_G.CalcField();
            Sum_Array_R[3] := FR_G.Value();

            //### Filter wieder zurücksetzen
            RR_G.SetView('WHERE(' + Filtertext2_L + ')');
        end;

        FR_G := RR_G.Field(PlanStat_LT.FieldNo("Plan VK Umsatz"));
        FR_G.CalcField();
        Sum_Array_R[4] := FR_G.Value();

        FR_G := RR_G.Field(PlanStat_LT.FieldNo("Plan VK Rabatt"));
        FR_G.CalcField();
        Sum_Array_R[5] := FR_G.Value();

        FR_G := RR_G.Field(PlanStat_LT.FieldNo("Plan VK Abschrift"));
        FR_G.CalcField();
        Sum_Array_R[6] := FR_G.Value();

        FR_G := RR_G.Field(PlanStat_LT.FieldNo("Plan VK WE (Limit)"));
        FR_G.CalcField();
        Sum_Array_R[7] := FR_G.Value();

        FR_G := RR_G.Field(PlanStat_LT.FieldNo("Plan Menge Umsatz"));
        FR_G.CalcField();
        Sum_Array_R[9] := FR_G.Value();

        FR_G := RR_G.Field(PlanStat_LT.FieldNo("Plan Menge WE (Limit)"));
        FR_G.CalcField();
        Sum_Array_R[10] := FR_G.Value();

        FR_G := RR_G.Field(PlanStat_LT.FieldNo("Plan EK Umsatz"));
        FR_G.CalcField();
        Sum_Array_R[12] := FR_G.Value();

        FR_G := RR_G.Field(PlanStat_LT.FieldNo("Plan EK WE (Limit)"));
        FR_G.CalcField();
        Sum_Array_R[13] := FR_G.Value();

        //### für Limitplanung:
        FR_G := RR_G.Field(PlanStat_LT.FieldNo("Plan EK Freies Limit"));
        FR_G.CalcField();
        Sum_Array_R[18] := FR_G.Value();    // Freies Limit
        FR_G := RR_G.Field(PlanStat_LT.FieldNo("Plan EK Limit 1"));
        FR_G.CalcField();
        Sum_Array_R[21] := FR_G.Value();

        FR_G := RR_G.Field(PlanStat_LT.FieldNo("Plan EK Limit 2"));
        FR_G.CalcField();
        Sum_Array_R[22] := FR_G.Value();

        FR_G := RR_G.Field(PlanStat_LT.FieldNo("Plan EK Limit 3"));
        FR_G.CalcField();
        Sum_Array_R[23] := FR_G.Value();

        FR_G := RR_G.Field(PlanStat_LT.FieldNo("Plan EK Limit 4"));
        FR_G.CalcField();
        Sum_Array_R[24] := FR_G.Value();

        FR_G := RR_G.Field(PlanStat_LT.FieldNo("Plan EK Limit 5"));
        FR_G.CalcField();
        Sum_Array_R[25] := FR_G.Value();

        //### Einzellimite VK:
        FR_G := RR_G.Field(PlanStat_LT.FieldNo("Plan Sales Limit 1"));
        FR_G.CalcField();
        Sum_Array_R[26] := FR_G.Value();

        FR_G := RR_G.Field(PlanStat_LT.FieldNo("Plan Sales Limit 2"));
        FR_G.CalcField();
        Sum_Array_R[27] := FR_G.Value();

        FR_G := RR_G.Field(PlanStat_LT.FieldNo("Plan Sales Limit 3"));
        FR_G.CalcField();
        Sum_Array_R[28] := FR_G.Value();

        FR_G := RR_G.Field(PlanStat_LT.FieldNo("Plan Sales Limit 4"));
        FR_G.CalcField();
        Sum_Array_R[29] := FR_G.Value();

        FR_G := RR_G.Field(PlanStat_LT.FieldNo("Plan Sales Limit 5"));
        FR_G.CalcField();
        Sum_Array_R[30] := FR_G.Value();

        //FR_G := RR_G.Field(PlanStat_LT.FieldNo("Plan Sales Order Amount"));
        //FR_G.CalcField;
        //Sum_Array_R[14] := FR_G.Value();

        //FR_G := RR_G.Field(PlanStat_LT.FieldNo("Plan Sales Order Qty."));
        //FR_G.CalcField;
        //Sum_Array_R[15] := FR_G.Value();
    end;

    /// <summary>
    /// CalcTotalsPlanFixed.
    /// </summary>
    /// <param name="PlanCube_PT">Record "BET FN Planning Value Cube".</param>
    /// <param name="PlanDoc_PT">Record "BET FN Planning Document".</param>
    /// <param name="PlanView_PT">Record "BET FN Planning View".</param>
    /// <param name="SumArray_R">VAR array[30] of Decimal.</param>
    procedure CalcTotalsPlanFixed(PlanCube_PT: Record "BET FN Planning Value Cube"; PlanDoc_PT: Record "BET FN Planning Document"; PlanView_PT: Record "BET FN Planning View"; var SumArray_R: array[30] of Decimal)
    var
        PlanStat_LT: Record "BET FN Planning Statistic";
        pos_L: Integer;
        Filtertext2_L: Text[1024];
        Filtertext_L: Text[1024];
    begin

        Filtertext_L := Filtertext_G;
        Filtertext_L := PlanStat_LT.FieldCaption(Fixed) + '=FILTER(' + Format(1) + ')' + ',' + Filtertext_L;
        RR_G.SetView('WHERE(' + Filtertext_L + ')');

        Filtertext2_L := Filtertext_L;    // Filter merken

        if PlanCube_PT.Date = 0D then begin
            FR_G := RR_G.Field(PlanStat_LT.FieldNo("Plan VK Anfangsbestand"));
            FR_G.CalcField();
            SumArray_R[1] := FR_G.Value();
            FR_G := RR_G.Field(PlanStat_LT.FieldNo("Plan Menge Anfangsbestand"));
            FR_G.CalcField();
            SumArray_R[2] := FR_G.Value();
            FR_G := RR_G.Field(PlanStat_LT.FieldNo("Plan EK Anfangsbestand"));
            FR_G.CalcField();
            SumArray_R[3] := FR_G.Value();
        end

        else begin
            //### AB-Summe aus den ersten Monaten bilden:
            //### Filter neu erstellen
            pos_L := StrPos(Filtertext_L, PlanStat_LT.FieldCaption(DateFilter));
            if pos_L > 0 then
                Filtertext_L := CopyStr(PadStr(Filtertext_L, pos_L - 1), 1, MaxStrLen(Filtertext_L));

            Filtertext_L := Filtertext_L + PlanStat_LT.FieldCaption(DateFilter) + '=FILTER(' + Format(PlanDoc_PT."Start Date") + '),';
            Filtertext_L := DelChr(Filtertext_L, '>', ',');
            RR_G.SetView('WHERE(' + Filtertext_L + ')');

            //### jetzt Bestände berechnen
            FR_G := RR_G.Field(PlanStat_LT.FieldNo("Plan VK Anfangsbestand"));
            FR_G.CalcField();
            SumArray_R[1] := FR_G.Value();
            FR_G := RR_G.Field(PlanStat_LT.FieldNo("Plan Menge Anfangsbestand"));
            FR_G.CalcField();
            SumArray_R[2] := FR_G.Value();
            FR_G := RR_G.Field(PlanStat_LT.FieldNo("Plan EK Anfangsbestand"));
            FR_G.CalcField();
            SumArray_R[3] := FR_G.Value();

            //### Filter wieder zurücksetzen
            RR_G.SetView('WHERE(' + Filtertext2_L + ')');
        end;

        FR_G := RR_G.Field(PlanStat_LT.FieldNo("Plan VK Umsatz"));
        FR_G.CalcField();
        SumArray_R[4] := FR_G.Value();

        FR_G := RR_G.Field(PlanStat_LT.FieldNo("Plan VK Rabatt"));
        FR_G.CalcField();
        SumArray_R[5] := FR_G.Value();

        FR_G := RR_G.Field(PlanStat_LT.FieldNo("Plan VK Abschrift"));
        FR_G.CalcField();
        SumArray_R[6] := FR_G.Value();

        FR_G := RR_G.Field(PlanStat_LT.FieldNo("Plan VK WE (Limit)"));
        FR_G.CalcField();
        SumArray_R[7] := FR_G.Value();

        FR_G := RR_G.Field(PlanStat_LT.FieldNo("Plan Menge Umsatz"));
        FR_G.CalcField();
        SumArray_R[9] := FR_G.Value();

        FR_G := RR_G.Field(PlanStat_LT.FieldNo("Plan Menge WE (Limit)"));
        FR_G.CalcField();
        SumArray_R[10] := FR_G.Value();

        FR_G := RR_G.Field(PlanStat_LT.FieldNo("Plan EK Umsatz"));
        FR_G.CalcField();
        SumArray_R[12] := FR_G.Value();

        FR_G := RR_G.Field(PlanStat_LT.FieldNo("Plan EK WE (Limit)"));
        FR_G.CalcField();
        SumArray_R[13] := FR_G.Value();
        FR_G := RR_G.Field(PlanStat_LT.FieldNo("Plan EK Limit 1"));
        FR_G.CalcField();
        SumArray_R[21] := FR_G.Value();

        FR_G := RR_G.Field(PlanStat_LT.FieldNo("Plan EK Limit 2"));
        FR_G.CalcField();
        SumArray_R[22] := FR_G.Value();

        FR_G := RR_G.Field(PlanStat_LT.FieldNo("Plan EK Limit 3"));
        FR_G.CalcField();
        SumArray_R[23] := FR_G.Value();

        FR_G := RR_G.Field(PlanStat_LT.FieldNo("Plan EK Limit 4"));
        FR_G.CalcField();
        SumArray_R[24] := FR_G.Value();

        FR_G := RR_G.Field(PlanStat_LT.FieldNo("Plan EK Limit 5"));
        FR_G.CalcField();
        SumArray_R[25] := FR_G.Value();
    end;

    /// <summary>
    /// CalcTotalsDeltaAndDistr.
    /// </summary>
    /// <param name="SumArray_P">array[30] of Decimal.</param>
    /// <param name="SumArrayFixed_P">array[30] of Decimal.</param>
    /// <param name="SumArrayDelta_R">VAR array[30] of Decimal.</param>
    /// <param name="SumArrayDistr_R">VAR array[30] of Decimal.</param>
    /// <param name="PlanView_PT">Record "BET FN Planning View".</param>
    procedure CalcTotalsDeltaAndDistr(SumArray_P: array[30] of Decimal; SumArrayFixed_P: array[30] of Decimal; var SumArrayDelta_R: array[30] of Decimal; var SumArrayDistr_R: array[30] of Decimal; PlanView_PT: Record "BET FN Planning View")
    var
        i_L: Integer;
        FixValueLargerThanDistributionValueErr: Label 'Fixed value is greater than the value to be distributed [%1].', Comment = '%1';
    begin
        //### für alle Werte Differenzen berechnen (Summe gesamt - Summe fixierte Zeilen)
        //### der Rest, der bleibt, kann verteilt werden

        //### DeltaArray beinhaltet die Verteilbasis der nicht fixierten Zeilen (WIE wird verteilt):
        for i_L := 1 to ArrayLen(SumArray_P) do
            SumArrayDelta_R[i_L] := SumArray_P[i_L] - SumArrayFixed_P[i_L];

        //### DistrArray beinhaltet die Differenz aus zuverteilendem Wert und fixiertem Wert (WAS wird verteilt):
        //### VK Anfangsbestand:
        SumArrayDistr_R[1] := PlanView_PT."Plan Sales Init. Inv." - SumArrayFixed_P[1];
        if SumArrayDistr_R[1] < 0 then
            Error(FixValueLargerThanDistributionValueErr, PlanView_PT.FieldCaption("Plan Sales Init. Inv."));

        //### Menge Anfangsbestand:
        SumArrayDistr_R[2] := PlanView_PT."Plan Qty. Init. Inv." - SumArrayFixed_P[2];
        if SumArrayDistr_R[2] < 0 then
            Error(FixValueLargerThanDistributionValueErr, PlanView_PT.FieldCaption("Plan Qty. Init. Inv."));

        //### EK Anfangsbestand:
        SumArrayDistr_R[3] := PlanView_PT."Plan Cost Init. Inv." - SumArrayFixed_P[3];
        if SumArrayDistr_R[3] < 0 then
            Error(FixValueLargerThanDistributionValueErr, PlanView_PT.FieldCaption("Plan Cost Init. Inv."));

        //### VK Umsatz:
        SumArrayDistr_R[4] := PlanView_PT."Plan Sales Amount" - SumArrayFixed_P[4];
        if SumArrayDistr_R[4] < 0 then
            Error(FixValueLargerThanDistributionValueErr, PlanView_PT.FieldCaption("Plan Sales Amount"));

        //### VK Rabatt:
        SumArrayDistr_R[5] := PlanView_PT."Plan Sales Discount" - SumArrayFixed_P[5];
        if SumArrayDistr_R[5] < 0 then
            Error(FixValueLargerThanDistributionValueErr, PlanView_PT.FieldCaption("Plan Sales Discount"));

        //### VK Abschrift:
        SumArrayDistr_R[6] := PlanView_PT."Plan Gross Sales Pr. Reduction" - SumArrayFixed_P[6];
        if SumArrayDistr_R[6] < 0 then
            Error(FixValueLargerThanDistributionValueErr, PlanView_PT.FieldCaption("Plan Gross Sales Pr. Reduction"));

        //### VK WE Limit:
        SumArrayDistr_R[7] := PlanView_PT."Plan Sales Am. Purchase" - SumArrayFixed_P[7];
        if SumArrayDistr_R[7] < 0 then
            Error(FixValueLargerThanDistributionValueErr, PlanView_PT.FieldCaption("Plan Sales Am. Purchase"));

        //### Menge Umsatz:
        SumArrayDistr_R[9] := PlanView_PT."Plan Qty. Sale" - SumArrayFixed_P[9];
        if SumArrayDistr_R[9] < 0 then
            Error(FixValueLargerThanDistributionValueErr, PlanView_PT.FieldCaption("Plan Qty. Sale"));

        //### Menge WE Limit:
        SumArrayDistr_R[10] := PlanView_PT."Plan Qty. Purchase" - SumArrayFixed_P[10];
        if SumArrayDistr_R[10] < 0 then
            Error(FixValueLargerThanDistributionValueErr, PlanView_PT.FieldCaption("Plan Qty. Purchase"));

        //### EK Umsatz:
        SumArrayDistr_R[12] := PlanView_PT."Plan Cost of Sales" - SumArrayFixed_P[12];
        if SumArrayDistr_R[12] < 0 then
            Error(FixValueLargerThanDistributionValueErr, PlanView_PT.FieldCaption("Plan Cost of Sales"));

        //### EK WE Limit:
        SumArrayDistr_R[13] := PlanView_PT."Plan Cost Am. Purchase" - SumArrayFixed_P[13];
        if SumArrayDistr_R[13] < 0 then
            Error(FixValueLargerThanDistributionValueErr, PlanView_PT.FieldCaption("Plan Cost Am. Purchase"));



        //### EK WE Limit 1:
        SumArrayDistr_R[21] := PlanView_PT."Plan Cost Am. Purch. 1" - SumArrayFixed_P[21];
        if SumArrayDistr_R[21] < 0 then
            Error(FixValueLargerThanDistributionValueErr, PlanView_PT.FieldCaption("Plan Cost Am. Purch. 1"));

        //### EK WE Limit 2:
        SumArrayDistr_R[22] := PlanView_PT."Plan Cost Am. Purch. 2" - SumArrayFixed_P[22];
        if SumArrayDistr_R[22] < 0 then
            Error(FixValueLargerThanDistributionValueErr, PlanView_PT.FieldCaption("Plan Cost Am. Purch. 2"));

        //### EK WE Limit 3:
        SumArrayDistr_R[23] := PlanView_PT."Plan Cost Am. Purch. 3" - SumArrayFixed_P[23];
        if SumArrayDistr_R[23] < 0 then
            Error(FixValueLargerThanDistributionValueErr, PlanView_PT.FieldCaption("Plan Cost Am. Purch. 3"));

        //### EK WE Limit 4:
        SumArrayDistr_R[24] := PlanView_PT."Plan Cost Am. Purch. 4" - SumArrayFixed_P[24];
        if SumArrayDistr_R[24] < 0 then
            Error(FixValueLargerThanDistributionValueErr, PlanView_PT.FieldCaption("Plan Cost Am. Purch. 4"));

        //### EK WE Limit 5:
        SumArrayDistr_R[25] := PlanView_PT."Plan Cost Am. Purch. 5" - SumArrayFixed_P[25];
        if SumArrayDistr_R[25] < 0 then
            Error(FixValueLargerThanDistributionValueErr, PlanView_PT.FieldCaption("Plan Cost Am. Purch. 5"));
    end;

    /// <summary>
    /// DistributePlan.
    /// </summary>
    /// <param name="PlanCube_RT">VAR Record "BET FN Planning Value Cube".</param>
    /// <param name="PlanView_PT">Record "BET FN Planning View".</param>
    /// <param name="Sum_Array_P">array[30] of Decimal.</param>
    /// <param name="lines_P">Integer.</param>
    /// <param name="datetime_P">DateTime.</param>
    /// <param name="NoOfDateRecords_P">Integer.</param>
    procedure DistributePlan(var PlanCube_RT: Record "BET FN Planning Value Cube"; PlanView_PT: Record "BET FN Planning View"; Sum_Array_P: array[30] of Decimal; lines_P: Integer; datetime_P: DateTime; NoOfDateRecords_P: Integer)
    var
        PlanViewSum_LT: Record "BET FN Planning View";
    begin
#pragma warning disable AL0432
        PlanViewSum_LT.Init();
        PlanViewSum_LT := PlanView_PT;

        if PlanView_PT.Date <> 0D then begin

            if PlanCube_RT.Date = 0D then begin              //### "Plan N VK Anfangsbestand"
                if Sum_Array_P[1] = 0 then
                    PlanCube_RT."Plan Sales Init. Inv." := PlanViewSum_LT."Plan Sales Init. Inv." / lines_P
                else
                    PlanCube_RT."Plan Sales Init. Inv." := PlanCube_RT."Plan Sales Init. Inv." / Sum_Array_P[1]
                                                            * PlanViewSum_LT."Plan Sales Init. Inv."
            end else
                if PlanCube_RT."First Month" then begin
                    if Sum_Array_P[1] = 0 then
                        PlanCube_RT."Plan Sales Init. Inv." := PlanViewSum_LT."Plan Sales Init. Inv." / lines_P // * NoOfDateRecords_P
                    else
                        PlanCube_RT."Plan Sales Init. Inv." := PlanCube_RT."Plan Sales Init. Inv." / Sum_Array_P[1]
                                                               * PlanViewSum_LT."Plan Sales Init. Inv."
                end else
                    PlanCube_RT."Plan Sales Init. Inv." := 0;

            if PlanCube_RT.Date = 0D then begin               //### "Plan N Menge Anfangsbestand"
                if Sum_Array_P[2] = 0 then
                    PlanCube_RT."Plan Qty. Init. Inv." := PlanViewSum_LT."Plan Qty. Init. Inv." / lines_P
                else
                    PlanCube_RT."Plan Qty. Init. Inv." := PlanCube_RT."Plan Qty. Init. Inv." / Sum_Array_P[2]
                                                              * PlanViewSum_LT."Plan Qty. Init. Inv.";
            end
            else
                if PlanCube_RT."First Month" then begin
                    if Sum_Array_P[2] = 0 then
                        PlanCube_RT."Plan Qty. Init. Inv." := PlanViewSum_LT."Plan Qty. Init. Inv." / lines_P //* NoOfDateRecords_P
                    else
                        PlanCube_RT."Plan Qty. Init. Inv." := PlanCube_RT."Plan Qty. Init. Inv." / Sum_Array_P[2]
                                                                  * PlanViewSum_LT."Plan Qty. Init. Inv.";
                end
                else
                    PlanCube_RT."Plan Qty. Init. Inv." := 0;

            if PlanCube_RT.Date = 0D then begin               //### "Plan N EK Anfangsbestand"
                if Sum_Array_P[3] = 0 then
                    PlanCube_RT."Plan Cost Init. Inv." := PlanViewSum_LT."Plan Cost Init. Inv." / lines_P
                else
                    PlanCube_RT."Plan Cost Init. Inv." := PlanCube_RT."Plan Cost Init. Inv." / Sum_Array_P[3]
                                                           * PlanViewSum_LT."Plan Cost Init. Inv.";
            end
            else
                if PlanCube_RT."First Month" then begin
                    if Sum_Array_P[3] = 0 then
                        PlanCube_RT."Plan Cost Init. Inv." := PlanViewSum_LT."Plan Cost Init. Inv." / lines_P //* NoOfDateRecords_P
                    else
                        PlanCube_RT."Plan Cost Init. Inv." := PlanCube_RT."Plan Cost Init. Inv." / Sum_Array_P[3]
                                                               * PlanViewSum_LT."Plan Cost Init. Inv.";
                end
                else
                    PlanCube_RT."Plan Cost Init. Inv." := 0;


        end else begin
            if PlanCube_RT.Date = 0D then begin               //### "Plan N VK Anfangsbestand"
                if Sum_Array_P[1] = 0 then
                    PlanCube_RT."Plan Sales Init. Inv." := PlanViewSum_LT."Plan Sales Init. Inv." / lines_P
                else
                    PlanCube_RT."Plan Sales Init. Inv." := PlanCube_RT."Plan Sales Init. Inv." / Sum_Array_P[1]
                                                            * PlanViewSum_LT."Plan Sales Init. Inv.";
            end
            else
                if PlanCube_RT."First Month" then begin
                    if Sum_Array_P[1] = 0 then
                        PlanCube_RT."Plan Sales Init. Inv." := PlanViewSum_LT."Plan Sales Init. Inv." / lines_P * NoOfDateRecords_P
                    else
                        PlanCube_RT."Plan Sales Init. Inv." := PlanCube_RT."Plan Sales Init. Inv." / Sum_Array_P[1]
                                                               * PlanViewSum_LT."Plan Sales Init. Inv.";
                end
                else
                    PlanCube_RT."Plan Sales Init. Inv." := 0;

            if PlanCube_RT.Date = 0D then begin               //### "Plan N Menge Anfangsbestand"
                if Sum_Array_P[2] = 0 then
                    PlanCube_RT."Plan Qty. Init. Inv." := PlanViewSum_LT."Plan Qty. Init. Inv." / lines_P
                else
                    PlanCube_RT."Plan Qty. Init. Inv." := PlanCube_RT."Plan Qty. Init. Inv." / Sum_Array_P[2]
                                                              * PlanViewSum_LT."Plan Qty. Init. Inv.";
            end
            else
                if PlanCube_RT."First Month" then begin
                    if Sum_Array_P[2] = 0 then
                        PlanCube_RT."Plan Qty. Init. Inv." := PlanViewSum_LT."Plan Qty. Init. Inv." / lines_P * NoOfDateRecords_P
                    else
                        PlanCube_RT."Plan Qty. Init. Inv." := PlanCube_RT."Plan Qty. Init. Inv." / Sum_Array_P[2]
                                                                  * PlanViewSum_LT."Plan Qty. Init. Inv.";
                end
                else
                    PlanCube_RT."Plan Qty. Init. Inv." := 0;

            if PlanCube_RT.Date = 0D then begin               //### "Plan N EK Anfangsbestand"
                if Sum_Array_P[3] = 0 then
                    PlanCube_RT."Plan Cost Init. Inv." := PlanViewSum_LT."Plan Cost Init. Inv." / lines_P
                else
                    PlanCube_RT."Plan Cost Init. Inv." := PlanCube_RT."Plan Cost Init. Inv." / Sum_Array_P[3]
                                                           * PlanViewSum_LT."Plan Cost Init. Inv.";
            end
            else
                if PlanCube_RT."First Month" then begin
                    if Sum_Array_P[3] = 0 then
                        PlanCube_RT."Plan Cost Init. Inv." := PlanViewSum_LT."Plan Cost Init. Inv." / lines_P * NoOfDateRecords_P
                    else
                        PlanCube_RT."Plan Cost Init. Inv." := PlanCube_RT."Plan Cost Init. Inv." / Sum_Array_P[3]
                                                               * PlanViewSum_LT."Plan Cost Init. Inv.";
                end
                else
                    PlanCube_RT."Plan Cost Init. Inv." := 0;
        end;

        if Sum_Array_P[4] = 0 then                       //### "Plan VK Umsatz" :
            PlanCube_RT."Plan Sales Amount" := PlanViewSum_LT."Plan Sales Amount" / lines_P
        else
            PlanCube_RT."Plan Sales Amount" := PlanCube_RT."Plan Sales Amount" / Sum_Array_P[4] * PlanViewSum_LT."Plan Sales Amount";


        if Sum_Array_P[5] = 0 then                       //### "Plan VK Umsatz PÄ" :
            PlanCube_RT."Plan Sal. Am. Discount" := PlanViewSum_LT."Plan Sales Discount" / lines_P
        else
            PlanCube_RT."Plan Sal. Am. Discount" := PlanCube_RT."Plan Sal. Am. Discount" / Sum_Array_P[5] * PlanViewSum_LT."Plan Sales Discount";


        if Sum_Array_P[6] = 0 then                        //### "Plan VK BPA"
            PlanCube_RT."Plan Gross Sales Pr. Reduction" := PlanViewSum_LT."Plan Gross Sales Pr. Reduction" / lines_P
        else
            PlanCube_RT."Plan Gross Sales Pr. Reduction" := PlanCube_RT."Plan Gross Sales Pr. Reduction" / Sum_Array_P[6] * PlanViewSum_LT."Plan Gross Sales Pr. Reduction";

        if Sum_Array_P[7] = 0 then                        //### "Plan VK WE (Limit)"
            PlanCube_RT."Plan Sales Am. Purchase" := PlanViewSum_LT."Plan Sales Am. Purchase" / lines_P
        else
            PlanCube_RT."Plan Sales Am. Purchase" := PlanCube_RT."Plan Sales Am. Purchase" / Sum_Array_P[7]
                                                  * PlanViewSum_LT."Plan Sales Am. Purchase";

        if Sum_Array_P[9] = 0 then                        //### "Plan Menge Umsatz"
            PlanCube_RT."Plan Qty. Sale" := PlanViewSum_LT."Plan Qty. Sale" / lines_P
        else
            PlanCube_RT."Plan Qty. Sale" := PlanCube_RT."Plan Qty. Sale" / Sum_Array_P[9] * PlanViewSum_LT."Plan Qty. Sale";

        if Sum_Array_P[10] = 0 then                       //### "Plan Menge WE (Limit)"
            PlanCube_RT."Plan Qty. Purchase" := PlanViewSum_LT."Plan Qty. Purchase" / lines_P
        else
            PlanCube_RT."Plan Qty. Purchase" := PlanCube_RT."Plan Qty. Purchase" / Sum_Array_P[10]
                                                  * PlanViewSum_LT."Plan Qty. Purchase";

        if Sum_Array_P[12] = 0 then                       //### "Plan EK Umsatz"
            PlanCube_RT."Plan Cost of Sales" := PlanViewSum_LT."Plan Cost of Sales" / lines_P
        else
            PlanCube_RT."Plan Cost of Sales" := PlanCube_RT."Plan Cost of Sales" / Sum_Array_P[12] * PlanViewSum_LT."Plan Cost of Sales";

        if Sum_Array_P[13] = 0 then                       //### "Plan EK WE (Limit)"
            PlanCube_RT."Plan Cost Am. Purchase" := PlanViewSum_LT."Plan Cost Am. Purchase" / lines_P
        else
            PlanCube_RT."Plan Cost Am. Purchase" := PlanCube_RT."Plan Cost Am. Purchase" / Sum_Array_P[13]
                                                  * PlanViewSum_LT."Plan Cost Am. Purchase";
        PlanCube_RT."Plan Sales Closing Inv." := PlanCube_RT."Plan Sales Am. Purchase" -
                                                 PlanCube_RT."Plan Sales Amount" -
                                                 PlanCube_RT."Plan Sal. Am. Discount" -
                                                 PlanCube_RT."Plan Gross Sales Pr. Reduction";

        PlanCube_RT."Plan Cost Closing Inv." := PlanCube_RT."Plan Cost Am. Purchase" -
                                                PlanCube_RT."Plan Cost of Sales";

        PlanCube_RT."Plan Qty. Closing Inv." := PlanCube_RT."Plan Qty. Purchase" -
                                                PlanCube_RT."Plan Qty. Sale";



        //### EK-Limite 1-5:

        //### EK-Limit 1:
        if Sum_Array_P[21] = 0 then
            PlanCube_RT."Plan Cost Am. Purch. 1" := PlanViewSum_LT."Plan Cost Am. Purch. 1" / lines_P
        else
            PlanCube_RT."Plan Cost Am. Purch. 1" := PlanCube_RT."Plan Cost Am. Purch. 1" / Sum_Array_P[21] * PlanViewSum_LT."Plan Cost Am. Purch. 1";

        //### EK-Limit 2:
        if Sum_Array_P[22] = 0 then
            PlanCube_RT."Plan Cost Am. Purch. 2" := PlanViewSum_LT."Plan Cost Am. Purch. 2" / lines_P
        else
            PlanCube_RT."Plan Cost Am. Purch. 2" := PlanCube_RT."Plan Cost Am. Purch. 2" / Sum_Array_P[22] * PlanViewSum_LT."Plan Cost Am. Purch. 2";

        //### EK-Limit 3:
        if Sum_Array_P[23] = 0 then
            PlanCube_RT."Plan Cost Am. Purch. 3" := PlanViewSum_LT."Plan Cost Am. Purch. 3" / lines_P
        else
            PlanCube_RT."Plan Cost Am. Purch. 3" := PlanCube_RT."Plan Cost Am. Purch. 3" / Sum_Array_P[23] * PlanViewSum_LT."Plan Cost Am. Purch. 3";

        //### EK-Limit 4:
        if Sum_Array_P[24] = 0 then
            PlanCube_RT."Plan Cost Am. Purch. 4" := PlanViewSum_LT."Plan Cost Am. Purch. 4" / lines_P
        else
            PlanCube_RT."Plan Cost Am. Purch. 4" := PlanCube_RT."Plan Cost Am. Purch. 4" / Sum_Array_P[24] * PlanViewSum_LT."Plan Cost Am. Purch. 4";

        //### EK-Limit 5:
        if Sum_Array_P[25] = 0 then
            PlanCube_RT."Plan Cost Am. Purch. 5" := PlanViewSum_LT."Plan Cost Am. Purch. 5" / lines_P
        else
            PlanCube_RT."Plan Cost Am. Purch. 5" := PlanCube_RT."Plan Cost Am. Purch. 5" / Sum_Array_P[25] * PlanViewSum_LT."Plan Cost Am. Purch. 5";


        //### VK-Limite 1-5:

        //### VK-Limit 1:
        if Sum_Array_P[26] = 0 then
            PlanCube_RT."Plan Sales Am. Purch. 1" := PlanViewSum_LT."Plan Sales Am. Purch. 1" / lines_P
        else
            PlanCube_RT."Plan Sales Am. Purch. 1" := PlanCube_RT."Plan Sales Am. Purch. 1" / Sum_Array_P[26] * PlanViewSum_LT."Plan Sales Am. Purch. 1";

        //### VK-Limit 2:
        if Sum_Array_P[27] = 0 then
            PlanCube_RT."Plan Sales Am. Purch. 2" := PlanViewSum_LT."Plan Sales Am. Purch. 2" / lines_P
        else
            PlanCube_RT."Plan Sales Am. Purch. 2" := PlanCube_RT."Plan Sales Am. Purch. 2" / Sum_Array_P[27] * PlanViewSum_LT."Plan Sales Am. Purch. 2";

        //### VK-Limit 3:
        if Sum_Array_P[28] = 0 then
            PlanCube_RT."Plan Sales Am. Purch. 3" := PlanViewSum_LT."Plan Sales Am. Purch. 3" / lines_P
        else
            PlanCube_RT."Plan Sales Am. Purch. 3" := PlanCube_RT."Plan Sales Am. Purch. 3" / Sum_Array_P[28] * PlanViewSum_LT."Plan Sales Am. Purch. 3";

        //### VK-Limit 4:
        if Sum_Array_P[29] = 0 then
            PlanCube_RT."Plan Sales Am. Purch. 4" := PlanViewSum_LT."Plan Sales Am. Purch. 4" / lines_P
        else
            PlanCube_RT."Plan Sales Am. Purch. 4" := PlanCube_RT."Plan Sales Am. Purch. 4" / Sum_Array_P[29] * PlanViewSum_LT."Plan Sales Am. Purch. 4";

        //### VK-Limit 5:
        if Sum_Array_P[30] = 0 then
            PlanCube_RT."Plan Sales Am. Purch. 5" := PlanViewSum_LT."Plan Sales Am. Purch. 5" / lines_P
        else
            PlanCube_RT."Plan Sales Am. Purch. 5" := PlanCube_RT."Plan Sales Am. Purch. 5" / Sum_Array_P[30] * PlanViewSum_LT."Plan Sales Am. Purch. 5";

        //### "Plan VK Auftragseingang"
        if Sum_Array_P[14] = 0 then
            PlanCube_RT."Plan Sales Order Amount" := PlanViewSum_LT."Plan Sales Order Amount" / lines_P
        else
            PlanCube_RT."Plan Sales Order Amount" := PlanCube_RT."Plan Sales Order Amount" / Sum_Array_P[14] * PlanViewSum_LT."Plan Sales Order Amount";

        //### "Plan Menge Auftragseingang"
        if Sum_Array_P[15] = 0 then
            PlanCube_RT."Plan Sales Order Qty." := PlanViewSum_LT."Plan Sales Order Qty." / lines_P
        else
            PlanCube_RT."Plan Sales Order Qty." := PlanCube_RT."Plan Sales Order Qty." / Sum_Array_P[15] * PlanViewSum_LT."Plan Sales Order Qty.";


        PlanCube_RT."Time-Stamp" := datetime_P;
        PlanCube_RT.Modify();
#pragma warning restore AL0432
    end;

    /// <summary>
    /// DistributePlanFixed.
    /// </summary>
    /// <param name="PlanCube_RT">VAR Record "BET FN Planning Value Cube".</param>
    /// <param name="PlanView_PT">Record "BET FN Planning View".</param>
    /// <param name="lines_P">Integer.</param>
    /// <param name="datetime_P">DateTime.</param>
    /// <param name="NoOfDateRecords_P">Integer.</param>
    /// <param name="SumArrayDelta_P">array[30] of Decimal.</param>
    /// <param name="SumArrayDistr_P">array[30] of Decimal.</param>
    procedure DistributePlanFixed(var PlanCube_RT: Record "BET FN Planning Value Cube"; PlanView_PT: Record "BET FN Planning View"; lines_P: Integer; datetime_P: DateTime; NoOfDateRecords_P: Integer; SumArrayDelta_P: array[30] of Decimal; SumArrayDistr_P: array[30] of Decimal)
    var
        PlanViewSum_LT: Record "BET FN Planning View";
    begin
#pragma warning disable AL0432

        PlanViewSum_LT.Init();
        PlanViewSum_LT := PlanView_PT;

        if PlanView_PT.Date <> 0D then begin

            if PlanCube_RT.Date = 0D then begin               //### "Plan N VK Anfangsbestand"
                if SumArrayDelta_P[1] = 0 then
                    PlanCube_RT."Plan Sales Init. Inv." := SumArrayDistr_P[1] / lines_P
                else
                    PlanCube_RT."Plan Sales Init. Inv." := PlanCube_RT."Plan Sales Init. Inv." / SumArrayDelta_P[1] * SumArrayDistr_P[1];
            end
            else
                if PlanCube_RT."First Month" then begin
                    if SumArrayDelta_P[1] = 0 then
                        PlanCube_RT."Plan Sales Init. Inv." := SumArrayDistr_P[1] / lines_P // * NoOfDateRecords_P
                    else
                        PlanCube_RT."Plan Sales Init. Inv." := PlanCube_RT."Plan Sales Init. Inv." / SumArrayDelta_P[1] * SumArrayDistr_P[1];
                end
                else
                    PlanCube_RT."Plan Sales Init. Inv." := 0;

            if PlanCube_RT.Date = 0D then begin               //### "Plan N Menge Anfangsbestand"
                if SumArrayDelta_P[2] = 0 then
                    PlanCube_RT."Plan Qty. Init. Inv." := SumArrayDistr_P[2] / lines_P
                else
                    PlanCube_RT."Plan Qty. Init. Inv." := PlanCube_RT."Plan Qty. Init. Inv." / SumArrayDelta_P[2] * SumArrayDistr_P[2];
            end
            else
                if PlanCube_RT."First Month" then begin
                    if SumArrayDelta_P[2] = 0 then
                        PlanCube_RT."Plan Qty. Init. Inv." := SumArrayDistr_P[2] / lines_P //* NoOfDateRecords_P
                    else
                        PlanCube_RT."Plan Qty. Init. Inv." := PlanCube_RT."Plan Qty. Init. Inv." / SumArrayDelta_P[2] * SumArrayDistr_P[2];
                end
                else
                    PlanCube_RT."Plan Qty. Init. Inv." := 0;

            if PlanCube_RT.Date = 0D then begin               //### "Plan N EK Anfangsbestand"
                if SumArrayDelta_P[3] = 0 then
                    PlanCube_RT."Plan Cost Init. Inv." := SumArrayDistr_P[3] / lines_P
                else
                    PlanCube_RT."Plan Cost Init. Inv." := PlanCube_RT."Plan Cost Init. Inv." / SumArrayDelta_P[3] * SumArrayDistr_P[3];
            end
            else
                if PlanCube_RT."First Month" then begin
                    if SumArrayDelta_P[3] = 0 then
                        PlanCube_RT."Plan Cost Init. Inv." := SumArrayDistr_P[3] / lines_P //* NoOfDateRecords_P
                    else
                        PlanCube_RT."Plan Cost Init. Inv." := PlanCube_RT."Plan Cost Init. Inv." / SumArrayDelta_P[3] * SumArrayDistr_P[3];
                end
                else
                    PlanCube_RT."Plan Cost Init. Inv." := 0;


        end else begin
            if PlanCube_RT.Date = 0D then begin              //### "Plan N VK Anfangsbestand"
                if SumArrayDelta_P[1] = 0 then
                    PlanCube_RT."Plan Sales Init. Inv." := SumArrayDistr_P[1] / lines_P
                else
                    PlanCube_RT."Plan Sales Init. Inv." := PlanCube_RT."Plan Sales Init. Inv." / SumArrayDelta_P[1] * SumArrayDistr_P[1];
            end else
                if PlanCube_RT."First Month" then begin
                    if SumArrayDelta_P[1] = 0 then
                        PlanCube_RT."Plan Sales Init. Inv." := SumArrayDistr_P[1] / lines_P * NoOfDateRecords_P
                    else
                        PlanCube_RT."Plan Sales Init. Inv." := PlanCube_RT."Plan Sales Init. Inv." / SumArrayDelta_P[1] * SumArrayDistr_P[1];
                end else
                    PlanCube_RT."Plan Sales Init. Inv." := 0;

            if PlanCube_RT.Date = 0D then begin              //### "Plan N Menge Anfangsbestand"
                if SumArrayDelta_P[2] = 0 then
                    PlanCube_RT."Plan Qty. Init. Inv." := SumArrayDistr_P[2] / lines_P
                else
                    PlanCube_RT."Plan Qty. Init. Inv." := PlanCube_RT."Plan Qty. Init. Inv." / SumArrayDelta_P[2] * SumArrayDistr_P[2];
            end else
                if PlanCube_RT."First Month" then begin
                    if SumArrayDelta_P[2] = 0 then
                        PlanCube_RT."Plan Qty. Init. Inv." := SumArrayDistr_P[2] / lines_P * NoOfDateRecords_P
                    else
                        PlanCube_RT."Plan Qty. Init. Inv." := PlanCube_RT."Plan Qty. Init. Inv." / SumArrayDelta_P[2] * SumArrayDistr_P[2];
                end else
                    PlanCube_RT."Plan Qty. Init. Inv." := 0;

            if PlanCube_RT.Date = 0D then begin              //### "Plan N EK Anfangsbestand"
                if SumArrayDelta_P[3] = 0 then
                    PlanCube_RT."Plan Cost Init. Inv." := SumArrayDistr_P[3] / lines_P
                else
                    PlanCube_RT."Plan Cost Init. Inv." := PlanCube_RT."Plan Cost Init. Inv." / SumArrayDelta_P[3] * SumArrayDistr_P[3]
            end else
                if PlanCube_RT."First Month" then begin
                    if SumArrayDelta_P[3] = 0 then
                        PlanCube_RT."Plan Cost Init. Inv." := SumArrayDistr_P[3] / lines_P * NoOfDateRecords_P
                    else
                        PlanCube_RT."Plan Cost Init. Inv." := PlanCube_RT."Plan Cost Init. Inv." / SumArrayDelta_P[3] * SumArrayDistr_P[3];
                end else
                    PlanCube_RT."Plan Cost Init. Inv." := 0;
        end;


        //### Umsatz VK:
        if SumArrayDelta_P[4] <> 0 then
            PlanCube_RT."Plan Sales Amount" := PlanCube_RT."Plan Sales Amount" / SumArrayDelta_P[4] * SumArrayDistr_P[4]
        else
            PlanCube_RT."Plan Sales Amount" := 0;

        //### Preisänderungen/Rabatte VK:
        if SumArrayDelta_P[5] <> 0 then
            PlanCube_RT."Plan Sal. Am. Discount" := PlanCube_RT."Plan Sal. Am. Discount" / SumArrayDelta_P[5] * SumArrayDistr_P[5]
        else
            PlanCube_RT."Plan Sal. Am. Discount" := 0;


        //### Brutto-Preisabschriften VK:
        if SumArrayDelta_P[6] <> 0 then
            PlanCube_RT."Plan Gross Sales Pr. Reduction" := PlanCube_RT."Plan Gross Sales Pr. Reduction" / SumArrayDelta_P[6] * SumArrayDistr_P[6]
        else
            PlanCube_RT."Plan Gross Sales Pr. Reduction" := 0;


        //### Wareneinkauf VK:
        if SumArrayDelta_P[7] <> 0 then
            PlanCube_RT."Plan Sales Am. Purchase" := PlanCube_RT."Plan Sales Am. Purchase" / SumArrayDelta_P[7] * SumArrayDistr_P[7]
        else
            PlanCube_RT."Plan Sales Am. Purchase" := 0;


        //### Umsatz Menge:
        if SumArrayDelta_P[9] <> 0 then
            PlanCube_RT."Plan Qty. Sale" := PlanCube_RT."Plan Qty. Sale" / SumArrayDelta_P[9] * SumArrayDistr_P[9]
        else
            PlanCube_RT."Plan Qty. Sale" := 0;


        //### Wareneinkauf Menge:
        if SumArrayDelta_P[10] <> 0 then
            PlanCube_RT."Plan Qty. Purchase" := PlanCube_RT."Plan Qty. Purchase" / SumArrayDelta_P[10] * SumArrayDistr_P[10]
        else
            PlanCube_RT."Plan Qty. Purchase" := 0;


        //### Umsatz EK:
        if SumArrayDelta_P[12] <> 0 then
            PlanCube_RT."Plan Cost of Sales" := PlanCube_RT."Plan Cost of Sales" / SumArrayDelta_P[12] * SumArrayDistr_P[12]
        else
            PlanCube_RT."Plan Cost of Sales" := 0;


        //### Einkauf EK:
        if SumArrayDelta_P[13] <> 0 then
            PlanCube_RT."Plan Cost Am. Purchase" := PlanCube_RT."Plan Cost Am. Purchase" / SumArrayDelta_P[13] * SumArrayDistr_P[13]
        else
            PlanCube_RT."Plan Cost Am. Purchase" := 0;


        //### EK-Limite 1-5:

        //### EK-Limit 1:
        if SumArrayDelta_P[21] <> 0 then
            PlanCube_RT."Plan Cost Am. Purch. 1" := PlanCube_RT."Plan Cost Am. Purch. 1" / SumArrayDelta_P[21] * SumArrayDistr_P[21]
        else
            PlanCube_RT."Plan Cost Am. Purch. 1" := 0;

        //### EK-Limit 2:
        if SumArrayDelta_P[22] <> 0 then
            PlanCube_RT."Plan Cost Am. Purch. 2" := PlanCube_RT."Plan Cost Am. Purch. 2" / SumArrayDelta_P[22] * SumArrayDistr_P[22]
        else
            PlanCube_RT."Plan Cost Am. Purch. 2" := 0;

        //### EK-Limit 3:
        if SumArrayDelta_P[23] <> 0 then
            PlanCube_RT."Plan Cost Am. Purch. 3" := PlanCube_RT."Plan Cost Am. Purch. 3" / SumArrayDelta_P[23] * SumArrayDistr_P[23]
        else
            PlanCube_RT."Plan Cost Am. Purch. 3" := 0;

        //### EK-Limit 4:
        if SumArrayDelta_P[24] <> 0 then
            PlanCube_RT."Plan Cost Am. Purch. 4" := PlanCube_RT."Plan Cost Am. Purch. 4" / SumArrayDelta_P[24] * SumArrayDistr_P[24]
        else
            PlanCube_RT."Plan Cost Am. Purch. 4" := 0;

        //### EK-Limit 5:
        if SumArrayDelta_P[25] <> 0 then
            PlanCube_RT."Plan Cost Am. Purch. 5" := PlanCube_RT."Plan Cost Am. Purch. 5" / SumArrayDelta_P[25] * SumArrayDistr_P[25]
        else
            PlanCube_RT."Plan Cost Am. Purch. 5" := 0;

        //### VK-Limite 1-5:

        //### VK-Limit 1:
        if SumArrayDelta_P[26] = 0 then
            PlanCube_RT."Plan Sales Am. Purch. 1" := PlanViewSum_LT."Plan Sales Am. Purch. 1" / lines_P
        else
            PlanCube_RT."Plan Sales Am. Purch. 1" := PlanCube_RT."Plan Sales Am. Purch. 1" / SumArrayDelta_P[26] * SumArrayDistr_P[26];

        //### VK-Limit 2:
        if SumArrayDelta_P[27] = 0 then
            PlanCube_RT."Plan Sales Am. Purch. 2" := PlanViewSum_LT."Plan Sales Am. Purch. 2" / lines_P
        else
            PlanCube_RT."Plan Sales Am. Purch. 2" := PlanCube_RT."Plan Sales Am. Purch. 2" / SumArrayDelta_P[27] * SumArrayDistr_P[27];

        //### VK-Limit 3:
        if SumArrayDelta_P[28] = 0 then
            PlanCube_RT."Plan Sales Am. Purch. 3" := PlanViewSum_LT."Plan Sales Am. Purch. 3" / lines_P
        else
            PlanCube_RT."Plan Sales Am. Purch. 3" := PlanCube_RT."Plan Sales Am. Purch. 3" / SumArrayDelta_P[28] * SumArrayDistr_P[28];

        //### VK-Limit 4:
        if SumArrayDelta_P[29] = 0 then
            PlanCube_RT."Plan Sales Am. Purch. 4" := PlanViewSum_LT."Plan Sales Am. Purch. 4" / lines_P
        else
            PlanCube_RT."Plan Sales Am. Purch. 4" := PlanCube_RT."Plan Sales Am. Purch. 4" / SumArrayDelta_P[29] * SumArrayDistr_P[29];

        //### VK-Limit 5:
        if SumArrayDelta_P[30] = 0 then
            PlanCube_RT."Plan Sales Am. Purch. 5" := PlanViewSum_LT."Plan Sales Am. Purch. 5" / lines_P
        else
            PlanCube_RT."Plan Sales Am. Purch. 5" := PlanCube_RT."Plan Sales Am. Purch. 5" / SumArrayDelta_P[30] * SumArrayDistr_P[30];

        //### beterna ASH 190514...
        //### "Plan VK Auftragseingang"
        if SumArrayDelta_P[14] = 0 then
            PlanCube_RT."Plan Sales Order Amount" := PlanViewSum_LT."Plan Sales Order Amount" / lines_P
        else
            PlanCube_RT."Plan Sales Order Amount" := PlanCube_RT."Plan Sales Order Amount" / SumArrayDelta_P[14] * SumArrayDistr_P[14];

        //### "Plan Menge Auftragseingang"
        if SumArrayDelta_P[15] = 0 then
            PlanCube_RT."Plan Sales Order Qty." := PlanViewSum_LT."Plan Sales Order Qty." / lines_P
        else
            PlanCube_RT."Plan Sales Order Qty." := PlanCube_RT."Plan Sales Order Qty." / SumArrayDelta_P[15] * SumArrayDistr_P[15];

        PlanCube_RT."Time-Stamp" := datetime_P;
        PlanCube_RT.Modify();
#pragma warning restore AL0432
    end;

    /// <summary>
    /// CalcInitialTopDown.
    /// </summary>
    /// <param name="PlanDoc_PT">Record "BET FN Planning Document".</param>
    procedure CalcInitialTopDown(PlanDoc_PT: Record "BET FN Planning Document")
    var
        PlanView_LT: Record "BET FN Planning View";
    begin

        //### oberste Zeile (Gesamt, ohne Monate) verteilen:
        PlanView_LT.Reset();
        PlanView_LT.SetRange("Planning Document No.", PlanDoc_PT."No.");
        PlanView_LT.SetRange("Planning Document Level", 0);
        PlanView_LT.SetRange(Date, 0D);

        CalcTopDown(PlanView_LT);
    end;
}

