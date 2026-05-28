// Dataverse-ready DTO mapping skeleton.
// Keeps transport contract explicit and versioned for later table mapping.

export const PLAN_CONTRACT_VERSION = "1.0.0";

export const toDataverseEnvelope = (plan, version) => ({
  contractVersion: PLAN_CONTRACT_VERSION,
  version,
  planHeader: {
    planId: plan.document.planId,
    planName: plan.document.planName,
    planningType: plan.document.planningType,
    status: plan.document.status,
    fiscalYear: plan.document.fiscalYear,
    comparisonYear: plan.document.comparisonYear,
    lastModified: plan.document.lastModified,
  },
  aggregateTotal: plan.aggregateTotal ?? null,
  nodes: plan.data,
});

