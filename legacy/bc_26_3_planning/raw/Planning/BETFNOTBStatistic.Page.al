/// <summary>
/// [planning]
/// Modules: 
/// </summary>
page 5138634 "BET FN OTB Statistic"
{

    Caption = 'OTB Statistic';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Purchase Header";
    UsageCategory = None;
    ApplicationArea = All;
    Extensible = true;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                group(Control1117300015)
                {
                    ShowCaption = false;
                    field("Document Type"; Rec."Document Type")
                    {
                        ToolTip = 'Specifies the Document Type.';
                        Editable = false;
                    }
                    field("No."; Rec."No.")
                    {
                        ToolTip = 'Specifies the No.';
                        Editable = false;
                    }
                    field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
                    {
                        ToolTip = 'Specifies the Buy-from Vendor No.';
                        Editable = false;
                    }
                    field("Season_GT.Code"; Season_GT.Code)
                    {
                        Caption = 'Order Season';
                        Editable = false;
                        TableRelation = "BET FN Season";

                        trigger OnValidate()
                        begin
                            UpdateStatisticLines();
                        end;
                    }
                    field("Expected Receipt Date"; Rec."Expected Receipt Date")
                    {
                        ToolTip = 'Specifies the Expected Receipt Date.';
                        Caption = 'Expected Receipt Date';
                        Editable = false;
                    }
                    field("Until Receipt Date"; UntilReceiptDate_G)
                    {
                        ToolTip = 'Specifies the Until Receipt Date.';
                        Caption = 'Until Receipt Date';

                        trigger OnValidate()
                        begin
                            UpdateStatisticLines();
                        end;
                    }
                }
                group(Control1117300014)
                {
                    ShowCaption = false;
                    field(LevelControl1; LevelCodeArray_G[1])
                    {
                        ToolTip = 'Specifies the LevelControl1.';
                        Caption = 'Level1';

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            RunLevelForm(LevelCodeArray_G[1]);
                            SetSubFormLevels();
                            UpdateStatisticLines();
                        end;

                        trigger OnValidate()
                        begin
                            if LevelCodeArray_G[1] = '' then
                                FiltertextArray_G[1] := '';
                            SetSubFormLevels();
                            UpdateStatisticLines();
                        end;
                    }
                    field("FiltertextArray_G[1]"; FiltertextArray_G[1])
                    {
                        Caption = 'Filter text';
                        ToolTip = 'Specifies the Filter text.';
                        Visible = false;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            OpenLevelForm(LevelCodeArray_G[1], FiltertextArray_G[1]);
                            CurrPage.SubPage.Page.SetFilterText(FiltertextArray_G);
                            UpdateStatisticLines();
                        end;

                        trigger OnValidate()
                        begin
                            CurrPage.SubPage.Page.SetFilterText(FiltertextArray_G);
                            UpdateStatisticLines();
                        end;
                    }
                    field(LevelControl2; LevelCodeArray_G[2])
                    {
                        ToolTip = 'Specifies the LevelControl2.';
                        Caption = 'Level2';

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            RunLevelForm(LevelCodeArray_G[2]);
                            SetSubFormLevels();
                            UpdateStatisticLines();
                        end;

                        trigger OnValidate()
                        begin
                            if LevelCodeArray_G[2] = '' then
                                FiltertextArray_G[2] := '';
                            SetSubFormLevels();
                            UpdateStatisticLines();
                        end;
                    }
                    field("FiltertextArray_G[2]"; FiltertextArray_G[2])
                    {
                        ToolTip = 'Specifies the Filter text.';
                        Caption = 'Filter text';
                        Visible = false;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            OpenLevelForm(LevelCodeArray_G[2], FiltertextArray_G[2]);
                            CurrPage.SubPage.Page.SetFilterText(FiltertextArray_G);
                            UpdateStatisticLines();
                        end;

                        trigger OnValidate()
                        begin
                            CurrPage.SubPage.Page.SetFilterText(FiltertextArray_G);
                            UpdateStatisticLines();
                        end;
                    }
                    field(LevelControl3; LevelCodeArray_G[3])
                    {
                        ToolTip = 'Specifies the LevelControl3.';
                        Caption = 'Level3';

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            RunLevelForm(LevelCodeArray_G[3]);
                            SetSubFormLevels();
                            UpdateStatisticLines();
                        end;

                        trigger OnValidate()
                        begin
                            if LevelCodeArray_G[3] = '' then
                                FiltertextArray_G[3] := '';
                            SetSubFormLevels();
                            UpdateStatisticLines();
                        end;
                    }
                    field("FiltertextArray_G[3]"; FiltertextArray_G[3])
                    {
                        Caption = 'Filter text';
                        ToolTip = 'Specifies the Filter text.';
                        Visible = false;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            OpenLevelForm(LevelCodeArray_G[3], FiltertextArray_G[3]);
                            CurrPage.SubPage.Page.SetFilterText(FiltertextArray_G);
                            UpdateStatisticLines();
                        end;

                        trigger OnValidate()
                        begin
                            CurrPage.SubPage.Page.SetFilterText(FiltertextArray_G);
                            UpdateStatisticLines();
                        end;
                    }
                    field(LevelControl4; LevelCodeArray_G[4])
                    {
                        ToolTip = 'Specifies the LevelControl4.';
                        Caption = 'Level4';

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            RunLevelForm(LevelCodeArray_G[4]);
                            SetSubFormLevels();
                            UpdateStatisticLines();
                        end;

                        trigger OnValidate()
                        begin
                            if LevelCodeArray_G[4] = '' then
                                FiltertextArray_G[4] := '';
                            SetSubFormLevels();
                            UpdateStatisticLines();
                        end;
                    }
                    field("FiltertextArray_G[4]"; FiltertextArray_G[4])
                    {
                        ToolTip = 'Specifies the Filter text.';
                        Caption = 'Filter text';
                        Visible = false;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            OpenLevelForm(LevelCodeArray_G[4], FiltertextArray_G[4]);
                            CurrPage.SubPage.Page.SetFilterText(FiltertextArray_G);
                            UpdateStatisticLines();
                        end;

                        trigger OnValidate()
                        begin
                            CurrPage.SubPage.Page.SetFilterText(FiltertextArray_G);
                            UpdateStatisticLines();
                        end;
                    }
                }
            }
            part(SubPage; "BET FN OTB Statistic Subpage")
            {
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        if PrevNo_G = Rec."No." then
            exit;
        PrevNo_G := Rec."No.";
        Rec.FilterGroup(2);
        Rec.SetRange("No.", PrevNo_G);
        Rec.FilterGroup(0);
        Season_GT.Code := Rec."BET FN Order Season";
        UpdateStatisticLines();
    end;

    trigger OnOpenPage()
    var
        PlanSetup_LT: Record "BET FN Planning Setup";
    begin
        if PlanSetup_LT.Get() then begin
            LevelCodeArray_G[1] := PlanSetup_LT."OTB Level 1";
            LevelCodeArray_G[2] := PlanSetup_LT."OTB Level 2";
            LevelCodeArray_G[3] := PlanSetup_LT."OTB Level 3";
            LevelCodeArray_G[4] := PlanSetup_LT."OTB Level 4";
            CurrPage.SubPage.Page.SetPurchaseHeader(Rec);
            SetSubFormLevels();
        end;
    end;

    var
        TempOTBStatLine_GTT: Record "BET FN OTB Statistic Line" temporary;
        Season_GT: Record "BET FN Season";
        UntilReceiptDate_G: Boolean;
        LevelCodeArray_G: array[10] of Code[20];
        PrevNo_G: Code[20];
        FiltertextArray_G: array[10] of Text[250];

    /// <summary>
    /// UpdateStatisticLines.
    /// </summary>
    procedure UpdateStatisticLines()
    begin
        CreateStatisticLines(Rec);
        TempOTBStatLine_GTT.Reset();
        if TempOTBStatLine_GTT.Find('-') then
            repeat
                CurrPage.SubPage.Page.TransferLines(TempOTBStatLine_GTT);
            until TempOTBStatLine_GTT.Next() = 0;
    end;

    /// <summary>
    /// CreateStatisticLines.
    /// </summary>
    /// <param name="PurchHeader_PT">Record "Purchase Header".</param>
    procedure CreateStatisticLines(PurchHeader_PT: Record "Purchase Header")
    var
        PlanLevel_LT: Record "BET FN Planning Level";
        PlanStat_LT: Record "BET FN Planning Statistic";
        PurchStatEntry_LT: Record "BET FN Purchase Statistic Ent";
        Season_LT: Record "BET FN Season";
        PurchLine_LT: Record "Purchase Line";
        Window_L: Dialog;
        Counter_L: Integer;
        i_L: Integer;
        Total_L: Integer;
        CalcLimitLbl: Label 'Calculate limit\@1@@@@@@@@@@@@';
        LevelDoesNotExistErr: Label 'Level %1 does not exist.', Comment = '%1';
    begin
        Season_LT.Get(PurchHeader_PT."BET FN Order Season");

        TempOTBStatLine_GTT.Reset();
        TempOTBStatLine_GTT.DeleteAll();

        //### temp. Tabelle für Filter erstellen:
        PurchLine_LT.Reset();
        PurchLine_LT.SetRange("Document Type", PurchLine_LT."Document Type"::Order);
        PurchLine_LT.SetRange(Type, PurchLine_LT.Type::Item);
        PurchLine_LT.SetRange("Document No.", Rec."No.");
        PurchLine_LT.SetFilter("No.", '<>%1', '');
        if PurchLine_LT.Find('-') then
            repeat
                for i_L := 1 to 6 do
                    if LevelCodeArray_G[i_L] <> '' then
                        if not PlanLevel_LT.Get(LevelCodeArray_G[i_L]) then
                            Error(LevelDoesNotExistErr)
                        else
                            case PlanLevel_LT."Index Table No." of
                                Database::Location:
                                    FiltertextArray_G[i_L] := PurchLine_LT."Location Code";   // Filiale
                                Database::Vendor:
                                    FiltertextArray_G[i_L] := PurchLine_LT."Buy-from Vendor No.";  // Lieferant
                                Database::"Item Category":
                                    FiltertextArray_G[i_L] := PurchLine_LT."Item Category Code";   // Warengruppe
                                Database::"BET FN Division":
                                    FiltertextArray_G[i_L] := PurchLine_LT."BET FN Division";   // Abteilung
                                Database::"BET FN Brand":
                                    FiltertextArray_G[i_L] := PurchLine_LT."BET FN Brand";   // Marke
                                Database::"BET FN Season":
                                    FiltertextArray_G[i_L] := PurchLine_LT."BET FN Season";   // Saison
                                Database::"BET FN Main Waregroup":
                                    FiltertextArray_G[i_L] := PurchLine_LT."BET FN Main Waregroup";   // Hauptwarengruppe
                                Database::"BET FN PDM Setup":
                                    if Season_LT.Get(PurchLine_LT."BET FN Season") then
                                        FiltertextArray_G[i_L] := Format(Season_LT."Season Type");
                            end;

                TempOTBStatLine_GTT.Reset();
                TempOTBStatLine_GTT.SetRange(Level1, FiltertextArray_G[1]);
                TempOTBStatLine_GTT.SetRange(Level2, FiltertextArray_G[2]);
                TempOTBStatLine_GTT.SetRange(Level3, FiltertextArray_G[3]);
                TempOTBStatLine_GTT.SetRange(Level4, FiltertextArray_G[4]);

                if not TempOTBStatLine_GTT.FindFirst() then begin
                    TempOTBStatLine_GTT.Init();
                    TempOTBStatLine_GTT.Level1 := FiltertextArray_G[1];
                    TempOTBStatLine_GTT.Level2 := FiltertextArray_G[2];
                    TempOTBStatLine_GTT.Level3 := FiltertextArray_G[3];
                    TempOTBStatLine_GTT.Level4 := FiltertextArray_G[4];
                    TempOTBStatLine_GTT.Insert();
                end;

                TempOTBStatLine_GTT."This Order Quantity" := TempOTBStatLine_GTT."This Order Quantity" + PurchLine_LT."Outstanding Quantity";
                TempOTBStatLine_GTT."This Order Purchase" := TempOTBStatLine_GTT."This Order Purchase" + PurchLine_LT."BET FN Net Outstanding Amt LCY";

                //### VK-Wert:
                TempOTBStatLine_GTT."This Order Sale" := TempOTBStatLine_GTT."This Order Sale" + PurchLine_LT."BET FN Outstd Gs Sales Amt LCY";

                if TempOTBStatLine_GTT."This Order Purchase" <> 0 then
                    TempOTBStatLine_GTT."This Order Calc." := (TempOTBStatLine_GTT."This Order Sale" - TempOTBStatLine_GTT."This Order Purchase") /
                                                       TempOTBStatLine_GTT."This Order Purchase" * 100
                else
                    TempOTBStatLine_GTT."This Order Calc." := 0;
                TempOTBStatLine_GTT.Modify();
            until PurchLine_LT.Next() = 0;


        //### Berechnung der Zeilen:
        TempOTBStatLine_GTT.Reset();

        Window_L.Open(CalcLimitLbl);
        Total_L := TempOTBStatLine_GTT.Count();
        Counter_L := 0;

        PlanStat_LT.Reset();
        if not PlanStat_LT.FindFirst() then begin
            PlanStat_LT.Init();
            PlanStat_LT.Index := 1;
            PlanStat_LT.Insert();
        end;

        if TempOTBStatLine_GTT.Find('-') then
            repeat
                Counter_L := Counter_L + 1;
                Window_L.Update(1, Round(Counter_L / Total_L * 9999, 1));
                PurchStatEntry_LT.Reset();

                for i_L := 1 to 6 do begin
                    // ### Filter aus temp. Tabelle nehmen:
                    case i_L of
                        1:
                            FiltertextArray_G[i_L] := TempOTBStatLine_GTT.Level1;
                        2:
                            FiltertextArray_G[i_L] := TempOTBStatLine_GTT.Level2;
                        3:
                            FiltertextArray_G[i_L] := TempOTBStatLine_GTT.Level3;
                        4:
                            FiltertextArray_G[i_L] := TempOTBStatLine_GTT.Level4;
                    end;

                    if LevelCodeArray_G[i_L] <> '' then
                        if not PlanLevel_LT.Get(LevelCodeArray_G[i_L]) then
                            Error(LevelDoesNotExistErr)
                        else
                            case PlanLevel_LT."Index Table No." of
                                Database::Location:
                                    PlanStat_LT.SetRange(LocFilter, FiltertextArray_G[i_L]);       // Filiale
                                Database::Vendor:
                                    PlanStat_LT.SetRange(VendorFilter, FiltertextArray_G[i_L]);    // Lieferant
                                Database::"Item Category":
                                    PlanStat_LT.SetRange(ItemCatFilter, FiltertextArray_G[i_L]);   // Warengruppe
                                Database::"BET FN Division":
                                    PlanStat_LT.SetRange(DivisFilter, FiltertextArray_G[i_L]);     // Abteilung
                                Database::"BET FN Brand":
                                    PlanStat_LT.SetRange(BrandFilter, FiltertextArray_G[i_L]);     // Marke
                                Database::"BET FN Main Waregroup":
                                    PlanStat_LT.SetRange(MainWGFilter, FiltertextArray_G[i_L]);    // Hauptwarengruppe
                            end;
                end;

                if UntilReceiptDate_G then
                    PlanStat_LT.SetFilter(DateFilter, '<=%1', PurchHeader_PT."Expected Receipt Date");

                PlanStat_LT.SetRange(SeasonFilter, PurchHeader_PT."BET FN Order Season");
                PlanStat_LT.CalcFields("OTB Qty. Purchase"
                                      , "OTB Cost Am. Purchase"
                                      , "OTB Sales Am. Purchase"
                                      );
                TempOTBStatLine_GTT."Limit Plan Purchase" := PlanStat_LT."OTB Cost Am. Purchase";
                TempOTBStatLine_GTT."Limit Plan Quantity" := PlanStat_LT."OTB Qty. Purchase";
                TempOTBStatLine_GTT."Limit Plan Sale" := PlanStat_LT."OTB Sales Am. Purchase";
                if TempOTBStatLine_GTT."Limit Plan Purchase" <> 0 then
                    TempOTBStatLine_GTT."Limit Plan Calc." := (TempOTBStatLine_GTT."Limit Plan Sale" - TempOTBStatLine_GTT."Limit Plan Purchase") /
                                                              TempOTBStatLine_GTT."Limit Plan Purchase" * 100
                else
                    TempOTBStatLine_GTT."Limit Plan Calc." := 0;

                //### Standardmäßig die Einkaufszeilen verwenden:
                PlanStat_LT.CalcFields("FSE Purchase Quantity"
                                       , "FSE Purchase Value (Cost)"
                                       , "FSE Purchase Value"
                                       , "Outst. Qty. in Purch. Order"
                                       , "Outst. Amount Net Purch. Order"
                                       , "Outst. Gross Sales Amt. (LCY)"
                                       );

                TempOTBStatLine_GTT."Limit Act. Purchase" := PlanStat_LT."FSE Purchase Value (Cost)" + PlanStat_LT."Outst. Amount Net Purch. Order";
                TempOTBStatLine_GTT."Limit Act. Quantity" := PlanStat_LT."FSE Purchase Quantity" + PlanStat_LT."Outst. Qty. in Purch. Order";
                TempOTBStatLine_GTT."Limit Act. Sale" := PlanStat_LT."FSE Purchase Value" + PlanStat_LT."Outst. Gross Sales Amt. (LCY)";
                /*
                //### die aktuelle Order muß aus dem Ist-Limit noch rausgerechnet werden:
                if PlanStat_LT.GetFilter(DateFilter) <> '' then begin
                    OTBStatLine_GTT."Limit Act. Purchase" := OTBStatLine_GTT."Limit Act. Purchase" - OTBStatLine_GTT."This Order Purchase";
                    OTBStatLine_GTT."Limit Act. Quantity" := OTBStatLine_GTT."Limit Act. Quantity" - OTBStatLine_GTT."This Order Quantity";
                    OTBStatLine_GTT."Limit Act. Sale" := OTBStatLine_GTT."Limit Act. Sale" - OTBStatLine_GTT."This Order Sale";
                end else begin
                  OTBStatLine_GTT."Limit Act. Purchase" := OTBStatLine_GTT."Limit Act. Purchase" - OTBStatLine_GTT."This Order Purchase";
                  OTBStatLine_GTT."Limit Act. Quantity" := OTBStatLine_GTT."Limit Act. Quantity" - OTBStatLine_GTT."This Order Quantity";
                  OTBStatLine_GTT."Limit Act. Sale" := OTBStatLine_GTT."Limit Act. Sale" - OTBStatLine_GTT."This Order Sale";
                end;
                */

                if TempOTBStatLine_GTT."Limit Act. Purchase" <> 0 then
                    TempOTBStatLine_GTT."Limit Act. Calc." := (TempOTBStatLine_GTT."Limit Act. Sale" - TempOTBStatLine_GTT."Limit Act. Purchase") /
                                                             TempOTBStatLine_GTT."Limit Act. Purchase" * 100
                else
                    TempOTBStatLine_GTT."Limit Act. Calc." := 0;
                if PurchHeader_PT.Status = PurchHeader_PT.Status::Open then begin
                    TempOTBStatLine_GTT."Limit Rest Purchase" := TempOTBStatLine_GTT."Limit Plan Purchase" - TempOTBStatLine_GTT."Limit Act. Purchase" - TempOTBStatLine_GTT."This Order Purchase";
                    TempOTBStatLine_GTT."Limit Rest Quantity" := TempOTBStatLine_GTT."Limit Plan Quantity" - TempOTBStatLine_GTT."Limit Act. Quantity" - TempOTBStatLine_GTT."This Order Quantity";
                    TempOTBStatLine_GTT."Limit Rest Sale" := TempOTBStatLine_GTT."Limit Plan Sale" - TempOTBStatLine_GTT."Limit Act. Sale" - TempOTBStatLine_GTT."This Order Sale";
                end else begin
                    TempOTBStatLine_GTT."Limit Rest Purchase" := TempOTBStatLine_GTT."Limit Plan Purchase" - TempOTBStatLine_GTT."Limit Act. Purchase";
                    TempOTBStatLine_GTT."Limit Rest Quantity" := TempOTBStatLine_GTT."Limit Plan Quantity" - TempOTBStatLine_GTT."Limit Act. Quantity";
                    TempOTBStatLine_GTT."Limit Rest Sale" := TempOTBStatLine_GTT."Limit Plan Sale" - TempOTBStatLine_GTT."Limit Act. Sale";
                end;



                if TempOTBStatLine_GTT."Limit Rest Purchase" <> 0 then
                    TempOTBStatLine_GTT."Limit Rest Calc." := (TempOTBStatLine_GTT."Limit Rest Sale" - TempOTBStatLine_GTT."Limit Rest Purchase") /
                                                      TempOTBStatLine_GTT."Limit Rest Purchase" * 100
                else
                    TempOTBStatLine_GTT."Limit Rest Calc." := 0;
                TempOTBStatLine_GTT.Modify();

            until TempOTBStatLine_GTT.Next() = 0;
        Window_L.Close();

    end;

    /// <summary>
    /// UpdateSubform.
    /// </summary>
    procedure UpdateSubform()
    begin
        CurrPage.SubPage.Page.UpdateForm();
    end;

    /// <summary>
    /// SetSubFormLevels.
    /// </summary>
    procedure SetSubFormLevels()
    begin
        CurrPage.SubPage.Page.SetLevelText(LevelCodeArray_G);
    end;

    /// <summary>
    /// RunLevelForm.
    /// </summary>
    /// <param name="LevelCode_VP">VAR Code[20].</param>
    procedure RunLevelForm(var LevelCode_VP: Code[20])
    var
        PlanLevel_LT: Record "BET FN Planning Level";
    begin
        PlanLevel_LT.Reset();
        PlanLevel_LT.SetRange(Activated, true);
        if Page.RunModal(Page::"BET FN Planning Levels List", PlanLevel_LT) = Action::LookupOK then
            LevelCode_VP := PlanLevel_LT."Index Code";
    end;

    /// <summary>
    /// OpenLevelForm.
    /// </summary>
    /// <param name="LevelCode_P">Code[20].</param>
    /// <param name="FilterText_VP">VAR Text[30].</param>
    procedure OpenLevelForm(LevelCode_P: Code[20]; var FilterText_VP: Text[30])
    var
        Brands_LT: Record "BET FN Brand";
        Division_LT: Record "BET FN Division";
        MainWaregroup_LT: Record "BET FN Main Waregroup";
        Season_LT: Record "BET FN Season";
        ItemCategory_LT: Record "Item Category";
        Location_LT: Record Location;
        Vendor_LT: Record Vendor;
    begin
        case LevelCode_P of
            'ABTEILUNG':
                //### Abteilung
                if Page.RunModal(0, Division_LT) = Action::LookupOK then
                    FilterText_VP := Division_LT.Code;
            'FILIALE':
                //### Filiale
                if Page.RunModal(0, Location_LT) = Action::LookupOK then
                    FilterText_VP := Location_LT.Code;
            'HWG':
                //### Hauptwarengruppe
                if Page.RunModal(0, MainWaregroup_LT) = Action::LookupOK then
                    FilterText_VP := MainWaregroup_LT.Code;
            'LIEFERANT':
                //### Kreditor
                if Page.RunModal(0, Vendor_LT) = Action::LookupOK then
                    FilterText_VP := Vendor_LT."No.";
            'MARKE':
                //### Marke
                if Page.RunModal(0, Brands_LT) = Action::LookupOK then
                    FilterText_VP := Brands_LT.Code;
            'SAISON':
                //### Saison
                if Page.RunModal(0, Season_LT) = Action::LookupOK then
                    FilterText_VP := Season_LT.Code;
            'WG':
                //### Warengruppe
                if Page.RunModal(0, ItemCategory_LT) = Action::LookupOK then
                    FilterText_VP := ItemCategory_LT.Code;
        end;
    end;
}

