/// <summary>
/// [planning]
/// Modules: 
/// </summary>
page 5138664 "BET FN Planning Statistic Card"
{
    ApplicationArea = All;
    Caption = 'Planning Statistic Card';
    DataCaptionExpression = '';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "BET FN Planning Statistic";
    UsageCategory = ReportsAndAnalysis;
    Extensible = true;

    layout
    {
        area(Content)
        {
            group(Filters)
            {
                Caption = 'Filters';
                field("Date Filter"; DateFilter_G)
                {
                    ToolTip = 'Specifies the Date Filter.';
                    Caption = 'Date filter';

                    trigger OnValidate()
                    begin
                        UpdateValues();
                        CurrPage.Update();
                    end;
                }
                field("Country Filter"; CountryFilter_G)
                {
                    ToolTip = 'Specifies the Country Filter.';
                    Caption = 'Country filter';
                    TableRelation = "Country/Region";

                    trigger OnValidate()
                    begin
                        UpdateValues();
                    end;
                }
                field("Location Filter"; LocFilter_G)
                {
                    ToolTip = 'Specifies the Location Filter.';
                    Caption = 'Location filter';
                    TableRelation = Location;

                    trigger OnValidate()
                    begin
                        UpdateValues();
                    end;
                }
                field("Brand Filter"; BrandFilter_G)
                {
                    ToolTip = 'Specifies the Brand Filter.';
                    Caption = 'Brand filter';
                    TableRelation = "BET FN Brand";

                    trigger OnValidate()
                    begin
                        UpdateValues();
                    end;
                }
                field("Division Filter"; DivisFilter_G)
                {
                    ToolTip = 'Specifies the Division Filter.';
                    Caption = 'Division filter';
                    TableRelation = "BET FN Division";

                    trigger OnValidate()
                    begin
                        UpdateValues();
                    end;
                }
                field("Main WG Filter"; MainWGFilter_G)
                {
                    ToolTip = 'Specifies the Main WG Filter.';
                    Caption = 'Main waregroup filter';
                    TableRelation = "BET FN Main Waregroup";

                    trigger OnValidate()
                    begin
                        UpdateValues();
                    end;
                }
                field("Item Cat. Filter"; ItemCatFilter_G)
                {
                    ToolTip = 'Specifies the item category filter.';
                    Caption = 'Warengruppenfilter';
                    TableRelation = "Item Category";

                    trigger OnValidate()
                    begin
                        UpdateValues();
                    end;
                }
                field("Season Filter"; SeasonFilter_G)
                {
                    ToolTip = 'Specifies the Season Filter.';
                    Caption = ' Season filter';
                    TableRelation = "BET FN Season";

                    trigger OnValidate()
                    begin
                        UpdateValues();
                    end;
                }
            }
            group("Planning Entries")
            {
                Caption = 'Planning Entries';
                group(SalesAmount)
                {
                    Caption = 'VK';
                    field("OTB Gross Sales Amount"; Rec."OTB Gross Sales Amount")
                    {
                        Caption = 'Gross Sales Amount';
                        DecimalPlaces = 0 : 0;
                        Editable = false;
                    }
                    field("OTB Sales Am. Purchase"; Rec."OTB Sales Am. Purchase")
                    {
                        Caption = 'Sales Am. Purchase';
                        DecimalPlaces = 0 : 0;
                        Editable = false;
                    }
                    field("OTB Sales Closing Inv."; Rec."OTB Sales Closing Inv.")
                    {
                        Caption = 'Sales Closing Inv.';
                        DecimalPlaces = 0 : 0;
                        Editable = false;
                    }
                    field("OTB Gross Sales Pr. Reduction"; Rec."OTB Gross Sales Pr. Reduction")
                    {
                        Caption = 'Gross Sales Pr. Reduction';
                        DecimalPlaces = 0 : 0;
                        Editable = false;
                    }
                    field("OTB Sal. Am. Discount"; Rec."OTB Sal. Am. Discount")
                    {
                        Caption = 'Sal. Am. Discount';
                        DecimalPlaces = 0 : 0;
                        Editable = false;
                    }
                }
                group(CostAmount)
                {
                    Caption = 'EK';
                    field("OTB Cost Of Sales"; Rec."OTB Cost Of Sales")
                    {
                        Caption = 'Cost Of Sales';
                        DecimalPlaces = 0 : 0;
                        Editable = false;
                    }
                    field("OTB Cost Am. Purchase"; Rec."OTB Cost Am. Purchase")
                    {
                        Caption = 'Cost Am. Purchase';
                        DecimalPlaces = 0 : 0;
                        Editable = false;
                    }
                    field("OTB Cost Closing Inv."; Rec."OTB Cost Closing Inv.")
                    {
                        Caption = 'Cost Closing Inv.';
                        DecimalPlaces = 0 : 0;
                        Editable = false;
                    }
                }
                group(Quantity)
                {
                    Caption = 'Planning Entries';
                    field("OTB Sales Quantity"; Rec."OTB Sales Quantity")
                    {
                        Caption = 'Sale Quantity';
                        Editable = false;
                    }
                    field("OTB Qty. Purchase"; Rec."OTB Qty. Purchase")
                    {
                        Caption = 'Qty. Purchase';
                        Editable = false;
                    }
                    field("OTB Qty. Closing Inv."; Rec."OTB Qty. Closing Inv.")
                    {
                        Caption = 'Qty. Closing Inv.';
                        Editable = false;
                    }
                }
            }
            group("Statistic Entries")
            {
                Caption = 'Statistic Entries';
                Visible = false;
                group(Control1117300020)
                {
                    Caption = 'Statistic Entries';
                    field("FSE Sale Quantity"; TempPlanStat_GTT."FSE Sale Quantity")
                    {
                        Caption = 'FSE sale quantity';
                        Editable = false;
                    }
                    field("FSE Sale Value (Cost)"; TempPlanStat_GTT."FSE Sale Value (Cost)")
                    {
                        Caption = 'FSE sale value (cost)';
                        Editable = false;
                    }
                    field("FSE Sale Value"; TempPlanStat_GTT."FSE Sale Value")
                    {
                        Caption = 'FSE sale value';
                        Editable = false;
                    }
                    field("FSE Purchase Quantity"; TempPlanStat_GTT."FSE Purchase Quantity")
                    {
                        Caption = 'FSE purchase quantity';
                        Editable = false;
                    }
                    field("FSE Purchase Value (Cost)"; TempPlanStat_GTT."FSE Purchase Value (Cost)")
                    {
                        Caption = 'FSE purchase value (cost)';
                        Editable = false;
                    }
                    field("FSE Purchase Value"; TempPlanStat_GTT."FSE Purchase Value")
                    {
                        Caption = 'FSE purchase value';
                        Editable = false;
                    }
                    field("FSE Inventory Quantity"; TempPlanStat_GTT."FSE Inventory Quantity")
                    {
                        Caption = 'FSE inventory quantity';
                        Editable = false;
                    }
                    field("FSE Inventory Value (Cost)"; TempPlanStat_GTT."FSE Inventory Value (Cost)")
                    {
                        Caption = 'FSE inventory value (cost)';
                        Editable = false;
                    }
                    field("FSE Inventory Value"; TempPlanStat_GTT."FSE Inventory Value")
                    {
                        Caption = 'FSE inventory value';
                        Editable = false;
                    }
                    field("FSE Gross Discount"; TempPlanStat_GTT."FSE Gross Discount")
                    {
                        Caption = 'FSE gross discount';
                        DecimalPlaces = 0 : 0;
                        Editable = false;
                    }
                    field("FSE G.S.P. Reduction"; TempPlanStat_GTT."FSE G.S.P. Reduction")
                    {
                        Caption = 'FSE reduction';
                        Editable = false;
                    }
                    field("FSE Change in GS-Prices"; TempPlanStat_GTT."FSE Change in GS-Prices")
                    {
                        Caption = 'FSE change gross sales in prices';
                        DecimalPlaces = 0 : 0;
                        Editable = false;
                    }
                }
                group("Order Statistic")
                {
                    Caption = 'Order Statistic';
                    field("PSE Outstanding Qty."; Rec."PSE Outstanding Qty.")
                    {
                        Caption = 'PSE outstanding qty.';
                        DecimalPlaces = 0 : 0;
                        Editable = false;
                    }
                    field("PSE Outst. Gross Sal. Amt."; Rec."PSE Outst. Gross Sal. Amt.")
                    {
                        Caption = 'PSE oustanding gross sales amount';
                        DecimalPlaces = 0 : 0;
                        Editable = false;
                    }
                    field("PSE Outstanding Amount"; Rec."PSE Outstanding Amount")
                    {
                        Caption = 'PSE outstanding amount';
                        DecimalPlaces = 0 : 0;
                        Editable = false;
                    }
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        TempPlanStat_GTT.Init();
    end;

    var
        TempPlanStat_GTT: Record "BET FN Planning Statistic" temporary;
        BrandFilter_G: Text;
        CountryFilter_G: Text;
        DateFilter_G: Text;
        DivisFilter_G: Text;
        ItemCatFilter_G: Text;
        LocFilter_G: Text;
        MainWGFilter_G: Text;
        SeasonFilter_G: Text;

    /// <summary>
    /// UpdateValues.
    /// </summary>
    procedure UpdateValues()
    begin
        TempPlanStat_GTT.Reset();
        TempPlanStat_GTT.SetFilter(DateFilter, DateFilter_G);
        TempPlanStat_GTT.SetFilter(LocFilter, LocFilter_G);
        TempPlanStat_GTT.SetFilter(ItemCatFilter, ItemCatFilter_G);
        TempPlanStat_GTT.SetFilter(SeasonFilter, SeasonFilter_G);
        TempPlanStat_GTT.SetFilter(CountryFilter, CountryFilter_G);
        TempPlanStat_GTT.SetFilter(DivisFilter, DivisFilter_G);
        TempPlanStat_GTT.SetFilter(MainWGFilter, MainWGFilter_G);
        TempPlanStat_GTT.SetFilter(BrandFilter, BrandFilter_G);

        TempPlanStat_GTT.CalcFields("FSE Sale Quantity",
                                "FSE Sale Value (Cost)",
                                "FSE Sale Value",
                                "FSE Purchase Quantity",
                                "FSE Purchase Value (Cost)",
                                "FSE Purchase Value",
                                "FSE Inventory Quantity",
                                "FSE Inventory Value (Cost)",
                                "FSE Inventory Value",
                                "FSE G.S.P. Reduction",
                                "FSE Gross Discount",
                                "FSE Change in GS-Prices",
                                "FSE Adjmt. Quantity",
                                "FSE Adjmt. Value (Cost)",
                                "FSE Adjmt. Value",

                                "PSE Outstanding Qty.",
                                "PSE Outst. Gross Sal. Amt.",
                                "PSE Outstanding Amount"
                                );





        Rec.Reset();
        Rec.SetFilter(DateFilter, DateFilter_G);
        Rec.SetFilter(LocFilter, LocFilter_G);
        Rec.SetFilter(ItemCatFilter, ItemCatFilter_G);
        Rec.SetFilter(SeasonFilter, SeasonFilter_G);
        Rec.SetFilter(CountryFilter, CountryFilter_G);
        Rec.SetFilter(DivisFilter, DivisFilter_G);
        Rec.SetFilter(MainWGFilter, MainWGFilter_G);
        Rec.SetFilter(BrandFilter, BrandFilter_G);
        Rec.CalcFields("OTB Sales Quantity"
                  , "OTB Cost Of Sales"
                  , "OTB Gross Sales Amount"
                  , "OTB Qty. Purchase"
                  , "OTB Cost Am. Purchase"
                  , "OTB Sales Am. Purchase"
                  , "OTB Qty. Closing Inv."
                  , "OTB Cost Closing Inv."
                  , "OTB Sales Closing Inv."
                  , "OTB Gross Sales Pr. Reduction"
                  , "OTB Qty. Init. Inv."
                  , "OTB Cost Init. Inv."
                  , "OTB Sales Init. Inv."
                  , "OTB Sal. Am. Discount"
                  );


        CurrPage.Update();
    end;
}

