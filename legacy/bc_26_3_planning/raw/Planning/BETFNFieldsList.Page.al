/// <summary>
/// [planning]
/// Modules: 
/// </summary>
page 5138667 "BET FN Fields List"
{
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Fields List';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Field";
    Extensible = true;

    layout
    {
        area(Content)
        {
            repeater(Control1117300000)
            {
                ShowCaption = false;
                field(TableNo; Rec.TableNo)
                {
                    ToolTip = 'Specifies the TableNo.';
                    Visible = false;
                }
                field(TableName; Rec.TableName)
                {
                    ToolTip = 'Specifies the TableName.';
                    Visible = false;
                }
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the No.';
                }
                field("Field Caption"; Rec."Field Caption")
                {
                    ToolTip = 'Specifies the Field Caption.';
                }
                field(FieldName; Rec.FieldName)
                {
                    ToolTip = 'Specifies the FieldName.';
                    Visible = false;
                }
                field(Type; Rec.Type)
                {
                    ToolTip = 'Specifies the Type.';
                }
                field(Len; Rec.Len)
                {
                    ToolTip = 'Specifies the Len.';
                }
                field(Class; Rec.Class)
                {
                    ToolTip = 'Specifies the Class.';
                }
                field(Enabled; Rec.Enabled)
                {
                    ToolTip = 'Specifies the Enabled.';
                }
                field("Type Name"; Rec."Type Name")
                {
                    ToolTip = 'Specifies the Type Name.';
                }
                field(RelationTableNo; Rec.RelationTableNo)
                {
                    ToolTip = 'Specifies the RelationTableNo.';
                }
                field(RelationFieldNo; Rec.RelationFieldNo)
                {
                    ToolTip = 'Specifies the RelationFieldNo.';
                }
                field(SQLDataType; Rec.SQLDataType)
                {
                    ToolTip = 'Specifies the SQLDataType.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    var
        Object_LT: Record AllObjWithCaption;
    begin
        Object_LT.Reset();
        Object_LT.SetRange("Object Type", Object_LT."Object Type"::Table);
        Rec.FilterGroup(2);
        Object_LT.SetFilter("Object ID", Rec.GetFilter(TableNo));
        Rec.FilterGroup(0);
        if Object_LT.FindFirst() then
            CurrPage.Caption('Tabelle:   ' + Object_LT."Object Caption");
    end;
}

