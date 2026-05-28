import { planningObjects } from "@/lib/planning-data";
import { applyComparisonDataToPlan } from "@/lib/comparison-import";
import type {
  PlanningObject,
  PlanningStatus,
} from "@/types/planning";

export type IntegrationErrorCode =
  | "NOT_FOUND"
  | "INVALID_STATUS"
  | "READ_ONLY"
  | "INVALID_TRANSITION";

export type IntegrationResult<T> =
  | { ok: true; data: T }
  | { ok: false; error: { code: IntegrationErrorCode; message: string } };

export interface PlanPolicyPort {
  isPlanReadOnly(plan: PlanningObject): boolean;
  canTransitionStatus(current: PlanningStatus, next: PlanningStatus): boolean;
  canExportPlan(plan: PlanningObject): IntegrationResult<PlanningObject>;
}

export interface ComparisonDataPort {
  findComparisonSourcePlanResult(
    allPlans: PlanningObject[],
    comparisonYear: string,
    targetPlanId: string,
  ): IntegrationResult<PlanningObject>;
  applyComparisonDataResult(
    targetPlan: PlanningObject,
    sourcePlan: PlanningObject,
  ): IntegrationResult<PlanningObject>;
}

export interface PlanIntegrationPort {
  policy: PlanPolicyPort;
  comparison: ComparisonDataPort;
}

export const localPlanIntegration: PlanIntegrationPort = {
  policy: {
    isPlanReadOnly: (plan) => plan.document.status === "Approved",
    canTransitionStatus: (current, next) => {
      if (current === next) return true;
      if (current === "Draft") return next === "InReview";
      if (current === "InReview") return next === "Draft" || next === "Approved";
      if (current === "Approved") return next === "Draft";
      return false;
    },
    canExportPlan: (plan) => {
      if (plan.document.status !== "Approved") {
        return {
          ok: false,
          error: {
            code: "INVALID_STATUS",
            message: "Export ist nur für freigegebene Pläne erlaubt.",
          },
        };
      }
      return { ok: true, data: plan };
    },
  },
  comparison: {
    findComparisonSourcePlanResult: (allPlans, comparisonYear, targetPlanId) => {
      const fromStore = allPlans.find(
        (plan) =>
          plan.document.planId !== targetPlanId &&
          plan.document.fiscalYear === comparisonYear,
      );
      if (fromStore) return { ok: true, data: fromStore };
      const fallback = planningObjects.find(
        (plan) => plan.document.fiscalYear === comparisonYear,
      );
      if (!fallback) {
        return {
          ok: false,
          error: {
            code: "NOT_FOUND",
            message: "Keine Vergleichsdaten für das angegebene Jahr gefunden.",
          },
        };
      }
      return { ok: true, data: fallback };
    },
    applyComparisonDataResult: (targetPlan, sourcePlan) => ({
      ok: true,
      data: applyComparisonDataToPlan(targetPlan, sourcePlan),
    }),
  },
};
