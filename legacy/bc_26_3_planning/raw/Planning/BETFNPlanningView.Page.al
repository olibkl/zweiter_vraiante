/// <summary>
/// 
/// 
/// Modules: [planning]
/// </summary>
#pragma warning disable AL0432
page 5138653 "BET FN Planning View"
{
    ApplicationArea = All;
    UsageCategory = None;
    Caption = 'Planning View';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Worksheet;
    ShowFilter = false;
    SourceTable = "BET FN Planning View";
    SourceTableView = sorting("Planning Document No.", "Planning Document Level", "Index 1", "Index 2", "Index 3", "Index 4", "Index 5", "Index 6", Date);
    Extensible = true;

    layout
    {
        area(Content)
        {
            group(Control5079203)
            {
                ShowCaption = false;
                field("Level Text"; LevelText_G)
                {
                    ToolTip = 'Specifies the Level Text.';
                    Caption = 'Level:';
                    Editable = false;
                }
                field("Filter Text"; FilterText_G)
                {
                    ToolTip = 'Specifies the Filter Text.';
                    AssistEdit = false;
                    Caption = 'Filters:';
                    Editable = false;
                }
                field("Distribution Type"; DistributionType_G)
                {
                    ToolTip = 'Specifies the Distribution Type.';
                    Caption = 'Distribution Type';
                    OptionCaption = 'Reference Values,Planning Values,Distribution Template';

                    trigger OnValidate()
                    begin
                        PlanDoc_GT.Get(PlanDoc_GT."No.");
                        PlanDoc_GT."Distribution Type" := DistributionType_G;
                        PlanDoc_GT.Modify();
                    end;
                }
            }
            grid(LineInfo)
            {
                Caption = 'Line information';
                Visible = false;
                field(LineInformation; LineInformation_G)
                {
                    ToolTip = 'Specifies the LineInformation.';
                    Caption = 'Line information';
                    Editable = false;
                    Visible = LineInfoVisible_G;
                }
            }
            repeater(Control1117300000)
            {
                ShowCaption = false;
                field("Fixed"; Rec.Fixed)
                {
                    Visible = ShowFixed_G;

                    trigger OnValidate()
                    begin
                        SetLineFixed();
                    end;
                }
                field(Date; Rec.Date)
                {
                    Editable = false;
                    Visible = ShowDate_G;
                }
                field("Date Description"; DateDescription_G)
                {
                    ToolTip = 'Specifies the Date Description.';
                    Caption = 'Month';
                    Editable = false;
                    Visible = ShowDateDescription_G;
                }
                field(I1; DescrArray_G[1])
                {
                    ToolTip = 'Specifies the I1.';
                    CaptionClass = IndexCaption_G[1];
                    Editable = false;
                    Visible = I1Visible_G;
                }
                field(I2; DescrArray_G[2])
                {
                    ToolTip = 'Specifies the I2.';
                    CaptionClass = IndexCaption_G[2];
                    Editable = false;
                    Visible = I2Visible_G;
                }
                field(I3; DescrArray_G[3])
                {
                    ToolTip = 'Specifies the I3.';
                    CaptionClass = IndexCaption_G[3];
                    Editable = false;
                    Visible = I3Visible_G;
                }
                field(I4; DescrArray_G[4])
                {
                    ToolTip = 'Specifies the I4.';
                    CaptionClass = IndexCaption_G[4];
                    Editable = false;
                    Visible = I4Visible_G;
                }
                field(I5; DescrArray_G[5])
                {
                    ToolTip = 'Specifies the I5.';
                    CaptionClass = IndexCaption_G[5];
                    Editable = false;
                    Visible = I5Visible_G;
                }
                field(I6; DescrArray_G[6])
                {
                    ToolTip = 'Specifies the I6.';
                    CaptionClass = IndexCaption_G[6];
                    Editable = false;
                    Visible = I6Visible_G;
                }
                field("Ref. Sales Amount"; Rec."Ref. Sales Amount")
                {
                    Caption = 'Sales Prev. Year';
                    DecimalPlaces = 0 : 0;
                    Editable = false;
                    Visible = Visible042_G;
                }
                field("Ref. Sales Percentage"; Rec."Ref. Sales Percentage")
                {
                    Caption = 'Ref. Sales Percentage';
                    DecimalPlaces = 1 : 1;
                    Editable = false;
                    Visible = Visible083_G;
                }
                field("Ref. Calc. Sales %"; Rec."Ref. Calc. Sales %")
                {
                    Caption = 'Calc. Prev. Year %';
                    DecimalPlaces = 1 : 1;
                    Editable = false;
                    Visible = Visible075_G;
                }
                field("Ref. Cost of Sales"; Rec."Ref. Cost of Sales")
                {
                    Caption = 'Purchase Previous Year';
                    DecimalPlaces = 0 : 0;
                    Editable = false;
                    Visible = Visible059_G;
                }
                field("Plan Sales Amount"; Rec."Plan Sales Amount")
                {
                    DecimalPlaces = 0 : 0;
                    Editable = Editable_G;
                    StyleExpr = LineChangedStyle_G;
                    Visible = Visible003_G;

                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                        UpdateLineColour();
                    end;
                }
                field("Plan Sales Percentage"; Rec."Plan Sales Percentage")
                {
                    Caption = 'Plan Sales Percentage';
                    DecimalPlaces = 1 : 1;
                    Editable = Editable_G;
                    StyleExpr = LineChangedStyle_G;
                    Visible = Visible084_G;

                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                        UpdateLineColour();
                    end;
                }
                field("Plan Calc. Sales %"; Rec."Plan Calc. Sales %")
                {
                    Caption = 'Calc. Plan %';
                    DecimalPlaces = 1 : 1;
                    Editable = Editable_G;
                    StyleExpr = LineChangedStyle_G;
                    Visible = Visible037_G;

                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                        UpdateLineColour();
                    end;
                }
                field("Plan Cost of Sales"; Rec."Plan Cost of Sales")
                {
                    DecimalPlaces = 0 : 0;
                    Editable = Editable_G;
                    StyleExpr = LineChangedStyle_G;
                    Visible = Visible021_G;

                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                        UpdateLineColour();
                    end;
                }
                field("Plan Sal. Am. Difference %"; Rec."Plan Sal. Am. Difference %")
                {
                    DecimalPlaces = 1 : 1;
                    Editable = Editable_G;
                    StyleExpr = LineChangedStyle_G;
                    Visible = Visible082_G;

                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                        UpdateLineColour();
                    end;
                }
                field("Ref. Sal. Am. incl. Discount"; Rec."Ref. Sal. Am. incl. Discount")
                {
                    CaptionClass = CaptionArray_G[3];
                    DecimalPlaces = 0 : 0;
                    Editable = false;
                    Visible = Visible043_G;
                }
                field("Plan Sal. Am. incl. Discount"; Rec."Plan Sal. Am. incl. Discount")
                {
                    DecimalPlaces = 0 : 0;
                    Editable = Editable_G;
                    StyleExpr = LineChangedStyle_G;
                    Visible = Visible004_G;

                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                        UpdateLineColour();
                    end;
                }
                field("Ref. Sales Discount"; Rec."Ref. Sales Discount")
                {
                    CaptionClass = CaptionArray_G[4];
                    DecimalPlaces = 0 : 0;
                    Editable = false;
                    Visible = Visible044_G;
                }
                field("Plan Sales Discount"; Rec."Plan Sales Discount")
                {
                    DecimalPlaces = 0 : 0;
                    Editable = Editable_G;
                    StyleExpr = LineChangedStyle_G;
                    Visible = Visible005_G;

                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                        UpdateLineColour();
                    end;
                }
                field("Ref. Sales Discount %"; Rec."Ref. Sales Discount %")
                {
                    CaptionClass = CaptionArray_G[5];
                    DecimalPlaces = 1 : 1;
                    Editable = false;
                    Visible = Visible045_G;
                }
                field("Plan Sales Discount %"; Rec."Plan Sales Discount %")
                {
                    DecimalPlaces = 1 : 1;
                    Editable = Editable_G;
                    StyleExpr = LineChangedStyle_G;
                    Visible = Visible006_G;

                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                        UpdateLineColour();
                    end;
                }
                field("Ref. Sales Init. Inv."; Rec."Ref. Sales Init. Inv.")
                {
                    CaptionClass = CaptionArray_G[6];
                    DecimalPlaces = 0 : 0;
                    Editable = false;
                    Visible = Visible046_G;
                }
                field("Plan Sales Init. Inv."; Rec."Plan Sales Init. Inv.")
                {
                    DecimalPlaces = 0 : 0;
                    Editable = Editable_G;
                    StyleExpr = LineChangedStyle_G;
                    Visible = Visible007_G;

                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                        UpdateLineColour();
                    end;
                }
                field("Ref. Sales Closing Inv."; Rec."Ref. Sales Closing Inv.")
                {
                    CaptionClass = CaptionArray_G[7];
                    DecimalPlaces = 0 : 0;
                    Editable = false;
                    Visible = Visible047_G;
                }
                field("Plan Sales Closing Inv."; Rec."Plan Sales Closing Inv.")
                {
                    DecimalPlaces = 0 : 0;
                    Editable = Editable_G;
                    StyleExpr = LineChangedStyle_G;
                    Visible = Visible008_G;

                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                        UpdateLineColour();
                    end;
                }
                field("Ref. Sales Inv. Change"; Rec."Ref. Sales Inv. Change")
                {
                    CaptionClass = CaptionArray_G[8];
                    DecimalPlaces = 0 : 0;
                    Editable = false;
                    Visible = Visible048_G;
                }
                field("Plan Sales Inv. Change"; Rec."Plan Sales Inv. Change")
                {
                    DecimalPlaces = 0 : 0;
                    Editable = Editable_G;
                    StyleExpr = LineChangedStyle_G;
                    Visible = Visible009_G;

                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                        UpdateLineColour();
                    end;
                }
                field("Ref. Gross Sales Pr. Reduction"; Rec."Ref. Gross Sales Pr. Reduction")
                {
                    CaptionClass = CaptionArray_G[9];
                    DecimalPlaces = 0 : 0;
                    Editable = false;
                    Visible = Visible049_G;
                }
                field("Plan Gross Sales Pr. Reduction"; Rec."Plan Gross Sales Pr. Reduction")
                {
                    DecimalPlaces = 0 : 0;
                    Editable = Editable_G;
                    StyleExpr = LineChangedStyle_G;
                    Visible = Visible010_G;

                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                        UpdateLineColour();
                    end;
                }
                field("Ref. Sales Am. Purchase"; Rec."Ref. Sales Am. Purchase")
                {
                    CaptionClass = CaptionArray_G[11];
                    DecimalPlaces = 0 : 0;
                    Editable = false;
                    Visible = Visible050_G;
                }
                field("Plan Sales Am. Purchase"; Rec."Plan Sales Am. Purchase")
                {
                    DecimalPlaces = 0 : 0;
                    Editable = Editable_G;
                    StyleExpr = LineChangedStyle_G;
                    Visible = Visible011_G;

                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                        UpdateLineColour();
                    end;
                }
                field("Ref. Sales Avg. Inv."; Rec."Ref. Sales Avg. Inv.")
                {
                    CaptionClass = CaptionArray_G[12];
                    DecimalPlaces = 0 : 0;
                    Editable = false;
                    Visible = Visible051_G;
                }
                field("Plan Sales Avg. Inv."; Rec."Plan Sales Avg. Inv.")
                {
                    DecimalPlaces = 0 : 0;
                    Editable = Editable_G;
                    StyleExpr = LineChangedStyle_G;
                    Visible = Visible012_G;
                }
                field("Ref. Qty. Sale"; Rec."Ref. Qty. Sale")
                {
                    CaptionClass = CaptionArray_G[13];
                    DecimalPlaces = 0 : 0;
                    Editable = false;
                    Visible = Visible052_G;
                }
                field("Plan Qty. Sale"; Rec."Plan Qty. Sale")
                {
                    DecimalPlaces = 0 : 0;
                    Editable = Editable_G;
                    StyleExpr = LineChangedStyle_G;
                    Visible = Visible013_G;

                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                        UpdateLineColour();
                    end;
                }
                field("Plan Qty. Sale Diff. %"; Rec."Plan Qty. Sale Diff. %")
                {
                    DecimalPlaces = 1 : 1;
                    Editable = Editable_G;
                    StyleExpr = LineChangedStyle_G;
                    Visible = Visible014_G;

                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                        UpdateLineColour();
                    end;
                }
                field("Ref. Qty. Init. Inv."; Rec."Ref. Qty. Init. Inv.")
                {
                    CaptionClass = CaptionArray_G[15];
                    DecimalPlaces = 0 : 0;
                    Editable = false;
                    Visible = Visible053_G;
                }
                field("Plan Qty. Init. Inv."; Rec."Plan Qty. Init. Inv.")
                {
                    DecimalPlaces = 0 : 0;
                    Editable = Editable_G;
                    StyleExpr = LineChangedStyle_G;
                    Visible = Visible015_G;

                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                        UpdateLineColour();
                    end;
                }
                field("Ref. Qty. Closing Inv."; Rec."Ref. Qty. Closing Inv.")
                {
                    CaptionClass = CaptionArray_G[16];
                    DecimalPlaces = 0 : 0;
                    Editable = false;
                    Visible = Visible054_G;
                }
                field("Plan Qty. Closing Inv."; Rec."Plan Qty. Closing Inv.")
                {
                    DecimalPlaces = 0 : 0;
                    Editable = Editable_G;
                    StyleExpr = LineChangedStyle_G;
                    Visible = Visible016_G;

                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                        UpdateLineColour();
                    end;
                }
                field("Ref. Qty. Inv. Change"; Rec."Ref. Qty. Inv. Change")
                {
                    CaptionClass = CaptionArray_G[17];
                    DecimalPlaces = 0 : 0;
                    Editable = false;
                    Visible = Visible055_G;
                }
                field("Plan Qty. Inv. Change"; Rec."Plan Qty. Inv. Change")
                {
                    DecimalPlaces = 0 : 0;
                    Editable = Editable_G;
                    StyleExpr = LineChangedStyle_G;
                    Visible = Visible017_G;
                }
                field("Ref. Qty. Closing Inv. %"; Rec."Ref. Qty. Closing Inv. %")
                {
                    CaptionClass = CaptionArray_G[18];
                    DecimalPlaces = 1 : 1;
                    Editable = false;
                    Visible = Visible056_G;
                }
                field("Plan Qty. Closing Inv. %"; Rec."Plan Qty. Closing Inv. %")
                {
                    DecimalPlaces = 1 : 1;
                    Editable = Editable_G;
                    StyleExpr = LineChangedStyle_G;
                    Visible = Visible018_G;

                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                        UpdateLineColour();
                    end;
                }
                field("Ref. Qty. Purchase"; Rec."Ref. Qty. Purchase")
                {
                    CaptionClass = CaptionArray_G[19];
                    DecimalPlaces = 0 : 0;
                    Editable = false;
                    Visible = Visible057_G;
                }
                field("Plan Qty. Purchase"; Rec."Plan Qty. Purchase")
                {
                    DecimalPlaces = 0 : 0;
                    Editable = Editable_G;
                    StyleExpr = LineChangedStyle_G;
                    Visible = Visible019_G;

                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                        UpdateLineColour();
                    end;
                }
                field("Ref. Qty. Avg. Inv."; Rec."Ref. Qty. Avg. Inv.")
                {
                    CaptionClass = CaptionArray_G[20];
                    DecimalPlaces = 0 : 0;
                    Editable = false;
                    Visible = Visible058_G;
                }
                field("Plan Qty. Avg. Inv."; Rec."Plan Qty. Avg. Inv.")
                {
                    DecimalPlaces = 0 : 0;
                    Editable = Editable_G;
                    StyleExpr = LineChangedStyle_G;
                    Visible = Visible020_G;
                }
                field("Plan Cost of Sales %"; Rec."Plan Cost of Sales %")
                {
                    DecimalPlaces = 1 : 1;
                    Editable = Editable_G;
                    StyleExpr = LineChangedStyle_G;
                    Visible = Visible002_G;

                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                        UpdateLineColour();
                    end;
                }
                field("Ref. Cost Init. Inv."; Rec."Ref. Cost Init. Inv.")
                {
                    CaptionClass = CaptionArray_G[23];
                    DecimalPlaces = 0 : 0;
                    Editable = false;
                    Visible = Visible060_G;
                }
                field("Plan Cost Init. Inv."; Rec."Plan Cost Init. Inv.")
                {
                    DecimalPlaces = 0 : 0;
                    Editable = Editable_G;
                    StyleExpr = LineChangedStyle_G;
                    Visible = Visible022_G;

                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                        UpdateLineColour();
                    end;
                }
                field("Ref. Cost Closing Inv."; Rec."Ref. Cost Closing Inv.")
                {
                    CaptionClass = CaptionArray_G[24];
                    DecimalPlaces = 0 : 0;
                    Editable = false;
                    Visible = Visible061_G;
                }
                field("Plan Cost Closing Inv."; Rec."Plan Cost Closing Inv.")
                {
                    DecimalPlaces = 0 : 0;
                    Editable = Editable_G;
                    StyleExpr = LineChangedStyle_G;
                    Visible = Visible023_G;

                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                        UpdateLineColour();
                    end;
                }
                field("Ref. Cost Inv. Change"; Rec."Ref. Cost Inv. Change")
                {
                    CaptionClass = CaptionArray_G[25];
                    DecimalPlaces = 0 : 0;
                    Editable = false;
                    Visible = Visible062_G;
                }
                field("Plan Cost Inv. Change"; Rec."Plan Cost Inv. Change")
                {
                    DecimalPlaces = 0 : 0;
                    Editable = Editable_G;
                    StyleExpr = LineChangedStyle_G;
                    Visible = Visible024_G;
                }
                field("Ref. Calc. Purchase %"; Rec."Ref. Calc. Purchase %")
                {
                    CaptionClass = CaptionArray_G[40];
                    DecimalPlaces = 1 : 1;
                    Editable = false;
                    Visible = Visible077_G;
                }
                field("Plan Calc. Purchase %"; Rec."Plan Calc. Purchase %")
                {
                    DecimalPlaces = 0 : 2;
                    Editable = Editable_G;
                    StyleExpr = LineChangedStyle_G;
                    Visible = Visible039_G;

                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                        UpdateLineColour();
                    end;
                }
                field("Ref. Cost Am. Purchase"; Rec."Ref. Cost Am. Purchase")
                {
                    CaptionClass = CaptionArray_G[26];
                    DecimalPlaces = 0 : 0;
                    Editable = false;
                    Visible = Visible063_G;
                }
                field("Plan Cost Am. Purchase"; Rec."Plan Cost Am. Purchase")
                {
                    DecimalPlaces = 0 : 0;
                    Editable = Editable_G;
                    StyleExpr = LineChangedStyle_G;
                    Visible = Visible025_G;

                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                        UpdateLineColour();
                    end;
                }

                field("Plan Limit 1 %"; Rec."Plan Limit 1 %")
                {
                    DecimalPlaces = 0 : 2;
                    Editable = Editable_G;
                    StyleExpr = LineChangedStyle_G;
                    Visible = Visible085_G;

                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                        UpdateLineColour();
                    end;
                }

                field("Plan Cost Am. Purch. 1"; Rec."Plan Cost Am. Purch. 1")
                {
                    DecimalPlaces = 0;
                    Editable = Editable_G;
                    StyleExpr = LineChangedStyle_G;
                    Visible = Visible085_G;
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                        UpdateLineColour();
                    end;
                }

                field("Plan Limit 2 %"; Rec."Plan Limit 2 %")
                {
                    DecimalPlaces = 0 : 2;
                    Editable = Editable_G;
                    StyleExpr = LineChangedStyle_G;
                    Visible = Visible085_G;

                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                        UpdateLineColour();
                    end;
                }

                field("Plan Cost Am. Purch. 2"; Rec."Plan Cost Am. Purch. 2")
                {
                    DecimalPlaces = 0;
                    Editable = false;
                    StyleExpr = LineChangedStyle_G;
                    Visible = Visible085_G;
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                        UpdateLineColour();
                    end;
                }

                field("Plan Limit 3 %"; Rec."Plan Limit 3 %")
                {
                    DecimalPlaces = 0 : 2;
                    Editable = Editable_G;
                    StyleExpr = LineChangedStyle_G;
                    Visible = Visible085_G;

                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                        UpdateLineColour();
                    end;
                }

                field("Plan Cost Am. Purch. 3"; Rec."Plan Cost Am. Purch. 3")
                {
                    DecimalPlaces = 0;
                    Editable = false;
                    StyleExpr = LineChangedStyle_G;
                    Visible = Visible085_G;
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                        UpdateLineColour();
                    end;
                }

                field("Plan Limit 4 %"; Rec."Plan Limit 4 %")
                {
                    DecimalPlaces = 0 : 2;
                    Editable = Editable_G;
                    StyleExpr = LineChangedStyle_G;
                    Visible = Visible085_G;

                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                        UpdateLineColour();
                    end;
                }

                field("Plan Cost Am. Purch. 4"; Rec."Plan Cost Am. Purch. 4")
                {
                    DecimalPlaces = 0;
                    Editable = false;
                    StyleExpr = LineChangedStyle_G;
                    Visible = Visible085_G;
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                        UpdateLineColour();
                    end;
                }

                field("Plan Limit 5 %"; Rec."Plan Limit 5 %")
                {
                    DecimalPlaces = 0 : 2;
                    Editable = Editable_G;
                    StyleExpr = LineChangedStyle_G;
                    Visible = Visible085_G;

                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                        UpdateLineColour();
                    end;
                }

                field("Plan Cost Am. Purch. 5"; Rec."Plan Cost Am. Purch. 5")
                {
                    DecimalPlaces = 0;
                    Editable = false;
                    StyleExpr = LineChangedStyle_G;
                    Visible = Visible085_G;
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                        UpdateLineColour();
                    end;
                }

                field("Ref. Cost Avg. Inv."; Rec."Ref. Cost Avg. Inv.")
                {
                    CaptionClass = CaptionArray_G[27];
                    DecimalPlaces = 0 : 0;
                    Editable = false;
                    Visible = Visible064_G;
                }
                field("Plan Cost Avg. Inv."; Rec."Plan Cost Avg. Inv.")
                {
                    DecimalPlaces = 0 : 0;
                    Editable = Editable_G;
                    StyleExpr = LineChangedStyle_G;
                    Visible = Visible026_G;
                }
                field("Ref. S.Price Sales"; Rec."Ref. S.Price Sales")
                {
                    CaptionClass = CaptionArray_G[28];
                    DecimalPlaces = 2 : 2;
                    Editable = false;
                    Visible = Visible065_G;
                }
                field("Plan S.Price Sales"; Rec."Plan S.Price Sales")
                {
                    Editable = Editable_G;
                    StyleExpr = LineChangedStyle_G;
                    Visible = Visible027_G;

                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                        UpdateLineColour();
                    end;
                }
                field("Ref. S.Price incl. Discount"; Rec."Ref. S.Price incl. Discount")
                {
                    CaptionClass = CaptionArray_G[29];
                    Editable = false;
                    Visible = Visible066_G;
                }
                field("Plan S.Price incl. Discount"; Rec."Plan S.Price incl. Discount")
                {
                    Editable = Editable_G;
                    StyleExpr = LineChangedStyle_G;
                    Visible = Visible028_G;
                }
                field("Ref. S.Price Purchase"; Rec."Ref. S.Price Purchase")
                {
                    CaptionClass = CaptionArray_G[30];
                    Editable = false;
                    Visible = Visible067_G;
                }
                field("Plan S.Price Purchase"; Rec."Plan S.Price Purchase")
                {
                    Editable = Editable_G;
                    StyleExpr = LineChangedStyle_G;
                    Visible = Visible029_G;
                }
                field("Ref. S.Price Init. Inv."; Rec."Ref. S.Price Init. Inv.")
                {
                    CaptionClass = CaptionArray_G[31];
                    Editable = false;
                    Visible = Visible068_G;
                }
                field("Plan S.Price Init. Inv."; Rec."Plan S.Price Init. Inv.")
                {
                    Editable = Editable_G;
                    StyleExpr = LineChangedStyle_G;
                    Visible = Visible030_G;
                }
                field("Ref. S.Price Closing Inv."; Rec."Ref. S.Price Closing Inv.")
                {
                    CaptionClass = CaptionArray_G[32];
                    Editable = false;
                    Visible = Visible069_G;
                }
                field("Plan S.Price Closing Inv."; Rec."Plan S.Price Closing Inv.")
                {
                    Editable = Editable_G;
                    StyleExpr = LineChangedStyle_G;
                    Visible = Visible031_G;
                }
                field("Ref. P.Price Sales"; Rec."Ref. P.Price Sales")
                {
                    CaptionClass = CaptionArray_G[33];
                    Editable = false;
                    Visible = Visible070_G;
                }
                field("Plan P.Price Sales"; Rec."Plan P.Price Sales")
                {
                    Editable = Editable_G;
                    StyleExpr = LineChangedStyle_G;
                    Visible = Visible032_G;
                }
                field("Ref. P.Price Purchase"; Rec."Ref. P.Price Purchase")
                {
                    CaptionClass = CaptionArray_G[34];
                    Editable = false;
                    Visible = Visible071_G;

                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                        UpdateLineColour();
                    end;
                }
                field("Plan P.Price Purchase"; Rec."Plan P.Price Purchase")
                {
                    Editable = Editable_G;
                    StyleExpr = LineChangedStyle_G;
                    Visible = Visible033_G;
                }
                field("Ref. P.Price Init. Inv."; Rec."Ref. P.Price Init. Inv.")
                {
                    CaptionClass = CaptionArray_G[35];
                    Editable = false;
                    Visible = Visible072_G;
                }
                field("Plan P.Price Init. Inv."; Rec."Plan P.Price Init. Inv.")
                {
                    Editable = Editable_G;
                    StyleExpr = LineChangedStyle_G;
                    Visible = Visible034_G;
                }
                field("Ref. P.Price Closing Inv."; Rec."Ref. P.Price Closing Inv.")
                {
                    CaptionClass = CaptionArray_G[36];
                    Editable = false;
                    Visible = Visible073_G;
                }
                field("Plan P.Price Closing Inv."; Rec."Plan P.Price Closing Inv.")
                {
                    Editable = Editable_G;
                    StyleExpr = LineChangedStyle_G;
                    Visible = Visible035_G;
                }
                field("Ref. Inv. Turnover"; Rec."Ref. Inv. Turnover")
                {
                    CaptionClass = CaptionArray_G[37];
                    Editable = false;
                    Visible = Visible074_G;
                }
                field("Plan Inv. Turnover"; Rec."Plan Inv. Turnover")
                {
                    Visible = Visible036_G;
                }
                field("Ref. Calc. Sales incl. Disc. %"; Rec."Ref. Calc. Sales incl. Disc. %")
                {
                    CaptionClass = CaptionArray_G[39];
                    DecimalPlaces = 1 : 1;
                    Editable = false;
                    Visible = Visible076_G;
                }
                field("Plan Calc. Sales incl. Disc. %"; Rec."Plan Calc. Sales incl. Disc. %")
                {
                    DecimalPlaces = 0 : 2;
                    Editable = Editable_G;
                    StyleExpr = LineChangedStyle_G;
                    Visible = Visible038_G;
                }
                field("Ref. Calc. Init. Inv. %"; Rec."Ref. Calc. Init. Inv. %")
                {
                    CaptionClass = CaptionArray_G[41];
                    DecimalPlaces = 1 : 1;
                    Editable = false;
                    Visible = Visible078_G;
                }
                field("Plan Calc. Init. Inv. %"; Rec."Plan Calc. Init. Inv. %")
                {
                    DecimalPlaces = 0 : 2;
                    Editable = Editable_G;
                    StyleExpr = LineChangedStyle_G;
                    Visible = Visible040_G;
                }
                field("Ref. Calc. Closing Inv. %"; Rec."Ref. Calc. Closing Inv. %")
                {
                    CaptionClass = CaptionArray_G[42];
                    DecimalPlaces = 1 : 1;
                    Editable = false;
                    Visible = Visible079_G;
                }
                field("Plan Calc. Closing Inv. %"; Rec."Plan Calc. Closing Inv. %")
                {
                    DecimalPlaces = 0 : 2;
                    Editable = Editable_G;
                    StyleExpr = LineChangedStyle_G;
                    Visible = Visible041_G;
                }
            }
            group(Total)
            {
                Caption = 'Total';
                part(TotalSubform; "BET FN Planning View Subpage")
                {
                }
            }
        }
        area(FactBoxes)
        {
            systempart(Control1900383207; Links)
            {
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            group(PlanMenu)
            {
                Caption = 'Planning';

                ObsoleteState = Pending;
                ObsoleteTag = '25.2';
                ObsoleteReason = '#35131 Pending removal - will be removed in future updates';
            }
        }
        area(Processing)
        {
            action(LevelUp)
            {
                Caption = 'Level up';
                Ellipsis = false;
                Enabled = LevelUpEnable_G;
                Image = MoveUp;
                ToolTip = 'Level Up';

                trigger OnAction()
                begin
                    ChangeLevel(1);
                end;
            }
            action(LevelDown)
            {
                Caption = 'Level down';
                Enabled = LevelDownEnable_G;
                Image = MoveDown;
                ToolTip = 'Level Down';

                trigger OnAction()
                begin
                    ChangeLevel(-1);
                end;
            }
            action(ShowDateLevel)
            {
                Caption = 'Show Date Level';
                ToolTip = 'Show Date Level';
                Enabled = DocHasDateLevel_G;
                Image = Calendar;
                ShortcutKey = 'Ctrl+D';

                trigger OnAction()
                begin
                    ChangeDateLevel();
                end;
            }
            action(ChangeFilters)
            {
                Caption = 'Edit Filters';
                ToolTip = 'Edit Filters';
                Enabled = PrevNextEnabled_G;
                Image = EditFilter;
                ShortcutKey = 'Ctrl+E';

                trigger OnAction()
                begin
                    EditFilters();
                end;
            }
            action(Previous)
            {
                Caption = 'Previous';
                ToolTip = 'Previous';
                Enabled = PrevNextEnabled_G;
                Image = PreviousRecord;

                trigger OnAction()
                begin
                    QuickAccessFilter(-1);
                end;
            }
            action(Next)
            {
                Caption = 'Next';
                ToolTip = 'Next';
                Enabled = PrevNextEnabled_G;
                Image = NextRecord;

                trigger OnAction()
                begin
                    QuickAccessFilter(1);
                end;
            }
            action(DefaultSorting)
            {
                Caption = 'Standardsortierung';
                ToolTip = 'Standardsortierung';
                Image = SetPriorities;

                trigger OnAction()
                begin
                    SetDefaultSorting();
                end;
            }
            group(FunctionMenu)
            {
                Caption = 'Functions';
                action(TopDown)
                {
                    Caption = 'Top Down';
                    ToolTip = 'Top Down';
                    Image = ExplodeBOM;
                    ShortcutKey = 'Ctrl+T';

                    trigger OnAction()
                    begin
                        CalcTopDown();
                    end;
                }
                action("Layout")
                {
                    Caption = 'Layout';
                    ToolTip = 'Layout';
                    Image = SetupColumns;

                    trigger OnAction()
                    begin
                        ChangeLayout();
                    end;
                }

                action(CalcReferenceValues)
                {
                    Caption = 'Calculate Reference Values';
                    ToolTip = 'Calculate Reference Values';
                    Image = Statistics;
                    ShortcutKey = 'Ctrl+G';

                    trigger OnAction()
                    begin
                        GetReferenceValues();
                    end;
                }
                action(CopyValuesInDocument)
                {
                    Caption = 'Copy planning values';
                    ToolTip = 'Copy planning values';
                    Image = CopyBudget;

                    trigger OnAction()
                    begin
                        CopyPlanningValuesWithinDocument();
                    end;
                }
                action(ImportPlanningValuesFromDoc)
                {
                    Caption = 'Import Planning Values from Document ...';
                    ToolTip = 'Import Planning Values from Document ...';
                    Enabled = false;
                    Image = Import;
                    ShortcutKey = 'Ctrl+B';

                    trigger OnAction()
                    begin
                        ImportPlanningValues();
                    end;
                }
            }
        }
        area(Promoted)
        {
            actionref(TopDown_Promoted; TopDown)
            {
            }
            actionref(LevelUp_Promoted; LevelUp)
            {
            }
            actionref(LevelDown_Promoted; LevelDown)
            {
            }
            actionref(ShowDateLevel_Promoted; ShowDateLevel)
            {
            }
            actionref(ChangeFilters_Promoted; ChangeFilters)
            {
            }
            actionref(Previous_Promoted; Previous)
            {
            }
            actionref(Next_Promoted; Next)
            {
            }
            actionref(DefaultSorting_Promoted; DefaultSorting)
            {
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        PlanFunctions_LC: Codeunit "BET FN Planning Functions";
    begin
        xRec := Rec;

        PlanFunctions_LC.GetDescriptionArray(Rec, PlanDoc_GT, DescrArray_G, DescrOptions_G, LineInformation_G);

        SetRefCaptions();   // Vgl.-Captions anpassen
        ShowDim();
        CalculateSummary(Rec);
    end;

    trigger OnAfterGetRecord()
    var
        PlanFunctions_LC: Codeunit "BET FN Planning Functions";
    begin
        PlanFunctions_LC.GetDescriptionArray(Rec, PlanDoc_GT, DescrArray_G, DescrOptions_G, LineInformation_G);
        if LineInfoVisible_G and (LineInformation_G <> '') then
            CurrPage.Caption(BaseCaption_G + ' +++ ' + LineInformation_G)
        else
            CurrPage.Caption(BaseCaption_G);

        // Datumsbeschreibung:
        if PlanDoc_GT."Show Date Description" then
            if TempDate_GTT.Get(PlanDoc_GT."Date Unit", Rec.Date) then
                DateDescription_G := TempDate_GTT."Period Name"
            else
                DateDescription_G := '';

        UpdateLineColour();

        if PlanDoc_GT."Auto Filter On Level Changing" then begin
            PlanViewFilter_GT.FilterGroup(2);
            if PlanViewFilter_GT.GetFilters <> '' then begin
                Rec.FilterGroup(2);
                Rec.CopyFilters(PlanViewFilter_GT);
                Rec.FilterGroup(0);
            end;
            PlanViewFilter_GT.FilterGroup(0);
        end;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        if (Rec.Fixed = xRec.Fixed) then
            Rec.Changed := true;
    end;

    trigger OnOpenPage()
    var
        PlanDoc_LT: Record "BET FN Planning Document";
        PlanDocLevel_LT: Record "BET FN Planning Document Level";
        PlanSetup_LT: Record "BET FN Planning Setup";
        PlanFunctions_LC: Codeunit "BET FN Planning Functions";
    begin
        PlanSetup_LT.Get();

        PlanFunctions_LC.InitPlanningStatistic();
        LockFilters();  // die übergebenen Filter auf Filterebene 2 heben

        Rec.FilterGroup(2);
        PlanDoc_LT.Get(Rec.GetFilter("Planning Document No."));
        DistributionType_G := PlanDoc_LT."Distribution Type";
        Rec.FilterGroup(0);
        PlanDoc_GT := PlanDoc_LT;

        // temp. Datumstabelle aufbauen mit Datum und Monatsbeschreibungen (für optionale Angabe der Monatsnamen):
        PlanFunctions_LC.CreateDateDescriptions(TempDate_GTT, PlanDoc_LT);

        // Caption anpassen:
        CurrPage.Caption(PlanDoc_LT."No.");

        // Caption des Fensters um Belegbeschreibung erweitern
        if PlanDoc_LT.Description <> '' then
            CurrPage.Caption(CurrPage.Caption() + ' - ' + PlanDoc_LT.Description);

        // Geschäftsjahr:
        if PlanDoc_LT."Financial Year" <> '' then
            CurrPage.Caption(CurrPage.Caption() + ' - ' + PlanDoc_LT."Financial Year");

        // Caption des Fensters um Einkäufer erweitern
        if PlanDoc_LT."Purchaser Code" <> '' then begin
            PlanDoc_LT.CalcFields("Purchaser Name");
            CurrPage.Caption(CurrPage.Caption() + ' - ' + PlanDoc_LT."Purchaser Name");
        end;

        if PlanDoc_LT."Planning Season" <> '' then
            CurrPage.Caption(CurrPage.Caption() + ' - ' + PlanDoc_LT."Planning Season");

        ChangeLevel(0);
        UpdateLines();

        PlanFunctions_LC.InitDescriptionOptions(PlanDoc_LT, DescrOptions_G);

        // bei automatischer Filterung die Standardfiterung und Schnellzugriff deaktivieren:
        PrevNextEnabled_G := (not PlanDoc_LT."Auto Filter On Level Changing");

        // Datumsfunktionen deaktivieren, wenn kein Datum verwendet wird:
        PlanDocLevel_LT.Reset();
        PlanDocLevel_LT.SetRange("Planning Document No.", PlanDoc_LT."No.");
        PlanDocLevel_LT.SetRange("Activate Date Level", true);
        DocHasDateLevel_G := not PlanDocLevel_LT.IsEmpty();

        LineInfoVisible_G := PlanSetup_LT."Show Line Information";
        ShowFixed_G := PlanSetup_LT."Show Fixed Column";
        BaseCaption_G := CurrPage.Caption();

        Editable_G := (PlanDoc_LT.Status = PlanDoc_LT.Status::Open);
    end;

    var
        PlanDoc_GT: Record "BET FN Planning Document";
        PlanViewFilter_GT: Record "BET FN Planning View";
        TempDate_GTT: Record Date temporary;
        PlanDocFilterMgt_GC: Codeunit "BET FN Planning Doc Fltr Mgt";
        DateFilterActivated_G: Boolean;
        DocHasDateLevel_G: Boolean;
        Editable_G: Boolean;
        I1Visible_G: Boolean;
        I2Visible_G: Boolean;
        I3Visible_G: Boolean;
        I4Visible_G: Boolean;
        I5Visible_G: Boolean;
        I6Visible_G: Boolean;
        LevelDownEnable_G: Boolean;
        LevelUpEnable_G: Boolean;
        LineInfoVisible_G: Boolean;
        PrevNextEnabled_G: Boolean;
        ShowDate_G: Boolean;
        ShowDateDescription_G: Boolean;
        ShowFixed_G: Boolean;
        Visible002_G: Boolean;
        Visible003_G: Boolean;
        Visible004_G: Boolean;
        Visible005_G: Boolean;
        Visible006_G: Boolean;
        Visible007_G: Boolean;
        Visible008_G: Boolean;
        Visible009_G: Boolean;
        Visible010_G: Boolean;
        Visible011_G: Boolean;
        Visible012_G: Boolean;
        Visible013_G: Boolean;
        Visible014_G: Boolean;
        Visible015_G: Boolean;
        Visible016_G: Boolean;
        Visible017_G: Boolean;
        Visible018_G: Boolean;
        Visible019_G: Boolean;
        Visible020_G: Boolean;
        Visible021_G: Boolean;
        Visible022_G: Boolean;
        Visible023_G: Boolean;
        Visible024_G: Boolean;
        Visible025_G: Boolean;
        Visible026_G: Boolean;
        Visible027_G: Boolean;
        Visible028_G: Boolean;
        Visible029_G: Boolean;
        Visible030_G: Boolean;
        Visible031_G: Boolean;
        Visible032_G: Boolean;
        Visible033_G: Boolean;
        Visible034_G: Boolean;
        Visible035_G: Boolean;
        Visible036_G: Boolean;
        Visible037_G: Boolean;
        Visible038_G: Boolean;
        Visible039_G: Boolean;
        Visible040_G: Boolean;
        Visible041_G: Boolean;
        Visible042_G: Boolean;
        Visible043_G: Boolean;
        Visible044_G: Boolean;
        Visible045_G: Boolean;
        Visible046_G: Boolean;
        Visible047_G: Boolean;
        Visible048_G: Boolean;
        Visible049_G: Boolean;
        Visible050_G: Boolean;
        Visible051_G: Boolean;
        Visible052_G: Boolean;
        Visible053_G: Boolean;
        Visible054_G: Boolean;
        Visible055_G: Boolean;
        Visible056_G: Boolean;
        Visible057_G: Boolean;
        Visible058_G: Boolean;
        Visible059_G: Boolean;
        Visible060_G: Boolean;
        Visible061_G: Boolean;
        Visible062_G: Boolean;
        Visible063_G: Boolean;
        Visible064_G: Boolean;
        Visible065_G: Boolean;
        Visible066_G: Boolean;
        Visible067_G: Boolean;
        Visible068_G: Boolean;
        Visible069_G: Boolean;
        Visible070_G: Boolean;
        Visible071_G: Boolean;
        Visible072_G: Boolean;
        Visible073_G: Boolean;
        Visible074_G: Boolean;
        Visible075_G: Boolean;
        Visible076_G: Boolean;
        Visible077_G: Boolean;
        Visible078_G: Boolean;
        Visible079_G: Boolean;
        Visible082_G: Boolean;
        Visible083_G: Boolean;
        Visible084_G: Boolean;
        Visible085_G: Boolean;
        QuickAccess_G: Option " ",Date,Index1,Index2,Index3,Index4,Index5,Index6;
        DescrOptions_G: array[6] of Option "Code",Description,Both;
        DistributionType_G: Option RefValues,PlanValues,DistributionTemplate;
        BaseCaption_G: Text;
        DateDescription_G: Text;
        DateFilter_G: Text;
        DescrArray_G: array[6] of Text;
        FilterText_G: Text[1024];
        IndexFilterArray_G: array[10] of Text;
        IndexTextArray_G: array[10] of Text;
        LevelText_G: Text;
        LineChangedStyle_G: Text;
        LineInformation_G: Text;
        CaptionArray_G: array[50] of Text[50];
        IndexCaption_G: array[6] of Text[50];

    /// <summary>
    /// UpdateLayout.
    /// </summary>
    /// <param name="PlanDocLevel_PT">Record "BET FN Planning Document Level".</param>
    procedure UpdateLayout(PlanDocLevel_PT: Record "BET FN Planning Document Level")
    var
        PlanDoc_LT: Record "BET FN Planning Document";
        LayoutTemplate_LT: Record "BET FN Planning Layout Tmplt";
        LayoutTemplateCode_L: Code[20];
        LevelIndex_L: Integer;
        MsgText_L: Text;
    begin
        Rec.FilterGroup(2);
        PlanDoc_LT.Get(Rec.GetFilter("Planning Document No."));
        Evaluate(LevelIndex_L, Rec.GetFilter("Planning Document Level"));
        Rec.FilterGroup(0);

        // wenn automatische Filterung aktiviert ist, immer nur aktive Ebene anzeigen 
        if PlanDoc_LT."Auto Filter On Level Changing" then begin
            I1Visible_G := (LevelIndex_L = 1);
            I2Visible_G := (LevelIndex_L = 2);
            I3Visible_G := (LevelIndex_L = 3);
            I4Visible_G := (LevelIndex_L = 4);
            I5Visible_G := (LevelIndex_L = 5);
            I6Visible_G := (LevelIndex_L = 6);
        end else begin
            I1Visible_G := PlanDocLevel_PT."Index Code 1" <> '';
            I2Visible_G := PlanDocLevel_PT."Index Code 2" <> '';
            I3Visible_G := PlanDocLevel_PT."Index Code 3" <> '';
            I4Visible_G := PlanDocLevel_PT."Index Code 4" <> '';
            I5Visible_G := PlanDocLevel_PT."Index Code 5" <> '';
            I6Visible_G := PlanDocLevel_PT."Index Code 6" <> '';
        end;

        Visible002_G := false;

        if PlanDoc_LT."Use Global Layout" then begin
            LayoutTemplateCode_L := PlanDoc_LT."Layout Template";
            MsgText_L := PlanDoc_LT.TableCaption();
        end else begin
            LayoutTemplateCode_L := PlanDocLevel_PT."Layout Template";
            MsgText_L := PlanDocLevel_PT.TableCaption();
        end;


        if LayoutTemplate_LT.Get(LayoutTemplateCode_L) then begin
            Visible003_G := LayoutTemplate_LT."Plan Sales Amount";
            Visible004_G := LayoutTemplate_LT."Plan Sal. Am. incl. Discount";
            Visible005_G := LayoutTemplate_LT."Plan Sales Discount";
            Visible006_G := LayoutTemplate_LT."Plan Sales Discount %";
            Visible007_G := LayoutTemplate_LT."Plan Sales Init. Inv.";
            Visible008_G := LayoutTemplate_LT."Plan Sales Closing Inv.";
            Visible009_G := LayoutTemplate_LT."Plan Sales Inv. Change";
            Visible010_G := LayoutTemplate_LT."Plan Gross Sales Pr. Reduction";
            Visible011_G := LayoutTemplate_LT."Plan Sales Am. Purchase";
            Visible012_G := LayoutTemplate_LT."Plan Sales Avg. Inv.";
            Visible013_G := LayoutTemplate_LT."Plan Qty. Sale";
            Visible014_G := LayoutTemplate_LT."Plan Qty. Sale Diff. %";
            Visible015_G := LayoutTemplate_LT."Plan Qty. Init. Inv.";
            Visible016_G := LayoutTemplate_LT."Plan Qty. Closing Inv.";
            Visible017_G := LayoutTemplate_LT."Plan Qty. Inv. Change";
            Visible018_G := LayoutTemplate_LT."Plan Qty. Closing Inv. %";
            Visible019_G := LayoutTemplate_LT."Plan Qty. Purchase";
            Visible020_G := LayoutTemplate_LT."Plan Qty. Avg. Inv.";
            Visible021_G := LayoutTemplate_LT."Plan Cost of Sales";
            Visible022_G := LayoutTemplate_LT."Plan Cost Init. Inv.";
            Visible023_G := LayoutTemplate_LT."Plan Cost Closing Inv.";
            Visible024_G := LayoutTemplate_LT."Plan Cost Inv. Change";
            Visible025_G := LayoutTemplate_LT."Plan Cost Am. Purchase";
            Visible026_G := LayoutTemplate_LT."Plan Cost Avg. Inv.";
            Visible027_G := LayoutTemplate_LT."Plan S.Price Sales";
            Visible028_G := LayoutTemplate_LT."Plan S.Price incl. Discount";
            Visible029_G := LayoutTemplate_LT."Plan S.Price Purchase";
            Visible030_G := LayoutTemplate_LT."Plan S.Price Init. Inv.";
            Visible031_G := LayoutTemplate_LT."Plan S.Price Closing Inv.";
            Visible032_G := LayoutTemplate_LT."Plan P.Price Sales";
            Visible033_G := LayoutTemplate_LT."Plan P.Price Purchase";
            Visible034_G := LayoutTemplate_LT."Plan P.Price Init. Inv.";
            Visible035_G := LayoutTemplate_LT."Plan P.Price Closing Inv.";
            Visible036_G := LayoutTemplate_LT."Plan Inv. Turnover";
            Visible037_G := LayoutTemplate_LT."Plan Calc. Sales %";
            Visible038_G := LayoutTemplate_LT."Plan Calc. Sales incl. Disc. %";
            Visible039_G := LayoutTemplate_LT."Plan Calc. Purchase %";
            Visible040_G := LayoutTemplate_LT."Plan Calc. Init. Inv. %";
            Visible041_G := LayoutTemplate_LT."Plan Calc. Closing Inv. %";
            Visible042_G := LayoutTemplate_LT."Ref. Sales Amount";
            Visible043_G := LayoutTemplate_LT."Ref. Sal. Am. incl. Discount";
            Visible044_G := LayoutTemplate_LT."Ref. Sales Discount";
            Visible045_G := LayoutTemplate_LT."Ref. Sales Discount %";
            Visible046_G := LayoutTemplate_LT."Ref. Sales Init. Inv.";
            Visible047_G := LayoutTemplate_LT."Ref. Sales Closing Inv.";
            Visible048_G := LayoutTemplate_LT."Ref. Sales Inv. Change";
            Visible049_G := LayoutTemplate_LT."Ref. Gross Sales Pr. Reduction";
            Visible050_G := LayoutTemplate_LT."Ref. Sales Am. Purchase";
            Visible051_G := LayoutTemplate_LT."Ref. Sales Avg. Inv.";
            Visible052_G := LayoutTemplate_LT."Ref. Qty. Sale";
            Visible053_G := LayoutTemplate_LT."Ref. Qty. Init. Inv.";
            Visible054_G := LayoutTemplate_LT."Ref. Qty. Closing Inv.";
            Visible055_G := LayoutTemplate_LT."Ref. Qty. Inv. Change";
            Visible056_G := LayoutTemplate_LT."Ref. Qty. Closing Inv. %";
            Visible057_G := LayoutTemplate_LT."Ref. Qty. Purchase";
            Visible058_G := LayoutTemplate_LT."Ref. Qty. Avg. Inv.";
            Visible059_G := LayoutTemplate_LT."Ref. Cost of Sales";
            Visible060_G := LayoutTemplate_LT."Ref. Cost Init. Inv.";
            Visible061_G := LayoutTemplate_LT."Ref. Cost Closing Inv.";
            Visible062_G := LayoutTemplate_LT."Ref. Cost Inv. Change";
            Visible063_G := LayoutTemplate_LT."Ref. Cost Val. Purchase";
            Visible064_G := LayoutTemplate_LT."Ref. Cost Avg. Inv.";
            Visible065_G := LayoutTemplate_LT."Ref. S.Price Sales";
            Visible066_G := LayoutTemplate_LT."Ref. S.Price incl. Discount";
            Visible067_G := LayoutTemplate_LT."Ref. S.Price Purchase";
            Visible068_G := LayoutTemplate_LT."Ref. S.Price Init. Inv.";
            Visible069_G := LayoutTemplate_LT."Ref. S.Price Closing Inv.";
            Visible070_G := LayoutTemplate_LT."Ref. P.Price Sales";
            Visible071_G := LayoutTemplate_LT."Ref. P.Price Purchase";
            Visible072_G := LayoutTemplate_LT."Ref. P.Price Init. Inv.";
            Visible073_G := LayoutTemplate_LT."Ref. P.Price Closing Inv.";
            Visible074_G := LayoutTemplate_LT."Ref. Inv. Turnover";
            Visible075_G := LayoutTemplate_LT."Ref. Calc. Sales %";
            Visible076_G := LayoutTemplate_LT."Ref. Calc. Sales incl. Disc. %";
            Visible077_G := LayoutTemplate_LT."Ref. Calc. Purchase %";
            Visible078_G := LayoutTemplate_LT."Ref. Calc. Init. Inv. %";
            Visible079_G := LayoutTemplate_LT."Ref. Calc. Closing Inv. %";
            //Visible080_G := LayoutTemplate_LT."Plan Calc. Sales Target %";
            //Visible081_G := LayoutTemplate_LT."Plan Calc. Sales Diff. %";
            Visible082_G := LayoutTemplate_LT."Plan Sal. Am. Difference %";
            Visible083_G := LayoutTemplate_LT."Ref. Sales Percentage" and PlanDoc_LT."Auto Filter On Level Changing";
            Visible084_G := LayoutTemplate_LT."Plan Sales Percentage" and PlanDoc_LT."Auto Filter On Level Changing";

            Visible085_G := LayoutTemplate_LT."Plan Cost Am. Purch. 1-5";
        end;

        //### Layout auf Summen-Subpage übertragen:
        CurrPage.TotalSubform.Page.SetLayout(PlanDocLevel_PT, PlanDoc_LT);
    end;

    /// <summary>
    /// ShowDim.
    /// </summary>
    procedure ShowDim()
    var
        PlanFunctions_LC: Codeunit "BET FN Planning Functions";
    begin
        PlanFunctions_LC.ShowDim(Rec."Planning Document No.", Rec."Planning Document Level", IndexCaption_G);
    end;

    /// <summary>
    /// UpdateFiltertext.
    /// </summary>
    procedure UpdateFiltertext()
    var
        PlanFunctions_LC: Codeunit "BET FN Planning Functions";
    begin
        PlanFunctions_LC.UpdateFilterText(FilterText_G, IndexTextArray_G, IndexFilterArray_G, Rec.FieldCaption(Date), DateFilter_G, DateFilterActivated_G);
    end;

    /// <summary>
    /// UpdateLeveltext.
    /// </summary>
    procedure UpdateLeveltext()
    var
        PlanFunctions_LC: Codeunit "BET FN Planning Functions";
    begin
        PlanFunctions_LC.UpdateLevelText(LevelText_G, IndexTextArray_G, DateFilterActivated_G, QuickAccess_G, Rec.FieldCaption(Date));
    end;

    /// <summary>
    /// GetIndexText.
    /// </summary>
    procedure GetIndexText()
    var
        PlanDocLevel_LT: Record "BET FN Planning Document Level";
        Level_L: Integer;
    begin
        Rec.FilterGroup(2);
        Evaluate(Level_L, Rec.GetFilter("Planning Document Level"));
        PlanDocLevel_LT.Get(Rec.GetFilter("Planning Document No."), Level_L);
        Rec.FilterGroup(0);

        IndexTextArray_G[1] := PlanDocLevel_LT."Index Code 1";
        IndexTextArray_G[2] := PlanDocLevel_LT."Index Code 2";
        IndexTextArray_G[3] := PlanDocLevel_LT."Index Code 3";
        IndexTextArray_G[4] := PlanDocLevel_LT."Index Code 4";
        IndexTextArray_G[5] := PlanDocLevel_LT."Index Code 5";
        IndexTextArray_G[6] := PlanDocLevel_LT."Index Code 6";
    end;

    /// <summary>
    /// ChangeLevel.
    /// </summary>
    /// <param name="Direction_P">Integer.</param>
    procedure ChangeLevel(Direction_P: Integer)
    var
        PlanDocLevel_LT: Record "BET FN Planning Document Level";
        PlanView_LT: Record "BET FN Planning View";
        PlanFunctions_LC: Codeunit "BET FN Planning Functions";
    begin
        //### Wechseln der Ebene
        if PlanFunctions_LC.ChangeLevel(Direction_P, Rec, PlanView_LT, PlanDoc_GT,
                                        IndexFilterArray_G[1], IndexFilterArray_G[2], IndexFilterArray_G[3],
                                        IndexFilterArray_G[4], IndexFilterArray_G[5], IndexFilterArray_G[6],
                                        DateFilterActivated_G, DateFilter_G, QuickAccess_G) then begin
            PlanDocLevel_LT.Get(PlanView_LT."Planning Document No.", PlanView_LT."Planning Document Level");
            UpdateLayout(PlanDocLevel_LT);
            GetIndexText();
            SetfilterValues();
            UpdateFiltertext();
            UpdateLeveltext();
            ShowDateColumns();
            SetLevelButtons();

            //### autom. Aktualisieren der veralteten Datensätze
            UpdateLines();

            case Direction_P of
                -1:
                    PlanDocFilterMgt_GC.SetViewEntryNoToStack(Rec."View Entry No.");    // urspr. Zeile merken...     
                1:
                    Rec.Get(PlanDocFilterMgt_GC.GetViewEntryNoFromStack());
            end;

            PlanViewFilter_GT.Reset();
            Rec.FilterGroup(2);
            PlanViewFilter_GT.CopyFilters(Rec);
            Rec.FilterGroup(0);
        end;
    end;

    /// <summary>
    /// LockFilters.
    /// </summary>
    procedure LockFilters()
    var
        Int_L: Integer;
        Text_L: Text[30];
    begin
        Evaluate(Text_L, Rec.GetFilter("Planning Document No."));
        Rec.FilterGroup(2);
        Rec.SetRange("Planning Document No.", Text_L);
        Rec.FilterGroup(0);
        Rec.SetRange("Planning Document No.");

        Evaluate(Int_L, Rec.GetFilter("Planning Document Level"));
        Rec.FilterGroup(2);
        Rec.SetRange("Planning Document Level", Int_L);
        Rec.FilterGroup(0);
        Rec.SetRange("Planning Document Level");
    end;

    /// <summary>
    /// CheckLevelExist.
    /// </summary>
    /// <param name="Direction_P">Integer.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure CheckLevelExist(Direction_P: Integer): Boolean
    var
        PlanDocMgt_LC: Codeunit "BET FN Planning Document Mgt";
    begin
        exit(PlanDocMgt_LC.CheckLevelExist(Rec, Direction_P));
    end;

    /// <summary>
    /// SetfilterValues.
    /// </summary>
    procedure SetfilterValues()
    begin
#pragma warning disable AA0139
        PlanDocFilterMgt_GC.SetFilterValues(IndexFilterArray_G,
                                             DateFilterActivated_G,
                                            DateFilter_G,
                                             QuickAccess_G);
#pragma warning restore AA0139
    end;

    /// <summary>
    /// GetfilterValues.
    /// </summary>
    procedure GetfilterValues()
    var
        PlanFunctions_LC: Codeunit "BET FN Planning Functions";
    begin
        //### globale Filter ermitteln und anwenden:
#pragma warning disable AA0139
        PlanDocFilterMgt_GC.GetFilterValues(IndexFilterArray_G,
                                             DateFilterActivated_G,
                                            DateFilter_G,
                                             QuickAccess_G);
#pragma warning restore AA0139
        PlanFunctions_LC.SetCurrentFiltersToRec(Rec, IndexFilterArray_G, DateFilterActivated_G, DateFilter_G);
    end;

    /// <summary>
    /// EditFilters.
    /// </summary>
    procedure EditFilters()
    begin
        Rec.FilterGroup(2);
        SetfilterValues();
        if Page.RunModal(Page::"BET FN Planning View Filters", Rec) = Action::LookupOK then begin
            GetfilterValues();
            GetIndexText();
            UpdateFiltertext();
            UpdateLeveltext();
            UpdateLines();
            ShowDateColumns();
            CurrPage.Update(false);
        end;
        Rec.FilterGroup(0);

        //### noch Buttons aktualisieren, wenn Datumsebene aktiviert ist: auch auf Datum prüfen!!
        SetLevelButtons();
    end;

    /// <summary>
    /// QuickAccessFilter.
    /// </summary>
    /// <param name="Direction_P">Integer.</param>
    procedure QuickAccessFilter(Direction_P: Integer)
    var
        PlanFunctions_LC: Codeunit "BET FN Planning Functions";
    begin
        if PlanFunctions_LC.SetQuickAccessFilter(Rec, QuickAccess_G, Direction_P, IndexFilterArray_G, DateFilter_G) then begin
            Rec.FilterGroup(2);
            SetfilterValues();
            GetfilterValues();
            GetIndexText();
            UpdateFiltertext();
            UpdateLeveltext();
            UpdateLines();
            Rec.FindFirst();
            CurrPage.Update(false);
            Rec.FilterGroup(0);
        end;
    end;

    /// <summary>
    /// CalcTopDown.
    /// </summary>
    procedure CalcTopDown()
    var
        PlanView_LT: Record "BET FN Planning View";
        CalcTopDown_LC: Codeunit "BET FN Calculate Top Down";
        ConfirmManagement: Codeunit "Confirm Management";
        CalculateTopDownQst: Label 'Calculate top-down?';
    begin
        if ConfirmManagement.GetResponse(CalculateTopDownQst, true) then begin
            PlanView_LT.Reset();
            PlanView_LT.SetRange("Planning Document No.", Rec."Planning Document No.");
            PlanView_LT.SetRange("Planning Document Level", Rec."Planning Document Level");
            PlanView_LT.SetFilter("Index 1", IndexFilterArray_G[1]);
            PlanView_LT.SetFilter("Index 2", IndexFilterArray_G[2]);
            PlanView_LT.SetFilter("Index 3", IndexFilterArray_G[3]);
            PlanView_LT.SetFilter("Index 4", IndexFilterArray_G[4]);
            PlanView_LT.SetFilter("Index 5", IndexFilterArray_G[5]);
            PlanView_LT.SetFilter("Index 6", IndexFilterArray_G[6]);
            if DateFilterActivated_G then
                PlanView_LT.SetFilter(Date, '<>%1', 0D)
            else
                PlanView_LT.SetRange(Date, 0D);
            CalcTopDown_LC.CalcTopDown(PlanView_LT);
            UpdateDistributionType();
        end;
    end;

    /// <summary>
    /// CalculateSummary.
    /// </summary>
    /// <param name="PlanView_PT">Record "BET FN Planning View".</param>
    procedure CalculateSummary(PlanView_PT: Record "BET FN Planning View")
    var
        TempPlanView_LTT: Record "BET FN Planning View" temporary;
        RefValueMgt_LC: Codeunit "BET FN Reference Value Mgt";
    begin
        //### Summenzeilen berechnen und in temp. Tabelle speichern:
        RefValueMgt_LC.CalculateTotalView(PlanDoc_GT, TempPlanView_LTT, PlanView_PT, IndexFilterArray_G[1], IndexFilterArray_G[2], IndexFilterArray_G[3],
                                          IndexFilterArray_G[4], IndexFilterArray_G[5], IndexFilterArray_G[6], DateFilter_G, DateFilterActivated_G);

        //### temp. Tab. an Subform übertragen:
        CurrPage.TotalSubform.Page.SetTempTable(TempPlanView_LTT);
    end;

    /// <summary>
    /// UpdateLines.
    /// </summary>
    procedure UpdateLines()
    var
        PlanView_LT: Record "BET FN Planning View";
        PlanDocMgmt_LC: Codeunit "BET FN Planning Document Mgt";
    begin
        PlanView_LT.Reset();
        Rec.FilterGroup(2);
        PlanView_LT.CopyFilters(Rec);
        Rec.FilterGroup(0);
        PlanDocMgmt_LC.CheckViewDataValidity(PlanView_LT);
        PlanDocMgmt_LC.UpdateViewData(PlanView_LT);
    end;

    /// <summary>
    /// SetLevelButtons.
    /// </summary>
    procedure SetLevelButtons()
    var
        DateStatusOK_L: Boolean;
    begin
        //### Ebenen-Buttons aktualisieren

        //### wenn Datumsebene angezeigt wird, dann nur Button anzeigen, wenn keine automatische Filterung an ist:
        DateStatusOK_L := true;
        if PlanDoc_GT."Auto Filter On Level Changing" and DateFilterActivated_G then
            DateStatusOK_L := false;

        //### gibt es eine Ebene weiter unten
        if not CheckLevelExist(-1) then
            LevelDownEnable_G := false
        else
            if DateStatusOK_L then
                LevelDownEnable_G := true
            else
                LevelDownEnable_G := false;

        //### gibt es eine Ebene weiter oben:
        if not CheckLevelExist(1) then
            LevelUpEnable_G := false
        else
            if DateStatusOK_L then
                LevelUpEnable_G := true
            else
                LevelUpEnable_G := false;
    end;

    /// <summary>
    /// GetReferenceValues.
    /// </summary>
    procedure GetReferenceValues()
    var
        PlanDoc_LT: Record "BET FN Planning Document";
        CalcRefValue_LC: Codeunit "BET FN Reference Value Mgt";
        ConfirmManagement: Codeunit "Confirm Management";
        CalculateReferenceValuesQst: Label 'Calculate reference values?';
        DocumentAlreadyReleasedErr: Label 'Document is already released';
    begin
        if PlanDoc_LT.Get(Rec."Planning Document No.") then
            if PlanDoc_LT.Status <> PlanDoc_LT.Status::Open then
                Error(DocumentAlreadyReleasedErr)
            else
                if ConfirmManagement.GetResponse(CalculateReferenceValuesQst, false) then
                    CalcRefValue_LC.CalcReferenceValueCube(PlanDoc_LT);
    end;

    /// <summary>
    /// SetRefCaptions.
    /// </summary>
    procedure SetRefCaptions()
    var
        PlanFunctions_LC: Codeunit "BET FN Planning Functions";
    begin
        PlanFunctions_LC.InitCaptionArrayRefValues(CaptionArray_G, PlanDoc_GT);
    end;

    /// <summary>
    /// ImportPlanningValues.
    /// </summary>
    procedure ImportPlanningValues()
    var
        ConfirmManagement: Codeunit "Confirm Management";
        ImportPlanningValuesQst: Label 'Import planning values ?\\ATTENTION: current planning values will be overwritten.';
    begin
        if not ConfirmManagement.GetResponse(ImportPlanningValuesQst, false) then
            exit;

        //### hier Importfunktion aufrufen:

        UpdateLines();
        CurrPage.Update();
    end;

    /// <summary>
    /// ChangeDateLevel.
    /// </summary>
    procedure ChangeDateLevel()
    var
        PlanDocLevel_LT: Record "BET FN Planning Document Level";
        DateLevelNotFoundMsg: Label 'Date level not found in this document.';
    begin
        //### wenn im Beleg keine Datumsebene verwendet wird, dann abbrechen:
        PlanDocLevel_LT.Reset();
        PlanDocLevel_LT.SetRange("Planning Document No.", PlanDoc_GT."No.");
        PlanDocLevel_LT.SetRange("Activate Date Level", true);
        if PlanDocLevel_LT.IsEmpty() then begin
            Message(DateLevelNotFoundMsg);
            exit;
        end;

        DateFilterActivated_G := not DateFilterActivated_G;

        ShowDateColumns();

        //### beim runternavigieren filtern auf den akt. Index
        if PlanDoc_GT."Auto Filter On Level Changing" then begin
            if DateFilterActivated_G then begin
                IndexFilterArray_G[1] := Rec."Index 1";
                IndexFilterArray_G[2] := Rec."Index 2";
                IndexFilterArray_G[3] := Rec."Index 3";
                IndexFilterArray_G[4] := Rec."Index 4";
                IndexFilterArray_G[5] := Rec."Index 5";
                IndexFilterArray_G[6] := Rec."Index 6";
            end else
                case Rec."Planning Document Level" of
                    1:
                        Clear(IndexFilterArray_G[1]);
                    2:
                        Clear(IndexFilterArray_G[2]);
                    3:
                        Clear(IndexFilterArray_G[3]);
                    4:
                        Clear(IndexFilterArray_G[4]);
                    5:
                        Clear(IndexFilterArray_G[5]);
                    6:
                        Clear(IndexFilterArray_G[6]);
                end;
        end else
            //### bei normaler Navigation mit filtern --> Datumsfilter und Schnellzugriff auf Datum wieder aufheben
            if not DateFilterActivated_G then begin
                DateFilter_G := '';
                if QuickAccess_G = QuickAccess_G::Date then
                    QuickAccess_G := QuickAccess_G::" ";
            end;

        SetfilterValues();
        GetfilterValues();
        GetIndexText();
        UpdateFiltertext();
        UpdateLeveltext();
        UpdateLines();

        SetLevelButtons();

        case DateFilterActivated_G of
            true:
                PlanDocFilterMgt_GC.SetViewEntryNoToStack(Rec."View Entry No.");    //### urspr. Zeile merken...     
            false:
                Rec.Get(PlanDocFilterMgt_GC.GetViewEntryNoFromStack());             //### ... und beim Wechsel nach oben wieder dahin zurück springen
        end;

        CurrPage.Update(false);

        if PlanDoc_GT."Auto Filter On Level Changing" then begin
            PlanViewFilter_GT.Reset();
            Rec.FilterGroup(2);
            PlanViewFilter_GT.CopyFilters(Rec);
            Rec.FilterGroup(0);
        end;
    end;

    /// <summary>
    /// ChangeLayout.
    /// </summary>
    procedure ChangeLayout()
    var
        PlanDocLevel_LT: Record "BET FN Planning Document Level";
        PlanDocLevelLayout_LP: Page "BET FN Plan Doc Lvl Layout";
        DocNo_L: Code[20];
        Vert_L: Integer;
    begin
        Rec.FilterGroup(2);
        Evaluate(DocNo_L, Rec.GetFilter("Planning Document No."));
        Evaluate(Vert_L, Rec.GetFilter("Planning Document Level"));
        Rec.FilterGroup(0);

        if PlanDocLevel_LT.Get(DocNo_L, Vert_L) then begin
            PlanDocLevelLayout_LP.SetDocumentNo(DocNo_L);
            PlanDocLevelLayout_LP.RunModal();

            PlanDocLevel_LT.Get(DocNo_L, Vert_L);
            UpdateLayout(PlanDocLevel_LT);

            CurrPage.Update(false);
        end;
    end;

    /// <summary>
    /// UpdateLineColour.
    /// </summary>
    procedure UpdateLineColour()
    begin
        //### Umschalten zwischen rot und blau, wenn Zeile geändert wurde:
        if Rec.Changed then
            LineChangedStyle_G := 'Attention'
        else
            LineChangedStyle_G := 'StandardAccent';
    end;

    /// <summary>
    /// ShowDateColumns.
    /// </summary>
    procedure ShowDateColumns()
    begin
        //### entweder normales Datum oder alternativen Datumstext anzeigen:
        if DateFilterActivated_G then begin
            ShowDateDescription_G := PlanDoc_GT."Show Date Description";
            ShowDate_G := not PlanDoc_GT."Show Date Description";
        end else begin
            ShowDateDescription_G := false;
            ShowDate_G := false;
        end;
    end;

    /// <summary>
    /// SetLineFixed.
    /// </summary>
    procedure SetLineFixed()
    var
        PLFunctions_LC: Codeunit "BET FN Planning Functions";
    begin
        //### Fixierung einzelner Zeilen
        PLFunctions_LC.SetLinesFixed(Rec);
        CurrPage.Update(false);
    end;

    /// <summary>
    /// CopyPlanningValuesWithinDocument.
    /// </summary>
    procedure CopyPlanningValuesWithinDocument()
    var
        TempPlanBuffer_LTT: Record "BET FN Planning Doc Lvl Buf" temporary;
        PlanDocLevel_LT: Record "BET FN Planning Document Level";
        PLFunctions_LC: Codeunit "BET FN Planning Functions";
        ConfirmManagement: Codeunit "Confirm Management";
        IndexCode_L: Code[20];
        CannotCopyValuesErr: Label 'Can not copy values at this planning level.';
        CopyPlanningValuesQst: Label 'Copy planning values?';
    begin
        //### Kopieren von Planwerten innerhalb des Belegs (z.B. Filiale A auf Filiale B)
        if not ConfirmManagement.GetResponse(CopyPlanningValuesQst, false) then
            exit;

        //### temp. Buffertabelle für Auswahl:
        PLFunctions_LC.CreateTempBufferSelection(Rec, TempPlanBuffer_LTT);


        //### Gesamtebene oder nur 1 Bufferzeile --> Kopieren nicht möglich
        if TempPlanBuffer_LTT.Count() < 1 then
            Error(CannotCopyValuesErr);

        case Rec."Planning Document Level" of
            1:
                IndexCode_L := Rec."Index 1";
            2:
                IndexCode_L := Rec."Index 2";
            3:
                IndexCode_L := Rec."Index 3";
            4:
                IndexCode_L := Rec."Index 4";
            5:
                IndexCode_L := Rec."Index 5";
            6:
                IndexCode_L := Rec."Index 6";
        end;

        if Page.RunModal(Page::"BET FN Planning Buffer Selctn", TempPlanBuffer_LTT) = Action::LookupOK then begin
            PlanDocLevel_LT.Get(Rec."Planning Document No.", Rec."Planning Document Level");
            if not ConfirmManagement.GetResponse(CopyPlanningValuesQst, false) then
                exit;

            PLFunctions_LC.CopyPlanningValuesWithinDocument(Rec."Planning Document No.", Rec."Planning Document Level",
                                                            IndexCode_L, TempPlanBuffer_LTT."Index Code", Rec);
            UpdateLines();
            CurrPage.Update();
        end;
    end;

    /// <summary>
    /// UpdateDistributionType.
    /// </summary>
    procedure UpdateDistributionType()
    var
        PlanDoc_LT: Record "BET FN Planning Document";
    begin
        Rec.FilterGroup(2);
        PlanDoc_LT.Get(Rec.GetFilter("Planning Document No."));
        DistributionType_G := PlanDoc_LT."Distribution Type";
        Rec.FilterGroup(0);
        PlanDoc_GT := PlanDoc_LT;
    end;

    /// <summary>
    /// SetDefaultSorting.
    /// </summary>
    procedure SetDefaultSorting()
    begin
        Rec.SetCurrentKey("Planning Document No.", "Planning Document Level", "Index 1", "Index 2", "Index 3", "Index 4", "Index 5", "Index 6", Date);
        Rec.Ascending(true);
        CurrPage.Update(false);
    end;
}

