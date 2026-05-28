/// <summary>
/// [planning]
/// Modules: 
/// </summary>
table 5138642 "BET FN Planning Document"
{

    Caption = 'Planning Document';
    DrillDownPageId = "BET FN Planning Documents";
    LookupPageId = "BET FN Planning Documents";
    DataClassification = CustomerContent;
    Access = Public;
    Extensible = true;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            ToolTip = 'Specifies the No.';
            trigger OnValidate()
            var
                PlanSetup_LT: Record "BET FN Planning Setup";
                NoSeries: Codeunit "No. Series";
            begin
                if "No." <> xRec."No." then begin
                    PlanSetup_LT.Get();
                    NoSeries.TestManual(PlanSetup_LT."No. Series");
                    "No." := '';
                end;
            end;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
            ToolTip = 'Specifies the Description.';
        }
        field(3; "Purchaser Code"; Code[20])
        {
            Caption = 'Purchaser Code';
            TableRelation = "Salesperson/Purchaser".Code where("BET FN Purchaser Yes No" = const(true));
            ToolTip = 'Specifies the Purchaser Code.';
        }
        field(4; "Purchaser Name"; Text[50])
        {

            CalcFormula = lookup("Salesperson/Purchaser".Name where(Code = field("Purchaser Code")));
            Caption = 'Purchaser Name';
            Editable = false;
            FieldClass = FlowField;
            ToolTip = 'Specifies the Purchaser Name.';
        }
        field(6; "Planning Version"; Option)
        {
            OptionMembers = Origin,Forecast;
            OptionCaption = 'Origin,Forecast';
        }
        field(10; "Financial Year"; Code[10])
        {
            Caption = 'Planning Period';
            TableRelation = "BET FN Financial Year";
            ToolTip = 'Specifies the Financial Year.';
            trigger OnValidate()
            var
                FinancialYear_LT: Record "BET FN Financial Year";
            begin
                if FinancialYear_LT.Get("Financial Year") then begin
                    if "Start Date" = 0D then
                        Validate("Start Date", FinancialYear_LT."Start Date");
                    if "End Date" = 0D then
                        Validate("End Date", FinancialYear_LT."End Date");

                    if FinancialYear_LT."Reference Period" <> '' then
                        Validate("Financial Year Ref. Period", FinancialYear_LT."Reference Period");
                end;
            end;
        }
        field(11; "Planning Type"; Code[20])
        {
            Caption = 'Planning Type';
            TableRelation = "BET FN Planning Type";
            ToolTip = 'Specifies the Planning Type.';
            trigger OnValidate()
            var
                PlanBuffer_LT: Record "BET FN Planning Doc Lvl Buf";
                PlanDocLevel_LT: Record "BET FN Planning Document Level";
                PlanType_LT: Record "BET FN Planning Type";
                BETFNPlanningDocumentMgt: Codeunit "BET FN Planning Document Mgt";
            // InsertPlanningPeriodFirstErr: Label 'Please insert planning period first.';
            begin
                if "Planning Document Created" <> 0DT then
                    exit;

                if ("Start Date" = 0D) or ("End Date" = 0D) then
                    //Error(Text001_L);
                    exit;

                if PlanType_LT.Get("Planning Type") then begin
                    Validate("Layout Template", PlanType_LT."Layout Template");

                    PlanDocLevel_LT.Reset();
                    PlanDocLevel_LT.SetRange("Planning Document No.", "No.");
                    PlanDocLevel_LT.SetFilter("Planning Document Level Index", '>%1', 0);
                    if not PlanDocLevel_LT.IsEmpty() then begin
                        PlanDocLevel_LT.DeleteAll();       //### bestehende Ebenen löschen
                        PlanDocLevel_LT.SetRange("Planning Document Level Index", 0);
                        PlanDocLevel_LT.FindFirst();
                        PlanDocLevel_LT."Path End" := true;
                        PlanDocLevel_LT.Modify();
                    end;

                    "Auto Filter On Level Changing" := PlanType_LT."Auto Filter On Level Changing";

                    BETFNPlanningDocumentMgt.CreateStructureTemplate(Rec, "Planning Type", true);   //### Ebenen laut Vorlage neu erstellen

                    //### Startebene übernehmen:
                    if "Starting Level" = '' then
                        case PlanType_LT."Starting Level" of
                            1:
                                Validate("Starting Level", PlanType_LT.Level1);
                            2:
                                Validate("Starting Level", PlanType_LT.Level2);
                            3:
                                Validate("Starting Level", PlanType_LT.Level3);
                            4:
                                Validate("Starting Level", PlanType_LT.Level4);
                            5:
                                Validate("Starting Level", PlanType_LT.Level5);
                        end;
                end else
                    //### beim Löschen des Planungstyps: Ebenen wieder entfernen
                    if (xRec."Planning Type" <> '') and ("Planning Type" = '') then begin
                        PlanDocLevel_LT.Reset();
                        PlanDocLevel_LT.SetRange("Planning Document No.", "No.");
                        PlanDocLevel_LT.SetFilter("Planning Document Level Index", '>%1', 0);
                        if not PlanDocLevel_LT.IsEmpty() then begin
                            PlanDocLevel_LT.DeleteAll();       //### bestehende Ebenen löschen
                            PlanDocLevel_LT.SetRange("Planning Document Level Index", 0);
                            PlanDocLevel_LT.FindFirst();
                            PlanDocLevel_LT."Path End" := true;
                            PlanDocLevel_LT.Modify();
                        end;

                        PlanBuffer_LT.Reset();
                        PlanBuffer_LT.SetRange("Planning Document No.", "No.");
                        PlanBuffer_LT.DeleteAll();

                        Validate("Starting Level", '');
                    end;
            end;
        }
        field(12; "Financial Year Ref. Period"; Code[10])
        {
            Caption = 'Financial Year';
            TableRelation = "BET FN Financial Year";
            ToolTip = 'Specifies the Financial Year Ref. Period.';
            trigger OnValidate()
            var
                FinancialYear_LT: Record "BET FN Financial Year";
            begin
                if FinancialYear_LT.Get("Financial Year Ref. Period") then begin
                    if "Start Date Ref. Period" = 0D then
                        Validate("Start Date Ref. Period", FinancialYear_LT."Start Date");
                    if "End Date Ref. Period" = 0D then
                        Validate("End Date Ref. Period", FinancialYear_LT."End Date");
                end;
            end;
        }
        field(21; "User ID"; Text[50])
        {
            Caption = 'Changed From User';
        }
        field(22; "Owner ID"; Text[50])
        {
            Caption = 'Created From User';

            trigger OnValidate()
            begin
                SetChanged();
            end;
        }
        field(23; "Last Alteration"; DateTime)
        {
            Caption = 'Last Alteration';
        }
        field(24; "Starting Level"; Code[20])
        {
            Caption = 'Starting Level';
            TableRelation = "BET FN Planning Document Level"."Index Code" where("Planning Document No." = field("No."));
            ValidateTableRelation = false;
            ToolTip = 'Specifies the Starting Level.';
            trigger OnValidate()
            begin
                if "Starting Level" <> '' then
                    "Auto Filter On Level Changing" := false;
            end;
        }
        field(100; "Date Unit"; Option)
        {
            Caption = 'Date Unit';
            Editable = false;
            InitValue = Month;
            OptionCaption = ' ,Day,Week,Month,Quarter,Year';
            OptionMembers = Day,Week,Month,Quarter,Year;

            trigger OnValidate()
            begin
                if "Date Unit" <> xRec."Date Unit" then begin
                    Validate("Start Date");
                    Validate("End Date");
                    Validate("Start Date Ref. Period");
                    Validate("End Date Ref. Period");
                    "No. of Date-Records" := CountDateRecords("Start Date", "End Date");
                    "No. of Ref.-Records" := CountDateRecords("Start Date Ref. Period", "End Date Ref. Period");
                end;
            end;
        }
        field(101; "Start Date"; Date)
        {
            Caption = 'Startdatum';
            ToolTip = 'Specifies the Start Date.';
            trigger OnValidate()
            begin
                //### immer auf Monatsersten setzen:
                if "Planning Document Created" = 0DT then begin
                    if "Start Date" <> 0D then
                        "Start Date" := CalcDate('<-CM>', "Start Date");

                    CheckStartEndDate("Start Date", "End Date");

                    "No. of Date-Records" := CountDateRecords("Start Date", "End Date");
                end;

                Validate("Planning Type", "Planning Type");
            end;
        }
        field(102; "End Date"; Date)
        {
            Caption = 'End Date';
            ToolTip = 'Specifies the End Date.';
            trigger OnValidate()
            begin
                //### immer auf Monatsletzten setzen:
                if "Planning Document Created" = 0DT then begin
                    if "End Date" <> 0D then
                        "End Date" := CalcDate('<+CM>', "End Date");

                    CheckStartEndDate("Start Date", "End Date");

                    "No. of Date-Records" := CountDateRecords("Start Date", "End Date");
                end;

                Validate("Planning Type", "Planning Type");
            end;
        }
        field(103; "No. of Date-Records"; Integer)
        {
            Caption = 'No. of Date-Records';
            ToolTip = 'Specifies the number of Date-Records.';
        }
        field(104; "Planning Document Created"; DateTime)
        {
            Caption = 'Planning Document Created';
            ToolTip = 'Specifies the Planning Document Created.';
        }
        field(105; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Open,Released,Finished';
            OptionMembers = Open,Released,Finished;
            ToolTip = 'Specifies the Status.';
        }
        field(106; "Planning Values Exported"; DateTime)
        {
            Caption = 'Planning Values Exported';
            ToolTip = 'Specifies the Planning Values Exported.';
        }
        field(107; "Start Date Ref. Period"; Date)
        {
            Caption = 'Start Date Reference Period';
            ToolTip = 'Specifies the Start Date Ref. Period.';
            trigger OnValidate()
            begin
                if ("Planning Document Created" = 0DT) and ("Start Date Ref. Period" <> 0D) then begin
                    //### immer auf Monatsersten setzen:
                    "Start Date Ref. Period" := CalcDate('<-CM>', "Start Date Ref. Period");

                    CheckStartEndDate("Start Date Ref. Period", "End Date Ref. Period");

                    "No. of Ref.-Records" := CountDateRecords("Start Date Ref. Period", "End Date Ref. Period");
                end;
            end;
        }
        field(108; "End Date Ref. Period"; Date)
        {
            Caption = 'End Date Reference Period';
            ToolTip = 'Specifies the End Date Ref. Period.';
            trigger OnValidate()
            begin
                if ("Planning Document Created" = 0DT) and ("End Date Ref. Period" <> 0D) then begin
                    "End Date Ref. Period" := CalcDate('<+CM>', "End Date Ref. Period");

                    CheckStartEndDate("Start Date Ref. Period", "End Date Ref. Period");

                    "No. of Ref.-Records" := CountDateRecords("Start Date Ref. Period", "End Date Ref. Period");
                end;
            end;
        }

        field(110; "Last Update Control Doc."; DateTime)
        {
            Caption = 'Last Update Control Doc.';

            ObsoleteState = Pending;
            ObsoleteTag = '25.2';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Last Update Control Doc.';
        }
        field(120; "Auto Filter On Level Changing"; Boolean)
        {
            Caption = 'Auto Filter On Level Changing';
            ToolTip = 'Specifies the Auto Filter On Level Changing.';
            trigger OnValidate()
            begin
                if "Auto Filter On Level Changing" then
                    Clear("Starting Level");
            end;
        }
        field(121; "Calculation Type"; Option)
        {
            Caption = 'Calculation Type';
            OptionCaption = 'Calculation,Margin';
            OptionMembers = Calculation,Margin;
            ToolTip = 'Specifies the Calculation Type.';
        }
        field(122; "Show Date Description"; Boolean)
        {
            Caption = 'Show Date Description';
            ToolTip = 'Specifies the Show Date Description.';
        }
        field(200; "Related Planning Document No."; Code[20])
        {
            Caption = 'Related Planning Document No.';
            ToolTip = 'Specifies the Related Planning Document No.';
        }
        field(205; "Copy From Document No."; Code[20])
        {
            Caption = 'Copy From Document No.';
            ToolTip = 'Specifies the Copy From Document No.';
        }
        field(206; "Is Copy"; Boolean)
        {
            Caption = 'Is Copy';
            ToolTip = 'Specifies the Is Copy.';
        }
        field(210; "Fixed Value"; Option)
        {
            Caption = 'Fixed Value';
            OptionCaption = 'Sales,Purchase,Inventory';
            OptionMembers = Umsatz,WE,Bestand;

            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Pending removal - field will be removed in future updates';
        }
        field(321; "Timestamp Planning Values"; DateTime)
        {
            Caption = 'Timestamp Planning Values';
            ToolTip = 'Specifies the Timestamp Planning Values.';
        }
        field(322; "Timestamp Reference Values"; DateTime)
        {
            Caption = 'Timestamp Reference Values';
            ToolTip = 'Specifies the Timestamp Reference Values.';
        }
        field(500; "Planning Season"; Code[10])
        {
            Caption = 'Planungssaison';
            ToolTip = 'Specifies the Planning Season.';
            trigger OnLookup()
            var
                Season_LT: Record "BET FN Season";
            begin
                Season_LT.Reset();
                if Season_LT.Find('-') then begin
                    "Date Unit" := "Date Unit"::Month;
                    if Page.RunModal(Page::"BET FN Season", Season_LT) = Action::LookupOK then
                        if "Planning Document Created" = 0DT then
                            Validate("Planning Season", Season_LT.Code);
                end;
            end;

            trigger OnValidate()
            var
                Season2_LT: Record "BET FN Season";
                Season_LT: Record "BET FN Season";
                SeasonDoesNotExistErr: Label 'Season %1 does not exist.', Comment = '%1';
            begin
                if ("Planning Document Created" = 0DT) and
                   ("Planning Season" <> '') then
                    if Season_LT.Get("Planning Season") then begin
                        //if ("Start Date" = 0D) and ("End Date" = 0D) then begin  //### wenn Start-/Endedatum leer, dann von Saison übernehmen
                        Validate("Start Date", Season_LT."Starting Date");
                        Validate("End Date", Season_LT."End Date");
                        //end;
                        if Season2_LT.Get(Season_LT."Season To Compare") then
                            if "Comparing Season" = '' then
                                Validate("Comparing Season", Season2_LT.Code);
                    end else
                        Error(SeasonDoesNotExistErr, "Planning Season");
            end;
        }
        field(501; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Planning Document,Control Document';
            OptionMembers = "Planning Document","Control Document";

            ObsoleteState = Pending;
            ObsoleteTag = '25.2';
            ObsoleteReason = '#19247 Pending removal - field will be removed in future updates';
            ToolTip = 'Specifies the Document Type.';
        }
        field(503; "Distribution Type"; Option)
        {
            Caption = 'Distribution Type';
            OptionCaption = 'Reference Values,Planning Values,Distribution Template';
            OptionMembers = Vergleichswerte,Planwerte,DistributionTemplate;
            ToolTip = 'Specifies the Distribution Type.';
        }
        field(504; "Comparing Season"; Code[10])
        {
            Caption = 'Reference Season';
            ToolTip = 'Specifies the Comparing Season.';
            trigger OnLookup()
            var
                Season_LT: Record "BET FN Season";
            begin
                Season_LT.Reset();
                if Season_LT.Find('-') then begin
                    "Date Unit" := "Date Unit"::Month;
                    if Page.RunModal(Page::"BET FN Season", Season_LT) = Action::LookupOK then
                        if "Planning Document Created" = 0DT then
                            Validate("Comparing Season", Season_LT.Code);
                end;
            end;

            trigger OnValidate()
            var
                Season_LT: Record "BET FN Season";
                SeasonDoesNotExistErr: Label 'Season %1 does not exist.', Comment = '%1';
            begin
                if ("Planning Document Created" = 0DT) and
                   ("Comparing Season" <> '') then
                    if Season_LT.Get("Comparing Season") then begin
                        if ("Start Date Ref. Period" = 0D) and ("End Date Ref. Period" = 0D) then begin
                            Validate("Start Date Ref. Period", Season_LT."Starting Date");
                            Validate("End Date Ref. Period", Season_LT."End Date");
                        end;
                    end else
                        Error(SeasonDoesNotExistErr, "Comparing Season");
            end;
        }
        field(505; "Use Global Layout"; Boolean)
        {
            Caption = 'Use Global Layout';
            ToolTip = 'Specifies whether to use the global Layout.';
        }
        field(506; "No. of Ref.-Records"; Integer)
        {
            Caption = 'No. of Ref.-Records';
            ToolTip = 'Specifies the number of Ref.-Records.';
        }
        field(508; "Default Dependency Template"; Code[20])
        {
            Caption = 'Default Dependency Template';
            TableRelation = "BET FN Dependency Matrix Tmplt";

            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(509; "Layout Template"; Code[20])
        {
            Caption = 'Layout Template';
            TableRelation = "BET FN Planning Layout Tmplt";
            ToolTip = 'Specifies the GlobalLayout.';
        }
        field(660; "Correct Inventory"; Boolean)
        {
            Caption = 'Correct Inventory';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(1000; "Sales Value"; Option)
        {
            Caption = 'Sales Value';
            OptionCaption = 'Quantity,Sales Price';
            OptionMembers = Quantity,"Sales Price";

            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(1001; "Cost Value"; Option)
        {
            Caption = 'Cost Value';
            OptionCaption = 'Quantity,Unit Price';
            OptionMembers = Quantity,"Unit Price";

            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(1002; Quantity; Option)
        {
            Caption = 'Quantity';
            OptionCaption = 'Prices,Values';
            OptionMembers = Prices,Values;

            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(1003; "Sales Price"; Option)
        {
            Caption = 'Sales Price';
            OptionCaption = 'Sales Value,Quantity';
            OptionMembers = "Sales Value",Quantity;

            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(1004; "Unit Price"; Option)
        {
            Caption = 'Unit Price';
            OptionCaption = 'Cost Value,Quantity';
            OptionMembers = "Cost Value",Quantity;

            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(1005; Margin; Option)
        {
            Caption = 'Margin';
            OptionCaption = 'Sales Value,Cost Value';
            OptionMembers = "Sales Value","Cost Value";

            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(1006; "CiP Sales Value"; Option)
        {
            Caption = 'Sales Value';
            OptionCaption = 'Change in Prices,Sales Value incl. CiP';
            OptionMembers = "Change in Prices","Sales Value incl. CiP";

            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(1007; "CiP Change in Prices"; Option)
        {
            Caption = 'CiP Change in Prices Value';
            OptionCaption = 'Sales Value,Sales Value incl. CiP';
            OptionMembers = "Sales Value","Sales Value incl. CiP";

            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(1008; "CiP Sales Value incl. CiP"; Option)
        {
            Caption = 'Sales Value incl. CiP';
            OptionCaption = 'Sales Value,Change in Prices';
            OptionMembers = "Sales Value","Change in Prices";

            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(1009; "Sales Value (Margin)"; Option)
        {
            Caption = 'Sales Value (Margin)';
            OptionCaption = 'Cost Value,Margin';
            OptionMembers = "Cost Value",Margin;

            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(1010; "Cost Value (Margin)"; Option)
        {
            Caption = 'Cost Value (Margin)';
            OptionCaption = 'Sales Value,Margin';
            OptionMembers = "Sales Value",Margin;

            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(12010; "Plan Sales Amount"; Boolean)
        {
            Caption = 'Plan Sales Amount';

            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(12011; "Plan Sal. Am. Difference %"; Boolean)
        {
            Caption = 'Plan Sal. Am. Difference %';

            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(12012; "Plan Sal. Am. incl. Discount"; Boolean)
        {
            Caption = 'Plan Sal. Am. incl. Discount';

            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(12013; "Plan Sales Percentage"; Boolean)
        {
            Caption = 'Plan Sales Percentage';

            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(12020; "Plan Sales Discount"; Boolean)
        {
            Caption = 'Plan Sales Discount';

            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(12021; "Plan Sales Discount %"; Boolean)
        {
            Caption = 'Plan Sales Discount %';

            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(12030; "Plan Sales Init. Inv."; Boolean)
        {
            Caption = 'Plan Sales Init. Inv.';

            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(12031; "Plan Sales Closing Inv."; Boolean)
        {
            Caption = 'Plan Sales Closing Inv.';

            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(12032; "Plan Sales Inv. Change"; Boolean)
        {
            Caption = 'Plan Sales Inv. Change';

            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(12040; "Plan Gross Sales Pr. Reduction"; Boolean)
        {
            Caption = 'Plan Gross Sales Pr. Reduction';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(12041; "Plan Gross Sales Pr. Red. %"; Boolean)
        {
            Caption = 'Plan Gross Sales Pr. Red. %';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(12050; "Plan Sales Am. Purchase"; Boolean)
        {
            Caption = 'Plan Sales Am. Purchase';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(12060; "Plan Sales Avg. Inv."; Boolean)
        {
            Caption = 'Plan Sales Avg. Inv.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(12110; "Plan Qty. Sale"; Boolean)
        {
            Caption = 'Plan Qty. Sale';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(12111; "Plan Qty. Sale Diff. %"; Boolean)
        {
            Caption = 'Plan Qty. Sale Diff. %';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(12130; "Plan Qty. Init. Inv."; Boolean)
        {
            Caption = 'Plan Qty. Init. Inv.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(12131; "Plan Qty. Closing Inv."; Boolean)
        {
            Caption = 'Plan Qty. Closing Inv.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(12132; "Plan Qty. Inv. Change"; Boolean)
        {
            Caption = 'Plan Qty. Inv. Change';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(12133; "Plan Qty. Closing Inv. %"; Boolean)
        {
            Caption = 'Plan Qty. Closing Inv. %';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(12150; "Plan Qty. Purchase"; Boolean)
        {
            Caption = 'Plan Qty. Purchase';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(12160; "Plan Qty. Avg. Inv."; Boolean)
        {
            Caption = 'Plan Qty. Avg. Inv.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(12210; "Plan Cost of Sales"; Boolean)
        {
            Caption = 'Plan Cost of Sales';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(12211; "Plan Cost of Sales %"; Boolean)
        {
            Caption = 'Plan Cost of Sales %';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(12230; "Plan Cost Init. Inv."; Boolean)
        {
            Caption = 'Plan Cost Init. Inv.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(12231; "Plan Cost Closing Inv."; Boolean)
        {
            Caption = 'Plan Cost Closing Inv.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(12232; "Plan Cost Inv. Change"; Boolean)
        {
            Caption = 'Plan Cost Inv. Change';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(12250; "Plan Cost Am. Purchase"; Boolean)
        {
            Caption = 'Plan Cost Val. Purchase';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(12251; "Plan Cost Am. Purch. 1-5"; Boolean)
        {
            Caption = 'Plan Cost Am. Purch. 1-5';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(12260; "Plan Cost Avg. Inv."; Boolean)
        {
            Caption = 'Plan Cost Avg. Inv.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(12310; "Plan S.Price Sales"; Boolean)
        {
            Caption = 'Plan S.Price Sales';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(12320; "Plan S.Price incl. Discount"; Boolean)
        {
            Caption = 'Plan S.Price incl. Discount';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(12330; "Plan S.Price Purchase"; Boolean)
        {
            Caption = 'Plan S.Price Purchase';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(12340; "Plan S.Price Init. Inv."; Boolean)
        {
            Caption = 'Plan S.Price Init. Inv.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(12350; "Plan S.Price Closing Inv."; Boolean)
        {
            Caption = 'Plan S.Price Closing Inv.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(12410; "Plan P.Price Sales"; Boolean)
        {
            Caption = 'Plan P.Price Sales';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(12430; "Plan P.Price Purchase"; Boolean)
        {
            Caption = 'Plan P.Price Purchase';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(12440; "Plan P.Price Init. Inv."; Boolean)
        {
            Caption = 'Plan P.Price Init. Inv.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(12450; "Plan P.Price Closing Inv."; Boolean)
        {
            Caption = 'Plan P.Price Closing Inv.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(12510; "Plan Inv. Turnover"; Boolean)
        {
            Caption = 'Plan Inv. Turnover';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(12520; "Plan Calc. Sales %"; Boolean)
        {
            Caption = 'Plan Calc. Sales %';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(12530; "Plan Calc. Sales incl. Disc. %"; Boolean)
        {
            Caption = 'Plan Calc. Sales incl. Disc. %';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(12540; "Plan Calc. Purchase %"; Boolean)
        {
            Caption = 'Plan Calc. Purchase %';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(12550; "Plan Calc. Init. Inv. %"; Boolean)
        {
            Caption = 'Plan Calc. Init. Inv. %';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(12560; "Plan Calc. Closing Inv. %"; Boolean)
        {
            Caption = 'Plan Calc. Closing Inv. %';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(13010; "Ref. Sales Amount"; Boolean)
        {
            Caption = 'Ref. Sales Amount';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(13012; "Ref. Sal. Am. incl. Discount"; Boolean)
        {
            Caption = 'Ref. Sal. Am. incl. Discount';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(13013; "Ref. Sales Percentage"; Boolean)
        {
            Caption = 'Ref. Sales Percentage';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(13020; "Ref. Sal. Am. Discount"; Boolean)
        {
            Caption = 'Ref. Sal. Am. Discount';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(13021; "Ref. Sal. Am. Discount %"; Boolean)
        {
            Caption = 'Ref. Sal. Am. Discount %';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(13030; "Ref. Sales Init. Inv."; Boolean)
        {
            Caption = 'Ref. Sales Init. Inv.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(13031; "Ref. Sales Closing Inv."; Boolean)
        {
            Caption = 'Ref. Sales Closing Inv.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(13032; "Ref. Sales Inv. Change"; Boolean)
        {
            Caption = 'Ref. Sales Inv. Change';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(13040; "Ref. Gross Sales Pr. Reduction"; Boolean)
        {
            Caption = 'Ref. Gross Sales Pr. Reduction';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(13041; "Ref. Gross Sales Pr. Red. %"; Boolean)
        {
            Caption = 'Ref. Gross Sales Pr. Red. %';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(13050; "Ref. Sales Am. Purchase"; Boolean)
        {
            Caption = 'Ref. Sales Am. Purchase';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(13060; "Ref. Sales Avg. Inv."; Boolean)
        {
            Caption = 'Ref. Sales Avg. Inv.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(13110; "Ref. Qty. Sale"; Boolean)
        {
            Caption = 'Ref. Qty. Sale';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(13130; "Ref. Qty. Init. Inv."; Boolean)
        {
            Caption = 'Ref. Qty. Init. Inv.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(13131; "Ref. Qty. Closing Inv."; Boolean)
        {
            Caption = 'Ref. Qty. Closing Inv.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(13132; "Ref. Qty. Inv. Change"; Boolean)
        {
            Caption = 'Ref. Qty. Inv. Change';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(13133; "Ref. Qty. Closing Inv. %"; Boolean)
        {
            Caption = 'Ref. Qty. Closing Inv. %';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(13150; "Ref. Qty. Purchase"; Boolean)
        {
            Caption = 'Ref. Qty. Purchase';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(13160; "Ref. Qty. Avg. Inv."; Boolean)
        {
            Caption = 'Ref. Qty. Avg. Inv.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(13210; "Ref. Cost of Sales"; Boolean)
        {
            Caption = 'Ref. Cost of Sales';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(13230; "Ref. Cost Init. Inv."; Boolean)
        {
            Caption = 'Ref. Cost Init. Inv.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(13231; "Ref. Cost Closing Inv."; Boolean)
        {
            Caption = 'Ref. Cost Closing Inv.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(13232; "Ref. Cost Inv. Change"; Boolean)
        {
            Caption = 'Ref. Cost Inv. Change';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(13250; "Ref. Cost Am. Purchase"; Boolean)
        {
            Caption = 'Ref. Cost Val. Purchase';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(13260; "Ref. Cost Avg. Inv."; Boolean)
        {
            Caption = 'Ref. Cost Avg. Inv.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(13310; "Ref. S.Price Sales"; Boolean)
        {
            Caption = 'Ref. S.Price Sales';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(13320; "Ref. S.Price incl. Discount"; Boolean)
        {
            Caption = 'Ref. S.Price incl. Discount';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(13330; "Ref. S.Price Purchase"; Boolean)
        {
            Caption = 'Ref. S.Price Purchase';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(13340; "Ref. S.Price Init. Inv."; Boolean)
        {
            Caption = 'Ref. S.Price Init. Inv.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(13350; "Ref. S.Price Closing Inv."; Boolean)
        {
            Caption = 'Ref. S.Price Closing Inv.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(13410; "Ref. P.Price Sales"; Boolean)
        {
            Caption = 'Ref. P.Price Sales';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(13430; "Ref. P.Price Purchase"; Boolean)
        {
            Caption = 'Ref. P.Price Purchase';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(13440; "Ref. P.Price Init. Inv."; Boolean)
        {
            Caption = 'Ref. P.Price Init. Inv.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(13450; "Ref. P.Price Closing Inv."; Boolean)
        {
            Caption = 'Ref. P.Price Closing Inv.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(13510; "Ref. Inv. Turnover"; Boolean)
        {
            Caption = 'Ref. Inv. Turnover';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(13520; "Ref. Calc. Sales %"; Boolean)
        {
            Caption = 'Ref. Calc. Sales %';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(13530; "Ref. Calc. Sales incl. Disc. %"; Boolean)
        {
            Caption = 'Ref. Calc. Sales incl. Disc. %';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(13540; "Ref. Calc. Purchase %"; Boolean)
        {
            Caption = 'Ref. Calc. Purchase %';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(13550; "Ref. Calc. Init. Inv. %"; Boolean)
        {
            Caption = 'Ref. Calc. Init. Inv. %';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(13560; "Ref. Calc. Closing Inv. %"; Boolean)
        {
            Caption = 'Ref. Calc. Closing Inv. %';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(13900; "Actual Sales Amount"; Boolean)
        {
            Caption = 'Actual Sales Amount';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(13901; "Actual Sal. Am. Discount"; Boolean)
        {
            Caption = 'Actual Sal. Am. Discount';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(13902; "Actual Sales Init. Inv."; Boolean)
        {
            Caption = 'Actual Sales Init. Inv.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(13903; "Actual Sales Closing Inv."; Boolean)
        {
            Caption = 'Actual Sales Closing Inv.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(13904; "Actual Gross Sales Pr. Red."; Boolean)
        {
            Caption = 'Actual Gross Sales Pr. Red.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(13905; "Actual Sales Am. Purchase"; Boolean)
        {
            Caption = 'Actual Sales Am. Purchase';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(13906; "Actual Qty. Sale"; Boolean)
        {
            Caption = 'Actual Qty. Sale';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(13907; "Actual Qty. Init. Inv."; Boolean)
        {
            Caption = 'Actual Qty. Init. Inv.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(13908; "Actual Qty. Closing Inv."; Boolean)
        {
            Caption = 'Actual Qty. Closing Inv.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(13909; "Actual Qty. Purchase"; Boolean)
        {
            Caption = 'Actual Qty. Purchase';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(13910; "Actual Cost of Sales"; Boolean)
        {
            Caption = 'Actual Cost of Sales';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(13911; "Actual Cost Init. Inv."; Boolean)
        {
            Caption = 'Actual Cost Init. Inv.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(13912; "Actual Cost Closing Inv."; Boolean)
        {
            Caption = 'Actual Cost Closing Inv.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(13913; "Actual Cost Am. Purchase"; Boolean)
        {
            Caption = 'Actual Cost Am. Purchase';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(13914; "Actual Sales Amount Net."; Boolean)
        {
            Caption = 'Actual Sales Amount';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(14000; "Free Purchase Limit"; Boolean)
        {
            Caption = 'Free Purchase Limit';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(14001; "Purch. Order Outst. Qty."; Boolean)
        {
            Caption = 'Purch. Order Outst. Qty.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(14002; "Purch. Order Outst. Amt."; Boolean)
        {
            Caption = 'Purch. Order Outst. Amt.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(14003; "Purch. Order Outst. Amt. Net."; Boolean)
        {
            Caption = 'Purch. Order Outst. Amt. Net.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(14200; "Plan Target Sales Amount"; Boolean)
        {
            Caption = 'Plan Target Sales Amount';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(14201; "Plan Target Discount"; Boolean)
        {
            Caption = 'Plan Target Discount';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(14202; "Plan Target Sales Init. Inv."; Boolean)
        {
            Caption = 'Plan Target Sales Init. Inv.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(14203; "Plan Target Sales Inv."; Boolean)
        {
            Caption = 'Plan Target Sales Inv.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(14204; "Plan Target G.S.P. Reduction"; Boolean)
        {
            Caption = 'Plan Target G.S.P. Reduction';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(14205; "Plan Target Sal. Am. Purch."; Boolean)
        {
            Caption = 'Plan Target Sal. Am. Purch.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(14210; "Plan Target Qty. Sale"; Boolean)
        {
            Caption = 'Plan Target Qty. Turnover';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(14211; "Plan Target Qty. Init. Inv."; Boolean)
        {
            Caption = 'Plan Target Qty. Init. Inv.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(14212; "Plan Target Qty. Closing Inv."; Boolean)
        {
            Caption = 'Plan Target Qty. Closing Inv.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(14213; "Plan Target Qty. Purchase"; Boolean)
        {
            Caption = 'Plan Target Qty. Purchase';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(14220; "Plan Target Cost of Sales"; Boolean)
        {
            Caption = 'Plan Target Cost of Sales';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(14221; "Plan Target Cost Init. Inv."; Boolean)
        {
            Caption = 'Plan Target Cost Init. Inv.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(14222; "Plan Target Cost Inv."; Boolean)
        {
            Caption = 'Plan Target Cost Inv.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(14223; "Plan Target Cost Am. Purch."; Boolean)
        {
            Caption = 'Plan Target Cost Val. Purch.';
            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        BETFNHelpersGeneral: Codeunit "BET FN Helpers General";

    trigger OnDelete()
    var
        BETFNPlanningFunctions: Codeunit "BET FN Planning Functions";
    begin
        BETFNPlanningFunctions.DeletePlanDoc(Rec);
    end;

    trigger OnInsert()
    var
        BETFNPlanningFunctions: Codeunit "BET FN Planning Functions";
    begin
        BETFNPlanningFunctions.InsertPlanDoc(Rec);
    end;

    /// <summary>
    /// CountDateRecords.
    /// </summary>
    /// <param name="StartDate_P">Date.</param>
    /// <param name="EndDate_P">Date.</param>
    /// <returns>Return value of type Integer.</returns>
    procedure CountDateRecords(StartDate_P: Date; EndDate_P: Date): Integer
    var
        Date_LT: Record Date;
    begin
        Date_LT.Reset();
        Date_LT.SetRange("Period Type", "Date Unit");
        Date_LT.SetRange("Period Start", StartDate_P, EndDate_P);
        if (StartDate_P = 0D) or (EndDate_P = 0D) then
            exit(0)
        else
            exit(Date_LT.Count());
    end;

    /// <summary>
    /// AssistEdit.
    /// </summary>
    /// <param name="OldDoc_PT">Record "BET FN Planning Document".</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure AssistEdit(OldDoc_PT: Record "BET FN Planning Document"): Boolean
    var
        PlanDoc_LT: Record "BET FN Planning Document";
        PlanSetup_LT: Record "BET FN Planning Setup";
        NoSeries_LT: Record "No. Series";
        NoSeries: Codeunit "No. Series";
        BETFNHelpersSetup: Codeunit "BET FN Helpers - Setup";
        NoSeriesDoesNotExistErr: Label 'No. series %1 does not exist.', Comment = '%1';
    begin
        PlanDoc_LT := Rec;
        PlanSetup_LT.Get();
        if PlanSetup_LT."No. Series" = '' then
            BETFNHelpersSetup.TestSetupFields(Database::"BET FN Planning Setup", PlanSetup_LT.FieldNo("No. Series"));

        if not NoSeries_LT.Get(PlanSetup_LT."No. Series") then
            Error(NoSeriesDoesNotExistErr, PlanSetup_LT."No. Series");

        if NoSeries.LookupRelatedNoSeries(PlanSetup_LT."No. Series", OldDoc_PT."No.", PlanDoc_LT."No.")
        then begin
            PlanSetup_LT.Get();
            if PlanSetup_LT."No. Series" = '' then
                BETFNHelpersSetup.TestSetupFields(Database::"BET FN Planning Setup", PlanSetup_LT.FieldNo("No. Series"));
            Rec := PlanDoc_LT;
            Rec."No." := NoSeries.GetNextNo(PlanSetup_LT."No. Series");
            exit(true);
        end;

    end;

    /// <summary>
    /// GetIndexField.
    /// </summary>
    /// <param name="PlanDocNo_P">Code[20].</param>
    /// <param name="IndexCode_P">Code[20].</param>
    /// <returns>Return value of type Integer.</returns>
    [Obsolete('#35131 Pending removal - procedure will be removed in future', '25.2')]
    procedure GetIndexField(PlanDocNo_P: Code[20]; IndexCode_P: Code[20]): Integer
    var
        PlanDocLevel_LT: Record "BET FN Planning Document Level";
    begin
        PlanDocLevel_LT.Reset();
        PlanDocLevel_LT.SetRange("Planning Document No.", PlanDocNo_P);
        PlanDocLevel_LT.SetRange("Index Code", IndexCode_P);
        if PlanDocLevel_LT.FindFirst() then begin
            if PlanDocLevel_LT."Index Code 1" = IndexCode_P then
                exit(1);
            if PlanDocLevel_LT."Index Code 2" = IndexCode_P then
                exit(2);
            if PlanDocLevel_LT."Index Code 3" = IndexCode_P then
                exit(3);
            if PlanDocLevel_LT."Index Code 4" = IndexCode_P then
                exit(4);
            if PlanDocLevel_LT."Index Code 5" = IndexCode_P then
                exit(5);
            if PlanDocLevel_LT."Index Code 6" = IndexCode_P then
                exit(6);
        end;
    end;

    /// <summary>
    /// SetChanged.
    /// </summary>
    procedure SetChanged()
    begin
        "User ID" := BETFNHelpersGeneral.ReturnUserId();
        "Last Alteration" := CurrentDateTime();
    end;

    /// <summary>
    /// CheckStartEndDate.
    /// </summary>
    /// <param name="StartDate_P">Date.</param>
    /// <param name="EndDate_P">Date.</param>
    procedure CheckStartEndDate(StartDate_P: Date; EndDate_P: Date)
    var
        EndDateMustBeLaterThanStartDateErr: Label 'End Date must be later than Start Date.';
    begin
        if (StartDate_P <> 0D) and (EndDate_P <> 0D) and (EndDate_P < StartDate_P) then
            Error(EndDateMustBeLaterThanStartDateErr);
    end;
}