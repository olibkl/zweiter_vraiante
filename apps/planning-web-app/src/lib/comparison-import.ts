import type { PlanningNode, PlanningObject } from "@/types/planning";

const mapNodeById = (nodes: PlanningNode[]) => {
  const map = new Map<string, PlanningNode>();

  const walk = (entries: PlanningNode[]) => {
    entries.forEach((node) => {
      map.set(node.id, node);
      if (node.children?.length) {
        walk(node.children);
      }
    });
  };

  walk(nodes);
  return map;
};

const applyReferenceToNode = (
  targetNode: PlanningNode,
  sourceNode: PlanningNode | undefined,
): PlanningNode => {
  const sourceMonthly = sourceNode?.monthlyValues ?? [];
  const monthlyValues = targetNode.monthlyValues.map((month, index) => ({
    ...month,
    refSalesAmount: sourceMonthly[index]?.planSalesAmount ?? month.refSalesAmount,
  }));

  const refSalesAmount = monthlyValues.reduce(
    (sum, month) => sum + month.refSalesAmount,
    0,
  );

  const children = (targetNode.children ?? []).map((child) =>
    applyReferenceToNode(child, sourceNode?.children?.find((s) => s.id === child.id)),
  );

  return {
    ...targetNode,
    metrics: {
      ...targetNode.metrics,
      refSalesAmount,
      refCostOfSales: sourceNode?.metrics.refCostOfSales ?? targetNode.metrics.refCostOfSales,
    },
    monthlyValues,
    children,
  };
};

export const applyComparisonDataToPlan = (
  targetPlan: PlanningObject,
  sourcePlan: PlanningObject,
): PlanningObject => {
  const sourceById = mapNodeById(sourcePlan.data);
  const data = targetPlan.data.map((node) =>
    applyReferenceToNode(node, sourceById.get(node.id)),
  );

  const aggregateMonthly = targetPlan.aggregateTotal?.monthlyValues.map(
    (month, index) => ({
      ...month,
      refSalesAmount:
        sourcePlan.aggregateTotal?.monthlyValues[index]?.planSalesAmount ??
        month.refSalesAmount,
    }),
  );

  const aggregateRefSalesAmount =
    aggregateMonthly?.reduce((sum, month) => sum + month.refSalesAmount, 0) ?? 0;

  return {
    ...targetPlan,
    aggregateTotal: targetPlan.aggregateTotal
      ? {
          ...targetPlan.aggregateTotal,
          monthlyValues: aggregateMonthly ?? targetPlan.aggregateTotal.monthlyValues,
          metrics: {
            ...targetPlan.aggregateTotal.metrics,
            refSalesAmount: aggregateRefSalesAmount,
            refCostOfSales:
              sourcePlan.aggregateTotal?.metrics.refCostOfSales ??
              targetPlan.aggregateTotal.metrics.refCostOfSales,
          },
        }
      : targetPlan.aggregateTotal,
    data,
  };
};
