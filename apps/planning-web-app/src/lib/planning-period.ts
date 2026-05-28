import type {
  PlanningAggregateTotal,
  PlanningDateUnit,
  PlanningMonthlyValue,
  PlanningNode,
  PlanningObject,
  PlanningPeriod,
} from "@/types/planning";

export type PlanningPeriodDraft = Omit<PlanningPeriod, "recordCount">;

const millisecondsPerDay = 24 * 60 * 60 * 1000;

const parseInputDate = (value: string): Date | null => {
  if (!value) {
    return null;
  }

  const isoMatch = value.match(/^(\d{4})-(\d{2})-(\d{2})$/);
  if (isoMatch) {
    return new Date(
      Date.UTC(Number(isoMatch[1]), Number(isoMatch[2]) - 1, Number(isoMatch[3])),
    );
  }

  const germanMatch = value.match(/^(\d{2})\.(\d{2})\.(\d{4})$/);
  if (germanMatch) {
    return new Date(
      Date.UTC(
        Number(germanMatch[3]),
        Number(germanMatch[2]) - 1,
        Number(germanMatch[1]),
      ),
    );
  }

  return null;
};

const daysSinceMonday = (date: Date) => (date.getUTCDay() + 6) % 7;
const quarterStartMonth = (monthIndex: number) =>
  Math.floor(monthIndex / 3) * 3;

const periodStart = (date: Date, unit: PlanningDateUnit) => {
  switch (unit) {
    case "Day":
      return date;
    case "Week":
      return new Date(date.getTime() - daysSinceMonday(date) * millisecondsPerDay);
    case "Month":
      return new Date(Date.UTC(date.getUTCFullYear(), date.getUTCMonth(), 1));
    case "Quarter":
      return new Date(
        Date.UTC(date.getUTCFullYear(), quarterStartMonth(date.getUTCMonth()), 1),
      );
    case "Year":
      return new Date(Date.UTC(date.getUTCFullYear(), 0, 1));
  }
};

const nextPeriodStart = (date: Date, unit: PlanningDateUnit) => {
  switch (unit) {
    case "Day":
      return new Date(date.getTime() + millisecondsPerDay);
    case "Week":
      return new Date(date.getTime() + 7 * millisecondsPerDay);
    case "Month":
      return new Date(Date.UTC(date.getUTCFullYear(), date.getUTCMonth() + 1, 1));
    case "Quarter":
      return new Date(Date.UTC(date.getUTCFullYear(), date.getUTCMonth() + 3, 1));
    case "Year":
      return new Date(Date.UTC(date.getUTCFullYear() + 1, 0, 1));
  }
};

const firstPeriodStartOnOrAfter = (date: Date, unit: PlanningDateUnit) => {
  const start = periodStart(date, unit);
  return start < date ? nextPeriodStart(start, unit) : start;
};

export const validatePlanningRange = (
  startDate: string,
  endDate: string,
): string | null => {
  const start = parseInputDate(startDate);
  const end = parseInputDate(endDate);

  if (!start || !end) {
    return "Start- und Enddatum muessen gesetzt sein.";
  }

  if (end < start) {
    return "Das Enddatum muss nach dem Startdatum liegen.";
  }

  return null;
};

export const countPlanningPeriodRecords = ({
  startDate,
  endDate,
  dateUnit,
}: PlanningPeriodDraft) => {
  const start = parseInputDate(startDate);
  const end = parseInputDate(endDate);

  if (!start || !end || end < start) {
    return 0;
  }

  let recordCount = 0;
  let cursor = firstPeriodStartOnOrAfter(start, dateUnit);

  while (cursor <= end) {
    recordCount += 1;
    cursor = nextPeriodStart(cursor, dateUnit);
  }

  return recordCount;
};

export const completePlanningPeriod = (period: PlanningPeriodDraft): PlanningPeriod => ({
  ...period,
  recordCount: countPlanningPeriodRecords(period),
});

export const yearPeriod = (year: string): PlanningPeriodDraft => ({
  startDate: `${year}-01-01`,
  endDate: `${year}-12-31`,
  dateUnit: "Month",
});

export const formatPlanningPeriod = (period?: PlanningPeriod) => {
  if (!period) {
    return "-";
  }

  return `${formatPeriodDate(period.startDate)} - ${formatPeriodDate(period.endDate)} (${period.recordCount})`;
};

export const resolvePlanningPeriod = (
  period: PlanningPeriod | undefined,
  fallbackYear: string | undefined,
) => {
  if (period || !fallbackYear) {
    return period;
  }

  return completePlanningPeriod(yearPeriod(fallbackYear));
};

export const fitPlanningObjectToPeriod = (
  template: PlanningObject,
  planningPeriod: PlanningPeriod,
): Pick<PlanningObject, "aggregateTotal" | "data"> => ({
  aggregateTotal: template.aggregateTotal
    ? fitAggregateTotalToPeriod(template.aggregateTotal, planningPeriod)
    : undefined,
  data: template.data.map((node) => fitNodeToPeriod(node, planningPeriod)),
});

const fitAggregateTotalToPeriod = (
  total: PlanningAggregateTotal,
  planningPeriod: PlanningPeriod,
): PlanningAggregateTotal => {
  const monthlyValues = filterMonthlyValues(total.monthlyValues, planningPeriod);
  return {
    ...total,
    metrics: calculateMetrics(total.metrics, monthlyValues),
    monthlyValues,
  };
};

const fitNodeToPeriod = (
  node: PlanningNode,
  planningPeriod: PlanningPeriod,
): PlanningNode => {
  const monthlyValues = filterMonthlyValues(node.monthlyValues, planningPeriod);
  return {
    ...node,
    metrics: calculateMetrics(node.metrics, monthlyValues),
    monthlyValues,
    children: node.children?.map((child) => fitNodeToPeriod(child, planningPeriod)),
  };
};

const filterMonthlyValues = (
  monthlyValues: PlanningMonthlyValue[],
  planningPeriod: PlanningPeriod,
) => {
  const start = parseInputDate(planningPeriod.startDate);
  const end = parseInputDate(planningPeriod.endDate);

  if (!start || !end) {
    return monthlyValues;
  }

  return monthlyValues.filter((entry) => {
    const entryDate = parseInputDate(entry.date);
    return Boolean(entryDate && entryDate >= start && entryDate <= end);
  });
};

const calculateMetrics = (
  metrics: PlanningNode["metrics"],
  monthlyValues: PlanningMonthlyValue[],
) => ({
  ...metrics,
  refSalesAmount: monthlyValues.reduce(
    (sum, entry) => sum + entry.refSalesAmount,
    0,
  ),
  planSalesAmount: monthlyValues.reduce(
    (sum, entry) => sum + entry.planSalesAmount,
    0,
  ),
});

const formatPeriodDate = (value: string) => {
  const date = parseInputDate(value);
  return date
    ? date.toLocaleDateString("de-DE", {
        timeZone: "UTC",
        year: "numeric",
        month: "2-digit",
        day: "2-digit",
      })
    : value;
};
