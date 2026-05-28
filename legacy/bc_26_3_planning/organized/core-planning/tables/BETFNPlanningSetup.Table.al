/// <summary>
/// [planning]
/// Modules: 
/// </summary>
table 5138637 "BET FN Planning Setup"
{

    Caption = 'Planning Setup';
    DataClassification = CustomerContent;
    Access = Public;
    Extensible = true;

    fields
    {
        field(1; Index; Integer)
        {
            Caption = 'Line no.';
        }
        field(50; "Last Value Entry in FSE"; Integer)
        {
            Caption = 'Last Value Entry in FSE';

            ObsoleteState = Pending;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Pending removal - field will be removed in future updates';
        }
        field(60; "SQL User"; Text[30])
        {
            Caption = 'User for SQL queries';

            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(61; "SQL PW"; Text[30])
        {
            Caption = 'Password for SQL queries';

            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(62; "SQL Server"; Text[50])
        {
            Caption = 'EXEC Server';

            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(63; "SQL Database"; Text[50])
        {
            Caption = 'EXEC Database';

            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(65; "Last Update FSE"; Date)
        {
            Caption = 'Last Update Statistic Entries';
        }
        field(101; "No. of Records for Warning"; Integer)
        {
            Caption = 'No. of Records for Warning';
            ToolTip = 'Specifies the number of Records for Warning.';
        }
        field(102; "Calc. Start Inventory"; Boolean)
        {
            Caption = 'Calculate Start Inventory';

            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(103; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
            ToolTip = 'Specifies the No. Series.';
        }
        field(104; "Check For Unsaved Lines"; Boolean)
        {
            Caption = 'Check For Unsaved Lines';
            ToolTip = 'Check for unsaved lines at document release';
        }
        field(105; "No Future Seasons"; Boolean)
        {
            Caption = 'No Future Seasons';

            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the No Future Seasons.';
        }
        field(106; "Assume Reference Values"; Boolean)
        {
            Caption = 'Assume Reference Values';

            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Assume Reference Values.';
        }
        field(107; "Dateformula Outst. Orders"; DateFormula)
        {
            Caption = 'Dateformula Outst. Orders';
            ToolTip = 'Specifies the Dateformula Outst. Orders.';
        }
        field(108; "Default Dependency Template"; Code[20])
        {
            Caption = 'Default Dependency Template';

            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
        }
        field(109; "Show Line Information"; Boolean)
        {
            Caption = 'Show Line Information';
            ToolTip = 'Specifies the Show Line Information.';
        }
        field(110; "Export Table No."; Integer)
        {
            Caption = 'Export Table No.';
            ToolTip = 'Specifies the Export Table No.';
            trigger OnLookup()
            var
                Object_LT: Record AllObjWithCaption;
            begin
                Object_LT.Reset();
                Object_LT.SetRange("Object Type", Object_LT."Object Type"::Table);
                if Page.RunModal(Page::"Table Objects", Object_LT) = Action::LookupOK then
                    "Export Table No." := Object_LT."Object ID";
            end;

            trigger OnValidate()
            var
                Object_LT: Record AllObjWithCaption;
                IndexTableNotFoundErr: Label 'Index Table not found.';
            begin
                if not Object_LT.Get(Object_LT."Object Type"::Table, '', "Export Table No.") then
                    Error(IndexTableNotFoundErr);
            end;
        }
        field(111; "Date Field in Export Table"; Integer)
        {
            Caption = 'Date Field in Export Table';
            ToolTip = 'Specifies the Date Field in Export Table.';
            trigger OnLookup()
            var
                Field_LT: Record "Field";
            begin
                Field_LT.Reset();
                Field_LT.SetRange(TableNo, "Export Table No.");
                if Page.RunModal(Page::"BET FN Fields List", Field_LT) = Action::LookupOK then
                    "Date Field in Export Table" := Field_LT."No.";
            end;
        }
        field(112; "PK Field in Export Table"; Integer)
        {
            Caption = 'PK Field in Export Table';
            ToolTip = 'Specifies the PK Field in Export Table.';
            trigger OnLookup()
            var
                Field_LT: Record "Field";
            begin
                Field_LT.Reset();
                Field_LT.SetRange(TableNo, "Export Table No.");
                if Page.RunModal(Page::"BET FN Fields List", Field_LT) = Action::LookupOK then
                    "PK Field in Export Table" := Field_LT."No.";
            end;
        }
        field(113; "Doc. No. Field in Export Table"; Integer)
        {
            Caption = 'Document No. Field in Export Table';
            ToolTip = 'Specifies the Doc. No. Field in Export Table.';
            trigger OnLookup()
            var
                Field_LT: Record "Field";
            begin
                Field_LT.Reset();
                Field_LT.SetRange(TableNo, "Export Table No.");
                if Page.RunModal(Page::"BET FN Fields List", Field_LT) = Action::LookupOK then
                    "Doc. No. Field in Export Table" := Field_LT."No.";
            end;
        }
        field(114; "Export Season"; Boolean)
        {
            Caption = 'Export Season';
            ToolTip = 'Specifies the Export Season.';
        }
        field(115; "Season Field in Export Table"; Integer)
        {
            Caption = 'Season Field in Export Table';
            ToolTip = 'Specifies the Season Field in Export Table.';
            trigger OnLookup()
            var
                Field_LT: Record "Field";
            begin
                Field_LT.Reset();
                Field_LT.SetRange(TableNo, "Export Table No.");
                if Page.RunModal(Page::"BET FN Fields List", Field_LT) = Action::LookupOK then
                    "Season Field in Export Table" := Field_LT."No.";
            end;
        }
        field(119; "Default Layout Template"; Code[20])
        {
            Caption = 'Default Layout Template';
            TableRelation = "BET FN Planning Layout Tmplt";
            ToolTip = 'Specifies the Default Layout Template.';
        }
        field(120; "Auto Filter On Level Changing"; Boolean)
        {
            Caption = 'Auto Filter On Level Changing';
            ToolTip = 'Specifies the Auto Filter On Level Changing.';
        }
        field(121; "Default Calculation Type"; Option)
        {
            Caption = 'Default Calculation Type';
            OptionCaption = 'Calculation,Margin';
            OptionMembers = Calculation,Margin;

            ObsoleteState = Pending;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Pending removal - field will be removed in future updates';
            ToolTip = 'Specifies the Default Calculation Type.';
        }
        field(122; "Show Fixed Column"; Boolean)
        {
            Caption = 'Show Fixed Column';
            ToolTip = 'Specifies the Show Fixed Column.';
        }
        field(123; "Auto Create Forecast"; Boolean)
        {
            Caption = 'Auto Create Forecast';
        }
        field(150; "Next Update Fash. Stat. Entr."; Option)
        {
            Caption = 'Next Update Fash. Stat. Entr.';
            OptionCaption = 'None,Partially,Complete';
            OptionMembers = None,Partially,Complete;

            ObsoleteState = Pending;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Pending removal - field will be removed in future updates';
            ToolTip = 'Specifies the Next Update Fash. Stat. Entr.';
        }
        field(156; "Calculation RIT"; Option)
        {
            Caption = 'Calculation RIT';
            OptionCaption = 'Sale,Purchase,Quantity';
            OptionMembers = Sale,Purchase,Quantity;

            ObsoleteState = Removed;
            ObsoleteTag = '22.3';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Calculation RIT.';
        }
        field(157; "Use Plan. Dim. Assignments"; Boolean)
        {
            Caption = 'Use Plan. Dim. Assignments';
        }
        field(158; "Create Statistic Entries"; Boolean)
        {
            Caption = 'Create Statistic Entries';
        }
        field(159; "Create Purchase Statistic"; Boolean)
        {
            Caption = 'Create Purchase Statistic';
        }
        field(200; "OTB Level 1"; Code[20])
        {
            Caption = 'OTB Level 1';
            TableRelation = "BET FN Planning Level";
            ToolTip = 'Specifies the SetupLevel1.';
            trigger OnValidate()
            var
                LevelAlreadyExistsErr: Label 'Level already exists.';
            begin
                if "OTB Level 1" <> '' then
                    if ("OTB Level 1" = "OTB Level 2") or
                       ("OTB Level 1" = "OTB Level 3") or
                       ("OTB Level 1" = "OTB Level 4") then
                        Error(LevelAlreadyExistsErr);
            end;
        }
        field(201; "OTB Level 2"; Code[20])
        {
            Caption = 'OTB Level 2';
            TableRelation = "BET FN Planning Level";
            ToolTip = 'Specifies the SetupLevel2.';
            trigger OnValidate()
            var
                LevelAlreadyExistsErr: Label 'Level already exists.';
                LevelMustNotBeEmptyErr: Label 'Level %1 must not be empty.', Comment = '%1';
            begin
                if "OTB Level 1" = '' then
                    Error(LevelMustNotBeEmptyErr, 1);

                if "OTB Level 2" <> '' then
                    if ("OTB Level 2" = "OTB Level 1") or
                       ("OTB Level 2" = "OTB Level 3") or
                       ("OTB Level 2" = "OTB Level 4") then
                        Error(LevelAlreadyExistsErr);
            end;
        }
        field(202; "OTB Level 3"; Code[20])
        {
            Caption = 'OTB Level 3';
            TableRelation = "BET FN Planning Level";
            ToolTip = 'Specifies the SetupLevel3.';
            trigger OnValidate()
            var
                LevelAlreadyExistsErr: Label 'Level already exists.';
                LevelMustNotBeEmptyErr: Label 'Level %1 must not be empty.', Comment = '%1';
            begin
                if "OTB Level 2" = '' then
                    Error(LevelMustNotBeEmptyErr, 2);

                if "OTB Level 3" <> '' then
                    if ("OTB Level 3" = "OTB Level 1") or
                       ("OTB Level 3" = "OTB Level 2") or
                       ("OTB Level 3" = "OTB Level 4") then
                        Error(LevelAlreadyExistsErr);
            end;
        }
        field(203; "OTB Level 4"; Code[20])
        {
            Caption = 'OTB Level 4';
            TableRelation = "BET FN Planning Level";
            ToolTip = 'Specifies the SetupLevel4.';
            trigger OnValidate()
            var
                LevelAlreadyExistsErr: Label 'Level already exists.';
                LevelMustNotBeEmptyErr: Label 'Level %1 must not be empty.', Comment = '%1';
            begin
                if "OTB Level 3" = '' then
                    Error(LevelMustNotBeEmptyErr, 3);

                if "OTB Level 4" <> '' then
                    if ("OTB Level 4" = "OTB Level 1") or
                       ("OTB Level 4" = "OTB Level 2") or
                       ("OTB Level 4" = "OTB Level 3") then
                        Error(LevelAlreadyExistsErr);
            end;
        }
        field(301; "Dimension Assignment 1"; Code[20])
        {
            Caption = 'Dimension Assignment 1';
            TableRelation = "BET FN Planning Level";
            ToolTip = 'Specifies the Dimension Assignment 1.';
        }
        field(302; "Dimension Assignment 2"; Code[20])
        {
            Caption = 'Dimension Assignment 2';
            TableRelation = "BET FN Planning Level";
            ToolTip = 'Specifies the Dimension Assignment 2.';
        }
        field(303; "Dimension Assignment 3"; Code[20])
        {
            Caption = 'Dimension Assignment 3';
            TableRelation = "BET FN Planning Level";
            ToolTip = 'Specifies the Dimension Assignment 3.';
        }
        field(304; "Dimension Assignment 4"; Code[20])
        {
            Caption = 'Dimension Assignment 4';
            TableRelation = "BET FN Planning Level";
            ToolTip = 'Specifies the Dimension Assignment 4.';
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

