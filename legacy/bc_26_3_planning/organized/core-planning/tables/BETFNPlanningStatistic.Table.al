/// <summary>
/// [planning]
/// Modules: 
/// </summary>
table 5138652 "BET FN Planning Statistic"
{

    Caption = 'Planning Statistic';
    DataClassification = CustomerContent;
    Access = Public;
    Extensible = true;

    fields
    {
        field(1; Index; Integer)
        {
            Caption = 'Primary Key';
        }
        field(2; DateFilter; Date)
        {

            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(3; ItemFilter; Code[20])
        {

            Caption = 'Item Filter';
            FieldClass = FlowFilter;
            TableRelation = Item;
        }
        field(4; ColourFilter; Code[35])
        {

            Caption = 'Colour Filter';
            FieldClass = FlowFilter;
            TableRelation = "BET FN Colours Assigned"."Colour Code" where("Item No." = field(ItemFilter));
        }
        field(5; SizeRunFilter; Code[10])
        {

            Caption = 'Size Run Filter';
            FieldClass = FlowFilter;
            TableRelation = "BET FN Size Runs Total";
        }
        field(6; SizeFilter; Code[10])
        {

            Caption = 'Size Filter';
            FieldClass = FlowFilter;
            TableRelation = "BET FN Sizes Assigned".Size where("Size Run" = field(SizeRunFilter));
        }
        field(7; LocFilter; Code[10])
        {

            Caption = 'Location Filter';
            FieldClass = FlowFilter;
            TableRelation = Location;
        }
        field(8; ItemCatFilter; Code[20])
        {

            Caption = 'Item Category Filter';
            FieldClass = FlowFilter;
            TableRelation = "Item Category";
        }
        field(9; LocationGroupFilter; Code[10])
        {

            Caption = 'Lagerortgruppenfilter';
            FieldClass = FlowFilter;
            TableRelation = "BET FN Location Group";
        }
        field(10; VendorFilter; Code[20])
        {

            Caption = 'Vendor Filter';
            FieldClass = FlowFilter;
            TableRelation = Vendor;
        }
        field(11; SeasonFilter; Code[10])
        {

            Caption = 'Season Filter';
            FieldClass = FlowFilter;
            TableRelation = "BET FN Season";
        }
        field(12; PriceFilter; Decimal)
        {

            Caption = 'Price Filter';
            FieldClass = FlowFilter;
            TableRelation = "BET FN Price Class Rngs";
        }
        field(13; CountryFilter; Code[10])
        {

            Caption = 'Country Filter';
            FieldClass = FlowFilter;
            TableRelation = "Country/Region";
        }
        field(14; PurchFilter; Code[20])
        {

            Caption = 'Purchaser Filter';
            FieldClass = FlowFilter;
            TableRelation = "Salesperson/Purchaser";
        }
        field(15; SrcTypeFilter; Option)
        {

            Caption = 'Source Type Filter';
            FieldClass = FlowFilter;
            OptionCaption = ' ,Customer,Vendor,Item,Contact';
            OptionMembers = " ",Customer,Vendor,Item,Contact;
        }
        field(16; SrcNoFilter; Code[20])
        {

            Caption = 'Source No. Filter';
            FieldClass = FlowFilter;
            TableRelation = if (SrcTypeFilter = const(Customer)) Customer."No."
            else
            if (SrcTypeFilter = const(Contact)) Contact."No."
            else
            if (SrcTypeFilter = const(Vendor)) Vendor."No."
            else
            if (SrcTypeFilter = const(Item)) Item."No.";

            trigger OnLookup()
            var
                Contact_LT: Record Contact;
                Customer_LT: Record Customer;
                Item_LT: Record Item;
                Vendor_LT: Record Vendor;
            begin
                case GetFilter(SrcTypeFilter) of
                    'Debitor':
                        begin
                            Customer_LT.Reset();
                            if Customer_LT.Find('-') then;
                            if Page.RunModal(0, Customer_LT) = Action::LookupOK then
                                SetRange(SrcNoFilter, Customer_LT."No.");
                        end;
                    'Kreditor':
                        begin
                            Vendor_LT.Reset();
                            if Vendor_LT.Find('-') then;
                            if Page.RunModal(0, Vendor_LT) = Action::LookupOK then
                                SetRange(SrcNoFilter, Vendor_LT."No.");
                        end;
                    'Artikel':
                        begin
                            Item_LT.Reset();
                            Item_LT.SetRange(Blocked, false);
                            if Item_LT.Find('-') then;
                            if Page.RunModal(0, Item_LT) = Action::LookupOK then
                                SetRange(SrcNoFilter, Item_LT."No.");
                        end;
                    'Kunde':
                        begin
                            Contact_LT.Reset();
                            if Contact_LT.Find('-') then;
                            if Page.RunModal(0, Contact_LT) = Action::LookupOK then
                                SetRange(SrcNoFilter, Contact_LT."No.");
                        end;
                end;
            end;
        }
        field(17; SeasonTypeFilter; Option)
        {

            Caption = 'SeasonTypeFilter';
            FieldClass = FlowFilter;
            OptionCaption = 'Complete year,Summer,Winter';
            OptionMembers = "Complete year",Summer,Winter;
        }
        field(23; DivisFilter; Code[10])
        {

            Caption = 'Division Filter';
            FieldClass = FlowFilter;
            TableRelation = "BET FN Division";
            ValidateTableRelation = false;
        }
        field(24; MainWGFilter; Code[10])
        {

            Caption = 'Main Waregroup Filter';
            FieldClass = FlowFilter;
            TableRelation = "BET FN Main Waregroup";
            ValidateTableRelation = false;
        }
        field(25; BrandFilter; Text[30])
        {

            Caption = 'Brand Filter';
            FieldClass = FlowFilter;
            TableRelation = "BET FN Brand";
        }
        field(26; FDim1; Code[20])
        {

            Caption = 'Fashiondimension 1 Filter';
            FieldClass = FlowFilter;

            trigger OnLookup()
            var
                FashionSetup_LT: Record "BET FN Fashion Setup";
                DimensionValue_LT: Record "Dimension Value";
            begin
                FashionSetup_LT.Get();
                DimensionValue_LT.Reset();
                DimensionValue_LT.SetRange("Dimension Code", FashionSetup_LT.FDim1);
                if DimensionValue_LT.Find('-') then;
                if Page.RunModal(0, DimensionValue_LT) = Action::LookupOK then begin
                    SetFilter(FDim1, DimensionValue_LT.Code);
                    Validate(FDim1, DimensionValue_LT.Code);
                end
            end;
        }
        field(27; FDim2; Code[20])
        {

            Caption = 'Fashiondimension 2 Filter';
            FieldClass = FlowFilter;

            trigger OnLookup()
            var
                FashionSetup_LT: Record "BET FN Fashion Setup";
                DimensionValue_LT: Record "Dimension Value";
            begin
                FashionSetup_LT.Get();
                DimensionValue_LT.Reset();
                DimensionValue_LT.SetRange("Dimension Code", FashionSetup_LT.FDim2);
                if DimensionValue_LT.Find('-') then;
                if Page.RunModal(Page::"Dimension Value List", DimensionValue_LT) = Action::LookupOK then begin
                    SetFilter(FDim2, DimensionValue_LT.Code);
                    Validate(FDim2, DimensionValue_LT.Code);
                end;
            end;
        }
        field(28; FDim3; Code[20])
        {

            Caption = 'Fashiondimension 3 Filter';
            FieldClass = FlowFilter;

            trigger OnLookup()
            var
                FashionSetup_LT: Record "BET FN Fashion Setup";
                DimensionValue_LT: Record "Dimension Value";
            begin
                FashionSetup_LT.Get();
                DimensionValue_LT.Reset();
                DimensionValue_LT.SetRange("Dimension Code", FashionSetup_LT.FDim3);
                if DimensionValue_LT.Find('-') then;
                if Page.RunModal(Page::"Dimension Value List", DimensionValue_LT) = Action::LookupOK then begin
                    SetFilter(FDim3, DimensionValue_LT.Code);
                    Validate(FDim3, DimensionValue_LT.Code);
                end;
            end;
        }
        field(29; FDim4; Code[20])
        {

            Caption = 'Fashiondimension 4 Filter';
            FieldClass = FlowFilter;

            trigger OnLookup()
            var
                FashionSetup_LT: Record "BET FN Fashion Setup";
                DimensionValue_LT: Record "Dimension Value";
            begin
                FashionSetup_LT.Get();
                DimensionValue_LT.Reset();
                DimensionValue_LT.SetRange("Dimension Code", FashionSetup_LT.FDim4);
                if DimensionValue_LT.Find('-') then;
                if Page.RunModal(Page::"Dimension Value List", DimensionValue_LT) = Action::LookupOK then begin
                    SetFilter(FDim4, DimensionValue_LT.Code);
                    Validate(FDim4, DimensionValue_LT.Code);
                end;
            end;
        }
        field(30; FDim5; Code[20])
        {

            Caption = 'Fashiondimension 5 Filter';
            FieldClass = FlowFilter;

            trigger OnLookup()
            var
                FashionSetup_LT: Record "BET FN Fashion Setup";
                DimensionValue_LT: Record "Dimension Value";
            begin
                FashionSetup_LT.Get();
                DimensionValue_LT.Reset();
                DimensionValue_LT.SetRange("Dimension Code", FashionSetup_LT.FDim5);
                if DimensionValue_LT.Find('-') then;
                if Page.RunModal(Page::"Dimension Value List", DimensionValue_LT) = Action::LookupOK then begin
                    SetFilter(FDim5, DimensionValue_LT.Code);
                    Validate(FDim5, DimensionValue_LT.Code);
                end;
            end;
        }
        field(31; FDim6; Code[20])
        {

            Caption = 'Fashiondimension 6 Filter';
            FieldClass = FlowFilter;

            trigger OnLookup()
            var
                FashionSetup_LT: Record "BET FN Fashion Setup";
                DimensionValue_LT: Record "Dimension Value";
            begin
                FashionSetup_LT.Get();
                DimensionValue_LT.Reset();
                DimensionValue_LT.SetRange("Dimension Code", FashionSetup_LT.FDim6);
                if DimensionValue_LT.Find('-') then;
                if Page.RunModal(Page::"Dimension Value List", DimensionValue_LT) = Action::LookupOK then begin
                    SetFilter(FDim6, DimensionValue_LT.Code);
                    Validate(FDim6, DimensionValue_LT.Code);
                end;
            end;
        }
        field(32; FDim7; Code[20])
        {

            Caption = 'Fashiondimension 7 Filter';
            FieldClass = FlowFilter;

            trigger OnLookup()
            var
                FashionSetup_LT: Record "BET FN Fashion Setup";
                DimensionValue_LT: Record "Dimension Value";
            begin
                FashionSetup_LT.Get();
                DimensionValue_LT.Reset();
                DimensionValue_LT.SetRange("Dimension Code", FashionSetup_LT.FDim7);
                if DimensionValue_LT.Find('-') then;
                if Page.RunModal(Page::"Dimension Value List", DimensionValue_LT) = Action::LookupOK then begin
                    SetFilter(FDim7, DimensionValue_LT.Code);
                    Validate(FDim7, DimensionValue_LT.Code);
                end;
            end;
        }
        field(33; FDim8; Code[20])
        {

            Caption = 'Fashiondimension 8 Filter';
            FieldClass = FlowFilter;

            trigger OnLookup()
            var
                FashionSetup_LT: Record "BET FN Fashion Setup";
                DimensionValue_LT: Record "Dimension Value";
            begin
                FashionSetup_LT.Get();
                DimensionValue_LT.Reset();
                DimensionValue_LT.SetRange("Dimension Code", FashionSetup_LT.FDim8);
                if DimensionValue_LT.Find('-') then;
                if Page.RunModal(Page::"Dimension Value List", DimensionValue_LT) = Action::LookupOK then begin
                    SetFilter(FDim8, DimensionValue_LT.Code);
                    Validate(FDim8, DimensionValue_LT.Code);
                end;
            end;
        }
        field(34; FDim9; Code[20])
        {

            Caption = 'Fashiondimension 9 Filter';
            FieldClass = FlowFilter;

            trigger OnLookup()
            var
                FashionSetup_LT: Record "BET FN Fashion Setup";
                DimensionValue_LT: Record "Dimension Value";
            begin
                FashionSetup_LT.Get();
                DimensionValue_LT.Reset();
                DimensionValue_LT.SetRange("Dimension Code", FashionSetup_LT.FDim9);
                if DimensionValue_LT.Find('-') then;
                if Page.RunModal(Page::"Dimension Value List", DimensionValue_LT) = Action::LookupOK then begin
                    SetFilter(FDim9, DimensionValue_LT.Code);
                    Validate(FDim9, DimensionValue_LT.Code);
                end;
            end;
        }
        field(35; FDim10; Code[20])
        {

            Caption = 'Fashiondimension 10 Filter';
            FieldClass = FlowFilter;

            trigger OnLookup()
            var
                FashionSetup_LT: Record "BET FN Fashion Setup";
                DimensionValue_LT: Record "Dimension Value";
            begin
                FashionSetup_LT.Get();
                DimensionValue_LT.Reset();
                DimensionValue_LT.SetRange("Dimension Code", FashionSetup_LT.FDim10);
                if DimensionValue_LT.Find('-') then;
                if Page.RunModal(Page::"Dimension Value List", DimensionValue_LT) = Action::LookupOK then begin
                    SetFilter(FDim10, DimensionValue_LT.Code);
                    Validate(FDim10, DimensionValue_LT.Code);
                end;
            end;
        }
        field(65; GDim1; Code[20])
        {

            CaptionClass = '1,3,1';
            Caption = 'Global Dimension 1 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(66; GDim2; Code[20])
        {

            CaptionClass = '1,3,2';
            Caption = 'Global Dimension 2 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(67; AgentFilter; Code[20])
        {

            Caption = 'Agent Filter';
            FieldClass = FlowFilter;
            TableRelation = "BET FN Agent";
        }
        field(68; "Order Type Filter"; Option)
        {

            Caption = 'Order Type Filter';
            FieldClass = FlowFilter;
            OptionCaption = ' ,Preorder,Immediatly Order,Sample,Special';
            OptionMembers = " ",Preorder,"Immediatly Order",Sample,Special;
        }
        field(69; CustomerFilter; Code[20])
        {

            Caption = 'Customer Filter';
            FieldClass = FlowFilter;
        }
        field(70; PriceRangeFilter; Code[20])
        {

            Caption = 'PriceRangeFilter';
            FieldClass = FlowFilter;
        }
        field(110; "Planning Document No."; Code[20])
        {

            Caption = 'Planning Document No.';
            Editable = false;
            FieldClass = FlowFilter;
        }
        field(112; "Index 1"; Code[20])
        {

            Editable = false;
            FieldClass = FlowFilter;
        }
        field(113; "Index 2"; Code[20])
        {

            Editable = false;
            FieldClass = FlowFilter;
        }
        field(114; "Index 3"; Code[20])
        {

            Editable = false;
            FieldClass = FlowFilter;
        }
        field(115; "Index 4"; Code[20])
        {

            Editable = false;
            FieldClass = FlowFilter;
        }
        field(116; "Index 5"; Code[20])
        {

            Editable = false;
            FieldClass = FlowFilter;
        }
        field(117; "Index 6"; Code[20])
        {

            FieldClass = FlowFilter;
        }
        field(124; "Planning Document Level"; Integer)
        {

            Caption = 'Planning Document Level vert.';
            Editable = false;
            FieldClass = FlowFilter;
        }
        field(127; Fixed; Boolean)
        {

            Caption = 'Fixed';
            FieldClass = FlowFilter;
        }
        field(201; "OTB Sales Quantity"; Decimal)
        {

            CalcFormula = sum("BET FN Planning Entry (DWH)"."Plan Qty. Sale" where("Posting Date" = field(DateFilter),
                                                                             Division = field(DivisFilter),
                                                                             "Item No." = field(ItemFilter),
                                                                             "Location Code" = field(LocFilter),
                                                                             "Main Waregroup" = field(MainWGFilter),
                                                                             "Customer No." = field(SrcNoFilter),
                                                                             "Vendor No." = field(VendorFilter),
                                                                             Brand = field(BrandFilter),
                                                                             Season = field(SeasonFilter),
                                                                             Agent = field(AgentFilter),
                                                                             "Item Category" = field(ItemCatFilter),
                                                                             "Country Code" = field(CountryFilter),
                                                                             "Planning Document No." = field("Planning Document No."),
                                                                             FDim1 = field(FDim1),
                                                                             FDim2 = field(FDim2),
                                                                             FDim3 = field(FDim3),
                                                                             FDim4 = field(FDim4),
                                                                             FDim5 = field(FDim5),
                                                                             FDim6 = field(FDim6),
                                                                             FDim7 = field(FDim7),
                                                                             FDim8 = field(FDim8),
                                                                             FDim9 = field(FDim9),
                                                                             FDim10 = field(FDim10)));
            Caption = 'OTB Sale Quantity';
            DecimalPlaces = 0 : 0;
            Editable = false;
            FieldClass = FlowField;
            ToolTip = 'Specifies the OTB Sales Quantity.';
        }
        field(202; "OTB Cost Of Sales"; Decimal)
        {

            CalcFormula = sum("BET FN Planning Entry (DWH)"."Plan Cost of Sales" where("Posting Date" = field(DateFilter),
                Division = field(DivisFilter),
                "Item No." = field(ItemFilter),
                "Location Code" = field(LocFilter),
                "Main Waregroup" = field(MainWGFilter),
                "Customer No." = field(SrcNoFilter),
                "Vendor No." = field(VendorFilter),
                Brand = field(BrandFilter),
                Season = field(SeasonFilter),
                Agent = field(AgentFilter),
                "Item Category" = field(ItemCatFilter),
                "Country Code" = field(CountryFilter),
                "Planning Document No." = field("Planning Document No."),
                FDim1 = field(FDim1),
                FDim2 = field(FDim2),
                FDim3 = field(FDim3),
                FDim4 = field(FDim4),
                FDim5 = field(FDim5),
                FDim6 = field(FDim6),
                FDim7 = field(FDim7),
                FDim8 = field(FDim8),
                FDim9 = field(FDim9),
                FDim10 = field(FDim10)));
            Caption = 'OTB Cost Of Sales';
            Editable = false;
            FieldClass = FlowField;
            ToolTip = 'Specifies the OTB Cost Of Sales.';
        }
        field(203; "OTB Gross Sales Amount"; Decimal)
        {

            CalcFormula = sum("BET FN Planning Entry (DWH)"."Plan Sales Amount" where("Posting Date" = field(DateFilter),
                Division = field(DivisFilter),
                "Item No." = field(ItemFilter),
                "Location Code" = field(LocFilter),
                "Main Waregroup" = field(MainWGFilter),
                "Customer No." = field(SrcNoFilter),
                "Vendor No." = field(VendorFilter),
                Brand = field(BrandFilter),
                Season = field(SeasonFilter),
                Agent = field(AgentFilter),
                "Item Category" = field(ItemCatFilter),
                "Country Code" = field(CountryFilter),
                "Planning Document No." = field("Planning Document No."),
                FDim1 = field(FDim1),
                FDim2 = field(FDim2),
                FDim3 = field(FDim3),
                FDim4 = field(FDim4),
                FDim5 = field(FDim5),
                FDim6 = field(FDim6),
                FDim7 = field(FDim7),
                FDim8 = field(FDim8),
                FDim9 = field(FDim9),
                FDim10 = field(FDim10)));
            Caption = 'OTB Gross Sales Amount';
            Editable = false;
            FieldClass = FlowField;
            ToolTip = 'Specifies the OTB Gross Sales Amount.';
        }
        field(204; "OTB Qty. Purchase"; Decimal)
        {

            CalcFormula = sum("BET FN Planning Entry (DWH)"."Plan Qty. Purchase" where("Posting Date" = field(DateFilter),
                Division = field(DivisFilter),
                "Item No." = field(ItemFilter),
                "Location Code" = field(LocFilter),
                "Main Waregroup" = field(MainWGFilter),
                "Customer No." = field(SrcNoFilter),
                "Vendor No." = field(VendorFilter),
                Brand = field(BrandFilter),
                Season = field(SeasonFilter),
                Agent = field(AgentFilter),
                "Item Category" = field(ItemCatFilter),
                "Country Code" = field(CountryFilter),
                "Planning Document No." = field("Planning Document No."),
                FDim1 = field(FDim1),
                FDim2 = field(FDim2),
                FDim3 = field(FDim3),
                FDim4 = field(FDim4),
                FDim5 = field(FDim5),
                FDim6 = field(FDim6),
                FDim7 = field(FDim7),
                FDim8 = field(FDim8),
                FDim9 = field(FDim9),
                FDim10 = field(FDim10)));
            Caption = 'OTB Qty. Purchase';
            DecimalPlaces = 0 : 0;
            Editable = false;
            FieldClass = FlowField;
            ToolTip = 'Specifies the OTB Qty. Purchase.';
        }
        field(205; "OTB Cost Am. Purchase"; Decimal)
        {

            CalcFormula = sum("BET FN Planning Entry (DWH)"."Plan Cost Am. Purchase" where("Posting Date" = field(DateFilter),
                Division = field(DivisFilter),
                "Item No." = field(ItemFilter),
                "Location Code" = field(LocFilter),
                "Main Waregroup" = field(MainWGFilter),
                "Customer No." = field(SrcNoFilter),
                "Vendor No." = field(VendorFilter),
                Brand = field(BrandFilter),
                Season = field(SeasonFilter),
                Agent = field(AgentFilter),
                "Item Category" = field(ItemCatFilter),
                "Country Code" = field(CountryFilter),
                "Planning Document No." = field("Planning Document No."),
                FDim1 = field(FDim1),
                FDim2 = field(FDim2),
                FDim3 = field(FDim3),
                FDim4 = field(FDim4),
                FDim5 = field(FDim5),
                FDim6 = field(FDim6),
                FDim7 = field(FDim7),
                FDim8 = field(FDim8),
                FDim9 = field(FDim9),
                FDim10 = field(FDim10)));
            Caption = 'OTB Cost Am. Purchase';
            Editable = false;
            FieldClass = FlowField;
            ToolTip = 'Specifies the OTB Cost Am. Purchase.';
        }
        field(206; "OTB Sales Am. Purchase"; Decimal)
        {

            CalcFormula = sum("BET FN Planning Entry (DWH)"."Plan Sales Am. Purchase" where("Posting Date" = field(DateFilter),
                Division = field(DivisFilter),
                "Item No." = field(ItemFilter),
                "Location Code" = field(LocFilter),
                "Main Waregroup" = field(MainWGFilter),
                "Customer No." = field(SrcNoFilter),
                "Vendor No." = field(VendorFilter),
                Brand = field(BrandFilter),
                Season = field(SeasonFilter),
                Agent = field(AgentFilter),
                "Item Category" = field(ItemCatFilter),
                "Country Code" = field(CountryFilter),
                "Planning Document No." = field("Planning Document No."),
                FDim1 = field(FDim1),
                FDim2 = field(FDim2),
                FDim3 = field(FDim3),
                FDim4 = field(FDim4),
                FDim5 = field(FDim5),
                FDim6 = field(FDim6),
                FDim7 = field(FDim7),
                FDim8 = field(FDim8),
                FDim9 = field(FDim9),
                FDim10 = field(FDim10)));
            Caption = 'OTB Sales Am. Purchase';
            Editable = false;
            FieldClass = FlowField;
            ToolTip = 'Specifies the OTB Sales Am. Purchase.';
        }
        field(207; "OTB Qty. Closing Inv."; Decimal)
        {

            CalcFormula = sum("BET FN Planning Entry (DWH)"."Plan Qty. Closing Inv." where("Posting Date" = field(upperlimit(DateFilter)),
                Division = field(DivisFilter),
                "Item No." = field(ItemFilter),
                "Location Code" = field(LocFilter),
                "Main Waregroup" = field(MainWGFilter),
                "Customer No." = field(SrcNoFilter),
                "Vendor No." = field(VendorFilter),
                Brand = field(BrandFilter),
                Season = field(SeasonFilter),
                Agent = field(AgentFilter),
                "Item Category" = field(ItemCatFilter),
                "Country Code" = field(CountryFilter),
                "Planning Document No." = field("Planning Document No."),
                FDim1 = field(FDim1),
                FDim2 = field(FDim2),
                FDim3 = field(FDim3),
                FDim4 = field(FDim4),
                FDim5 = field(FDim5),
                FDim6 = field(FDim6),
                FDim7 = field(FDim7),
                FDim8 = field(FDim8),
                FDim9 = field(FDim9),
                FDim10 = field(FDim10)));
            Caption = 'OTB Qty. Closing Inv.';
            DecimalPlaces = 0 : 0;
            Editable = false;
            FieldClass = FlowField;
            ToolTip = 'Specifies the OTB Qty. Closing Inv.';
        }
        field(208; "OTB Cost Closing Inv."; Decimal)
        {

            CalcFormula = sum("BET FN Planning Entry (DWH)"."Plan Cost Closing Inv." where("Posting Date" = field(upperlimit(DateFilter)),
                Division = field(DivisFilter),
                "Item No." = field(ItemFilter),
                "Location Code" = field(LocFilter),
                "Main Waregroup" = field(MainWGFilter),
                "Customer No." = field(SrcNoFilter),
                "Vendor No." = field(VendorFilter),
                Brand = field(BrandFilter),
                Season = field(SeasonFilter),
                Agent = field(AgentFilter),
                "Item Category" = field(ItemCatFilter),
                "Country Code" = field(CountryFilter),
                "Planning Document No." = field("Planning Document No."),
                FDim1 = field(FDim1),
                FDim2 = field(FDim2),
                FDim3 = field(FDim3),
                FDim4 = field(FDim4),
                FDim5 = field(FDim5),
                FDim6 = field(FDim6),
                FDim7 = field(FDim7),
                FDim8 = field(FDim8),
                FDim9 = field(FDim9),
                FDim10 = field(FDim10)));
            Caption = 'OTB Cost Closing Inv.';
            Editable = false;
            FieldClass = FlowField;
            ToolTip = 'Specifies the OTB Cost Closing Inv.';
        }
        field(209; "OTB Sales Closing Inv."; Decimal)
        {

            CalcFormula = sum("BET FN Planning Entry (DWH)"."Plan Sales Closing Inv." where("Posting Date" = field(upperlimit(DateFilter)),
                Division = field(DivisFilter),
                "Item No." = field(ItemFilter),
                "Location Code" = field(LocFilter),
                "Main Waregroup" = field(MainWGFilter),
                "Customer No." = field(SrcNoFilter),
                "Vendor No." = field(VendorFilter),
                Brand = field(BrandFilter),
                Season = field(SeasonFilter),
                Agent = field(AgentFilter),
                "Item Category" = field(ItemCatFilter),
                "Country Code" = field(CountryFilter),
                "Planning Document No." = field("Planning Document No."),
                FDim1 = field(FDim1),
                FDim2 = field(FDim2),
                FDim3 = field(FDim3),
                FDim4 = field(FDim4),
                FDim5 = field(FDim5),
                FDim6 = field(FDim6),
                FDim7 = field(FDim7),
                FDim8 = field(FDim8),
                FDim9 = field(FDim9),
                FDim10 = field(FDim10)));
            Caption = 'OTB Sales Closing Inv.';
            Editable = false;
            FieldClass = FlowField;
            ToolTip = 'Specifies the OTB Sales Closing Inv.';
        }
        field(210; "OTB Gross Sales Pr. Reduction"; Decimal)
        {

            CalcFormula = sum("BET FN Planning Entry (DWH)"."Plan Gross Sales Pr. Reduction" where("Posting Date" = field(DateFilter),
                Division = field(DivisFilter),
                "Item No." = field(ItemFilter),
                "Location Code" = field(LocFilter),
                "Main Waregroup" = field(MainWGFilter),
                "Customer No." = field(SrcNoFilter),
                "Vendor No." = field(VendorFilter),
                Brand = field(BrandFilter),
                Season = field(SeasonFilter),
                Agent = field(AgentFilter),
                "Item Category" = field(ItemCatFilter),
                "Country Code" = field(CountryFilter),
                "Planning Document No." = field("Planning Document No."),
                FDim1 = field(FDim1),
                FDim2 = field(FDim2),
                FDim3 = field(FDim3),
                FDim4 = field(FDim4),
                FDim5 = field(FDim5),
                FDim6 = field(FDim6),
                FDim7 = field(FDim7),
                FDim8 = field(FDim8),
                FDim9 = field(FDim9),
                FDim10 = field(FDim10)));
            Caption = 'OTB Gross Sales Pr. Reduction';
            Editable = false;
            FieldClass = FlowField;
            ToolTip = 'Specifies the OTB Gross Sales Pr. Reduction.';
        }
        field(211; "OTB Qty. Init. Inv."; Decimal)
        {

            CalcFormula = sum("BET FN Planning Entry (DWH)"."Plan Qty. Init. Inv." where("Posting Date" = field(upperlimit(DateFilter)),
                Division = field(DivisFilter),
                "Location Code" = field(LocFilter),
                "Main Waregroup" = field(MainWGFilter),
                "Customer No." = field(SrcNoFilter),
                "Vendor No." = field(VendorFilter),
                Brand = field(BrandFilter),
                Season = field(SeasonFilter),
                Agent = field(AgentFilter),
                "Item Category" = field(ItemCatFilter),
                "Country Code" = field(CountryFilter),
                "Planning Document No." = field("Planning Document No."),
                FDim1 = field(FDim1),
                FDim2 = field(FDim2),
                FDim3 = field(FDim3),
                FDim4 = field(FDim4),
                FDim5 = field(FDim5),
                FDim6 = field(FDim6),
                FDim7 = field(FDim7),
                FDim8 = field(FDim8),
                FDim9 = field(FDim9),
                FDim10 = field(FDim10)));
            Caption = 'OTB Qty. Init. Inv.';
            FieldClass = FlowField;
            Editable = false;
        }
        field(212; "OTB Cost Init. Inv."; Decimal)
        {

            CalcFormula = sum("BET FN Planning Entry (DWH)"."Plan Cost Init. Inv." where("Posting Date" = field(upperlimit(DateFilter)),
                Division = field(DivisFilter),
                "Location Code" = field(LocFilter),
                "Main Waregroup" = field(MainWGFilter),
                "Customer No." = field(SrcNoFilter),
                "Vendor No." = field(VendorFilter),
                Brand = field(BrandFilter),
                Season = field(SeasonFilter),
                Agent = field(AgentFilter),
                "Item Category" = field(ItemCatFilter),
                "Country Code" = field(CountryFilter),
                "Planning Document No." = field("Planning Document No."),
                FDim1 = field(FDim1),
                FDim2 = field(FDim2),
                FDim3 = field(FDim3),
                FDim4 = field(FDim4),
                FDim5 = field(FDim5),
                FDim6 = field(FDim6),
                FDim7 = field(FDim7),
                FDim8 = field(FDim8),
                FDim9 = field(FDim9),
                FDim10 = field(FDim10)));
            Caption = 'OTB Cost Init. Inv.';
            FieldClass = FlowField;
            Editable = false;
        }
        field(213; "OTB Sales Init. Inv."; Decimal)
        {

            CalcFormula = sum("BET FN Planning Entry (DWH)"."Plan Sales Init. Inv." where("Posting Date" = field(upperlimit(DateFilter)),
                Division = field(DivisFilter),
                "Location Code" = field(LocFilter),
                "Main Waregroup" = field(MainWGFilter),
                "Customer No." = field(SrcNoFilter),
                "Vendor No." = field(VendorFilter),
                Brand = field(BrandFilter),
                Season = field(SeasonFilter),
                Agent = field(AgentFilter),
                "Item Category" = field(ItemCatFilter),
                "Country Code" = field(CountryFilter),
                "Planning Document No." = field("Planning Document No."),
                FDim1 = field(FDim1),
                FDim2 = field(FDim2),
                FDim3 = field(FDim3),
                FDim4 = field(FDim4),
                FDim5 = field(FDim5),
                FDim6 = field(FDim6),
                FDim7 = field(FDim7),
                FDim8 = field(FDim8),
                FDim9 = field(FDim9),
                FDim10 = field(FDim10)));
            Caption = 'OTB Sales Init. Inv.';
            FieldClass = FlowField;
            Editable = false;
        }
        field(214; "OTB Sales Amount Net"; Decimal)
        {

            CalcFormula = sum("BET FN Planning Entry (DWH)"."Plan Sales Amount Net" where("Posting Date" = field(DateFilter),
                Division = field(DivisFilter),
                "Item No." = field(ItemFilter),
                "Location Code" = field(LocFilter),
                "Main Waregroup" = field(MainWGFilter),
                "Customer No." = field(SrcNoFilter),
                "Vendor No." = field(VendorFilter),
                Brand = field(BrandFilter),
                Season = field(SeasonFilter),
                Agent = field(AgentFilter),
                "Item Category" = field(ItemCatFilter),
                "Country Code" = field(CountryFilter),
                "Planning Document No." = field("Planning Document No."),
                FDim1 = field(FDim1),
                FDim2 = field(FDim2),
                FDim3 = field(FDim3),
                FDim4 = field(FDim4),
                FDim5 = field(FDim5),
                FDim6 = field(FDim6),
                FDim7 = field(FDim7),
                FDim8 = field(FDim8),
                FDim9 = field(FDim9),
                FDim10 = field(FDim10)));
            Caption = 'OTB Sales Amount Net';
            Editable = false;
            FieldClass = FlowField;
        }
        field(218; "OTB Sal. Am. Discount"; Decimal)
        {

            CalcFormula = sum("BET FN Planning Entry (DWH)"."Plan Sal. Am. Discount" where("Posting Date" = field(DateFilter),
                Division = field(DivisFilter),
                "Item No." = field(ItemFilter),
                "Location Code" = field(LocFilter),
                "Main Waregroup" = field(MainWGFilter),
                "Customer No." = field(SrcNoFilter),
                "Vendor No." = field(VendorFilter),
                Brand = field(BrandFilter),
                Season = field(SeasonFilter),
                Agent = field(AgentFilter),
                "Item Category" = field(ItemCatFilter),
                "Country Code" = field(CountryFilter),
                "Planning Document No." = field("Planning Document No."),
                FDim1 = field(FDim1),
                FDim2 = field(FDim2),
                FDim3 = field(FDim3),
                FDim4 = field(FDim4),
                FDim5 = field(FDim5),
                FDim6 = field(FDim6),
                FDim7 = field(FDim7),
                FDim8 = field(FDim8),
                FDim9 = field(FDim9),
                FDim10 = field(FDim10)));
            Caption = 'OTB Sal. Am. Discount';
            Editable = false;
            FieldClass = FlowField;
            ToolTip = 'Specifies the OTB Sal. Am. Discount.';
        }
        field(401; "FSE Sale Quantity"; Decimal)
        {

            CalcFormula = - sum("BET FN Fashion Statistic Entry"."S Quantity" where("Location Code" = field(LocFilter),
                "Posting Date" = field(DateFilter),
                "Size Run" = field(SizeRunFilter),
                Size = field(SizeFilter),
                Season = field(SeasonFilter),
                "Vendor No." = field(VendorFilter),
                "Item Category Code" = field(ItemCatFilter),
                Division = field(DivisFilter),
                "Main Waregroup" = field(MainWGFilter),
                Brand = field(BrandFilter),
                Agent = field(AgentFilter),
                Customer = field(CustomerFilter),
                FDim1 = field(FDim1),
                FDim2 = field(FDim2),
                FDim3 = field(FDim3),
                FDim4 = field(FDim4),
                FDim5 = field(FDim5),
                FDim6 = field(FDim6),
                FDim7 = field(FDim7),
                FDim8 = field(FDim8),
                FDim9 = field(FDim9),
                FDim10 = field(FDim10),
                "Item No." = field(ItemFilter),
                "Location Group" = field(LocationGroupFilter),
                "Price Range" = field(PriceRangeFilter),
                "Country Code" = field(CountryFilter),
                "Season Type" = field(SeasonTypeFilter)));
            Caption = 'FES Sale Quantity';
            DecimalPlaces = 0 : 0;
            Editable = false;
            FieldClass = FlowField;
            ToolTip = 'Specifies the FSE Sale Quantity.';
        }
        field(402; "FSE Sale Value (Cost)"; Decimal)
        {

            CalcFormula = - sum("BET FN Fashion Statistic Entry"."S Cost Amount" where("Location Code" = field(LocFilter),
                "Posting Date" = field(DateFilter),
                "Size Run" = field(SizeRunFilter),
                Size = field(SizeFilter),
                Season = field(SeasonFilter),
                "Vendor No." = field(VendorFilter),
                "Item Category Code" = field(ItemCatFilter),
                Division = field(DivisFilter),
                "Main Waregroup" = field(MainWGFilter),
                Brand = field(BrandFilter),
                Agent = field(AgentFilter),
                Customer = field(CustomerFilter),
                FDim1 = field(FDim1),
                FDim2 = field(FDim2),
                FDim3 = field(FDim3),
                FDim4 = field(FDim4),
                FDim5 = field(FDim5),
                FDim6 = field(FDim6),
                FDim7 = field(FDim7),
                FDim8 = field(FDim8),
                FDim9 = field(FDim9),
                FDim10 = field(FDim10),
                "Item No." = field(ItemFilter),
                "Location Group" = field(LocationGroupFilter),
                "Price Range" = field(PriceRangeFilter),
                "Country Code" = field(CountryFilter),
                "Season Type" = field(SeasonTypeFilter)));
            Caption = 'FSE Sale Value (Cost)';
            DecimalPlaces = 0 : 0;
            Editable = false;
            FieldClass = FlowField;
            ToolTip = 'Specifies the FSE Sale Value (Cost).';
        }
        field(403; "FSE Sale Value"; Decimal)
        {

            CalcFormula = - sum("BET FN Fashion Statistic Entry"."S Realized Gross Sales Amount" where("Location Code" = field(LocFilter),
                "Posting Date" = field(DateFilter),
                "Size Run" = field(SizeRunFilter),
                Size = field(SizeFilter),
                Season = field(SeasonFilter),
                "Vendor No." = field(VendorFilter),
                "Item Category Code" = field(ItemCatFilter),
                Division = field(DivisFilter),
                "Main Waregroup" = field(MainWGFilter),
                Brand = field(BrandFilter),
                Agent = field(AgentFilter),
                Customer = field(CustomerFilter),
                FDim1 = field(FDim1),
                FDim2 = field(FDim2),
                FDim3 = field(FDim3),
                FDim4 = field(FDim4),
                FDim5 = field(FDim5),
                FDim6 = field(FDim6),
                FDim7 = field(FDim7),
                FDim8 = field(FDim8),
                FDim9 = field(FDim9),
                FDim10 = field(FDim10),
                "Item No." = field(ItemFilter),
                "Location Group" = field(LocationGroupFilter),
                "Price Range" = field(PriceRangeFilter),
                "Country Code" = field(CountryFilter),
                "Season Type" = field(SeasonTypeFilter)));
            Caption = 'FSE Sale Value';
            DecimalPlaces = 0 : 0;
            Editable = false;
            FieldClass = FlowField;
            ToolTip = 'Specifies the FSE Sale Value.';
        }
        field(404; "FSE Purchase Quantity"; Decimal)
        {

            CalcFormula = sum("BET FN Fashion Statistic Entry"."P Quantity" where("Location Code" = field(LocFilter),
                "Posting Date" = field(DateFilter),
                "Size Run" = field(SizeRunFilter),
                Size = field(SizeFilter),
                Season = field(SeasonFilter),
                "Vendor No." = field(VendorFilter),
                "Item Category Code" = field(ItemCatFilter),
                "Season Type" = field(PriceFilter),
                Division = field(DivisFilter),
                "Main Waregroup" = field(MainWGFilter),
                Brand = field(BrandFilter),
                Agent = field(AgentFilter),
                Customer = field(CustomerFilter),
                FDim1 = field(FDim1),
                FDim2 = field(FDim2),
                FDim3 = field(FDim3),
                FDim4 = field(FDim4),
                FDim5 = field(FDim5),
                FDim6 = field(FDim6),
                FDim7 = field(FDim7),
                FDim8 = field(FDim8),
                FDim9 = field(FDim9),
                FDim10 = field(FDim10),
                "Item No." = field(ItemFilter),
                "Location Group" = field(LocationGroupFilter),
                "Price Range" = field(PriceRangeFilter),
                "Country Code" = field(CountryFilter),
                "Season Type" = field(SeasonTypeFilter)));
            Caption = 'FSE Purchase Quantity';
            DecimalPlaces = 0 : 0;
            Editable = false;
            FieldClass = FlowField;
            ToolTip = 'Specifies the FSE Purchase Quantity.';
        }
        field(405; "FSE Purchase Value (Cost)"; Decimal)
        {

            CalcFormula = sum("BET FN Fashion Statistic Entry"."P Cost Amount" where("Location Code" = field(LocFilter),
                "Posting Date" = field(DateFilter),
                "Size Run" = field(SizeRunFilter),
                Size = field(SizeFilter),
                Season = field(SeasonFilter),
                "Vendor No." = field(VendorFilter),
                "Item Category Code" = field(ItemCatFilter),
                Division = field(DivisFilter),
                "Main Waregroup" = field(MainWGFilter),
                Brand = field(BrandFilter),
                Agent = field(AgentFilter),
                Customer = field(CustomerFilter),
                FDim1 = field(FDim1),
                FDim2 = field(FDim2),
                FDim3 = field(FDim3),
                FDim4 = field(FDim4),
                FDim5 = field(FDim5),
                FDim6 = field(FDim6),
                FDim7 = field(FDim7),
                FDim8 = field(FDim8),
                FDim9 = field(FDim9),
                FDim10 = field(FDim10),
                "Item No." = field(ItemFilter),
                "Location Group" = field(LocationGroupFilter),
                "Price Range" = field(PriceRangeFilter),
                "Country Code" = field(CountryFilter),
                "Season Type" = field(SeasonTypeFilter)));
            Caption = 'FSE Purchase Value (Cost)';
            DecimalPlaces = 0 : 0;
            Editable = false;
            FieldClass = FlowField;
            ToolTip = 'Specifies the FSE Purchase Value (Cost).';
        }
        field(406; "FSE Purchase Value"; Decimal)
        {

            CalcFormula = sum("BET FN Fashion Statistic Entry"."P Inventory Value Sales" where("Location Code" = field(LocFilter),
                "Posting Date" = field(DateFilter),
                "Size Run" = field(SizeRunFilter),
                Size = field(SizeFilter),
                Season = field(SeasonFilter),
                "Vendor No." = field(VendorFilter),
                "Item Category Code" = field(ItemCatFilter),
                Division = field(DivisFilter),
                "Main Waregroup" = field(MainWGFilter),
                Brand = field(BrandFilter),
                Agent = field(AgentFilter),
                Customer = field(CustomerFilter),
                FDim1 = field(FDim1),
                FDim2 = field(FDim2),
                FDim3 = field(FDim3),
                FDim4 = field(FDim4),
                FDim5 = field(FDim5),
                FDim6 = field(FDim6),
                FDim7 = field(FDim7),
                FDim8 = field(FDim8),
                FDim9 = field(FDim9),
                FDim10 = field(FDim10),
                "Item No." = field(ItemFilter),
                "Location Group" = field(LocationGroupFilter),
                "Price Range" = field(PriceRangeFilter),
                "Country Code" = field(CountryFilter),
                "Season Type" = field(SeasonTypeFilter)));
            Caption = 'FSE Purchase Value';
            DecimalPlaces = 0 : 0;
            Editable = false;
            FieldClass = FlowField;
            ToolTip = 'Specifies the FSE Purchase Value.';
        }
        field(407; "FSE Inventory Quantity"; Decimal)
        {

            CalcFormula = sum("BET FN Fashion Statistic Entry"."I Quantity" where("Location Code" = field(LocFilter),
                "Posting Date" = field(upperlimit(DateFilter)),
                "Size Run" = field(SizeRunFilter),
                Size = field(SizeFilter),
                Season = field(SeasonFilter),
                "Vendor No." = field(VendorFilter),
                "Item Category Code" = field(ItemCatFilter),
                Division = field(DivisFilter),
                "Main Waregroup" = field(MainWGFilter),
                Brand = field(BrandFilter),
                Agent = field(AgentFilter),
                Customer = field(CustomerFilter),
                FDim1 = field(FDim1),
                FDim2 = field(FDim2),
                FDim3 = field(FDim3),
                FDim4 = field(FDim4),
                FDim5 = field(FDim5),
                FDim6 = field(FDim6),
                FDim7 = field(FDim7),
                FDim8 = field(FDim8),
                FDim9 = field(FDim9),
                FDim10 = field(FDim10),
                "Item No." = field(ItemFilter),
                "Location Group" = field(LocationGroupFilter),
                "Price Range" = field(PriceRangeFilter),
                "Country Code" = field(CountryFilter),
                "Season Type" = field(SeasonTypeFilter)));
            Caption = 'FSE Inventory Quantity';
            DecimalPlaces = 0 : 0;
            Editable = false;
            FieldClass = FlowField;
            ToolTip = 'Specifies the FSE Inventory Quantity.';
        }
        field(408; "FSE Inventory Value (Cost)"; Decimal)
        {

            CalcFormula = sum("BET FN Fashion Statistic Entry"."I Cost Amount" where("Location Code" = field(LocFilter),
                "Posting Date" = field(upperlimit(DateFilter)),
                "Size Run" = field(SizeRunFilter),
                Size = field(SizeFilter),
                Season = field(SeasonFilter),
                "Vendor No." = field(VendorFilter),
                "Item Category Code" = field(ItemCatFilter),
                Division = field(DivisFilter),
                "Main Waregroup" = field(MainWGFilter),
                Brand = field(BrandFilter),
                Agent = field(AgentFilter),
                Customer = field(CustomerFilter),
                FDim1 = field(FDim1),
                FDim2 = field(FDim2),
                FDim3 = field(FDim3),
                FDim4 = field(FDim4),
                FDim5 = field(FDim5),
                FDim6 = field(FDim6),
                FDim7 = field(FDim7),
                FDim8 = field(FDim8),
                FDim9 = field(FDim9),
                FDim10 = field(FDim10),
                "Item No." = field(ItemFilter),
                "Location Group" = field(LocationGroupFilter),
                "Price Range" = field(PriceRangeFilter),
                "Country Code" = field(CountryFilter),
                "Season Type" = field(SeasonTypeFilter)));
            Caption = 'FSE Inventory Value (Cost)';
            DecimalPlaces = 0 : 0;
            Editable = false;
            FieldClass = FlowField;
            ToolTip = 'Specifies the FSE Inventory Value (Cost).';
        }
        field(409; "FSE Inventory Value"; Decimal)
        {

            CalcFormula = sum("BET FN Fashion Statistic Entry"."I Inventory Value Sales" where("Location Code" = field(LocFilter),
                "Posting Date" = field(upperlimit(DateFilter)),
                "Size Run" = field(SizeRunFilter),
                Size = field(SizeFilter),
                Season = field(SeasonFilter),
                "Vendor No." = field(VendorFilter),
                "Item Category Code" = field(ItemCatFilter),
                Division = field(DivisFilter),
                "Main Waregroup" = field(MainWGFilter),
                Brand = field(BrandFilter),
                Agent = field(AgentFilter),
                Customer = field(CustomerFilter),
                FDim1 = field(FDim1),
                FDim2 = field(FDim2),
                FDim3 = field(FDim3),
                FDim4 = field(FDim4),
                FDim5 = field(FDim5),
                FDim6 = field(FDim6),
                FDim7 = field(FDim7),
                FDim8 = field(FDim8),
                FDim9 = field(FDim9),
                FDim10 = field(FDim10),
                "Item No." = field(ItemFilter),
                "Location Group" = field(LocationGroupFilter),
                "Price Range" = field(PriceRangeFilter),
                "Country Code" = field(CountryFilter),
                "Season Type" = field(SeasonTypeFilter)));
            Caption = 'FSE Inventory Value';
            DecimalPlaces = 0 : 0;
            Editable = false;
            FieldClass = FlowField;
            ToolTip = 'Specifies the FSE Inventory Value.';
        }
        field(410; "FSE G.S.P. Reduction"; Decimal)
        {

            CalcFormula = - sum("BET FN Fashion Statistic Entry"."S Realized GSP Reduction" where("Location Code" = field(LocFilter),
                "Posting Date" = field(DateFilter),
                "Size Run" = field(SizeRunFilter),
                Size = field(SizeFilter),
                Season = field(SeasonFilter),
                "Vendor No." = field(VendorFilter),
                "Item Category Code" = field(ItemCatFilter),
                Division = field(DivisFilter),
                "Main Waregroup" = field(MainWGFilter),
                Brand = field(BrandFilter),
                Agent = field(AgentFilter),
                Customer = field(CustomerFilter),
                FDim1 = field(FDim1),
                FDim2 = field(FDim2),
                FDim3 = field(FDim3),
                FDim4 = field(FDim4),
                FDim5 = field(FDim5),
                FDim6 = field(FDim6),
                FDim7 = field(FDim7),
                FDim8 = field(FDim8),
                FDim9 = field(FDim9),
                FDim10 = field(FDim10),
                "Item No." = field(ItemFilter),
                "Location Group" = field(LocationGroupFilter),
                "Price Range" = field(PriceRangeFilter),
                "Country Code" = field(CountryFilter),
                "Season Type" = field(SeasonTypeFilter)));
            Caption = 'FSE G.S.P. Reduction';
            DecimalPlaces = 0 : 0;
            Editable = false;
            FieldClass = FlowField;
            ToolTip = 'Specifies the FSE G.S.P. Reduction.';
        }
        field(411; "FSE Gross Discount"; Decimal)
        {

            CalcFormula = - sum("BET FN Fashion Statistic Entry"."S Discount Amount Gross" where("Location Code" = field(LocFilter),
                "Posting Date" = field(DateFilter),
                "Size Run" = field(SizeRunFilter),
                Size = field(SizeFilter),
                Season = field(SeasonFilter),
                "Vendor No." = field(VendorFilter),
                "Item Category Code" = field(ItemCatFilter),
                Division = field(DivisFilter),
                "Main Waregroup" = field(MainWGFilter),
                Brand = field(BrandFilter),
                Agent = field(AgentFilter),
                Customer = field(CustomerFilter),
                FDim1 = field(FDim1),
                FDim2 = field(FDim2),
                FDim3 = field(FDim3),
                FDim4 = field(FDim4),
                FDim5 = field(FDim5),
                FDim6 = field(FDim6),
                FDim7 = field(FDim7),
                FDim8 = field(FDim8),
                FDim9 = field(FDim9),
                FDim10 = field(FDim10),
                "Item No." = field(ItemFilter),
                "Location Group" = field(LocationGroupFilter),
                "Price Range" = field(PriceRangeFilter),
                "Country Code" = field(CountryFilter),
                "Season Type" = field(SeasonTypeFilter)));
            Caption = 'FSE Gross Discount';
            Editable = false;
            FieldClass = FlowField;
            ToolTip = 'Specifies the FSE Gross Discount.';
        }
        field(412; "FSE Change in GS-Prices"; Decimal)
        {

            CalcFormula = - sum("BET FN Fashion Statistic Entry"."S Change in GS-Prices" where("Location Code" = field(LocFilter),
                "Posting Date" = field(DateFilter),
                Season = field(SeasonFilter),
                "Vendor No." = field(VendorFilter),
                "Item Category Code" = field(ItemCatFilter),
                Division = field(DivisFilter),
                "Main Waregroup" = field(MainWGFilter),
                Brand = field(BrandFilter),
                Agent = field(AgentFilter),
                Customer = field(CustomerFilter),
                FDim1 = field(FDim1),
                FDim2 = field(FDim2),
                FDim3 = field(FDim3),
                FDim4 = field(FDim4),
                FDim5 = field(FDim5),
                FDim6 = field(FDim6),
                FDim7 = field(FDim7),
                FDim8 = field(FDim8),
                FDim9 = field(FDim9),
                FDim10 = field(FDim10),
                "Item No." = field(ItemFilter),
                "Location Group" = field(LocationGroupFilter),
                "Price Range" = field(PriceRangeFilter),
                "Country Code" = field(CountryFilter),
                "Season Type" = field(SeasonTypeFilter)));
            Caption = 'FSE Change in GS-Prices';
            Editable = false;
            FieldClass = FlowField;
            ToolTip = 'Specifies the FSE Change in GS-Prices.';
        }
        field(413; "FSE Sale Value Net"; Decimal)
        {

            CalcFormula = - sum("BET FN Fashion Statistic Entry"."S Real. Net Sales Amount" where("Location Code" = field(LocFilter),
                "Posting Date" = field(DateFilter),
                "Size Run" = field(SizeRunFilter),
                Size = field(SizeFilter),
                Season = field(SeasonFilter),
                "Vendor No." = field(VendorFilter),
                "Item Category Code" = field(ItemCatFilter),
                Division = field(DivisFilter),
                "Main Waregroup" = field(MainWGFilter),
                Brand = field(BrandFilter),
                Agent = field(AgentFilter),
                Customer = field(CustomerFilter),
                FDim1 = field(FDim1),
                FDim2 = field(FDim2),
                FDim3 = field(FDim3),
                FDim4 = field(FDim4),
                FDim5 = field(FDim5),
                FDim6 = field(FDim6),
                FDim7 = field(FDim7),
                FDim8 = field(FDim8),
                FDim9 = field(FDim9),
                FDim10 = field(FDim10),
                "Item No." = field(ItemFilter),
                "Location Group" = field(LocationGroupFilter),
                "Price Range" = field(PriceRangeFilter),
                "Country Code" = field(CountryFilter),
                "Season Type" = field(SeasonTypeFilter)));
            Caption = 'FSE Sale Value Net';
            DecimalPlaces = 0 : 0;
            Editable = false;
            FieldClass = FlowField;
        }
        field(414; "FSE Discount Net"; Decimal)
        {

            CalcFormula = - sum("BET FN Fashion Statistic Entry"."S Discount Amount" where("Location Code" = field(LocFilter),
                "Posting Date" = field(DateFilter),
                "Size Run" = field(SizeRunFilter),
                Size = field(SizeFilter),
                Season = field(SeasonFilter),
                "Vendor No." = field(VendorFilter),
                "Item Category Code" = field(ItemCatFilter),
                Division = field(DivisFilter),
                "Main Waregroup" = field(MainWGFilter),
                Brand = field(BrandFilter),
                Agent = field(AgentFilter),
                Customer = field(CustomerFilter),
                FDim1 = field(FDim1),
                FDim2 = field(FDim2),
                FDim3 = field(FDim3),
                FDim4 = field(FDim4),
                FDim5 = field(FDim5),
                FDim6 = field(FDim6),
                FDim7 = field(FDim7),
                FDim8 = field(FDim8),
                FDim9 = field(FDim9),
                FDim10 = field(FDim10),
                "Item No." = field(ItemFilter),
                "Location Group" = field(LocationGroupFilter),
                "Price Range" = field(PriceRangeFilter),
                "Country Code" = field(CountryFilter),
                "Season Type" = field(SeasonTypeFilter)));
            Caption = 'FSE Discount Net';
            Editable = false;
            FieldClass = FlowField;
        }
        field(420; "FSE Adjmt. Quantity"; Decimal)
        {

            CalcFormula = - sum("BET FN Fashion Statistic Entry"."A Quantity" where("Location Code" = field(LocFilter),
                "Posting Date" = field(DateFilter),
                Season = field(SeasonFilter),
                "Vendor No." = field(VendorFilter),
                "Item Category Code" = field(ItemCatFilter),
                Division = field(DivisFilter),
                "Main Waregroup" = field(MainWGFilter),
                Brand = field(BrandFilter),
                FDim1 = field(FDim1),
                FDim2 = field(FDim2),
                FDim3 = field(FDim3),
                FDim4 = field(FDim4),
                FDim5 = field(FDim5),
                FDim6 = field(FDim6),
                FDim7 = field(FDim7),
                FDim8 = field(FDim8),
                FDim9 = field(FDim9),
                FDim10 = field(FDim10),
                "Item No." = field(ItemFilter),
                "Location Group" = field(LocationGroupFilter),
                "Price Range" = field(PriceRangeFilter),
                "Country Code" = field(CountryFilter),
                "Season Type" = field(SeasonTypeFilter)));
            Caption = 'FSE Adjmt. Quantity';
            DecimalPlaces = 0 : 0;
            Editable = false;
            FieldClass = FlowField;
        }
        field(421; "FSE Adjmt. Value (Cost)"; Decimal)
        {

            CalcFormula = - sum("BET FN Fashion Statistic Entry"."A Cost Amount" where("Location Code" = field(LocFilter),
                "Posting Date" = field(DateFilter),
                Season = field(SeasonFilter),
                "Vendor No." = field(VendorFilter),
                "Item Category Code" = field(ItemCatFilter),
                Division = field(DivisFilter),
                "Main Waregroup" = field(MainWGFilter),
                Brand = field(BrandFilter),
                FDim1 = field(FDim1),
                FDim2 = field(FDim2),
                FDim3 = field(FDim3),
                FDim4 = field(FDim4),
                FDim5 = field(FDim5),
                FDim6 = field(FDim6),
                FDim7 = field(FDim7),
                FDim8 = field(FDim8),
                FDim9 = field(FDim9),
                FDim10 = field(FDim10),
                "Item No." = field(ItemFilter),
                "Location Group" = field(LocationGroupFilter),
                "Price Range" = field(PriceRangeFilter),
                "Country Code" = field(CountryFilter),
                "Season Type" = field(SeasonTypeFilter)));
            Caption = 'FSE Adjmt. Value (Cost)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(422; "FSE Adjmt. Value"; Decimal)
        {

            CalcFormula = - sum("BET FN Fashion Statistic Entry"."A Inventory Value Sales" where("Location Code" = field(LocFilter),
                "Posting Date" = field(DateFilter),
                Season = field(SeasonFilter),
                "Vendor No." = field(VendorFilter),
                "Item Category Code" = field(ItemCatFilter),
                Division = field(DivisFilter),
                "Main Waregroup" = field(MainWGFilter),
                Brand = field(BrandFilter),
                FDim1 = field(FDim1),
                FDim2 = field(FDim2),
                FDim3 = field(FDim3),
                FDim4 = field(FDim4),
                FDim5 = field(FDim5),
                FDim6 = field(FDim6),
                FDim7 = field(FDim7),
                FDim8 = field(FDim8),
                FDim9 = field(FDim9),
                FDim10 = field(FDim10),
                "Item No." = field(ItemFilter),
                "Location Group" = field(LocationGroupFilter),
                "Price Range" = field(PriceRangeFilter),
                "Country Code" = field(CountryFilter),
                "Season Type" = field(SeasonTypeFilter)));
            Caption = 'FSE Adjmt. Value';
            Editable = false;
            FieldClass = FlowField;
        }
        field(900; "Outst. Qty. in Purch. Order"; Decimal)
        {

            CalcFormula = sum("Purchase Line"."Outstanding Qty. (Base)" where("Document Type" = const(Order),
                Type = const(Item),
                "BET FN Status" = const(Released),
                "No." = field(ItemFilter),
                "Location Code" = field(LocFilter),
                "Expected Receipt Date" = field(DateFilter),
                "Item Category Code" = field(ItemCatFilter),
                "Buy-from Vendor No." = field(VendorFilter),
                "BET FN Order Season" = field(SeasonFilter),
                "BET FN Size Run" = field(SizeRunFilter),
                "BET FN Size" = field(SizeFilter),
                "BET FN Colour" = field(ColourFilter),
                "BET FN Purchaser Code" = field(PurchFilter),
                "BET FN Division" = field(DivisFilter),
                "BET FN Main Waregroup" = field(MainWGFilter),
                "BET FN Brand" = field(BrandFilter),
                "Unit Price (LCY)" = field(PriceFilter)));
            Caption = 'Outst. Qty. in Purch. Order';
            Editable = false;
            FieldClass = FlowField;
        }
        field(901; "Outst. Gross Sales Amt. (LCY)"; Decimal)
        {

            CalcFormula = sum("Purchase Line"."BET FN Outstd Gs Sales Amt LCY" where("Document Type" = const(Order),
                Type = const(Item),
                "BET FN Status" = const(Released),
                "No." = field(ItemFilter),
                "Location Code" = field(LocFilter),
                "Expected Receipt Date" = field(DateFilter),
                "Item Category Code" = field(ItemCatFilter),
                "Buy-from Vendor No." = field(VendorFilter),
                "BET FN Order Season" = field(SeasonFilter),
                "BET FN Size Run" = field(SizeRunFilter),
                "BET FN Size" = field(SizeFilter),
                "BET FN Colour" = field(ColourFilter),
                "BET FN Purchaser Code" = field(PurchFilter),
                "BET FN Division" = field(DivisFilter),
                "BET FN Main Waregroup" = field(MainWGFilter),
                "BET FN Brand" = field(BrandFilter),
                "Unit Price (LCY)" = field(PriceFilter)));
            Caption = 'Outst. Amount in Purch. Order (incl. VAT)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(902; "Outst. Amount Net Purch. Order"; Decimal)
        {

            CalcFormula = sum("Purchase Line"."BET FN Net Outstanding Amt LCY" where("Document Type" = const(Order),
                Type = const(Item),
                "BET FN Status" = const(Released),
                "No." = field(ItemFilter),
                "Location Code" = field(LocFilter),
                "Expected Receipt Date" = field(DateFilter),
                "Item Category Code" = field(ItemCatFilter),
                "Buy-from Vendor No." = field(VendorFilter),
                "BET FN Order Season" = field(SeasonFilter),
                "BET FN Size Run" = field(SizeRunFilter),
                "BET FN Size" = field(SizeFilter),
                "BET FN Colour" = field(ColourFilter),
                "BET FN Purchaser Code" = field(PurchFilter),
                "BET FN Division" = field(DivisFilter),
                "BET FN Main Waregroup" = field(MainWGFilter),
                "BET FN Brand" = field(BrandFilter),
                "Unit Price (LCY)" = field(PriceFilter)));
            Caption = 'Outst. Amount Net Purch. Order';
            Editable = false;
            FieldClass = FlowField;
        }
        field(910; "PSE Outstanding Qty."; Decimal)
        {

            CalcFormula = sum("BET FN Purchase Statistic Ent"."Outstanding Quantity" where("Expected Receipt Date" = field(DateFilter),
                "Location Code" = field(LocFilter),
                Season = field(SeasonFilter),
                "Item Category Code" = field(ItemCatFilter),
                "Vendor No." = field(VendorFilter),
                Division = field(DivisFilter),
                "Main Waregroup" = field(MainWGFilter),
                Brand = field(BrandFilter),
                Customer = field(CustomerFilter),
                Agent = field(AgentFilter),
                FDim1 = field(FDim1),
                FDim2 = field(FDim2),
                FDim3 = field(FDim3),
                FDim4 = field(FDim4),
                FDim5 = field(FDim5),
                FDim6 = field(FDim6),
                FDim7 = field(FDim7),
                FDim8 = field(FDim8),
                FDim9 = field(FDim9),
                FDim10 = field(FDim10),
                "Location Group" = field(LocationGroupFilter),
                "Item No." = field(ItemFilter),
                "Season Type" = field(SeasonTypeFilter)));
            Caption = 'PSE Outstanding Qty.';
            Editable = false;
            FieldClass = FlowField;
            ToolTip = 'Specifies the PSE Outstanding Qty.';
        }
        field(911; "PSE Outst. Gross Sal. Amt."; Decimal)
        {

            CalcFormula = sum("BET FN Purchase Statistic Ent"."Outst. Gross Sales Amt. (LCY)" where("Expected Receipt Date" = field(DateFilter),
                "Location Code" = field(LocFilter),
                Season = field(SeasonFilter),
                "Item Category Code" = field(ItemCatFilter),
                "Vendor No." = field(VendorFilter),
                Division = field(DivisFilter),
                "Main Waregroup" = field(MainWGFilter),
                Brand = field(BrandFilter),
                Customer = field(CustomerFilter),
                Agent = field(AgentFilter),
                FDim1 = field(FDim1),
                FDim2 = field(FDim2),
                FDim3 = field(FDim3),
                FDim4 = field(FDim4),
                FDim5 = field(FDim5),
                FDim6 = field(FDim6),
                FDim7 = field(FDim7),
                FDim8 = field(FDim8),
                FDim9 = field(FDim9),
                FDim10 = field(FDim10),
                "Location Group" = field(LocationGroupFilter),
                "Item No." = field(ItemFilter),
                "Season Type" = field(SeasonTypeFilter)));
            Caption = 'PSE Outst. Gross Sal. Amt.';
            Editable = false;
            FieldClass = FlowField;
            ToolTip = 'Specifies the PSE Outst. Gross Sal. Amt.';
        }
        field(912; "PSE Outstanding Amount"; Decimal)
        {

            CalcFormula = sum("BET FN Purchase Statistic Ent"."Net Outstanding Amount (LCY)" where("Expected Receipt Date" = field(DateFilter),
                "Location Code" = field(LocFilter),
                Season = field(SeasonFilter),
                "Item Category Code" = field(ItemCatFilter),
                "Vendor No." = field(VendorFilter),
                Division = field(DivisFilter),
                "Main Waregroup" = field(MainWGFilter),
                Brand = field(BrandFilter),
                Customer = field(CustomerFilter),
                Agent = field(AgentFilter),
                FDim1 = field(FDim1),
                FDim2 = field(FDim2),
                FDim3 = field(FDim3),
                FDim4 = field(FDim4),
                FDim5 = field(FDim5),
                FDim6 = field(FDim6),
                FDim7 = field(FDim7),
                FDim8 = field(FDim8),
                FDim9 = field(FDim9),
                FDim10 = field(FDim10),
                "Location Group" = field(LocationGroupFilter),
                "Item No." = field(ItemFilter),
                "Season Type" = field(SeasonTypeFilter)));
            Caption = 'PSE Outstanding Amount';
            Editable = false;
            FieldClass = FlowField;
            ToolTip = 'Specifies the PSE Outstanding Amount.';
        }
        field(2010; "Plan VK Umsatz"; Decimal)
        {

            CalcFormula = sum("BET FN Planning Value Cube"."Plan Sales Amount" where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter),
                Fixed = field(Fixed)));
            Caption = 'Plan Sales Amount';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(2011; "Plan Sales Amount Net"; Decimal)
        {

            CalcFormula = sum("BET FN Planning Value Cube"."Plan Sales Amount Net" where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter),
                Fixed = field(Fixed)));
            Caption = 'Plan Sales Amount Net';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(2020; "Plan VK Rabatt"; Decimal)
        {

            CalcFormula = sum("BET FN Planning Value Cube"."Plan Sal. Am. Discount" where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter),
                Fixed = field(Fixed)));
            Caption = 'Plan Sal. Am. Depreciation';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(2030; "Plan VK Anfangsbestand"; Decimal)
        {

            CalcFormula = sum("BET FN Planning Value Cube"."Plan Sales Init. Inv." where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter),
                Fixed = field(Fixed)));
            Caption = 'Plan Sales Init. Inv.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(2035; "Plan VK Endbestand"; Decimal)
        {
            CalcFormula = sum("BET FN Planning Value Cube"."Plan Sales Closing Inv." where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter),
                Fixed = field(Fixed)));
            Caption = 'Plan Cost Closing Inv.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(2040; "Plan VK Abschrift"; Decimal)
        {
            CalcFormula = sum("BET FN Planning Value Cube"."Plan Gross Sales Pr. Reduction" where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter),
                Fixed = field(Fixed)));
            Caption = 'Plan GSPR Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(2050; "Plan VK WE (Limit)"; Decimal)
        {
            CalcFormula = sum("BET FN Planning Value Cube"."Plan Sales Am. Purchase" where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter),
                Fixed = field(Fixed)));
            Caption = 'Plan Sales Am. Purchase';
            Editable = false;
            FieldClass = FlowField;
        }
        field(2110; "Plan Menge Umsatz"; Decimal)
        {

            CalcFormula = sum("BET FN Planning Value Cube"."Plan Qty. Sale" where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter),
                Fixed = field(Fixed)));
            Caption = 'Plan Qty. Sale';
            Editable = false;
            FieldClass = FlowField;
        }
        field(2130; "Plan Menge Anfangsbestand"; Decimal)
        {

            CalcFormula = sum("BET FN Planning Value Cube"."Plan Qty. Init. Inv." where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter),
                Fixed = field(Fixed)));
            Caption = 'Plan Qty. Init. Inv.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(2135; "Plan Menge Endbestand"; Decimal)
        {

            CalcFormula = sum("BET FN Planning Value Cube"."Plan Qty. Closing Inv." where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter),
                Fixed = field(Fixed)));
            Caption = 'Plan Cost Closing Inv.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(2150; "Plan Menge WE (Limit)"; Decimal)
        {

            CalcFormula = sum("BET FN Planning Value Cube"."Plan Qty. Purchase" where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter),
                Fixed = field(Fixed)));
            Caption = 'Plan Qty. Purchase';
            Editable = false;
            FieldClass = FlowField;
        }
        field(2210; "Plan EK Umsatz"; Decimal)
        {

            CalcFormula = sum("BET FN Planning Value Cube"."Plan Cost of Sales" where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter),
                Fixed = field(Fixed)));
            Caption = 'Plan Cost of Sales';
            Editable = false;
            FieldClass = FlowField;
        }
        field(2230; "Plan EK Anfangsbestand"; Decimal)
        {

            CalcFormula = sum("BET FN Planning Value Cube"."Plan Cost Init. Inv." where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter),
                Fixed = field(Fixed)));
            Caption = 'Plan Cost Init. Inv.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(2235; "Plan EK Endbestand"; Decimal)
        {

            CalcFormula = sum("BET FN Planning Value Cube"."Plan Cost Closing Inv." where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter),
                Fixed = field(Fixed)));
            Caption = 'Plan Cost Closing Inv.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(2250; "Plan EK WE (Limit)"; Decimal)
        {

            CalcFormula = sum("BET FN Planning Value Cube"."Plan Cost Am. Purchase" where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter),
                Fixed = field(Fixed)));
            Caption = 'Plan Cost Val. Purchase';
            Editable = false;
            FieldClass = FlowField;
        }
        field(2251; "Plan EK Limit 1"; Decimal)
        {

            CalcFormula = sum("BET FN Planning Value Cube"."Plan Cost Am. Purch. 1" where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter),
                Fixed = field(Fixed)));
            Caption = 'Plan Cost Val. Purchase';
            Editable = false;
            FieldClass = FlowField;
        }
        field(2252; "Plan EK Limit 2"; Decimal)
        {

            CalcFormula = sum("BET FN Planning Value Cube"."Plan Cost Am. Purch. 2" where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter),
                Fixed = field(Fixed)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(2253; "Plan EK Limit 3"; Decimal)
        {

            CalcFormula = sum("BET FN Planning Value Cube"."Plan Cost Am. Purch. 3" where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter),
                Fixed = field(Fixed)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(2254; "Plan EK Limit 4"; Decimal)
        {

            CalcFormula = sum("BET FN Planning Value Cube"."Plan Cost Am. Purch. 4" where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter),
                Fixed = field(Fixed)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(2255; "Plan EK Limit 5"; Decimal)
        {

            CalcFormula = sum("BET FN Planning Value Cube"."Plan Cost Am. Purch. 5" where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter),
                Fixed = field(Fixed)));
            Editable = false;
            FieldClass = FlowField;
        }

        field(2256; "Plan Sales Limit 1"; Decimal)
        {
            CalcFormula = sum("BET FN Planning Value Cube"."Plan Sales Am. Purch. 1" where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter),
                Fixed = field(Fixed)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(2257; "Plan Sales Limit 2"; Decimal)
        {
            CalcFormula = sum("BET FN Planning Value Cube"."Plan Sales Am. Purch. 2" where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter),
                Fixed = field(Fixed)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(2258; "Plan Sales Limit 3"; Decimal)
        {
            CalcFormula = sum("BET FN Planning Value Cube"."Plan Sales Am. Purch. 3" where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter),
                Fixed = field(Fixed)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(2259; "Plan Sales Limit 4"; Decimal)
        {
            CalcFormula = sum("BET FN Planning Value Cube"."Plan Sales Am. Purch. 4" where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter),
                Fixed = field(Fixed)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(2260; "Plan Sales Limit 5"; Decimal)
        {
            CalcFormula = sum("BET FN Planning Value Cube"."Plan Sales Am. Purch. 5" where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter),
                Fixed = field(Fixed)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(2295; "Plan EK Freies Limit"; Decimal)
        {

            CalcFormula = sum("BET FN Planning Value Cube"."Free Purchase Limit" where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter)));
            Caption = 'Open To Buy';
            Editable = false;
            FieldClass = FlowField;
        }
        field(3000; "Proj. Sales Closing Inv."; Decimal)
        {

            CalcFormula = sum("BET FN Planning Value Cube"."Proj. Sales Closing Inv." where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter)));
            Caption = 'Proj. Sales Closing Inv.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(3001; "Proj. Cost Closing Inv."; Decimal)
        {

            CalcFormula = sum("BET FN Planning Value Cube"."Proj. Cost Closing Inv." where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter)));
            Caption = 'Proj. Cost Closing Inv.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(3002; "Proj. Qty. Closing Inv."; Decimal)
        {

            CalcFormula = sum("BET FN Planning Value Cube"."Proj. Qty. Closing Inv." where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter)));
            Caption = 'Proj. Qty. Closing Inv.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(3003; "Proj. Sales Amount"; Decimal)
        {

            CalcFormula = sum("BET FN Planning Value Cube"."Proj. Sales Amount" where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter)));
            Caption = 'Proj. Sales Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(4000; "Plan Target Sales Amount"; Decimal)
        {

            CalcFormula = sum("BET FN Planning Value Cube"."Plan Target Sales Amount" where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter)));
            Caption = 'Plan Target Sales Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(4001; "Plan Target Discount"; Decimal)
        {

            CalcFormula = sum("BET FN Planning Value Cube"."Plan Target Discount" where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter)));
            Caption = 'Plan Target Discount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(4003; "Plan Target G.S.P. Reduction"; Decimal)
        {

            CalcFormula = sum("BET FN Planning Value Cube"."Plan Target G.S.P. Reduction" where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter)));
            Caption = 'Plan Target G.S.P. Reduction';
            Editable = false;
            FieldClass = FlowField;
        }
        field(4004; "Plan Target Sal. Am. Purch."; Decimal)
        {

            CalcFormula = sum("BET FN Planning Value Cube"."Plan Target Sal. Am. Purch." where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter)));
            Caption = 'Plan Target Sal. Am. Purch.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(4005; "Plan Target Sales Init. Inv."; Decimal)
        {

            CalcFormula = sum("BET FN Planning Value Cube"."Plan Target Sales Init. Inv." where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter)));
            Caption = 'Plan Target Sales Init. Inv.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(4006; "Plan Target Sales Closing Inv."; Decimal)
        {

            CalcFormula = sum("BET FN Planning Value Cube"."Plan Target Sales Closing Inv." where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter)));
            Caption = 'Plan Target Sales Closing Inv.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(4007; "Plan Target Sales Am. Net"; Decimal)
        {

            CalcFormula = sum("BET FN Planning Value Cube"."Plan Target Sales Am. Net" where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter)));
            Caption = 'Plan Target Sales Am. Net';
            Editable = false;
            FieldClass = FlowField;
        }
        field(4008; "Plan Target Discount Net"; Decimal)
        {

            CalcFormula = sum("BET FN Planning Value Cube"."Plan Target Discount Net" where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter)));
            Caption = 'Plan Target Discount Net';
            Editable = false;
            FieldClass = FlowField;
        }
        field(4010; "Plan Target Cost of Sales"; Decimal)
        {

            CalcFormula = sum("BET FN Planning Value Cube"."Plan Target Cost of Sales" where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter)));
            Caption = 'Plan Target Cost of Sales';
            Editable = false;
            FieldClass = FlowField;
        }
        field(4011; "Plan Target Cost Am. Purch."; Decimal)
        {

            CalcFormula = sum("BET FN Planning Value Cube"."Plan Target Cost Am. Purch." where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter)));
            Caption = 'Plan Target Cost Am. Purch.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(4012; "Plan Target Cost Init. Inv."; Decimal)
        {

            CalcFormula = sum("BET FN Planning Value Cube"."Plan Target Cost Init. Inv." where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter)));
            Caption = 'Plan Target Cost Init. Inv.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(4013; "Plan Target Cost Closing Inv."; Decimal)
        {

            CalcFormula = sum("BET FN Planning Value Cube"."Plan Target Cost Closing Inv." where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter)));
            Caption = 'Plan Target Cost Closing Inv.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(4014; "Plan Target Purch. Limit 1"; Decimal)
        {

            CalcFormula = sum("BET FN Planning Value Cube"."Plan Target Purch. Limit 1" where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter)));
            Caption = 'Plan Target Purch. Limit 1';
            Editable = false;
            FieldClass = FlowField;
        }
        field(4015; "Plan Target Purch. Limit 2"; Decimal)
        {

            CalcFormula = sum("BET FN Planning Value Cube"."Plan Target Purch. Limit 2" where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter)));
            Caption = 'Plan Target Purch. Limit 2';
            Editable = false;
            FieldClass = FlowField;
        }
        field(4016; "Plan Target Purch. Limit 3"; Decimal)
        {

            CalcFormula = sum("BET FN Planning Value Cube"."Plan Target Purch. Limit 3" where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter)));
            Caption = 'Plan Target Purch. Limit 3';
            Editable = false;
            FieldClass = FlowField;
        }
        field(4017; "Plan Target Purch. Limit 4"; Decimal)
        {

            CalcFormula = sum("BET FN Planning Value Cube"."Plan Target Purch. Limit 4" where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter)));
            Caption = 'Plan Target Purch. Limit 4';
            Editable = false;
            FieldClass = FlowField;
        }
        field(4018; "Plan Target Purch. Limit 5"; Decimal)
        {

            CalcFormula = sum("BET FN Planning Value Cube"."Plan Target Purch. Limit 5" where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter)));
            Caption = 'Plan Target Purch. Limit 5';
            Editable = false;
            FieldClass = FlowField;
        }
        field(4020; "Plan Target Qty. Sale"; Decimal)
        {

            CalcFormula = sum("BET FN Planning Value Cube"."Plan Target Qty. Sale" where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter)));
            Caption = 'Plan Target Qty. Sale';
            Editable = false;
            FieldClass = FlowField;
        }
        field(4021; "Plan Target Qty. Purchase"; Decimal)
        {

            CalcFormula = sum("BET FN Planning Value Cube"."Plan Target Qty. Purchase" where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter)));
            Caption = 'Plan Target Qty. Purchase';
            Editable = false;
            FieldClass = FlowField;
        }
        field(4022; "Plan Target Qty. Init. Inv."; Decimal)
        {

            CalcFormula = sum("BET FN Planning Value Cube"."Plan Target Qty. Init. Inv." where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter)));
            Caption = 'Plan Target Qty. Init. Inv.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(4023; "Plan Target Qty. Closing Inv."; Decimal)
        {

            CalcFormula = sum("BET FN Planning Value Cube"."Plan Target Qty. Closing Inv." where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter)));
            Caption = 'Plan Target Qty. Closing Inv.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5010; "Vgl. VK Umsatz"; Decimal)
        {

            CalcFormula = sum("BET FN Reference Value Cube"."Ref. Sales Amount" where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter)));
            Caption = 'Ref. Sales Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5011; "Ref. Sales Amount Net"; Decimal)
        {

            CalcFormula = sum("BET FN Reference Value Cube"."Ref. Sales Amount Net" where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter)));
            Caption = 'Ref. Sales Amount Net';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5020; "Vgl. VK Rabatt"; Decimal)
        {

            CalcFormula = sum("BET FN Reference Value Cube"."Ref. Sal. Am. Discount" where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter)));
            Caption = 'Ref. Sal. Am. Depreciation';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5021; "Vgl. VK Rabatt Netto"; Decimal)
        {

            CalcFormula = sum("BET FN Reference Value Cube"."Ref. Discount Net" where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter)));
            Caption = 'Vgl. VK Rabatt Netto';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5030; "Vgl. VK Anfangsbestand"; Decimal)
        {

            CalcFormula = sum("BET FN Reference Value Cube"."Ref. Sales Init. Inv." where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter)));
            Caption = 'Ref. Sales Init. Inv.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5035; "Vgl. VK Endbestand"; Decimal)
        {

            CalcFormula = sum("BET FN Reference Value Cube"."Ref. Sales Closing Inv." where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter)));
            Caption = 'Ref. Sales Closing Inv.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5040; "Vgl. VK Abschrift"; Decimal)
        {

            CalcFormula = sum("BET FN Reference Value Cube"."Ref. Gross Sales Pr. Reduction" where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter)));
            Caption = 'Ref. GSPR Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5050; "Vgl. VK WE (Limit)"; Decimal)
        {

            CalcFormula = sum("BET FN Reference Value Cube"."Ref. Sales Am. Purchase" where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter)));
            Caption = 'Ref. Sales Am. Purchase';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5070; "Vgl. Menge Umsatz"; Decimal)
        {

            CalcFormula = sum("BET FN Reference Value Cube"."Ref. Qty. Sale" where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter)));
            Caption = 'Ref. Qty. Sale';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5080; "Vgl. Menge Anfangsbestand"; Decimal)
        {

            CalcFormula = sum("BET FN Reference Value Cube"."Ref. Qty. Init. Inv." where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter)));
            Caption = 'Ref. Qty. Init. Inv.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5085; "Vgl. Menge Endbestand"; Decimal)
        {

            CalcFormula = sum("BET FN Reference Value Cube"."Ref. Qty. Closing Inv." where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter)));
            Caption = 'Ref. Qty. Closing Inv.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5090; "Vgl. Menge WE (Limit)"; Decimal)
        {

            CalcFormula = sum("BET FN Reference Value Cube"."Ref. Qty. Purchase" where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter)));
            Caption = 'Ref. Qty. Purchase';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5110; "Vgl. EK Umsatz"; Decimal)
        {

            CalcFormula = sum("BET FN Reference Value Cube"."Ref. Cost of Sales" where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter)));
            Caption = 'Ref. Cost of Sales';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5120; "Vgl. EK Anfangsbestand"; Decimal)
        {

            CalcFormula = sum("BET FN Reference Value Cube"."Ref. Cost Init. Inv." where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter)));
            Caption = 'Ref. Cost Init. Inv.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5125; "Vgl. EK Endbestand"; Decimal)
        {

            CalcFormula = sum("BET FN Reference Value Cube"."Ref. Cost Closing Inv." where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter)));
            Caption = 'Ref. Cost Closing Inv.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5130; "Vgl. EK WE (Limit)"; Decimal)
        {

            CalcFormula = sum("BET FN Reference Value Cube"."Ref. Cost Val. Purchase" where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter)));
            Caption = 'Ref. Cost Val. Purchase';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5200; "Vgl. Menge off. Best."; Decimal)
        {

            CalcFormula = sum("BET FN Reference Value Cube"."Purch. Order Outst. Qty." where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter)));
            Caption = 'Ref. Qty. Orders';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5210; "Vgl. VK off. Best."; Decimal)
        {

            CalcFormula = sum("BET FN Reference Value Cube"."Purch. Order Outst. Amt." where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter)));
            Caption = 'Ref. Sales Orders';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5220; "Vgl. EK off. Best."; Decimal)
        {

            CalcFormula = sum("BET FN Reference Value Cube"."Purch. Order Outst. Amt. Net." where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter)));
            Caption = 'Ref. Cost Orders';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5501; "Actual Sales Amount"; Decimal)
        {

            CalcFormula = sum("BET FN Reference Value Cube"."Actual Sales Amount" where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter)));
            Caption = 'Ref. Sales Amount';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5502; "Actual Sales Amount Net"; Decimal)
        {

            CalcFormula = sum("BET FN Reference Value Cube"."Actual Sales Amount Net" where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter)));
            Caption = 'Ref. Sales Amount Net';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5503; "Actual Sal. Am. Discount"; Decimal)
        {

            CalcFormula = sum("BET FN Reference Value Cube"."Actual Sal. Am. Discount" where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter)));
            Caption = 'Ref. Sal. Am. Discount';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5504; "Actual Discount Net"; Decimal)
        {

            CalcFormula = sum("BET FN Reference Value Cube"."Actual Discount Net" where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter)));
            Caption = 'Ref. Discount Net';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5505; "Actual Sales Init. Inv."; Decimal)
        {

            CalcFormula = sum("BET FN Reference Value Cube"."Actual Sales Init. Inv." where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter)));
            Caption = 'Ref. Sales Init. Inv.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5506; "Actual Sales Closing Inv."; Decimal)
        {

            CalcFormula = sum("BET FN Reference Value Cube"."Actual Sales Closing Inv." where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter)));
            Caption = 'Ref. Sales Closing Inv.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5507; "Actual Gross Sales Pr. Red."; Decimal)
        {

            CalcFormula = sum("BET FN Reference Value Cube"."Actual Gross Sales Pr. Red." where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter)));
            Caption = 'Ref. Gross Sales Pr. Reduction';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5508; "Actual Sales Am. Purchase"; Decimal)
        {

            CalcFormula = sum("BET FN Reference Value Cube"."Actual Sales Am. Purchase" where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter)));
            Caption = 'Ref. Sales Am. Purchase';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5509; "Actual Qty. Sale"; Decimal)
        {

            CalcFormula = sum("BET FN Reference Value Cube"."Actual Qty. Sale" where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter)));
            Caption = 'Ref. Qty. Sale';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5510; "Actual Qty. Init. Inv."; Decimal)
        {

            CalcFormula = sum("BET FN Reference Value Cube"."Actual Qty. Init. Inv." where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter)));
            Caption = 'Ref. Qty. Init. Inv.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5511; "Actual Qty. Closing Inv."; Decimal)
        {

            CalcFormula = sum("BET FN Reference Value Cube"."Actual Qty. Closing Inv." where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter)));
            Caption = 'Ref. Qty. Closing Inv.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5512; "Actual Qty. Purchase"; Decimal)
        {

            CalcFormula = sum("BET FN Reference Value Cube"."Actual Qty. Purchase" where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter)));
            Caption = 'Ref. Qty. Purchase';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5513; "Actual Cost of Sales"; Decimal)
        {

            CalcFormula = sum("BET FN Reference Value Cube"."Actual Cost of Sales" where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter)));
            Caption = 'Ref. Cost of Sales';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5514; "Actual Cost Init. Inv."; Decimal)
        {

            CalcFormula = sum("BET FN Reference Value Cube"."Actual Cost Init. Inv." where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter)));
            Caption = 'Ref. Cost Init. Inv.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5515; "Actual Cost Closing Inv."; Decimal)
        {

            CalcFormula = sum("BET FN Reference Value Cube"."Actual Cost Closing Inv." where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter)));
            Caption = 'Ref. Cost Closing Inv.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5516; "Actual Cost Am. Purchase"; Decimal)
        {

            CalcFormula = sum("BET FN Reference Value Cube"."Actual Cost Am. Purchase" where("Planning Document No." = field("Planning Document No."),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Date = field(DateFilter)));
            Caption = 'Ref. Cost Val. Purchase';
            Editable = false;
            FieldClass = FlowField;
        }
        field(8000; "View Plan VK Umsatz"; Decimal)
        {

            CalcFormula = sum("BET FN Planning View"."Plan Sales Amount" where("Planning Document No." = field("Planning Document No."),
                "Planning Document Level" = field("Planning Document Level"),
                Date = field(DateFilter),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Fixed = field(Fixed)));
            Caption = 'View Plan Sales Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(8001; "View Plan VK Rabatt"; Decimal)
        {

            CalcFormula = sum("BET FN Planning View"."Plan Sales Discount" where("Planning Document No." = field("Planning Document No."),
                "Planning Document Level" = field("Planning Document Level"),
                Date = field(DateFilter),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Fixed = field(Fixed)));
            Caption = 'View Plan Sal. Am. Depreciation';
            Editable = false;
            FieldClass = FlowField;
        }
        field(8002; "View Plan VK Abschrift"; Decimal)
        {

            CalcFormula = sum("BET FN Planning View"."Plan Gross Sales Pr. Reduction" where("Planning Document No." = field("Planning Document No."),
                "Planning Document Level" = field("Planning Document Level"),
                Date = field(DateFilter),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Fixed = field(Fixed)));
            Caption = 'View Plan GSPR Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(8003; "View Plan VK WE (Limit)"; Decimal)
        {

            CalcFormula = sum("BET FN Planning View"."Plan Sales Am. Purchase" where("Planning Document No." = field("Planning Document No."),
                "Planning Document Level" = field("Planning Document Level"),
                Date = field(DateFilter),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Fixed = field(Fixed)));
            Caption = 'View Plan Sales Am. Purchase';
            Editable = false;
            FieldClass = FlowField;
        }
        field(8005; "View Plan Menge Umsatz"; Decimal)
        {

            CalcFormula = sum("BET FN Planning View"."Plan Qty. Sale" where("Planning Document No." = field("Planning Document No."),
                "Planning Document Level" = field("Planning Document Level"),
                Date = field(DateFilter),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Fixed = field(Fixed)));
            Caption = 'View Plan Qty. Sale';
            Editable = false;
            FieldClass = FlowField;
        }
        field(8006; "View Plan Menge WE (Limit)"; Decimal)
        {

            CalcFormula = sum("BET FN Planning View"."Plan Qty. Purchase" where("Planning Document No." = field("Planning Document No."),
                "Planning Document Level" = field("Planning Document Level"),
                Date = field(DateFilter),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Fixed = field(Fixed)));
            Caption = 'View Plan Qty. Purchase';
            Editable = false;
            FieldClass = FlowField;
        }
        field(8008; "View Plan EK Umsatz"; Decimal)
        {

            CalcFormula = sum("BET FN Planning View"."Plan Cost of Sales" where("Planning Document No." = field("Planning Document No."),
                "Planning Document Level" = field("Planning Document Level"),
                Date = field(DateFilter),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Fixed = field(Fixed)));
            Caption = 'View Plan Cost of Sales';
            Editable = false;
            FieldClass = FlowField;
        }
        field(8009; "View Plan EK WE (Limit)"; Decimal)
        {

            CalcFormula = sum("BET FN Planning View"."Plan Cost Am. Purchase" where("Planning Document No." = field("Planning Document No."),
                "Planning Document Level" = field("Planning Document Level"),
                Date = field(DateFilter),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Fixed = field(Fixed)));
            Caption = 'View Plan Cost Val. Purchase';
            Editable = false;
            FieldClass = FlowField;
        }
        field(8011; "View Plan VK Anfangsbestand"; Decimal)
        {

            CalcFormula = sum("BET FN Planning View"."Plan Sales Init. Inv." where("Planning Document No." = field("Planning Document No."),
                "Planning Document Level" = field("Planning Document Level"),
                Date = field(DateFilter),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Fixed = field(Fixed)));
            Caption = 'View Plan Sales Init. Inv.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(8012; "View Plan EK Anfangsbestand"; Decimal)
        {

            CalcFormula = sum("BET FN Planning View"."Plan Cost Init. Inv." where("Planning Document No." = field("Planning Document No."),
                "Planning Document Level" = field("Planning Document Level"),
                Date = field(DateFilter),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Fixed = field(Fixed)));
            Caption = 'View Plan Cost Init. Inv.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(8013; "View Plan Menge Anfangsbestand"; Decimal)
        {

            CalcFormula = sum("BET FN Planning View"."Plan Qty. Init. Inv." where("Planning Document No." = field("Planning Document No."),
                "Planning Document Level" = field("Planning Document Level"),
                Date = field(DateFilter),
                "Index 1" = field("Index 1"),
                "Index 2" = field("Index 2"),
                "Index 3" = field("Index 3"),
                "Index 4" = field("Index 4"),
                "Index 5" = field("Index 5"),
                "Index 6" = field("Index 6"),
                Fixed = field(Fixed)));
            Caption = 'View Plan Qty. Init. Inv.';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; Index)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

