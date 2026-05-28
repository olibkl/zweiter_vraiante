/// <summary>
/// [scenario]
/// Modules: 
/// </summary>
page 5138654 "BET FN Scenario"
{
    ApplicationArea = All;
    Caption = 'Scenario';
    PageType = Card;
    SourceTable = "BET FN Scenario";
    UsageCategory = Tasks;
    Extensible = true;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("Code"; Rec.Code)
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Start Date"; Rec."Start Date")
                {
                }
                field("End Date"; Rec."End Date")
                {
                }
                field("Opening Stock"; Rec."Opening Stock")
                {
                    DecimalPlaces = 0 : 0;
                }
                field("Real. Sal. Am. per Year"; Rec."Real. Sal. Am. per Year")
                {
                    DecimalPlaces = 0 : 0;
                }
                field(Deduction; Rec.Deduction)
                {
                    DecimalPlaces = 0 : 0;
                }
                field(Discount; Rec.Discount)
                {
                    DecimalPlaces = 0 : 0;
                }
                field("Purchase Value Gross"; Rec."Purchase Value Gross")
                {
                    DecimalPlaces = 0 : 0;
                    Editable = false;
                }
                field("Closing Stock"; Rec."Closing Stock")
                {
                    DecimalPlaces = 0 : 0;
                }
                field(Active; Rec.Active)
                {
                    Editable = false;
                }
                field("Closing Stock Rate"; Rec."Closing Stock Rate")
                {
                }
                field("Calculation (act.)"; Rec."Calculation (act.)")
                {
                    Caption = 'Kalkulation (WE)';
                }
                field(Fluctuation; Rec.Fluctuation)
                {
                }
                field("Purch. Val. in Purch. Order %"; Rec."Purch. Val. in Purch. Order %")
                {
                }
                field("VAT %"; Rec."VAT %")
                {
                }
            }
            group(Dimensions)
            {
                Caption = 'Dimensions';
                part(Subform1; "BET FN Scenario Dimension")
                {
                    SubPageLink = "Scenario Code" = field(Code);
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group("F&unctions")
            {
                Caption = 'Functions';
                action(CreateStatistic)
                {
                    Caption = 'Create Statistic Entries';
                    ToolTip = 'Create Statistic Entries';
                    Image = Statistics;

                    trigger OnAction()
                    begin
                        CreateStatisticEntries();
                    end;
                }
                action(CreatePurchStatistic)
                {
                    Caption = 'Create Purchase Entries';
                    ToolTip = 'Create Purchase Entries';
                    Image = Purchase;

                    trigger OnAction()
                    begin
                        CreateOrderEntries();
                    end;
                }
                separator(Action1117300015)
                {
                }
                action(CopyScenarioAction)
                {
                    Caption = 'Copy scenario';
                    ToolTip = 'Copy scenario';
                    Image = CopyDocument;

                    trigger OnAction()
                    begin
                        CopyScenario();
                    end;
                }
            }
        }
    }

    procedure CreateStatisticEntries()
    var
        ScenarioMgmt_LC: Codeunit "BET FN Scenario Mgt";
    begin
        ScenarioMgmt_LC.CreateFashionStatisticEntries(Rec.Code);
    end;

    procedure CreateOrderEntries()
    var
        ScenarioMgmt_LC: Codeunit "BET FN Scenario Mgt";
    begin
        ScenarioMgmt_LC.CreatePurchaseStatisticEntries(Rec.Code);
    end;

    procedure CopyScenario()
    var
        ScenarioMgmt_LC: Codeunit "BET FN Scenario Mgt";
    begin
        ScenarioMgmt_LC.CopyScenario(Rec.Code);
    end;
}

