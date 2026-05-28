import { create } from "zustand";
import { persist } from "zustand/middleware";
import { planningObjects } from "@/lib/planning-data";
import { localPlanIntegration } from "@/lib/integration/plan-integration";
import type { IntegrationResult } from "@/lib/integration/plan-integration";
import {
  completePlanningPeriod,
  fitPlanningObjectToPeriod,
  type PlanningPeriodDraft,
} from "@/lib/planning-period";
import {
  buildPlanningDocumentRuntime,
  distributePlanningObjectTopDown,
} from "@/lib/planning-document";
import {
  filterNodesByHierarchies,
  recalculateAggregateTotalFromTree,
  recalculatePlanningTree,
} from "@/lib/planning-calculation";
import {
  isApiModeEnabled,
  loadPlanFromApi,
  savePlanToApi,
} from "@/lib/api/plan-api";
import type {
  PlanningDistributionType,
  PlanningNode,
  PlanningObject,
  PlanningStatus,
  PlanningType,
  SelectedHierarchy,
} from "@/types/planning";

export type PlanStatus = "Idle" | PlanningStatus;

interface PlanStoreState {
  planId: string | null;
  planName: string | null;
  timeframe: string | null;
  selectedKPIs: string[];
  status: PlanStatus;
  data: PlanningNode[];
  allPlans: PlanningObject[];
  setPlanSetup: (payload: {
    planId: string;
    name: string;
    description: string;
    fiscalYear: string;
    comparisonYear: string;
    planningPeriod: PlanningPeriodDraft;
    referencePeriod: PlanningPeriodDraft;
    kpis: string[];
    hierarchies?: SelectedHierarchy[];
  }) => string;
  setActivePlan: (planId: string) => void;
  updateNodeMonthlyPlanValue: (
    planId: string,
    nodeId: string,
    date: string,
    planSalesAmount: number,
    skipApiSync?: boolean,
  ) => IntegrationResult<void>;
  updateNodeBatchMonthlyPlanValues: (
    planId: string,
    nodeId: string,
    updates: Array<{ date: string; planSalesAmount: number }>,
    skipApiSync?: boolean,
  ) => IntegrationResult<void>;
  commitPlanToApi: (planId: string) => Promise<IntegrationResult<void>>;
  refreshPlanFromApi: (planId: string) => Promise<IntegrationResult<void>>;
  resetStore: () => void;
  deletePlan: (planId: string) => void;
  updatePlanMetadata: (
    planId: string,
    payload: { planName: string; description: string; comparisonYear: string },
  ) => IntegrationResult<void>;
  restorePlanSnapshot: (planId: string, snapshot: PlanningObject) => IntegrationResult<void>;
  setPlanStatus: (
    planId: string,
    status: PlanningStatus,
  ) => IntegrationResult<void>;
  createPlanningDocument: (planId: string) => IntegrationResult<void>;
  releasePlanningDocument: (planId: string) => IntegrationResult<void>;
  reopenPlanningDocument: (planId: string) => IntegrationResult<void>;
  exportApprovedPlan: (planId: string) => IntegrationResult<PlanningObject>;
  importComparisonData: (
    planId: string,
    comparisonYear: string,
  ) => IntegrationResult<void>;
  distributeTopDown: (
    planId: string,
    nodeId: string,
    distributionType: PlanningDistributionType,
  ) => IntegrationResult<void>;
}

const updateMonthlyValueInTree = (
  nodes: PlanningNode[],
  nodeId: string,
  date: string,
  planSalesAmount: number,
): PlanningNode[] => {
  return nodes.map((node) => {
    if (node.id === nodeId) {
      const monthlyValues = node.monthlyValues.map((entry) =>
        entry.date === date ? { ...entry, planSalesAmount } : entry,
      );

      const nextPlanSalesAmount = monthlyValues.reduce(
        (sum, entry) => sum + entry.planSalesAmount,
        0,
      );

      return {
        ...node,
        metrics: {
          ...node.metrics,
          planSalesAmount: nextPlanSalesAmount,
        },
        monthlyValues,
      };
    }

    if (!node.children || node.children.length === 0) {
      return node;
    }

    return {
      ...node,
      children: updateMonthlyValueInTree(
        node.children,
        nodeId,
        date,
        planSalesAmount,
      ),
    };
  });
};

const updateBatchMonthlyValuesInTree = (
  nodes: PlanningNode[],
  nodeId: string,
  updates: Array<{ date: string; planSalesAmount: number }>,
): PlanningNode[] => {
  const updateMap = new Map(updates.map((u) => [u.date, u.planSalesAmount]));
  return nodes.map((node) => {
    if (node.id === nodeId) {
      const monthlyValues = node.monthlyValues.map((entry) => {
        const newAmount = updateMap.get(entry.date);
        return newAmount !== undefined
          ? { ...entry, planSalesAmount: newAmount }
          : entry;
      });
      const nextPlanSalesAmount = monthlyValues.reduce(
        (sum, entry) => sum + entry.planSalesAmount,
        0,
      );
      return {
        ...node,
        metrics: { ...node.metrics, planSalesAmount: nextPlanSalesAmount },
        monthlyValues,
      };
    }
    if (!node.children || node.children.length === 0) return node;
    return {
      ...node,
      children: updateBatchMonthlyValuesInTree(node.children, nodeId, updates),
    };
  });
};

// Mock seed for the future ERP/Dataverse-backed plan database.
const initialPlans = structuredClone(planningObjects);

const resolvePlanningType = (kpis: string[]): PlanningType => {
  if (kpis.includes("Menge")) {
    return "Anzahl";
  }

  return "Umsatz";
};

const planIntegration = localPlanIntegration;

const createActivePlanState = (plan: PlanningObject) => ({
  planId: plan.document.planId,
  planName: plan.document.planName,
  timeframe: null,
  selectedKPIs: [],
  status: plan.document.status,
  data: structuredClone(plan.data),
});

const findComparisonSourcePlan = (
  allPlans: PlanningObject[],
  comparisonYear: string,
  targetPlanId: string,
): PlanningObject | undefined => {
  const result = planIntegration.comparison.findComparisonSourcePlanResult(
    allPlans,
    comparisonYear,
    targetPlanId,
  );
  return result.ok ? result.data : undefined;
};

const initialState: Pick<
  PlanStoreState,
  | "planId"
  | "planName"
  | "timeframe"
  | "selectedKPIs"
  | "status"
  | "data"
  | "allPlans"
> = {
  planId: null,
  planName: null,
  timeframe: null,
  selectedKPIs: [],
  status: "Idle" as PlanStatus,
  data: [],
  allPlans: initialPlans,
};

const syncPlanToApi = (getState: () => PlanStoreState, planId: string) => {
  if (!isApiModeEnabled()) return;
  const plan = getState().allPlans.find((entry) => entry.document.planId === planId);
  if (!plan) return;
  void savePlanToApi(plan).catch((error) => {
    // eslint-disable-next-line no-console
    console.error("API sync failed", error);
  });
};

export const usePlanStore = create<PlanStoreState>()(
  persist(
    (set, get) => ({
      // Mock-only store seed for the future Dataverse-backed implementation.
      ...initialState,

      setPlanSetup: ({
        planId,
        name,
        description,
        fiscalYear,
        comparisonYear,
        planningPeriod,
        referencePeriod,
        kpis,
        hierarchies,
      }) => {
        set((state) => {
          const planningType = resolvePlanningType(kpis);
          const completePlanning = completePlanningPeriod(planningPeriod);
          const completeReference = completePlanningPeriod(referencePeriod);
          const planTemplate =
            planningObjects.find(
              (plan) => plan.document.fiscalYear === fiscalYear,
            ) ?? planningObjects[0];
          const periodData = fitPlanningObjectToPeriod(
            planTemplate,
            completePlanning,
          );
          const filteredData = filterNodesByHierarchies(
            structuredClone(periodData.data),
            hierarchies ?? [],
          );
          const recalculatedData = recalculatePlanningTree(filteredData);
          const recalculatedAggregateTotal = recalculateAggregateTotalFromTree(
            structuredClone(periodData.aggregateTotal),
            recalculatedData,
          );
          const newPlan: PlanningObject = {
            document: {
              planId,
              planName: name,
              planningType,
              description,
              fiscalYear,
              comparisonYear,
              planningPeriod: completePlanning,
              referencePeriod: completeReference,
              status: "Draft",
              selectedHierarchies: hierarchies ?? [],
              lastModified: new Date().toISOString(),
            },
            aggregateTotal: recalculatedAggregateTotal,
            // This node tree is currently mocked and will later be replaced by the ERP payload.
            data: recalculatedData,
          };
          const comparisonSource = findComparisonSourcePlan(
            state.allPlans,
            comparisonYear,
            planId,
          );
          const planWithComparison = (() => {
            if (!comparisonSource) return newPlan;
            const compareResult =
              planIntegration.comparison.applyComparisonDataResult(
                newPlan,
                comparisonSource,
              );
            return compareResult.ok ? compareResult.data : newPlan;
          })();

          return {
            allPlans: [...state.allPlans, planWithComparison],
            planId,
            planName: name,
            timeframe: fiscalYear,
            selectedKPIs: kpis,
            status: "Draft",
            data: structuredClone(planWithComparison.data),
          };
        });

        return planId;
      },

      setActivePlan: (planId) => {
        const activePlan = get().allPlans.find(
          (plan) => plan.document.planId === planId,
        );

        if (!activePlan) {
          return;
        }

        set({
          ...createActivePlanState(activePlan),
        });

        if (isApiModeEnabled()) {
          void loadPlanFromApi(planId)
            .then((apiPlan) => {
              set((state) => {
                const nextAllPlans = state.allPlans.map((plan) =>
                  plan.document.planId === planId ? apiPlan : plan,
                );
                return {
                  allPlans: nextAllPlans,
                  ...(state.planId === planId
                    ? createActivePlanState(apiPlan)
                    : {}),
                };
              });
            })
            .catch((error) => {
              // eslint-disable-next-line no-console
              console.error("API pull failed", error);
            });
        }
      },

      updateNodeMonthlyPlanValue: (planId, nodeId, date, planSalesAmount, skipApiSync = false) => {
        let hasPlan = false;
        let isReadOnly = false;
        set((state) => {
          const nextAllPlans = state.allPlans.map((plan) => {
            if (plan.document.planId !== planId) {
              return plan;
            }
            hasPlan = true;
            if (planIntegration.policy.isPlanReadOnly(plan)) {
              isReadOnly = true;
              return plan;
            }

            const nextData = updateMonthlyValueInTree(
              plan.data,
              nodeId,
              date,
              planSalesAmount,
            );
            const recalculatedData = recalculatePlanningTree(nextData);
            const nextAggregateTotal = recalculateAggregateTotalFromTree(
              plan.aggregateTotal,
              recalculatedData,
            );

            return {
              ...plan,
              document: {
                ...plan.document,
                lastModified: new Date().toISOString(),
              },
              data: recalculatedData,
              aggregateTotal: nextAggregateTotal,
            };
          });

          const nextState: Pick<PlanStoreState, "allPlans" | "data"> = {
            allPlans: nextAllPlans,
            data: state.data,
          };

          if (state.planId === planId) {
            const activePlan = nextAllPlans.find(
              (plan) => plan.document.planId === planId,
            );
            nextState.data = activePlan
              ? structuredClone(activePlan.data)
              : state.data;
          }

          return nextState;
        });
        if (!hasPlan) {
          return { ok: false, error: { code: "NOT_FOUND", message: "Plan wurde nicht gefunden." } };
        }
        if (isReadOnly) {
          return { ok: false, error: { code: "READ_ONLY", message: "Plan ist freigegeben und kann nicht bearbeitet werden." } };
        }
        if (!skipApiSync) {
          syncPlanToApi(get, planId);
        }
        return { ok: true, data: undefined };
      },

      updateNodeBatchMonthlyPlanValues: (planId, nodeId, updates, skipApiSync = false) => {
        let hasPlan = false;
        let isReadOnly = false;
        set((state) => {
          const nextAllPlans = state.allPlans.map((plan) => {
            if (plan.document.planId !== planId) {
              return plan;
            }
            hasPlan = true;
            if (planIntegration.policy.isPlanReadOnly(plan)) {
              isReadOnly = true;
              return plan;
            }

            const nextData = updateBatchMonthlyValuesInTree(
              plan.data,
              nodeId,
              updates,
            );
            const recalculatedData = recalculatePlanningTree(nextData);
            const nextAggregateTotal = recalculateAggregateTotalFromTree(
              plan.aggregateTotal,
              recalculatedData,
            );

            return {
              ...plan,
              document: {
                ...plan.document,
                lastModified: new Date().toISOString(),
              },
              data: recalculatedData,
              aggregateTotal: nextAggregateTotal,
            };
          });

          const nextState: Pick<PlanStoreState, "allPlans" | "data"> = {
            allPlans: nextAllPlans,
            data: state.data,
          };

          if (state.planId === planId) {
            const activePlan = nextAllPlans.find(
              (plan) => plan.document.planId === planId,
            );
            nextState.data = activePlan
              ? structuredClone(activePlan.data)
              : state.data;
          }

          return nextState;
        });
        if (!hasPlan) {
          return { ok: false, error: { code: "NOT_FOUND", message: "Plan wurde nicht gefunden." } };
        }
        if (isReadOnly) {
          return { ok: false, error: { code: "READ_ONLY", message: "Plan ist freigegeben und kann nicht bearbeitet werden." } };
        }
        if (!skipApiSync) {
          syncPlanToApi(get, planId);
        }
        return { ok: true, data: undefined };
      },

      commitPlanToApi: async (planId) => {
        if (!isApiModeEnabled()) {
          return { ok: true, data: undefined };
        }
        const currentPlan = get().allPlans.find((p) => p.document.planId === planId);
        if (!currentPlan) {
          return {
            ok: false,
            error: { code: "NOT_FOUND", message: "Plan wurde nicht gefunden." },
          };
        }
        try {
          const apiPlan = await savePlanToApi(currentPlan);
          set((state) => {
            const nextAllPlans = state.allPlans.map((plan) =>
              plan.document.planId === planId ? apiPlan : plan,
            );
            return {
              allPlans: nextAllPlans,
              ...(state.planId === planId ? createActivePlanState(apiPlan) : {}),
            };
          });
          return { ok: true, data: undefined };
        } catch (error) {
          const message =
            error instanceof Error
              ? error.message
              : "Plan konnte nicht gespeichert werden.";
          return {
            ok: false,
            error: {
              code: "INVALID_STATUS",
              message,
            },
          };
        }
      },

      refreshPlanFromApi: async (planId) => {
        if (!isApiModeEnabled()) {
          return { ok: true, data: undefined };
        }
        try {
          const apiPlan = await loadPlanFromApi(planId);
          set((state) => {
            const nextAllPlans = state.allPlans.map((plan) =>
              plan.document.planId === planId ? apiPlan : plan,
            );
            return {
              allPlans: nextAllPlans,
              ...(state.planId === planId ? createActivePlanState(apiPlan) : {}),
            };
          });
          return { ok: true, data: undefined };
        } catch (error) {
          const message =
            error instanceof Error
              ? error.message
              : "Plan konnte nicht vom Server geladen werden.";
          return {
            ok: false,
            error: {
              code: "INVALID_STATUS",
              message,
            },
          };
        }
      },

      resetStore: () =>
        set({
          ...initialState,
        }),

      deletePlan: (planId) =>
        set((state) => ({
          allPlans: state.allPlans.filter((p) => p.document.planId !== planId),
          planId: state.planId === planId ? null : state.planId,
          planName: state.planId === planId ? null : state.planName,
          timeframe: state.planId === planId ? null : state.timeframe,
          selectedKPIs: state.planId === planId ? [] : state.selectedKPIs,
          status: state.planId === planId ? "Idle" : state.status,
          data: state.planId === planId ? [] : state.data,
        })),

      updatePlanMetadata: (planId, payload) => {
        let hasPlan = false;
        let isReadOnly = false;
        let didUpdate = false;
        set((state) => ({
          allPlans: state.allPlans.map((plan) => {
            if (plan.document.planId !== planId) {
              return plan;
            }
            hasPlan = true;
            if (planIntegration.policy.isPlanReadOnly(plan)) {
              isReadOnly = true;
              return plan;
            }
            didUpdate = true;
            return {
              ...plan,
              document: {
                ...plan.document,
                planName: payload.planName.trim(),
                description: payload.description.trim(),
                comparisonYear: payload.comparisonYear.trim(),
                lastModified: new Date().toISOString(),
              },
            };
          }),
          planName:
            state.planId === planId && didUpdate
              ? payload.planName.trim()
              : state.planName,
        }));
        if (!hasPlan) {
          return {
            ok: false,
            error: { code: "NOT_FOUND", message: "Plan wurde nicht gefunden." },
          };
        }
        if (isReadOnly) {
          return {
            ok: false,
            error: {
              code: "READ_ONLY",
              message: "Freigegebene Pläne können nicht bearbeitet werden.",
            },
          };
        }
        syncPlanToApi(get, planId);
        return { ok: true, data: undefined };
      },

      restorePlanSnapshot: (planId, snapshot) => {
        let hasPlan = false;
        set((state) => ({
          allPlans: state.allPlans.map((plan) => {
            if (plan.document.planId !== planId) {
              return plan;
            }
            hasPlan = true;
            return structuredClone(snapshot);
          }),
          data:
            state.planId === planId ? structuredClone(snapshot.data) : state.data,
          status:
            state.planId === planId ? snapshot.document.status : state.status,
          planName:
            state.planId === planId ? snapshot.document.planName : state.planName,
        }));
        if (!hasPlan) {
          return {
            ok: false,
            error: { code: "NOT_FOUND", message: "Plan wurde nicht gefunden." },
          };
        }
        return { ok: true, data: undefined };
      },

      setPlanStatus: (planId, status) => {
        let transitionApplied = false;
        let hasPlan = false;
        let transitionAllowed = false;

        set((state) => ({
          allPlans: state.allPlans.map((p) => {
            if (p.document.planId !== planId) {
              return p;
            }
            hasPlan = true;
            transitionAllowed = planIntegration.policy.canTransitionStatus(
              p.document.status,
              status,
            );
            if (!transitionAllowed) {
              return p;
            }
            transitionApplied = true;
            return {
              ...p,
              document: {
                ...p.document,
                status,
                lastModified: new Date().toISOString(),
              },
            };
          }),
          status:
            state.planId === planId && transitionApplied ? status : state.status,
        }));

        if (!hasPlan) {
          return {
            ok: false,
            error: { code: "NOT_FOUND", message: "Plan wurde nicht gefunden." },
          };
        }
        if (!transitionAllowed) {
          return {
            ok: false,
            error: {
              code: "INVALID_TRANSITION",
              message: "Dieser Statuswechsel ist nicht erlaubt.",
            },
          };
        }
        syncPlanToApi(get, planId);
        return { ok: true, data: undefined };
      },

      createPlanningDocument: (planId) => {
        let hasPlan = false;
        let isReadOnly = false;

        set((state) => ({
          allPlans: state.allPlans.map((plan) => {
            if (plan.document.planId !== planId) {
              return plan;
            }
            hasPlan = true;
            if (planIntegration.policy.isPlanReadOnly(plan)) {
              isReadOnly = true;
              return plan;
            }
            return {
              ...plan,
              document: {
                ...plan.document,
                runtime: buildPlanningDocumentRuntime(
                  plan,
                  plan.document.runtime,
                ),
                lastModified: new Date().toISOString(),
              },
            };
          }),
        }));

        if (!hasPlan) {
          return {
            ok: false,
            error: { code: "NOT_FOUND", message: "Plan wurde nicht gefunden." },
          };
        }
        if (isReadOnly) {
          return {
            ok: false,
            error: {
              code: "READ_ONLY",
              message: "Plan ist freigegeben und kann nicht bearbeitet werden.",
            },
          };
        }
        syncPlanToApi(get, planId);
        return { ok: true, data: undefined };
      },

      releasePlanningDocument: (planId) => {
        let didRelease = false;
        let hasPlan = false;
        let missingRuntime = false;
        let isReadOnly = false;
        set((state) => ({
          allPlans: state.allPlans.map((plan) => {
            if (plan.document.planId !== planId) {
              return plan;
            }
            hasPlan = true;
            if (planIntegration.policy.isPlanReadOnly(plan)) {
              isReadOnly = true;
              return plan;
            }
            if (!plan.document.runtime) {
              missingRuntime = true;
              return plan;
            }

            const releasedAt = new Date().toISOString();
            didRelease = true;
            return {
              ...plan,
              document: {
                ...plan.document,
                status: "Approved",
                lastModified: releasedAt,
                runtime: {
                  ...plan.document.runtime,
                  releasedAt,
                },
              },
            };
          }),
          status: state.planId === planId && didRelease ? "Approved" : state.status,
        }));
        if (!hasPlan) {
          return {
            ok: false,
            error: { code: "NOT_FOUND", message: "Plan wurde nicht gefunden." },
          };
        }
        if (isReadOnly) {
          return {
            ok: false,
            error: {
              code: "READ_ONLY",
              message: "Plan ist bereits freigegeben.",
            },
          };
        }
        if (missingRuntime || !didRelease) {
          return {
            ok: false,
            error: {
              code: "INVALID_STATUS",
              message: "Erzeuge zuerst die Ebenenstruktur des Planungsdokuments.",
            },
          };
        }
        syncPlanToApi(get, planId);
        return { ok: true, data: undefined };
      },

      reopenPlanningDocument: (planId) => {
        let hasPlan = false;
        let didReopen = false;
        set((state) => ({
          allPlans: state.allPlans.map((plan) => {
            if (plan.document.planId !== planId) {
              return plan;
            }
            hasPlan = true;
            if (plan.document.status !== "Approved") {
              return plan;
            }
            didReopen = true;
            return {
              ...plan,
              document: {
                ...plan.document,
                status: "Draft",
                lastModified: new Date().toISOString(),
                runtime: plan.document.runtime
                  ? {
                      ...plan.document.runtime,
                      releasedAt: undefined,
                    }
                  : plan.document.runtime,
              },
            };
          }),
          status: state.planId === planId && didReopen ? "Draft" : state.status,
        }));
        if (!hasPlan) {
          return {
            ok: false,
            error: { code: "NOT_FOUND", message: "Plan wurde nicht gefunden." },
          };
        }
        if (!didReopen) {
          return {
            ok: false,
            error: {
              code: "INVALID_STATUS",
              message: "Nur freigegebene Pläne können wieder geöffnet werden.",
            },
          };
        }
        syncPlanToApi(get, planId);
        return { ok: true, data: undefined };
      },

      exportApprovedPlan: (planId) => {
        const plan = get().allPlans.find((p) => p.document.planId === planId);

        if (!plan) {
          return {
            ok: false,
            error: { code: "NOT_FOUND", message: "Plan wurde nicht gefunden." },
          };
        }
        const exportResult = planIntegration.policy.canExportPlan(plan);
        if (!exportResult.ok) return exportResult;

        return { ok: true, data: structuredClone(plan) };
      },

      importComparisonData: (planId, comparisonYear) => {
        let imported = false;
        let hasPlan = false;
        let isReadOnly = false;
        let noSource = false;
        set((state) => {
          const nextAllPlans = state.allPlans.map((plan) => {
            if (plan.document.planId !== planId) {
              return plan;
            }
            hasPlan = true;
            if (planIntegration.policy.isPlanReadOnly(plan)) {
              isReadOnly = true;
              return plan;
            }

            const source = findComparisonSourcePlan(
              state.allPlans,
              comparisonYear,
              planId,
            );
            if (!source) {
              noSource = true;
              return plan;
            }

            imported = true;
            const compareResult = planIntegration.comparison.applyComparisonDataResult(
              plan,
              source,
            );
            if (!compareResult.ok) {
              return plan;
            }
            const nextPlan = compareResult.data;
            return {
              ...nextPlan,
              document: {
                ...nextPlan.document,
                comparisonYear,
                lastModified: new Date().toISOString(),
              },
            };
          });

          const activePlan = nextAllPlans.find(
            (plan) => plan.document.planId === state.planId,
          );

          return {
            allPlans: nextAllPlans,
            data:
              state.planId === planId && activePlan
                ? structuredClone(activePlan.data)
                : state.data,
          };
        });
        if (!hasPlan) {
          return {
            ok: false,
            error: { code: "NOT_FOUND", message: "Plan wurde nicht gefunden." },
          };
        }
        if (isReadOnly) {
          return {
            ok: false,
            error: {
              code: "READ_ONLY",
              message: "Plan ist freigegeben und kann nicht bearbeitet werden.",
            },
          };
        }
        if (noSource || !imported) {
          return {
            ok: false,
            error: {
              code: "NOT_FOUND",
              message: "Keine Vergleichsdaten für das gewählte Jahr gefunden.",
            },
          };
        }
        syncPlanToApi(get, planId);
        return { ok: true, data: undefined };
      },

      distributeTopDown: (planId, nodeId, distributionType) => {
        let hasPlan = false;
        let isReadOnly = false;
        set((state) => {
          const nextAllPlans = state.allPlans.map((plan) => {
            if (plan.document.planId !== planId) {
              return plan;
            }
            hasPlan = true;
            if (planIntegration.policy.isPlanReadOnly(plan)) {
              isReadOnly = true;
              return plan;
            }

            const distributedPlan = distributePlanningObjectTopDown(
              plan,
              nodeId,
              distributionType,
            );
            const recalculatedData = recalculatePlanningTree(
              structuredClone(distributedPlan.data),
            );

            return {
              ...distributedPlan,
              data: recalculatedData,
              aggregateTotal: recalculateAggregateTotalFromTree(
                distributedPlan.aggregateTotal,
                recalculatedData,
              ),
            };
          });
          const activePlan = nextAllPlans.find(
            (plan) => plan.document.planId === state.planId,
          );

          return {
            allPlans: nextAllPlans,
            data:
              state.planId === planId && activePlan
                ? structuredClone(activePlan.data)
                : state.data,
          };
        });
        if (!hasPlan) {
          return { ok: false, error: { code: "NOT_FOUND", message: "Plan wurde nicht gefunden." } };
        }
        if (isReadOnly) {
          return { ok: false, error: { code: "READ_ONLY", message: "Plan ist freigegeben und kann nicht bearbeitet werden." } };
        }
        syncPlanToApi(get, planId);
        return { ok: true, data: undefined };
      },
    }),
    {
      name: "planning-web-app-plan-store",
      version: 4,
      partialize: (state) => ({
        allPlans: state.allPlans,
      }),
      migrate: (persistedState, version) => {
        const state = persistedState as { allPlans?: PlanningObject[] };
        if (version < 2) {
          return {
            allPlans: initialPlans,
          };
        }

        return {
          allPlans: state.allPlans ?? initialPlans,
        };
      },
    },
  ),
);
