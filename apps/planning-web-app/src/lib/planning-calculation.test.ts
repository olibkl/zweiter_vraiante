import { describe, expect, it } from "vitest";
import {
  filterNodesByHierarchies,
  recalculateAggregateTotalFromTree,
  recalculatePlanningTree,
} from "@/lib/planning-calculation";
import type { PlanningAggregateTotal, PlanningNode } from "@/types/planning";

const createLeaf = (
  id: string,
  level: PlanningNode["level"],
  name: string,
  jan: number,
  feb: number,
): PlanningNode => ({
  id,
  level,
  name,
  metrics: {
    refSalesAmount: 0,
    planSalesAmount: 0,
  },
  monthlyValues: [
    { date: "01.01.2026", refSalesAmount: 0, planSalesAmount: jan },
    { date: "01.02.2026", refSalesAmount: 0, planSalesAmount: feb },
  ],
  children: [],
});

describe("recalculatePlanningTree", () => {
  it("rolls up parent monthly and total plan values from children", () => {
    const childA = createLeaf("leaf-a", "Brick", "A", 10, 20);
    const childB = createLeaf("leaf-b", "Brick", "B", 5, 15);

    const root: PlanningNode = {
      id: "root",
      level: "Class",
      name: "Root",
      metrics: {
        refSalesAmount: 0,
        planSalesAmount: 0,
      },
      monthlyValues: [
        { date: "01.01.2026", refSalesAmount: 0, planSalesAmount: 0 },
        { date: "01.02.2026", refSalesAmount: 0, planSalesAmount: 0 },
      ],
      children: [childA, childB],
    };

    const [recalculated] = recalculatePlanningTree([root]);

    expect(recalculated.monthlyValues[0].planSalesAmount).toBe(15);
    expect(recalculated.monthlyValues[1].planSalesAmount).toBe(35);
    expect(recalculated.metrics.planSalesAmount).toBe(50);
  });
});

describe("recalculateAggregateTotalFromTree", () => {
  it("derives aggregate totals from root nodes", () => {
    const nodes = recalculatePlanningTree([
      createLeaf("leaf-a", "Segment", "Segment A", 30, 70),
      createLeaf("leaf-b", "Segment", "Segment B", 20, 40),
    ]);

    const aggregate: PlanningAggregateTotal = {
      id: "total",
      name: "Total",
      metrics: {
        refSalesAmount: 0,
        planSalesAmount: 0,
      },
      monthlyValues: [
        { date: "01.01.2026", refSalesAmount: 0, planSalesAmount: 0 },
        { date: "01.02.2026", refSalesAmount: 0, planSalesAmount: 0 },
      ],
      calculatedAt: "2026-01-01T00:00:00.000Z",
    };

    const recalculated = recalculateAggregateTotalFromTree(aggregate, nodes);

    expect(recalculated?.monthlyValues[0].planSalesAmount).toBe(50);
    expect(recalculated?.monthlyValues[1].planSalesAmount).toBe(110);
    expect(recalculated?.metrics.planSalesAmount).toBe(160);
  });
});

describe("filterNodesByHierarchies", () => {
  it("keeps only selected Segment/Family/Class branches", () => {
    const selectedClass = createLeaf("class-1", "Class", "Class 1", 10, 10);
    const otherClass = createLeaf("class-2", "Class", "Class 2", 20, 20);
    const familyA: PlanningNode = {
      ...createLeaf("family-a", "Family", "Family A", 0, 0),
      children: [selectedClass, otherClass],
    };
    const familyB: PlanningNode = {
      ...createLeaf("family-b", "Family", "Family B", 0, 0),
      children: [createLeaf("class-3", "Class", "Class 3", 5, 5)],
    };
    const segmentA: PlanningNode = {
      ...createLeaf("segment-a", "Segment", "Segment A", 0, 0),
      children: [familyA, familyB],
    };

    const filtered = filterNodesByHierarchies([segmentA], [
      { segment: "Segment A", family: "Family A", className: "Class 1" },
    ]);

    expect(filtered).toHaveLength(1);
    expect(filtered[0].name).toBe("Segment A");
    expect(filtered[0].children?.[0].name).toBe("Family A");
    expect(filtered[0].children?.[0].children?.map((n) => n.name)).toEqual([
      "Class 1",
    ]);
  });
});

describe("write protection contract", () => {
  it("keeps approved plans read-only at store action level", async () => {
    if (typeof globalThis.localStorage === "undefined") {
      const storage = new Map<string, string>();
      (globalThis as { localStorage: Storage }).localStorage = {
        getItem: (key: string) => storage.get(key) ?? null,
        setItem: (key: string, value: string) => {
          storage.set(key, value);
        },
        removeItem: (key: string) => {
          storage.delete(key);
        },
        clear: () => {
          storage.clear();
        },
        key: (index: number) => Array.from(storage.keys())[index] ?? null,
        get length() {
          return storage.size;
        },
      } as Storage;
    }

    const { usePlanStore } = await import("@/store/usePlanStore");

    usePlanStore.getState().resetStore();
    const planId = usePlanStore.getState().setPlanSetup({
      planId: "PLAN-RO-1",
      name: "Readonly Plan",
      description: "approved plan",
      fiscalYear: "2026",
      comparisonYear: "2025",
      planningPeriod: {
        startDate: "2026-01-01",
        endDate: "2026-12-31",
        dateUnit: "Month",
      },
      referencePeriod: {
        startDate: "2025-01-01",
        endDate: "2025-12-31",
        dateUnit: "Month",
      },
      kpis: ["Umsatz"],
      hierarchies: [],
    });

    usePlanStore.getState().setPlanStatus(planId, "Approved");
    const approvedPlanBefore = usePlanStore
      .getState()
      .allPlans.find((p) => p.document.planId === planId);
    const nodeId = approvedPlanBefore?.data[0]?.id;
    const date = approvedPlanBefore?.data[0]?.monthlyValues[0]?.date;
    const beforeValue = approvedPlanBefore?.data[0]?.monthlyValues[0]?.planSalesAmount;

    expect(nodeId).toBeDefined();
    expect(date).toBeDefined();
    expect(beforeValue).toBeDefined();

    usePlanStore
      .getState()
      .updateNodeMonthlyPlanValue(planId, nodeId!, date!, 999999);

    const approvedPlanAfter = usePlanStore
      .getState()
      .allPlans.find((p) => p.document.planId === planId);
    const afterValue = approvedPlanAfter?.data[0]?.monthlyValues[0]?.planSalesAmount;

    expect(afterValue).toBe(beforeValue);
  });
});

describe("status transition contract", () => {
  it("blocks invalid Draft -> Approved transition and allows Draft -> InReview", async () => {
    if (typeof globalThis.localStorage === "undefined") {
      const storage = new Map<string, string>();
      (globalThis as { localStorage: Storage }).localStorage = {
        getItem: (key: string) => storage.get(key) ?? null,
        setItem: (key: string, value: string) => {
          storage.set(key, value);
        },
        removeItem: (key: string) => {
          storage.delete(key);
        },
        clear: () => {
          storage.clear();
        },
        key: (index: number) => Array.from(storage.keys())[index] ?? null,
        get length() {
          return storage.size;
        },
      } as Storage;
    }

    const { usePlanStore } = await import("@/store/usePlanStore");

    usePlanStore.getState().resetStore();
    const planId = usePlanStore.getState().setPlanSetup({
      planId: "PLAN-STATE-1",
      name: "State Plan",
      description: "state transitions",
      fiscalYear: "2026",
      comparisonYear: "2025",
      planningPeriod: {
        startDate: "2026-01-01",
        endDate: "2026-12-31",
        dateUnit: "Month",
      },
      referencePeriod: {
        startDate: "2025-01-01",
        endDate: "2025-12-31",
        dateUnit: "Month",
      },
      kpis: ["Umsatz"],
      hierarchies: [],
    });

    usePlanStore.getState().setPlanStatus(planId, "Approved");
    const statusAfterInvalidTransition = usePlanStore
      .getState()
      .allPlans.find((p) => p.document.planId === planId)?.document.status;
    expect(statusAfterInvalidTransition).toBe("Draft");

    usePlanStore.getState().setPlanStatus(planId, "InReview");
    const statusAfterValidTransition = usePlanStore
      .getState()
      .allPlans.find((p) => p.document.planId === planId)?.document.status;
    expect(statusAfterValidTransition).toBe("InReview");
  });
});

describe("export contract", () => {
  it("allows export only when plan is Approved", async () => {
    if (typeof globalThis.localStorage === "undefined") {
      const storage = new Map<string, string>();
      (globalThis as { localStorage: Storage }).localStorage = {
        getItem: (key: string) => storage.get(key) ?? null,
        setItem: (key: string, value: string) => {
          storage.set(key, value);
        },
        removeItem: (key: string) => {
          storage.delete(key);
        },
        clear: () => {
          storage.clear();
        },
        key: (index: number) => Array.from(storage.keys())[index] ?? null,
        get length() {
          return storage.size;
        },
      } as Storage;
    }

    const { usePlanStore } = await import("@/store/usePlanStore");
    usePlanStore.getState().resetStore();

    const planId = usePlanStore.getState().setPlanSetup({
      planId: "PLAN-EXPORT-1",
      name: "Export Plan",
      description: "export test",
      fiscalYear: "2026",
      comparisonYear: "2025",
      planningPeriod: {
        startDate: "2026-01-01",
        endDate: "2026-12-31",
        dateUnit: "Month",
      },
      referencePeriod: {
        startDate: "2025-01-01",
        endDate: "2025-12-31",
        dateUnit: "Month",
      },
      kpis: ["Umsatz"],
      hierarchies: [],
    });

    const deniedExport = usePlanStore.getState().exportApprovedPlan(planId);
    expect(deniedExport.ok).toBe(false);

    usePlanStore.getState().setPlanStatus(planId, "InReview");
    usePlanStore.getState().setPlanStatus(planId, "Approved");

    const allowedExport = usePlanStore.getState().exportApprovedPlan(planId);
    expect(allowedExport.ok).toBe(true);
    if (allowedExport.ok) {
      expect(allowedExport.data.document.status).toBe("Approved");
    }
  });
});
