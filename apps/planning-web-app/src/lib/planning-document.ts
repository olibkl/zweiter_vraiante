import type {
  HierarchyLevel,
  PlanningDistributionType,
  PlanningDocumentRuntime,
  PlanningLevelBufferEntry,
  PlanningMonthlyValue,
  PlanningNode,
  PlanningObject,
} from "@/types/planning";
import { DEFAULT_ROUNDING_MODE, roundNonNegative } from "@/lib/rounding";

const levelOrder: HierarchyLevel[] = [
  "Total",
  "Segment",
  "Family",
  "Class",
  "Brick",
];

const levelDescriptions: Record<HierarchyLevel, string> = {
  Total: "Gesamt",
  Segment: "Segment",
  Family: "Familie",
  Class: "Klasse",
  Brick: "Brick",
};

const roundAmount = (value: number) =>
  roundNonNegative(value, DEFAULT_ROUNDING_MODE, 0);

const sumPlanValues = (monthlyValues: PlanningMonthlyValue[]) =>
  monthlyValues.reduce((sum, value) => sum + value.planSalesAmount, 0);

const walkNodes = (
  nodes: PlanningNode[],
  visit: (node: PlanningNode) => void,
) => {
  nodes.forEach((node) => {
    visit(node);
    if (node.children?.length) {
      walkNodes(node.children, visit);
    }
  });
};

const getDateRecordCount = (plan: PlanningObject) =>
  plan.document.planningPeriod?.recordCount ??
  plan.aggregateTotal?.monthlyValues.length ??
  plan.data[0]?.monthlyValues.length ??
  0;

export const calculatePlanAmountFromDifference = (
  referenceValue: number,
  differencePercent: number,
) => roundAmount(referenceValue * ((differencePercent + 100) / 100));

export const calculatePlanAmountFromShare = (
  totalValue: number,
  sharePercent: number,
) => roundAmount(totalValue * (sharePercent / 100));

export const buildPlanningDocumentRuntime = (
  plan: PlanningObject,
  currentRuntime?: PlanningDocumentRuntime,
): PlanningDocumentRuntime => {
  const now = new Date().toISOString();
  const levelMap = new Map<HierarchyLevel, PlanningLevelBufferEntry[]>();

  walkNodes(plan.data, (node) => {
    const levelIndex = levelOrder.indexOf(node.level);
    const entries = levelMap.get(node.level) ?? [];
    if (!entries.some((entry) => entry.nodeId === node.id)) {
      entries.push({
        nodeId: node.id,
        levelIndex,
        level: node.level,
        indexCode: node.id,
        indexDescription: node.name,
        active: true,
        dummy: false,
      });
    }
    levelMap.set(node.level, entries);
  });

  const dateRecordCount = Math.max(getDateRecordCount(plan), 1);
  const hierarchyLevels = levelOrder.filter(
    (level) => level === "Total" || levelMap.has(level),
  );
  const lastLevelIndex = hierarchyLevels.length - 1;
  const buffers = hierarchyLevels.flatMap((level) => levelMap.get(level) ?? []);

  return {
    createdAt: currentRuntime?.createdAt ?? now,
    releasedAt: currentRuntime?.releasedAt,
    planningValuesTimestamp: now,
    distributionType: currentRuntime?.distributionType ?? "PlanValues",
    levels: hierarchyLevels.map((level, index) => {
      const activeBufferCount =
        level === "Total"
          ? plan.aggregateTotal
            ? 1
            : plan.data.length
          : levelMap.get(level)?.length ?? 0;

      return {
        index,
        level,
        description: levelDescriptions[level],
        activateDateLevel: true,
        pathEnd: index === lastLevelIndex,
        activeBufferCount,
        lineCount: activeBufferCount * dateRecordCount,
      };
    }),
    buffers,
  };
};

const readDistributionBase = (
  value: PlanningMonthlyValue | undefined,
  mode: PlanningDistributionType,
) => {
  if (!value) {
    return 0;
  }

  return mode === "ReferenceValues"
    ? value.refSalesAmount
    : value.planSalesAmount;
};

const distributeMonth = (
  children: PlanningNode[],
  date: string,
  targetValue: number,
  mode: PlanningDistributionType,
) => {
  const bases = children.map((child) =>
    readDistributionBase(
      child.monthlyValues.find((value) => value.date === date),
      mode,
    ),
  );
  const totalBase = bases.reduce((sum, value) => sum + value, 0);
  let remainder = roundAmount(targetValue);

  return children.map((child, index) => {
    const rawValue =
      index === children.length - 1
        ? remainder
        : totalBase > 0
          ? targetValue * (bases[index] / totalBase)
          : targetValue / Math.max(children.length, 1);
    const planSalesAmount =
      index === children.length - 1 ? remainder : roundAmount(rawValue);
    remainder -= planSalesAmount;

    return {
      child,
      planSalesAmount,
    };
  });
};

const distributeChildren = (
  parentMonthlyValues: PlanningMonthlyValue[],
  children: PlanningNode[],
  mode: PlanningDistributionType,
): PlanningNode[] => {
  if (children.length === 0) {
    return children;
  }

  const nextAmountsByChild = new Map<string, Map<string, number>>();

  parentMonthlyValues.forEach((parentMonth) => {
    distributeMonth(
      children,
      parentMonth.date,
      parentMonth.planSalesAmount,
      mode,
    ).forEach(({ child, planSalesAmount }) => {
      const amounts = nextAmountsByChild.get(child.id) ?? new Map();
      amounts.set(parentMonth.date, planSalesAmount);
      nextAmountsByChild.set(child.id, amounts);
    });
  });

  return children.map((child) => {
    const amounts = nextAmountsByChild.get(child.id);
    const monthlyValues = child.monthlyValues.map((month) => ({
      ...month,
      planSalesAmount: amounts?.get(month.date) ?? month.planSalesAmount,
    }));
    const nextChild = {
      ...child,
      metrics: {
        ...child.metrics,
        planSalesAmount: sumPlanValues(monthlyValues),
      },
      monthlyValues,
    };

    return nextChild.children?.length
      ? {
          ...nextChild,
          children: distributeChildren(monthlyValues, nextChild.children, mode),
        }
      : nextChild;
  });
};

const distributeNodeInTree = (
  nodes: PlanningNode[],
  nodeId: string,
  mode: PlanningDistributionType,
): { nodes: PlanningNode[]; changed: boolean } => {
  let changed = false;
  const nextNodes = nodes.map((node) => {
    if (node.id === nodeId && node.children?.length) {
      changed = true;
      return {
        ...node,
        children: distributeChildren(node.monthlyValues, node.children, mode),
      };
    }

    if (!node.children?.length) {
      return node;
    }

    const result = distributeNodeInTree(node.children, nodeId, mode);
    changed ||= result.changed;
    return result.changed ? { ...node, children: result.nodes } : node;
  });

  return { nodes: nextNodes, changed };
};

export const distributePlanningObjectTopDown = (
  plan: PlanningObject,
  nodeId: string,
  mode: PlanningDistributionType,
): PlanningObject => {
  const now = new Date().toISOString();
  const isTotalNode = plan.aggregateTotal?.id === nodeId;
  const result = isTotalNode
    ? {
        nodes: distributeChildren(
          plan.aggregateTotal?.monthlyValues ?? [],
          plan.data,
          mode,
        ),
        changed: true,
      }
    : distributeNodeInTree(plan.data, nodeId, mode);

  if (!result.changed) {
    return plan;
  }

  return {
    ...plan,
    document: {
      ...plan.document,
      lastModified: now,
      runtime: plan.document.runtime
        ? {
            ...plan.document.runtime,
            planningValuesTimestamp: now,
            distributionType: mode,
          }
        : plan.document.runtime,
    },
    data: result.nodes,
  };
};
