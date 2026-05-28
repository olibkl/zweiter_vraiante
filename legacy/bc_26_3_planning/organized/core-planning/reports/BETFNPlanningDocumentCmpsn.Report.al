/// <summary>
/// [planning]
/// Modules: 
/// </summary>
report 5138632 "BET FN Planning Document Cmpsn"
{
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = 'layout/PlanningDocumentComparison.rdlc';
    Caption = 'Planning Document Comparison';
    Extensible = true;

    dataset
    {
        dataitem("Planning View"; "BET FN Planning View")
        {
            DataItemTableView = sorting("View Entry No.");
            column(PlanDocNo1; PlanDocNo1_G)
            {
            }
            column(PlanDocNo2; PlanDocNo2_G)
            {
            }
            column(Planning_View__GETFILTERS; "Planning View".GetFilters())
            {
            }
            column(CREATEDATETIME_TODAY_TIME_; CreateDateTime(Today(), Time()))
            {
            }
            column(IndexLabels_1_; IndexLabels[1])
            {
            }
            column(IndexLabels_2_; IndexLabels[2])
            {
            }
            column(IndexLabels_3_; IndexLabels[3])
            {
            }
            column(IndexLabels_4_; IndexLabels[4])
            {
            }
            column(IndexLabels_5_; IndexLabels[5])
            {
            }
            column(IndexLabels_6_; IndexLabels[6])
            {
            }
            column(Planning_View__Planning_View___Index_1_; "Planning View"."Index 1")
            {
            }
            column(Planning_View__Planning_View___Index_2_; "Planning View"."Index 2")
            {
            }
            column(Planning_View__Planning_View___Index_3_; "Planning View"."Index 3")
            {
            }
            column(Planning_View__Planning_View___Index_4_; "Planning View"."Index 4")
            {
            }
            column(Planning_View__Planning_View___Index_5_; "Planning View"."Index 5")
            {
            }
            column(Planning_View__Planning_View___Index_6_; "Planning View"."Index 6")
            {
            }
            column(Planning_View__Planning_View__Date; "Planning View".Date)
            {
            }
            column(UmsatzEKVorgabe; UmsatzEKVorgabe_G)
            {
                DecimalPlaces = 0 : 0;
            }
            column(UmsatzEKPlan; UmsatzEKPlan_G)
            {
                DecimalPlaces = 0 : 0;
            }
            column(UmsatzEKAbweichung; UmsatzEKAbweichung_G)
            {
            }
            column(LimitEKVorgabe; LimitEKVorgabe_G)
            {
                DecimalPlaces = 0 : 0;
            }
            column(LimitEKPlan; LimitEKPlan_G)
            {
                DecimalPlaces = 0 : 0;
            }
            column(LimitEKAbweichung; LimitEKAbweichung_G)
            {
            }
            column(Target_Document_Caption; Target_Document_CaptionLbl)
            {
            }
            column(Planning_Doc__Comparison_ListCaption; Planning_Doc__Comparison_ListCaptionLbl)
            {
            }
            column(Comparison_DocumentCaption; Comparison_DocumentCaptionLbl)
            {
            }
            column(FilterCaption; FilterCaptionLbl)
            {
            }
            column(DateCaption; DateCaptionLbl)
            {
            }
            column(Sales_Cost_TargetCaption; Sales_Cost_TargetCaptionLbl)
            {
            }
            column(Sales_Cost_PlanCaption; Sales_Cost_PlanCaptionLbl)
            {
            }
            column(Sales_Cost_Diff___Caption; Sales_Cost_Diff___CaptionLbl)
            {
            }
            column(Limit_Purch__TargetCaption; Limit_Purch__TargetCaptionLbl)
            {
            }
            column(Limit_Purch__PlanCaption; Limit_Purch__PlanCaptionLbl)
            {
            }
            column(Lkmit_Purch__Diff___Caption; Lkmit_Purch__Diff___CaptionLbl)
            {
            }
            column(Planning_View_View_Entry_No_; "View Entry No.")
            {
            }

            trigger OnAfterGetRecord()
            var
                PlanView_LT: Record "BET FN Planning View";
            begin
                UmsatzEKVorgabe_G := "Planning View"."Plan Cost of Sales";
                LimitEKVorgabe_G := "Planning View"."Plan Cost Am. Purchase";

                PlanView_LT.Reset();
                PlanView_LT.SetRange("Planning Document No.", PlanDocNo2_G);
                PlanView_LT.SetRange("Index 1", "Planning View"."Index 1");
                PlanView_LT.SetRange("Index 2", "Planning View"."Index 2");
                PlanView_LT.SetRange("Index 3", "Planning View"."Index 3");
                PlanView_LT.SetRange("Index 4", "Planning View"."Index 4");
                PlanView_LT.SetRange("Index 5", "Planning View"."Index 5");
                PlanView_LT.SetRange("Index 6", "Planning View"."Index 6");
                PlanView_LT.SetRange(Date, "Planning View".Date);

                if PlanView_LT.FindFirst() then begin
                    UmsatzEKPlan_G := PlanView_LT."Plan Cost of Sales";
                    if (UmsatzEKVorgabe_G <> 0) then
                        UmsatzEKAbweichung_G := (UmsatzEKPlan_G - UmsatzEKVorgabe_G) / UmsatzEKVorgabe_G * 100
                    else
                        UmsatzEKAbweichung_G := 0;

                    LimitEKPlan_G := PlanView_LT."Plan Cost Am. Purchase";
                    if (LimitEKVorgabe_G <> 0) then
                        LimitEKAbweichung_G := (LimitEKPlan_G - LimitEKVorgabe_G) / LimitEKVorgabe_G * 100
                    else
                        LimitEKAbweichung_G := 0;

                end else
                    CurrReport.Skip();
            end;

            trigger OnPreDataItem()
            var
                PlanDocLevel_LT: Record "BET FN Planning Document Level";
                RR: RecordRef;
                FR: FieldRef;
                i: Integer;
                FilterText: Text[100];
            begin
                PlanDocLevel_LT.Reset();
                PlanDocLevel_LT.SetRange("Planning Document No.", PlanDocNo1_G);
                PlanDocLevel_LT.SetRange("Index Code", PlanDocLevelCode_G);
                if PlanDocLevel_LT.FindFirst() then begin

                    "Planning View".SetRange("Planning Document No.", PlanDocLevel_LT."Planning Document No.");
                    "Planning View".SetRange("Planning Document Level", PlanDocLevel_LT."Planning Document Level Index");
                    if UseDate_G then
                        "Planning View".SetFilter(Date, '<>%1', 0D)
                    else
                        "Planning View".SetRange(Date, 0D);

                    IndexLabels[1] := PlanDocLevel_LT."Index Description 1";
                    IndexLabels[2] := PlanDocLevel_LT."Index Description 2";
                    IndexLabels[3] := PlanDocLevel_LT."Index Description 3";
                    IndexLabels[4] := PlanDocLevel_LT."Index Description 4";
                    IndexLabels[5] := PlanDocLevel_LT."Index Description 5";
                    IndexLabels[6] := PlanDocLevel_LT."Index Description 6";

                    RR.GetTable(PlanDocLevel_LT);
                    for i := 1 to 10 do begin
                        FR := RR.Field(1002 + (i * 10));     // ### Tabellennummern statt Code verwenden
                        if Format(FR.Value()) <> '0' then begin
                            case Format(FR.Value()) of
                                '9':
                                    ;   // Land
                                '13':
                                    ;   // Vertreter (Salesperson/Purchaser)
                                '14':
                                    FilterText := LocFilter_G;   // Filiale
                                '18':
                                    ;   // Debitor/Kunde
                                '23':
                                    FilterText := VendorFilter_G;   // Kreditor/Lieferant
                                '27':
                                    ;   // Artikel
                                '5722':
                                    FilterText := ItemCatFilter_G;   // Warengruppe = Lager
                                '55200':
                                    ;   // Material
                                '55201':
                                    ;   // Qualität
                                '55214':
                                    ;   // Thema
                                '5079207':
                                    ;   // Größe
                                '5079215':
                                    ;   // Farbe
                                '5079224':
                                    FilterText := DivisFilter_G;   // Abteilung = Lagerhauptgruppe
                                '5079226':
                                    ;   // Marke
                                '5079230':
                                    FilterText := SeasonFilter_G;   // Saison
                                '5079241':
                                    ;   // Preislage
                                '5079281':
                                    FilterText := MainWGFilter_G;   // Hauptwarengruppe
                            end;

                            case i of
                                1:
                                    "Planning View".SetFilter("Index 1", FilterText);
                                2:
                                    "Planning View".SetFilter("Index 2", FilterText);
                                3:
                                    "Planning View".SetFilter("Index 3", FilterText);
                                4:
                                    "Planning View".SetFilter("Index 4", FilterText);
                                5:
                                    "Planning View".SetFilter("Index 5", FilterText);
                                6:
                                    "Planning View".SetFilter("Index 6", FilterText);
                            end;
                        end;
                    end; // for
                end else
                    CurrReport.Quit();
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(PlanDocNo1; PlanDocNo1_G)
                    {
                        ApplicationArea = All;
                        Caption = 'Target Document:';
                        ToolTip = 'Specifies the Target Document.';

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            PlanDoc_LT: Record "BET FN Planning Document";
                        begin
                            PlanDoc_LT.Reset();
                            if Page.RunModal(Page::"BET FN Planning Documents", PlanDoc_LT) = Action::LookupOK then
                                PlanDocNo1_G := PlanDoc_LT."No.";
                        end;
                    }
                    field(PlanDocNo2; PlanDocNo2_G)
                    {
                        ApplicationArea = All;
                        ShowCaption = false;

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            PlanDoc_LT: Record "BET FN Planning Document";
                            FirstDocumentInvalidErr: Label '1. Document is invalid.';
                        begin
                            if not PlanDoc_LT.Get(PlanDocNo1_G) then
                                Error(FirstDocumentInvalidErr);

                            PlanDoc_LT.Reset();
                            if Page.RunModal(Page::"BET FN Planning Documents", PlanDoc_LT) = Action::LookupOK then
                                PlanDocNo2_G := PlanDoc_LT."No.";
                        end;
                    }
                    field(PlanDocLevelCode; PlanDocLevelCode_G)
                    {
                        ApplicationArea = All;
                        ShowCaption = false;

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            PlanDoc_LT: Record "BET FN Planning Document";
                            PlanDocLevel_LT: Record "BET FN Planning Document Level";
                            PlanDocNo: Code[20];
                            FirstDocumentInvalidErr: Label '1. Document is invalid.';
                            SecondDocumentInvalidErr: Label '2. Document is invalid.';
                        begin
                            if not PlanDoc_LT.Get(PlanDocNo1_G) then
                                Error(FirstDocumentInvalidErr);
                            if not PlanDoc_LT.Get(PlanDocNo2_G) then
                                Error(SecondDocumentInvalidErr);

                            PlanDocNo := CheckLevelParity(PlanDocNo1_G, PlanDocNo2_G);
                            if (PlanDocNo <> '') then begin
                                // ### öffne Übersicht der Ebenen mit dem Beleg, der die geringere Anzahl an Ebenen hat:
                                PlanDocLevel_LT.Reset();
                                PlanDocLevel_LT.SetRange("Planning Document No.", PlanDocNo);
                                if Page.RunModal(Page::"BET FN Planning Document Lvls", PlanDocLevel_LT) = Action::LookupOK then begin
                                    PlanDocLevelCode_G := CopyStr(PlanDocLevel_LT."Index Code", 1, MaxStrLen(PlanDocLevelCode_G));
                                    DateControlEnable := PlanDocLevel_LT."Activate Date Level";
                                end;
                            end;
                        end;
                    }
                    field(DateControl; UseDate_G)
                    {
                        ApplicationArea = All;
                        Caption = 'Use Date Level';
                        Enabled = DateControlEnable;
                        ToolTip = 'Specifies whether to use Date Level.';
                    }
                    field(DateFilter; DateFilter_G)
                    {
                        ApplicationArea = All;
                        Caption = 'Date';
                        ToolTip = 'Specifies the Date.';
                    }
                    field(LocFilter; LocFilter_G)
                    {
                        ApplicationArea = All;
                        ShowCaption = false;
                        TableRelation = Location;
                    }
                    field(DivisFilter; DivisFilter_G)
                    {
                        ApplicationArea = All;
                        Caption = 'Division';
                        TableRelation = "BET FN Division";
                        ToolTip = 'Specifies the Division.';
                    }
                    field(MainWGFilter; MainWGFilter_G)
                    {
                        ApplicationArea = All;
                        ShowCaption = false;
                        TableRelation = "BET FN Main Waregroup";
                    }
                    field(ItemCatFilter; ItemCatFilter_G)
                    {
                        ApplicationArea = All;
                        Caption = 'Item Category';
                        TableRelation = "Item Category";
                        ToolTip = 'Specifies the Item Category.';
                    }
                    field(VendorFilter; VendorFilter_G)
                    {
                        ApplicationArea = All;
                        ShowCaption = false;
                        TableRelation = Vendor;
                    }
                    field(SeasonFilter; SeasonFilter_G)
                    {
                        ApplicationArea = All;
                        ShowCaption = false;
                        TableRelation = "BET FN Season";
                    }
                    label(Control1117300025)
                    {
                        ApplicationArea = All;
                        Caption = 'Season Code';
                    }
                    label(Control1117300022)
                    {
                        ApplicationArea = All;
                        Caption = 'Vendor';
                    }
                    label(Control1117300018)
                    {
                        ApplicationArea = All;
                        Caption = 'Main Waregroup';
                    }
                    label(Control1117300014)
                    {
                        ApplicationArea = All;
                        Caption = 'Location Code';
                    }
                    label(Control1117300004)
                    {
                        ApplicationArea = All;
                        Caption = 'Level';
                    }
                    label(Control1117300002)
                    {
                        ApplicationArea = All;
                        Caption = 'Comparison Document';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            DateControlEnable := true;
        end;
    }

    labels
    {
    }

    var
        DateControlEnable: Boolean;
        UseDate_G: Boolean;
        PlanDocLevelCode_G: Code[10];
        PlanDocNo1_G: Code[20];
        PlanDocNo2_G: Code[20];
        LimitEKAbweichung_G: Decimal;
        LimitEKPlan_G: Decimal;
        LimitEKVorgabe_G: Decimal;
        UmsatzEKAbweichung_G: Decimal;
        UmsatzEKPlan_G: Decimal;
        UmsatzEKVorgabe_G: Decimal;
        Comparison_DocumentCaptionLbl: Label 'Comparison Document';
        DateCaptionLbl: Label 'Date';
        FilterCaptionLbl: Label 'Filter';
        IntersectionNotFoundErr: Label 'Intersection in %1 found.', Comment = '%1';
        Limit_Purch__PlanCaptionLbl: Label 'Limit Purch. Plan';
        Limit_Purch__TargetCaptionLbl: Label 'Limit Purch. Target';
        Lkmit_Purch__Diff___CaptionLbl: Label 'Lkmit Purch. Diff. %';
        Planning_Doc__Comparison_ListCaptionLbl: Label 'Planning Doc. Comparison List';
        Sales_Cost_Diff___CaptionLbl: Label 'Sales Cost Diff. %';
        Sales_Cost_PlanCaptionLbl: Label 'Sales Cost Plan';
        Sales_Cost_TargetCaptionLbl: Label 'Sales Cost Target';
        Target_Document_CaptionLbl: Label 'Target Document:';
        IndexLabels: array[10] of Text[30];
        DateFilter_G: Text[100];
        DivisFilter_G: Text[100];
        ItemCatFilter_G: Text[100];
        LocFilter_G: Text[100];
        MainWGFilter_G: Text[100];
        SeasonFilter_G: Text[100];
        VendorFilter_G: Text[100];

    /// <summary>
    /// CheckLevelParity.
    /// </summary>
    /// <param name="PlanDocNo1_P">Code[20].</param>
    /// <param name="PlanDocNo2_P">Code[20].</param>
    /// <returns>Return value of type Code[20].</returns>
    procedure CheckLevelParity(PlanDocNo1_P: Code[20]; PlanDocNo2_P: Code[20]): Code[20]
    var
        DestLevelBuffer_LT: Record "BET FN Planning Doc Lvl Buf";
        SrcLevelBuffer_LT: Record "BET FN Planning Doc Lvl Buf";
        PlanDoc1_LT: Record "BET FN Planning Document";
        PlanDoc2_LT: Record "BET FN Planning Document";
        DestPlanDocLevel_LT: Record "BET FN Planning Document Level";
        SrcPlanDocLevel_LT: Record "BET FN Planning Document Level";
        stop: Boolean;
        buffer_counter: Integer;
        level_vert: Integer;
        DocumentsDoNotHaveComparableDataErr: Label 'Documents do not have comparable data on chosen level.';
        DocumentsHaveDifferentDateAreasErr: Label 'Document %1 and %2 have different date areas.', Comment = '%1 %2';
        FirstDocumentNoInvalidErr: Label '1. Document No. invalid.';
        SecondDocumentNoInvalidErr: Label '2. Document No. invalid.';
    begin
        if not PlanDoc1_LT.Get(PlanDocNo1_P) then
            Error(FirstDocumentNoInvalidErr);
        if not PlanDoc2_LT.Get(PlanDocNo2_P) then
            Error(SecondDocumentNoInvalidErr);

        // ### Datumsbereich beider Belege prüfen (muß identisch sein)
        if (PlanDoc1_LT."Start Date" <> PlanDoc2_LT."Start Date") or
           (PlanDoc1_LT."End Date" <> PlanDoc2_LT."End Date") then
            Error(DocumentsHaveDifferentDateAreasErr, PlanDoc1_LT."No.", PlanDoc2_LT."No.");

        SrcPlanDocLevel_LT.Reset();
        SrcPlanDocLevel_LT.SetRange("Planning Document No.", PlanDoc1_LT."No.");
        level_vert := 0;
        stop := false;

        DestPlanDocLevel_LT.Reset();
        DestPlanDocLevel_LT.SetRange("Planning Document No.", PlanDoc2_LT."No.");

        repeat
            level_vert += 1;

            // ### Abbruch bei Verzweigung (Quellbeleg)
            SrcPlanDocLevel_LT.SetRange("Planning Document Level Index", level_vert);
            if SrcPlanDocLevel_LT.Count() > 1 then
                Error(IntersectionNotFoundErr, PlanDoc1_LT."No.");

            // ### Abbruch bei Verzweigung (Zielbeleg)
            DestPlanDocLevel_LT.SetRange("Planning Document Level Index", level_vert);
            if DestPlanDocLevel_LT.Count() > 1 then
                Error(IntersectionNotFoundErr, PlanDoc2_LT."No.");

            // ### Repeatschleife abbrechen, wenn das Pfadende bei einem der Belege erreicht ist:
            if (SrcPlanDocLevel_LT.Count() = 0) or
               (DestPlanDocLevel_LT.Count() = 0) then
                stop := true;

            // ### jetzt prüfen, ob Quell und Zielebene identisch sind:
            if SrcPlanDocLevel_LT.FindFirst() and
               DestPlanDocLevel_LT.FindFirst() and
               (SrcPlanDocLevel_LT."Index Code" = DestPlanDocLevel_LT."Index Code") then begin

                buffer_counter := 0;

                // ### mind. 1 Datensatz der Zielebene muß in der Quellebene vorhanden sein:
                // ###  --> Puffertabellen vergleichen!
                DestLevelBuffer_LT.Reset();
                DestLevelBuffer_LT.SetRange("Planning Document No.", DestPlanDocLevel_LT."Planning Document No.");
                DestLevelBuffer_LT.SetRange("Planning Document Level", DestPlanDocLevel_LT."Planning Document Level Index");
                DestLevelBuffer_LT.SetRange(Active, true);
                SrcLevelBuffer_LT.Reset();
                SrcLevelBuffer_LT.SetRange("Planning Document No.", SrcPlanDocLevel_LT."Planning Document No.");
                SrcLevelBuffer_LT.SetRange("Planning Document Level", SrcPlanDocLevel_LT."Planning Document Level Index");
                SrcLevelBuffer_LT.SetRange(Active, true);

                if DestLevelBuffer_LT.Find('-') then
                    repeat
                        SrcLevelBuffer_LT.SetRange("Index Code", DestLevelBuffer_LT."Index Code");
                        if not SrcLevelBuffer_LT.IsEmpty() then
                            buffer_counter += 1;
                    until DestLevelBuffer_LT.Next() = 0;

                // ### wenn Zeile 'SONSTIGE' existiert, dann separat behandeln (alle anderen Pufferzeilen _müssen_ identisch sein!!!)
            end;

        until stop;

        // ### wenn die Quellebene keine relevanten Datensätze enthält: abbrechen
        if buffer_counter = 0 then
            Error(DocumentsDoNotHaveComparableDataErr);

        if (SrcPlanDocLevel_LT.Count() = 0) then
            exit(PlanDoc1_LT."No.")
        else
            exit(PlanDoc2_LT."No.");
    end;
}

