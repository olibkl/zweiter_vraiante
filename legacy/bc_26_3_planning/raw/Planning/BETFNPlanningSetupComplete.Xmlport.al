/// <summary>
/// [planning]
/// Modules: 
/// </summary>
#pragma warning disable AL0432
xmlport 5138633 "BET FN Planning Setup Complete"
{
    Caption = 'Planning Setup Complete';
    DefaultFieldsValidation = false;
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement("Planning Setup"; "BET FN Planning Setup")
            {
                XmlName = 'PlanningSetup';
                fieldelement(SETUP_01; "Planning Setup".Index)
                {
                }
                fieldelement(SETUP_02; "Planning Setup"."No. of Records for Warning")
                {
                }
                fieldelement(SETUP_04; "Planning Setup"."No. Series")
                {
                }
                fieldelement(SETUP_07; "Planning Setup"."Dateformula Outst. Orders")
                {
                }
                fieldelement(SETUP_08; "Planning Setup"."Export Table No.")
                {
                }
                fieldelement(SETUP_09; "Planning Setup"."Date Field in Export Table")
                {
                }
                fieldelement(SETUP_10; "Planning Setup"."PK Field in Export Table")
                {
                }
                fieldelement(SETUP_11; "Planning Setup"."Doc. No. Field in Export Table")
                {
                }
                fieldelement(SETUP_12; "Planning Setup"."Export Season")
                {
                }
                fieldelement(SETUP_13; "Planning Setup"."Season Field in Export Table")
                {
                }
                fieldelement(SETUP_14; "Planning Setup"."Default Layout Template")
                {
                }
                fieldelement(SETUP_15; "Planning Setup"."Auto Filter On Level Changing")
                {
                }
                fieldelement(SETUP_16; "Planning Setup"."Default Calculation Type")
                {
                }
            }
            tableelement("Financial Year"; "BET FN Financial Year")
            {
                XmlName = 'FinancialYear';
                fieldelement(FY_01; "Financial Year".Code)
                {
                }
                fieldelement(FY_02; "Financial Year".Description)
                {
                }
                fieldelement(FY_03; "Financial Year"."Start Date")
                {
                }
                fieldelement(FY_04; "Financial Year"."End Date")
                {
                }
            }
            tableelement("Planning Layout Template"; "BET FN Planning Layout Tmplt")
            {
                XmlName = 'PlanningLayoutTemplate';
                fieldelement(LAYOUT_01; "Planning Layout Template".Code)
                {
                }
                fieldelement(LAYOUT_02; "Planning Layout Template".Description)
                {
                }
                fieldelement(LAYOUT_03; "Planning Layout Template"."Plan Sales Amount")
                {
                }
                fieldelement(LAYOUT_04; "Planning Layout Template"."Plan Sal. Am. Difference %")
                {
                }
                fieldelement(LAYOUT_05; "Planning Layout Template"."Plan Sal. Am. incl. Discount")
                {
                }
                fieldelement(LAYOUT_06; "Planning Layout Template"."Plan Sales Discount")
                {
                }
                fieldelement(LAYOUT_07; "Planning Layout Template"."Plan Sales Discount %")
                {
                }
                fieldelement(LAYOUT_08; "Planning Layout Template"."Plan Sales Init. Inv.")
                {
                }
                fieldelement(LAYOUT_09; "Planning Layout Template"."Plan Sales Closing Inv.")
                {
                }
                fieldelement(LAYOUT_10; "Planning Layout Template"."Plan Sales Inv. Change")
                {
                }
                fieldelement(LAYOUT_11; "Planning Layout Template"."Plan Gross Sales Pr. Reduction")
                {
                }
                fieldelement(LAYOUT_12; "Planning Layout Template"."Plan Gross Sales Pr. Red. %")
                {
                }
                fieldelement(LAYOUT_13; "Planning Layout Template"."Plan Sales Am. Purchase")
                {
                }
                fieldelement(LAYOUT_14; "Planning Layout Template"."Plan Sales Avg. Inv.")
                {
                }
                fieldelement(LAYOUT_15; "Planning Layout Template"."Plan Qty. Sale")
                {
                }
                fieldelement(LAYOUT_16; "Planning Layout Template"."Plan Qty. Sale Diff. %")
                {
                }
                fieldelement(LAYOUT_17; "Planning Layout Template"."Plan Qty. Init. Inv.")
                {
                }
                fieldelement(LAYOUT_18; "Planning Layout Template"."Plan Qty. Closing Inv.")
                {
                }
                fieldelement(LAYOUT_19; "Planning Layout Template"."Plan Qty. Inv. Change")
                {
                }
                fieldelement(LAYOUT_20; "Planning Layout Template"."Plan Qty. Closing Inv. %")
                {
                }
                fieldelement(LAYOUT_21; "Planning Layout Template"."Plan Qty. Purchase")
                {
                }
                fieldelement(LAYOUT_22; "Planning Layout Template"."Plan Qty. Avg. Inv.")
                {
                }
                fieldelement(LAYOUT_23; "Planning Layout Template"."Plan Cost of Sales")
                {
                }
                fieldelement(LAYOUT_24; "Planning Layout Template"."Plan Cost of Sales %")
                {
                }
                fieldelement(LAYOUT_25; "Planning Layout Template"."Plan Cost Init. Inv.")
                {
                }
                fieldelement(LAYOUT_26; "Planning Layout Template"."Plan Cost Closing Inv.")
                {
                }
                fieldelement(LAYOUT_27; "Planning Layout Template"."Plan Cost Inv. Change")
                {
                }
                fieldelement(LAYOUT_28; "Planning Layout Template"."Plan Cost Am. Purchase")
                {
                }
                fieldelement(LAYOUT_29; "Planning Layout Template"."Plan Cost Am. Purch. 1-5")
                {
                }
                fieldelement(LAYOUT_30; "Planning Layout Template"."Plan Cost Avg. Inv.")
                {
                }
                fieldelement(LAYOUT_31; "Planning Layout Template"."Plan S.Price Sales")
                {
                }
                fieldelement(LAYOUT_32; "Planning Layout Template"."Plan S.Price incl. Discount")
                {
                }
                fieldelement(LAYOUT_33; "Planning Layout Template"."Plan S.Price Purchase")
                {
                }
                fieldelement(LAYOUT_34; "Planning Layout Template"."Plan S.Price Init. Inv.")
                {
                }
                fieldelement(LAYOUT_35; "Planning Layout Template"."Plan S.Price Closing Inv.")
                {
                }
                fieldelement(LAYOUT_36; "Planning Layout Template"."Plan P.Price Sales")
                {
                }
                fieldelement(LAYOUT_37; "Planning Layout Template"."Plan P.Price Purchase")
                {
                }
                fieldelement(LAYOUT_38; "Planning Layout Template"."Plan P.Price Init. Inv.")
                {
                }
                fieldelement(LAYOUT_39; "Planning Layout Template"."Plan P.Price Closing Inv.")
                {
                }
                fieldelement(LAYOUT_40; "Planning Layout Template"."Plan Inv. Turnover")
                {
                }
                fieldelement(LAYOUT_41; "Planning Layout Template"."Plan Calc. Sales %")
                {
                }
                fieldelement(LAYOUT_42; "Planning Layout Template"."Plan Calc. Sales incl. Disc. %")
                {
                }
                fieldelement(LAYOUT_43; "Planning Layout Template"."Plan Calc. Purchase %")
                {
                }
                fieldelement(LAYOUT_44; "Planning Layout Template"."Plan Calc. Init. Inv. %")
                {
                }
                fieldelement(LAYOUT_45; "Planning Layout Template"."Plan Calc. Closing Inv. %")
                {
                }
                fieldelement(LAYOUT_46; "Planning Layout Template"."Ref. Sales Amount")
                {
                }
                fieldelement(LAYOUT_47; "Planning Layout Template"."Ref. Sal. Am. incl. Discount")
                {
                }
                fieldelement(LAYOUT_48; "Planning Layout Template"."Ref. Sales Discount")
                {
                }
                fieldelement(LAYOUT_49; "Planning Layout Template"."Ref. Sales Discount %")
                {
                }
                fieldelement(LAYOUT_50; "Planning Layout Template"."Ref. Sales Init. Inv.")
                {
                }
                fieldelement(LAYOUT_51; "Planning Layout Template"."Ref. Sales Closing Inv.")
                {
                }
                fieldelement(LAYOUT_52; "Planning Layout Template"."Ref. Sales Inv. Change")
                {
                }
                fieldelement(LAYOUT_53; "Planning Layout Template"."Ref. Gross Sales Pr. Reduction")
                {
                }
                fieldelement(LAYOUT_54; "Planning Layout Template"."Ref. Gross Sales Pr. Red. %")
                {
                }
                fieldelement(LAYOUT_55; "Planning Layout Template"."Ref. Sales Am. Purchase")
                {
                }
                fieldelement(LAYOUT_56; "Planning Layout Template"."Ref. Sales Avg. Inv.")
                {
                }
                fieldelement(LAYOUT_57; "Planning Layout Template"."Ref. Qty. Sale")
                {
                }
                fieldelement(LAYOUT_58; "Planning Layout Template"."Ref. Qty. Init. Inv.")
                {
                }
                fieldelement(LAYOUT_59; "Planning Layout Template"."Ref. Qty. Closing Inv.")
                {
                }
                fieldelement(LAYOUT_60; "Planning Layout Template"."Ref. Qty. Inv. Change")
                {
                }
                fieldelement(LAYOUT_61; "Planning Layout Template"."Ref. Qty. Closing Inv. %")
                {
                }
                fieldelement(LAYOUT_62; "Planning Layout Template"."Ref. Qty. Purchase")
                {
                }
                fieldelement(LAYOUT_63; "Planning Layout Template"."Ref. Qty. Avg. Inv.")
                {
                }
                fieldelement(LAYOUT_64; "Planning Layout Template"."Ref. Cost of Sales")
                {
                }
                fieldelement(LAYOUT_65; "Planning Layout Template"."Ref. Cost Init. Inv.")
                {
                }
                fieldelement(LAYOUT_66; "Planning Layout Template"."Ref. Cost Closing Inv.")
                {
                }
                fieldelement(LAYOUT_67; "Planning Layout Template"."Ref. Cost Inv. Change")
                {
                }
                fieldelement(LAYOUT_68; "Planning Layout Template"."Ref. Cost Val. Purchase")
                {
                }
                fieldelement(LAYOUT_69; "Planning Layout Template"."Ref. Cost Avg. Inv.")
                {
                }
                fieldelement(LAYOUT_70; "Planning Layout Template"."Ref. S.Price Sales")
                {
                }
                fieldelement(LAYOUT_71; "Planning Layout Template"."Ref. S.Price incl. Discount")
                {
                }
                fieldelement(LAYOUT_72; "Planning Layout Template"."Ref. S.Price Purchase")
                {
                }
                fieldelement(LAYOUT_73; "Planning Layout Template"."Ref. S.Price Init. Inv.")
                {
                }
                fieldelement(LAYOUT_74; "Planning Layout Template"."Ref. S.Price Closing Inv.")
                {
                }
                fieldelement(LAYOUT_75; "Planning Layout Template"."Ref. P.Price Sales")
                {
                }
                fieldelement(LAYOUT_76; "Planning Layout Template"."Ref. P.Price Purchase")
                {
                }
                fieldelement(LAYOUT_77; "Planning Layout Template"."Ref. P.Price Init. Inv.")
                {
                }
                fieldelement(LAYOUT_78; "Planning Layout Template"."Ref. P.Price Closing Inv.")
                {
                }
                fieldelement(LAYOUT_79; "Planning Layout Template"."Ref. Inv. Turnover")
                {
                }
                fieldelement(LAYOUT_80; "Planning Layout Template"."Ref. Calc. Sales %")
                {
                }
                fieldelement(LAYOUT_81; "Planning Layout Template"."Ref. Calc. Sales incl. Disc. %")
                {
                }
                fieldelement(LAYOUT_82; "Planning Layout Template"."Ref. Calc. Purchase %")
                {
                }
                fieldelement(LAYOUT_83; "Planning Layout Template"."Ref. Calc. Init. Inv. %")
                {
                }
                fieldelement(LAYOUT_84; "Planning Layout Template"."Ref. Calc. Closing Inv. %")
                {
                }
            }
            tableelement("Planning Export Fieldreference"; "BET FN Planning Export Fld Ref")
            {
                XmlName = 'PlanningExportFieldreference';
                fieldelement(EXPORT_01; "Planning Export Fieldreference"."Export Field No.")
                {
                }
                fieldelement(EXPORT_02; "Planning Export Fieldreference"."Cube Field No.")
                {
                }
                fieldelement(EXPORT_03; "Planning Export Fieldreference"."Cube Field Description")
                {
                }
                fieldelement(EXPORT_04; "Planning Export Fieldreference"."Export Field Description")
                {
                }
                fieldelement(EXPORT_05; "Planning Export Fieldreference"."Reverse Sign")
                {
                }
            }
            tableelement("Planning Level"; "BET FN Planning Level")
            {
                XmlName = 'PlanningLevel';
                fieldelement(LEVEL_01; "Planning Level"."Index Code")
                {
                }
                fieldelement(LEVEL_02; "Planning Level"."Index Description")
                {
                }
                fieldelement(LEVEL_03; "Planning Level"."Index Table No.")
                {
                }
                fieldelement(LEVEL_04; "Planning Level"."Assigned to Index")
                {
                }
                fieldelement(LEVEL_05; "Planning Level"."Primary Key Field No.")
                {
                }
                fieldelement(LEVEL_06; "Planning Level"."Description Field No.")
                {
                }
                fieldelement(LEVEL_07; "Planning Level"."Planning Statistic Field")
                {
                }
                fieldelement(LEVEL_08; "Planning Level".Activated)
                {
                }
                fieldelement(LEVEL_09; "Planning Level"."Export Field No.")
                {
                }
                fieldelement(LEVEL_10; "Planning Level"."Fash. Stat. Entry Field")
                {
                }
                fieldelement(LEVEL_11; "Planning Level"."Assigned to Index Field No.")
                {
                }
                fieldelement(LEVEL_12; "Planning Level"."Description in Document")
                {
                }
            }
            tableelement("Planning Type"; "BET FN Planning Type")
            {
                XmlName = 'PlanningType';
                fieldelement(TYPE_01; "Planning Type".Code)
                {
                }
                fieldelement(TYPE_02; "Planning Type".Description)
                {
                }
                fieldelement(TYPE_03; "Planning Type"."Write Planning Entries")
                {
                }
                fieldelement(TYPE_04; "Planning Type"."Layout Template")
                {
                }
                fieldelement(TYPE_05; "Planning Type"."Company Plan")
                {

                }
                fieldelement(TYPE_06; "Planning Type"."Purchase Plan")
                {
                }
                fieldelement(TYPE_07; "Planning Type".Level1)
                {
                }
                fieldelement(TYPE_08; "Planning Type".Level2)
                {
                }
                fieldelement(TYPE_09; "Planning Type".Level3)
                {
                }
                fieldelement(TYPE_10; "Planning Type".Level4)
                {
                }
                fieldelement(TYPE_11; "Planning Type".Level5)
                {
                }
                fieldelement(TYPE_12; "Planning Type".Level6)
                {
                }
                fieldelement(TYPE_13; "Planning Type"."Use Date Level")
                {
                }
                fieldelement(TYPE_14; "Planning Type"."Starting Level")
                {
                }
                fieldelement(TYPE_15; "Planning Type"."Auto Filter On Level Changing")
                {
                }
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }
}

