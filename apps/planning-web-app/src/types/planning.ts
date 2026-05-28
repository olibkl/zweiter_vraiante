export type PlanningStatus = "Draft" | "InReview" | "Approved";
export type HierarchyLevel = "Total" | "Segment" | "Family" | "Class" | "Brick";
export type PlanningType = "Umsatz" | "Anzahl";
export type PlanningDateUnit = "Day" | "Week" | "Month" | "Quarter" | "Year";
export type PlanningDistributionType = "PlanValues" | "ReferenceValues";

export interface PlanningPeriod {
  startDate: string;
  endDate: string;
  dateUnit: PlanningDateUnit;
  recordCount: number;
}

export interface SelectedHierarchy {
  segment: string;
  family: string;
  className: string;
}

export interface PlanningMetrics {
  refSalesAmount: number;
  refCostOfSales?: number;
  planSalesAmount: number;
}

export interface PlanningMonthlyValue {
  date: string;
  refSalesAmount: number;
  planSalesAmount: number;
}

export interface PlanningNode {
  id: string;
  level: HierarchyLevel;
  name: string;
  metrics: PlanningMetrics;
  monthlyValues: PlanningMonthlyValue[];
  children?: PlanningNode[];
}

export interface PlanningDocumentLevel {
  index: number;
  level: HierarchyLevel;
  description: string;
  activateDateLevel: boolean;
  pathEnd: boolean;
  activeBufferCount: number;
  lineCount: number;
}

export interface PlanningLevelBufferEntry {
  nodeId: string;
  levelIndex: number;
  level: HierarchyLevel;
  indexCode: string;
  indexDescription: string;
  active: boolean;
  dummy: boolean;
}

export interface PlanningDocumentRuntime {
  createdAt: string;
  releasedAt?: string;
  planningValuesTimestamp: string;
  distributionType: PlanningDistributionType;
  levels: PlanningDocumentLevel[];
  buffers: PlanningLevelBufferEntry[];
}

export interface PlanningObjectDocument {
  planId: string;
  planName: string;
  planningType: PlanningType;
  description: string;
  fiscalYear?: string;
  comparisonYear?: string;
  planningPeriod?: PlanningPeriod;
  referencePeriod?: PlanningPeriod;
  status: PlanningStatus;
  selectedHierarchies?: SelectedHierarchy[];
  runtime?: PlanningDocumentRuntime;
  lastModified: string;
}

export interface PlanningAggregateTotal {
  id: string;
  name: string;
  metrics: PlanningMetrics;
  monthlyValues: PlanningMonthlyValue[];
  calculatedAt: string;
}

export interface PlanningObject {
  document: PlanningObjectDocument;
  aggregateTotal?: PlanningAggregateTotal;
  data: PlanningNode[];
}
