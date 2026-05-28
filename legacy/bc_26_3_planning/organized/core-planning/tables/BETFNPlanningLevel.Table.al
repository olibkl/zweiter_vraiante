/// <summary>
/// [planning]
/// Modules: 
/// </summary>
table 5138641 "BET FN Planning Level"
{
    Caption = 'Planning Level';
    DrillDownPageId = "BET FN Planning Levels List";
    LookupPageId = "BET FN Planning Levels List";
    DataClassification = CustomerContent;
    Access = Public;
    Extensible = true;

    fields
    {
        field(1; "Index Code"; Code[20])
        {
            Caption = 'Index Code';
            ToolTip = 'Specifies the Index Code.';
        }
        field(2; "Index Description"; Text[30])
        {
            Caption = 'Index Description';
            ToolTip = 'Specifies the Index Description.';
        }
        field(3; "Index Table No."; Integer)
        {
            Caption = 'Index Table No.';
            TableRelation = AllObj."Object ID" where("Object Type" = const(Table));
            ToolTip = 'Specifies the Index Table No.';
            trigger OnValidate()
            var
                Object_LT: Record AllObjWithCaption;
            begin
                if not Object_LT.Get(Object_LT."Object Type"::Table, "Index Table No.") then
                    Error(IndexTableNotFoundErr);
                "Index Description" := CopyStr(Object_LT."Object Caption", 1, MaxStrLen("Index Description"));
            end;
        }
        field(4; "Assigned to Index"; Code[20])
        {
            Caption = 'Assigned to Index';
            TableRelation = "BET FN Planning Level"."Index Code";
            ToolTip = 'Specifies the Assigned to Index.';
            trigger OnValidate()
            begin
                if "Assigned to Index" = "Index Code" then
                    "Assigned to Index" := '';
            end;
        }
        field(7; "Primary Key Field No."; Integer)
        {
            Caption = 'Primary Key Field No.';
            TableRelation = Field."No." where(TableNo = field("Index Table No."));
            ToolTip = 'Specifies the Primary Key Field No.';
            trigger OnLookup()
            var
                Field_LT: Record "Field";
            begin
                Field_LT.Reset();
                Field_LT.FilterGroup(2);
                Field_LT.SetRange(TableNo, "Index Table No.");
                Field_LT.FilterGroup(0);
                if Page.RunModal(Page::"Fields Lookup", Field_LT) = Action::LookupOK then
                    Validate("Primary Key Field No.", Field_LT."No.");
            end;
        }
        field(8; "Description Field No."; Integer)
        {
            Caption = 'Description Field No.';
            TableRelation = Field."No." where(TableNo = field("Index Table No."));
            ToolTip = 'Specifies the Description Field No.';
            trigger OnLookup()
            var
                Field_LT: Record "Field";
            begin
                Field_LT.Reset();
                Field_LT.FilterGroup(2);
                Field_LT.SetRange(TableNo, "Index Table No.");
                Field_LT.FilterGroup(0);
                if Page.RunModal(Page::"Fields Lookup", Field_LT) = Action::LookupOK then
                    Validate("Description Field No.", Field_LT."No.");
            end;
        }
        field(20; "Planning Statistic Field"; Integer)
        {
            Caption = 'Planning Statistic Field';
            TableRelation = Field."No." where(TableNo = const(5138652));
            ToolTip = 'Specifies the Planning Statistic Field.';
            trigger OnLookup()
            var
                Field_LT: Record "Field";
            begin
                Field_LT.Reset();
                Field_LT.FilterGroup(2);
                Field_LT.SetRange(TableNo, Database::"BET FN Planning Statistic");
                Field_LT.FilterGroup(0);
                if Page.RunModal(Page::"Fields Lookup", Field_LT) = Action::LookupOK then
                    Validate("Planning Statistic Field", Field_LT."No.");
            end;
        }
        field(21; Activated; Boolean)
        {
            Caption = 'Activated';
            ToolTip = 'Specifies the Activated.';
        }
        field(31; "Export Field No."; Integer)
        {
            Caption = 'Export Field No.';
            TableRelation = Field."No." where(TableNo = const(5138634));
            ToolTip = 'Specifies the Export Field No.';
            trigger OnLookup()
            var
                Field_LT: Record "Field";
            begin
                Field_LT.Reset();
                Field_LT.FilterGroup(2);
                Field_LT.SetRange(TableNo, Database::"BET FN Planning Entry (DWH)");
                Field_LT.FilterGroup(0);
                if Page.RunModal(Page::"Fields Lookup", Field_LT) = Action::LookupOK then
                    Validate("Export Field No.", Field_LT."No.");
            end;
        }
        field(32; "Fash. Stat. Entry Field"; Integer)
        {
            Caption = 'Fash. Stat. Entry Field';
            TableRelation = Field."No." where(TableNo = const(5138632));
            ToolTip = 'Specifies the Fash. Stat. Entry Field.';
            trigger OnLookup()
            var
                Field_LT: Record "Field";
            begin
                Field_LT.Reset();
                Field_LT.FilterGroup(2);
                Field_LT.SetRange(TableNo, Database::"BET FN Fashion Statistic Entry");
                Field_LT.FilterGroup(0);
                if Page.RunModal(Page::"Fields Lookup", Field_LT) = Action::LookupOK then
                    Validate("Fash. Stat. Entry Field", Field_LT."No.");
            end;
        }
        field(40; "Assigned to Index Field No."; Integer)
        {
            Caption = 'Assigned to Index Field No.';
            ToolTip = 'Specifies the Assigned to Index Field No.';
        }
        field(41; "Description in Document"; Option)
        {
            Caption = 'Description in Document';
            OptionCaption = 'Code,Description,Both';
            OptionMembers = "Code",Description,Both;
            ToolTip = 'Specifies the Description in Document.';
        }
        field(42; "Check Dim. Assign. Table"; Boolean)
        {
            Caption = 'Check Dim. Assign. Table';
            ToolTip = 'use complex assignment with assignment table';
        }
        field(43; "Dim. Assign. Field No."; Integer)
        {
            Caption = 'Dim. Assign. Field No.';
            ToolTip = 'field no. in assignment table';
        }
        field(44; "Use Dummy"; Boolean)
        {
            Caption = 'Use Dummy';
            ToolTip = 'use additional dummy element in buffer and levels';
        }
        field(45; "Filter Field"; Integer)
        {
            Caption = 'Filter Field';
            ToolTip = 'fix filter field for this level';
        }
        field(46; "Filter Value"; Code[20])
        {
            Caption = 'Filter Value';
            ToolTip = 'fix filter value for this level';
        }
    }

    keys
    {
        key(Key1; "Index Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnRename()
    begin
        Error(RenameNotAllowedErr);
    end;

    var
        IndexTableNotFoundErr: Label 'Index table not found.';
        RenameNotAllowedErr: Label 'Rename not possible. Please delete and create new.';

    /// <summary>
    /// CheckUsed.
    /// </summary>
    /// <param name="PlanLevel_P">Record "BET FN Planning Level".</param>
    /// <returns>Return value of type Boolean.</returns>
    [Obsolete('#35131 Pending removal - procedure will be removed in future', '25.2')]

    procedure CheckUsed(PlanLevel_P: Record "BET FN Planning Level"): Boolean
    begin
    end;
}

