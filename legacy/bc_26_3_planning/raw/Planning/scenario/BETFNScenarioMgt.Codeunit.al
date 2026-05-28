/// <summary>
/// [scenario]
/// Modules: 
/// </summary>
codeunit 5138641 "BET FN Scenario Mgt"
{
    Access = Public;

    var
        CurrentMonth_G: Date;
        DateTime_G: DateTime;
        MonthPercentArray_G: array[12] of Decimal;
        Window2_G: Dialog;
        Window_G: Dialog;
        Counter_G: Integer;
        LinesComplete_G: Integer;
        LinesWithoutDate_G: Integer;
        NextDays_G: Integer;
        PastDays_G: Integer;

    procedure CreateFashionStatisticEntries(Scenario_P: Code[20])
    var
        FSE_LT: Record "BET FN Fashion Statistic Entry";
        Scenario_LT: Record "BET FN Scenario";
        ScenarioDimension_LT: Record "BET FN Scenario Dimension";
        ScenarioDimLine_LT: Record "BET FN Scenario Dimension Line";
        Date_LT: Record Date;
        ConfirmManagement: Codeunit "Confirm Management";
        DimWithZeroLine_L: Code[20];
        Fluctuation_L: Decimal;
        RandomFactor_L: Decimal;
        LfdNo_L: Integer;
        CreateStatisticsEntriesForScenarioQst: Label 'Create statistic entries for scenario %1?', Comment = '%1';
        CreatingInventoryForScenarioLbl: Label 'Creating inventory for scenario #1##########\@2@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@', Comment = '%1 %2';
        CreatingStatisticsEntriesForScenarioLbl: Label 'Creating statistic entries for scenario #1##########\@2@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@', Comment = '%1 %2';
        DeleteEntriesLbl: Label 'Deleting entries...';
        DeleteStatisticsEntriesQst: Label 'Delete all statistic entries for %1?', Comment = '%1: Represents the name of the scenario for which the statistic entries will be deleted.';
        DimensionHasActiveLinesWithPercentileQst: Label 'Dimension %1 has active lines with percentage = 0.\Continue anyway?', Comment = '%1';
        Time1_L: Time;
        Time2_L: Time;
    begin
        Time1_L := Time();

        if not ConfirmManagement.GetResponse(StrSubstNo(CreateStatisticsEntriesForScenarioQst, Scenario_P), false) then
            exit;

        //### optionales Löschen der bisherigen Statistik
        if ConfirmManagement.GetResponse(StrSubstNo(DeleteStatisticsEntriesQst, Scenario_P), false) then begin
            Window_G.Open(DeleteEntriesLbl);
            FSE_LT.Reset();
            FSE_LT.DeleteAll();
            Window_G.Close();
        end;

        Scenario_LT.Get(Scenario_P);
        DimWithZeroLine_L := CheckActiveDimLineZeroPercent(Scenario_P);
        if ScenarioDimension_LT.Get(Scenario_P, DimWithZeroLine_L) then
            if not ConfirmManagement.GetResponse(StrSubstNo(DimensionHasActiveLinesWithPercentileQst, DimWithZeroLine_L), false) then
                exit;


        //### Anzahl der zu erstellenden Zeilen ermitteln (für Fortschrittsbalken):
        ScenarioDimension_LT.Reset();
        ScenarioDimension_LT.SetRange("Scenario Code", Scenario_P);
        ScenarioDimension_LT.SetRange(Dateline, false);
        if ScenarioDimension_LT.FindSet() then begin
            LinesWithoutDate_G := 1;
            repeat
                ScenarioDimLine_LT.Reset();
                ScenarioDimLine_LT.SetRange("Scenario Code", Scenario_P);
                ScenarioDimLine_LT.SetRange("Dimension Code", ScenarioDimension_LT.Code);
                ScenarioDimLine_LT.SetRange(Active, true);
                LinesWithoutDate_G *= ScenarioDimLine_LT.Count();
            until ScenarioDimension_LT.Next() = 0;
        end;

        //### mit Datum:
        ScenarioDimension_LT.SetRange(Dateline, true);
        ScenarioDimension_LT.FindFirst();
        ScenarioDimLine_LT.Reset();
        ScenarioDimLine_LT.SetRange("Scenario Code", Scenario_P);
        ScenarioDimLine_LT.SetRange("Dimension Code", ScenarioDimension_LT.Code);
        if LinesWithoutDate_G <> 0 then
            LinesComplete_G := LinesWithoutDate_G * ScenarioDimLine_LT.Count()
        else
            LinesComplete_G := ScenarioDimLine_LT.Count();    //### Sonderfall: nur Datumsdimension


        //### 090624 : für aktuellen Monat: Monatswerte anteilig nach vergangenen Tagen
        CurrentMonth_G := CalcDate('<-CM>', WorkDate());
        Date_LT.Reset();
        Date_LT.SetRange("Period Type", Date_LT."Period Type"::Date);
        Date_LT.SetFilter("Period Start", '>=%1 & <=%2', CurrentMonth_G, CalcDate('<CM>', WorkDate()));
        PastDays_G := 0;
        NextDays_G := 0;
        //### ak. Monat durchlaufen und vergangene/Kommende Tage zählen
        if Date_LT.FindSet() then
            repeat
                if Date_LT."Period Start" < WorkDate() then
                    PastDays_G += 1
                else
                    NextDays_G += 1;
            until Date_LT.Next() = 0;
        //### ...090624


        ScenarioDimension_LT.Reset();
        ScenarioDimension_LT.SetRange("Scenario Code", Scenario_P);
        if ScenarioDimension_LT.Count() > 0 then begin
            //LfdNo := 0;
            FSE_LT.Reset();
            if FSE_LT.FindLast() then
                LfdNo_L := FSE_LT."Entry No."
            else
                LfdNo_L := 0;

            Fluctuation_L := 1;
            DateTime_G := 0DT;  //### Zeitstempel für Randomfunktion


            //#######################################
            //### zuerst Anfangsbestände anlegen: ###
            //#######################################

            Window_G.Open(CreatingInventoryForScenarioLbl, Scenario_P);

            FSE_LT.Init();
            //### Bestände immer auf Vormonat des ersten Monats:
            FSE_LT."Posting Date" := CalcDate('<-1M>', Scenario_LT."Start Date");

            ScenarioDimension_LT.SetRange(Dateline, false);   //### Datumsebene nicht verwenden
            if ScenarioDimension_LT.FindFirst() then begin
                Counter_G := 0;
                CreateFSEInventoryLines(LfdNo_L, FSE_LT, Scenario_P, ScenarioDimension_LT.Code, Fluctuation_L);
            end else begin
                //### es wurde (außer Datumsdimension) keine Dimension gefunden, also nur eine Bestandszeile anlegen:
                LfdNo_L += 1;
                FSE_LT."Entry No." := LfdNo_L;
                RandomFactor_L := GetRandomFluctuation(Scenario_LT);
                FSE_LT."I Inventory Value Sales" := Scenario_LT."Opening Stock" * RandomFactor_L;
                FSE_LT.Insert();
            end;
            Window_G.Close();

            //#####################################
            //### dann restliche Werte anlegen: ###
            //#####################################
            Window2_G.Open(CreatingStatisticsEntriesForScenarioLbl, Scenario_P);
            FSE_LT.Init();
            ScenarioDimension_LT.SetRange(Dateline);   //### alle Ebenen (mit Datum) verwenden
            ScenarioDimension_LT.FindFirst();
            Counter_G := 0;
            CreateFSELines(LfdNo_L, FSE_LT, Scenario_P, ScenarioDimension_LT.Code, Fluctuation_L);
            Window2_G.Close();
        end;

        //### 090701
        SetScenarioActive(Scenario_P);

        Time2_L := Time();

        Message('Zeit in ms: ' + Format(Time2_L - Time1_L));
    end;

#pragma warning disable AA0150
    procedure CreateFSELines(var LfdNo_R: Integer; var FSE_RT: Record "BET FN Fashion Statistic Entry"; Scenario_P: Code[20]; Dimension_P: Code[20]; var Fluctuation_P: Decimal)
#pragma warning restore AA0150

    var
        Scenario_LT: Record "BET FN Scenario";
        ScenarioDimension2_LT: Record "BET FN Scenario Dimension";
        ScenarioDimension_LT: Record "BET FN Scenario Dimension";
        ScenarioDimLine_LT: Record "BET FN Scenario Dimension Line";
        Item_LT: Record Item;
        InsertMode_L: Boolean;
        AvgPrice_L: Decimal;
        Calculation_L: Decimal;
        CalculationWR_L: Decimal;
        Factor_L: Decimal;
        Fluctuation_L: Decimal;
    begin
        Scenario_LT.Get(Scenario_P);
        ScenarioDimension_LT.Get(Scenario_P, Dimension_P);

        ScenarioDimLine_LT.Reset();
        ScenarioDimLine_LT.SetRange("Scenario Code", Scenario_P);
        ScenarioDimLine_LT.SetRange("Dimension Code", Dimension_P);
        ScenarioDimLine_LT.SetRange(Active, true);
        if ScenarioDimLine_LT.FindSet() then begin
            ScenarioDimension2_LT.Reset();
            ScenarioDimension2_LT.SetRange("Scenario Code", Scenario_P);
            ScenarioDimension2_LT.SetFilter(Code, '>%1', Dimension_P);
            InsertMode_L := not ScenarioDimension2_LT.FindFirst();    //### Posten einfügen, wenn keine weitere Dimension

            repeat
                //### Übernehmen der Dimensionswerte (Datum, Fil. HWG) in Statistikposten:
                if ScenarioDimension_LT."Table No." = 0 then                  //### DATUM
                    Evaluate(FSE_RT."Posting Date", ScenarioDimLine_LT.Code)
                else
                    SetFashStatEntryDimension(ScenarioDimension_LT, FSE_RT, ScenarioDimLine_LT.Code);

                //### Berechnung der Werte (incl. Abweichung):
                Fluctuation_L := Fluctuation_P * ScenarioDimLine_LT.Percentage / 100;     //### normaler Prozentwert ohne Abweichung


                if InsertMode_L then begin   //### keine weitere Dimension: Rekursionsabbruch und Einfügen der Statistikposten

                    //### 090624
                    if FSE_RT."Posting Date" = CurrentMonth_G then
                        Factor_L := PastDays_G / (PastDays_G + NextDays_G)      //### Anteil bis zum aktuellen Tag d. akt. Monats
                    else
                        Factor_L := 1;        //### sonst immer kompletten Wert
                    //### ...090624


                    LfdNo_R += 1;
                    FSE_RT."Entry No." := LfdNo_R;

                    //### erzielter Umsatz VK (Brutto):
                    // neg. !
                    FSE_RT."S Realized Gross Sales Amount" := Fluctuation_L *
                                                              -Scenario_LT."Real. Sal. Am. per Year" *
                                                              GetRandomFluctuation(Scenario_LT)
                                                              * Factor_L;

                    //### Abschrift:
                    // neg. !
                    FSE_RT."S Realized GSP Reduction" := Fluctuation_L *
                                                         -Scenario_LT.Deduction *
                                                         GetRandomFluctuation(Scenario_LT)
                                                         * Factor_L;

                    //### Rabatt (Brutto):
                    // neg. !
                    FSE_RT."S Discount Amount Gross" := Fluctuation_L *
                                                        -Scenario_LT.Discount *
                                                        GetRandomFluctuation(Scenario_LT)
                                                        * Factor_L;

                    //### erzielter Umsatz VK (Netto) und Rabatt (Netto):
                    if (100 + Scenario_LT."VAT %") <> 0 then begin
                        FSE_RT."S Real. Net Sales Amount" := FSE_RT."S Realized Gross Sales Amount" / (100 + Scenario_LT."VAT %") * 100;
                        FSE_RT."S Discount Amount" := FSE_RT."S Discount Amount Gross" / (100 + Scenario_LT."VAT %") * 100;
                    end else begin
                        FSE_RT."S Real. Net Sales Amount" := 0;
                        FSE_RT."S Discount Amount" := 0;
                    end;

                    //### WE VK:
                    FSE_RT."P Inventory Value Sales" := Fluctuation_L *
                                                        Scenario_LT."Purchase Value Gross" *
                                                        GetRandomFluctuation(Scenario_LT)
                                                        * Factor_L;   //### 090624

                    //### Bestandsänderung:
                    FSE_RT."I Inventory Value Sales" := FSE_RT."P Inventory Value Sales" +
                                                        FSE_RT."S Change in GS-Prices" +
                                                        FSE_RT."S Discount Amount Gross" +
                                                        FSE_RT."S Realized GSP Reduction" +
                                                        FSE_RT."S Realized Gross Sales Amount";

                    //### temp. Kalkulation (erzielt) zur EK-Berechnung:
                    Calculation_L := Scenario_LT."Calculation (act.)" * GetRandomFluctuation(Scenario_LT);

                    //### Kalkulation (WE) für Einkauf:
                    if FSE_RT."S Realized Gross Sales Amount" <> 0 then
                        CalculationWR_L := (FSE_RT."S Realized Gross Sales Amount" + FSE_RT."S Change in GS-Prices") *
                                         (Calculation_L + 100) / FSE_RT."S Realized Gross Sales Amount" - 100
                    else
                        CalculationWR_L := 0;





                    //### Umsatz/WE EK:
                    if (Calculation_L + 100) <> 0 then begin
                        FSE_RT."S Cost Amount" := 100 * FSE_RT."S Realized Gross Sales Amount" / (Calculation_L + 100);
                        //FSE_RT."P Cost Amount" := 100 * FSE_RT."P Inventory Value Sales" / (Calculation + 100);
                        FSE_RT."P Cost Amount" := 100 * FSE_RT."P Inventory Value Sales" / (CalculationWR_L + 100);

                        //FSE_RT."I Cost Amount" := 100 * FSE_RT."I Inventory Value Sales" / (Calculation + 100);
                    end else begin
                        FSE_RT."S Cost Amount" := 0;
                        FSE_RT."P Cost Amount" := 0;
                    end;

                    //### noch DS-Preis ermitteln und Menge berechnen:
                    AvgPrice_L := GetAvgPrice(CopyStr(FSE_RT."Item Category Code", 1, 10), FSE_RT."Main Waregroup", FSE_RT.Division, Scenario_P);
                    if FSE_RT."Item No." <> '' then
                        if Item_LT.Get(FSE_RT."Item No.") then
                            AvgPrice_L := Item_LT."Unit Price";

                    if AvgPrice_L <> 0 then begin
                        FSE_RT."S Quantity" := Round(FSE_RT."S Realized Gross Sales Amount" / AvgPrice_L, 1);
                        FSE_RT."P Quantity" := Round(FSE_RT."P Inventory Value Sales" / AvgPrice_L, 1);
                    end else begin
                        FSE_RT."S Quantity" := 0;
                        FSE_RT."P Quantity" := 0;
                    end;

                    //### Bestandsänderung Menge und EK:
                    FSE_RT."I Quantity" := FSE_RT."P Quantity" + FSE_RT."S Quantity";
                    FSE_RT."I Cost Amount" := FSE_RT."P Cost Amount" + FSE_RT."S Cost Amount";

                    FSE_RT.Insert();

                    Window2_G.Update(2, Round(Counter_G / LinesComplete_G * 9999, 1));
                    Counter_G += 1;
                end else
                    //### weitere Dimension: erneuter Funktionsaufruf (rekursiv)
#pragma warning disable AL0432
                    CreateFSELines(LfdNo_R, FSE_RT, Scenario_P, ScenarioDimension2_LT.Code, Fluctuation_L);
#pragma warning restore AL0432

            until ScenarioDimLine_LT.Next() = 0;
        end;
    end;

#pragma warning disable AA0150
    procedure CreateFSEInventoryLines(var LfdNo_R: Integer; var FSE_RT: Record "BET FN Fashion Statistic Entry"; Scenario_P: Code[20]; Dimension_P: Code[20]; var Fluctuation_P: Decimal)
#pragma warning restore AA0150
    var
        Scenario_LT: Record "BET FN Scenario";
        ScenarioDimension2_LT: Record "BET FN Scenario Dimension";
        ScenarioDimension_LT: Record "BET FN Scenario Dimension";
        ScenarioDimLine_LT: Record "BET FN Scenario Dimension Line";
        Item_LT: Record Item;
        InsertMode_L: Boolean;
        AvgPrice_L: Decimal;
        Calculation_L: Decimal;
        Fluctuation_L: Decimal;
    begin
        //### rekursives Durchlaufen aller Dimensionen (außer Datum) und Anlegen der Bestandszeilen:
        Scenario_LT.Get(Scenario_P);
        ScenarioDimension_LT.Get(Scenario_P, Dimension_P);

        ScenarioDimLine_LT.Reset();
        ScenarioDimLine_LT.SetRange("Scenario Code", Scenario_P);
        ScenarioDimLine_LT.SetRange("Dimension Code", Dimension_P);
        ScenarioDimLine_LT.SetRange(Active, true);
        if ScenarioDimLine_LT.FindSet() then begin
            ScenarioDimension2_LT.Reset();
            ScenarioDimension2_LT.SetRange("Scenario Code", Scenario_P);
            ScenarioDimension2_LT.SetRange(Dateline, false);    //### nicht Datum
            ScenarioDimension2_LT.SetFilter(Code, '>%1', Dimension_P);
            InsertMode_L := not ScenarioDimension2_LT.FindFirst();    //### Posten einfügen, wenn keine weitere Dimension

            repeat
                //### Übernehmen der Dimensionswerte (Datum, Fil. HWG) in Statistikposten:
                SetFashStatEntryDimension(ScenarioDimension_LT, FSE_RT, ScenarioDimLine_LT.Code);

                //### Berechnung der Werte (incl. Abweichung):
                Fluctuation_L := Fluctuation_P * ScenarioDimLine_LT.Percentage / 100;     //### normaler Prozentwert ohne Abweichung


                if InsertMode_L then begin   //### keine weitere Dimension: Rekursionsabbruch und Einfügen der Statistikposten
                    LfdNo_R += 1;
                    FSE_RT."Entry No." := LfdNo_R;

                    FSE_RT."I Inventory Value Sales" := Fluctuation_L * Scenario_LT."Opening Stock" * GetRandomFluctuation(Scenario_LT);

                    //### temp. Kalkulation zur EK-Berechnung:
                    Calculation_L := Scenario_LT."Calculation (act.)" * GetRandomFluctuation(Scenario_LT);

                    //### Bestand EK:
                    if (Calculation_L + 100) <> 0 then
                        FSE_RT."I Cost Amount" := 100 * FSE_RT."I Inventory Value Sales" / (Calculation_L + 100)
                    else
                        FSE_RT."I Cost Amount" := 0;

                    //### noch DS-Preis ermitteln und Menge berechnen:
                    AvgPrice_L := GetAvgPrice(CopyStr(FSE_RT."Item Category Code", 1, 10), FSE_RT."Main Waregroup", FSE_RT.Division, Scenario_P);
                    if FSE_RT."Item No." <> '' then
                        if Item_LT.Get(FSE_RT."Item No.") then
                            AvgPrice_L := Item_LT."Unit Price";

                    if AvgPrice_L <> 0 then
                        FSE_RT."I Quantity" := Round(FSE_RT."I Inventory Value Sales" / AvgPrice_L, 1)
                    else
                        FSE_RT."I Quantity" := 0;

                    FSE_RT.Insert();

                    Window_G.Update(2, Round(Counter_G / LinesWithoutDate_G * 9999, 1));
                    Counter_G += 1;
                end else
                    //### weitere Dimension: erneuter Funktionsaufruf (rekursiv)
#pragma warning disable AL0432
                    CreateFSEInventoryLines(LfdNo_R, FSE_RT, Scenario_P, ScenarioDimension2_LT.Code, Fluctuation_L);
#pragma warning restore AL0432

            until ScenarioDimLine_LT.Next() = 0;
        end;
    end;

    procedure CreatePurchaseStatisticEntries(Scenario_P: Code[20])
    var
        PSE_LT: Record "BET FN Purchase Statistic Ent";
        Scenario_LT: Record "BET FN Scenario";
        ScenarioDimension_LT: Record "BET FN Scenario Dimension";
        ScenarioDimLine_LT: Record "BET FN Scenario Dimension Line";
        Date_LT: Record Date;
        ConfirmManagement: Codeunit "Confirm Management";
        DimWithZeroLine_L: Code[20];
        Fluctuation_L: Decimal;
        OutstAmNet_L: Decimal;
        PurchaseValueCost_L: Decimal;
        LfdNo_L: Integer;
        MonthCount_L: Integer;
        DeleteEntriesLbl: Label 'Deleting entries...';
        DeleteOrderEntriesAndCreateValuesForScenarioQst: Label 'Delete all order entries and create new values for scenario %1?', Comment = '%1';
        DimensionHasActiveLinesWithPercentileQst: Label 'Dimension %1 has active lines with percentage = 0.\Continue anyway?', Comment = '%1';
        Time1_L: Time;
        Time2_L: Time;
    begin
        //### - akt. + 4 Monate zurück + 7 Monate vorwärts = 12 Monate mit 100%
        //### - %-Satz des in Bestellungen befindlichen gesamten Jahres-WE: 40%

        if not ConfirmManagement.GetResponse(StrSubstNo(DeleteOrderEntriesAndCreateValuesForScenarioQst, Scenario_P), false) then
            exit;

        Scenario_LT.Get(Scenario_P);
        DimWithZeroLine_L := CheckActiveDimLineZeroPercent(Scenario_P);      //### 090630
        if ScenarioDimension_LT.Get(Scenario_P, DimWithZeroLine_L) then
            if not ConfirmManagement.GetResponse(StrSubstNo(DimensionHasActiveLinesWithPercentileQst, DimWithZeroLine_L), false) then
                exit;

        Window_G.Open(DeleteEntriesLbl);
        PSE_LT.Reset();
        PSE_LT.DeleteAll();
        Window_G.Close();

        InitPercentPerMonthPSE();

        Time1_L := Time();

        //### zuerst EK-Wert (Einkauf gesamtes Jahr) des Szenarios ermitteln:
        if ((Scenario_LT."Calculation (act.)" + 100) / 100) <> 0 then
            PurchaseValueCost_L := Scenario_LT."Purchase Value Gross" / ((Scenario_LT."Calculation (act.)" + 100) / 100)
        else
            Error('Es kann kein EK-Wareneinsatz ermittelt werden.');

        //### Betrag ermitteln, welcher insgesamt in allen Bestellungen steckt:
        OutstAmNet_L := Scenario_LT."Purch. Val. in Purch. Order %" * PurchaseValueCost_L / 100;

        //### Anzahl der zu erstellenden Zeilen ermitteln (für Fortschrittsbalken):
        ScenarioDimension_LT.Reset();
        ScenarioDimension_LT.SetRange("Scenario Code", Scenario_P);
        ScenarioDimension_LT.SetRange(Dateline, false);
        if ScenarioDimension_LT.FindSet() then begin
            LinesWithoutDate_G := 1;
            repeat
                ScenarioDimLine_LT.Reset();
                ScenarioDimLine_LT.SetRange("Scenario Code", Scenario_P);
                ScenarioDimLine_LT.SetRange("Dimension Code", ScenarioDimension_LT.Code);
                ScenarioDimLine_LT.SetRange(Active, true);
                LinesWithoutDate_G *= ScenarioDimLine_LT.Count();
            until ScenarioDimension_LT.Next() = 0;
        end;

        //### mit Datum:
        LinesComplete_G := LinesWithoutDate_G * 12;     //### immer nur 12 Monate betrachten

        //### 12 Monate (-4 ...akt. Monat... +7)
        Date_LT.Reset();
        Date_LT.SetRange("Period Type", Date_LT."Period Type"::Month);
        Date_LT.SetRange("Period Start", CalcDate('<-CM -4M>', WorkDate()), CalcDate('<-CM +7M>', WorkDate()));
        if Date_LT.FindSet() then begin
            LfdNo_L := 0;
            Fluctuation_L := 1;
            DateTime_G := 0DT;  //### Zeitstempel für Randomfunktion
            Window_G.Open('Erstelle Orderposten für Szenario #1##########\' +
                          '@2@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@', Scenario_P);
            PSE_LT.Init();
            Counter_G := 0;
            MonthCount_L := 0;
            repeat
                MonthCount_L += 1;
                PSE_LT."Expected Receipt Date" := Date_LT."Period Start";     //### erw. WE-Datum auf Monatsersten

                ScenarioDimension_LT.Reset();
                ScenarioDimension_LT.SetRange("Scenario Code", Scenario_P);
                ScenarioDimension_LT.SetRange(Dateline, false);
                if ScenarioDimension_LT.FindFirst() then;      //### erste Nicht-Datums-Dimension oder leeres Rec.
                CreatePSELines(LfdNo_L, PSE_LT, Scenario_P, ScenarioDimension_LT.Code, Fluctuation_L, OutstAmNet_L, MonthCount_L);
            until Date_LT.Next() = 0;
            Window_G.Close();
        end;

        //### 090701
        SetScenarioActive(Scenario_P);

        Time2_L := Time();
        Message('Zeit in ms: ' + Format(Time2_L - Time1_L));
    end;

    procedure CreatePSELines(var LfdNo_R: Integer; var PSE_RT: Record "BET FN Purchase Statistic Ent"; Scenario_P: Code[20]; Dimension_P: Code[20]; var Fluctuation_P: Decimal; OutstAmNet_P: Decimal; MonthCount_P: Integer)
    var
        Scenario_LT: Record "BET FN Scenario";
        ScenarioDimension2_LT: Record "BET FN Scenario Dimension";
        ScenarioDimension_LT: Record "BET FN Scenario Dimension";
        ScenarioDimLine_LT: Record "BET FN Scenario Dimension Line";
        Item_LT: Record Item;
        AvgPrice_L: Decimal;
        Calculation_L: Decimal;
        Fluctuation_L: Decimal;
    begin
        Scenario_LT.Get(Scenario_P);

        if not ScenarioDimension_LT.Get(Scenario_P, Dimension_P) then begin     //### keine weitere Dimension: Insert
                                                                                //### Verteilung des in Bestellungen befindlichen EK-Wertes auf die Monate (a = akt. Monat)
                                                                                /*
                                                                                    a-4:    1
                                                                                    a-3:    2
                                                                                    a-2:    3
                                                                                    a-1:    7
                                                                                    a:      13
                                                                                    a+1:    15
                                                                                    a+2:    20
                                                                                    a+3:    17
                                                                                    a+4:    11
                                                                                    a+5:    8
                                                                                    a+6:    2
                                                                                    a+7:    1
                                                                                */

            //### Aufteilung der Einkaufswerte auf zurückliegende/akt./kommende Monate
            Fluctuation_P := Fluctuation_P * MonthPercentArray_G[MonthCount_P] / 100;


            LfdNo_R += 1;
            PSE_RT."Entry No." := LfdNo_R;

            PSE_RT."Net Outstanding Amount (LCY)" := Fluctuation_P *
                                                     OutstAmNet_P *
                                                     GetRandomFluctuation(Scenario_LT);

            //### temp. Kalkulation zur EK-Berechnung:
            Calculation_L := Scenario_LT."Calculation (act.)" * GetRandomFluctuation(Scenario_LT);

            //### Restbestellwert VK:
            if (Calculation_L + 100) <> 0 then
                PSE_RT."Outst. Gross Sales Amt. (LCY)" := PSE_RT."Net Outstanding Amount (LCY)" * (Calculation_L + 100) / 100
            else
                PSE_RT."Outst. Gross Sales Amt. (LCY)" := 0;

            //### noch DS-Preis ermitteln und Menge berechnen:
            AvgPrice_L := GetAvgPrice(CopyStr(PSE_RT."Item Category Code", 1, 10), PSE_RT."Main Waregroup", PSE_RT.Division, Scenario_P);
            if PSE_RT."Item No." <> '' then
                if Item_LT.Get(PSE_RT."Item No.") then
                    AvgPrice_L := Item_LT."Unit Price";


            if AvgPrice_L <> 0 then
                PSE_RT."Outstanding Quantity" := Round(PSE_RT."Outst. Gross Sales Amt. (LCY)" / AvgPrice_L, 1)
            else
                PSE_RT."Outstanding Quantity" := 0;

            PSE_RT.Insert();

            Window_G.Update(2, Round(Counter_G / LinesComplete_G * 9999, 1));
            Counter_G += 1;
        end else begin
            ScenarioDimLine_LT.Reset();
            ScenarioDimLine_LT.SetRange("Scenario Code", Scenario_P);
            ScenarioDimLine_LT.SetRange("Dimension Code", Dimension_P);
            ScenarioDimLine_LT.SetRange(Active, true);
            if ScenarioDimLine_LT.FindSet() then
                repeat
                    //### Übernehmen der Dimensionswerte (Datum, Fil. HWG) in Statistikposten:
                    SetPSEDimension(ScenarioDimension_LT, PSE_RT, ScenarioDimLine_LT.Code);

                    //### Berechnung der Werte (incl. Abweichung):
                    Fluctuation_L := Fluctuation_P * ScenarioDimLine_LT.Percentage / 100;     //### normaler Prozentwert ohne Abweichung


                    ScenarioDimension2_LT.Reset();
                    ScenarioDimension2_LT.SetRange("Scenario Code", Scenario_P);
                    ScenarioDimension2_LT.SetRange(Dateline, false);    //### nicht Datum
                    ScenarioDimension2_LT.SetFilter(Code, '>%1', Dimension_P);
                    if ScenarioDimension2_LT.FindFirst() then;    //### Posten einfügen, wenn keine weitere Dimension
                    CreatePSELines(LfdNo_R, PSE_RT, Scenario_P, ScenarioDimension2_LT.Code, Fluctuation_L, OutstAmNet_P, MonthCount_P);
                until ScenarioDimLine_LT.Next() = 0;
        end;

    end;

    procedure CopyScenario(Scenario_P: Code[20])
    var
        Scenario_LT: Record "BET FN Scenario";
        ScenarioNew_LT: Record "BET FN Scenario";
        ScenarioDimension_LT: Record "BET FN Scenario Dimension";
        ScenarioDimensionNew_LT: Record "BET FN Scenario Dimension";
        ScenarioDimLine_LT: Record "BET FN Scenario Dimension Line";
        ScenarioDimLineNew_LT: Record "BET FN Scenario Dimension Line";
        ConfirmManagement: Codeunit "Confirm Management";
        InputPage_LP: Page "BET FN Planning Input Page";
        NewScenarioCode_L: Code[10];
        CopyScenarioQst: Label 'Copy scenario %1 to scenario %2?', Comment = '%1 %2';
        CreateCopyFromScenarioQst: Label 'Create copy of scenario %1?', Comment = '%1';
        EmptyScenarioCodeNotAllowedErr: Label 'Empty scenario code not allowed.';
        InsertNewScenarioCodeLbl: Label 'Insert new scenario code.';
    begin
        if not ConfirmManagement.GetResponse(StrSubstNo(CreateCopyFromScenarioQst, Scenario_P), false) then
            exit;


        //### obsolet...
        //Window_L.Open('Neuer Szenariocode: #1########');
        //Window_L.INPUT(1, NewScenarioCode_L);

        InputPage_LP.SetPageDescription(InsertNewScenarioCodeLbl);
        if InputPage_LP.RunModal() = Action::OK then
            Evaluate(NewScenarioCode_L, InputPage_LP.GetInputText());
        if NewScenarioCode_L = '' then
            Error(EmptyScenarioCodeNotAllowedErr);



        if not ConfirmManagement.GetResponse(StrSubstNo(CopyScenarioQst, Scenario_P, NewScenarioCode_L), false) then
            exit;

        //### Szenario:
        Scenario_LT.Get(Scenario_P);
        ScenarioNew_LT.Init();
        ScenarioNew_LT.TransferFields(Scenario_LT);
        ScenarioNew_LT.Active := false;
        ScenarioNew_LT.Code := NewScenarioCode_L;
        ScenarioNew_LT.Insert(false);

        //### Dimensionen:
        ScenarioDimension_LT.Reset();
        ScenarioDimension_LT.SetRange("Scenario Code", Scenario_P);
        if ScenarioDimension_LT.FindSet() then
            repeat
                ScenarioDimensionNew_LT.Init();
                ScenarioDimensionNew_LT.TransferFields(ScenarioDimension_LT);
                ScenarioDimensionNew_LT."Scenario Code" := NewScenarioCode_L;
                ScenarioDimensionNew_LT.Insert(false);
            until ScenarioDimension_LT.Next() = 0;

        //### Dimensionszeilen:
        ScenarioDimLine_LT.Reset();
        ScenarioDimLine_LT.SetRange("Scenario Code", Scenario_P);
        if ScenarioDimLine_LT.FindSet() then
            repeat
                ScenarioDimLineNew_LT.Init();
                ScenarioDimLineNew_LT.TransferFields(ScenarioDimLine_LT);
                ScenarioDimLineNew_LT."Scenario Code" := NewScenarioCode_L;
                ScenarioDimLineNew_LT.Insert(false);
            until ScenarioDimLine_LT.Next() = 0;
    end;

    procedure GetRandomFluctuation(Scenario_PT: Record "BET FN Scenario"): Decimal
    var
        DateTime_L: DateTime;
        NewFluctuation_L: Decimal;
        RandomNo_L: Integer;
    begin
        //### hier erfolgt die Zufallszahlengenerierung für die Abweichungen:

        if Scenario_PT.Fluctuation = 0 then
            exit(1);

        //### ist seit dem letzten Funktionsaufruf weniger als 1 ms vergangen, dann 1ms warten (sonst gleiche Werte!)
        DateTime_L := CreateDateTime(WorkDate(), Time());
        if DateTime_L = DateTime_G then
            Sleep(1)
        else
            DateTime_G := DateTime_L;

        Randomize();
        RandomNo_L := Random((2 * Scenario_PT.Fluctuation) - 1);    // 1..59
        NewFluctuation_L := Scenario_PT.Fluctuation - RandomNo_L;     // -29..29

        exit(1 + (NewFluctuation_L / 100));
    end;

    procedure SetFashStatEntryDimension(ScenarioDimension_PT: Record "BET FN Scenario Dimension"; var FSE_RT: Record "BET FN Fashion Statistic Entry"; DimLineCode_P: Code[20])
    var
        MainWG_LT: Record "BET FN Main Waregroup";
        PlanLevel_LT: Record "BET FN Planning Level";
        Customer_LT: Record Customer;
        Item_LT: Record Item;
        ItemCat_LT: Record "Item Category";
        Location_LT: Record Location;
        RR_L: RecordRef;
        FR_L: FieldRef;
    begin
        //### dynamisch (über Tabellen- und Feldnummern):
        PlanLevel_LT.Reset();
        PlanLevel_LT.SetRange("Index Table No.", ScenarioDimension_PT."Table No.");
        PlanLevel_LT.SetRange(Activated, true);
        if PlanLevel_LT.FindFirst() then begin
            RR_L.GetTable(FSE_RT);
            FR_L := RR_L.Field(PlanLevel_LT."Fash. Stat. Entry Field");
            FR_L.Value(DimLineCode_P);

            //### bei Abt./HWG: jeweils WG/HWG ergänzen
            case ScenarioDimension_PT."Table No." of
                Database::Item:
                    if Item_LT.Get(DimLineCode_P) then begin
                        FR_L := RR_L.Field(4);    //### Warengruppe
                        FR_L.Value(Item_LT."Item Category Code");
                        FR_L := RR_L.Field(102);    //### HWG
                        FR_L.Value(Item_LT."BET FN Main Waregroup");
                        FR_L := RR_L.Field(101);    //### Abteilung
                        FR_L.Value(Item_LT."BET FN Division");
                    end;

                Database::"Item Category":   //### WG: HWG und Abteilung ergänzen
                    if ItemCat_LT.Get(DimLineCode_P) then begin
                        FR_L := RR_L.Field(102);    //### HWG
                        FR_L.Value(ItemCat_LT."BET FN Main Waregroup");
                        FR_L := RR_L.Field(101);    //### Abteilung
                        FR_L.Value(ItemCat_LT."BET FN Division");
                    end;

                Database::"BET FN Main Waregroup": //### HWG: Abteilung ergänzen
                    if MainWG_LT.Get(DimLineCode_P) then begin
                        FR_L := RR_L.Field(101);    //### Abteilung
                        FR_L.Value(MainWG_LT.Division);
                    end;

                //### Lagerortgruppe ab FN602 nicht mehr 1:n !
                Database::Location:
                    begin
                        //### Lagerortgruppe:
                        if Location_LT.Get(DimLineCode_P) then begin
                            FR_L := RR_L.Field(10);    //### Lagerortgruppe
                            FR_L.Value(Location_LT."BET FN No Of GLN");
                        end;
                        //### Land:
                        if Location_LT.Get(DimLineCode_P) then begin
                            FR_L := RR_L.Field(11);
                            FR_L.Value(Location_LT."Country/Region Code");
                        end;
                    end;


                //### Kunde: Vertreter ergänzen
                Database::Customer:
                    if Customer_LT.Get(DimLineCode_P) then begin
                        FR_L := RR_L.Field(111);    //### Vertreter
                        FR_L.Value(Customer_LT."BET FN Agent No");
                    end;

            end;

            RR_L.SetTable(FSE_RT);
        end;
    end;

    procedure SetPSEDimension(ScenarioDimension_PT: Record "BET FN Scenario Dimension"; var PSE_RT: Record "BET FN Purchase Statistic Ent"; DimLineCode_P: Code[20])
    var
        MainWG_LT: Record "BET FN Main Waregroup";
        PlanLevel_LT: Record "BET FN Planning Level";
        Item_LT: Record Item;
        ItemCat_LT: Record "Item Category";
        RR_L: RecordRef;
        FR_L: FieldRef;
    begin
        //### dynamisch (über Tabellen- und Feldnummern):
        PlanLevel_LT.Reset();
        PlanLevel_LT.SetRange("Index Table No.", ScenarioDimension_PT."Table No.");
        PlanLevel_LT.SetRange(Activated, true);
        if PlanLevel_LT.FindFirst() then begin
            RR_L.GetTable(PSE_RT);
            FR_L := RR_L.Field(PlanLevel_LT."Fash. Stat. Entry Field");    //### FSE und PSE haben gleiche Feldnummern, also OK
            FR_L.Value(DimLineCode_P);

            //### bei Abt./HWG: jeweils WG/HWG ergänzen
            case ScenarioDimension_PT."Table No." of
                Database::Item: //### Artikel: WG, HWG und Abteilung ergänzen
                    if Item_LT.Get(DimLineCode_P) then begin
                        FR_L := RR_L.Field(4);    //### Warengruppe
                        FR_L.Value(Item_LT."Item Category Code");
                        FR_L := RR_L.Field(102);    //### HWG
                        FR_L.Value(Item_LT."BET FN Main Waregroup");
                        FR_L := RR_L.Field(101);    //### Abteilung
                        FR_L.Value(Item_LT."BET FN Division");
                    end;

                Database::"Item Category":   //### WG: HWG und Abteilung ergänzen
                    if ItemCat_LT.Get(DimLineCode_P) then begin
                        FR_L := RR_L.Field(102);    //### HWG
                        FR_L.Value(ItemCat_LT."BET FN Main Waregroup");
                        FR_L := RR_L.Field(101);    //### Abteilung
                        FR_L.Value(ItemCat_LT."BET FN Division");
                    end;

                Database::"BET FN Main Waregroup": //### HWG: Abteilung ergänzen
                    if MainWG_LT.Get(DimLineCode_P) then begin
                        FR_L := RR_L.Field(101);    //### Abteilung
                        FR_L.Value(MainWG_LT.Division);
                    end;
            end;

            RR_L.SetTable(PSE_RT);
        end;
    end;

    procedure GetAvgPrice(ItemCatCode_P: Code[10]; MainWGCode_P: Code[10]; DivisionCode_P: Code[10]; Scenario_P: Code[20]): Decimal
    var
        ScenarioDimension_LT: Record "BET FN Scenario Dimension";
        ScenarioDimLine_LT: Record "BET FN Scenario Dimension Line";
        RandomNo_L: Decimal;
    begin
        //### für die einzufügende FSE/PSE-Zeile wird der DS-Preis ermittelt (aus WG oder HWG oder Abteilung)
        //### kann kein DS-Preis ermittelt werden, dann wird einer zufällig ermittelt

        //### zuerst WG:
        if ItemCatCode_P <> '' then begin
            ScenarioDimension_LT.Reset();
            ScenarioDimension_LT.SetRange("Scenario Code", Scenario_P);
            ScenarioDimension_LT.SetRange("Table No.", Database::"Item Category");
            if ScenarioDimension_LT.FindFirst() then;

            ScenarioDimLine_LT.Reset();
            ScenarioDimLine_LT.SetRange("Scenario Code", Scenario_P);
            ScenarioDimLine_LT.SetRange("Dimension Code", ScenarioDimension_LT.Code);
            ScenarioDimLine_LT.SetRange(Code, ItemCatCode_P);

            if ScenarioDimLine_LT.FindFirst() and (ScenarioDimLine_LT."Avg. Price" <> 0) then
                exit(ScenarioDimLine_LT."Avg. Price");
        end;

        //### dann HWG:
        if MainWGCode_P <> '' then begin
            ScenarioDimension_LT.Reset();
            ScenarioDimension_LT.SetRange("Scenario Code", Scenario_P);
            ScenarioDimension_LT.SetRange("Table No.", Database::"BET FN Main Waregroup");
            if ScenarioDimension_LT.FindFirst() then;

            ScenarioDimLine_LT.Reset();
            ScenarioDimLine_LT.SetRange("Scenario Code", Scenario_P);
            ScenarioDimLine_LT.SetRange("Dimension Code", ScenarioDimension_LT.Code);
            ScenarioDimLine_LT.SetRange(Code, MainWGCode_P);

            if ScenarioDimLine_LT.FindFirst() and (ScenarioDimLine_LT."Avg. Price" <> 0) then
                exit(ScenarioDimLine_LT."Avg. Price");
        end;

        //### zuletzt Abteilung:
        if DivisionCode_P <> '' then begin
            ScenarioDimension_LT.Reset();
            ScenarioDimension_LT.SetRange("Scenario Code", Scenario_P);
            ScenarioDimension_LT.SetRange("Table No.", Database::"BET FN Division");
            if ScenarioDimension_LT.FindFirst() then;

            ScenarioDimLine_LT.Reset();
            ScenarioDimLine_LT.SetRange("Scenario Code", Scenario_P);
            ScenarioDimLine_LT.SetRange("Dimension Code", ScenarioDimension_LT.Code);
            ScenarioDimLine_LT.SetRange(Code, DivisionCode_P);

            if ScenarioDimLine_LT.FindFirst() and (ScenarioDimLine_LT."Avg. Price" <> 0) then
                exit(ScenarioDimLine_LT."Avg. Price");
        end;


        //### wenn bisher kein Preis ermittelt wurde: Random-Fkt. verwenden
        // zufällige DS-Preise: 1 - 250
        Randomize();
        RandomNo_L := Random(250);
        exit(RandomNo_L);
    end;

    procedure InitPercentPerMonthFSE(MonthNo_P: Integer): Decimal
    begin
        //### 090624_2
        case MonthNo_P of
            1:
                exit(6);    // Januar
            2:
                exit(7);    // Februar
            3:
                exit(7);    // März
            4:
                exit(6);    // April
            5:
                exit(7);    // Mai
            6:
                exit(7);    // Juni
            7:
                exit(7);    // Juli
            8:
                exit(8);    // August
            9:
                exit(8);    // September
            10:
                exit(9);   // Oktober
            11:
                exit(11);  // November
            12:
                exit(17);  // Dezember
        end;
    end;

    procedure InitPercentPerMonthPSE()
    begin
        //### Aufteilung der Einkaufswerte auf zurückliegende/akt./kommende Monate in Prozent:
        Clear(MonthPercentArray_G);
        MonthPercentArray_G[1] := 0;  //### akt. Monat - 4 Monate
        MonthPercentArray_G[2] := 0;  //### akt. Monat - 3 Monate
        MonthPercentArray_G[3] := 0;  //### akt. Monat - 2 Monate
        MonthPercentArray_G[4] := 1;  //### akt. Monat - 1 Monat
        MonthPercentArray_G[5] := 15;  //### akt. Monat
        MonthPercentArray_G[6] := 26;  //### akt. Monat + 1 Monat
        MonthPercentArray_G[7] := 20;  //### akt. Monat + 2 Monate
        MonthPercentArray_G[8] := 13;  //### akt. Monat + 3 Monate
        MonthPercentArray_G[9] := 11;  //### akt. Monat + 4 Monate
        MonthPercentArray_G[10] := 8;  //### akt. Monat + 5 Monate
        MonthPercentArray_G[11] := 5;  //### akt. Monat + 6 Monate
        MonthPercentArray_G[12] := 1;  //### akt. Monat + 7 Monate
    end;

    procedure CheckActiveDimLineZeroPercent(Scenario_P: Code[20]): Code[20]
    var
        ScenarioDimLine_LT: Record "BET FN Scenario Dimension Line";
    begin
        //### Da das Erstellen der Posten mitunter sehr lange dauert, wird vorher geprüft, ob versehentlich
        //### aktive Dimensionszeilen mit einem Prozentanteil von 0 existieren.
        //### Rückgabe: Dimension, die aktive Dimensionszeilen mit Prozentanteil = 0 besitzt
        ScenarioDimLine_LT.Reset();
        ScenarioDimLine_LT.SetRange("Scenario Code", Scenario_P);
        ScenarioDimLine_LT.SetRange(Active, true);
        ScenarioDimLine_LT.SetRange(Percentage, 0);
        if ScenarioDimLine_LT.FindFirst() then
            exit(ScenarioDimLine_LT."Dimension Code")
        else
            exit('');
    end;

    procedure SetScenarioActive(Scenario_P: Code[20])
    var
        Scenario_LT: Record "BET FN Scenario";
    begin
        //### 090701
        Scenario_LT.Reset();
        Scenario_LT.SetRange(Active, true);
        Scenario_LT.SetFilter(Code, '<>%1', Scenario_P);
        Scenario_LT.ModifyAll(Active, false);

        Scenario_LT.Get(Scenario_P);
        Scenario_LT.Active := true;
        Scenario_LT.Modify();
        //### ...090701
    end;
}

