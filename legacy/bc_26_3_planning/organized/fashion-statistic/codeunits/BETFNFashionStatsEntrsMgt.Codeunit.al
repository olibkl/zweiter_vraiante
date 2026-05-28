/// <summary>
/// [fashion-statistic]
/// Modules: 
/// </summary>

#pragma warning disable AL0432
codeunit 5138632 "BET FN Fashion Stats Entrs Mgt"
{
    Access = Public;

    trigger OnRun()
    var
        PlanSetup_LT: Record "BET FN Planning Setup";
        ConfirmManagement: Codeunit "Confirm Management";
        PlanningSetupNotFoundErr: Label 'Planning setup not found.';
        RecreatePlanningStatisticsQst: Label 'Planung-Statistikposten wirklich neu aufbauen?';
    begin
        //### Aktualisierung des Fensters aller [WindowUpdateRange_G] Posten; hier erfolgt dann ebenfalls die
        //### Prüfung, ob bereits genug [CommitRange_G] Statistikposten in der temp. Tabelle enthalten sind
        WindowUpdateRange_G := 500;

        //### Mindestanzahl der in der temp. Tabelle enthaltenen Sätze für Übertragung der Sätze in die
        //### echte Statistiktabelle und COMMIT:
        CommitRange_G := 50;

        if not PlanSetup_LT.Get() then
            Error(PlanningSetupNotFoundErr);

        case PlanSetup_LT."Next Update Fash. Stat. Entr." of
            PlanSetup_LT."Next Update Fash. Stat. Entr."::None:
                exit;
            PlanSetup_LT."Next Update Fash. Stat. Entr."::Partially:
                UpdateTableTemp();
            PlanSetup_LT."Next Update Fash. Stat. Entr."::Complete:
                begin
                    if Confirm_G then
                        if not ConfirmManagement.GetResponse(RecreatePlanningStatisticsQst, false) then
                            exit;
                    RebuildTable();
                end;
        end;
    end;

    var
        Counter_G: BigInteger;
        CounterActual_G: BigInteger;
        EndingTime_G: BigInteger;
        RemainingTime_G: BigInteger;
        RunningTime_G: BigInteger;
        StartingTime_G: BigInteger;
        Confirm_G: Boolean;
        Total_G: Decimal;
        TotalActual_G: Decimal;
        Window_G: Dialog;
        CommitRange_G: Integer;
        TempCounter_G: Integer;
        WindowUpdateRange_G: Integer;

    procedure RebuildTable()
    var
        FashStatEntry_LT: Record "BET FN Fashion Statistic Entry";
        PlanSetup_LT: Record "BET FN Planning Setup";
    begin
        Window_G.Open('#3##################################');
        Window_G.Update(3, 'Lösche Statistiktabelle');

        FashStatEntry_LT.Reset();

        if not FashStatEntry_LT.IsEmpty() then
            FashStatEntry_LT.DeleteAll();

        PlanSetup_LT.ReadIsolation := PlanSetup_LT.ReadIsolation::UpdLock;
        PlanSetup_LT.Get();

        PlanSetup_LT."Last Value Entry in FSE" := 0;

        //### nach dem Neuaufbau automatisch umschalten auf differentiell:
        PlanSetup_LT."Next Update Fash. Stat. Entr." := PlanSetup_LT."Next Update Fash. Stat. Entr."::Partially;
        PlanSetup_LT.Modify();
        Window_G.Close();

        //UpdateTableTemp();
    end;

    procedure UpdateTableTemp()
    var
        FashStatEntry_LT: Record "BET FN Fashion Statistic Entry";
        TempFSE_LTT: Record "BET FN Fashion Statistic Entry" temporary;
        PlanSetup_LT: Record "BET FN Planning Setup";
        ValueEntry_LT: Record "Value Entry";
        LastNo_L: Integer;
    begin
        PlanSetup_LT.ReadIsolation := PlanSetup_LT.ReadIsolation::UpdLock;
        PlanSetup_LT.Get();

        FashStatEntry_LT.Reset();
        Window_G.Open('#3################################## #2###############\' +
                    '@1@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\' +
                    'Startzeit / akt. Zeit / Endzeit  #10### #13### #11####\' +
                    'Laufzeit / Restzeit / Gesamt     #14### #12### #15####\' +
                    'Posten pro Sekunde #16###');

        Window_G.Update(3, 'Berechne Statistiktabelle');

        StartingTime_G := TimeinInteger(Time());
        Window_G.Update(10, IntegerTimeinText(StartingTime_G));
        RunningTime_G := 0;
        EndingTime_G := 0;

        ValueEntry_LT.Reset();
        ValueEntry_LT.ReadIsolation := ValueEntry_LT.ReadIsolation::UpdLock;

        if ValueEntry_LT.FindLast() then
            Total_G := ValueEntry_LT."Entry No." - PlanSetup_LT."Last Value Entry in FSE";

        ValueEntry_LT.SetFilter("Entry No.", '>%1', PlanSetup_LT."Last Value Entry in FSE");

        if ValueEntry_LT.FindLast() then begin
            Counter_G := PlanSetup_LT."Last Value Entry in FSE";
            CounterActual_G := 0;
            TotalActual_G := Total_G;
        end;

        if ValueEntry_LT.FindSet(false) then begin
            TempFSE_LTT.Reset();
            TempFSE_LTT.DeleteAll();
            LastNo_L := 0;
            TempCounter_G := 0;

            repeat
                ProcessNewEntryAdvancedTemp(ValueEntry_LT, LastNo_L, TempFSE_LTT);
                Counter_G += 1;
                CounterActual_G += 1;

                //### Aktualisierung Fenster:
                if Counter_G mod WindowUpdateRange_G = 0 then begin
                    CalculateRemainingTime();
                    Window_G.Update(1, Round(CounterActual_G / Total_G * 9999, 1));
                    Window_G.Update(2, Counter_G);

                    if TempCounter_G >= CommitRange_G then begin

                        //### nach vorgegebener Anzahl Posten wird die temp. Statistik in die echte Tabelle
                        //### übernommen und die Postennr. im Setup gespeichert
                        TransferTempTable(TempFSE_LTT);

                        PlanSetup_LT."Last Value Entry in FSE" := ValueEntry_LT."Entry No.";
                        PlanSetup_LT.Modify();
                        Commit();

                        //### temp. Tab. wieder löschen + Zähler zurücksetzen:
                        TempFSE_LTT.Reset();
                        TempFSE_LTT.DeleteAll();
                        TempCounter_G := 0;
                    end;

                end;
            until ValueEntry_LT.Next() = 0;

            TransferTempTable(TempFSE_LTT);
            PlanSetup_LT."Last Value Entry in FSE" := ValueEntry_LT."Entry No.";
            PlanSetup_LT.Modify();
        end;

        Window_G.Close();
    end;

    procedure ProcessNewEntryAdvancedTemp(ValueEntry_PT: Record "Value Entry"; var LastNo_R: Integer; var FSE_RTT: Record "BET FN Fashion Statistic Entry" temporary)
    var
        Item_LT: Record Item;
    begin
        if Item_LT.Get(ValueEntry_PT."Item No.") then begin

            FSE_RTT.SetRange("Posting Date", CalcDate('<-CM>', ValueEntry_PT."Posting Date"));   //### auf Monatsersten
                                                                                                 //FSE_RTT.SetRange("Item No.", ValueEntry_PT."Item No.");
            FSE_RTT.SetRange("Location Code", ValueEntry_PT."Location Code");
            FSE_RTT.SetRange("Item Category Code", Item_LT."Item Category Code");
            FSE_RTT.SetRange("Vendor No.", Item_LT."Vendor No.");
            FSE_RTT.SetRange(Brand, Item_LT."BET FN Brand");
            //FSE_RTT.SetRange(Season, Season);

            if not FSE_RTT.Find('-') then begin
                FSE_RTT.Init();
                LastNo_R += 1;
                FSE_RTT."Entry No." := LastNo_R;
                FSE_RTT."Posting Date" := CalcDate('<-CM>', ValueEntry_PT."Posting Date");
                //FSE_RTT."Item No." := ValueEntry_PT."Item No.";
                FSE_RTT."Location Code" := ValueEntry_PT."Location Code";
                FSE_RTT."Item Category Code" := Item_LT."Item Category Code";
                FSE_RTT."Vendor No." := Item_LT."Vendor No.";
                FSE_RTT.Brand := Item_LT."BET FN Brand";
                FSE_RTT.Division := Item_LT."BET FN Division";
                FSE_RTT."Main Waregroup" := Item_LT."BET FN Main Waregroup";

                FSE_RTT.Insert();
                TempCounter_G += 1;
            end;

            case ValueEntry_PT."Item Ledger Entry Type" of
                //### Einkäufe:
                ValueEntry_PT."Item Ledger Entry Type"::Purchase:
                    begin
                        //### Einkauf Menge:
                        FSE_RTT."P Quantity" := FSE_RTT."P Quantity" + ValueEntry_PT."Item Ledger Entry Quantity";

                        //### Einkauf EK:
                        FSE_RTT."P Cost Amount" := FSE_RTT."P Cost Amount" + ValueEntry_PT."BET FN Cost Amount LCY";

                        //### Einkauf VK:
                        // FSE_RTT."P Inventory Value Sales" := FSE_RTT."P Inventory Value Sales" + //ValueEntry_PT."Inventory Value Sales (LCY)";
                        //                                     (ValueEntry_PT."Item Ledger Entry Quantity" * ValueEntry_PT."Gross Sales Price (LCY)");
                        FSE_RTT."P Inventory Value Sales" := FSE_RTT."P Inventory Value Sales" +
                                                            (ValueEntry_PT."Item Ledger Entry Quantity" * ValueEntry_PT."BET FN Gross Sales Price LCY");
                    end;

                //### Verkäufe:
                ValueEntry_PT."Item Ledger Entry Type"::Sale:
                    begin
                        //### Umsatz Menge:
                        FSE_RTT."S Quantity" := FSE_RTT."S Quantity" + ValueEntry_PT."Item Ledger Entry Quantity";

                        //### erzielter Umsatz VK:
                        FSE_RTT."S Realized Gross Sales Amount" := FSE_RTT."S Realized Gross Sales Amount"
                                                                   + ValueEntry_PT."BET FN Realized Gs Sales Amt";

                        //### Umsatz VK (Netto):
                        FSE_RTT."S Real. Net Sales Amount" := FSE_RTT."S Real. Net Sales Amount" + ValueEntry_PT."Sales Amount (Actual)";

                        //### Rabatte (Brutto):
                        FSE_RTT."S Discount Amount Gross" := FSE_RTT."S Discount Amount Gross" + ValueEntry_PT."BET FN Discount Amount Gs LCY";

                        //### Rabatte (Netto):
                        FSE_RTT."S Discount Amount" := FSE_RTT."S Discount Amount" + ValueEntry_PT."Discount Amount";

                        //### Preisänderungen:
                        //FSE_RTT."S Change in GS-Prices" := FSE_RTT."S Change in GS-Prices" + ???;

                        //### Umsatz EK:
                        FSE_RTT."S Cost Amount" := FSE_RTT."S Cost Amount" + ValueEntry_PT."BET FN Cost Amount LCY";

                        //### Umsatz VK (?)
                        // FSE_RTT."S Inventory Value Sales" := FSE_RTT."S Inventory Value Sales" + //ValueEntry_PT."Inventory Value Sales (LCY)";
                        //                                      (ValueEntry_PT."Item Ledger Entry Quantity" * ValueEntry_PT."Gross Sales Price (LCY)");
                        FSE_RTT."S Inventory Value Sales" := FSE_RTT."S Inventory Value Sales" +
                                                             (ValueEntry_PT."Item Ledger Entry Quantity" * ValueEntry_PT."BET FN Gross Sales Price LCY");
                    end;

                //### Abgänge:
                ValueEntry_PT."Item Ledger Entry Type"::"Negative Adjmt.":
                    begin
                        FSE_RTT."A Quantity" := FSE_RTT."A Quantity" + ValueEntry_PT."Item Ledger Entry Quantity";
                        FSE_RTT."A Cost Amount" := FSE_RTT."A Cost Amount" + ValueEntry_PT."BET FN Cost Amount LCY";
                        // ValueEntry_PT."Entry Type"::"5" does not exist.
                        //
                        // if ValueEntry_PT."Entry Type" = ValueEntry_PT."Entry Type"::"5" then
                        //     FSE_RTT."D Inventory Value Sales" := FSE_RTT."D Inventory Value Sales" - //ValueEntry_PT."Inventory Value Sales (LCY)"
                        //                                          (ValueEntry_PT."Item Ledger Entry Quantity" * ValueEntry_PT."Gross Sales Price (LCY)")
                        // else
                        //     FSE_RTT."A Inventory Value Sales" := FSE_RTT."A Inventory Value Sales" + //ValueEntry_PT."Inventory Value Sales (LCY)";
                        //                                          (ValueEntry_PT."Item Ledger Entry Quantity" * ValueEntry_PT."Gross Sales Price (LCY)");
                    end;

                //### Zugänge:
                ValueEntry_PT."Item Ledger Entry Type"::"Positive Adjmt.":
                    begin
                        FSE_RTT."A Quantity" := FSE_RTT."A Quantity" + ValueEntry_PT."Item Ledger Entry Quantity";
                        FSE_RTT."A Cost Amount" := FSE_RTT."A Cost Amount" + ValueEntry_PT."BET FN Cost Amount LCY";
                        // FSE_RTT."A Inventory Value Sales" := FSE_RTT."A Inventory Value Sales" + //ValueEntry_PT."Inventory Value Sales (LCY)";
                        //                                      (ValueEntry_PT."Item Ledger Entry Quantity" * ValueEntry_PT."Gross Sales Price (LCY)");
                        FSE_RTT."A Inventory Value Sales" := FSE_RTT."A Inventory Value Sales" +
                                                             (ValueEntry_PT."Item Ledger Entry Quantity" * ValueEntry_PT."BET FN Gross Sales Price LCY");
                    end;

                //### Umlagerungen:
                ValueEntry_PT."Item Ledger Entry Type"::Transfer:
                    begin
                        FSE_RTT."T Quantity" := FSE_RTT."T Quantity" + ValueEntry_PT."Item Ledger Entry Quantity";
                        FSE_RTT."T Cost Amount" := FSE_RTT."T Cost Amount" + ValueEntry_PT."BET FN Cost Amount LCY";
                        // FSE_RTT."T Inventory Value Sales" := FSE_RTT."T Inventory Value Sales" + //ValueEntry_PT."Inventory Value Sales (LCY)";
                        //                                      (ValueEntry_PT."Item Ledger Entry Quantity" * ValueEntry_PT."Gross Sales Price (LCY)");
                        FSE_RTT."T Inventory Value Sales" := FSE_RTT."T Inventory Value Sales" +
                                                             (ValueEntry_PT."Item Ledger Entry Quantity" * ValueEntry_PT."BET FN Gross Sales Price LCY");
                    end;
            end;

            FSE_RTT."I Quantity" := FSE_RTT."I Quantity" + ValueEntry_PT."Item Ledger Entry Quantity";
            // FSE_RTT."I Inventory Value Sales" := FSE_RTT."I Inventory Value Sales" + //ValueEntry_PT."Inventory Value Sales (LCY)";
            //                                      (ValueEntry_PT."Item Ledger Entry Quantity" * ValueEntry_PT."Gross Sales Price (LCY)");
            FSE_RTT."I Inventory Value Sales" := FSE_RTT."I Inventory Value Sales" +
                                                 (ValueEntry_PT."Item Ledger Entry Quantity" * ValueEntry_PT."BET FN Gross Sales Price LCY");
            FSE_RTT."I Cost Amount" := FSE_RTT."I Cost Amount" + ValueEntry_PT."BET FN Cost Amount LCY";
            FSE_RTT.Modify();
        end;
    end;

    procedure TransferTempTable(var FSE_PTT: Record "BET FN Fashion Statistic Entry" temporary)
    var
        FSE_LT: Record "BET FN Fashion Statistic Entry";
        LastNo_L: Integer;
    begin
        FSE_PTT.Reset();
        if FSE_PTT.Find('-') then begin
            //### letzte Postennr.:
            FSE_LT.Reset();
            if FSE_LT.FindLast() then
                LastNo_L := FSE_LT."Entry No."
            else
                LastNo_L := 0;

            FSE_LT.SetCurrentKey("Location Code", "Item Category Code", "Vendor No.", Brand, "Posting Date");

            repeat
                //FSE_LT.SetRange("Item No.", FSE_PTT."Item No.");
                FSE_LT.SetRange("Location Code", FSE_PTT."Location Code");
                FSE_LT.SetRange("Posting Date", FSE_PTT."Posting Date");
                FSE_LT.SetRange("Item Category Code", FSE_PTT."Item Category Code");
                FSE_LT.SetRange("Vendor No.", FSE_PTT."Vendor No.");
                FSE_LT.SetRange(Brand, FSE_PTT.Brand);

                FSE_LT.ReadIsolation := FSE_LT.ReadIsolation::UpdLock;

                if FSE_LT.FindFirst() then begin
                    //### Zeile existiert bereits, also nur Werte addieren:

                    //### Verkäufe:
                    FSE_LT."S Quantity" += FSE_PTT."S Quantity";
                    FSE_LT."S Cost Amount" += FSE_PTT."S Cost Amount";
                    FSE_LT."S Inventory Value Sales" += FSE_PTT."S Inventory Value Sales";
                    FSE_LT."S Realized Gross Sales Amount" += FSE_PTT."S Realized Gross Sales Amount";
                    FSE_LT."S Real. Net Sales Amount" += FSE_PTT."S Real. Net Sales Amount";

                    //### Abschriften/Rabatte/Preisänderungen:
                    FSE_LT."S Discount Amount Gross" += FSE_PTT."S Discount Amount Gross";
                    FSE_LT."S Discount Amount Gross S." += FSE_PTT."S Discount Amount Gross S.";
                    FSE_LT."S Realized GSP Reduction" += FSE_PTT."S Realized GSP Reduction";
                    FSE_LT."D Inventory Value Sales" += FSE_PTT."D Inventory Value Sales";
                    FSE_LT."S Change in GS-Prices" += FSE_PTT."S Change in GS-Prices";

                    //### Einkäufe:
                    FSE_LT."P Quantity" += FSE_PTT."P Quantity";
                    FSE_LT."P Cost Amount" += FSE_PTT."P Cost Amount";
                    FSE_LT."P Inventory Value Sales" += FSE_PTT."P Inventory Value Sales";

                    //### Zu-/Abgänge:
                    FSE_LT."A Quantity" += FSE_PTT."A Quantity";
                    FSE_LT."A Cost Amount" += FSE_PTT."A Cost Amount";
                    FSE_LT."A Inventory Value Sales" += FSE_PTT."A Inventory Value Sales";

                    //### Umlagerungen:
                    FSE_LT."T Quantity" += FSE_PTT."T Quantity";
                    FSE_LT."T Cost Amount" += FSE_PTT."T Cost Amount";
                    FSE_LT."T Inventory Value Sales" += FSE_PTT."T Inventory Value Sales";

                    //### Bestände:
                    FSE_LT."I Quantity" += FSE_PTT."I Quantity";
                    FSE_LT."I Cost Amount" += FSE_PTT."I Cost Amount";
                    FSE_LT."I Inventory Value Sales" += FSE_PTT."I Inventory Value Sales";

                    FSE_LT.Modify();
                end else begin
                    //### neue Zeile anlegen:
                    FSE_LT.Init();
                    FSE_LT.TransferFields(FSE_PTT);
                    LastNo_L += 1;
                    FSE_LT."Entry No." := LastNo_L;
                    FSE_LT.Insert(true);
                end;
            until FSE_PTT.Next() = 0;
        end;
    end;

    procedure CalculateRemainingTime()
    var
        EndingTime_L: Decimal;
        Days_L: Integer;
    begin
        if TimeinInteger(Time()) < StartingTime_G then
            RunningTime_G := TimeinInteger(Time()) - StartingTime_G + (24 * 3600)
        else
            RunningTime_G := TimeinInteger(Time()) - StartingTime_G;

        if CounterActual_G <> 0 then begin
            EndingTime_G := StartingTime_G + Round(RunningTime_G * TotalActual_G / CounterActual_G, 1);
            RemainingTime_G := Round(RunningTime_G * TotalActual_G / CounterActual_G, 1) - RunningTime_G;
            EndingTime_L := EndingTime_G;
            Days_L := 0;
            while EndingTime_L > (24 * 3600) do begin
                EndingTime_L := EndingTime_L - (24 * 3600);
                Days_L := Days_L + 1;
            end;
        end;

        if Days_L > 0 then
            Window_G.Update(11, (IntegerTimeinText(EndingTime_L) + ' T' + Format(Days_L)))
        else
            Window_G.Update(11, IntegerTimeinText(EndingTime_L));
        Window_G.Update(12, IntegerTimeinText(RemainingTime_G));
        Window_G.Update(13, IntegerTimeinText(TimeinInteger(Time())));
        Window_G.Update(14, IntegerTimeinText(RunningTime_G));
        Window_G.Update(15, IntegerTimeinText(RunningTime_G + RemainingTime_G));
        if RunningTime_G <> 0 then
            Window_G.Update(16, Round(CounterActual_G / RunningTime_G, 0.1))
        else
            Window_G.Update(16, Round(0, 0.1));
    end;

    procedure TimeinInteger(Time_P: Time) Time_R: BigInteger
    var
        Hour_L: Decimal;
        Minute_L: Decimal;
        Second_L: Decimal;
    begin
        Clear(Hour_L);
        Clear(Minute_L);
        Clear(Second_L);
        if not Evaluate(Hour_L, CopyStr(Format(Time_P), 1, 2)) then
            Hour_L := 0;
        if not Evaluate(Minute_L, CopyStr(Format(Time_P), 4, 2)) then
            Minute_L := 0;
        if not Evaluate(Second_L, CopyStr(Format(Time_P), 7, 2)) then
            Second_L := 0;
        Time_R := (3600 * Hour_L) + (60 * Minute_L) + Second_L;
        exit(Time_R);
    end;

    procedure IntegerTimeinText(Time_P: BigInteger) TimeText_R: Text[8]
    var
        HourText_L: Code[3];
        MinuteText_L: Code[3];
        SecondText_L: Code[3];
        Hour_L: Decimal;
        Minute_L: Decimal;
        RestHour_L: Decimal;
        Second_L: Decimal;
    begin
        Hour_L := Round(Time_P / 3600, 1, '<');
        RestHour_L := Time_P - Hour_L * 3600;
        Minute_L := Round(RestHour_L / 60, 1, '<');
        Second_L := Round(RestHour_L - Minute_L * 60, 1, '<');
        HourText_L := Format(Hour_L);
        while StrLen(HourText_L) < 2 do
            HourText_L := CopyStr('0' + HourText_L, 1, 3);
        MinuteText_L := Format(Minute_L);
        while StrLen(MinuteText_L) < 2 do
            MinuteText_L := CopyStr('0' + MinuteText_L, 1, 3);
        SecondText_L := Format(Second_L);
        while StrLen(SecondText_L) < 2 do
            SecondText_L := CopyStr('0' + SecondText_L, 1, 3);
        //ZeitText := StundeTextLoc + ':' + MinuteTextLoc + ':' + SekundeTextLoc;
        TimeText_R := HourText_L + ':' + MinuteText_L;
        exit(TimeText_R);
    end;

    procedure EnableConfirm(Confirm_P: Boolean)
    begin
        Confirm_G := Confirm_P;
    end;
}

