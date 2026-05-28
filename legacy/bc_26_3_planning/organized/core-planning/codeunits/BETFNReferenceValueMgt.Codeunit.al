/// <summary>
/// [planning]
/// Modules: 
/// </summary>
#pragma warning disable AL0432
codeunit 5138637 "BET FN Reference Value Mgt"
{
    Access = Public;

    /// <summary>
    /// CalcReferenceValueCube.
    /// </summary>
    /// <param name="PlanDoc_RT">VAR Record "BET FN Planning Document".</param>
    procedure CalcReferenceValueCube(var PlanDoc_RT: Record "BET FN Planning Document")
    var
        FashionStatEntry_LT: Record "BET FN Fashion Statistic Entry";
        PlanDocLevelBuffer_LT: Record "BET FN Planning Doc Lvl Buf";
        PlanDocDateRef_LT: Record "BET FN Planning Document D Ref";
        PlanDocLevel_LT: Record "BET FN Planning Document Level";
        PlanLevel_LT: Record "BET FN Planning Level";
        PlanSetup_LT: Record "BET FN Planning Setup";
        PlanStat_LT: Record "BET FN Planning Statistic";
        RefCube_LT: Record "BET FN Reference Value Cube";
        Date_LT: Record Date;
        CalcTopDown_LC: Codeunit "BET FN Calculate Top Down";
        RecRef_L: RecordRef;
        FieldRef_L: FieldRef;
        CalcInitialTopDown_L: Boolean;
        IsHandled: Boolean;
        IndexFilterCode_L: Code[20];
        datetime_L: DateTime;
        DecVar_L: Decimal;
        Window_L: Dialog;
        i_L: Integer;
        pos_L: Integer;
        total_L: Integer;
        CalculateReferenceValuesLbl: Label 'Calculate reference values\@1@@@@@@@@@@@@@@@@@@@@@@@';
        Filtertext_L: Text[1024];
        FiltertextTemp_L: Text[1024];
    begin
        OnBeforeCalcReferenceValueCube(PlanDoc_RT, IsHandled);
        if IsHandled then
            exit;

        //### Daten nicht aus Cache verwenden, sondern neu vom Server holen:
        if FashionStatEntry_LT.IsEmpty() then
            Error('%1 not found.', FashionStatEntry_LT.TableCaption());

        PlanSetup_LT.Get();
        PlanStat_LT.Reset();

        RefCube_LT.Reset();
        RefCube_LT.SetCurrentKey("Planning Document No.", "Index 1", "Index 2", "Index 3", "Index 4", "Index 5", "Index 6", Date);
        RefCube_LT.SetRange("Planning Document No.", PlanDoc_RT."No.");
        if RefCube_LT.FindSet(true) then begin
            RecRef_L.Open(Database::"BET FN Planning Statistic");
            Window_L.Open(CalculateReferenceValuesLbl);

            i_L := 1;
            total_L := RefCube_LT.Count();
            datetime_L := CreateDateTime(WorkDate(), Time());

            PlanDocLevel_LT.Reset();
            PlanDocLevel_LT.SetRange("Planning Document No.", PlanDoc_RT."No.");

            if RefCube_LT."Index 1" = '' then
                PlanDocLevel_LT.SetFilter("Index Code 1", '=%1', '')
            else
                PlanDocLevel_LT.SetFilter("Index Code 1", '<>%1', '');
            if RefCube_LT."Index 2" = '' then
                PlanDocLevel_LT.SetFilter("Index Code 2", '=%1', '')
            else
                PlanDocLevel_LT.SetFilter("Index Code 2", '<>%1', '');
            if RefCube_LT."Index 3" = '' then
                PlanDocLevel_LT.SetFilter("Index Code 3", '=%1', '')
            else
                PlanDocLevel_LT.SetFilter("Index Code 3", '<>%1', '');
            if RefCube_LT."Index 4" = '' then
                PlanDocLevel_LT.SetFilter("Index Code 4", '=%1', '')
            else
                PlanDocLevel_LT.SetFilter("Index Code 4", '<>%1', '');
            if RefCube_LT."Index 5" = '' then
                PlanDocLevel_LT.SetFilter("Index Code 5", '=%1', '')
            else
                PlanDocLevel_LT.SetFilter("Index Code 5", '<>%1', '');
            if RefCube_LT."Index 6" = '' then
                PlanDocLevel_LT.SetFilter("Index Code 6", '=%1', '')
            else
                PlanDocLevel_LT.SetFilter("Index Code 6", '<>%1', '');

            if RefCube_LT.Date = 0D then
                PlanDocLevel_LT.SetFilter("Activate Date Level", '=%1', false)
            else
                PlanDocLevel_LT.SetFilter("Activate Date Level", '=%1', true);

            //if PlanDocLevel_LT.FindFirst() then begin
            PlanDocLevel_LT.FindFirst();

            repeat
                i_L += 1;
                Window_L.Update(1, Round(i_L / total_L * 9999, 1));

                Filtertext_L := '';

                //### für neue Stammdaten (z.B. neue Filialen) nach Vergleichsdaten suchen
                PlanDocLevelBuffer_LT.Reset();
                PlanDocLevelBuffer_LT.SetRange("Planning Document No.", RefCube_LT."Planning Document No.");


                //### Index 1:
                if PlanLevel_LT.Get(PlanDocLevel_LT."Index Code 1") then begin
                    FieldRef_L := RecRef_L.Field(PlanLevel_LT."Planning Statistic Field");
                    if RefCube_LT."Index 1" <> '' then begin
                        IndexFilterCode_L := RefCube_LT."Index 1";
                        Filtertext_L := Filtertext_L + FieldRef_L.Caption() + '=FILTER(' + IndexFilterCode_L + '),';
                    end;
                end;

                //### Index 2:
                if PlanLevel_LT.Get(PlanDocLevel_LT."Index Code 2") then begin
                    FieldRef_L := RecRef_L.Field(PlanLevel_LT."Planning Statistic Field");
                    if RefCube_LT."Index 2" <> '' then begin
                        IndexFilterCode_L := RefCube_LT."Index 2";
                        Filtertext_L := Filtertext_L + FieldRef_L.Caption() + '=FILTER(' + IndexFilterCode_L + '),';
                    end;
                end;

                //### Index 3:
                if PlanLevel_LT.Get(PlanDocLevel_LT."Index Code 3") then begin
                    FieldRef_L := RecRef_L.Field(PlanLevel_LT."Planning Statistic Field");
                    if RefCube_LT."Index 3" <> '' then begin
                        IndexFilterCode_L := RefCube_LT."Index 3";
                        Filtertext_L := Filtertext_L + FieldRef_L.Caption() + '=FILTER(' + IndexFilterCode_L + '),';
                    end;
                end;

                //### Index 4:
                if PlanLevel_LT.Get(PlanDocLevel_LT."Index Code 4") then begin
                    FieldRef_L := RecRef_L.Field(PlanLevel_LT."Planning Statistic Field");
                    if RefCube_LT."Index 4" <> '' then begin
                        IndexFilterCode_L := RefCube_LT."Index 4";
                        Filtertext_L := Filtertext_L + FieldRef_L.Caption() + '=FILTER(' + IndexFilterCode_L + '),';
                    end;
                end;

                //### Index 5:
                if PlanLevel_LT.Get(PlanDocLevel_LT."Index Code 5") then begin
                    FieldRef_L := RecRef_L.Field(PlanLevel_LT."Planning Statistic Field");
                    if RefCube_LT."Index 5" <> '' then begin
                        IndexFilterCode_L := RefCube_LT."Index 5";
                        Filtertext_L := Filtertext_L + FieldRef_L.Caption() + '=FILTER(' + IndexFilterCode_L + '),';
                    end;
                end;

                //### Index 6:
                if PlanLevel_LT.Get(PlanDocLevel_LT."Index Code 6") then begin
                    FieldRef_L := RecRef_L.Field(PlanLevel_LT."Planning Statistic Field");
                    if RefCube_LT."Index 6" <> '' then begin
                        IndexFilterCode_L := RefCube_LT."Index 6";
                        Filtertext_L := Filtertext_L + FieldRef_L.Caption() + '=FILTER(' + IndexFilterCode_L + '),';
                    end;
                end;



                /*
                    //### Saison
                    FieldRef_L := RecRef_L.Field(11);
                    if PlanDoc_RT."Document Type" = PlanDoc_RT."Document Type"::Planungsbeleg then
                      Filtertext_L := Filtertext_L + FieldRef_L.Caption() + '=FILTER(' + PlanDoc_RT."Comparing Season" + '),'
                    else
                      Filtertext_L := Filtertext_L + FieldRef_L.Caption() + '=FILTER(' + PlanDoc_RT."Planning Season" + '),';
                */


                //###############################
                //### Anfangsbestand Vorjahr: ###
                //###############################
                Date_LT.Reset();
                Date_LT.SetRange("Period Type", PlanDoc_RT."Date Unit");
                if RefCube_LT.Date <> 0D then     //### Datumsebene aktiv
                    Date_LT.SetFilter("Period Start", '<%1', RefCube_LT.Date)     // EB d. vorherigen Periode
                else                          //### ohne Monate: EB Vorperiode verwenden
                    Date_LT.SetFilter("Period Start", '<%1', PlanDoc_RT."Start Date Ref. Period");

                if Date_LT.FindLast() then begin
                    FieldRef_L := RecRef_L.Field(2);    //### Datumsfilter
                    Filtertext_L := Filtertext_L + FieldRef_L.Caption() +
                                 '=FILTER(' + Format(Date_LT."Period Start") + '..' + Format(NormalDate(Date_LT."Period End")) + ')';
                end;
                Filtertext_L := DelChr(Filtertext_L, '>', ',');

                RecRef_L.SetView('WHERE(' + Filtertext_L + ')');

                //### Anfangsbestände berechnen
                FieldRef_L := RecRef_L.Field(PlanStat_LT.FieldNo("FSE Inventory Quantity"));        // Menge AB - I Quantity
                FieldRef_L.CalcField();
                RefCube_LT."Ref. Qty. Init. Inv." := FieldRef_L.Value();
                FieldRef_L := RecRef_L.Field(PlanStat_LT.FieldNo("FSE Inventory Value (Cost)"));      // EK AB - I Cost Amount
                FieldRef_L.CalcField();
                RefCube_LT."Ref. Cost Init. Inv." := FieldRef_L.Value();
                FieldRef_L := RecRef_L.Field(PlanStat_LT.FieldNo("FSE Inventory Value"));        // VK AB - I Inventory Value Sales
                FieldRef_L.CalcField();
                RefCube_LT."Ref. Sales Init. Inv." := FieldRef_L.Value();

                //### Datumsfilter wieder entfernen:
                FieldRef_L := RecRef_L.Field(2);
                pos_L := StrPos(Filtertext_L, FieldRef_L.Caption());
                if pos_L > 0 then
                    Filtertext_L := CopyStr(PadStr(Filtertext_L, pos_L - 1), 1, MaxStrLen(Filtertext_L));

                //###########################
                //### Endbestand Vorjahr: ###
                //###########################
                Date_LT.Reset();
                Date_LT.SetRange("Period Type", PlanDoc_RT."Date Unit");
                if RefCube_LT.Date <> 0D then     //### Datumsebene aktiv
                    Date_LT.SetRange("Period Start", RefCube_LT.Date)     // EB d. vorherigen Periode
                else                          //### ohne Monate: EB Vorperiode verwenden
                    Date_LT.SetRange("Period Start", CalcDate('<-CM>', PlanDoc_RT."End Date Ref. Period"));

                if Date_LT.FindLast() then begin
                    FieldRef_L := RecRef_L.Field(2);    //### Datumsfilter
                    Filtertext_L := Filtertext_L + FieldRef_L.Caption() +
                                  '=FILTER(' + Format(Date_LT."Period Start") + '..' + Format(NormalDate(Date_LT."Period End")) + ')';
                end;
                Filtertext_L := DelChr(Filtertext_L, '>', ',');
                RecRef_L.SetView('WHERE(' + Filtertext_L + ')');

                //### Endbestände berechnen
                FieldRef_L := RecRef_L.Field(PlanStat_LT.FieldNo("FSE Inventory Quantity"));
                FieldRef_L.CalcField();
                RefCube_LT."Ref. Qty. Closing Inv." := FieldRef_L.Value();
                FieldRef_L := RecRef_L.Field(PlanStat_LT.FieldNo("FSE Inventory Value (Cost)"));
                FieldRef_L.CalcField();
                RefCube_LT."Ref. Cost Closing Inv." := FieldRef_L.Value();
                FieldRef_L := RecRef_L.Field(PlanStat_LT.FieldNo("FSE Inventory Value"));
                FieldRef_L.CalcField();
                RefCube_LT."Ref. Sales Closing Inv." := FieldRef_L.Value();

                //### jetzt andere Werte berechnen
                FieldRef_L := RecRef_L.Field(2);
                pos_L := StrPos(Filtertext_L, FieldRef_L.Caption());
                if pos_L > 0 then
                    Filtertext_L := CopyStr(PadStr(Filtertext_L, pos_L - 1), 1, MaxStrLen(Filtertext_L));

                //### Datumsebene aktiv?
                Date_LT.Reset();
                Date_LT.SetRange("Period Type", PlanDoc_RT."Date Unit");
                Date_LT.SetRange("Period Start", RefCube_LT.Date);
                if Date_LT.FindFirst() then begin
                    FieldRef_L := RecRef_L.Field(2);
                    //### wenn noch keine Vorjahreswerte existieren, dann VVJ-Werte nehmen

                    GetPeriodWithValues(Date_LT, PlanDoc_RT);

                    Filtertext_L := Filtertext_L + FieldRef_L.Caption() +
                                  '=FILTER(' + Format(Date_LT."Period Start") + '..' + Format(NormalDate(Date_LT."Period End")) + ')';

                    FiltertextTemp_L := DelChr(Filtertext_L, '>', ',');
                    RecRef_L.SetView('WHERE(' + FiltertextTemp_L + ')');
                end
                else begin
                    PlanDocDateRef_LT.Reset();
                    PlanDocDateRef_LT.SetRange("Planning Document No.", PlanDoc_RT."No.");
                    PlanDocDateRef_LT.FindFirst();
                    FieldRef_L := RecRef_L.Field(2);
                    Filtertext_L := Filtertext_L + FieldRef_L.Caption() + '=FILTER(' + Format(PlanDocDateRef_LT."Reference Date") + '..';
                    PlanDocDateRef_LT.FindLast();
                    Date_LT.Reset();
                    Date_LT.SetRange("Period Type", PlanDoc_RT."Date Unit");
                    Date_LT.SetRange("Period Start", PlanDocDateRef_LT."Reference Date");
                    Date_LT.FindFirst();
                    Filtertext_L := CopyStr(Filtertext_L + Format(NormalDate(Date_LT."Period End")) + ')', 1, MaxStrLen(Filtertext_L));
                end;

                Filtertext_L := DelChr(Filtertext_L, '>', ',');
                RecRef_L.SetView('WHERE(' + Filtertext_L + ')');

                FieldRef_L := RecRef_L.Field(PlanStat_LT.FieldNo("FSE Sale Quantity"));       // Menge Umsatz - S Quantity
                FieldRef_L.CalcField();
                RefCube_LT."Ref. Qty. Sale" := FieldRef_L.Value();

                FieldRef_L := RecRef_L.Field(PlanStat_LT.FieldNo("FSE Sale Value (Cost)"));     // EK Umsatz - S Cost Amount
                FieldRef_L.CalcField();
                RefCube_LT."Ref. Cost of Sales" := FieldRef_L.Value();

                FieldRef_L := RecRef_L.Field(PlanStat_LT.FieldNo("FSE Sale Value"));          // VK Umsatz - S Realized Gross Sales Amount
                FieldRef_L.CalcField();
                RefCube_LT."Ref. Sales Amount" := FieldRef_L.Value();

                FieldRef_L := RecRef_L.Field(PlanStat_LT.FieldNo("FSE Sale Value Net"));          // VK Umsatz - S Real. Net Sales Amount
                FieldRef_L.CalcField();
                RefCube_LT."Ref. Sales Amount Net" := FieldRef_L.Value();

                FieldRef_L := RecRef_L.Field(PlanStat_LT.FieldNo("FSE Purchase Quantity"));     // Menge WE - P Quantity
                FieldRef_L.CalcField();
                RefCube_LT."Ref. Qty. Purchase" := FieldRef_L.Value();

                FieldRef_L := RecRef_L.Field(PlanStat_LT.FieldNo("FSE Purchase Value (Cost)"));     // EK WE - P Cost Amount
                FieldRef_L.CalcField();
                RefCube_LT."Ref. Cost Val. Purchase" := FieldRef_L.Value();

                FieldRef_L := RecRef_L.Field(PlanStat_LT.FieldNo("FSE Purchase Value"));       // VK WE - P Inventory Value Sales
                FieldRef_L.CalcField();
                RefCube_LT."Ref. Sales Am. Purchase" := FieldRef_L.Value();

                /*
                //### Zugänge mit zu WE rechnen:
                    FieldRef_L := RecRef_L.Field(PlanStat_LT.FieldNo("FSE Adjmt. Quantity"));     // Menge WE - A Quantity
                    FieldRef_L.CALCFIELD;
                    if not Evaluate(DecVar_L, Format(FieldRef_L.Value())) then
                      DecVar_L := 0;
                    RefCube_LT."Vgl. Menge WE (Limit)" -= DecVar_L;

                    FieldRef_L := RecRef_L.Field(PlanStat_LT.FieldNo("FSE Adjmt. Value (Cost)"));     // EK WE - A Cost Amount
                    FieldRef_L.CALCFIELD;
                    if not Evaluate(DecVar_L, Format(FieldRef_L.Value())) then
                      DecVar_L := 0;
                    RefCube_LT."Vgl. EK WE (Limit)" -= DecVar_L;

                    FieldRef_L := RecRef_L.Field(PlanStat_LT.FieldNo("FSE Adjmt. Value"));       // VK WE - A Inventory Value Sales
                    FieldRef_L.CALCFIELD;
                    if not Evaluate(DecVar_L, Format(FieldRef_L.Value())) then
                      DecVar_L := 0;
                    RefCube_LT."Vgl. VK WE (Limit)" -= DecVar_L;
                //###
                */


                FieldRef_L := RecRef_L.Field(PlanStat_LT.FieldNo("FSE G.S.P. Reduction"));       //### VK Abschrift
                FieldRef_L.CalcField();
                RefCube_LT."Ref. Gross Sales Pr. Reduction" := FieldRef_L.Value();

                //### Rabatte und Preisänderungen zusammenfassen:
                FieldRef_L := RecRef_L.Field(PlanStat_LT.FieldNo("FSE Gross Discount"));  //### VK Rabattbeträge
                FieldRef_L.CalcField();
                RefCube_LT."Ref. Sal. Am. Discount" := FieldRef_L.Value();

                FieldRef_L := RecRef_L.Field(PlanStat_LT.FieldNo("FSE Change in GS-Prices"));  //### VK Preisänderungen (PÄ)
                FieldRef_L.CalcField();
                if not Evaluate(DecVar_L, Format(FieldRef_L.Value())) then
                    DecVar_L := 0;
                RefCube_LT."Ref. Sal. Am. Discount" := RefCube_LT."Ref. Sal. Am. Discount" + DecVar_L;

                //### neg. VJ-Werte unterbinden
                if RefCube_LT."Ref. Sales Amount" < 0 then
                    RefCube_LT."Ref. Sales Amount" := 0;
                if RefCube_LT."Ref. Sal. Am. Discount" < 0 then
                    RefCube_LT."Ref. Sal. Am. Discount" := 0;
                if RefCube_LT."Ref. Gross Sales Pr. Reduction" < 0 then
                    RefCube_LT."Ref. Gross Sales Pr. Reduction" := 0;
                if RefCube_LT."Ref. Sales Init. Inv." < 0 then
                    RefCube_LT."Ref. Sales Init. Inv." := 0;
                if RefCube_LT."Ref. Sales Am. Purchase" < 0 then
                    RefCube_LT."Ref. Sales Am. Purchase" := 0;

                if RefCube_LT."Ref. Qty. Sale" < 0 then
                    RefCube_LT."Ref. Qty. Sale" := 0;
                if RefCube_LT."Ref. Qty. Init. Inv." < 0 then
                    RefCube_LT."Ref. Qty. Init. Inv." := 0;
                if RefCube_LT."Ref. Qty. Purchase" < 0 then
                    RefCube_LT."Ref. Qty. Purchase" := 0;

                if RefCube_LT."Ref. Cost of Sales" < 0 then
                    RefCube_LT."Ref. Cost of Sales" := 0;
                if RefCube_LT."Ref. Cost Init. Inv." < 0 then
                    RefCube_LT."Ref. Cost Init. Inv." := 0;
                if RefCube_LT."Ref. Cost Val. Purchase" < 0 then
                    RefCube_LT."Ref. Cost Val. Purchase" := 0;

                RefCube_LT."Time-Stamp" := datetime_L;
                RefCube_LT.Modify();
            until RefCube_LT.Next() = 0;

            CalcInitialTopDown_L := (PlanDoc_RT."Timestamp Reference Values" = 0DT);

            //### noch Zeitstempel im Beleg ändern:
            PlanDoc_RT.Get(RefCube_LT."Planning Document No.");
            PlanDoc_RT."Timestamp Reference Values" := datetime_L;
            PlanDoc_RT.Modify();

            Window_L.Close();
        end;

        //### jetzt noch die Vgl.-Werte in die View-Tabelle übernehmen
        UpdateRefViewData(PlanDoc_RT);
        if CalcInitialTopDown_L then
            CalcTopDown_LC.CalcInitialTopDown(PlanDoc_RT);

    end;

    /// <summary>
    /// GetPeriodWithValues.
    /// </summary>
    /// <param name="Date_RT">VAR Record Date.</param>
    /// <param name="PlanDoc_PT">Record "BET FN Planning Document".</param>
    procedure GetPeriodWithValues(var Date_RT: Record Date; PlanDoc_PT: Record "BET FN Planning Document")
    var
        Date_LT: Record Date;
        RefDate_L: Date;
        Day_L: Integer;
        Month_L: Integer;
        PlanYear_L: Integer;
        PrevYear_L: Integer;
    begin
        //### bei fehlenden Vorjahreswerten: Vorvorjahr nehmen
        //if CALCDATE('<-CM>', WORKDATE) <= Date_RT."Period Start" then begin
        //  if Date_LT.Get(Date_RT."Period Type", CALCDATE('<-1Y -CM>', Date_RT."Period Start")) then
        //    Date_RT := Date_LT;
        //end;
        Date_LT.Reset();
        Date_LT.SetRange("Period Type", Date_RT."Period Type");
        Date_LT.SetRange("Period No.", Date_RT."Period No.");

        //### Vorjahresdatum berechnen:
        Day_L := Date2DMY(Date_RT."Period Start", 1);
        Month_L := Date2DMY(Date_RT."Period Start", 2);

        //### Monat in Vorjahr und Planjahr festlegen:
        Evaluate(PlanYear_L, PlanDoc_PT."Financial Year");
        PrevYear_L := PlanYear_L - 1;
        RefDate_L := DMY2Date(Day_L, Month_L, PrevYear_L);


        //### wenn innerhalb des Planungszeitraums UND betrachteter Monat schon vorbei, dann VJ verwenden
        if (WorkDate() >= PlanDoc_PT."Start Date") then
            Date_LT.SetRange("Period Start", RefDate_L)
        else
            //### wenn Planperiode noch nicht begonnen hat, dann immer den letzten abgelaufenen Monat:
            Date_LT.SetFilter("Period Start", '<%1', CalcDate('<-CM>', WorkDate()));

        Date_LT.FindLast();

        Date_RT := Date_LT;
    end;

    /// <summary>
    /// UpdateRefViewData.
    /// </summary>
    /// <param name="PlanDoc_PT">Record "BET FN Planning Document".</param>
    procedure UpdateRefViewData(PlanDoc_PT: Record "BET FN Planning Document")
    var
        PlanView_LT: Record "BET FN Planning View";
        TotalSalesAmount_L: Decimal;
        Window_L: Dialog;
        i_L: Integer;
        total_L: Integer;
        UpdatePlanningLevelsLbl: Label 'Update planning levels\@1@@@@@@@@@@@@@@@@@@@@@@@@';
    begin
        //### Aktualisierung der Viewzeilen bei Neuberechnung der VJ-Werte
        PlanView_LT.Reset();
        PlanView_LT.SetCurrentKey("Planning Document No.", "Planning Document Level", "Index 1", "Index 2", "Index 3", "Index 4", "Index 5", "Index 6", Date);
        PlanView_LT.SetRange("Planning Document No.", PlanDoc_PT."No.");
        Window_L.Open(UpdatePlanningLevelsLbl);
        total_L := PlanView_LT.Count();
        i_L := 0;

        if PlanView_LT.FindSet() then
            repeat
                i_L += 1;
                Window_L.Update(1, Round(i_L / total_L * 9999, 1));
                //CalcRefViewData(PlanView_LT);
                TotalSalesAmount_L := CalcTotalRefSalesAmount(PlanView_LT);
                CalcRefViewData(PlanView_LT, TotalSalesAmount_L);

            until PlanView_LT.Next() = 0;
    end;

    /// <summary>
    /// CalcRefViewData.
    /// </summary>
    /// <param name="PlanView_PT">Record "BET FN Planning View".</param>
    /// <param name="TotalSalesAmount_P">Decimal.</param>
    procedure CalcRefViewData(PlanView_PT: Record "BET FN Planning View"; TotalSalesAmount_P: Decimal)
    var
        PlanDoc_LT: Record "BET FN Planning Document";
        PlanDocDateRef_LT: Record "BET FN Planning Document D Ref";
        PlanDocLevel_LT: Record "BET FN Planning Document Level";
        PlanSetup_LT: Record "BET FN Planning Setup";
        PlanStat_LT: Record "BET FN Planning Statistic";
        PlanView2_LT: Record "BET FN Planning View";
        CalcPlanValues_LC: Codeunit "BET FN Calculate Planning Vals";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeCalcRefViewData(PlanView_PT, TotalSalesAmount_P, IsHandled);
        if IsHandled then
            exit;

        if not PlanStat_LT.Get() then begin
            PlanStat_LT.Init();
            PlanStat_LT.Insert();
        end;

        PlanDoc_LT.Get(PlanView_PT."Planning Document No.");

        PlanStat_LT.Reset();
        PlanStat_LT.SetRange("Planning Document No.", PlanView_PT."Planning Document No.");

        //### Filter nur setzen, wenn auch Ebene vorhanden!
        PlanDocLevel_LT.Reset();
        PlanDocLevel_LT.SetCurrentKey("Planning Document No.", "Planning Document Level Index");
        PlanDocLevel_LT.SetRange("Planning Document No.", PlanView_PT."Planning Document No.");
        if PlanDocLevel_LT.FindLast() then begin

            if PlanDocLevel_LT."Planning Document Level Index" > 0 then
                if PlanView_PT."Index 1" <> '' then
                    PlanStat_LT.SetRange("Index 1", PlanView_PT."Index 1")
                else
                    PlanStat_LT.SetRange("Index 1");
            if PlanDocLevel_LT."Planning Document Level Index" > 1 then
                if PlanView_PT."Index 2" <> '' then
                    PlanStat_LT.SetRange("Index 2", PlanView_PT."Index 2")
                else
                    PlanStat_LT.SetRange("Index 2");
            if PlanDocLevel_LT."Planning Document Level Index" > 2 then
                if PlanView_PT."Index 3" <> '' then
                    PlanStat_LT.SetRange("Index 3", PlanView_PT."Index 3")
                else
                    PlanStat_LT.SetRange("Index 3");
            if PlanDocLevel_LT."Planning Document Level Index" > 3 then
                if PlanView_PT."Index 4" <> '' then
                    PlanStat_LT.SetRange("Index 4", PlanView_PT."Index 4")
                else
                    PlanStat_LT.SetRange("Index 4");
            if PlanDocLevel_LT."Planning Document Level Index" > 4 then
                if PlanView_PT."Index 5" <> '' then
                    PlanStat_LT.SetRange("Index 5", PlanView_PT."Index 5")
                else
                    PlanStat_LT.SetRange("Index 5");
            if PlanDocLevel_LT."Planning Document Level Index" > 5 then
                if PlanView_PT."Index 6" <> '' then
                    PlanStat_LT.SetRange("Index 6", PlanView_PT."Index 6")
                else
                    PlanStat_LT.SetRange("Index 6");
        end;

        PlanDocLevel_LT.Reset();
        PlanDocLevel_LT.SetRange("Planning Document No.", PlanView_PT."Planning Document No.");
        PlanDocLevel_LT.SetRange("Planning Document Level Index", PlanView_PT."Planning Document Level");
        PlanDocLevel_LT.FindFirst();

        if (PlanDocDateRef_LT.Get(PlanView_PT."Planning Document No.", PlanView_PT.Date)) and
           (PlanDocDateRef_LT."Reference Date" <> 0D) then
            PlanStat_LT.SetRange(DateFilter, PlanDocDateRef_LT."Reference Date")
        else
            if PlanDocLevel_LT."Activate Date Level" then
                PlanStat_LT.SetFilter(DateFilter, '<>%1', 0D)
            else
                PlanStat_LT.SetRange(DateFilter);

        PlanView2_LT.Get(PlanView_PT."View Entry No.");
        PlanStat_LT.CalcFields("Vgl. VK Umsatz"
                              , "Vgl. VK Rabatt"
                              , "Vgl. VK Anfangsbestand"
                              , "Vgl. VK Abschrift"
                              , "Vgl. VK WE (Limit)"
                              , "Vgl. Menge Umsatz"
                              , "Vgl. Menge Anfangsbestand"
                              , "Vgl. Menge WE (Limit)"
                              , "Vgl. EK Umsatz"
                              , "Vgl. EK Anfangsbestand"
                              , "Vgl. EK WE (Limit)"
                              );

        PlanView2_LT."Ref. Sales Amount" := PlanStat_LT."Vgl. VK Umsatz";
        PlanView2_LT."Ref. Sales Discount" := PlanStat_LT."Vgl. VK Rabatt";
        PlanView2_LT."Ref. Sal. Am. incl. Discount" := PlanView2_LT."Ref. Sales Amount" + PlanView2_LT."Ref. Sales Discount";
        PlanView2_LT."Ref. Sales Init. Inv." := PlanStat_LT."Vgl. VK Anfangsbestand";
        PlanView2_LT."Ref. Gross Sales Pr. Reduction" := PlanStat_LT."Vgl. VK Abschrift";
        PlanView2_LT."Ref. Sales Am. Purchase" := PlanStat_LT."Vgl. VK WE (Limit)";

        PlanView2_LT."Ref. Qty. Sale" := PlanStat_LT."Vgl. Menge Umsatz";
        PlanView2_LT."Ref. Qty. Init. Inv." := PlanStat_LT."Vgl. Menge Anfangsbestand";
        PlanView2_LT."Ref. Qty. Purchase" := PlanStat_LT."Vgl. Menge WE (Limit)";

        PlanView2_LT."Ref. Cost of Sales" := PlanStat_LT."Vgl. EK Umsatz";
        PlanView2_LT."Ref. Cost Init. Inv." := PlanStat_LT."Vgl. EK Anfangsbestand";
        PlanView2_LT."Ref. Cost Am. Purchase" := PlanStat_LT."Vgl. EK WE (Limit)";
        if TotalSalesAmount_P <> 0 then
            PlanView2_LT."Ref. Sales Percentage" := PlanView2_LT."Ref. Sales Amount" / TotalSalesAmount_P * 100
        else
            PlanView2_LT."Ref. Sales Percentage" := 0;

        //### 090615
        if PlanView2_LT.Date <> 0D then
            PlanStat_LT.SetRange(DateFilter, PlanDocDateRef_LT."Reference Date")
        else              //### Zeile ohne Datum: Bestand des letzten Monats verwenden
            PlanStat_LT.SetRange(DateFilter, CalcDate('<-CM>', PlanDoc_LT."End Date Ref. Period"));    //### letzter Monat

        //### Sonderfall: keine Datumsebene vorhanden:
        if not PlanDocLevel_LT."Activate Date Level" then
            PlanStat_LT.SetRange(DateFilter, 0D);


        PlanStat_LT.CalcFields("Vgl. VK Endbestand"
                              , "Vgl. EK Endbestand"
                              , "Vgl. Menge Endbestand"
                              );
        PlanView2_LT."Ref. Sales Closing Inv." := PlanStat_LT."Vgl. VK Endbestand";
        PlanView2_LT."Ref. Cost Closing Inv." := PlanStat_LT."Vgl. EK Endbestand";
        PlanView2_LT."Ref. Qty. Closing Inv." := PlanStat_LT."Vgl. Menge Endbestand";
        //### ...090615


        PlanDocLevel_LT.Reset();
        PlanDocLevel_LT.SetRange("Planning Document No.", PlanView_PT."Planning Document No.");
        PlanDocLevel_LT.SetFilter("Planning Document Level Index", '>=%1', PlanView_PT."Planning Document Level");
        PlanDocLevel_LT.SetRange("Activate Date Level", true);
        //### Anfangsbestände für Nichtdatumsebenen berechnen, wenn Datum im Cube aktiviert ist
        if (PlanView_PT.Date = 0D) and (not PlanDocLevel_LT.IsEmpty()) then begin
            PlanDocDateRef_LT.Reset();
            PlanDocDateRef_LT.SetRange("Planning Document No.", PlanView_PT."Planning Document No.");
            PlanDocDateRef_LT.FindFirst();
            PlanStat_LT.SetRange(DateFilter, PlanDocDateRef_LT."Reference Date");
            PlanStat_LT.CalcFields("Vgl. VK Anfangsbestand",
                                   "Vgl. Menge Anfangsbestand",
                                   "Vgl. EK Anfangsbestand");
            PlanView2_LT."Ref. Sales Init. Inv." := PlanStat_LT."Vgl. VK Anfangsbestand";
            PlanView2_LT."Ref. Qty. Init. Inv." := PlanStat_LT."Vgl. Menge Anfangsbestand";
            PlanView2_LT."Ref. Cost Init. Inv." := PlanStat_LT."Vgl. EK Anfangsbestand";

        end;

        //### restliche Werte berechnen (Preise, Kalkulationen, etc.)
        CalcPlanValues_LC.EnterFromViewTable(PlanView2_LT, PlanView2_LT.FieldNo("Plan Sales Amount"), 0, PlanView2_LT);

        CalcRefValues(PlanView2_LT, PlanDoc_LT);

        //### Preise und Spannen vom Vorjahr übernehmen (nicht bei Kontrollbeleg!!)
        if PlanSetup_LT.IsEmpty() then
            GetRefPricesAndMargins(PlanView2_LT);

        OnAfterCalcRefViewData(PlanView_PT, TotalSalesAmount_P);

        PlanView2_LT.Modify();
    end;

    /// <summary>
    /// GetRefPricesAndMargins.
    /// </summary>
    /// <param name="PlanView_RT">VAR Record "BET FN Planning View".</param>
    procedure GetRefPricesAndMargins(var PlanView_RT: Record "BET FN Planning View")
    begin

        //### Preise nicht vom Vorjahr übernehmen, da sonst bei Menge = 0 und Wert = 0
        //### die Zahlen nicht stimmen

        if Round(PlanView_RT."Plan S.Price Sales", 0.01) = 0 then
            PlanView_RT."Plan S.Price Sales" := PlanView_RT."Ref. S.Price Sales";
        if Round(PlanView_RT."Plan S.Price incl. Discount", 0.01) = 0 then
            PlanView_RT."Plan S.Price incl. Discount" := PlanView_RT."Ref. S.Price incl. Discount";
        if Round(PlanView_RT."Plan S.Price Purchase", 0.01) = 0 then
            PlanView_RT."Plan S.Price Purchase" := PlanView_RT."Ref. S.Price Purchase";
        if Round(PlanView_RT."Plan S.Price Init. Inv.", 0.01) = 0 then
            PlanView_RT."Plan S.Price Init. Inv." := PlanView_RT."Ref. S.Price Init. Inv.";
        if Round(PlanView_RT."Plan S.Price Closing Inv.", 0.01) = 0 then
            PlanView_RT."Plan S.Price Closing Inv." := PlanView_RT."Ref. S.Price Closing Inv.";
        if Round(PlanView_RT."Plan P.Price Sales", 0.01) = 0 then
            PlanView_RT."Plan P.Price Sales" := PlanView_RT."Ref. P.Price Sales";
        if Round(PlanView_RT."Plan P.Price Purchase", 0.01) = 0 then
            PlanView_RT."Plan P.Price Purchase" := PlanView_RT."Ref. P.Price Purchase";
        if Round(PlanView_RT."Plan P.Price Init. Inv.", 0.01) = 0 then
            PlanView_RT."Plan P.Price Init. Inv." := PlanView_RT."Ref. P.Price Init. Inv.";
        if Round(PlanView_RT."Plan P.Price Closing Inv.", 0.01) = 0 then
            PlanView_RT."Plan P.Price Closing Inv." := PlanView_RT."Ref. P.Price Closing Inv.";


        //if Round("Plan Sp% Umsatz", 0.01) = 0 then
        PlanView_RT."Plan Calc. Sales %" := PlanView_RT."Ref. Calc. Sales %";
        //if Round("Plan Sp% Umsatz mit PÄ", 0.01) = 0 then
        PlanView_RT."Plan Calc. Sales incl. Disc. %" := PlanView_RT."Ref. Calc. Sales incl. Disc. %";
        //if Round("Plan Sp% WE (Limit)", 0.01) = 0 then
        PlanView_RT."Plan Calc. Purchase %" := PlanView_RT."Ref. Calc. Purchase %";
        //if Round("Plan Sp% Anfangsbestand", 0.01) = 0 then
        PlanView_RT."Plan Calc. Init. Inv. %" := PlanView_RT."Ref. Calc. Init. Inv. %";
        //if Round("Plan Sp% Endbestand", 0.01) = 0 then
        PlanView_RT."Plan Calc. Closing Inv. %" := PlanView_RT."Ref. Calc. Closing Inv. %";
    end;

    /// <summary>
    /// CalcOutstandingOrders.
    /// </summary>
    /// <param name="RefCube_RT">VAR Record "BET FN Reference Value Cube".</param>
    /// <param name="PlanDocLevel_PT">Record "BET FN Planning Document Level".</param>
    /// <param name="PlanDoc_PT">Record "BET FN Planning Document".</param>
    procedure CalcOutstandingOrders(var RefCube_RT: Record "BET FN Reference Value Cube"; PlanDocLevel_PT: Record "BET FN Planning Document Level"; PlanDoc_PT: Record "BET FN Planning Document")
    var
        PlanStat_LT: Record "BET FN Planning Statistic";
        Date_LT: Record Date;
        PL_Functions_LC: Codeunit "BET FN Planning Functions";
        RecRef_L: RecordRef;
        FieldRef_L: FieldRef;
        i_L: Integer;
        Filter_L: Text[10];
    begin
        PlanStat_LT.Reset();
        RecRef_L.GetTable(PlanDocLevel_PT);
        for i_L := 1 to PL_Functions_LC.GetMaxNoOfLevels() do begin
            case i_L of
                1:
                    Filter_L := CopyStr(RefCube_RT."Index 1", 1, MaxStrLen(Filter_L));
                2:
                    Filter_L := CopyStr(RefCube_RT."Index 2", 1, MaxStrLen(Filter_L));
                3:
                    Filter_L := CopyStr(RefCube_RT."Index 3", 1, MaxStrLen(Filter_L));
                4:
                    Filter_L := CopyStr(RefCube_RT."Index 4", 1, MaxStrLen(Filter_L));
                5:
                    Filter_L := CopyStr(RefCube_RT."Index 5", 1, MaxStrLen(Filter_L));
                6:
                    Filter_L := CopyStr(RefCube_RT."Index 6", 1, MaxStrLen(Filter_L));
            end;

            FieldRef_L := RecRef_L.Field(1002 + (i_L * 10));     //### Tabellennummern statt Code verwenden
            if Format(FieldRef_L.Value()) <> '0' then
                case Format(FieldRef_L.Value()) of
                    '9':
                        PlanStat_LT.SetRange(CountryFilter, Filter_L);   //Land
                    '13':
                        ;   //Verkäufer/Einkäufer
                    '14':
                        PlanStat_LT.SetRange(LocFilter, Filter_L);   //Filiale
                    '18':
                        PlanStat_LT.SetRange(CustomerFilter, Filter_L);   //Debitor/Kunde
                    '23':
                        PlanStat_LT.SetRange(VendorFilter, Filter_L);   //Kreditor/Lieferant
                    '27':
                        PlanStat_LT.SetRange(ItemFilter, Filter_L);   //Artikel
                    '5722':
                        PlanStat_LT.SetRange(ItemCatFilter, Filter_L);   //Warengruppe
                    '5079224':
                        PlanStat_LT.SetRange(DivisFilter, Filter_L);   //Abteilung
                    '5079226':
                        PlanStat_LT.SetRange(BrandFilter, Filter_L);   //Marke
                    '5079230':
                        PlanStat_LT.SetRange(SeasonFilter, Filter_L);  //Saison
                    '5079239':
                        PlanStat_LT.SetRange(AgentFilter, Filter_L);   //Vertreter
                    '5079241':
                        ;   //Preislage
                    '5079281':
                        PlanStat_LT.SetRange(MainWGFilter, Filter_L);   //Hauptwarengruppe
                end;
        end;

        //### nicht auf Planungssaison filtern:
        //PlanStat_LT.SetRange(SeasonFilter, PlanDoc_PT."Planning Season");

        //### Datum: wenn kein Datum angegeben, dann gesamten Planzeitraum betrachten, sonst nur Monat, etc.
        if RefCube_RT.Date = 0D then
            PlanStat_LT.SetRange(DateFilter, PlanDoc_PT."Start Date", PlanDoc_PT."End Date")
        else begin
            Date_LT.Reset();
            Date_LT.SetRange("Period Type", PlanDoc_PT."Date Unit");
            Date_LT.SetRange("Period Start", RefCube_RT.Date);
            if Date_LT.FindFirst() then
                //### für ersten Monat: alle bis dahin offenen Orders mit in den ersten Monat nehmen
                if RefCube_RT.Date = PlanDoc_PT."Start Date" then    //### erster Monat
                    PlanStat_LT.SetFilter(DateFilter, '<=%1', NormalDate(Date_LT."Period End"))
                else
                    PlanStat_LT.SetRange(DateFilter, RefCube_RT.Date, NormalDate(Date_LT."Period End"));
        end;

        PlanStat_LT.CalcFields("PSE Outstanding Amount", "PSE Outstanding Qty.", "PSE Outst. Gross Sal. Amt.");
        RefCube_RT."Purch. Order Outst. Amt. Net." := PlanStat_LT."PSE Outstanding Amount";
        RefCube_RT."Purch. Order Outst. Qty." := PlanStat_LT."PSE Outstanding Qty.";
        RefCube_RT."Purch. Order Outst. Amt." := PlanStat_LT."PSE Outst. Gross Sal. Amt.";
    end;

    /// <summary>
    /// GetStartInventory.
    /// </summary>
    /// <param name="PlanDoc_RT">VAR Record "BET FN Planning Document".</param>
    procedure GetStartInventory(var PlanDoc_RT: Record "BET FN Planning Document")
    var
        LevelBuffer_LT: Record "BET FN Planning Doc Lvl Buf";
        PlanDocLevel_LT: Record "BET FN Planning Document Level";
        PlanLevel_LT: Record "BET FN Planning Level";
        // DateRef_LT: Record "Planning Doc. Date Reference";
        PlanStat_LT: Record "BET FN Planning Statistic";
        PlanCube_LT: Record "BET FN Planning Value Cube";
        RecRef_L: RecordRef;
        FieldRef_L: FieldRef;
        IndexFilterCode_L: Code[20];
        datetime_L: DateTime;
        ActualInventory_L: Decimal;
        ActualInventoryCost_L: Decimal;
        ActualInventoryQuantity_L: Decimal;
        OpenOrders_L: Decimal;
        OpenOrdersCost_L: Decimal;
        OpenOrdersQuantity_L: Decimal;
        Sales_L: Decimal;
        SalesCost_L: Decimal;
        SalesQuantity_L: Decimal;
        Window_L: Dialog;
        i_L: Integer;
        total_L: Integer;
        CalculateInitialInventoryLbl: Label 'Calculate initial inventory: \@1@@@@@@@@@@@@@@@@@@@@@';
        Filtertext_L: Text[1024];
        FilterWithoutDate_L: Text[1024];
    begin
        //### 090612
        //### Hochrechnung der Anfangsbestände: akt. Bestand - Umsatz (Vorjahreszeitraum)

        // DateRef_LT.Reset();
        // DateRef_LT.SetRange("Planning Document No.", PlanDoc_RT."No.");
        // DateRef_LT.FindFirst();  // erster Monat - wird für RefCube benötigt siehe: [1]

        PlanCube_LT.Reset();
        PlanCube_LT.SetCurrentKey("Planning Document No.", Date, "Index 1", "Index 2", "Index 3", "Index 4", "Index 5", "Index 6");
        PlanCube_LT.SetRange("Planning Document No.", PlanDoc_RT."No.");

        /*
        //### Belege ohne Datumsebene mit berückstichtigen:
        PlanDocLevel_LT.reset;
        PlanDocLevel_LT.SetRange("Planning Document No.", PlanDoc_RT."No.");
        if PlanDocLevel_LT.findfirst and PlanDocLevel_LT."Activate Date Level" then begin
          PlanCube_LT.SetRange("First Month", true);
        end else begin
          PlanCube_LT.SetRange(Date, DateRef_LT.Date);   //### nur Anfangsmonate
        end;
        */
        PlanCube_LT.SetRange("First Month", true);


        Window_L.Open(CalculateInitialInventoryLbl);

        PlanStat_LT.Reset();
        if PlanCube_LT.FindSet(true) then begin
            RecRef_L.Open(Database::"BET FN Planning Statistic");
            i_L := 1;
            total_L := PlanCube_LT.Count();
            datetime_L := CreateDateTime(WorkDate(), Time());
            repeat
                PlanDocLevel_LT.Reset();
                PlanDocLevel_LT.SetRange("Planning Document No.", PlanDoc_RT."No.");

                if PlanCube_LT."Index 1" = '' then
                    PlanDocLevel_LT.SetFilter("Index Code 1", '=%1', '')
                else
                    PlanDocLevel_LT.SetFilter("Index Code 1", '<>%1', '');
                if PlanCube_LT."Index 2" = '' then
                    PlanDocLevel_LT.SetFilter("Index Code 2", '=%1', '')
                else
                    PlanDocLevel_LT.SetFilter("Index Code 2", '<>%1', '');
                if PlanCube_LT."Index 3" = '' then
                    PlanDocLevel_LT.SetFilter("Index Code 3", '=%1', '')
                else
                    PlanDocLevel_LT.SetFilter("Index Code 3", '<>%1', '');
                if PlanCube_LT."Index 4" = '' then
                    PlanDocLevel_LT.SetFilter("Index Code 4", '=%1', '')
                else
                    PlanDocLevel_LT.SetFilter("Index Code 4", '<>%1', '');
                if PlanCube_LT."Index 5" = '' then
                    PlanDocLevel_LT.SetFilter("Index Code 5", '=%1', '')
                else
                    PlanDocLevel_LT.SetFilter("Index Code 5", '<>%1', '');
                if PlanCube_LT."Index 6" = '' then
                    PlanDocLevel_LT.SetFilter("Index Code 6", '=%1', '')
                else
                    PlanDocLevel_LT.SetFilter("Index Code 6", '<>%1', '');

                if PlanCube_LT.Date = 0D then
                    PlanDocLevel_LT.SetFilter("Activate Date Level", '=%1', false)
                else
                    PlanDocLevel_LT.SetFilter("Activate Date Level", '=%1', true);

                if PlanDocLevel_LT.Find('-') then begin
                    Filtertext_L := '';

                    //### für neue Stammdaten (z.B. neue Filialen) nach Vergleichsdaten suchen
                    LevelBuffer_LT.Reset();
                    LevelBuffer_LT.SetRange("Planning Document No.", PlanDoc_RT."No.");

                    //### Index 1:
                    if PlanLevel_LT.Get(PlanDocLevel_LT."Index Code 1") then begin
                        FieldRef_L := RecRef_L.Field(PlanLevel_LT."Planning Statistic Field");
                        if PlanCube_LT."Index 1" <> '' then begin
                            IndexFilterCode_L := PlanCube_LT."Index 1";
                            Filtertext_L := Filtertext_L + FieldRef_L.Caption() + '=FILTER(' + IndexFilterCode_L + '),';
                        end;
                    end;

                    //### Index 2:
                    if PlanLevel_LT.Get(PlanDocLevel_LT."Index Code 2") then begin
                        FieldRef_L := RecRef_L.Field(PlanLevel_LT."Planning Statistic Field");
                        if PlanCube_LT."Index 2" <> '' then begin
                            IndexFilterCode_L := PlanCube_LT."Index 2";
                            Filtertext_L := Filtertext_L + FieldRef_L.Caption() + '=FILTER(' + IndexFilterCode_L + '),';
                        end;
                    end;

                    //### Index 3:
                    if PlanLevel_LT.Get(PlanDocLevel_LT."Index Code 3") then begin
                        FieldRef_L := RecRef_L.Field(PlanLevel_LT."Planning Statistic Field");
                        if PlanCube_LT."Index 3" <> '' then begin
                            IndexFilterCode_L := PlanCube_LT."Index 3";
                            Filtertext_L := Filtertext_L + FieldRef_L.Caption() + '=FILTER(' + IndexFilterCode_L + '),';
                        end;
                    end;

                    //### Index 4:
                    if PlanLevel_LT.Get(PlanDocLevel_LT."Index Code 4") then begin
                        FieldRef_L := RecRef_L.Field(PlanLevel_LT."Planning Statistic Field");
                        if PlanCube_LT."Index 4" <> '' then begin
                            IndexFilterCode_L := PlanCube_LT."Index 4";
                            Filtertext_L := Filtertext_L + FieldRef_L.Caption() + '=FILTER(' + IndexFilterCode_L + '),';
                        end;
                    end;

                    //### Index 5:
                    if PlanLevel_LT.Get(PlanDocLevel_LT."Index Code 5") then begin
                        FieldRef_L := RecRef_L.Field(PlanLevel_LT."Planning Statistic Field");
                        if PlanCube_LT."Index 5" <> '' then begin
                            IndexFilterCode_L := PlanCube_LT."Index 5";
                            Filtertext_L := Filtertext_L + FieldRef_L.Caption() + '=FFILTER(' + IndexFilterCode_L + '),';
                        end;
                    end;

                    //### Index 6:
                    if PlanLevel_LT.Get(PlanDocLevel_LT."Index Code 6") then begin
                        FieldRef_L := RecRef_L.Field(PlanLevel_LT."Planning Statistic Field");
                        if PlanCube_LT."Index 6" <> '' then begin
                            IndexFilterCode_L := PlanCube_LT."Index 6";
                            Filtertext_L := Filtertext_L + FieldRef_L.Caption() + '=FILTER(' + IndexFilterCode_L + '),';
                        end;
                    end;


                    //### wenn wir uns bereits in Planungperiode befinden, dann Bestand von Vortag des Startdatums:
                    if WorkDate() >= PlanDoc_RT."Start Date" then begin
                        FieldRef_L := RecRef_L.Field(2);
                        Filtertext_L := Filtertext_L + FieldRef_L.Caption() + '=FILTER(' + Format(CalcDate('<-1D>', PlanDoc_RT."Start Date")) + ')';
                        RecRef_L.SetView('WHERE(' + Filtertext_L + ')');

                        FieldRef_L := RecRef_L.Field(PlanStat_LT.FieldNo("FSE Inventory Value"));        // AB VK
                        FieldRef_L.CalcField();
                        PlanCube_LT."Plan Sales Init. Inv." := FieldRef_L.Value();

                        FieldRef_L := RecRef_L.Field(PlanStat_LT.FieldNo("FSE Inventory Value (Cost)"));  // AB EK
                        FieldRef_L.CalcField();
                        PlanCube_LT."Plan Cost Init. Inv." := FieldRef_L.Value();

                        FieldRef_L := RecRef_L.Field(PlanStat_LT.FieldNo("FSE Inventory Quantity"));    // AB Menge
                        FieldRef_L.CalcField();
                        PlanCube_LT."Plan Qty. Init. Inv." := FieldRef_L.Value();

                        //### wenn noch vor der Planungsperiode, dann Bestände hochrechnen:
                        //### aktueller Bestand + Summe Orderrückstände bis Start Planungsperiode - Umsätze bis Start Planungsperiode (-1 Jahr)
                    end else begin
                        Clear(ActualInventory_L);
                        Clear(ActualInventoryCost_L);
                        Clear(ActualInventoryQuantity_L);
                        Clear(OpenOrders_L);
                        Clear(OpenOrdersCost_L);
                        Clear(OpenOrdersQuantity_L);
                        Clear(Sales_L);
                        Clear(SalesCost_L);
                        Clear(SalesQuantity_L);

                        //### aktueller Bestand:
                        FieldRef_L := RecRef_L.Field(2);
                        FilterWithoutDate_L := Filtertext_L;
                        Filtertext_L := Filtertext_L + FieldRef_L.Caption() + '=FILTER(' + Format(WorkDate()) + ')';
                        RecRef_L.SetView('WHERE(' + Filtertext_L + ')');

                        FieldRef_L := RecRef_L.Field(PlanStat_LT.FieldNo("FSE Inventory Value"));         // AB VK
                        FieldRef_L.CalcField();
                        ActualInventory_L := FieldRef_L.Value();
                        FieldRef_L := RecRef_L.Field(PlanStat_LT.FieldNo("FSE Inventory Value (Cost)"));  // AB EK
                        FieldRef_L.CalcField();
                        ActualInventoryCost_L := FieldRef_L.Value();
                        FieldRef_L := RecRef_L.Field(PlanStat_LT.FieldNo("FSE Inventory Quantity"));      // AB Menge
                        FieldRef_L.CalcField();
                        ActualInventoryQuantity_L := FieldRef_L.Value();


                        //### akt. Datum bis 1 Tag vor Start Planungsperiode:
                        FieldRef_L := RecRef_L.Field(2);
                        Filtertext_L := FilterWithoutDate_L + FieldRef_L.Caption() + '=FILTER(' + Format(CalcDate('<-CM>', WorkDate())) + '..' +
                                      Format(CalcDate('<-1D>', PlanDoc_RT."Start Date")) + ')';
                        RecRef_L.SetView('WHERE(' + Filtertext_L + ')');

                        //### Orderstatistik:
                        FieldRef_L := RecRef_L.Field(PlanStat_LT.FieldNo("PSE Outst. Gross Sal. Amt."));
                        FieldRef_L.CalcField();
                        OpenOrders_L := FieldRef_L.Value();
                        FieldRef_L := RecRef_L.Field(PlanStat_LT.FieldNo("PSE Outstanding Qty."));
                        FieldRef_L.CalcField();
                        OpenOrdersQuantity_L := FieldRef_L.Value();
                        FieldRef_L := RecRef_L.Field(PlanStat_LT.FieldNo("PSE Outstanding Amount"));
                        FieldRef_L.CalcField();
                        OpenOrdersCost_L := FieldRef_L.Value();


                        //### noch VJ-Umsätze für kommende Monate bis zum Start der Planungsperiode berechnen:
                        //### einfach für den gleichen Zeitraum wie die Orders die Vorjahresmonate verwenden...
                        //PlanStat_LT.SetRange(DateFilter, CALCDATE('<-CM -1Y>', WORKDATE), CALCDATE('<-1Y -1D>', PlanDoc_RT."Start Date"));
                        FieldRef_L := RecRef_L.Field(2);
                        if PlanCube_LT.Date <> 0D then
                            //### Datumsebene wird verwendet
                            Filtertext_L := FilterWithoutDate_L + FieldRef_L.Caption() + '=FILTER(' + Format(CalcDate('<-CM -1Y>', WorkDate())) + '..' +
                                          Format(CalcDate('<-1Y -1D>', PlanDoc_RT."Start Date")) + ')'
                        else
                            //### Datumsebene wird nicht verwendet
                            Filtertext_L := FilterWithoutDate_L + FieldRef_L.Caption() + '=FILTER(' + Format(PlanDoc_RT."Start Date Ref. Period") + '..' +
                                          Format(PlanDoc_RT."End Date Ref. Period") + ')';
                        RecRef_L.SetView('WHERE(' + Filtertext_L + ')');

                        //### FSE:
                        FieldRef_L := RecRef_L.Field(PlanStat_LT.FieldNo("FSE Sale Value"));
                        FieldRef_L.CalcField();
                        Sales_L := FieldRef_L.Value();
                        FieldRef_L := RecRef_L.Field(PlanStat_LT.FieldNo("FSE Sale Value (Cost)"));
                        FieldRef_L.CalcField();
                        SalesCost_L := FieldRef_L.Value();
                        FieldRef_L := RecRef_L.Field(PlanStat_LT.FieldNo("FSE Sale Quantity"));
                        FieldRef_L.CalcField();
                        SalesQuantity_L := FieldRef_L.Value();


                        PlanCube_LT."Plan Sales Init. Inv." := ActualInventory_L + OpenOrders_L - Sales_L;
                        PlanCube_LT."Plan Cost Init. Inv." := ActualInventoryCost_L + OpenOrdersCost_L - SalesCost_L;
                        PlanCube_LT."Plan Qty. Init. Inv." := ActualInventoryQuantity_L + OpenOrdersQuantity_L - SalesQuantity_L;

                        //### Wenn Menge = 0, dann auch Werte auf 0 setzen!
                        if PlanCube_LT."Plan Qty. Init. Inv." = 0 then begin
                            PlanCube_LT."Plan Sales Init. Inv." := 0;
                            PlanCube_LT."Plan Cost Init. Inv." := 0;
                        end;

                    end;

                    //### neg. AB auf 0 setzen:
                    if PlanCube_LT."Plan Sales Init. Inv." < 0 then
                        PlanCube_LT."Plan Sales Init. Inv." := 0;
                    if PlanCube_LT."Plan Cost Init. Inv." < 0 then
                        PlanCube_LT."Plan Cost Init. Inv." := 0;
                    if PlanCube_LT."Plan Qty. Init. Inv." < 0 then
                        PlanCube_LT."Plan Qty. Init. Inv." := 0;
                end;

                PlanCube_LT."Time-Stamp" := datetime_L;
                PlanCube_LT.Modify();
                i_L += 1;
                Window_L.Update(1, Round(i_L / total_L * 9999, 1));
            until PlanCube_LT.Next() = 0;

            //### Zeitstempel im Beleg aktualisieren
            PlanDoc_RT."Timestamp Planning Values" := datetime_L;

            //### Zeitstempel der Ebene aktualisieren
            PlanDocLevel_LT.Reset();
            PlanDocLevel_LT.SetRange("Planning Document No.", PlanDoc_RT."No.");
            PlanDocLevel_LT.ModifyAll("Timestamp Planning Values", datetime_L);
        end;
        //### ...090612

    end;

    /// <summary>
    /// CalculateTotalView.
    /// </summary>
    /// <param name="PlanDoc_PT">Record "BET FN Planning Document".</param>
    /// <param name="PlanView_RTT">Temporary VAR Record "BET FN Planning View".</param>
    /// <param name="PlanView_PT">Record "BET FN Planning View".</param>
    /// <param name="IndexFilter1_P">Text.</param>
    /// <param name="IndexFilter2_P">Text.</param>
    /// <param name="IndexFilter3_P">Text.</param>
    /// <param name="IndexFilter4_P">Text.</param>
    /// <param name="IndexFilter5_P">Text.</param>
    /// <param name="IndexFilter6_P">Text.</param>
    /// <param name="DateFilter_P">Text.</param>
    /// <param name="DateFilterActivated_P">Boolean.</param>
    procedure CalculateTotalView(PlanDoc_PT: Record "BET FN Planning Document"; var PlanView_RTT: Record "BET FN Planning View" temporary; PlanView_PT: Record "BET FN Planning View"; IndexFilter1_P: Text; IndexFilter2_P: Text; IndexFilter3_P: Text; IndexFilter4_P: Text; IndexFilter5_P: Text; IndexFilter6_P: Text; DateFilter_P: Text; DateFilterActivated_P: Boolean)
    var
        PlanDocDateRef_LT: Record "BET FN Planning Document D Ref";
        PlanStat_LT: Record "BET FN Planning Statistic";
        PlanView_LT: Record "BET FN Planning View";
        LineNo_L: Integer;
        PlanValuesLbl: Label 'Plan values';
        RefValuesLbl: Label 'Ref. Values';
        SavedPlanValuesLbl: Label 'Plan values (saved)';
        DateFilter_L: Text;
        IsHandled: Boolean;
    begin
        OnBeforeCalculateTotalView(PlanDoc_PT, PlanView_RTT, PlanView_PT, IndexFilter1_P, IndexFilter2_P, IndexFilter3_P, IndexFilter4_P, IndexFilter5_P, IndexFilter6_P, DateFilter_P, DateFilterActivated_P, IsHandled);
        if IsHandled then
            exit;

        //### Berechnung der Summenzeilen in Tabellenansicht (SubPage)

        PlanView_RTT.Reset();
        PlanView_RTT.DeleteAll();

        //### für VJ-Werte noch den Datumsfilter ermitteln:
        if DateFilter_P <> '' then begin
            PlanDocDateRef_LT.Reset();
            PlanDocDateRef_LT.SetRange("Planning Document No.", PlanDoc_PT."No.");
            PlanDocDateRef_LT.SetFilter(Date, DateFilter_P);
            if PlanDocDateRef_LT.FindSet() then begin
                DateFilter_L := '';
                repeat
                    if DateFilter_L <> '' then
                        DateFilter_L += '|';
                    DateFilter_L += Format(PlanDocDateRef_LT."Reference Date");
                until PlanDocDateRef_LT.Next() = 0;
            end;
        end;

        LineNo_L := 0;

        //################################
        //### 1. Zeile: Vorjahreswerte ###
        //################################
        PlanView_RTT.Init();
        PlanView_RTT."Planning Document No." := PlanDoc_PT."No.";
        LineNo_L += 1;
        PlanView_RTT."View Entry No." := LineNo_L;
        PlanView_RTT."Description 1" := RefValuesLbl;
        PlanView_RTT.Insert();

        PlanStat_LT.Reset();
        PlanStat_LT.SetRange("Planning Document No.", PlanDoc_PT."No.");

        if DateFilterActivated_P and (DateFilter_P <> '') then
            PlanStat_LT.SetFilter(DateFilter, DateFilter_L)
        else
            PlanStat_LT.SetRange(DateFilter);

        PlanStat_LT.SetFilter("Index 1", IndexFilter1_P);
        PlanStat_LT.SetFilter("Index 2", IndexFilter2_P);
        PlanStat_LT.SetFilter("Index 3", IndexFilter3_P);
        PlanStat_LT.SetFilter("Index 4", IndexFilter4_P);
        PlanStat_LT.SetFilter("Index 5", IndexFilter5_P);
        PlanStat_LT.SetFilter("Index 6", IndexFilter6_P);

        PlanStat_LT.CalcFields("Vgl. VK Umsatz"
                              , "Vgl. VK Rabatt"
                              , "Vgl. VK Abschrift"
                              , "Vgl. VK WE (Limit)"
                              , "Vgl. EK Umsatz"
                              , "Vgl. EK WE (Limit)"
                              , "Vgl. Menge Umsatz"
                              , "Vgl. Menge WE (Limit)"
                              );

        PlanView_RTT."Plan Sales Amount" := PlanStat_LT."Vgl. VK Umsatz";
        PlanView_RTT."Plan Sales Discount" := PlanStat_LT."Vgl. VK Rabatt";
        PlanView_RTT."Plan Sal. Am. incl. Discount" := PlanStat_LT."Vgl. VK Umsatz" + PlanStat_LT."Vgl. VK Rabatt";
        PlanView_RTT."Plan Gross Sales Pr. Reduction" := PlanStat_LT."Vgl. VK Abschrift";
        PlanView_RTT."Plan Sales Am. Purchase" := PlanStat_LT."Vgl. VK WE (Limit)";

        PlanView_RTT."Plan Cost of Sales" := PlanStat_LT."Vgl. EK Umsatz";
        PlanView_RTT."Plan Cost Am. Purchase" := PlanStat_LT."Vgl. EK WE (Limit)";

        PlanView_RTT."Plan Qty. Sale" := PlanStat_LT."Vgl. Menge Umsatz";
        PlanView_RTT."Plan Qty. Purchase" := PlanStat_LT."Vgl. Menge WE (Limit)";
        if PlanStat_LT."Vgl. VK Umsatz" <> 0 then
            PlanView_RTT."Plan Sales Percentage" := 100
        else
            PlanView_RTT."Plan Sales Percentage" := 0;

        //### hier bei Bedarf noch die anderen Werte berechnen:
        //

        PlanView_RTT.Modify();


        //###########################
        //### 2. Zeile: Planwerte ###
        //###########################
        PlanView_RTT.Init();
        PlanView_RTT."Planning Document No." := PlanDoc_PT."No.";
        LineNo_L += 1;
        PlanView_RTT."View Entry No." := LineNo_L;
        PlanView_RTT."Description 1" := PlanValuesLbl;
        PlanView_RTT.Insert();

        PlanView_LT.Reset();
        PlanView_LT.SetRange("Planning Document No.", PlanView_PT."Planning Document No.");
        PlanView_LT.SetRange("Planning Document Level", PlanView_PT."Planning Document Level");
        PlanView_LT.SetFilter("Index 1", IndexFilter1_P);
        PlanView_LT.SetFilter("Index 2", IndexFilter2_P);
        PlanView_LT.SetFilter("Index 3", IndexFilter3_P);
        PlanView_LT.SetFilter("Index 4", IndexFilter4_P);
        PlanView_LT.SetFilter("Index 5", IndexFilter5_P);
        PlanView_LT.SetFilter("Index 6", IndexFilter6_P);
        if DateFilterActivated_P then begin
            if DateFilter_P <> '' then
                PlanView_LT.SetFilter(Date, DateFilter_P)
            else
                PlanView_LT.SetFilter(Date, '<>%1', 0D)
        end else
            PlanView_LT.SetRange(Date, 0D);


        PlanView_LT.SetCurrentKey("Planning Document No.", "Planning Document Level", "Index 1", "Index 2", "Index 3", "Index 4", "Index 5", "Index 6", Date);
        PlanView_LT.CalcSums("Plan Sales Amount"
                            , "Plan Sales Discount"
                            , "Plan Gross Sales Pr. Reduction"
                            , "Plan Sales Am. Purchase"
                            , "Plan Cost of Sales"
                            , "Plan Cost Am. Purchase"
                            , "Plan Qty. Sale"
                            , "Plan Qty. Purchase"
                            , "Plan Sales Percentage"
                            );

        PlanView_RTT."Plan Sales Amount" := PlanView_LT."Plan Sales Amount";
        PlanView_RTT."Plan Sales Discount" := PlanView_LT."Plan Sales Discount";
        PlanView_RTT."Plan Sal. Am. incl. Discount" := PlanView_LT."Plan Sales Amount" + PlanView_LT."Plan Sales Discount";
        PlanView_RTT."Plan Gross Sales Pr. Reduction" := PlanView_LT."Plan Gross Sales Pr. Reduction";
        PlanView_RTT."Plan Sales Am. Purchase" := PlanView_LT."Plan Sales Am. Purchase";

        PlanView_RTT."Plan Cost of Sales" := PlanView_LT."Plan Cost of Sales";
        PlanView_RTT."Plan Cost Am. Purchase" := PlanView_LT."Plan Cost Am. Purchase";

        PlanView_RTT."Plan Qty. Sale" := PlanView_LT."Plan Qty. Sale";
        PlanView_RTT."Plan Qty. Purchase" := PlanView_LT."Plan Qty. Purchase";

        PlanView_RTT."Plan Sales Percentage" := PlanView_LT."Plan Sales Percentage";

        //### hier bei Bedarf noch die anderen Werte berechnen:
        //

        PlanView_RTT.Modify();





        //#################################################
        //### 3. Zeile: Planwerte gespeichert (Vorgabe) ###
        //#################################################
        PlanView_RTT.Init();
        PlanView_RTT."Planning Document No." := PlanDoc_PT."No.";
        LineNo_L += 1;
        PlanView_RTT."View Entry No." := LineNo_L;
        PlanView_RTT."Description 1" := SavedPlanValuesLbl;
        PlanView_RTT.Insert();


        //### Filter sind noch gesetzt, nur Datumsfilter anpassen:
        if DateFilterActivated_P and (DateFilter_P <> '') then
            PlanStat_LT.SetFilter(DateFilter, DateFilter_P)
        else
            PlanStat_LT.SetRange(DateFilter);


        PlanStat_LT.CalcFields("Plan VK Umsatz"
                              , "Plan VK Rabatt"
                              , "Plan VK Abschrift"
                              , "Plan VK WE (Limit)"
                              , "Plan EK Umsatz"
                              , "Plan EK WE (Limit)"
                              , "Plan Menge Umsatz"
                              , "Plan Menge WE (Limit)"
                              );

        PlanView_RTT."Plan Sales Amount" := PlanStat_LT."Plan VK Umsatz";
        PlanView_RTT."Plan Sales Discount" := PlanStat_LT."Plan VK Rabatt";
        PlanView_RTT."Plan Sal. Am. incl. Discount" := PlanStat_LT."Plan VK Umsatz" + PlanStat_LT."Plan VK Rabatt";
        PlanView_RTT."Plan Gross Sales Pr. Reduction" := PlanStat_LT."Plan VK Abschrift";
        PlanView_RTT."Plan Sales Am. Purchase" := PlanStat_LT."Plan VK WE (Limit)";

        PlanView_RTT."Plan Cost of Sales" := PlanStat_LT."Plan EK Umsatz";
        PlanView_RTT."Plan Cost Am. Purchase" := PlanStat_LT."Plan EK WE (Limit)";

        PlanView_RTT."Plan Qty. Sale" := PlanStat_LT."Plan Menge Umsatz";
        PlanView_RTT."Plan Qty. Purchase" := PlanStat_LT."Plan Menge WE (Limit)";
        if PlanStat_LT."Plan VK Umsatz" <> 0 then
            PlanView_RTT."Plan Sales Percentage" := 100
        else
            PlanView_RTT."Plan Sales Percentage" := 0;

        //### hier bei Bedarf noch die anderen Werte berechnen:
        //

        OnBeforeModifyTotalView(PlanDoc_PT, PlanView_RTT, PlanView_PT, IndexFilter1_P, IndexFilter2_P, IndexFilter3_P, IndexFilter4_P, IndexFilter5_P, IndexFilter6_P, DateFilter_P, DateFilterActivated_P);

        PlanView_RTT.Modify();
    end;

    /// <summary>
    /// CalcTotalRefSalesAmount.
    /// </summary>
    /// <param name="PlanView_PT">Record "BET FN Planning View".</param>
    /// <returns>Return value of type Decimal.</returns>
    procedure CalcTotalRefSalesAmount(PlanView_PT: Record "BET FN Planning View"): Decimal
    var
        RefCube_LT: Record "BET FN Reference Value Cube";
        i_L: Integer;
    begin
        //### - Zeile mit Datum --> alle zugehörigen Cubezeilen )
        //### - Ziele ohne Datum --> alle zugehörigen Cubezeilen ohne Filter auf akt. Ebenenindex

        RefCube_LT.Reset();
        RefCube_LT.SetCurrentKey("Planning Document No.", "Index 1", "Index 2", "Index 3", "Index 4", "Index 5", "Index 6", Date);
        RefCube_LT.SetRange("Planning Document No.", PlanView_PT."Planning Document No.");

        i_L := 0;

        //### bei Datumsebene einen Ebenenindex zusätzlich filtern (Index der Viewzeile):
        if PlanView_PT.Date <> 0D then
            i_L := 1;

        if PlanView_PT."Planning Document Level" > (1 - i_L) then
            RefCube_LT.SetRange("Index 1", PlanView_PT."Index 1");
        if PlanView_PT."Planning Document Level" > (2 - i_L) then
            RefCube_LT.SetRange("Index 2", PlanView_PT."Index 2");
        if PlanView_PT."Planning Document Level" > (3 - i_L) then
            RefCube_LT.SetRange("Index 3", PlanView_PT."Index 3");
        if PlanView_PT."Planning Document Level" > (4 - i_L) then
            RefCube_LT.SetRange("Index 4", PlanView_PT."Index 4");
        if PlanView_PT."Planning Document Level" > (5 - i_L) then
            RefCube_LT.SetRange("Index 5", PlanView_PT."Index 5");

        RefCube_LT.CalcSums("Ref. Sales Amount");

        exit(RefCube_LT."Ref. Sales Amount");
    end;

    local procedure CalcRefValues(var BETFNPlanningView: Record "BET FN Planning View"; BETFNPlanningDocument: Record "BET FN Planning Document")
    begin
        // VJ WE-Spanne:
        case BETFNPlanningDocument."Calculation Type" of
            // WE-Spanne (Abschlag) aus VK und EK:
            BETFNPlanningDocument."Calculation Type"::Margin:
                if BETFNPlanningView."Ref. Sales Am. Purchase" <> 0 then
                    BETFNPlanningView."Ref. Calc. Purchase %" :=
                        (BETFNPlanningView."Ref. Sales Am. Purchase" - BETFNPlanningView."Ref. Cost Am. Purchase") / BETFNPlanningView."Ref. Sales Am. Purchase" * 100
                else
                    BETFNPlanningView."Ref. Calc. Purchase %" := 0;

            // WE-Kalkulation (Aufschlag) aus VK und EK:
            BETFNPlanningDocument."Calculation Type"::Calculation:
                if BETFNPlanningView."Ref. Cost Am. Purchase" <> 0 then
                    BETFNPlanningView."Ref. Calc. Purchase %" :=
                       (BETFNPlanningView."Ref. Sales Am. Purchase" - BETFNPlanningView."Ref. Cost Am. Purchase") / BETFNPlanningView."Ref. Cost Am. Purchase" * 100
                else
                    BETFNPlanningView."Ref. Calc. Purchase %" := 0;
        end;
    end;


    [IntegrationEvent(false, false)]
    local procedure OnBeforeCalcReferenceValueCube(BETFNPlanningDocument: Record "BET FN Planning Document"; var IsHandled: Boolean);
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCalculateTotalView(PlanDoc_PT: Record "BET FN Planning Document"; var PlanView_RTT: Record "BET FN Planning View" temporary; PlanView_PT: Record "BET FN Planning View"; IndexFilter1_P: Text; IndexFilter2_P: Text; IndexFilter3_P: Text; IndexFilter4_P: Text; IndexFilter5_P: Text; IndexFilter6_P: Text; DateFilter_P: Text; DateFilterActivated_P: Boolean; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeModifyTotalView(PlanDoc_PT: Record "BET FN Planning Document"; var PlanView_RTT: Record "BET FN Planning View" temporary; var PlanView_PT: Record "BET FN Planning View"; IndexFilter1_P: Text; IndexFilter2_P: Text; IndexFilter3_P: Text; IndexFilter4_P: Text; IndexFilter5_P: Text; IndexFilter6_P: Text; DateFilter_P: Text; DateFilterActivated_P: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCalcRefViewData(var PlanView_PT: Record "BET FN Planning View"; TotalSalesAmount_P: Decimal; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCalcRefViewData(var PlanView_PT: Record "BET FN Planning View"; TotalSalesAmount_P: Decimal)
    begin
    end;
}

