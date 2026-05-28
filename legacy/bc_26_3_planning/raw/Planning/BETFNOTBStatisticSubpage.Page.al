/// <summary>
/// [planning]
/// Modules: 
/// </summary>
page 5138635 "BET FN OTB Statistic Subpage"
{
    Caption = 'Lines';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = "BET FN OTB Statistic Line";
    ApplicationArea = All;
    Extensible = true;

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field(LevelControl1; Rec.Level1)
                {
                    CaptionClass = LevelCaption_G[1];
                    Visible = LevelControl1Visible_G;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        PlanLevel_LT: Record "BET FN Planning Level";
                    begin
                        if PlanLevel_LT.Get(LevelText_G[1]) then
                            OpenForm(PlanLevel_LT."Index Table No.", Rec.Level1);
                    end;
                }
                field(LevelControl2; Rec.Level2)
                {
                    CaptionClass = LevelCaption_G[2];
                    Visible = LevelControl2Visible_G;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        PlanLevel_LT: Record "BET FN Planning Level";
                    begin
                        if PlanLevel_LT.Get(LevelText_G[2]) then
                            OpenForm(PlanLevel_LT."Index Table No.", Rec.Level2);
                    end;
                }
                field(LevelControl3; Rec.Level3)
                {
                    CaptionClass = LevelCaption_G[3];
                    Visible = LevelControl3Visible_G;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        PlanLevel_LT: Record "BET FN Planning Level";
                    begin
                        if PlanLevel_LT.Get(LevelText_G[3]) then
                            OpenForm(PlanLevel_LT."Index Table No.", Rec.Level3);
                    end;
                }
                field(LevelControl4; Rec.Level4)
                {
                    CaptionClass = LevelCaption_G[4];
                    Visible = LevelControl4Visible_G;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        PlanLevel_LT: Record "BET FN Planning Level";
                    begin
                        if PlanLevel_LT.Get(LevelText_G[4]) then
                            OpenForm(PlanLevel_LT."Index Table No.", Rec.Level4);
                    end;
                }
                field("Limit Plan Purchase"; Rec."Limit Plan Purchase")
                {
                    Caption = 'Limit Plan\Purchase';
                    DecimalPlaces = 0 : 0;
                }
                field("Limit Act. Purchase"; Rec."Limit Act. Purchase")
                {
                    Caption = 'Limit Actual\Purchase';
                    DecimalPlaces = 0 : 0;
                }
                field("This Order Purchase"; Rec."This Order Purchase")
                {
                    Caption = 'This Order\Purchase';
                    DecimalPlaces = 0 : 0;
                    Style = Unfavorable;
                    StyleExpr = ThisOrderPurchaseAttention_G;
                }
                field("Limit Rest Purchase"; Rec."Limit Rest Purchase")
                {
                    Caption = 'Limit Rest\Purchase';
                    DecimalPlaces = 0 : 0;
                    Style = Strong;
                    StyleExpr = true;
                }
                field("Limit Plan Quantity"; Rec."Limit Plan Quantity")
                {
                    Caption = 'Limit Plan\Quantity';
                    DecimalPlaces = 0 : 0;
                    Visible = false;
                }
                field("Limit Act. Quantity"; Rec."Limit Act. Quantity")
                {
                    Caption = 'Limit Actual\Quantity';
                    DecimalPlaces = 0 : 0;
                    Visible = false;
                }
                field("This Order Quantity"; Rec."This Order Quantity")
                {
                    Caption = 'This Order\Quantity';
                    DecimalPlaces = 0 : 0;
                    StyleExpr = ThisOrderQuantityAttention_G;
                    Visible = false;
                }
                field("Limit Rest Quantity"; Rec."Limit Rest Quantity")
                {
                    Caption = 'Limit Rest\Quantity';
                    DecimalPlaces = 0 : 0;
                    Style = Strong;
                    StyleExpr = true;
                    Visible = false;
                }
                field("Limit Plan Sale"; Rec."Limit Plan Sale")
                {
                    Caption = 'Limit Plan\Sale Value';
                    DecimalPlaces = 0 : 0;
                    Visible = false;
                }
                field("Limit Act. Sale"; Rec."Limit Act. Sale")
                {
                    Caption = 'Limit Actual Sale Value';
                    DecimalPlaces = 0 : 0;
                    Visible = false;
                }
                field("This Order Sale"; Rec."This Order Sale")
                {
                    Caption = 'This Order\Sale Value';
                    DecimalPlaces = 0 : 0;
                    Style = Strong;
                    StyleExpr = ThisOrderSaleAttention_G;
                    Visible = false;
                }
                field("Limit Rest Sale"; Rec."Limit Rest Sale")
                {
                    Caption = 'Limit Rest\Sale Value';
                    DecimalPlaces = 0 : 0;
                    Style = Strong;
                    StyleExpr = true;
                    Visible = false;
                }
                field("Limit Plan Calc."; Rec."Limit Plan Calc.")
                {
                    Caption = 'Limit Plan\Calculation';
                    DecimalPlaces = 1 : 1;
                    Visible = false;
                }
                field("Limit Act. Calc."; Rec."Limit Act. Calc.")
                {
                    Caption = 'Limit Actual\Calculation';
                    DecimalPlaces = 1 : 1;
                    Visible = false;
                }
                field("This Order Calc."; Rec."This Order Calc.")
                {
                    Caption = 'This Order\Calculation';
                    DecimalPlaces = 1 : 1;
                    Visible = false;
                }
                field("Limit Rest Calc."; Rec."Limit Rest Calc.")
                {
                    Caption = 'Limit Rest\Calculation';
                    DecimalPlaces = 1 : 1;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        ThisOrderPurchaseOnFormat();
        ThisOrderQuantityOnFormat();
        ThisOrderSaleOnFormat();
    end;

    trigger OnFindRecord(Which: Text): Boolean
    begin
        TempLine_GTT.Copy(Rec);
        if TempLine_GTT.Find(Which) then begin
            Rec := TempLine_GTT;
            exit(true);
        end else
            exit(false);
    end;

    trigger OnNextRecord(Steps: Integer): Integer
    var
        ResultSteps: Integer;
    begin
        TempLine_GTT.Copy(Rec);
        ResultSteps := TempLine_GTT.Next(Steps);
        if ResultSteps <> 0 then
            Rec := TempLine_GTT;
        exit(ResultSteps);
    end;

    trigger OnOpenPage()
    begin
        /*
        LevelControl1Visible_G := false;
        LevelControl2Visible_G := false;
        LevelControl3Visible_G := false;
        LevelControl4Visible_G := false;
        */

    end;

    var
        TempLine_GTT: Record "BET FN OTB Statistic Line" temporary;
        PurchaseHeader_GT: Record "Purchase Header";
        LevelControl1Visible_G: Boolean;
        LevelControl2Visible_G: Boolean;
        LevelControl3Visible_G: Boolean;
        LevelControl4Visible_G: Boolean;
        ThisOrderPurchaseAttention_G: Boolean;
        ThisOrderQuantityAttention_G: Boolean;
        ThisOrderSaleAttention_G: Boolean;
        LevelCaption_G: array[10] of Text[30];
        LevelText_G: array[10] of Text[30];
        FilterText_G: array[10] of Text[250];

    /// <summary>
    /// TransferLines.
    /// </summary>
    /// <param name="NewLine_LT">VAR Record "BET FN OTB Statistic Line".</param>
    procedure TransferLines(var NewLine_LT: Record "BET FN OTB Statistic Line")
    begin
        TempLine_GTT.DeleteAll();
        if NewLine_LT.Find('-') then
            repeat
                TempLine_GTT.Copy(NewLine_LT);
                TempLine_GTT.Insert();
            until NewLine_LT.Next() = 0;
        CurrPage.Update(false);
    end;

    /// <summary>
    /// UpdateForm.
    /// </summary>
    procedure UpdateForm()
    begin
        CurrPage.Update();
    end;

    /// <summary>
    /// SetFilterText.
    /// </summary>
    /// <param name="FilterText_P">array[10] of Text[250].</param>
    procedure SetFilterText(FilterText_P: array[10] of Text[250])
    var
        i: Integer;
    begin
        for i := 1 to 6 do
            FilterText_G[i] := FilterText_P[i];
    end;

    /// <summary>
    /// SetLevelText.
    /// </summary>
    /// <param name="LevelCode_P">array[10] of Code[20].</param>
    procedure SetLevelText(LevelCode_P: array[10] of Code[20])
    var
        i: Integer;
    begin
        for i := 1 to 6 do begin
            LevelText_G[i] := LevelCode_P[i];
            LevelCaption_G[i] := '1,5,,' + LevelText_G[i];
        end;

        LevelControl1Visible_G := LevelText_G[1] <> '';
        LevelControl2Visible_G := LevelText_G[2] <> '';
        LevelControl3Visible_G := LevelText_G[3] <> '';
        LevelControl4Visible_G := LevelText_G[4] <> '';
        CurrPage.Update(false);
    end;

    /// <summary>
    /// OpenForm.
    /// </summary>
    /// <param name="TableNo_P">Integer.</param>
    /// <param name="Code_P">Code[20].</param>
    procedure OpenForm(TableNo_P: Integer; Code_P: Code[20])
    var
        Brand_LT: Record "BET FN Brand";
        Division_LT: Record "BET FN Division";
        MainWG_LT: Record "BET FN Main Waregroup";
        ItemCat_LT: Record "Item Category";
        Location_LT: Record Location;
        Vendor_LT: Record Vendor;
    begin
        case TableNo_P of
            Database::Location:        // ### Filiale
                if Location_LT.Get(Code_P) then
                    Page.RunModal(0, Location_LT);
            Database::Vendor:        // ### Lieferant
                if Vendor_LT.Get(Code_P) then
                    Page.RunModal(0, Vendor_LT);
            Database::"Item Category":      // ### WG
                if ItemCat_LT.Get(Code_P) then
                    Page.RunModal(0, ItemCat_LT);
            Database::"BET FN Division":   // ### Abteilung
                if Division_LT.Get(Code_P) then
                    Page.RunModal(0, Division_LT);
            Database::"BET FN Brand":   // ### Marke
                if Brand_LT.Get(Code_P) then
                    Page.RunModal(0, Brand_LT);
            Database::"BET FN Main Waregroup":   // ### HWG
                if MainWG_LT.Get(Code_P) then
                    Page.RunModal(0, MainWG_LT);
        end;
    end;

    local procedure ThisOrderPurchaseOnFormat()
    begin
        ThisOrderPurchaseAttention_G := false;
        if (PurchaseHeader_GT.Status = PurchaseHeader_GT.Status::Open) and (Rec."Limit Rest Purchase" < 0) then
            ThisOrderPurchaseAttention_G := true;
    end;

    local procedure ThisOrderQuantityOnFormat()
    begin
        // todo...
        if Rec."Limit Rest Quantity" < Rec."This Order Quantity" then
            ThisOrderQuantityAttention_G := true
        else
            ThisOrderQuantityAttention_G := false;
    end;

    local procedure ThisOrderSaleOnFormat()
    begin
        // todo...
        if Rec."Limit Rest Sale" < Rec."This Order Sale" then
            ThisOrderSaleAttention_G := true
        else
            ThisOrderSaleAttention_G := false;
    end;

    /// <summary>
    /// SetPurchaseHeader.
    /// </summary>
    /// <param name="PurchaseHeader_PT">Record "Purchase Header".</param>
    procedure SetPurchaseHeader(PurchaseHeader_PT: Record "Purchase Header")
    begin
        PurchaseHeader_GT := PurchaseHeader_PT;
    end;
}

