/// <summary>
/// [scenario]
/// Modules: 
/// </summary>
table 5138658 "BET FN Scenario Dimension Line"
{
    Caption = 'Scenario Dimension Line';
    DrillDownPageId = "BET FN Scenario Dimension Line";
    LookupPageId = "BET FN Scenario Dimension Line";
    DataClassification = CustomerContent;
    Access = Public;
    Extensible = true;

    fields
    {
        field(1; "Scenario Code"; Code[20])
        {
            Caption = 'Scenario Code';
        }
        field(2; "Dimension Code"; Code[20])
        {
            Caption = 'Dimension Code';
            ToolTip = 'Specifies the Dimension Code.';
        }
        field(3; "Code"; Code[20])
        {
            Caption = 'Code';
            ToolTip = 'Specifies the Code.';
        }
        field(4; Description; Text[50])
        {
            Caption = 'Description';
            ToolTip = 'Specifies the Description.';
        }
        field(5; Active; Boolean)
        {
            Caption = 'Active';
            ToolTip = 'Specifies the Active flag.';
            trigger OnValidate()
            var
                ScenarioDimension_LT: Record "BET FN Scenario Dimension";
            begin
                ScenarioDimension_LT.Reset();
                if ScenarioDimension_LT.Get("Scenario Code", "Dimension Code") then
                    if ScenarioDimension_LT.Dateline then begin
                        Active := xRec.Active;
                        exit;
                    end;

                if not Active then
                    Percentage := 0;
                CalcPercentage();
            end;
        }
        field(6; "Sorting No."; Integer)
        {
            Caption = 'Sorting No.';
        }
        field(10; Weight; Decimal)
        {
            Caption = 'Weight';
            ToolTip = 'Specifies the Weight.';
            trigger OnValidate()
            begin
                if Active then
                    CalcPercentage();
            end;
        }
        field(11; Percentage; Decimal)
        {
            Caption = 'Percentage';
            ToolTip = 'Specifies the Percentage.';
        }
        field(12; "Avg. Price"; Decimal)
        {
            Caption = 'Avg. Price';
            ToolTip = 'Specifies the Avg. Price.';
        }
    }

    keys
    {
        key(Key1; "Scenario Code", "Dimension Code", "Code")
        {
            Clustered = true;
        }
        key(Key2; Active)
        {
            IncludedFields = Percentage, Weight;
        }
        key(Key3; "Sorting No.")
        {
        }
    }

    fieldgroups
    {
    }

    procedure CalcPercentage()
    var
        ScenarioDimLine_LT: Record "BET FN Scenario Dimension Line";
        PercentTotal_L: Decimal;
        WeightTotal_L: Decimal;
    begin
        ScenarioDimLine_LT.Reset();
        ScenarioDimLine_LT.SetRange("Scenario Code", "Scenario Code");
        ScenarioDimLine_LT.SetRange("Dimension Code", "Dimension Code");
        ScenarioDimLine_LT.SetRange(Active, true);
        ScenarioDimLine_LT.SetFilter(Code, '<>%1', Code);

        WeightTotal_L := 0;

        if ScenarioDimLine_LT.Find('-') then
            repeat
                WeightTotal_L += ScenarioDimLine_LT.Weight;
            until ScenarioDimLine_LT.Next() = 0;
        if Active then
            WeightTotal_L += Weight;

        PercentTotal_L := 0;

        if ScenarioDimLine_LT.Find('-') then
            repeat
                if WeightTotal_L = 0 then
                    ScenarioDimLine_LT.Percentage := 0
                else
                    ScenarioDimLine_LT.Percentage := ScenarioDimLine_LT.Weight / WeightTotal_L * 100;
                ScenarioDimLine_LT.Modify();
                PercentTotal_L += ScenarioDimLine_LT.Percentage;
            until ScenarioDimLine_LT.Next() = 0;

        if (WeightTotal_L + Weight) = 0 then
            Percentage := 0
        else
            Percentage := 100 - PercentTotal_L;
    end;
}

