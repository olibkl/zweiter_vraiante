/// <summary>
/// [planning]
/// Modules: 
/// </summary>
report 5138634 "BET FN Planning Fin Yr 12 Mths"
{
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = 'layout/PlanningFinYear12Months.rdlc';
    Caption = 'Planning Fin. Year 12 Monaths';
    Extensible = true;

    dataset
    {
        dataitem(LevelBuffer1; "BET FN Planning Doc Lvl Buf")
        {
            dataitem(LevelBuffer2; "BET FN Planning Doc Lvl Buf")
            {
                column(ReportCaption; ReportCaption_G)
                {
                }
                column(CompanyName; CompanyName())
                {
                }
                column(DocumentNo; CompanyDocNo_G)
                {
                }
                column(FinancialYear; FinancialYear_G)
                {
                }
                column(IndexCode1; LevelBuffer1."Index Code")
                {
                }
                column(IndexCode2; LevelBuffer2."Index Code")
                {
                }
                column(IndexDescription1; LevelBuffer1."Index Description")
                {
                }
                column(IndexDescription2; LevelBuffer2."Index Description")
                {
                }
                column(PlanSalesAmount_01; SalesAmountArray_G[1])
                {
                }
                column(PlanSalesAmount_02; SalesAmountArray_G[2])
                {
                }
                column(PlanSalesAmount_03; SalesAmountArray_G[3])
                {
                }
                column(PlanSalesAmount_04; SalesAmountArray_G[4])
                {
                }
                column(PlanSalesAmount_05; SalesAmountArray_G[5])
                {
                }
                column(PlanSalesAmount_06; SalesAmountArray_G[6])
                {
                }
                column(PlanSalesAmount_07; SalesAmountArray_G[7])
                {
                }
                column(PlanSalesAmount_08; SalesAmountArray_G[8])
                {
                }
                column(PlanSalesAmount_09; SalesAmountArray_G[9])
                {
                }
                column(PlanSalesAmount_10; SalesAmountArray_G[10])
                {
                }
                column(PlanSalesAmount_11; SalesAmountArray_G[11])
                {
                }
                column(PlanSalesAmount_12; SalesAmountArray_G[12])
                {
                }
                column(PlanSalesAmount_Total; SalesAmountArray_G[13])
                {
                }

                trigger OnAfterGetRecord()
                var
                    PlanCube_LT: Record "BET FN Planning Value Cube";
                begin
                    //### Prüfen, ob Kombination existiert:
                    PlanCube_LT.Reset();
                    PlanCube_LT.SetRange("Planning Document No.", CompanyDocNo_G);
                    PlanCube_LT.SetRange("Index 1", LevelBuffer1."Index Code");
                    PlanCube_LT.SetRange("Index 2", LevelBuffer2."Index Code");
                    if PlanCube_LT.IsEmpty() then
                        CurrReport.Skip();

                    CalcAmounts();
                end;

                trigger OnPreDataItem()
                begin
                    LevelBuffer2.SetRange("Planning Document No.", CompanyDocNo_G);
                    LevelBuffer2.SetRange("Planning Document Level", 2);
                    LevelBuffer2.SetRange(Active, true);
                end;
            }

            trigger OnPreDataItem()
            begin
                LevelBuffer1.SetRange("Planning Document No.", CompanyDocNo_G);
                LevelBuffer1.SetRange("Planning Document Level", 1);
                LevelBuffer1.SetRange(Active, true);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(Content)
            {
                field(CompanyDocNo; CompanyDocNo_G)
                {
                    ApplicationArea = All;
                    Caption = 'Company Plan';
                    TableRelation = "BET FN Planning Document";
                    Visible = false;
                    ToolTip = 'Specifies the Company Plan.';

                    trigger OnValidate()
                    var
                        PlanDoc_LT: Record "BET FN Planning Document";
                    begin
                        PlanDoc_LT.Get(CompanyDocNo_G);
                        FinancialYear_G := PlanDoc_LT."Financial Year";
                    end;
                }
                field(FinancialYear; FinancialYear_G)
                {
                    ApplicationArea = All;
                    Caption = 'Financial Year';
                    ToolTip = 'Specifies the Financial Year.';
                    TableRelation = "BET FN Financial Year";
                    Visible = false;
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        FinancialYear_G: Code[10];
        CompanyDocNo_G: Code[20];
        SalesAmountArray_G: array[20] of Decimal;
        ReportCaption_G: Text;

    /// <summary>
    /// CalcAmounts.
    /// </summary>
    procedure CalcAmounts()
    var
        DateRef_LT: Record "BET FN Planning Document D Ref";
        PlanCube_LT: Record "BET FN Planning Value Cube";
        i_L: Integer;
    begin
        //### GL-Planung aus ausgewähltem Beleg holen:

        Clear(SalesAmountArray_G);

        DateRef_LT.Reset();
        DateRef_LT.SetRange("Planning Document No.", CompanyDocNo_G);
        if DateRef_LT.FindSet() then begin
            PlanCube_LT.Reset();
            PlanCube_LT.SetRange("Planning Document No.", CompanyDocNo_G);
            PlanCube_LT.SetRange("Index 1", LevelBuffer1."Index Code");
            PlanCube_LT.SetRange("Index 2", LevelBuffer2."Index Code");
            i_L := 0;
            repeat
                i_L += 1;
                PlanCube_LT.SetRange(Date, DateRef_LT.Date);
                PlanCube_LT.CalcSums("Plan Sales Amount");

                SalesAmountArray_G[i_L] := PlanCube_LT."Plan Sales Amount";
                SalesAmountArray_G[13] += PlanCube_LT."Plan Sales Amount";
            until DateRef_LT.Next() = 0;
        end;
    end;

    /// <summary>
    /// SetDocumentNo.
    /// </summary>
    /// <param name="DocNo_P">Code[20].</param>
    procedure SetDocumentNo(DocNo_P: Code[20])
    var
        PlanDoc_LT: Record "BET FN Planning Document";
        PlanType_LT: Record "BET FN Planning Type";
        ReportAvailForGlPlanningErr: Label 'Report only available for GL planning.';
    begin
        PlanDoc_LT.Get(DocNo_P);
        PlanType_LT.Get(PlanDoc_LT."Planning Type");
#pragma warning disable AL0432
        if PlanType_LT."Company Plan" then begin
#pragma warning restore AL0432
            CompanyDocNo_G := PlanDoc_LT."No.";
            FinancialYear_G := PlanDoc_LT."Financial Year";
            ReportCaption_G := 'Geschäftsjahresplanung - ' + FinancialYear_G;
        end else
            Error(ReportAvailForGlPlanningErr);
    end;
}

