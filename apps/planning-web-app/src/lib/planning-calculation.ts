import type {
  PlanningAggregateTotal,
  PlanningNode,
  SelectedHierarchy,
} from "@/types/planning";

const buildHierarchyClassKey = (hierarchy: SelectedHierarchy) =>
  `${hierarchy.segment}|${hierarchy.family}|${hierarchy.className}`;

export const filterNodesByHierarchies = (
  nodes: PlanningNode[],
  hierarchies: SelectedHierarchy[],
): PlanningNode[] => {
  if (hierarchies.length === 0) {
    return nodes;
  }

  const classKeys = new Set(hierarchies.map(buildHierarchyClassKey));

  const visit = (
    node: PlanningNode,
    path: { segment?: string; family?: string },
    branchSelected: boolean,
  ): PlanningNode | null => {
    const nextPath = { ...path };
    let isSelected = branchSelected;

    if (node.level === "Segment") {
      nextPath.segment = node.name;
      isSelected = hierarchies.some((h) => h.segment === node.name);
    } else if (node.level === "Family") {
      nextPath.family = node.name;
      isSelected = hierarchies.some(
        (h) => h.segment === nextPath.segment && h.family === node.name,
      );
    } else if (node.level === "Class") {
      const key = `${nextPath.segment}|${nextPath.family}|${node.name}`;
      isSelected = classKeys.has(key);
    }

    const children =
      node.children
        ?.map((child) => visit(child, nextPath, isSelected))
        .filter((child): child is PlanningNode => child !== null) ?? [];

    if (!isSelected && children.length === 0) {
      return null;
    }

    return {
      ...node,
      children,
    };
  };

  return nodes
    .map((node) => visit(node, {}, false))
    .filter((node): node is PlanningNode => node !== null);
};

const recalculateNodeMetrics = (node: PlanningNode): PlanningNode => {
  if (!node.children || node.children.length === 0) {
    const planSalesAmount = node.monthlyValues.reduce(
      (sum, entry) => sum + entry.planSalesAmount,
      0,
    );

    return {
      ...node,
      metrics: {
        ...node.metrics,
        planSalesAmount,
      },
    };
  }

  const recalculatedChildren = node.children.map(recalculateNodeMetrics);
  const monthlyValues = node.monthlyValues.map((entry) => {
    const planSalesAmount = recalculatedChildren.reduce((sum, child) => {
      const childEntry = child.monthlyValues.find((m) => m.date === entry.date);
      return sum + (childEntry?.planSalesAmount ?? 0);
    }, 0);

    return {
      ...entry,
      planSalesAmount,
    };
  });

  const planSalesAmount = monthlyValues.reduce(
    (sum, entry) => sum + entry.planSalesAmount,
    0,
  );

  return {
    ...node,
    children: recalculatedChildren,
    monthlyValues,
    metrics: {
      ...node.metrics,
      planSalesAmount,
    },
  };
};

export const recalculatePlanningTree = (nodes: PlanningNode[]): PlanningNode[] =>
  nodes.map(recalculateNodeMetrics);

export const recalculateAggregateTotalFromTree = (
  aggregateTotal: PlanningAggregateTotal | undefined,
  nodes: PlanningNode[],
): PlanningAggregateTotal | undefined => {
  if (!aggregateTotal) {
    return aggregateTotal;
  }

  const monthlyValues = aggregateTotal.monthlyValues.map((entry) => {
    const planSalesAmount = nodes.reduce((sum, node) => {
      const nodeEntry = node.monthlyValues.find((m) => m.date === entry.date);
      return sum + (nodeEntry?.planSalesAmount ?? 0);
    }, 0);

    return {
      ...entry,
      planSalesAmount,
    };
  });

  const planSalesAmount = monthlyValues.reduce(
    (sum, entry) => sum + entry.planSalesAmount,
    0,
  );

  return {
    ...aggregateTotal,
    monthlyValues,
    metrics: {
      ...aggregateTotal.metrics,
      planSalesAmount,
    },
    calculatedAt: new Date().toISOString(),
  };
};
