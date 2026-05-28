/// <summary>
/// [scenario]
/// Modules: 
/// </summary>
table 5138657 "BET FN Scenario Dimension"
{
    Caption = 'Scenario Dimension';
    DrillDownPageId = "BET FN Scenario Dimension";
    LookupPageId = "BET FN Scenario Dimension";
    DataClassification = CustomerContent;
    Access = Public;
    Extensible = true;

    fields
    {
        field(1; "Scenario Code"; Code[20])
        {
            Caption = 'Scenario Code';
            NotBlank = true;
            TableRelation = "BET FN Scenario".Code;
            ToolTip = 'Specifies the Scenario Code.';
        }
        field(2; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
            TableRelation = "BET FN Planning Level" where(Activated = const(true));
            ToolTip = 'Specifies the Code.';
            trigger OnValidate()
            var
                PlanLevel_LT: Record "BET FN Planning Level";
            begin
                if PlanLevel_LT.Get(Code) then begin
                    Description := PlanLevel_LT."Index Description";
                    "Table No." := PlanLevel_LT."Index Table No.";
                    CreateDimensionLines(Rec);
                end;
            end;
        }
        field(3; Description; Text[50])
        {
            Caption = 'Description';
            ToolTip = 'Specifies the Description.';
        }
        field(4; "Table No."; Integer)
        {
            Caption = 'Table No.';
            ToolTip = 'Specifies the Table No.';
        }
        field(5; Lines; Integer)
        {

            CalcFormula = count("BET FN Scenario Dimension Line" where("Scenario Code" = field("Scenario Code"),
                                                                 "Dimension Code" = field(Code),
                                                                 Active = const(true)));
            Caption = 'Lines';
            Editable = false;
            FieldClass = FlowField;
            ToolTip = 'Specifies the Lines.';
            trigger OnLookup()
            var
                ScenarioDimLine_LT: Record "BET FN Scenario Dimension Line";
            begin
                ScenarioDimLine_LT.FilterGroup(2);
                ScenarioDimLine_LT.Reset();
                ScenarioDimLine_LT.SetRange("Scenario Code", "Scenario Code");
                ScenarioDimLine_LT.SetRange("Dimension Code", Code);
                Page.RunModal(0, ScenarioDimLine_LT);
                ScenarioDimLine_LT.FilterGroup(0);
            end;
        }
        field(6; Dateline; Boolean)
        {
            Caption = 'Dateline';
        }
    }

    keys
    {
        key(Key1; "Scenario Code", "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        ScenarioDimLine_LT: Record "BET FN Scenario Dimension Line";
        DateDimensionDeletionNotAllowedErr: Label 'Deleting date dimension is not allowed.';
    begin
        if Dateline then      //### Datumsdimension darf nicht gelöscht werden
            Error(DateDimensionDeletionNotAllowedErr);
        ScenarioDimLine_LT.Reset();
        ScenarioDimLine_LT.SetRange("Scenario Code", "Scenario Code");
        ScenarioDimLine_LT.SetRange("Dimension Code", Code);
        ScenarioDimLine_LT.DeleteAll();
    end;

    procedure CreateDimensionLines(ScenarioDim_PT: Record "BET FN Scenario Dimension")
    var
        PlanLevel_LT: Record "BET FN Planning Level";
        DivDim_LT: Record "BET FN Scenario Dimension";
        MainWGDim_LT: Record "BET FN Scenario Dimension";
        WGDim_LT: Record "BET FN Scenario Dimension";
        ScenarioDimLine_LT: Record "BET FN Scenario Dimension Line";
        Location_LT: Record Location;
        RR_L: RecordRef;
        FR_L: FieldRef;
        InsertLine_L: Boolean;
        SortingNo_L: Integer;
        DimensionAlreadyExistsErr: Label 'Dimension %1 allready exist.', Comment = '%1';
    begin
        //### bei Verwendung von WG/HWG/Abteilung sicherstellen, daß nur eine der 3 Dimensionen enthalten ist:
        case "Table No." of
            Database::"Item Category", Database::"BET FN Division", Database::"BET FN Main Waregroup":
                begin
                    WGDim_LT.Reset();
                    WGDim_LT.SetRange("Scenario Code", "Scenario Code");
                    WGDim_LT.SetRange("Table No.", Database::"Item Category");
                    MainWGDim_LT.Reset();
                    MainWGDim_LT.SetRange("Scenario Code", "Scenario Code");
                    MainWGDim_LT.SetRange("Table No.", Database::"BET FN Main Waregroup");
                    DivDim_LT.Reset();
                    DivDim_LT.SetRange("Scenario Code", "Scenario Code");
                    DivDim_LT.SetRange("Table No.", Database::"BET FN Division");
                    if WGDim_LT.FindFirst() then
                        Error(DimensionAlreadyExistsErr, WGDim_LT.Code);
                    if MainWGDim_LT.FindFirst() then
                        Error(DimensionAlreadyExistsErr, MainWGDim_LT.Code);
                    if DivDim_LT.FindFirst() then
                        Error(DimensionAlreadyExistsErr, DivDim_LT.Code);
                end;
        end;


        RR_L.Open(ScenarioDim_PT."Table No.");
        if RR_L.Find('-') then begin
            PlanLevel_LT.Get(ScenarioDim_PT.Code);    //### hier stehen die Feldnummern (PK, Beschr.) drin

            ScenarioDimLine_LT.Init();
            ScenarioDimLine_LT."Scenario Code" := ScenarioDim_PT."Scenario Code";
            ScenarioDimLine_LT."Dimension Code" := ScenarioDim_PT.Code;
            SortingNo_L := 0;
            repeat
                //### Code
                FR_L := RR_L.Field(PlanLevel_LT."Primary Key Field No.");
                ScenarioDimLine_LT.Code := FR_L.Value();
                //### Beschreibung
                FR_L := RR_L.Field(PlanLevel_LT."Description Field No.");
                ScenarioDimLine_LT.Description := FR_L.Value();

                ScenarioDimLine_LT.Active := true;
                InsertLine_L := true;

                //### inaktive Filialen nicht verwenden:
                if (ScenarioDim_PT."Table No." = 14) then
                    if Location_LT.Get(ScenarioDimLine_LT.Code) then
                        InsertLine_L := Location_LT."BET FN Active";

                ScenarioDimLine_LT.Weight := 10;       //### Standardgewichtung

                if InsertLine_L then begin
                    SortingNo_L += 1;
                    ScenarioDimLine_LT."Sorting No." := SortingNo_L;
                    ScenarioDimLine_LT.Insert();
                end;
            until RR_L.Next() = 0;
        end;
    end;
}

