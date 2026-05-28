/// <summary>
/// [planning]
/// Modules: 
/// </summary>
#pragma warning disable AL0432
page 5138663 "BET FN Planning View OTB Subp"
{
    ObsoleteState = Pending;
    ObsoleteTag = '25.2';
    ObsoleteReason = '#35131 Pending removal - page will be removed in future updates';

    Caption = 'Total View';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = "BET FN Planning View";
    SourceTableTemporary = true;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("View Entry No."; Rec."View Entry No.")
                {
                    Visible = false;
                }
                field("Planning Document No."; Rec."Planning Document No.")
                {
                    Visible = false;
                }
                field(Description; Rec."Description 1")
                {
                    Caption = 'Description';
                    StyleExpr = ColourStyle_G;
                }
                field("Plan Sales Amount"; Rec."Plan Sales Amount")
                {
                    Caption = 'Gross Sales Amount';
                    DecimalPlaces = 0 : 0;
                    StyleExpr = ColourStyle_G;
                    Visible = GrossSalesAmountVisible_G;
                }
                field("Plan Calc. Sales %"; Rec."Plan Calc. Sales %")
                {
                    Caption = 'real. Calc. %';
                    DecimalPlaces = 1 : 1;
                    StyleExpr = ColourStyle_G;
                    Visible = false;
                }
                field("Plan Sales Discount %"; Rec."Plan Sales Discount %")
                {
                    Caption = 'Discount %';
                    DecimalPlaces = 1 : 1;
                    StyleExpr = ColourStyle_G;
                    Visible = false;
                }
                field("Plan Sales Discount"; Rec."Plan Sales Discount")
                {
                    Caption = 'Discount Amount';
                    DecimalPlaces = 0 : 0;
                    StyleExpr = ColourStyle_G;
                    Visible = DiscountVisible_G;
                }
                field("Plan Sal. Am. incl. Discount"; Rec."Plan Sal. Am. incl. Discount")
                {
                    Caption = 'Sal. Am. incl. Discount';
                    DecimalPlaces = 0 : 0;
                    StyleExpr = ColourStyle_G;
                    Visible = SalesInclDiscountVisible_G;
                }
                field("Plan Sales Init. Inv."; Rec."Plan Sales Init. Inv.")
                {
                    Caption = 'Sales Init. Inv.';
                    DecimalPlaces = 0 : 0;
                    StyleExpr = ColourStyle_G;
                    Visible = SalesInitInvVisible_G;
                }
                field("Plan Sales Closing Inv."; Rec."Plan Sales Closing Inv.")
                {
                    Caption = 'Sales Closing Inv.';
                    DecimalPlaces = 0 : 0;
                    StyleExpr = ColourStyle_G;
                    Visible = SalesInitClosingVisible_G;
                }
                field("Plan Gross Sales Pr. Reduction"; Rec."Plan Gross Sales Pr. Reduction")
                {
                    Caption = 'Reduction Amount';
                    DecimalPlaces = 0 : 0;
                    StyleExpr = ColourStyle_G;
                    Visible = ReductionVisible_G;
                }
                field("Plan Sales Am. Purchase"; Rec."Plan Sales Am. Purchase")
                {
                    Caption = 'Sales Am. Purchase';
                    DecimalPlaces = 0 : 0;
                    StyleExpr = ColourStyle_G;
                    Visible = SalesAmtPurchVisible_G;
                }
                field("Plan Cost of Sales"; Rec."Plan Cost of Sales")
                {
                    Caption = 'Cost of Sales';
                    DecimalPlaces = 0 : 0;
                    StyleExpr = ColourStyle_G;
                    Visible = CostOfSalesVisible_G;
                }
                field("Plan Cost Init. Inv."; Rec."Plan Cost Init. Inv.")
                {
                    Caption = 'Cost Init. Inv.';
                    DecimalPlaces = 0 : 0;
                    StyleExpr = ColourStyle_G;
                    Visible = CostInitInvVisible_G;
                }
                field("Plan Cost Closing Inv."; Rec."Plan Cost Closing Inv.")
                {
                    Caption = 'Cost Closing Inv.';
                    DecimalPlaces = 0 : 0;
                    StyleExpr = ColourStyle_G;
                    Visible = CostClosingInvVisible_G;
                }
                field("Plan Cost Am. Purchase"; Rec."Plan Cost Am. Purchase")
                {
                    Caption = 'Cost Val. Purchase';
                    DecimalPlaces = 0 : 0;
                    StyleExpr = ColourStyle_G;
                    Visible = CostAmtPurchVisible_G;
                }
                field("Plan Qty. Sale"; Rec."Plan Qty. Sale")
                {
                    Caption = 'Qty. Sale';
                    DecimalPlaces = 0 : 0;
                    StyleExpr = ColourStyle_G;
                    Visible = QtySalesVisible_G;
                }
                field("Plan Qty. Init. Inv."; Rec."Plan Qty. Init. Inv.")
                {
                    Caption = 'Qty. Init. Inv.';
                    DecimalPlaces = 0 : 0;
                    StyleExpr = ColourStyle_G;
                    Visible = QtyInitInvVisible_G;
                }
                field("Plan Qty. Closing Inv."; Rec."Plan Qty. Closing Inv.")
                {
                    Caption = 'Qty. Closing Inv.';
                    DecimalPlaces = 0 : 0;
                    StyleExpr = ColourStyle_G;
                    Visible = QtyClosingInvVisible_G;
                }
                field("Plan Qty. Purchase"; Rec."Plan Qty. Purchase")
                {
                    Caption = 'Qty. Purchase';
                    DecimalPlaces = 0 : 0;
                    StyleExpr = ColourStyle_G;
                    Visible = QtyPurchVisible_G;
                }
                field("Plan Calc. Purchase %"; Rec."Plan Calc. Purchase %")
                {
                    Caption = 'Calc. Purchase %';
                    DecimalPlaces = 1 : 1;
                    StyleExpr = ColourStyle_G;
                    Visible = false;
                }
                field("Plan Sales Inv. Change"; Rec."Plan Sales Inv. Change")
                {
                    Caption = 'Sales Inv. Change';
                    DecimalPlaces = 0 : 0;
                    StyleExpr = ColourStyle_G;
                    Visible = false;
                }
                field("Plan Cost Inv. Change"; Rec."Plan Cost Inv. Change")
                {
                    Caption = 'Cost Inv. Change';
                    DecimalPlaces = 0 : 0;
                    StyleExpr = ColourStyle_G;
                    Visible = false;
                }
                field("Plan Qty. Inv. Change"; Rec."Plan Qty. Inv. Change")
                {
                    Caption = 'Qty. Inv. Change';
                    DecimalPlaces = 0 : 0;
                    StyleExpr = ColourStyle_G;
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
        case Rec."View Entry No." of
            1:
                ColourStyle_G := 'Subordinate';     //### VJ-Werte = grau
            2:
                ColourStyle_G := 'StandardAccent';  //### Planwerte = blau
            3:
                ColourStyle_G := 'Standard';        //### Planwerte gespeichert bzw. Vorgabe = schwarz
        end;
    end;

    var
        CostAmtPurchVisible_G: Boolean;
        CostClosingInvVisible_G: Boolean;
        CostInitInvVisible_G: Boolean;
        CostOfSalesVisible_G: Boolean;
        DiscountVisible_G: Boolean;
        GrossSalesAmountVisible_G: Boolean;
        QtyClosingInvVisible_G: Boolean;
        QtyInitInvVisible_G: Boolean;
        QtyPurchVisible_G: Boolean;
        QtySalesVisible_G: Boolean;
        ReductionVisible_G: Boolean;
        SalesAmtPurchVisible_G: Boolean;
        SalesInclDiscountVisible_G: Boolean;
        SalesInitClosingVisible_G: Boolean;
        SalesInitInvVisible_G: Boolean;
        ColourStyle_G: Text;

    /// <summary>
    /// SetTempTable.
    /// </summary>
    /// <param name="PlanView_PTT">Temporary VAR Record "BET FN Planning View".</param>
    procedure SetTempTable(var PlanView_PTT: Record "BET FN Planning View" temporary)
    begin
        Rec.Reset();
        Rec.DeleteAll();

        if PlanView_PTT.Find('-') then
            repeat
                Rec.Init();
                Rec.TransferFields(PlanView_PTT);
                Rec.Insert();
            until PlanView_PTT.Next() = 0;

        CurrPage.Update(false);
    end;

    /// <summary>
    /// SetLayout.
    /// </summary>
    /// <param name="PlanDocLevel_PT">Record "BET FN Planning Document Level".</param>
    /// <param name="PlanDoc_PT">Record "BET FN Planning Document".</param>
    procedure SetLayout(PlanDocLevel_PT: Record "BET FN Planning Document Level"; PlanDoc_PT: Record "BET FN Planning Document")
    begin

    end;
}

