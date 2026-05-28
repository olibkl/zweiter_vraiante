import { describe, expect, it } from "vitest";
import { applyComparisonDataToPlan } from "@/lib/comparison-import";
import type { PlanningNode, PlanningObject } from "@/types/planning";

const createLeaf = (
  id: string,
  refMonthly: number[],
  planMonthly: number[],
): PlanningNode => ({
  id,
  level: "Brick",
  name: id,
  metrics: {
    refSalesAmount: refMonthly.reduce((sum, n) => sum + n, 0),
    planSalesAmount: planMonthly.reduce((sum, n) => sum + n, 0),
  },
  monthlyValues: refMonthly.map((ref, index) => ({
    date: `01.0${index + 1}.2026`,
    refSalesAmount: ref,
    planSalesAmount: planMonthly[index] ?? 0,
  })),
  children: [],
});

const createPlan = (
  fiscalYear: string,
  comparisonYear: string,
  nodes: PlanningNode[],
): PlanningObject => ({
  document: {
    planId: `PLAN-${fiscalYear}`,
    planName: `Plan ${fiscalYear}`,
    planningType: "Umsatz",
    description: "",
    fiscalYear,
    comparisonYear,
    status: "Draft",
    lastModified: "2026-01-01T00:00:00.000Z",
  },
  aggregateTotal: {
    id: "TOTAL",
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
  },
  data: nodes,
});

describe("applyComparisonDataToPlan", () => {
  it("maps source plan values to target ref values", () => {
    const target = createPlan("2026", "2025", [
      createLeaf("A", [0, 0], [20, 30]),
      createLeaf("B", [0, 0], [10, 10]),
    ]);
    const source = createPlan("2025", "2024", [
      createLeaf("A", [1, 1], [100, 200]),
      createLeaf("B", [1, 1], [50, 80]),
    ]);
    source.aggregateTotal!.monthlyValues[0].planSalesAmount = 150;
    source.aggregateTotal!.monthlyValues[1].planSalesAmount = 280;
    source.aggregateTotal!.metrics.refCostOfSales = 999;

    const imported = applyComparisonDataToPlan(target, source);

    expect(imported.data[0].monthlyValues[0].refSalesAmount).toBe(100);
    expect(imported.data[0].monthlyValues[1].refSalesAmount).toBe(200);
    expect(imported.data[1].monthlyValues[0].refSalesAmount).toBe(50);
    expect(imported.data[1].monthlyValues[1].refSalesAmount).toBe(80);
    expect(imported.data[0].metrics.refSalesAmount).toBe(300);
    expect(imported.data[1].metrics.refSalesAmount).toBe(130);
    expect(imported.aggregateTotal?.monthlyValues[0].refSalesAmount).toBe(150);
    expect(imported.aggregateTotal?.monthlyValues[1].refSalesAmount).toBe(280);
    expect(imported.aggregateTotal?.metrics.refSalesAmount).toBe(430);
  });
});
