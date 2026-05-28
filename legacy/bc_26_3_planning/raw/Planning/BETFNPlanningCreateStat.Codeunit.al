/// <summary>
/// Codeunit BET FN Planning Create Stat. (ID 5079352).
/// </summary>
codeunit 5079352 "BET FN Planning Create Stat."
{
    Access = Public;

    trigger OnRun()
    begin
        CreateStatistics(false);
    end;


    /// <summary>
    /// CreateStatistics.
    /// </summary>
    /// <param name="ShowDialog">Boolean.</param>
    procedure CreateStatistics(ShowDialog: Boolean)
    var
        BETFNPlanningSetup: Record "BET FN Planning Setup";
        ConfirmManagement: Codeunit "Confirm Management";
        IsHandled: Boolean;
        ConfirmLbl: Label 'Update planning statistic?';
    begin
        IsHandled := false;
        OnBeforeCreateStatistics(IsHandled);
        if not IsHandled then begin

            if ShowDialog then
                if not ConfirmManagement.GetResponse(ConfirmLbl, false) then
                    exit;

            BETFNPlanningSetup.Reset();
            BETFNPlanningSetup.FindSet(true);

            if BETFNPlanningSetup."Create Statistic Entries" then
                CreateStatisticEntries();

            if BETFNPlanningSetup."Create Purchase Statistic" then
                CreatePurchaseStatistic();

            BETFNPlanningSetup."Last Update FSE" := Today();
            BETFNPlanningSetup.Modify();
        end;
    end;

    local procedure CreateStatisticEntries()
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeCreateStatisticEntries(IsHandled);
        if IsHandled then
            exit;
    end;

    local procedure CreatePurchaseStatistic()
    var
        IsHandled: Boolean;
    begin
        OnBeforeCreatePurchaseStatistic(IsHandled);
        if IsHandled then
            exit;
    end;


    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateStatistics(var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateStatisticEntries(var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreatePurchaseStatistic(var IsHandled: Boolean)
    begin
    end;
}
