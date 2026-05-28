/// <summary>
/// [planning]
/// Modules: 
/// </summary>
codeunit 5138636 "BET FN Calculate Planning Vals"
{
    Access = Public;

    /// <summary>
    /// EnterFromViewTable.
    /// </summary>
    /// <param name="BETFNPlanningView">VAR Record "BET FN Planning View".</param>
    /// <param name="FieldNo_P">Integer.</param>
    /// <param name="CurrFieldNo">Integer.</param>
    /// <param name="xBETFNPlanningView">Record "BET FN Planning View".</param>
    procedure EnterFromViewTable(var BETFNPlanningView: Record "BET FN Planning View"; FieldNo_P: Integer; CurrFieldNo: Integer; xBETFNPlanningView: Record "BET FN Planning View")
    var
        BETFNPlanningDocument: Record "BET FN Planning Document";
        IsHandled: Boolean;
    begin
        OnBeforeStartCalculation(BETFNPlanningView, xBETFNPlanningView, CurrFieldNo, IsHandled);
        if IsHandled then
            exit;

        BETFNPlanningDocument.Get(BETFNPlanningView."Planning Document No.");

        if CurrFieldNo in [BETFNPlanningView.FieldNo("Plan Limit 1 %"), BETFNPlanningView.FieldNo("Plan Limit 2 %"),
                            BETFNPlanningView.FieldNo("Plan Limit 3 %"), BETFNPlanningView.FieldNo("Plan Limit 4 %")] then
            CheckTotalLimitPercentage(BETFNPlanningView);

        ProcessCalculation(BETFNPlanningDocument, BETFNPlanningView, xBETFNPlanningView, CurrFieldNo);

        OnAfterCalculation(BETFNPlanningView, xBETFNPlanningView, CurrFieldNo);
    end;

    local procedure ProcessCalculation(BETFNPlanningDocument: Record "BET FN Planning Document"; var BETFNPlanningView: Record "BET FN Planning View"; xBETFNPlanningView: Record "BET FN Planning View"; CurrFieldNo: Integer)
    var
        BETFNPlanningType: Record "BET FN Planning Type";
    begin
        BETFNPlanningType.Get(BETFNPlanningDocument."Planning Type");

        case BETFNPlanningType."Planning Process Type" of
            // kundenspezifische Berechnungen:
            BETFNPlanningType."Planning Process Type"::" ":
                ;

            // Umsatzplanung (Umsatz (VJ, Plan, Ist)):
            BETFNPlanningType."Planning Process Type"::SalesPlan:
                StartCalculationSalesPlan(BETFNPlanningDocument, BETFNPlanningView, xBETFNPlanningView, CurrFieldNo);

            // Limitplanung (Umsatz, Abschriften, Kalkulation, Bestände, WE, etc.)
            BETFNPlanningType."Planning Process Type"::PurchasePlan:
                StartCalculationPurchasePlan(BETFNPlanningDocument, BETFNPlanningView, xBETFNPlanningView, CurrFieldNo);

            // Auftragseingänge (Menge + VK-Wert, Plan/VJ/Ist):
            BETFNPlanningType."Planning Process Type"::SalesOrderPlan:
                ;
        end;
    end;

    internal procedure CalcSalesAmountPurchaseFromValues(var BETFNPlanningView: Record "BET FN Planning View")
    begin
        // Limit VK := Endbestand - Anfangsbestand + Umsatz + Rabatt + Abschrift
        BETFNPlanningView."Plan Sales Am. Purchase" :=
            BETFNPlanningView."Plan Sales Closing Inv." -
            BETFNPlanningView."Plan Sales Init. Inv." +
            BETFNPlanningView."Plan Sales Amount" +
            BETFNPlanningView."Plan Sales Discount" +
            BETFNPlanningView."Plan Gross Sales Pr. Reduction";
    end;

    internal procedure CalcPurchValueFromWhsRcptMargin(var BETFNPlanningView: Record "BET FN Planning View"; BETFNPlanningDocument: Record "BET FN Planning Document")
    begin
        case BETFNPlanningDocument."Calculation Type" of
            // EK aus WE-Spanne (Abschlag):
            BETFNPlanningDocument."Calculation Type"::Margin:
                BETFNPlanningView."Plan Cost Am. Purchase" :=
                    BETFNPlanningView."Plan Sales Am. Purchase" -
                        (BETFNPlanningView."Plan Calc. Purchase %" / 100 * BETFNPlanningView."Plan Sales Am. Purchase");
            // EK aus WE-Kalkulation (Aufschlag):
            BETFNPlanningDocument."Calculation Type"::Calculation:
                if (BETFNPlanningView."Plan Calc. Purchase %" + 100) <> 0 then
                    BETFNPlanningView."Plan Cost Am. Purchase" :=
                    100 * BETFNPlanningView."Plan Sales Am. Purchase" / (BETFNPlanningView."Plan Calc. Purchase %" + 100);
        end;
    end;

    internal procedure CalcPurchValueFromRealizedMargin(var BETFNPlanningView: Record "BET FN Planning View"; BETFNPlanningDocument: Record "BET FN Planning Document")
    begin
        case BETFNPlanningDocument."Calculation Type" of
            // EK aus WE-Spanne (Abschlag):
            BETFNPlanningDocument."Calculation Type"::Margin:
                BETFNPlanningView."Plan Cost Am. Purchase" :=
                    BETFNPlanningView."Plan Sales Amount" -
                        (BETFNPlanningView."Plan Calc. Sales %" / 100 * BETFNPlanningView."Plan Sales Amount");
            // EK aus WE-Kalkulation (Aufschlag):
            BETFNPlanningDocument."Calculation Type"::Calculation:
                if (BETFNPlanningView."Plan Calc. Sales %" + 100) <> 0 then
                    BETFNPlanningView."Plan Cost Am. Purchase" :=
                    100 * BETFNPlanningView."Plan Sales Amount" / (BETFNPlanningView."Plan Calc. Sales %" + 100);
        end;
    end;

    internal procedure CalcWhsRcptMargin(var BETFNPlanningView: Record "BET FN Planning View"; BETFNPlanningDocument: Record "BET FN Planning Document")
    begin
        case BETFNPlanningDocument."Calculation Type" of
            // WE-Spanne (Abschlag) aus VK und EK:
            BETFNPlanningDocument."Calculation Type"::Margin:
                if BETFNPlanningView."Plan Sales Am. Purchase" <> 0 then
                    BETFNPlanningView."Plan Calc. Purchase %" :=
                        (BETFNPlanningView."Plan Sales Am. Purchase" - BETFNPlanningView."Plan Cost Am. Purchase") / BETFNPlanningView."Plan Sales Am. Purchase" * 100
                else
                    BETFNPlanningView."Plan Calc. Purchase %" := 0;

            // WE-Kalkulation (Aufschlag) aus VK und EK:
            BETFNPlanningDocument."Calculation Type"::Calculation:
                if BETFNPlanningView."Plan Cost Am. Purchase" <> 0 then
                    BETFNPlanningView."Plan Calc. Purchase %" :=
                       (BETFNPlanningView."Plan Sales Am. Purchase" - BETFNPlanningView."Plan Cost Am. Purchase") / BETFNPlanningView."Plan Cost Am. Purchase" * 100
                else
                    BETFNPlanningView."Plan Calc. Purchase %" := 0;
        end;
    end;

    internal procedure CalcRealizedMargin(var BETFNPlanningView: Record "BET FN Planning View"; BETFNPlanningDocument: Record "BET FN Planning Document")
    begin
        case BETFNPlanningDocument."Calculation Type" of
            // erz. Spanne (Abschlag) aus VK und EK:
            BETFNPlanningDocument."Calculation Type"::Margin:
                if BETFNPlanningView."Plan Sales Amount" <> 0 then
                    BETFNPlanningView."Plan Calc. Sales %" :=
                        (BETFNPlanningView."Plan Sales Amount" - BETFNPlanningView."Plan Cost Am. Purchase") / BETFNPlanningView."Plan Sales Amount" * 100
                else
                    BETFNPlanningView."Plan Calc. Sales %" := 0;

            // erz. Kalkulation (Aufschlag) aus VK und EK:
            BETFNPlanningDocument."Calculation Type"::Calculation:
                if BETFNPlanningView."Plan Cost Am. Purchase" <> 0 then
                    BETFNPlanningView."Plan Calc. Sales %" :=
                       (BETFNPlanningView."Plan Sales Amount" - BETFNPlanningView."Plan Cost Am. Purchase") / BETFNPlanningView."Plan Cost Am. Purchase" * 100
                else
                    BETFNPlanningView."Plan Calc. Sales %" := 0;
        end;
    end;

    internal procedure CalcSalesAmountDiffToRef(var BETFNPlanningView: Record "BET FN Planning View")
    begin
        if Round(BETFNPlanningView."Ref. Sales Amount", 0.01) <> 0 then
            BETFNPlanningView."Plan Sal. Am. Difference %" := (BETFNPlanningView."Plan Sales Amount" - BETFNPlanningView."Ref. Sales Amount") / BETFNPlanningView."Ref. Sales Amount" * 100
        else
            BETFNPlanningView."Plan Sal. Am. Difference %" := 0;
    end;

    /// <summary>
    /// StartCalculationPurchasePlan.
    /// </summary>
    /// <param name="BETFNPlanningDocument">Record "BET FN Planning Document".</param>
    /// <param name="BETFNPlanningView">VAR Record "BET FN Planning View".</param>
    /// <param name="xBETFNPlanningView">Record "BET FN Planning View".</param>
    /// <param name="CurrFieldNo">Integer.</param>
    procedure StartCalculationPurchasePlan(BETFNPlanningDocument: Record "BET FN Planning Document"; var BETFNPlanningView: Record "BET FN Planning View"; xBETFNPlanningView: Record "BET FN Planning View"; CurrFieldNo: Integer)
    var
        BETFNPlanningViewTotal: Record "BET FN Planning View";
    begin



        // Berechnungen für Limitplanung (Umsatz, Abschriften, WE, Spannen, EK-Limit)
        case CurrFieldNo of
            // Eingabe VK-Umsatz: %-Anteil und Abschriftenbetrag aktualisieren
            BETFNPlanningView.FieldNo("Plan Sales Amount"):
                begin
                    // Umsatzanteil:
                    CalcTotalAmounts(BETFNPlanningView, BETFNPlanningViewTotal, BETFNPlanningView.FieldNo("Plan Sales Amount"));

                    // Abschrift anpassen:
                    if ((100 - BETFNPlanningView."Plan Gross Sales Pr. Red. %") / 100) <> 0 then
                        BETFNPlanningView."Plan Gross Sales Pr. Reduction" := (BETFNPlanningView."Plan Sales Amount" / ((100 - BETFNPlanningView."Plan Gross Sales Pr. Red. %") / 100)) - BETFNPlanningView."Plan Sales Amount"
                    else
                        BETFNPlanningView."Plan Gross Sales Pr. Reduction" := 0;
                end;

            // Eingabe Umsatzanteil: Umsatz neu berechnen und Umsatzeingabe simulieren
            BETFNPlanningView.FieldNo("Plan Sales Percentage"):
                begin
                    CalcTotalAmounts(BETFNPlanningView, BETFNPlanningViewTotal, BETFNPlanningView.FieldNo("Plan Sales Amount"));
                    BETFNPlanningView."Plan Sales Amount" := BETFNPlanningViewTotal."Plan Sales Amount" * BETFNPlanningView."Plan Sales Percentage" / 100;
                    StartCalculationPurchasePlan(BETFNPlanningDocument, BETFNPlanningView, xBETFNPlanningView, BETFNPlanningView.FieldNo("Plan Sales Amount"));
                    exit;
                end;

            // Eingabe Plan Abschrift %: Abschriftswert neu berechnen
            BETFNPlanningView.FieldNo("Plan Gross Sales Pr. Red. %"):
                if ((100 - BETFNPlanningView."Plan Gross Sales Pr. Red. %") / 100) <> 0 then
                    BETFNPlanningView."Plan Gross Sales Pr. Reduction" := (BETFNPlanningView."Plan Sales Amount" / ((100 - BETFNPlanningView."Plan Gross Sales Pr. Red. %") / 100)) - BETFNPlanningView."Plan Sales Amount"
                else
                    BETFNPlanningView."Plan Gross Sales Pr. Reduction" := 0;

            // Eingabe VK-Limit (Wareneingang): VK-Endbestand neu berechnen
            BETFNPlanningView.FieldNo("Plan Sales Am. Purchase"):
                CalculateClosingInventory(BETFNPlanningView);

            // Eingabe Plan EK-Limit: VK-Limit und VK-Endbestand neu berechnen 
            BETFNPlanningView.FieldNo("Plan Cost Am. Purchase"):
                begin
                    if (100 - BETFNPlanningView."Plan Calc. Purchase %") <> 0 then
                        BETFNPlanningView."Plan Sales Am. Purchase" := 100 / (100 - BETFNPlanningView."Plan Calc. Purchase %") * BETFNPlanningView."Plan Cost Am. Purchase"
                    else
                        BETFNPlanningView."Plan Sales Am. Purchase" := 0;

                    CalculateClosingInventory(BETFNPlanningView);
                end;

            // Eingabe WE-Spanne: EK-Limit neu berechnen
            BETFNPlanningView.FieldNo("Plan Calc. Purchase %"):
                CalcPurchValueFromWhsRcptMargin(BETFNPlanningView, BETFNPlanningDocument);
            //BETFNPlanningView."Plan Cost Am. Purchase" := BETFNPlanningView."Plan Sales Am. Purchase" * ((100 - BETFNPlanningView."Plan Calc. Purchase %") / 100);

            BETFNPlanningView.FieldNo("Plan Calc. Sales %"):
                CalcPurchValueFromRealizedMargin(BETFNPlanningView, BETFNPlanningDocument);
        end;

        // Abweichung VJ/Plan in %:
        if Round(BETFNPlanningView."Ref. Sales Amount", 0.01) <> 0 then
            BETFNPlanningView."Plan Sal. Am. Difference %" := (BETFNPlanningView."Plan Sales Amount" - BETFNPlanningView."Ref. Sales Amount") / BETFNPlanningView."Ref. Sales Amount" * 100
        else
            BETFNPlanningView."Plan Sal. Am. Difference %" := 0;

        // Abschrift %:
        if Round((BETFNPlanningView."Plan Gross Sales Pr. Reduction" + BETFNPlanningView."Plan Sales Amount"), 1) <> 0 then
            BETFNPlanningView."Plan Gross Sales Pr. Red. %" := 100 - (BETFNPlanningView."Plan Sales Amount" / (BETFNPlanningView."Plan Gross Sales Pr. Reduction" + BETFNPlanningView."Plan Sales Amount") * 100)
        else
            BETFNPlanningView."Plan Gross Sales Pr. Red. %" := 0;

        // Limit VK:
        CalcSalesAmountPurchaseFromValues(BETFNPlanningView);

        //EK-Limit aus WE-Spanne:
        //CalcPurchValueFromWhsRcptMargin(BETFNPlanningView, BETFNPlanningDocument);


        CalcWhsRcptMargin(BETFNPlanningView, BETFNPlanningDocument);

        CalcRealizedMargin(BETFNPlanningView, BETFNPlanningDocument);


        /*
                // WE-Spanne:
                if Round(BETFNPlanningView."Plan Sales Am. Purchase", 1) <> 0 then
                    BETFNPlanningView."Plan Calc. Purchase %" := 100 - (BETFNPlanningView."Plan Cost Am. Purchase" / BETFNPlanningView."Plan Sales Am. Purchase" * 100)
                else
                    BETFNPlanningView."Plan Calc. Purchase %" := 0;

                // erz. Spanne:
                if Round(BETFNPlanningView."Plan Sales Amount", 1) <> 0 then
                    BETFNPlanningView."Plan Calc. Sales %" := 100 - (BETFNPlanningView."Plan Cost Am. Purchase" / BETFNPlanningView."Plan Sales Amount" * 100)
                else
                    BETFNPlanningView."Plan Calc. Sales %" := 0;
        */

        // Teil-Limite (NOS/Reserve/etc.) :
        CalcSingleLimitValues(BETFNPlanningView);
    end;

    /// <summary>
    /// CalculateClosingInventory.
    /// </summary>
    /// <param name="BETFNPlanningView">VAR Record "BET FN Planning View".</param>
    procedure CalculateClosingInventory(var BETFNPlanningView: Record "BET FN Planning View")
    begin
        // VK:
        BETFNPlanningView."Plan Sales Closing Inv." := BETFNPlanningView."Plan Sales Am. Purchase"
                                                        + BETFNPlanningView."Plan Sales Init. Inv."
                                                        - BETFNPlanningView."Plan Sales Discount"
                                                        - BETFNPlanningView."Plan Sales Amount";
        // EK:
        BETFNPlanningView."Plan Cost Closing Inv." := BETFNPlanningView."Plan Cost Am. Purchase"
                                                        + BETFNPlanningView."Plan Cost Init. Inv."
                                                        - BETFNPlanningView."Plan Cost of Sales";
    end;

    /// <summary>
    /// CalcSingleLimitValues.
    /// </summary>
    /// <param name="BETFNPlanningView">VAR Record "BET FN Planning View".</param>
    procedure CalcSingleLimitValues(var BETFNPlanningView: Record "BET FN Planning View")
    begin
        // Rest ausrechnen (entspr. Spalten 'Nettolimit...'):
        BETFNPlanningView."Plan Limit 5 %" := 100 - BETFNPlanningView."Plan Limit 1 %" - BETFNPlanningView."Plan Limit 2 %" -
                                              BETFNPlanningView."Plan Limit 3 %" - BETFNPlanningView."Plan Limit 4 %";

        BETFNPlanningView."Plan Sales Am. Purch. 1" := BETFNPlanningView."Plan Sales Am. Purchase" * BETFNPlanningView."Plan Limit 1 %" / 100;
        BETFNPlanningView."Plan Sales Am. Purch. 2" := BETFNPlanningView."Plan Sales Am. Purchase" * BETFNPlanningView."Plan Limit 2 %" / 100;
        BETFNPlanningView."Plan Sales Am. Purch. 3" := BETFNPlanningView."Plan Sales Am. Purchase" * BETFNPlanningView."Plan Limit 3 %" / 100;
        BETFNPlanningView."Plan Sales Am. Purch. 4" := BETFNPlanningView."Plan Sales Am. Purchase" * BETFNPlanningView."Plan Limit 4 %" / 100;
        BETFNPlanningView."Plan Sales Am. Purch. 5" := BETFNPlanningView."Plan Sales Am. Purchase" * BETFNPlanningView."Plan Limit 5 %" / 100;

        BETFNPlanningView."Plan Cost Am. Purch. 1" := BETFNPlanningView."Plan Cost Am. Purchase" * BETFNPlanningView."Plan Limit 1 %" / 100;
        BETFNPlanningView."Plan Cost Am. Purch. 2" := BETFNPlanningView."Plan Cost Am. Purchase" * BETFNPlanningView."Plan Limit 2 %" / 100;
        BETFNPlanningView."Plan Cost Am. Purch. 3" := BETFNPlanningView."Plan Cost Am. Purchase" * BETFNPlanningView."Plan Limit 3 %" / 100;
        BETFNPlanningView."Plan Cost Am. Purch. 4" := BETFNPlanningView."Plan Cost Am. Purchase" * BETFNPlanningView."Plan Limit 4 %" / 100;
        BETFNPlanningView."Plan Cost Am. Purch. 5" := BETFNPlanningView."Plan Cost Am. Purchase" * BETFNPlanningView."Plan Limit 5 %" / 100;
    end;

    internal procedure GetLimitPercentageFromPurchValue(var BETFNPlanningView: Record "BET FN Planning View")
    begin
        if Round(BETFNPlanningView."Plan Cost Am. Purchase", 1) <> 0 then begin
            BETFNPlanningView."Plan Limit 1 %" := BETFNPlanningView."Plan Cost Am. Purch. 1" * 100 / BETFNPlanningView."Plan Cost Am. Purchase";
            BETFNPlanningView."Plan Limit 2 %" := BETFNPlanningView."Plan Cost Am. Purch. 2" * 100 / BETFNPlanningView."Plan Cost Am. Purchase";
            BETFNPlanningView."Plan Limit 3 %" := BETFNPlanningView."Plan Cost Am. Purch. 3" * 100 / BETFNPlanningView."Plan Cost Am. Purchase";
            BETFNPlanningView."Plan Limit 4 %" := BETFNPlanningView."Plan Cost Am. Purch. 4" * 100 / BETFNPlanningView."Plan Cost Am. Purchase";
            BETFNPlanningView."Plan Limit 5 %" := BETFNPlanningView."Plan Cost Am. Purch. 5" * 100 / BETFNPlanningView."Plan Cost Am. Purchase";
        end else begin
            BETFNPlanningView."Plan Limit 1 %" := 0;
            BETFNPlanningView."Plan Limit 2 %" := 0;
            BETFNPlanningView."Plan Limit 3 %" := 0;
            BETFNPlanningView."Plan Limit 4 %" := 0;
            BETFNPlanningView."Plan Limit 5 %" := 0;
        end;
    end;


    /// <summary>
    /// StartCalculationSalesPlan.
    /// </summary>
    /// <param name="BETFNPlanningDocument">Record "BET FN Planning Document".</param>
    /// <param name="BETFNPlanningView">VAR Record "BET FN Planning View".</param>
    /// <param name="xBETFNPlanningView">Record "BET FN Planning View".</param>
    /// <param name="CurrFieldNo">Integer.</param>
    procedure StartCalculationSalesPlan(BETFNPlanningDocument: Record "BET FN Planning Document"; var BETFNPlanningView: Record "BET FN Planning View"; xBETFNPlanningView: Record "BET FN Planning View"; CurrFieldNo: Integer)
    var
        BETFNPlanningViewTotal: Record "BET FN Planning View";
    begin
        // Berechnungen für reine Umsatzplanung (Umsatz, %-Anteil)
        case CurrFieldNo of
            BETFNPlanningView.FieldNo("Plan Sales Percentage"):
                begin
                    CalcTotalAmounts(BETFNPlanningView, BETFNPlanningViewTotal, BETFNPlanningView.FieldNo("Plan Sales Amount"));
                    BETFNPlanningView."Plan Sales Amount" := BETFNPlanningViewTotal."Plan Sales Amount" * BETFNPlanningView."Plan Sales Percentage" / 100;
                end;

            BETFNPlanningView.FieldNo("Plan Sal. Am. Difference %"):
                if BETFNPlanningView."Ref. Sales Amount" <> 0 then
                    BETFNPlanningView."Plan Sales Amount" := (BETFNPlanningView."Plan Sal. Am. Difference %" + 100) * BETFNPlanningView."Ref. Sales Amount" / 100;
        end;

        CalcSalesAmountDiffToRef(BETFNPlanningView);        // %-Abw. Planumsatz/VJ-Umsatz
    end;

    /// <summary>
    /// CalcTotalAmounts.
    /// </summary>
    /// <param name="BETFNPlanningView">Record "BET FN Planning View".</param>
    /// <param name="BETFNPlanningViewTotal">VAR Record "BET FN Planning View".</param>
    /// <param name="FieldNo">Integer.</param>
    procedure CalcTotalAmounts(BETFNPlanningView: Record "BET FN Planning View"; var BETFNPlanningViewTotal: Record "BET FN Planning View"; FieldNo: Integer)
    var
        BETFNPlanningValueCube: Record "BET FN Planning Value Cube";
        Level: Integer;
    begin
        BETFNPlanningValueCube.Reset();
        BETFNPlanningValueCube.SetCurrentKey("Planning Document No.", "Index 1", "Index 2", "Index 3", "Index 4", "Index 5", "Index 6", Date);
        BETFNPlanningValueCube.SetRange("Planning Document No.", BETFNPlanningView."Planning Document No.");

        Level := 0;

        //### bei Datumsebene einen Ebenenindex zusätzlich filtern (Index der Viewzeile):
        if BETFNPlanningView.Date <> 0D then
            Level := 1;

        if BETFNPlanningView."Planning Document Level" > (1 - Level) then
            BETFNPlanningValueCube.SetRange("Index 1", BETFNPlanningView."Index 1");
        if BETFNPlanningView."Planning Document Level" > (2 - Level) then
            BETFNPlanningValueCube.SetRange("Index 2", BETFNPlanningView."Index 2");
        if BETFNPlanningView."Planning Document Level" > (3 - Level) then
            BETFNPlanningValueCube.SetRange("Index 3", BETFNPlanningView."Index 3");
        if BETFNPlanningView."Planning Document Level" > (4 - Level) then
            BETFNPlanningValueCube.SetRange("Index 4", BETFNPlanningView."Index 4");
        if BETFNPlanningView."Planning Document Level" > (5 - Level) then
            BETFNPlanningValueCube.SetRange("Index 5", BETFNPlanningView."Index 5");

        if FieldNo = BETFNPlanningView.FieldNo("Plan Sales Amount") then begin
            BETFNPlanningValueCube.CalcSums("Plan Sales Amount");
            BETFNPlanningViewTotal."Plan Sales Amount" := BETFNPlanningValueCube."Plan Sales Amount";
        end;
    end;

    /// <summary>
    /// CheckTotalLimitPercentage.
    /// </summary>
    /// <param name="BETFNPlanningView">Record "BET FN Planning View".</param>
    procedure CheckTotalLimitPercentage(BETFNPlanningView: Record "BET FN Planning View")
    var
        ErrorLbl: Label 'Total percentage must be less or equal 100 percent';
    begin
        if (BETFNPlanningView."Plan Limit 1 %" + BETFNPlanningView."Plan Limit 2 %" + BETFNPlanningView."Plan Limit 3 %" + BETFNPlanningView."Plan Limit 4 %") > 100 then
            Error(ErrorLbl);
    end;

    /// <summary>
    /// CalcLinePercentage.
    /// </summary>
    /// <param name="BETFNPlanningView">VAR Record "BET FN Planning View".</param>
    /// <param name="BETFNPlanningDocument">Record "BET FN Planning Document".</param>
    /// <param name="UpdatePercentage_P">Boolean.</param>
    procedure CalcLinePercentage(var BETFNPlanningView: Record "BET FN Planning View"; BETFNPlanningDocument: Record "BET FN Planning Document"; UpdatePercentage_P: Boolean)
    var
        BETFNPlanningType: Record "BET FN Planning Type";
        BETFNPlanningValueCube: Record "BET FN Planning Value Cube";
        Level: Integer;
    begin
        BETFNPlanningValueCube.Reset();
        BETFNPlanningValueCube.SetCurrentKey("Planning Document No.", "Index 1", "Index 2", "Index 3", "Index 4", "Index 5", "Index 6", Date);
        BETFNPlanningValueCube.SetRange("Planning Document No.", BETFNPlanningView."Planning Document No.");

        Level := 0;

        //### bei Datumsebene einen Ebenenindex zusätzlich filtern (Index der Viewzeile):
        if BETFNPlanningView.Date <> 0D then
            Level := 1;

        if BETFNPlanningView."Planning Document Level" > (1 - Level) then
            BETFNPlanningValueCube.SetRange("Index 1", BETFNPlanningView."Index 1");
        if BETFNPlanningView."Planning Document Level" > (2 - Level) then
            BETFNPlanningValueCube.SetRange("Index 2", BETFNPlanningView."Index 2");
        if BETFNPlanningView."Planning Document Level" > (3 - Level) then
            BETFNPlanningValueCube.SetRange("Index 3", BETFNPlanningView."Index 3");
        if BETFNPlanningView."Planning Document Level" > (4 - Level) then
            BETFNPlanningValueCube.SetRange("Index 4", BETFNPlanningView."Index 4");
        if BETFNPlanningView."Planning Document Level" > (5 - Level) then
            BETFNPlanningValueCube.SetRange("Index 5", BETFNPlanningView."Index 5");


        if BETFNPlanningType.Get(BETFNPlanningDocument."Planning Type") and
            (BETFNPlanningType."Planning Process Type" = BETFNPlanningType."Planning Process Type"::SalesPlan) then begin

            BETFNPlanningValueCube.CalcSums("Plan Sales Amount");

            //### optional gleich ins Rec zurückschreiben:
            if UpdatePercentage_P then
                if Round(BETFNPlanningValueCube."Plan Sales Amount", 1) <> 0 then
                    BETFNPlanningView."Plan Sales Percentage" := BETFNPlanningView."Plan Sales Amount" / BETFNPlanningValueCube."Plan Sales Amount" * 100
                else
                    BETFNPlanningView."Plan Sales Percentage" := 0;
        end;

        // optional weitere Werte berechnen: 
        OnAfterCalcLinePercentage(BETFNPlanningView, BETFNPlanningValueCube, BETFNPlanningType);
    end;

    internal procedure UpdatePercentages(var BETFNPlanningViewPar: Record "BET FN Planning View"; PlanDoc_LT: Record "BET FN Planning Document")
    var
        BETFNPlanningView: Record "BET FN Planning View";
        BETFNCalculatePlanningVals: Codeunit "BET FN Calculate Planning Vals";
    begin
        // some checks?
        // ...

        BETFNPlanningView.Reset();
        BETFNPlanningView.CopyFilters(BETFNPlanningViewPar);
        BETFNPlanningView.SetRange("To Update (Plan)");
        if BETFNPlanningView.FindSet(true) then
            repeat
                BETFNCalculatePlanningVals.CalcLinePercentage(BETFNPlanningView, PlanDoc_LT, true);
                BETFNPlanningView.Modify();
            until BETFNPlanningView.Next() = 0;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeStartCalculation(var BETFNPlanningView: Record "BET FN Planning View"; xBETFNPlanningView: Record "BET FN Planning View"; CurrFieldNo: Integer; var IsHandled: Boolean)
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCalcLinePercentage(var BETFNPlanningView: Record "BET FN Planning View"; var BETFNPlanningValueCube: Record "BET FN Planning Value Cube"; BETFNPlanningType: Record "BET FN Planning Type")
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCalculation(var BETFNPlanningView: Record "BET FN Planning View"; xBETFNPlanningView: Record "BET FN Planning View"; CurrFieldNo: Integer)
    begin
    end;
}

