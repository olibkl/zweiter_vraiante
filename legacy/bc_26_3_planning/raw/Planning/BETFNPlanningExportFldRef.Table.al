/// <summary>
/// [planning]
/// Modules: 
/// </summary>
table 5138640 "BET FN Planning Export Fld Ref"
{
    Caption = 'Planning Export Fieldreference';
    DataClassification = CustomerContent;
    LookupPageId = "BET FN Planning Export Fld Ref";
    DrillDownPageId = "BET FN Planning Export Fld Ref";
    Access = Public;
    Extensible = true;

    fields
    {
        field(2; "Export Field No."; Integer)
        {
            Caption = 'Export Field No.';
            NotBlank = true;
            ToolTip = 'Specifies the Export Field No.';
            trigger OnLookup()
            begin
                PlanSetup_GT.FindFirst();
                PlanSetup_GT.TestField("Export Table No.");
                Field_GT.Reset();
                Field_GT.SetRange(TableNo, PlanSetup_GT."Export Table No.");
                if Page.RunModal(Page::"Fields Lookup", Field_GT) = Action::LookupOK then begin
                    "Export Field No." := Field_GT."No.";
                    "Export Field Description" := CopyStr(Field_GT."Field Caption", 1, 50);
                end;
            end;

            trigger OnValidate()
            begin
                if "Export Field No." = 0 then
                    "Export Field Description" := ''
                else begin
                    PlanSetup_GT.FindFirst();
                    Field_GT.Reset();
                    Field_GT.SetRange(TableNo, PlanSetup_GT."Export Table No.");
                    Field_GT.SetRange("No.", "Export Field No.");
                    Field_GT.FindFirst();
                    "Export Field Description" := CopyStr(Field_GT."Field Caption", 1, 50);
                end;
            end;
        }
        field(3; "Cube Field No."; Integer)
        {
            Caption = 'Cube Field No.';
            NotBlank = true;
            ToolTip = 'Specifies the Cube Field No.';
            trigger OnLookup()
            begin
                Field_GT.Reset();
                Field_GT.SetRange(TableNo, Database::"BET FN Planning Value Cube");
                if Page.RunModal(Page::"Fields Lookup", Field_GT) = Action::LookupOK then begin
                    "Cube Field No." := Field_GT."No.";
                    "Cube Field Description" := CopyStr(Field_GT."Field Caption", 1, 50);
                end;
            end;

            trigger OnValidate()
            begin
                if "Cube Field No." = 0 then
                    "Cube Field Description" := ''
                else begin
                    PlanSetup_GT.FindFirst();
                    Field_GT.Reset();
                    Field_GT.SetRange(TableNo, Database::"BET FN Planning Value Cube");
                    Field_GT.SetRange("No.", "Cube Field No.");
                    Field_GT.FindFirst();
                    "Cube Field Description" := CopyStr(Field_GT."Field Caption", 1, 50);
                end;
            end;
        }
        field(4; "Cube Field Description"; Text[50])
        {
            Caption = 'Cube Field Description';
            Editable = false;
            ToolTip = 'Specifies the Cube Field Description.';
        }
        field(5; "Export Field Description"; Text[50])
        {
            Caption = 'Export Field Description';
            Editable = false;
            ToolTip = 'Specifies the Export Field Description.';
        }
        field(6; "Reverse Sign"; Boolean)
        {
            Caption = 'Reverse Sign';
            ToolTip = 'Specifies the Reverse Sign.';
        }
    }

    keys
    {
        key(Key1; "Export Field No.", "Cube Field No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        PlanSetup_GT: Record "BET FN Planning Setup";
        Field_GT: Record "Field";
}

