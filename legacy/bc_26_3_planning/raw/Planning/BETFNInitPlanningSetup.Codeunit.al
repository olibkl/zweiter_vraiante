/// <summary>
/// Codeunit BET FN Init Planning Setup (ID 5079353).
/// </summary>
codeunit 5079353 "BET FN Init Planning Setup"
{
    Access = Public;

    trigger OnRun()
    begin
        InitAll();
    end;

    local procedure InitAll()
    begin
        InitNoSeries();             // Nummernserie Planung
        InitPlanPeriod();           // Planungsperioden
        InitPlanLevels();           // Planungsebenen
        InitPlanSetup();            // Planung Einrichtung
        InitLayouts();              // Layouts
        InitPlanTypes();            // Planungstypen
        InitplanDimAssignment();    // Zuordnungstabelle
    end;

    local procedure InitplanDimAssignment()
    var
        PlanDimAssignment_LT: Record "BET FN Plan. Dim. Assign.";
        PlanDimAssignMgt_LC: Codeunit "BET FN Plan. Dim. Assign. Mgt.";
    begin
        PlanDimAssignment_LT.Reset();
        if not PlanDimAssignment_LT.IsEmpty() then
            exit;

        PlanDimAssignMgt_LC.InitFromItemLedgerEntry(false);
    end;

    local procedure InitPlanTypes()
    var
        PlanningType_LT: Record "BET FN Planning Type";
    begin
        PlanningType_LT.Reset();
        if PlanningType_LT.FindFirst() then
            exit;

        // Umsatzplanung auf Ebene Filiale:
        PlanningType_LT.Init();
        PlanningType_LT.Code := 'UMSATZ';
        PlanningType_LT.Description := 'Umsatzplanung (Land + Filiale)';
        PlanningType_LT."Write Planning Entries" := true;
        PlanningType_LT."Layout Template" := 'UMSATZ';
        PlanningType_LT.Level1 := 'LAND';
        PlanningType_LT.Level2 := 'FILIALE';
        PlanningType_LT."Use Date Level" := true;
        PlanningType_LT."Planning Process Type" := PlanningType_LT."Planning Process Type"::SalesPlan;
        PlanningType_LT."Auto Filter On Level Changing" := true;
        PlanningType_LT.Insert();

        // Limitplanung auf Ebene Marke + HWG (mit Zuordnungstabelle):
        PlanningType_LT.Init();
        PlanningType_LT.Code := 'LIMIT';
        PlanningType_LT.Description := 'Limitplanung (Abteilung + HWG)';
        PlanningType_LT."Write Planning Entries" := true;
        PlanningType_LT."Layout Template" := 'LIMIT';
        PlanningType_LT.Level1 := 'ABTEILUNG';
        PlanningType_LT.Level2 := 'HWG';
        PlanningType_LT."Use Date Level" := true;
        PlanningType_LT."Check Dim. Assign. Table" := true;
        PlanningType_LT."Planning Process Type" := PlanningType_LT."Planning Process Type"::PurchasePlan;
        PlanningType_LT."Auto Filter On Level Changing" := true;
        PlanningType_LT.Insert();

        // Auftragseingangsplanung auf Ebene Vertreter + Kunde:
        PlanningType_LT.Init();
        PlanningType_LT.Code := 'AUFTRAG';
        PlanningType_LT.Description := 'Auftragseingangsplanung (Vertreter + Debitor)';
        PlanningType_LT."Write Planning Entries" := true;
        PlanningType_LT."Layout Template" := 'AUFTRAG';
        PlanningType_LT.Level1 := 'VERTRETER';
        PlanningType_LT.Level2 := 'DEBITOR';
        PlanningType_LT."Use Date Level" := true;
        PlanningType_LT."Planning Process Type" := PlanningType_LT."Planning Process Type"::SalesOrderPlan;
        PlanningType_LT."Auto Filter On Level Changing" := true;
        PlanningType_LT.Insert();
    end;

    local procedure InitLayouts()
    var
        PlanLayoutTemplate_LT: Record "BET FN Planning Layout Tmplt";
    begin
        PlanLayoutTemplate_LT.Reset();
        if PlanLayoutTemplate_LT.FindFirst() then
            exit;

        // UMSATZ:
        PlanLayoutTemplate_LT.Init();
        PlanLayoutTemplate_LT.Code := 'UMSATZ';
        PlanLayoutTemplate_LT."Plan Sales Amount" := true;                  // Plan VK-Umsatz 
        PlanLayoutTemplate_LT."Plan Sal. Am. Difference %" := true;         // Plan VK-Umsatzentwicklung zu VJ
        PlanLayoutTemplate_LT."Plan Sales Percentage" := true;              // Plan VK-Umsatz %-Anteil
        PlanLayoutTemplate_LT."Ref. Sales Amount" := true;                  // VJ VK-Umsatz
        PlanLayoutTemplate_LT."Ref. Sales Percentage" := true;              // VJ VK-Umsatz %-Anteil
        PlanLayoutTemplate_LT.Insert();

        // LIMIT:
        PlanLayoutTemplate_LT.Init();
        PlanLayoutTemplate_LT.Code := 'LIMIT';
        PlanLayoutTemplate_LT."Plan Sales Amount" := true;                  // Plan VK Umsatz  
        PlanLayoutTemplate_LT."Plan Sal. Am. Difference %" := true;         // Plan VK Umsatzentwicklung zu VJ
        // PlanLayoutTemplate_LT."Plan Sales Percentage" := true;              // Plan VK-Umsatz %-Anteil
        PlanLayoutTemplate_LT."Plan Sales Init. Inv." := true;              // Plan VK Anfangsbestand
        PlanLayoutTemplate_LT."Plan Sales Closing Inv." := true;            // Plan VK Endbestand
        PlanLayoutTemplate_LT."Plan Gross Sales Pr. Red. %" := true;        // Plan Abschrift %
        PlanLayoutTemplate_LT."Plan Gross Sales Pr. Reduction" := true;     // Plan Abschrift
        PlanLayoutTemplate_LT."Plan Sales Am. Purchase" := true;            // Plan VK Limit
        PlanLayoutTemplate_LT."Plan Cost Am. Purchase" := true;             // Plan EK Limit
        // PlanLayoutTemplate_LT."Plan Cost Am. Purch. 1-5" := true;           // Plan EK Limit Orderarten
        PlanLayoutTemplate_LT."Plan Calc. Sales %" := true;                 // Plan Spanne Umsatz (erz. Spanne)
        PlanLayoutTemplate_LT."Plan Calc. Purchase %" := true;              // Plan Spannne Limit (WE-Spanne)
        PlanLayoutTemplate_LT."Ref. Sales Amount" := true;                  // VJ VK Umsatz
        PlanLayoutTemplate_LT."Ref. Calc. Purchase %" := true;              // VJ Spanne Limit (WE-Spanne)
        PlanLayoutTemplate_LT.Insert();

        // MENGE:
        PlanLayoutTemplate_LT.Init();
        PlanLayoutTemplate_LT.Code := 'MENGE';
        PlanLayoutTemplate_LT."Plan Qty. Sale" := true;                     // Plan Menge Umsatz
        PlanLayoutTemplate_LT."Plan Qty. Sale Diff. %" := true;             // Plan Menge Umsatzentwicklung zu VJ %
        PlanLayoutTemplate_LT."Plan Qty. Init. Inv." := true;               // Plan Menge Anfangsbestand
        PlanLayoutTemplate_LT."Plan Qty. Closing Inv." := true;             // Plan Menge Endbestand
        // PlanLayoutTemplate_LT."Plan Qty. Closing Inv. %" := true;           // Plan Menge Endbestand % vom Umsatz (=AVQ)
        PlanLayoutTemplate_LT."Plan Qty. Purchase" := true;                 // Plan Menge Einkauf
        PlanLayoutTemplate_LT."Ref. Qty. Sale" := true;                     // VJ Menge Umsatz
        PlanLayoutTemplate_LT."Ref. Qty. Purchase" := true;                 // VJ Menge Einkauf
        PlanLayoutTemplate_LT.Insert();

        // AUFTRAG:
        PlanLayoutTemplate_LT.Init();
        PlanLayoutTemplate_LT.Code := 'AUFTRAG';
        PlanLayoutTemplate_LT."Plan Sales Order Amount" := true;            // Plan VK Auftragseingang
        PlanLayoutTemplate_LT."Ref. Sales Order Amount" := true;            // VJ VK Auftragseingang
        PlanLayoutTemplate_LT.Insert();
    end;

    local procedure InitPlanSetup()
    var
        PlanEntry_LT: Record "BET FN Planning Entry (DWH)";
        PlanningSetup_LT: Record "BET FN Planning Setup";
    begin
        if PlanningSetup_LT.Get() then
            exit;

        PlanningSetup_LT.Init();
        PlanningSetup_LT."No. of Records for Warning" := 5000;
        PlanningSetup_LT."No. Series" := 'PLANUNG';
        PlanningSetup_LT."Auto Filter On Level Changing" := true;
        PlanningSetup_LT."Create Statistic Entries" := true;
        PlanningSetup_LT."Dimension Assignment 1" := 'MARKE';
        PlanningSetup_LT."Dimension Assignment 2" := 'HWG';
        PlanningSetup_LT."Export Table No." := Database::"BET FN Planning Entry (DWH)";
        PlanningSetup_LT."Date Field in Export Table" := PlanEntry_LT.FieldNo("Posting Date");
        PlanningSetup_LT."PK Field in Export Table" := PlanEntry_LT.FieldNo("Entry No.");
        PlanningSetup_LT."Doc. No. Field in Export Table" := PlanEntry_LT.FieldNo("Planning Document No.");
        PlanningSetup_LT."Season Field in Export Table" := PlanEntry_LT.FieldNo(Season);
        PlanningSetup_LT.Insert();
    end;

    local procedure InitNoSeries()
    var
        NoSeries_LT: Record "No. Series";
        NoSeriesLine_LT: Record "No. Series Line";
    begin
        if NoSeries_LT.Get('PLANUNG') then
            exit;

        NoSeries_LT.Init();
        NoSeries_LT.Code := 'PLANUNG';
        NoSeries_LT."Default Nos." := true;
        NoSeries_LT.Insert();

        NoSeriesLine_LT.Init();
        NoSeriesLine_LT."Series Code" := NoSeries_LT.Code;
        NoSeriesLine_LT."Line No." := 1;
        NoSeriesLine_LT."Starting Date" := 20200101D;
        NoSeriesLine_LT.Insert();

        NoSeriesLine_LT.Init();
        NoSeriesLine_LT."Series Code" := NoSeries_LT.Code;
        NoSeriesLine_LT."Line No." := 10000;
        NoSeriesLine_LT."Starting Date" := CalcDate('<-CY>', WorkDate());
        NoSeriesLine_LT."Starting No." := 'PL00001';
        NoSeriesLine_LT.Insert();
    end;

    local procedure InitPlanPeriod()
    var
        PlanningPeriod_LT: Record "BET FN Financial Year";
        LastYear_L: Code[10];
        StartYear_L, Year_L : Integer;
    begin
        PlanningPeriod_LT.Reset();
        if PlanningPeriod_LT.FindFirst() then
            exit;

        StartYear_L := Date2DMY(WorkDate(), 3) - 3;   // Beginn: 3 Jahre zurück für Vgl.-Zahlen etc.
        LastYear_L := '';
        for Year_L := StartYear_L to (StartYear_L + 10) do begin
            PlanningPeriod_LT.Init();
            PlanningPeriod_LT.Code := Format(Year_L);
            PlanningPeriod_LT.Description := 'Planjahr ' + Format(Year_L);
            PlanningPeriod_LT."Start Date" := DMY2Date(1, 1, Year_L);
            PlanningPeriod_LT."End Date" := DMY2Date(31, 12, Year_L);
            PlanningPeriod_LT."Reference Period" := LastYear_L;
            LastYear_L := Format(Year_L);
            PlanningPeriod_LT.Insert();
        end;
    end;

    local procedure InitPlanLevels()
    var
        Agent_LT: Record "BET FN Agent";
        Brand_LT: Record "BET FN Brand";
        Division_LT: Record "BET FN Division";
        FashStatEntry_LT: Record "BET FN Fashion Statistic Entry";
        LocationGroup_LT: Record "BET FN Location Group";
        MainWaregroup_LT: Record "BET FN Main Waregroup";
        PlanningEntry_LT: Record "BET FN Planning Entry (DWH)";
        PlanningLevel_LT: Record "BET FN Planning Level";
        PlanningStatistic_LT: Record "BET FN Planning Statistic";
        CountryRegion_LT: Record "Country/Region";
        Customer_LT: Record Customer;
        ItemCategory_LT: Record "Item Category";
        Location_LT: Record Location;
        Vendor_LT: Record Vendor;
    begin
        PlanningLevel_LT.Reset();
        if PlanningLevel_LT.FindFirst() then
            exit;

        // Abteilung:
        PlanningLevel_LT.Init();
        PlanningLevel_LT."Index Code" := 'ABTEILUNG';
        PlanningLevel_LT."Index Description" := 'Abteilung';
        PlanningLevel_LT."Index Table No." := Database::"BET FN Division";
        PlanningLevel_LT."Primary Key Field No." := Division_LT.FieldNo(Code);
        PlanningLevel_LT."Description Field No." := Division_LT.FieldNo(Description);
        PlanningLevel_LT."Planning Statistic Field" := PlanningStatistic_LT.FieldNo(DivisFilter);
        PlanningLevel_LT."Export Field No." := PlanningEntry_LT.FieldNo(Division);
        PlanningLevel_LT."Fash. Stat. Entry Field" := FashStatEntry_LT.FieldNo(Division);
        PlanningLevel_LT.Activated := true;
        PlanningLevel_LT."Description in Document" := PlanningLevel_LT."Description in Document"::Both;
        PlanningLevel_LT.Insert();

        // Hauptwarengruppe:
        PlanningLevel_LT.Init();
        PlanningLevel_LT."Index Code" := 'HWG';
        PlanningLevel_LT."Index Description" := 'Hauptwarengruppe';
        PlanningLevel_LT."Index Table No." := Database::"BET FN Main Waregroup";
        PlanningLevel_LT."Primary Key Field No." := MainWaregroup_LT.FieldNo(Code);
        PlanningLevel_LT."Description Field No." := MainWaregroup_LT.FieldNo(Description);
        PlanningLevel_LT."Planning Statistic Field" := PlanningStatistic_LT.FieldNo(MainWGFilter);
        PlanningLevel_LT."Export Field No." := PlanningEntry_LT.FieldNo("Main Waregroup");
        PlanningLevel_LT."Fash. Stat. Entry Field" := FashStatEntry_LT.FieldNo("Main Waregroup");
        PlanningLevel_LT.Activated := true;
        PlanningLevel_LT."Description in Document" := PlanningLevel_LT."Description in Document"::Both;
        // Zuordnung Abteilung:
        PlanningLevel_LT."Assigned to Index" := 'ABTEILUNG';
        PlanningLevel_LT."Assigned to Index Field No." := MainWaregroup_LT.FieldNo(Division);
        PlanningLevel_LT.Insert();

        // Warengruppe:
        PlanningLevel_LT.Init();
        PlanningLevel_LT."Index Code" := 'WG';
        PlanningLevel_LT."Index Description" := 'Warengruppe';
        PlanningLevel_LT."Index Table No." := Database::"Item Category";
        PlanningLevel_LT."Primary Key Field No." := ItemCategory_LT.FieldNo(Code);
        PlanningLevel_LT."Description Field No." := ItemCategory_LT.FieldNo(Description);
        PlanningLevel_LT."Planning Statistic Field" := PlanningStatistic_LT.FieldNo(ItemCatFilter);
        PlanningLevel_LT."Export Field No." := PlanningEntry_LT.FieldNo("Item Category");
        PlanningLevel_LT."Fash. Stat. Entry Field" := FashStatEntry_LT.FieldNo("Item Category Code");
        PlanningLevel_LT.Activated := true;
        PlanningLevel_LT."Description in Document" := PlanningLevel_LT."Description in Document"::Both;
        // Zuordnung HWG:
        PlanningLevel_LT."Assigned to Index" := 'HWG';
        PlanningLevel_LT."Assigned to Index Field No." := ItemCategory_LT.FieldNo("BET FN Main Waregroup");
        PlanningLevel_LT.Insert();

        // Filiale:
        PlanningLevel_LT.Init();
        PlanningLevel_LT."Index Code" := 'FILIALE';
        PlanningLevel_LT."Index Description" := 'Filiale';
        PlanningLevel_LT."Index Table No." := Database::Location;
        PlanningLevel_LT."Primary Key Field No." := Location_LT.FieldNo(Code);
        PlanningLevel_LT."Description Field No." := Location_LT.FieldNo(Name);
        PlanningLevel_LT."Planning Statistic Field" := PlanningStatistic_LT.FieldNo(LocFilter);
        PlanningLevel_LT."Export Field No." := PlanningEntry_LT.FieldNo("Location Code");
        PlanningLevel_LT."Fash. Stat. Entry Field" := FashStatEntry_LT.FieldNo("Location Code");
        PlanningLevel_LT.Activated := true;
        PlanningLevel_LT."Description in Document" := PlanningLevel_LT."Description in Document"::Both;
        // Zuordnung LAND:
        PlanningLevel_LT."Assigned to Index" := 'LAND';
        PlanningLevel_LT."Assigned to Index Field No." := Location_LT.FieldNo("Country/Region Code");
        PlanningLevel_LT.Insert();

        // Filialgruppe:
        PlanningLevel_LT.Init();
        PlanningLevel_LT."Index Code" := 'FILGRP';
        PlanningLevel_LT."Index Description" := 'Filialgruppe';
        PlanningLevel_LT."Index Table No." := Database::"BET FN Location Group";
        PlanningLevel_LT."Primary Key Field No." := LocationGroup_LT.FieldNo(Code);
        PlanningLevel_LT."Description Field No." := LocationGroup_LT.FieldNo(Description);
        PlanningLevel_LT."Planning Statistic Field" := PlanningStatistic_LT.FieldNo(LocationGroupFilter);
        PlanningLevel_LT."Export Field No." := PlanningEntry_LT.FieldNo("Location Group");
        PlanningLevel_LT."Fash. Stat. Entry Field" := FashStatEntry_LT.FieldNo("Location Group");
        PlanningLevel_LT.Activated := true;
        PlanningLevel_LT."Description in Document" := PlanningLevel_LT."Description in Document"::Code;
        PlanningLevel_LT.Insert();

        // Vertreter:
        PlanningLevel_LT.Init();
        PlanningLevel_LT."Index Code" := 'VERTRETER';
        PlanningLevel_LT."Index Description" := 'Vertreter';
        PlanningLevel_LT."Index Table No." := Database::"BET FN Agent";
        PlanningLevel_LT."Primary Key Field No." := Agent_LT.FieldNo(Code);
        PlanningLevel_LT."Description Field No." := Agent_LT.FieldNo(Description);
        PlanningLevel_LT."Planning Statistic Field" := PlanningStatistic_LT.FieldNo(AgentFilter);
        PlanningLevel_LT."Export Field No." := PlanningEntry_LT.FieldNo(Agent);
        PlanningLevel_LT."Fash. Stat. Entry Field" := FashStatEntry_LT.FieldNo(Agent);
        PlanningLevel_LT.Activated := true;
        PlanningLevel_LT."Description in Document" := PlanningLevel_LT."Description in Document"::Both;
        PlanningLevel_LT.Insert();

        // Debitor:
        PlanningLevel_LT.Init();
        PlanningLevel_LT."Index Code" := 'DEBITOR';
        PlanningLevel_LT."Index Description" := 'Debitor';
        PlanningLevel_LT."Index Table No." := Database::Customer;
        PlanningLevel_LT."Primary Key Field No." := Customer_LT.FieldNo("No.");
        PlanningLevel_LT."Description Field No." := Customer_LT.FieldNo(Name);
        PlanningLevel_LT."Planning Statistic Field" := PlanningStatistic_LT.FieldNo(CustomerFilter);
        PlanningLevel_LT."Export Field No." := PlanningEntry_LT.FieldNo("Customer No.");
        PlanningLevel_LT."Fash. Stat. Entry Field" := FashStatEntry_LT.FieldNo(Customer);
        PlanningLevel_LT.Activated := true;
        PlanningLevel_LT."Description in Document" := PlanningLevel_LT."Description in Document"::Both;
        // Zuordnung Vertreter:
        PlanningLevel_LT."Assigned to Index" := 'VERTRETER';
        PlanningLevel_LT."Assigned to Index Field No." := Customer_LT.FieldNo("BET FN Agent No");
        PlanningLevel_LT.Insert();

        // Land:
        PlanningLevel_LT.Init();
        PlanningLevel_LT."Index Code" := 'LAND';
        PlanningLevel_LT."Index Description" := 'Land/Region';
        PlanningLevel_LT."Index Table No." := Database::"Country/Region";
        PlanningLevel_LT."Primary Key Field No." := CountryRegion_LT.FieldNo(Code);
        PlanningLevel_LT."Description Field No." := CountryRegion_LT.FieldNo(Name);
        PlanningLevel_LT."Planning Statistic Field" := PlanningStatistic_LT.FieldNo(CountryFilter);
        PlanningLevel_LT."Export Field No." := PlanningEntry_LT.FieldNo("Country Code");
        PlanningLevel_LT."Fash. Stat. Entry Field" := FashStatEntry_LT.FieldNo("Country Code");
        PlanningLevel_LT.Activated := true;
        PlanningLevel_LT."Description in Document" := PlanningLevel_LT."Description in Document"::Code;
        PlanningLevel_LT.Insert();

        // Kreditor:
        PlanningLevel_LT.Init();
        PlanningLevel_LT."Index Code" := 'KREDITOR';
        PlanningLevel_LT."Index Description" := 'Kreditor';
        PlanningLevel_LT."Index Table No." := Database::Vendor;
        PlanningLevel_LT."Primary Key Field No." := Vendor_LT.FieldNo("No.");
        PlanningLevel_LT."Description Field No." := Vendor_LT.FieldNo(Name);
        PlanningLevel_LT."Planning Statistic Field" := PlanningStatistic_LT.FieldNo(VendorFilter);
        PlanningLevel_LT."Export Field No." := PlanningEntry_LT.FieldNo("Vendor No.");
        PlanningLevel_LT."Fash. Stat. Entry Field" := FashStatEntry_LT.FieldNo("Vendor No.");
        PlanningLevel_LT.Activated := true;
        PlanningLevel_LT."Description in Document" := PlanningLevel_LT."Description in Document"::Both;
        PlanningLevel_LT.Insert();

        // Marke:
        PlanningLevel_LT.Init();
        PlanningLevel_LT."Index Code" := 'MARKE';
        PlanningLevel_LT."Index Description" := 'Marke';
        PlanningLevel_LT."Index Table No." := Database::"BET FN Brand";
        PlanningLevel_LT."Primary Key Field No." := Brand_LT.FieldNo(Code);
        PlanningLevel_LT."Description Field No." := Brand_LT.FieldNo(Description);
        PlanningLevel_LT."Planning Statistic Field" := PlanningStatistic_LT.FieldNo(BrandFilter);
        PlanningLevel_LT."Export Field No." := PlanningEntry_LT.FieldNo(Brand);
        PlanningLevel_LT."Fash. Stat. Entry Field" := FashStatEntry_LT.FieldNo(Brand);
        PlanningLevel_LT.Activated := true;
        PlanningLevel_LT."Description in Document" := PlanningLevel_LT."Description in Document"::Description;
        PlanningLevel_LT.Insert();
    end;
}