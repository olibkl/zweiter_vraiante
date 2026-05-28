/// <summary>
/// [planning]
/// Modules: 
/// </summary>
table 5138648 "BET FN Planning Type"
{
    Caption = 'Planning Type';
    DrillDownPageId = "BET FN Planning Type";
    LookupPageId = "BET FN Planning Type";
    DataClassification = CustomerContent;
    Access = Public;
    Extensible = true;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            ToolTip = 'Specifies the Code.';
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
            ToolTip = 'Specifies the Description.';
        }
        field(5; "Write Planning Entries"; Boolean)
        {
            Caption = 'Write Planning Entries';
            ToolTip = 'Specifies the Write Planning Entries.';
        }
        field(6; "Layout Template"; Code[20])
        {
            Caption = 'Layout Template';
            TableRelation = "BET FN Planning Layout Tmplt";
            ToolTip = 'Specifies the Layout Template.';
        }
        field(7; "Company Plan"; Boolean)
        {
            Caption = 'Company Plan';

            ObsoleteState = Pending;
            ObsoleteTag = '26.0';
            ObsoleteReason = '#19247 Pending removal - field will be removed in future updates';
            ToolTip = 'Specifies the Company Plan.';
        }
        field(8; "Purchase Plan"; Boolean)
        {
            Caption = 'Purchase Plan';

            ObsoleteState = Pending;
            ObsoleteTag = '26.0';
            ObsoleteReason = '#19247 Pending removal - field will be removed in future updates';
            ToolTip = 'Specifies the Purchase Plan.';
        }
        field(10; Level1; Code[20])
        {
            Caption = 'Level 1';
            TableRelation = "BET FN Planning Level" where(Activated = const(true));
            ToolTip = 'Specifies the Level1.';
            trigger OnValidate()
            begin
                if Level1 <> '' then begin
                    if not PlanLevel_GT.Get(Level1) or
                      (not PlanLevel_GT.Activated) then
                        Error(LevelNotAvailableErr, Level1);
                    CheckLevel1();
                end;
            end;
        }
        field(11; Level2; Code[20])
        {
            Caption = 'Level 2';
            TableRelation = "BET FN Planning Level" where(Activated = const(true));
            ToolTip = 'Specifies the Level2.';
            trigger OnValidate()
            begin
                if Level2 <> '' then begin
                    if not PlanLevel_GT.Get(Level2) or
                      (not PlanLevel_GT.Activated) then
                        Error(LevelNotAvailableErr, Level2);
                    CheckLevel2();
                end;
            end;
        }
        field(12; Level3; Code[20])
        {
            Caption = 'Level 3';
            TableRelation = "BET FN Planning Level" where(Activated = const(true));
            ToolTip = 'Specifies the Level3.';
            trigger OnValidate()
            begin
                if Level3 <> '' then begin
                    if not PlanLevel_GT.Get(Level3) or
                      (not PlanLevel_GT.Activated) then
                        Error(LevelNotAvailableErr, Level3);
                    CheckLevel3();
                end;
            end;
        }
        field(13; Level4; Code[20])
        {
            Caption = 'Level 4';
            TableRelation = "BET FN Planning Level" where(Activated = const(true));
            ToolTip = 'Specifies the Level4.';
            trigger OnValidate()
            begin
                if Level4 <> '' then begin
                    if not PlanLevel_GT.Get(Level4) or
                      (not PlanLevel_GT.Activated) then
                        Error(LevelNotAvailableErr, Level4);
                    CheckLevel4();
                end;
            end;
        }
        field(14; Level5; Code[20])
        {
            Caption = 'Level 5';
            TableRelation = "BET FN Planning Level" where(Activated = const(true));
            ToolTip = 'Specifies the Level5.';
            trigger OnValidate()
            begin
                if Level5 <> '' then begin
                    if not PlanLevel_GT.Get(Level5) or
                      (not PlanLevel_GT.Activated) then
                        Error(LevelNotAvailableErr, Level5);
                    CheckLevel5();
                end;
            end;
        }
        field(15; Level6; Code[20])
        {
            Caption = 'Level 6';
            ToolTip = 'Specifies the Level6.';
            trigger OnValidate()
            begin
                if Level6 <> '' then begin
                    if not PlanLevel_GT.Get(Level6) or
                      (not PlanLevel_GT.Activated) then
                        Error(LevelNotAvailableErr, Level6);
                    CheckLevel6();
                end;
            end;
        }
        field(18; "Use Date Level"; Boolean)
        {
            Caption = 'Use Date Level';
            ToolTip = 'Specifies the Use Date Level.';
        }
        field(20; "Starting Level"; Option)
        {
            Caption = 'Starting Level';
            OptionCaption = ' ,Level 1,Level 2,Level 3,Level 4,Level 5';
            OptionMembers = Level0,Level1,Level2,Level3,Level4,Level5;
            ToolTip = 'Specifies the Starting Level.';
            trigger OnValidate()
            begin
                CheckStartingLevel();
            end;
        }
        field(120; "Auto Filter On Level Changing"; Boolean)
        {
            Caption = 'Auto Filter On Level Changing';
            ToolTip = 'Specifies the Auto Filter On Level Changing.';
        }
        field(122; "Dim. Assign. per Purchaser"; Boolean)
        {
            Caption = 'Dim. Assign. per Purchaser';
            ToolTip = 'Specifies the Dim. Assign. per Purchaser.';
        }
        field(123; "Check Dim. Assign. Table"; Boolean)
        {
            Caption = 'Check Dim. Assign. Table';
            ToolTip = 'Specifies whether to check then Dim. Assign. Table.';
        }
        field(124; "Calculation Type"; Boolean)
        {
            Caption = 'Calculation Type';

            ObsoleteState = Removed;
            ObsoleteTag = '22.4';
            ObsoleteReason = '#19247 Removed - field will be removed in future updates';
            ToolTip = 'Specifies the Calculation Type.';
        }
        field(125; "Type of Calculation"; Option)
        {
            ObsoleteState = Pending;
            ObsoleteTag = '25.2';
            ObsoleteReason = '#35131 Pending removal - field will be removed in future updates';

            Caption = 'Type of Calculation';
            OptionMembers = " ",SalesPlan,PurchasePlan,SalesOrderPlan,Quantity;
            OptionCaption = ' ,SalesPlan,PurchasePlan,SalesOrderPlan,Quantity';
            ToolTip = 'Specifies the Calculation Type.';
        }
        field(126; "Planning Process Type"; Enum "BET FN Planning Process Type")
        {
            Caption = 'Planning Process Type';
            ToolTip = 'Specifies the Planning Process Type. Defines the type of calculation.';
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
            MaintainSiftIndex = false;
        }
    }

    fieldgroups
    {
    }

    var
        PlanLevel_GT: Record "BET FN Planning Level";
        InsertLevelErr: Label 'Please insert levels starting at 1.';
        LevelAlreadyInUseErr: Label 'Level %1 is already in use.', Comment = '%1';
        LevelNotAvailableErr: Label 'Level %1 is not available.', Comment = '%1';

    /// <summary>
    /// CheckLevel1.
    /// </summary>
    procedure CheckLevel1()
    begin
        if (Level1 = Level2) or
           (Level1 = Level3) or
           (Level1 = Level4) or
           (Level1 = Level5) or
           (Level1 = Level6) then
            Error(LevelAlreadyInUseErr, Level1);
    end;

    /// <summary>
    /// CheckLevel2.
    /// </summary>
    procedure CheckLevel2()
    begin
        if (Level2 = Level1) or
           (Level2 = Level3) or
           (Level2 = Level4) or
           (Level2 = Level5) or
           (Level2 = Level6) then
            Error(LevelAlreadyInUseErr, Level2);

        if Level1 = '' then
            Error(InsertLevelErr);
    end;

    /// <summary>
    /// CheckLevel3.
    /// </summary>
    procedure CheckLevel3()
    begin
        if (Level3 = Level1) or
           (Level3 = Level2) or
           (Level3 = Level4) or
           (Level3 = Level5) or
           (Level3 = Level6) then
            Error(LevelAlreadyInUseErr, Level3);

        if (Level1 = '') or
           (Level2 = '') then
            Error(InsertLevelErr);
    end;

    /// <summary>
    /// CheckLevel4.
    /// </summary>
    procedure CheckLevel4()
    begin
        if (Level4 = Level1) or
           (Level4 = Level2) or
           (Level4 = Level3) or
           (Level4 = Level5) or
           (Level4 = Level6) then
            Error(LevelAlreadyInUseErr, Level4);

        if (Level1 = '') or
           (Level2 = '') or
           (Level3 = '') then
            Error(InsertLevelErr);
    end;

    /// <summary>
    /// CheckLevel5.
    /// </summary>
    procedure CheckLevel5()
    begin
        if (Level5 = Level1) or
           (Level5 = Level2) or
           (Level5 = Level3) or
           (Level5 = Level4) or
           (Level5 = Level6) then
            Error(LevelAlreadyInUseErr, Level5);

        if (Level1 = '') or
           (Level2 = '') or
           (Level3 = '') or
           (Level4 = '') then
            Error(InsertLevelErr);
    end;

    /// <summary>
    /// CheckLevel6.
    /// </summary>
    procedure CheckLevel6()
    begin
        if (Level6 = Level1) or
           (Level6 = Level2) or
           (Level6 = Level3) or
           (Level6 = Level4) or
           (Level6 = Level5) then
            Error(LevelAlreadyInUseErr, Level6);

        if (Level1 = '') or
           (Level2 = '') or
           (Level3 = '') or
           (Level4 = '') or
           (Level5 = '') then
            Error(InsertLevelErr);
    end;

    /// <summary>
    /// CheckStartingLevel.
    /// </summary>
    procedure CheckStartingLevel()
    var
        LevelHasNotBeenDefinedErr: Label 'Level %1 has not been defined.', Comment = '%1';
    begin
        case "Starting Level" of
            0:
                ;
            1:
                if Level1 = '' then
                    Error(LevelHasNotBeenDefinedErr, "Starting Level");
            2:
                if Level2 = '' then
                    Error(LevelHasNotBeenDefinedErr, "Starting Level");
            3:
                if Level3 = '' then
                    Error(LevelHasNotBeenDefinedErr, "Starting Level");
            4:
                if Level4 = '' then
                    Error(LevelHasNotBeenDefinedErr, "Starting Level");
            5:
                if Level5 = '' then
                    Error(LevelHasNotBeenDefinedErr, "Starting Level");
        end;
    end;
}

