import { describe, expect, it } from "vitest";
import { distributePlanningObjectTopDown } from "@/lib/planning-document";
import type { PlanningNode, PlanningObject } from "@/types/planning";

const createLeaf = (
  id: string,
  name: string,
  monthly: Array<{ date: string; ref: number; plan: number }>,
): PlanningNode => ({
  id,
  level: "Brick",
  name,
  metrics: {
    refSalesAmount: monthly.reduce((sum, m) => sum + m.ref, 0),
    planSalesAmount: monthly.reduce((sum, m) => sum + m.plan, 0),
  },
  monthlyValues: monthly.map((m) => ({
    date: m.date,
    refSalesAmount: m.ref,
    planSalesAmount: m.plan,
  })),
  children: [],
});

const createPlan = (
  totalMonthlyPlan: Array<{ date: string; plan: number }>,
  children: PlanningNode[],
): PlanningObject => ({
  document: {
    planId: "TEST-PLAN",
    planName: "TopDown Test",
    planningType: "Umsatz",
    description: "test",
    fiscalYear: "2026",
    comparisonYear: "2025",
    status: "Draft",
    lastModified: "2026-01-01T00:00:00.000Z",
  },
  aggregateTotal: {
    id: "total",
    name: "Total",
    metrics: {
      refSalesAmount: 0,
      planSalesAmount: totalMonthlyPlan.reduce((sum, m) => sum + m.plan, 0),
    },
    monthlyValues: totalMonthlyPlan.map((m) => ({
      date: m.date,
      refSalesAmount: 0,
      planSalesAmount: m.plan,
    })),
    calculatedAt: "2026-01-01T00:00:00.000Z",
  },
  data: children,
});

describe("distributePlanningObjectTopDown", () => {
  it("preserves monthly totals with rounding and remainder correction", () => {
    const dates = ["01.01.2026", "01.02.2026"];
    const childA = createLeaf("a", "A", [
      { date: dates[0], ref: 0, plan: 0 },
      { date: dates[1], ref: 0, plan: 0 },
    ]);
    const childB = createLeaf("b", "B", [
      { date: dates[0], ref: 0, plan: 0 },
      { date: dates[1], ref: 0, plan: 0 },
    ]);
    const childC = createLeaf("c", "C", [
      { date: dates[0], ref: 0, plan: 0 },
      { date: dates[1], ref: 0, plan: 0 },
    ]);

    const plan = createPlan(
      [
        { date: dates[0], plan: 10 },
        { date: dates[1], plan: 11 },
      ],
      [childA, childB, childC],
    );

    const distributed = distributePlanningObjectTopDown(
      plan,
      "total",
      "PlanValues",
    );

    const janSum = distributed.data.reduce(
      (sum, node) =>
        sum +
        (node.monthlyValues.find((m) => m.date === dates[0])?.planSalesAmount ??
          0),
      0,
    );
    const febSum = distributed.data.reduce(
      (sum, node) =>
        sum +
        (node.monthlyValues.find((m) => m.date === dates[1])?.planSalesAmount ??
          0),
      0,
    );

    expect(janSum).toBe(10);
    expect(febSum).toBe(11);
  });

  it("uses reference values as distribution base in ReferenceValues mode", () => {
    const date = "01.01.2026";
    const childA = createLeaf("a", "A", [{ date, ref: 1, plan: 0 }]);
    const childB = createLeaf("b", "B", [{ date, ref: 3, plan: 0 }]);

    const plan = createPlan([{ date, plan: 10 }], [childA, childB]);
    const distributed = distributePlanningObjectTopDown(
      plan,
      "total",
      "ReferenceValues",
    );

    const a = distributed.data.find((n) => n.id === "a");
    const b = distributed.data.find((n) => n.id === "b");

    expect(a?.monthlyValues[0].planSalesAmount).toBe(3);
    expect(b?.monthlyValues[0].planSalesAmount).toBe(7);
    expect(
      (a?.monthlyValues[0].planSalesAmount ?? 0) +
        (b?.monthlyValues[0].planSalesAmount ?? 0),
    ).toBe(10);
  });
});
