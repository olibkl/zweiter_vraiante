import { useEffect, useRef, useState } from "react";
import type { KeyboardEvent, ReactNode } from "react";
import { useParams } from "react-router-dom";
import { usePlanStore } from "@/store/usePlanStore";
import { formatPlanningPeriod, resolvePlanningPeriod } from "@/lib/planning-period";
import type { PlanningDistributionType, PlanningNode } from "@/types/planning";
import { toast } from "sonner";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import {
  DropdownMenu,
  DropdownMenuTrigger,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuSeparator,
} from "@/components/ui/dropdown-menu";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogDescription,
  DialogFooter,
  DialogClose,
} from "@/components/ui/dialog";
import {
  ArrowDownToLine,
  CircleHelp,
  Lock,
  Maximize2,
  Minimize2,
  MoreVertical,
  Unlock,
} from "lucide-react";
import { useNavigate } from "react-router-dom";
import { Input } from "@/components/ui/input";
import { CalendarDays, ChevronDown, ChevronRight } from "lucide-react";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import {
  Tooltip,
  TooltipContent,
  TooltipTrigger,
} from "@/components/ui/tooltip";
import {
  DEFAULT_MONEY_PRECISION,
  DEFAULT_PHYSICAL_PRECISION,
  DEFAULT_ROUNDING_MODE,
  roundNonNegative,
} from "@/lib/rounding";
import { fetchFxRate } from "@/lib/fx-rate";

const formatNumber = (value: number, precision = 2) => {
  return new Intl.NumberFormat("de-DE", {
    minimumFractionDigits: precision,
    maximumFractionDigits: precision,
  }).format(value);
};

const formatPercent = (value: number, precision = 2) => {
  return new Intl.NumberFormat("de-DE", {
    minimumFractionDigits: precision,
    maximumFractionDigits: precision,
  }).format(value);
};

const CURRENCY_OPTIONS = ["EUR", "USD", "GBP", "CHF"] as const;
type CurrencyCode = (typeof CURRENCY_OPTIONS)[number];
type RoundingMode = "commercial" | "symmetric" | "up" | "down";

const getMonthLabel = (date: string) => {
  const months = [
    "Januar",
    "Februar",
    "Maerz",
    "April",
    "Mai",
    "Juni",
    "Juli",
    "August",
    "September",
    "Oktober",
    "November",
    "Dezember",
  ];
  const monthIndex = Number(date.split(".")[1]) - 1;
  return months[monthIndex] ?? date;
};

const calculateDelta = (ref: number, plan: number) => {
  if (ref === 0) return 0;
  return ((plan - ref) / ref) * 100;
};

const parsePlanInput = (value: string) => {
  const normalized = value
    .replace(/%/g, "")
    .replace(/\./g, "")
    .replace(",", ".")
    .trim();
  const parsed = Number(normalized);
  return Number.isFinite(parsed) ? parsed : 0;
};

const isValidNumericInput = (value: string) => {
  return /^[\d\s.,%-]+$/.test(value.trim());
};

const focusNextEditableInput = (current: HTMLInputElement) => {
  const inputs = Array.from(
    document.querySelectorAll<HTMLInputElement>('input[type="text"]:not(:disabled)'),
  );
  const currentIndex = inputs.indexOf(current);
  if (currentIndex === -1) return;
  const next = inputs[currentIndex + 1];
  next?.focus();
  next?.select();
};

const focusPreviousEditableInput = (current: HTMLInputElement) => {
  const inputs = Array.from(
    document.querySelectorAll<HTMLInputElement>('input[type="text"]:not(:disabled)'),
  );
  const currentIndex = inputs.indexOf(current);
  if (currentIndex <= 0) return;
  const previous = inputs[currentIndex - 1];
  previous?.focus();
  previous?.select();
};

const handleVerticalArrowNavigation = (event: React.KeyboardEvent<HTMLInputElement>) => {
  if (event.key === "ArrowDown") {
    event.preventDefault();
    focusNextEditableInput(event.currentTarget);
    return true;
  }
  if (event.key === "ArrowUp") {
    event.preventDefault();
    focusPreviousEditableInput(event.currentTarget);
    return true;
  }
  return false;
};

const formatDate = (dateString: string) => {
  const date = dateString.includes("T")
    ? new Date(dateString)
    : new Date(`${dateString}T00:00:00`);
  return date.toLocaleDateString("de-DE", {
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
  });
};

type ChangeLogEntry = {
  id: string;
  timestamp: string;
  message: string;
};

const formatLevelLabel = (level: PlanningNode["level"]) => {
  switch (level) {
    case "Total":
      return "Gesamt";
    case "Segment":
      return "Segment";
    case "Family":
      return "Familie";
    case "Class":
      return "Klasse";
    case "Brick":
      return "Artikel";
    default:
      return level;
  }
};

const levelBadgeClassName = (_level: PlanningNode["level"]) =>
  "border-slate-300 bg-slate-50 text-slate-700";
const fastTabHeaderClassName =
  "flex h-12 w-full items-center justify-between border-b bg-muted/20 px-4 py-0 text-left text-sm font-semibold uppercase tracking-wide";
const fastTabChevronClassName = "h-4 w-4 shrink-0 text-muted-foreground";

const InfoFieldLabel = ({
  label,
  description,
}: {
  label: string;
  description: string;
}) => (
  <span className="inline-flex items-center gap-1">
    {label}
    <Tooltip>
      <TooltipTrigger asChild>
        <button
          type="button"
          className="inline-flex h-4 w-4 items-center justify-center rounded-full border border-border text-[10px] text-muted-foreground"
          aria-label={`Info zu ${label}`}
        >
          i
        </button>
      </TooltipTrigger>
      <TooltipContent side="top" className="max-w-72">
        {description}
      </TooltipContent>
    </Tooltip>
  </span>
);

const NodeDetailItem = ({
  label,
  value,
  numeric = false,
}: {
  label: string;
  value: string;
  numeric?: boolean;
}) => (
  <div className="space-y-1">
    <p className="text-xs font-semibold uppercase tracking-wide text-muted-foreground">
      {label}
    </p>
    <p className={`text-2xl leading-none text-foreground ${numeric ? "font-mono" : ""}`}>
      {value}
    </p>
  </div>
);

export default function Workspace() {
  const navigate = useNavigate();
  const deletePlan = usePlanStore((state) => state.deletePlan);
  const updatePlanMetadata = usePlanStore((state) => state.updatePlanMetadata);
  const setPlanStatus = usePlanStore((state) => state.setPlanStatus);
  const createPlanningDocument = usePlanStore(
    (state) => state.createPlanningDocument,
  );
  const releasePlanningDocument = usePlanStore(
    (state) => state.releasePlanningDocument,
  );
  const reopenPlanningDocument = usePlanStore(
    (state) => state.reopenPlanningDocument,
  );
  const exportApprovedPlan = usePlanStore((state) => state.exportApprovedPlan);
  const importComparisonData = usePlanStore(
    (state) => state.importComparisonData,
  );
  const distributeTopDown = usePlanStore((state) => state.distributeTopDown);
  const convertPlanCurrency = usePlanStore((state) => state.convertPlanCurrency);
  const updatePlanningSettings = usePlanStore((state) => state.updatePlanningSettings);
  const commitPlanToApi = usePlanStore((state) => state.commitPlanToApi);
  const refreshPlanFromApi = usePlanStore((state) => state.refreshPlanFromApi);
  const { planId } = useParams();
  const [isNavigating, setIsNavigating] = useState(false);
  const [isDetailsDrawerOpen, setIsDetailsDrawerOpen] = useState(false);
  const [lockedPercentNodeIds, setLockedPercentNodeIds] = useState<Set<string>>(
    () => new Set(),
  );
  const [currencyCode, setCurrencyCode] = useState<CurrencyCode>("EUR");
  const [conversionFactorInput, setConversionFactorInput] = useState("1.00");
  const [roundingMode, setRoundingMode] = useState<RoundingMode>("commercial");
  const [roundingPrecisionMoney, setRoundingPrecisionMoney] = useState(2);
  const [roundingPrecisionPhysical, setRoundingPrecisionPhysical] = useState(3);
  const [enforcePercentPlanning, setEnforcePercentPlanning] = useState(true);
  const [showDeleteDialog, setShowDeleteDialog] = useState(false);
  const [showEditDialog, setShowEditDialog] = useState(false);
  const [editPlanName, setEditPlanName] = useState("");
  const [editDescription, setEditDescription] = useState("");
  const [editComparisonYear, setEditComparisonYear] = useState("");
  const handleDelete = () => {
    if (planId) {
      deletePlan(planId);
      setIsNavigating(true);
      setShowDeleteDialog(false);
      navigate("/", { replace: true });
    }
  };
  const handleInReview = () => {
    if (planId) {
      const result = setPlanStatus(planId, "InReview");
      if (!result.ok) {
        toast.error(result.error.message);
      }
    }
  };
  const handleRemoveFromReview = () => {
    if (planId) {
      const result = setPlanStatus(planId, "Draft");
      if (!result.ok) {
        toast.error(result.error.message);
      }
    }
  };
  const handleCreatePlanningDocument = () => {
    if (!planId) return;
    const result = createPlanningDocument(planId);
    if (!result.ok) {
      toast.error(result.error.message);
      return;
    }
    toast.success("Planungsdokument, Ebenen und Buffer wurden erzeugt.");
  };
  const handleReleasePlanningDocument = () => {
    if (!planId) return;
    const result = releasePlanningDocument(planId);
    if (!result.ok) {
      toast.error(result.error.message);
      return;
    }
    toast.success("Planungsdokument wurde freigegeben.");
  };
  const handleReopenPlanningDocument = () => {
    if (!planId) return;
    const result = reopenPlanningDocument(planId);
    if (!result.ok) {
      toast.error(result.error.message);
      return;
    }
    toast.success("Planungsdokument ist wieder im Entwurf.");
  };
  const handleExportPlan = () => {
    if (!planId) return;

    const exportPlan = exportApprovedPlan(planId);
    if (!exportPlan.ok) {
      toast.error(exportPlan.error.message);
      return;
    }

    const blob = new Blob([JSON.stringify(exportPlan.data, null, 2)], {
      type: "application/json",
    });
    const url = URL.createObjectURL(blob);
    const link = document.createElement("a");
    const safeName =
      exportPlan.data.document.planName
        ?.replace(/\s+/g, "-")
        .replace(/[^a-zA-Z0-9-_]/g, "") || "plan";
    link.href = url;
    link.download = `${safeName}-${exportPlan.data.document.planId}.json`;
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
    URL.revokeObjectURL(url);

    toast.success("Export wurde heruntergeladen.");
  };
  const handleImportComparisonData = () => {
    if (!planId || !obj?.document.comparisonYear) {
      toast.error("Kein Vergleichsjahr gesetzt.");
      return;
    }

    const imported = importComparisonData(planId, obj.document.comparisonYear);
    if (!imported.ok) {
      toast.error(imported.error.message);
      return;
    }

    toast.success(
      `Vergleichsdaten aus ${obj.document.comparisonYear} wurden importiert.`,
    );
  };
  const handleApplyCurrencyConversion = async () => {
    if (!planId || !obj) return;
    const sourceCurrency = (obj.document.currencyCode ?? "EUR") as CurrencyCode;
    const targetCurrency = currencyCode;
    if (sourceCurrency === targetCurrency) {
      toast.message("Quell- und Zielwährung sind identisch.");
      return;
    }

    let factor = 0;
    try {
      factor = await fetchFxRate(sourceCurrency, targetCurrency);
      setConversionFactorInput(
        new Intl.NumberFormat("en-US", {
          minimumFractionDigits: 2,
          maximumFractionDigits: 6,
        }).format(factor),
      );
    } catch {
      toast.error("Live-Wechselkurs konnte nicht geladen werden.");
      return;
    }

    const result = convertPlanCurrency(planId, currencyCode, factor);
    if (!result.ok) {
      toast.error(result.error.message);
      return;
    }
    toast.success(
      `Planwerte wurden von ${sourceCurrency} nach ${targetCurrency} umgerechnet.`,
    );
  };
  const handleFullscreenToggle = async () => {
    try {
      if (!document.fullscreenElement) {
        await document.documentElement.requestFullscreen();
        setIsFullscreen(true);
      } else {
        await document.exitFullscreen();
        setIsFullscreen(false);
      }
    } catch {
      toast.error("Fullscreen konnte nicht aktiviert werden.");
    }
  };
  const allPlans = usePlanStore((state) => state.allPlans);
  const updateNodeMonthlyPlanValue = usePlanStore(
    (state) => state.updateNodeMonthlyPlanValue,
  );
  const updateNodeBatchMonthlyPlanValues = usePlanStore(
    (state) => state.updateNodeBatchMonthlyPlanValues,
  );
  const obj = allPlans.find((p) => p.document.planId === planId);
  useEffect(() => {
    if (!obj) return;
    setCurrencyCode((obj.document.currencyCode ?? "EUR") as CurrencyCode);
    setRoundingMode((obj.document.roundingMode ?? DEFAULT_ROUNDING_MODE) as RoundingMode);
    setRoundingPrecisionMoney(obj.document.roundingPrecisionMoney ?? DEFAULT_MONEY_PRECISION);
    setRoundingPrecisionPhysical(
      obj.document.roundingPrecisionPhysical ?? DEFAULT_PHYSICAL_PRECISION,
    );
  }, [obj?.document.planId]);
  const planningPeriod = obj
    ? resolvePlanningPeriod(obj.document.planningPeriod, obj.document.fiscalYear)
    : undefined;
  const referencePeriod = obj
    ? resolvePlanningPeriod(
        obj.document.referencePeriod,
        obj.document.comparisonYear,
      )
    : undefined;

  const openEditDialog = () => {
    if (!obj) return;
    setEditPlanName(obj.document.planName ?? "");
    setEditDescription(obj.document.description ?? "");
    setEditComparisonYear(obj.document.comparisonYear ?? "");
    setShowEditDialog(true);
  };

  const handleSaveEdit = () => {
    if (!planId) return;
    const result = updatePlanMetadata(planId, {
      planName: editPlanName,
      description: editDescription,
      comparisonYear: editComparisonYear,
    });
    if (!result.ok) {
      toast.error(result.error.message);
      return;
    }
    toast.success("Plan-Metadaten wurden gespeichert.");
    setShowEditDialog(false);
  };
  const handleEditDialogKeyDown = (
    event: KeyboardEvent<HTMLInputElement>,
  ) => {
    if (event.key === "Enter") {
      event.preventDefault();
      handleSaveEdit();
      return;
    }
    if (event.key === "Escape") {
      event.preventDefault();
      setShowEditDialog(false);
    }
  };

  const rootNodes = obj
    ? obj.aggregateTotal
      ? [
          {
            id: obj.aggregateTotal.id,
            level: "Total" as const,
            name: obj.aggregateTotal.name,
            metrics: obj.aggregateTotal.metrics,
            monthlyValues: obj.aggregateTotal.monthlyValues,
            children: obj.data,
          },
        ]
      : obj.data
    : [];

  const [expandedNodes, setExpandedNodes] = useState<Set<string>>(
    () => new Set(),
  );
  const [monthlyShareDrafts, setMonthlyShareDrafts] = useState<
    Record<string, string>
  >({});
  const [monthlyPlanDrafts, setMonthlyPlanDrafts] = useState<
    Record<string, string>
  >({});
  const [totalShareDrafts, setTotalShareDrafts] = useState<
    Record<string, string>
  >({});
  const [totalPlanDrafts, setTotalPlanDrafts] = useState<Record<string, string>>(
    {},
  );
  const [inputErrors, setInputErrors] = useState<Record<string, string>>({});
  const [showHeaderFastTab, setShowHeaderFastTab] = useState(true);
  const [showPositionsFastTab, setShowPositionsFastTab] = useState(true);
  const [showDetailFastTab, setShowDetailFastTab] = useState(false);
  const [distributionType, setDistributionType] =
    useState<PlanningDistributionType>("PlanValues");
  const [isMonthlyViewActive, setIsMonthlyViewActive] = useState(false);
  const monthlyCloseTimeoutRef = useRef<number | null>(null);
  const initializedPlanIdRef = useRef<string | null>(null);
  const [selectedMonthlyNodeId, setSelectedMonthlyNodeId] = useState<
    string | null
  >(null);
  const [selectedNodeId, setSelectedNodeId] = useState<string | null>(null);
  const [isFullscreen, setIsFullscreen] = useState(false);
  const [showHelpPanel, setShowHelpPanel] = useState(false);
  const [changeLog, setChangeLog] = useState<ChangeLogEntry[]>([]);
  const [showAllChangeLog, setShowAllChangeLog] = useState(false);

  useEffect(() => {
    return () => {
      if (monthlyCloseTimeoutRef.current !== null) {
        window.clearTimeout(monthlyCloseTimeoutRef.current);
      }
    };
  }, []);

  useEffect(() => {
    const onFullscreenChange = () => {
      setIsFullscreen(Boolean(document.fullscreenElement));
    };
    document.addEventListener("fullscreenchange", onFullscreenChange);
    return () => {
      document.removeEventListener("fullscreenchange", onFullscreenChange);
    };
  }, []);

  useEffect(() => {
    if (!obj) return;
    const isPlanSwitch = initializedPlanIdRef.current !== obj.document.planId;
    if (isPlanSwitch) {
      initializedPlanIdRef.current = obj.document.planId;
      setExpandedNodes(new Set());
      setMonthlyShareDrafts({});
      setMonthlyPlanDrafts({});
      setTotalShareDrafts({});
      setTotalPlanDrafts({});
      setInputErrors({});
      setShowPositionsFastTab(true);
      setDistributionType(obj.document.runtime?.distributionType ?? "PlanValues");
      setIsMonthlyViewActive(false);
      setSelectedMonthlyNodeId(null);
      setSelectedNodeId(null);
      setShowAllChangeLog(false);
      if (monthlyCloseTimeoutRef.current !== null) {
        window.clearTimeout(monthlyCloseTimeoutRef.current);
        monthlyCloseTimeoutRef.current = null;
      }
      return;
    }

    // Keep the current UI context stable after recalculation/saving within the same plan.
    setDistributionType(obj.document.runtime?.distributionType ?? "PlanValues");
  }, [obj]);

  if (isNavigating) return null;
  if (!obj) {
    return (
      <div className="container mx-auto py-8">
        <h1 className="text-2xl font-bold">Plan wurde nicht gefunden.</h1>
      </div>
    );
  }

  const toggleNode = (nodeId: string) => {
    setExpandedNodes((prev) => {
      const next = new Set(prev);
      if (next.has(nodeId)) {
        next.delete(nodeId);
      } else {
        next.add(nodeId);
      }
      return next;
    });
  };

  const collectExpandableNodeIds = (nodes: PlanningNode[]): string[] => {
    const ids: string[] = [];
    const walk = (entries: PlanningNode[]) => {
      entries.forEach((node) => {
        if (node.children?.length) {
          ids.push(node.id);
          walk(node.children);
        }
      });
    };
    walk(nodes);
    return ids;
  };

  const expandAllNodes = () => {
    setExpandedNodes(new Set(collectExpandableNodeIds(rootNodes)));
  };

  const collapseAllNodes = () => {
    setExpandedNodes(new Set());
  };

  const openMonthlyView = (nodeId: string) => {
    if (monthlyCloseTimeoutRef.current !== null) {
      window.clearTimeout(monthlyCloseTimeoutRef.current);
      monthlyCloseTimeoutRef.current = null;
    }
    setSelectedMonthlyNodeId(nodeId);
    setIsMonthlyViewActive(true);
  };

  const closeMonthlyView = () => {
    setIsMonthlyViewActive(false);
    if (monthlyCloseTimeoutRef.current !== null) {
      window.clearTimeout(monthlyCloseTimeoutRef.current);
    }
    monthlyCloseTimeoutRef.current = window.setTimeout(() => {
      setSelectedMonthlyNodeId(null);
      monthlyCloseTimeoutRef.current = null;
    }, 280);
  };

  const getMonthlyPlanValue = (node: PlanningNode, date: string): number => {
    return (
      node.monthlyValues.find((entry) => entry.date === date)
        ?.planSalesAmount ?? 0
    );
  };

  const getMonthlyRefValue = (node: PlanningNode, date: string): number => {
    return (
      node.monthlyValues.find((entry) => entry.date === date)?.refSalesAmount ??
      0
    );
  };

  const getMonthlyRefShare = (node: PlanningNode, date: string): number => {
    const refTotal = node.metrics.refSalesAmount;
    if (refTotal === 0) {
      return 0;
    }

    return (getMonthlyRefValue(node, date) / refTotal) * 100;
  };

  const getEffectivePlanTotal = (node: PlanningNode): number => {
    return node.monthlyValues.reduce(
      (sum, month) => sum + month.planSalesAmount,
      0,
    );
  };

  const hasPendingChanges =
    Object.keys(totalPlanDrafts).length > 0 ||
    Object.keys(totalShareDrafts).length > 0 ||
    Object.keys(monthlyPlanDrafts).length > 0 ||
    Object.keys(monthlyShareDrafts).length > 0;

  const setFieldError = (key: string, message: string) => {
    setInputErrors((prev) => ({ ...prev, [key]: message }));
  };

  const clearFieldError = (key: string) => {
    setInputErrors((prev) => {
      if (!(key in prev)) return prev;
      const next = { ...prev };
      delete next[key];
      return next;
    });
  };

  const updateMonthlyPlan = (
    nodeId: string,
    date: string,
    value: string,
    skipApiSync = false,
  ) => {
    if (!value.trim() || !isValidNumericInput(value)) {
      return;
    }
    const parsed = parsePlanInput(value);
    // The aggregate root is not part of plan.data. Distribute root monthly edits to first-level children.
    if (obj.aggregateTotal && nodeId === obj.aggregateTotal.id) {
      const children = obj.data;
      if (!children.length) {
        return;
      }
      const target = asPlannedAmount(Number.isFinite(parsed) ? parsed : 0);
      const siblingTotal = children.reduce(
        (sum, child) => sum + getMonthlyPlanValue(child, date),
        0,
      );

      let remainder = target;
      for (let index = 0; index < children.length; index += 1) {
        const child = children[index];
        const childCurrent = getMonthlyPlanValue(child, date);
        const distributedValue =
          index === children.length - 1
            ? remainder
            : Math.min(
                remainder,
                Math.round(
                  target *
                    (siblingTotal > 0
                      ? childCurrent / siblingTotal
                      : 1 / children.length),
                ),
              );
        remainder -= distributedValue;
        const result = updateNodeMonthlyPlanValue(
          obj.document.planId,
          child.id,
          date,
          distributedValue,
          skipApiSync,
        );
        if (!result.ok) {
          toast.error(result.error.message);
          return;
        }
      }
      return;
    }

    const result = updateNodeMonthlyPlanValue(
      obj.document.planId,
      nodeId,
      date,
      Number.isFinite(parsed) ? parsed : 0,
      skipApiSync,
    );
    if (!result.ok) {
      toast.error(result.error.message);
    }
  };

  const updateMonthlyPlanDraft = (nodeId: string, date: string, value: string) => {
    const key = `${nodeId}-${date}`;
    clearFieldError(`monthly-plan-${key}`);
    setMonthlyPlanDrafts((prev) => ({
      ...prev,
      [key]: value,
    }));
  };

  const commitMonthlyPlanDraft = (
    nodeId: string,
    date: string,
    applyNow = false,
  ) => {
    const key = `${nodeId}-${date}`;
    const draftValue = monthlyPlanDrafts[key];
    if (draftValue === undefined) {
      return;
    }
    if (!draftValue.trim() || !isValidNumericInput(draftValue)) {
      setFieldError(`monthly-plan-${key}`, "Bitte gueltige Zahl eingeben.");
      return;
    }

    if (applyNow) {
      updateMonthlyPlan(nodeId, date, draftValue);
      setMonthlyPlanDrafts((prev) => {
        const next = { ...prev };
        delete next[key];
        return next;
      });
    }
    clearFieldError(`monthly-plan-${key}`);
  };

  const updateMonthlyShareDraft = (
    nodeId: string,
    date: string,
    value: string,
  ) => {
    const key = `${nodeId}-${date}`;
    clearFieldError(`monthly-share-${key}`);
    setMonthlyShareDrafts((prev) => ({
      ...prev,
      [key]: value,
    }));
  };

  const commitMonthlyShareDraft = (
    nodeId: string,
    date: string,
    currentTotal: number,
    fallbackTotal: number,
    applyNow = false,
  ) => {
    const key = `${nodeId}-${date}`;
    const draftValue = monthlyShareDrafts[key];
    if (draftValue === undefined) {
      return;
    }
    if (!draftValue.trim() || !isValidNumericInput(draftValue)) {
      setFieldError(`monthly-share-${key}`, "Bitte gueltige Zahl eingeben.");
      return;
    }

    const share = parsePlanInput(draftValue);
    const baseTotal = currentTotal > 0 ? currentTotal : fallbackTotal;
    const nextPlanValue = asPlannedAmount((baseTotal * share) / 100);
    if (applyNow) {
      updateMonthlyPlan(nodeId, date, String(nextPlanValue));
      setMonthlyPlanDrafts((prev) => {
        const next = { ...prev };
        delete next[key];
        return next;
      });
      setMonthlyShareDrafts((prev) => {
        const next = { ...prev };
        delete next[key];
        return next;
      });
    } else {
      // Keep % draft visible until the user confirms all pending changes via "Aktualisieren".
      setMonthlyPlanDrafts((prev) => {
        const next = { ...prev };
        delete next[key];
        return next;
      });
    }
    clearFieldError(`monthly-share-${key}`);
  };

  const updateTotalPlan = (
    node: PlanningNode,
    value: string,
    skipApiSync = false,
  ): boolean => {
    if (!value.trim() || !isValidNumericInput(value)) {
      return false;
    }
    const parsed = parsePlanInput(value);
    const monthCount = node.monthlyValues.length;
    if (monthCount === 0) {
      return false;
    }

    // The aggregate root is not part of plan.data. Distribute root total edits to first-level children.
    if (obj.aggregateTotal && node.id === obj.aggregateTotal.id) {
      const children = obj.data;
      if (!children.length) {
        return false;
      }
      const targetTotal = asPlannedAmount(parsed);
      const siblingTotal = children.reduce(
        (sum, child) => sum + getEffectivePlanTotal(child),
        0,
      );
      let remainder = targetTotal;
      for (let index = 0; index < children.length; index += 1) {
        const child = children[index];
        const childCurrent = getEffectivePlanTotal(child);
        const distributedValue =
          index === children.length - 1
            ? remainder
            : Math.min(
                remainder,
                Math.round(
                  targetTotal *
                    (siblingTotal > 0
                      ? childCurrent / siblingTotal
                      : 1 / children.length),
                ),
              );
        remainder -= distributedValue;
        const ok = updateTotalPlan(child, String(distributedValue), skipApiSync);
        if (!ok) {
          return false;
        }
      }
      return true;
    }

    const currentMonthlyTotal = node.monthlyValues.reduce(
      (sum, month) => sum + month.planSalesAmount,
      0,
    );
    const nextTotal = asPlannedAmount(parsed);
    let remainder = nextTotal;

    const updates = node.monthlyValues.map((month, index) => {
      const monthWeight =
        currentMonthlyTotal > 0
          ? month.planSalesAmount / currentMonthlyTotal
          : 1 / monthCount;
      const distributedValue =
        index === monthCount - 1
          ? remainder
          : Math.min(remainder, Math.round(nextTotal * monthWeight));
      remainder -= distributedValue;

      return {
        date: month.date,
        planSalesAmount: distributedValue,
      };
    });

    const result = updateNodeBatchMonthlyPlanValues(
      obj.document.planId,
      node.id,
      updates,
      skipApiSync,
    );
    if (!result.ok) {
      toast.error(result.error.message);
      return false;
    }
    return true;
  };

  const applyTopDownTargetToChildren = (
    node: PlanningNode,
    targetTotal: number,
    skipApiSync = false,
  ): boolean => {
    if (!node.children?.length) {
      return updateTotalPlan(node, String(targetTotal), skipApiSync);
    }

    const monthCount = node.monthlyValues.length;
    if (monthCount === 0) return false;

    const parentMonthlyTarget: number[] = [];
    let remainder = asPlannedAmount(targetTotal);
    const currentParentTotal = node.monthlyValues.reduce(
      (sum, month) => sum + month.planSalesAmount,
      0,
    );

    node.monthlyValues.forEach((month, index) => {
      const weight =
        currentParentTotal > 0
          ? month.planSalesAmount / currentParentTotal
          : 1 / monthCount;
      const value =
        index === monthCount - 1
          ? remainder
          : Math.min(remainder, Math.round(targetTotal * weight));
      remainder -= value;
      parentMonthlyTarget.push(value);
    });

    for (const child of node.children) {
      const childCurrentTotal = child.monthlyValues.reduce(
        (sum, month) => sum + month.planSalesAmount,
        0,
      );
      const siblingTotal = node.children!.reduce(
        (sum, sibling) =>
          sum +
          sibling.monthlyValues.reduce((inner, month) => inner + month.planSalesAmount, 0),
        0,
      );
      const childTargetTotal =
        siblingTotal > 0
          ? Math.round((targetTotal * childCurrentTotal) / siblingTotal)
          : Math.round(targetTotal / node.children!.length);

      // If the child has descendants, push the target deeper so roll-up keeps it.
      if (child.children?.length) {
        const ok = applyTopDownTargetToChildren(
          child,
          childTargetTotal,
          skipApiSync,
        );
        if (!ok) {
          return false;
        }
        continue;
      }

      const updates: Array<{ date: string; planSalesAmount: number }> = [];
      let childRemainder = Math.max(0, childTargetTotal);

      child.monthlyValues.forEach((month, index) => {
        const monthBase = parentMonthlyTarget[index] ?? 0;
        const value =
          index === child.monthlyValues.length - 1
            ? childRemainder
            : Math.min(
                childRemainder,
                Math.round(
                  monthBase *
                    (childCurrentTotal > 0
                      ? month.planSalesAmount / childCurrentTotal
                      : 1 / child.monthlyValues.length),
                ),
              );
        childRemainder -= value;
        updates.push({ date: month.date, planSalesAmount: value });
      });

      const result = updateNodeBatchMonthlyPlanValues(
        obj.document.planId,
        child.id,
        updates,
        skipApiSync,
      );
      if (!result.ok) {
        toast.error(result.error.message);
        return false;
      }
    }
    return true;
  };

  const updateTotalPlanDraft = (nodeId: string, value: string) => {
    clearFieldError(`total-plan-${nodeId}`);
    setTotalPlanDrafts((prev) => ({
      ...prev,
      [nodeId]: value,
    }));
  };

  const commitTotalPlanDraft = (node: PlanningNode, applyNow = false) => {
    const draftValue = totalPlanDrafts[node.id];
    if (draftValue === undefined) {
      return;
    }
    if (!draftValue.trim() || !isValidNumericInput(draftValue)) {
      setFieldError(`total-plan-${node.id}`, "Bitte gueltige Zahl eingeben.");
      return;
    }

    if (applyNow) {
      updateTotalPlan(node, draftValue);
      setTotalPlanDrafts((prev) => {
        const next = { ...prev };
        delete next[node.id];
        return next;
      });
    }
    clearFieldError(`total-plan-${node.id}`);
  };

  const handleTopDown = (node: PlanningNode) => {
    if (!node.children?.length) {
      return;
    }

    const result = distributeTopDown(obj.document.planId, node.id, distributionType);
    if (!result.ok) {
      toast.error(result.error.message);
      return;
    }
    toast.success(
      distributionType === "ReferenceValues"
        ? "Top-down wurde nach Referenzwerten verteilt."
        : "Top-down wurde nach Planwerten verteilt.",
    );
  };

  const updateTotalShareDraft = (nodeId: string, value: string) => {
    clearFieldError(`total-share-${nodeId}`);
    setTotalShareDrafts((prev) => ({
      ...prev,
      [nodeId]: value,
    }));
  };

  const commitTotalShareDraft = (node: PlanningNode, applyNow = false) => {
    const draftValue = totalShareDrafts[node.id];
    if (draftValue === undefined) {
      return;
    }

    if (!draftValue.trim() || !isValidNumericInput(draftValue)) {
      setFieldError(`total-share-${node.id}`, "Bitte gueltige Zahl eingeben.");
      return;
    }

    const share = parsePlanInput(draftValue);
    const nextTotal = Math.max(
      0,
      asPlannedAmount((node.metrics.refSalesAmount * share) / 100),
    );
    if (applyNow) {
      updateTotalPlan(node, String(nextTotal));
      setTotalPlanDrafts((prev) => {
        const next = { ...prev };
        delete next[node.id];
        return next;
      });
      setTotalShareDrafts((prev) => {
        const next = { ...prev };
        delete next[node.id];
        return next;
      });
    } else {
      // Keep % draft visible until "Aktualisieren"; calculation happens in applyPendingChanges.
      setTotalPlanDrafts((prev) => {
        const next = { ...prev };
        delete next[node.id];
        return next;
      });
    }
    clearFieldError(`total-share-${node.id}`);
  };

  const applyPendingChanges = async () => {
    if (obj.document.status === "Approved") {
      toast.error("Freigegebene Pläne können nicht bearbeitet werden.");
      return;
    }

    const logs: ChangeLogEntry[] = [];
    const now = new Date();
    const timestamp = now.toLocaleTimeString("de-DE", {
      hour: "2-digit",
      minute: "2-digit",
      second: "2-digit",
    });

    // 1) Convert pending % drafts into pending absolute plan drafts first.
    const normalizedTotalPlanDrafts: Record<string, string> = { ...totalPlanDrafts };
    Object.entries(totalShareDrafts).forEach(([nodeId, draftPercent]) => {
      const node = getNodeById(nodeId);
      if (!node || !draftPercent.trim() || !isValidNumericInput(draftPercent)) return;
      const share = parsePlanInput(draftPercent);
      const nextTotal = Math.max(
        0,
        asPlannedAmount((node.metrics.refSalesAmount * share) / 100),
      );
      normalizedTotalPlanDrafts[nodeId] = String(nextTotal);
    });

    // If both parent and child totals are edited, keep the deeper (more specific) node edit.
    // This avoids parent/child overwrite loops in the same apply cycle.
    const totalDraftNodeIds = new Set(Object.keys(normalizedTotalPlanDrafts));
    totalDraftNodeIds.forEach((nodeId) => {
      const ancestors = getAncestorIds(nodeId);
      ancestors.forEach((ancestorId) => {
        if (totalDraftNodeIds.has(ancestorId)) {
          delete normalizedTotalPlanDrafts[ancestorId];
        }
      });
    });

    const normalizedMonthlyPlanDrafts: Record<string, string> = { ...monthlyPlanDrafts };

    Object.entries(normalizedTotalPlanDrafts).forEach(([nodeId, value]) => {
      const node = getNodeById(nodeId);
      if (!node) return;
      const before = getEffectivePlanTotal(node);
      const applied = applyTopDownTargetToChildren(
        node,
        parsePlanInput(value),
        true,
      );
      if (!applied) {
        return;
      }
      logs.push({
        id: `${node.id}-total-${timestamp}`,
        timestamp,
        message: `${node.name}: VK Plan ${formatPlanNumber(before)} → ${formatPlanNumber(parsePlanInput(value))}`,
      });
    });

    rootNodes.forEach((root) => {
      const walk = (node: PlanningNode) => {
        node.monthlyValues.forEach((month) => {
          const key = `${node.id}-${month.date}`;
          const draftPercent = monthlyShareDrafts[key];
          if (draftPercent !== undefined && draftPercent.trim() && isValidNumericInput(draftPercent)) {
            const share = parsePlanInput(draftPercent);
            const currentTotal = getEffectivePlanTotal(node);
            const baseTotal = currentTotal > 0 ? currentTotal : node.metrics.planSalesAmount;
            const nextPlanValue = asPlannedAmount((baseTotal * share) / 100);
            normalizedMonthlyPlanDrafts[key] = String(nextPlanValue);
          }
          const draft = normalizedMonthlyPlanDrafts[key];
          if (draft !== undefined) {
            const before = getMonthlyPlanValue(node, month.date);
            updateMonthlyPlan(node.id, month.date, draft, true);
            logs.push({
              id: `${node.id}-${month.date}-${timestamp}`,
              timestamp,
              message: `${node.name} ${month.date}: ${formatPlanNumber(before)} → ${formatPlanNumber(parsePlanInput(draft))}`,
            });
          }
        });
        node.children?.forEach(walk);
      };
      walk(root);
    });

    setTotalPlanDrafts({});
    setTotalShareDrafts({});
    setMonthlyPlanDrafts({});
    setMonthlyShareDrafts({});
    if (logs.length > 0) {
      const commitResult = await commitPlanToApi(obj.document.planId);
      if (!commitResult.ok) {
        const refreshResult = await refreshPlanFromApi(obj.document.planId);
        if (!refreshResult.ok) {
          toast.error("Speichern fehlgeschlagen. Bitte Seite neu laden.");
          return;
        }
        toast.error(
          "Speichern fehlgeschlagen (Versionskonflikt). Serverstand wurde neu geladen.",
        );
        return;
      }
      setChangeLog((prev) => [...logs.slice(-20), ...prev].slice(0, 100));
      toast.success("Änderungen wurden übernommen.");
    } else {
      toast.message("Keine Änderungen zum Übernehmen.");
    }
  };

  const renderNodeRows = (node: PlanningNode, depth = 0): ReactNode[] => {
    const hasChildren = Boolean(node.children?.length);
    const canExpand = hasChildren;
    const isExpanded = expandedNodes.has(node.id);
    const effectivePlanTotal = getEffectivePlanTotal(node);
    const effectivePlanShare =
      node.metrics.refSalesAmount === 0
        ? 0
        : (effectivePlanTotal / node.metrics.refSalesAmount) * 100;
    const totalShareInputValue =
      totalShareDrafts[node.id] ?? formatPercent(effectivePlanShare);
    const totalPlanInputValue = totalPlanDrafts[node.id] ?? String(effectivePlanTotal);
    const totalPlanFieldKey = `total-plan-${node.id}`;
    const totalShareFieldKey = `total-share-${node.id}`;
    const totalPlanError = inputErrors[totalPlanFieldKey];
    const totalShareError = inputErrors[totalShareFieldKey];
    const showMonthlyButton = true;
    const treeIndent = depth * 0.85;
    const labelIndent = depth * 0.9;

    const rows: ReactNode[] = [
      <TableRow
        key={node.id}
        className={`h-12 cursor-pointer ${
          selectedNodeId === node.id ? "bg-muted/30" : ""
        }`}
        onClick={() => setSelectedNodeId(node.id)}
      >
        <TableCell className="w-12 pl-2 pr-1 align-middle">
          <div
            className="flex h-6 items-center justify-center"
            style={{ marginLeft: `${treeIndent}rem` }}
          >
            {canExpand ? (
              <button
                type="button"
                onClick={() => toggleNode(node.id)}
                className="inline-flex h-6 w-6 items-center justify-center rounded-sm border border-transparent text-muted-foreground leading-none hover:border-border hover:bg-muted"
                aria-label={
                  isExpanded ? "Knoten einklappen" : "Knoten ausklappen"
                }
              >
                {isExpanded ? (
                  <ChevronDown className="h-4 w-4" />
                ) : (
                  <ChevronRight className="h-4 w-4" />
                )}
              </button>
            ) : (
              <span className="inline-block h-6 w-6" />
            )}
          </div>
        </TableCell>
        <TableCell className="w-[24%] pl-4 font-medium">
          <div className="flex items-center gap-2" style={{ paddingLeft: `${labelIndent}rem` }}>
            <span className="truncate">{node.name}</span>
            <span
              className={`rounded-full border px-2 py-0.5 text-[10px] font-medium uppercase tracking-wide ${levelBadgeClassName(node.level)}`}
            >
              {formatLevelLabel(node.level)}
            </span>
            <button
              type="button"
              className="inline-flex h-6 w-6 items-center justify-center rounded border border-slate-300 text-slate-600 hover:bg-slate-100"
              onClick={(event) => {
                event.stopPropagation();
                setLockedPercentNodeIds((prev) => {
                  const next = new Set(prev);
                  if (next.has(node.id)) {
                    next.delete(node.id);
                    toast.success(`% PLAN für ${node.name} ist entsperrt.`);
                  } else {
                    next.add(node.id);
                    toast.success(`% PLAN für ${node.name} ist gesperrt.`);
                  }
                  return next;
                });
              }}
              title={isPercentLocked(node.id) ? "% PLAN entsperren" : "% PLAN sperren"}
              aria-label={isPercentLocked(node.id) ? "% PLAN entsperren" : "% PLAN sperren"}
            >
              {isPercentLocked(node.id) ? (
                <Lock className="h-3.5 w-3.5" />
              ) : (
                <Unlock className="h-3.5 w-3.5" />
              )}
            </button>
          </div>
        </TableCell>
        <TableCell className="w-[10%] text-right font-mono text-sm">
          {formatPlanNumber(node.metrics.refSalesAmount)}
        </TableCell>
        <TableCell className="w-[10%] text-right font-mono text-sm">
          {formatPercent(100)}
        </TableCell>
        <TableCell className="w-[10%]">
          <div>
            <Input
              type="text"
              inputMode="numeric"
              className={`h-8 bg-transparent px-0 text-right font-mono text-sm text-foreground shadow-none focus-visible:ring-0 disabled:cursor-not-allowed disabled:opacity-60 ${
                totalPlanError
                  ? "border-red-500 focus-visible:border-red-500"
                  : "border-amber-200 bg-amber-50/40 focus-visible:border-amber-300"
              }`}
              value={totalPlanInputValue}
              onChange={(event) => updateTotalPlanDraft(node.id, event.target.value)}
              onBlur={() => commitTotalPlanDraft(node)}
              onKeyDown={(event) => {
                if (handleVerticalArrowNavigation(event)) return;
                if (event.key === "Enter") {
                  event.preventDefault();
                  commitTotalPlanDraft(node);
                  if (event.shiftKey) {
                    focusPreviousEditableInput(event.currentTarget);
                  } else {
                    focusNextEditableInput(event.currentTarget);
                  }
                  return;
                }
                if (event.key === "Escape") {
                  event.preventDefault();
                  clearFieldError(totalPlanFieldKey);
                  setTotalPlanDrafts((prev) => {
                    const next = { ...prev };
                    delete next[node.id];
                    return next;
                  });
                  event.currentTarget.blur();
                  return;
                }
              }}
              disabled={obj.document.status === "Approved" || enforcePercentPlanning}
            />
            {totalPlanError ? (
              <p className="mt-1 text-right text-[11px] text-red-600">{totalPlanError}</p>
            ) : null}
          </div>
        </TableCell>
        <TableCell className="w-[10%]">
          <div>
            <Input
              type="text"
              inputMode="decimal"
              className={`h-8 bg-transparent px-0 text-right text-sm text-foreground shadow-none focus-visible:ring-0 disabled:cursor-not-allowed disabled:opacity-60 ${
                totalShareError
                  ? "border-red-500 focus-visible:border-red-500"
                  : "border-emerald-200 bg-emerald-50/40 focus-visible:border-emerald-300"
              }`}
              value={totalShareInputValue}
              onChange={(event) =>
                updateTotalShareDraft(node.id, event.target.value)
              }
              onBlur={() => commitTotalShareDraft(node)}
              onKeyDown={(event) => {
                if (handleVerticalArrowNavigation(event)) return;
                if (event.key === "Enter") {
                  event.preventDefault();
                  commitTotalShareDraft(node);
                  if (event.shiftKey) {
                    focusPreviousEditableInput(event.currentTarget);
                  } else {
                    focusNextEditableInput(event.currentTarget);
                  }
                  return;
                }
                if (event.key === "Escape") {
                  event.preventDefault();
                  clearFieldError(totalShareFieldKey);
                  setTotalShareDrafts((prev) => {
                    const next = { ...prev };
                    delete next[node.id];
                    return next;
                  });
                  event.currentTarget.blur();
                  return;
                }
              }}
              disabled={isPercentLocked(node.id)}
            />
            {totalShareError ? (
              <p className="mt-1 text-right text-[11px] text-red-600">{totalShareError}</p>
            ) : null}
          </div>
        </TableCell>
        <TableCell className="w-[10%] text-right font-mono text-foreground">
          {formatPercent(
            calculateDelta(node.metrics.refSalesAmount, effectivePlanTotal),
          )}
        </TableCell>
        <TableCell className="w-[10%] pr-6 text-right">
          <div className="hidden justify-end gap-1">
            {hasChildren && (
              <Button
                type="button"
                size="sm"
                variant="outline"
                className="h-9 w-9 p-0"
                onClick={() => handleTopDown(node)}
                disabled={
                  obj.document.status === "Approved" || !obj.document.runtime
                }
                aria-label={`Top-down für ${node.name} verteilen`}
                title="Top-down verteilen"
              >
                <ArrowDownToLine className="h-3.5 w-3.5" />
              </Button>
            )}
            {showMonthlyButton && (
              <Button
                type="button"
                size="sm"
                variant="outline"
                className="h-9 w-9 p-0"
                onClick={() => openMonthlyView(node.id)}
                aria-label={`Monatsansicht für ${node.name} öffnen`}
                title="Monatsansicht"
              >
                <CalendarDays className="h-3.5 w-3.5" />
              </Button>
            )}
          </div>
        </TableCell>
      </TableRow>,
    ];

    if (isExpanded && hasChildren) {
      node.children!.forEach((child) => {
        rows.push(...renderNodeRows(child, depth + 1));
      });
    }

    return rows;
  };

  const getNodeById = (nodeId: string): PlanningNode | null => {
    let found: PlanningNode | null = null;
    const walk = (node: PlanningNode) => {
      if (node.id === nodeId) {
        found = node;
      } else {
        node.children?.forEach(walk);
      }
    };
    rootNodes.forEach(walk);
    return found;
  };

  const getAncestorIds = (nodeId: string): string[] => {
    const parentById = new Map<string, string>();
    const walk = (node: PlanningNode, parentId: string | null) => {
      if (parentId) {
        parentById.set(node.id, parentId);
      }
      node.children?.forEach((child) => walk(child, node.id));
    };
    rootNodes.forEach((root) => walk(root, null));

    const ancestors: string[] = [];
    let cursor = parentById.get(nodeId);
    while (cursor) {
      ancestors.push(cursor);
      cursor = parentById.get(cursor);
    }
    return ancestors;
  };
  const isPercentLocked = (nodeId: string) =>
    obj.document.status === "Approved" || lockedPercentNodeIds.has(nodeId);

  const selectedMonthlyNode = selectedMonthlyNodeId
    ? getNodeById(selectedMonthlyNodeId)
    : null;
  const selectedDrilldownNode = selectedNodeId ? getNodeById(selectedNodeId) : null;
  const selectedDrilldownPlanTotal = selectedDrilldownNode
    ? getEffectivePlanTotal(selectedDrilldownNode)
    : 0;
  const selectedDrilldownPlanPercent = selectedDrilldownNode
    ? selectedDrilldownNode.metrics.refSalesAmount === 0
      ? 0
      : (selectedDrilldownPlanTotal / selectedDrilldownNode.metrics.refSalesAmount) * 100
    : 0;
  const selectedDrilldownDeltaPercent = selectedDrilldownNode
    ? calculateDelta(selectedDrilldownNode.metrics.refSalesAmount, selectedDrilldownPlanTotal)
    : 0;
  const selectedDrilldownChildrenCount = selectedDrilldownNode?.children?.length ?? 0;
  const selectedMonthlyTotal = selectedMonthlyNode
    ? getEffectivePlanTotal(selectedMonthlyNode)
    : 0;
  const selectedDrilldownPath = (() => {
    if (!selectedNodeId) return "";
    const path: string[] = [];
    const walk = (nodes: PlanningNode[], parent: string[]): boolean => {
      for (const node of nodes) {
        const next = [...parent, node.name];
        if (node.id === selectedNodeId) {
          path.push(...next);
          return true;
        }
        if (node.children?.length && walk(node.children, next)) {
          return true;
        }
      }
      return false;
    };
    walk(rootNodes, []);
    return path.join(" > ");
  })();
  const toolbarButtonClass =
    "border-slate-300 text-slate-800 hover:bg-slate-100 focus-visible:ring-0 focus-visible:border-slate-400";
  const toolbarToggleActiveClass =
    "border-slate-400 bg-slate-100 text-slate-900 hover:bg-slate-100 focus-visible:ring-0 focus-visible:border-slate-500";
  const asPlannedAmount = (value: number) =>
    roundNonNegative(value, roundingMode, roundingPrecisionMoney);
  const valuePrecision =
    obj?.document.planningType === "Anzahl"
      ? roundingPrecisionPhysical
      : roundingPrecisionMoney;
  const formatPlanNumber = (value: number) => formatNumber(value, valuePrecision);
  const currencySymbol =
    currencyCode === "EUR"
      ? "€"
      : currencyCode === "USD"
        ? "$"
        : currencyCode === "GBP"
          ? "£"
          : "CHF";
  const renderNodeDetailsPanel = () => (
    <div className="h-full rounded-lg border border-border/80 bg-card">
      <div className="border-b px-5 py-4">
        <p className="text-[28px] font-semibold text-foreground">Ebenendetails</p>
      </div>
      {selectedDrilldownNode ? (
        <div className="space-y-6 px-5 py-5">
          <NodeDetailItem label="Name" value={selectedDrilldownNode.name} />
          <div className="grid grid-cols-2 gap-4">
            <NodeDetailItem
              label="Ebene"
              value={formatLevelLabel(selectedDrilldownNode.level)}
            />
            <NodeDetailItem label="ID" value={selectedDrilldownNode.id} />
          </div>
          <div className="grid grid-cols-2 gap-4">
            <NodeDetailItem
              label="VK VJ"
              value={`${formatPlanNumber(selectedDrilldownNode.metrics.refSalesAmount)} ${currencySymbol}`}
              numeric
            />
            <NodeDetailItem
              label="VK Plan"
              value={`${formatPlanNumber(selectedDrilldownPlanTotal)} ${currencySymbol}`}
              numeric
            />
          </div>
          <div className="grid grid-cols-2 gap-4">
            <NodeDetailItem
              label="% Plan"
              value={formatPercent(selectedDrilldownPlanPercent)}
              numeric
            />
            <NodeDetailItem
              label="Entw. %"
              value={formatPercent(selectedDrilldownDeltaPercent)}
              numeric
            />
          </div>
          <NodeDetailItem
            label="Unterebenen"
            value={String(selectedDrilldownChildrenCount)}
            numeric
          />
          {selectedDrilldownChildrenCount > 0 ? (
            <div className="space-y-2">
              <p className="text-xs font-semibold uppercase tracking-wide text-muted-foreground">
                Verteilung Unterebenen (VK Plan)
              </p>
              <div className="flex items-center gap-3">
                <svg viewBox="0 0 42 42" className="h-28 w-28">
                  {(() => {
                    const children = selectedDrilldownNode.children ?? [];
                    const totals = children.map((child) => ({
                      name: child.name,
                      value: getEffectivePlanTotal(child),
                    }));
                    const sum = totals.reduce((acc, item) => acc + item.value, 0);
                    let start = 0;
                    const colors = ["#2563eb", "#14b8a6", "#f59e0b", "#8b5cf6", "#ef4444", "#10b981"];
                    return totals.map((slice, index) => {
                      const ratio = sum > 0 ? slice.value / sum : 0;
                      const dash = Math.max(0, ratio * 100);
                      const segment = (
                        <circle
                          key={`${slice.name}-${index}`}
                          cx="21"
                          cy="21"
                          r="15.915"
                          fill="transparent"
                          stroke={colors[index % colors.length]}
                          strokeWidth="7"
                          strokeDasharray={`${dash} ${100 - dash}`}
                          strokeDashoffset={-start}
                          transform="rotate(-90 21 21)"
                        />
                      );
                      start += dash;
                      return segment;
                    });
                  })()}
                </svg>
                <div className="space-y-1 text-xs">
                  {(selectedDrilldownNode.children ?? []).slice(0, 6).map((child, index) => {
                    const colors = ["#2563eb", "#14b8a6", "#f59e0b", "#8b5cf6", "#ef4444", "#10b981"];
                    return (
                      <div key={child.id} className="flex items-center gap-2">
                        <span
                          className="inline-block h-2.5 w-2.5 rounded-full"
                          style={{ backgroundColor: colors[index % colors.length] }}
                        />
                        <span className="text-muted-foreground">{child.name}</span>
                      </div>
                    );
                  })}
                </div>
              </div>
            </div>
          ) : null}
        </div>
      ) : (
        <div className="px-5 py-8 text-sm text-muted-foreground">
          Knoten auswählen, um Details zu sehen.
        </div>
      )}
    </div>
  );

  return (
    <div className="flex flex-col h-full">
      <header className="py-4">
        <div className="flex justify-between items-center">
          <div>
            <div className="flex items-center gap-2">
              <h1 className="text-2xl font-bold">{obj.document.planName}</h1>
              <Badge
                variant={
                  obj.document.status === "Approved"
                    ? "outline"
                    : obj.document.status === "InReview"
                      ? "outline"
                      : "secondary"
                }
                className={
                  obj.document.status === "Approved"
                    ? "border-green-400 text-green-700 bg-green-50"
                    : obj.document.status === "InReview"
                      ? "border-orange-400 text-orange-700 bg-orange-50"
                      : undefined
                }
              >
                {obj.document.status === "Approved"
                  ? "Freigegeben"
                  : obj.document.status === "InReview"
                    ? "In Prüfung"
                    : "Entwurf"}
              </Badge>
            </div>
            <p className="mt-1 text-sm text-muted-foreground">
              Plan-ID: {obj.document.planId} | Plantyp:{" "}
              {obj.document.planningType} | Zuletzt bearbeitet:{" "}
              {formatDate(obj.document.lastModified)}
            </p>
            <p className="mt-1 text-xs text-muted-foreground">
              Ausstehende Änderungen:{" "}
              <span className="font-medium text-foreground">
                {Object.keys(totalPlanDrafts).length +
                  Object.keys(totalShareDrafts).length +
                  Object.keys(monthlyPlanDrafts).length +
                  Object.keys(monthlyShareDrafts).length}
              </span>
            </p>
          </div>
          <Dialog open={showDeleteDialog} onOpenChange={setShowDeleteDialog}>
            <DropdownMenu>
              <DropdownMenuTrigger asChild>
                <Button size="icon" variant="outline" aria-label="Aktionen">
                  <MoreVertical className="h-5 w-5" />
                </Button>
              </DropdownMenuTrigger>
              <DropdownMenuContent align="end">
                <DropdownMenuItem
                  onClick={openEditDialog}
                  disabled={obj.document.status === "Approved"}
                >
                  Bearbeiten
                </DropdownMenuItem>
                <DropdownMenuItem
                  onClick={handleCreatePlanningDocument}
                  disabled={obj.document.status === "Approved"}
                >
                  Ebenenstruktur erzeugen
                </DropdownMenuItem>
                {obj.document.status === "Approved" ? (
                  <DropdownMenuItem onClick={handleReopenPlanningDocument}>
                    Planungsdokument wieder öffnen
                  </DropdownMenuItem>
                ) : (
                  <DropdownMenuItem onClick={handleReleasePlanningDocument}>
                    Planungsdokument freigeben
                  </DropdownMenuItem>
                )}
                <DropdownMenuItem
                  onClick={handleExportPlan}
                  disabled={obj.document.status !== "Approved"}
                >
                  Plan als JSON exportieren
                </DropdownMenuItem>
                <DropdownMenuItem
                  onClick={handleImportComparisonData}
                  disabled={obj.document.status === "Approved"}
                >
                  Vergleichsdaten importieren
                </DropdownMenuItem>
                <DropdownMenuSeparator />
                {obj.document.status === "InReview" ? (
                  <DropdownMenuItem onClick={handleRemoveFromReview}>
                    Aus Prüfung entfernen
                  </DropdownMenuItem>
                ) : (
                  <DropdownMenuItem onClick={handleInReview}>
                    Zur Prüfung einreichen
                  </DropdownMenuItem>
                )}
                <DropdownMenuSeparator />
                <DropdownMenuItem
                  variant="destructive"
                  onClick={() => setShowDeleteDialog(true)}
                >
                  Löschen
                </DropdownMenuItem>
              </DropdownMenuContent>
            </DropdownMenu>
            <Dialog open={showEditDialog} onOpenChange={setShowEditDialog}>
              <DialogContent>
                <DialogHeader>
                  <DialogTitle>Plan bearbeiten</DialogTitle>
                  <DialogDescription>
                    Name, Beschreibung und Vergleichsjahr anpassen.
                  </DialogDescription>
                </DialogHeader>
                <div className="space-y-3">
                  <div className="space-y-1">
                    <p className="text-sm font-medium">Planname</p>
                    <Input
                      value={editPlanName}
                      onChange={(event) => setEditPlanName(event.target.value)}
                      onKeyDown={handleEditDialogKeyDown}
                    />
                  </div>
                  <div className="space-y-1">
                    <p className="text-sm font-medium">Beschreibung</p>
                    <Input
                      value={editDescription}
                      onChange={(event) => setEditDescription(event.target.value)}
                      onKeyDown={handleEditDialogKeyDown}
                    />
                  </div>
                  <div className="space-y-1">
                    <p className="text-sm font-medium">Vergleichsjahr</p>
                    <Input
                      value={editComparisonYear}
                      onChange={(event) =>
                        setEditComparisonYear(event.target.value)
                      }
                      onKeyDown={handleEditDialogKeyDown}
                    />
                  </div>
                </div>
                <DialogFooter>
                  <DialogClose asChild>
                    <Button variant="outline">Abbrechen</Button>
                  </DialogClose>
                  <Button onClick={handleSaveEdit}>Speichern</Button>
                </DialogFooter>
              </DialogContent>
            </Dialog>
            <DialogContent>
              <DialogHeader>
                <DialogTitle>Plan wirklich löschen?</DialogTitle>
                <DialogDescription>
                  Dieser Vorgang kann nicht rückgängig gemacht werden. Der Plan
                  wird dauerhaft entfernt.
                </DialogDescription>
              </DialogHeader>
              <DialogFooter>
                <DialogClose asChild>
                  <Button variant="outline">Abbrechen</Button>
                </DialogClose>
                <Button variant="destructive" onClick={handleDelete} autoFocus>
                  Löschen
                </Button>
              </DialogFooter>
            </DialogContent>
          </Dialog>
        </div>
      </header>

      <main
        className={
          isMonthlyViewActive
            ? "flex flex-col pt-3"
            : "flex flex-1 flex-col overflow-hidden pt-3"
        }
      >
        {!isMonthlyViewActive && (
          <div className="sticky top-0 z-20 mb-7 flex items-center justify-end gap-2 shrink-0 bg-background/95 pb-2 backdrop-blur supports-[backdrop-filter]:bg-background/80">
            <div className="flex items-center gap-2">
              <Button
                type="button"
                size="sm"
                variant="outline"
                className="xl:hidden"
                onClick={() => setIsDetailsDrawerOpen(true)}
              >
                Ebenendetails
              </Button>
              <Button
                type="button"
                size="sm"
                variant="outline"
                onClick={() => setShowHelpPanel((current) => !current)}
              >
                <CircleHelp className="mr-1 h-4 w-4" />
                Hilfe
              </Button>
              <Button type="button" size="sm" variant="outline" onClick={handleFullscreenToggle}>
                {isFullscreen ? (
                  <Minimize2 className="mr-1 h-4 w-4" />
                ) : (
                  <Maximize2 className="mr-1 h-4 w-4" />
                )}
                {isFullscreen ? "Exit Fullscreen" : "Fullscreen"}
              </Button>
            </div>
          </div>
        )}

        <div
          className={
            isMonthlyViewActive ? "relative" : "relative flex-1 overflow-hidden"
          }
        >
          {!isMonthlyViewActive && (
            <div className="overflow-y-auto overflow-x-hidden transition-all duration-300 ease-out translate-x-0 opacity-100">
              <div className="space-y-4">
                <section className="rounded-lg border bg-card">
                  <button
                    type="button"
                    className={fastTabHeaderClassName}
                    onClick={() => setShowHeaderFastTab((current) => !current)}
                    aria-expanded={showHeaderFastTab}
                  >
                    <span>Kopfinformationen</span>
                    {showHeaderFastTab ? (
                      <ChevronDown className={fastTabChevronClassName} />
                    ) : (
                      <ChevronRight className={fastTabChevronClassName} />
                    )}
                  </button>
                  {showHeaderFastTab ? (
                    <div className="grid gap-4 p-4 md:grid-cols-3">
                      <div>
                        <p className="text-xs uppercase text-muted-foreground">Plan-ID</p>
                        <p className="font-mono text-sm">{obj.document.planId}</p>
                      </div>
                      <div>
                        <p className="text-xs uppercase text-muted-foreground">Plantyp</p>
                        <p className="text-sm">{obj.document.planningType}</p>
                      </div>
                      <div>
                        <p className="text-xs uppercase text-muted-foreground">Status</p>
                        <p className="text-sm">{obj.document.status === "Approved" ? "Freigegeben" : obj.document.status === "InReview" ? "In Prüfung" : "Entwurf"}</p>
                      </div>
                      <div>
                        <p className="text-xs uppercase text-muted-foreground">Zuletzt bearbeitet</p>
                        <p className="text-sm">{formatDate(obj.document.lastModified)}</p>
                      </div>
                      <div>
                        <p className="text-xs uppercase text-muted-foreground">Geschäftsjahr</p>
                        <p className="text-sm">{obj.document.fiscalYear ?? "-"}</p>
                      </div>
                      <div>
                        <p className="text-xs uppercase text-muted-foreground">Vergleichsjahr</p>
                        <p className="text-sm">{obj.document.comparisonYear ?? "-"}</p>
                      </div>
                    </div>
                  ) : null}
                </section>
                <section className="rounded-lg border bg-card">
                  <button
                    type="button"
                    className={fastTabHeaderClassName}
                    onClick={() => setShowPositionsFastTab((current) => !current)}
                    aria-expanded={showPositionsFastTab}
                  >
                    <span>Positionen</span>
                    {showPositionsFastTab ? (
                      <ChevronDown className={fastTabChevronClassName} />
                    ) : (
                      <ChevronRight className={fastTabChevronClassName} />
                    )}
                  </button>
                  {showPositionsFastTab ? (
                  <div className="flex items-start gap-4 p-4">
                    <div className="min-w-0 flex-1 overflow-hidden rounded-lg border bg-card">
                    <div className="flex flex-wrap items-center justify-between gap-3 border-b bg-muted/20 px-4 py-3">
                      <div className="text-sm">
                        <span className="font-medium">Planungslogik</span>
                        <span className="mx-2 text-muted-foreground">·</span>
                        <span className="text-muted-foreground">
                          {obj.document.runtime
                            ? `${obj.document.runtime.levels.length} Ebenen, ${obj.document.runtime.buffers.length} aktive Buffer`
                            : "Struktur noch nicht erzeugt"}
                        </span>
                        {hasPendingChanges ? (
                          <Badge variant="secondary" className="ml-3">
                            Ungespeicherte Änderungen
                          </Badge>
                        ) : null}
	                      </div>
	                      <div className="flex items-center gap-2">
	                        <Button
                          type="button"
                          size="sm"
                          variant="outline"
                          className={toolbarButtonClass}
                          onClick={applyPendingChanges}
                          disabled={!hasPendingChanges}
                        >
                          Aktualisieren
                        </Button>
                        <Button
                          type="button"
                          size="sm"
                          variant="outline"
                          className={toolbarButtonClass}
                          onClick={expandAllNodes}
                        >
                          Alle aufklappen
                        </Button>
                        <Button
                          type="button"
                          size="sm"
                          variant="outline"
                          className={toolbarButtonClass}
                          onClick={collapseAllNodes}
                        >
                          Alle einklappen
                        </Button>
                        <Button
                          type="button"
                          size="sm"
                          variant="outline"
                          className={
                            distributionType === "PlanValues"
                              ? toolbarToggleActiveClass
                              : toolbarButtonClass
                          }
                          onClick={() => setDistributionType("PlanValues")}
                        >
                          Planwerte
                        </Button>
                        <Button
                          type="button"
                          size="sm"
                          variant="outline"
                          className={
                            distributionType === "ReferenceValues"
                              ? toolbarToggleActiveClass
                              : toolbarButtonClass
                          }
                          onClick={() => setDistributionType("ReferenceValues")}
                        >
	                          Referenzwerte
	                        </Button>
	                      </div>
	                    </div>
	                    <div className="flex flex-wrap items-center gap-2 border-b bg-background px-4 py-2 text-xs">
	                      <span className="font-medium text-foreground">Steuerung</span>
	                      <Button
	                        type="button"
	                        size="sm"
	                        variant="outline"
	                        className={toolbarButtonClass}
	                        onClick={() => setEnforcePercentPlanning((current) => !current)}
	                      >
	                        {enforcePercentPlanning ? "Budgetschutz aktiv (%-Planung)" : "Budgetschutz aus"}
	                      </Button>
	                      <label className="text-muted-foreground">Währung</label>
	                      <select
	                        className="h-7 rounded border border-slate-300 bg-background px-2"
	                        value={currencyCode}
                        onChange={(event) => {
                          const nextCurrency = event.target.value as CurrencyCode;
                          setCurrencyCode(nextCurrency);
                        }}
	                      >
	                        {CURRENCY_OPTIONS.map((currency) => (
	                          <option key={currency} value={currency}>
	                            {currency}
	                          </option>
	                        ))}
	                      </select>
	                      <label className="text-muted-foreground">Rundung</label>
	                      <select
	                        className="h-7 rounded border border-slate-300 bg-background px-2"
	                        value={roundingMode}
	                        onChange={(event) => {
	                          const nextMode = event.target.value as RoundingMode;
	                          setRoundingMode(nextMode);
	                          if (planId) {
	                            updatePlanningSettings(planId, { roundingMode: nextMode });
	                          }
	                        }}
	                      >
	                        <option value="commercial">Kaufmännisch</option>
	                        <option value="symmetric">Symmetrisch</option>
	                        <option value="up">Immer aufrunden</option>
	                        <option value="down">Immer abrunden</option>
	                      </select>
	                      <label className="text-muted-foreground">Genauigkeit (Wert)</label>
	                      <select
	                        className="h-7 rounded border border-slate-300 bg-background px-2"
	                        value={String(roundingPrecisionMoney)}
	                        onChange={(event) => {
	                          const nextPrecision = Number(event.target.value);
	                          setRoundingPrecisionMoney(nextPrecision);
	                          if (planId) {
	                            updatePlanningSettings(planId, {
	                              roundingPrecisionMoney: nextPrecision,
	                            });
	                          }
	                        }}
	                      >
	                        <option value="0">0</option>
	                        <option value="1">1</option>
	                        <option value="2">2</option>
	                        <option value="3">3</option>
	                      </select>
	                      <label className="text-muted-foreground">Genauigkeit (physisch)</label>
	                      <select
	                        className="h-7 rounded border border-slate-300 bg-background px-2"
	                        value={String(roundingPrecisionPhysical)}
	                        onChange={(event) => {
	                          const nextPrecision = Number(event.target.value);
	                          setRoundingPrecisionPhysical(nextPrecision);
	                          if (planId) {
	                            updatePlanningSettings(planId, {
	                              roundingPrecisionPhysical: nextPrecision,
	                            });
	                          }
	                        }}
	                      >
	                        <option value="0">0</option>
	                        <option value="1">1</option>
	                        <option value="2">2</option>
	                        <option value="3">3</option>
	                      </select>
	                      <label className="text-muted-foreground">Kurs</label>
	                      <Input
	                        value={conversionFactorInput}
	                        onChange={(event) => setConversionFactorInput(event.target.value)}
	                        className="h-7 w-20 px-2 font-mono text-xs"
	                      />
	                      <Button
	                        type="button"
	                        size="sm"
	                        variant="outline"
	                        className={toolbarButtonClass}
	                        onClick={handleApplyCurrencyConversion}
	                      >
	                        Währung anwenden
	                      </Button>
	                    </div>
	                    {showHelpPanel ? (
	                      <div className="border-b bg-muted/10 px-4 py-3 text-xs leading-relaxed text-muted-foreground">
	                        <p><span className="font-medium text-foreground">Begriffe:</span> VK VJ = Verkaufswert Vorjahr, VK Plan = geplanter Verkaufswert, Entw. % = prozentuale Abweichung zu VK VJ.</p>
	                        <p><span className="font-medium text-foreground">Regeln:</span> % Plan = (VK Plan / VK VJ) * 100. Entw. % = ((VK Plan - VK VJ) / VK VJ) * 100.</p>
	                        <p><span className="font-medium text-foreground">Top-down:</span> verteilt Elternwerte auf Kinder nach Plan- oder Referenzgewichten.</p>
	                        <p><span className="font-medium text-foreground">Rundung:</span> Berechnung mit der gewählten Rundungsregel und Genauigkeit.</p>
	                      </div>
	                    ) : null}
	                      <div className="border-b bg-muted/5 px-4 py-2">
                        <div className="flex items-center justify-between">
                          <p className="text-xs font-medium text-foreground">Letzte Änderungen</p>
                          {changeLog.length > 10 ? (
                            <Button
                              type="button"
                              variant="ghost"
                              size="sm"
                              className="h-6 px-2 text-[11px]"
                              onClick={() => setShowAllChangeLog((current) => !current)}
                            >
                              {showAllChangeLog ? "Weniger" : "Mehr"}
                            </Button>
                          ) : null}
                        </div>
	                        <div className="mt-1 space-y-1">
	                          {(showAllChangeLog ? changeLog : changeLog.slice(0, 10)).map((entry) => (
	                            <p key={entry.id} className="text-xs text-muted-foreground">
	                              <span className="mr-2 font-mono text-[10px]">{entry.timestamp}</span>
	                              {entry.message}
	                            </p>
	                          ))}
	                          {changeLog.length === 0 ? (
	                            <p className="text-xs text-muted-foreground">
	                              Noch keine Änderungen protokolliert.
	                            </p>
	                          ) : null}
	                        </div>
	                      </div>
                    {selectedDrilldownNode ? (
                      <div className="flex flex-wrap items-center gap-x-4 gap-y-1 border-b bg-background px-4 py-2 text-xs text-muted-foreground">
                        <span className="font-medium text-foreground">
                          {selectedDrilldownNode.name}
                        </span>
                        <span>Pfad: {selectedDrilldownPath}</span>
                      </div>
                    ) : null}
                    <Table className="w-full table-fixed">
                      <TableHeader className="sticky top-0 z-10 bg-muted/60">
                        <TableRow className="border-b border-border/80">
                          <TableHead className="h-12 w-10" />
                          <TableHead className="h-12 w-[24%] pl-4 text-xs font-semibold uppercase tracking-wide text-foreground">
                            Struktur
                          </TableHead>
                          <TableHead className="h-12 w-[10%] text-right text-xs font-semibold uppercase tracking-wide text-foreground">
                            <span className="inline-flex items-center gap-1">
                              VK VJ
                              <Tooltip>
                                <TooltipTrigger asChild>
                                  <button type="button" className="inline-flex h-4 w-4 items-center justify-center rounded-full border border-border text-[10px] text-muted-foreground" aria-label="Info zu VK VJ">i</button>
                                </TooltipTrigger>
                                <TooltipContent side="top">VK VJ = Verkaufswert aus dem Vorjahr.</TooltipContent>
                              </Tooltip>
                            </span>
                          </TableHead>
                          <TableHead className="h-12 w-[10%] text-right text-xs font-semibold uppercase tracking-wide text-foreground">
                            <span className="inline-flex items-center gap-1">
                              % VJ
                              <Tooltip>
                                <TooltipTrigger asChild>
                                  <button type="button" className="inline-flex h-4 w-4 items-center justify-center rounded-full border border-border text-[10px] text-muted-foreground" aria-label="Info zu Prozent Vorjahr">i</button>
                                </TooltipTrigger>
                                <TooltipContent side="top">% VJ ist der prozentuale Monatsanteil am Vorjahreswert.</TooltipContent>
                              </Tooltip>
                            </span>
                          </TableHead>
                          <TableHead className="h-12 w-[10%] text-right text-xs font-semibold uppercase tracking-wide text-foreground">
                            <span className="inline-flex items-center gap-1">
                              VK Plan
                              <Tooltip>
                                <TooltipTrigger asChild>
                                  <button type="button" className="inline-flex h-4 w-4 items-center justify-center rounded-full border border-border text-[10px] text-muted-foreground" aria-label="Info zu VK Plan">i</button>
                                </TooltipTrigger>
                                <TooltipContent side="top">VK Plan ist der geplante Verkaufswert für den Knoten.</TooltipContent>
                              </Tooltip>
                            </span>
                          </TableHead>
                          <TableHead className="h-12 w-[10%] text-right text-xs font-semibold uppercase tracking-wide text-foreground">
                            <span className="inline-flex items-center gap-1">
                              % Plan
                              <Tooltip>
                                <TooltipTrigger asChild>
                                  <button
                                    type="button"
                                    className="inline-flex h-4 w-4 items-center justify-center rounded-full border border-border text-[10px] text-muted-foreground"
                                    aria-label="Info zur Rundungsregel"
                                  >
                                    i
                                  </button>
                                </TooltipTrigger>
                                <TooltipContent side="top" className="max-w-72">
                                  VK% = (VK Plan / VK VJ) * 100. Die Anzeige wird auf
                                  die konfigurierte Genauigkeit gerundet.
                                  Beispiel: 1049 / 1000 * 100 = 104,9%.
                                </TooltipContent>
                              </Tooltip>
                            </span>
                          </TableHead>
                          <TableHead className="h-12 w-[10%] text-right text-xs font-semibold uppercase tracking-wide text-foreground">
                            <span className="inline-flex items-center gap-1">
                              Entw. %
                              <Tooltip>
                                <TooltipTrigger asChild>
                                  <button type="button" className="inline-flex h-4 w-4 items-center justify-center rounded-full border border-border text-[10px] text-muted-foreground" aria-label="Info zu Entwicklung">i</button>
                                </TooltipTrigger>
                                <TooltipContent side="top">Entw. % zeigt die Abweichung von VK Plan gegenüber VK VJ.</TooltipContent>
                              </Tooltip>
                            </span>
                          </TableHead>
                          <TableHead className="h-12 w-[10%] pr-6 text-right text-xs font-semibold uppercase tracking-wide text-foreground">
                            <span className="inline-flex items-center gap-1">
                              Monate
                              <Tooltip>
                                <TooltipTrigger asChild>
                                  <button type="button" className="inline-flex h-4 w-4 items-center justify-center rounded-full border border-border text-[10px] text-muted-foreground" aria-label="Info zur Monatsansicht">i</button>
                                </TooltipTrigger>
                                <TooltipContent side="top">Öffnet die Monatsverteilung für den Knoten.</TooltipContent>
                              </Tooltip>
                            </span>
                          </TableHead>
                        </TableRow>
                      </TableHeader>
                      <TableBody>
                        {rootNodes.map((node) => renderNodeRows(node))}
                      </TableBody>
                    </Table>
                  </div>
                    <aside className="sticky top-3 hidden w-[340px] shrink-0 self-start xl:block">
                      {renderNodeDetailsPanel()}
                    </aside>
                  </div>
                ) : null}
                </section>
                <section className="rounded-lg border bg-card">
                  <button
                    type="button"
                    className={fastTabHeaderClassName}
                    onClick={() => setShowDetailFastTab((current) => !current)}
                    aria-expanded={showDetailFastTab}
                  >
                    <span>Detailansicht</span>
                    {showDetailFastTab ? (
                      <ChevronDown className={fastTabChevronClassName} />
                    ) : (
                      <ChevronRight className={fastTabChevronClassName} />
                    )}
                  </button>
                {showDetailFastTab ? (
                <div className="flex w-fit max-w-full flex-col gap-4 p-4">
                  <div className="overflow-hidden rounded-xl border border-border/70 bg-card shadow-sm">
                    <Table containerClassName="w-fit" className="w-auto">
                    <TableBody>
                      <TableRow className="hover:bg-muted/30">
                        <TableCell className="px-6 font-medium">
                          <InfoFieldLabel
                            label="Plan-ID"
                            description="Eindeutige Kennung des Planungsdokuments."
                          />
                        </TableCell>
                        <TableCell className="px-6 font-mono text-sm">
                          {obj.document.planId}
                        </TableCell>
                      </TableRow>
                      <TableRow className="hover:bg-muted/30">
                        <TableCell className="px-6 font-medium">
                          <InfoFieldLabel
                            label="Plantyp"
                            description="Definiert die fachliche Planungsart, z. B. Umsatz oder Menge."
                          />
                        </TableCell>
                        <TableCell className="px-6">
                          {obj.document.planningType}
                        </TableCell>
                      </TableRow>
                      <TableRow className="hover:bg-muted/30">
                        <TableCell className="px-6 font-medium">
                          <InfoFieldLabel
                            label="Status"
                            description="Aktueller Workflow-Status: Entwurf, In Prüfung oder Freigegeben."
                          />
                        </TableCell>
                        <TableCell className="px-6">
                          <Badge
                            variant={
                              obj.document.status === "Approved"
                                ? "outline"
                                : obj.document.status === "InReview"
                                  ? "outline"
                                  : "secondary"
                            }
                            className={
                              obj.document.status === "Approved"
                                ? "w-fit border-green-400 bg-green-50 text-green-700"
                                : obj.document.status === "InReview"
                                  ? "w-fit border-orange-400 bg-orange-50 text-orange-700"
                                  : "w-fit"
                            }
                          >
                            {obj.document.status === "Approved"
                              ? "Freigegeben"
                              : obj.document.status === "InReview"
                                ? "In Prüfung"
                                : "Entwurf"}
                          </Badge>
                        </TableCell>
                      </TableRow>
                      <TableRow className="hover:bg-muted/30">
                        <TableCell className="px-6 font-medium">
                          <InfoFieldLabel
                            label="Zuletzt bearbeitet"
                            description="Zeitpunkt der letzten gespeicherten Änderung."
                          />
                        </TableCell>
                        <TableCell className="px-6">
                          {formatDate(obj.document.lastModified)}
                        </TableCell>
                      </TableRow>
                      <TableRow className="hover:bg-muted/30">
                        <TableCell className="px-6 font-medium">
                          Browser Support
                        </TableCell>
                        <TableCell className="px-6">
                          Getestet für aktuelle Versionen von Edge und Chrome.
                        </TableCell>
                      </TableRow>
                      <TableRow className="hover:bg-muted/30">
                        <TableCell className="px-6 font-medium">
                          <InfoFieldLabel
                            label="Geschäftsjahr"
                            description="Jahr, für das die Planung erstellt wird."
                          />
                        </TableCell>
                        <TableCell className="px-6">
                          {obj.document.fiscalYear ?? "-"}
                        </TableCell>
                      </TableRow>
                      <TableRow className="hover:bg-muted/30">
                        <TableCell className="px-6 font-medium">
                          <InfoFieldLabel
                            label="Vergleichsjahr"
                            description="Referenzjahr für Vorjahres- und Vergleichswerte."
                          />
                        </TableCell>
                        <TableCell className="px-6">
                          {obj.document.comparisonYear ?? "-"}
                        </TableCell>
                      </TableRow>
                      <TableRow className="hover:bg-muted/30">
                        <TableCell className="px-6 font-medium">
                          <InfoFieldLabel
                            label="Planungsperiode"
                            description="Datumsbereich, in dem Planwerte aktiv erfasst werden."
                          />
                        </TableCell>
                        <TableCell className="px-6">
                          {formatPlanningPeriod(planningPeriod)}
                        </TableCell>
                      </TableRow>
                      <TableRow className="hover:bg-muted/30">
                        <TableCell className="px-6 font-medium">
                          <InfoFieldLabel
                            label="Referenzperiode"
                            description="Datumsbereich der Referenzwerte für den Vergleich."
                          />
                        </TableCell>
                        <TableCell className="px-6">
                          {formatPlanningPeriod(referencePeriod)}
                        </TableCell>
                      </TableRow>
                      <TableRow className="hover:bg-muted/30">
                        <TableCell className="px-6 font-medium">
                          <InfoFieldLabel
                            label="Beschreibung"
                            description="Freitext zur fachlichen Einordnung des Plans."
                          />
                        </TableCell>
                        <TableCell className="px-6">
                          {obj.document.description || "-"}
                        </TableCell>
                      </TableRow>
                      <TableRow className="hover:bg-muted/30">
                        <TableCell className="px-6 font-medium">
                          <InfoFieldLabel
                            label="Dokument erzeugt"
                            description="Zeitpunkt der erstmaligen Struktur- und Buffer-Erzeugung."
                          />
                        </TableCell>
                        <TableCell className="px-6">
                          {obj.document.runtime
                            ? formatDate(obj.document.runtime.createdAt)
                            : "-"}
                        </TableCell>
                      </TableRow>
                      <TableRow className="hover:bg-muted/30">
                        <TableCell className="px-6 font-medium">
                          <InfoFieldLabel
                            label="Dokument freigegeben"
                            description="Zeitpunkt, ab dem das Dokument im Status Freigegeben ist."
                          />
                        </TableCell>
                        <TableCell className="px-6">
                          {obj.document.runtime?.releasedAt
                            ? formatDate(obj.document.runtime.releasedAt)
                            : "-"}
                        </TableCell>
                      </TableRow>
                      <TableRow className="hover:bg-muted/30">
                        <TableCell className="px-6 font-medium align-top">
                          <InfoFieldLabel
                            label="Produkthierarchie(n)"
                            description="Ausgewählte Segment/Familie/Klasse-Kombinationen für den Plan."
                          />
                        </TableCell>
                        <TableCell className="px-6">
                          {obj.document.selectedHierarchies?.length ? (
                            <div className="flex flex-col items-start gap-2 py-1">
                              {obj.document.selectedHierarchies.map(
                                (h, idx) => (
                                  <Badge
                                    key={`${h.segment}-${h.family}-${h.className}-${idx}`}
                                    variant="outline"
                                    className="border-border/70 bg-muted/40 text-foreground"
                                  >
                                    {h.segment} / {h.family} / {h.className}
                                  </Badge>
                                ),
                              )}
                            </div>
                          ) : (
                            "-"
                          )}
                        </TableCell>
                      </TableRow>
                    </TableBody>
                    </Table>
                  </div>
                  {obj.document.runtime && (
                    <div className="overflow-hidden rounded-xl border border-border/70 bg-card shadow-sm">
                      <Table className="w-auto min-w-[620px]">
                        <TableHeader className="bg-muted/60">
                          <TableRow>
                            <TableHead className="px-5">Ebene</TableHead>
                            <TableHead className="px-5">Pfad</TableHead>
                            <TableHead className="px-5 text-right">
                              Buffer
                            </TableHead>
                            <TableHead className="px-5 text-right">
                              Zeilen
                            </TableHead>
                          </TableRow>
                        </TableHeader>
                        <TableBody>
                          {obj.document.runtime.levels.map((level) => (
                            <TableRow key={`${level.index}-${level.level}`}>
                              <TableCell className="px-5 font-medium">
                                {level.index}. {level.description}
                              </TableCell>
                              <TableCell className="px-5">
                                {level.pathEnd ? "Cube-Ende" : "View"}
                              </TableCell>
                              <TableCell className="px-5 text-right font-mono">
                                {level.activeBufferCount}
                              </TableCell>
                              <TableCell className="px-5 text-right font-mono">
                                {level.lineCount}
                              </TableCell>
                            </TableRow>
                          ))}
                        </TableBody>
                      </Table>
                    </div>
                  )}
                </div>
              ) : null}
                </section>
              </div>
            </div>
          )}

          {isMonthlyViewActive && (
            <div className="relative overflow-y-auto overflow-x-hidden transition-all duration-300 ease-out translate-x-0 opacity-100">
              {/* Monthly Detail View */}
              <div className="flex flex-col h-full">
                {selectedMonthlyNode && (
                  <>
                    <div className="py-0 shrink-0">
                      <div className="flex items-center gap-2">
                        <button
                          type="button"
                          onClick={closeMonthlyView}
                          className="inline-flex h-8 w-8 items-center justify-center rounded-md border border-transparent text-muted-foreground hover:border-border hover:bg-muted"
                          aria-label="Zurueck zur Tabelle"
                        >
                          <ChevronRight className="h-4 w-4 rotate-180" />
                        </button>
                        <h2 className="font-semibold text-lg">
                          {selectedMonthlyNode.name}
                        </h2>
                      </div>
                    </div>

                    <div className="mt-4 pb-2">
                      <div className="grid grid-cols-5 rounded-lg border bg-card">
                        <div className="flex flex-col items-center justify-center px-3 py-3 text-center">
                          <p className="text-xs text-muted-foreground">
                            <InfoFieldLabel
                              label="VK VJ"
                              description="Verkaufswert aus dem Vorjahr."
                            />
                          </p>
                          <p className="font-mono text-sm font-medium">
                            {formatPlanNumber(
                              selectedMonthlyNode.metrics.refSalesAmount,
                            )}
                          </p>
                        </div>
                        <div className="flex flex-col items-center justify-center px-3 py-3 text-center">
                          <p className="text-xs text-muted-foreground">
                            <InfoFieldLabel
                              label="VK Plan"
                              description="Aktuell geplanter Verkaufswert."
                            />
                          </p>
                          <p className="font-mono text-sm font-medium text-foreground">
                            {formatPlanNumber(selectedMonthlyTotal)}
                          </p>
                        </div>
                        <div className="flex flex-col items-center justify-center px-3 py-3 text-center">
                          <p className="text-xs text-muted-foreground">
                            <InfoFieldLabel
                              label="Entw. %"
                              description="Prozentuale Abweichung von VK Plan gegenüber VK VJ."
                            />
                          </p>
                          <p className="text-sm text-foreground">
                            {formatPercent(
                              calculateDelta(
                                selectedMonthlyNode.metrics.refSalesAmount,
                                selectedMonthlyTotal,
                              ),
                            )}
                          </p>
                        </div>
                        <div className="flex flex-col items-center justify-center px-3 py-3 text-center">
                          <p className="text-xs text-muted-foreground">
                            <InfoFieldLabel
                              label="Gesamtsumme"
                              description="Summe aller Monatswerte des selektierten Knotens."
                            />
                          </p>
                          <p className="font-mono text-sm font-medium">
                            {formatPlanNumber(selectedMonthlyTotal)}
                          </p>
                        </div>
                        <div className="flex flex-col items-center justify-center px-3 py-3 text-center">
                          <p className="text-xs text-muted-foreground">
                            <InfoFieldLabel
                              label="Monatsdurchschnitt"
                              description="Durchschnittlicher Monatswert des selektierten Knotens."
                            />
                          </p>
                          <p className="font-mono text-sm font-medium">
                            {formatPlanNumber(
                              Math.round(
                                selectedMonthlyTotal /
                                  Math.max(
                                    selectedMonthlyNode.monthlyValues.length,
                                    1,
                                  ),
                              ),
                            )}
                          </p>
                        </div>
                      </div>
                    </div>

                    <div className="py-6">
                      <p className="mb-2 ml-2 text-xs text-muted-foreground">
                        Monatliche Verteilung
                      </p>
                      <div className="overflow-hidden rounded-lg border bg-card">
                        <Table className="w-full table-fixed">
                          <TableHeader className="sticky top-0 z-30 bg-muted/60">
                            <TableRow className="border-b border-border/80">
                              <TableHead className="h-12 w-[12%] pl-6 text-xs font-semibold uppercase tracking-wide text-foreground">
                                Monat
                              </TableHead>
                              <TableHead className="h-12 w-[28%] pl-4 text-xs font-semibold uppercase tracking-wide text-foreground">
                                Struktur
                              </TableHead>
                              <TableHead className="h-12 w-[11%] text-right text-xs font-semibold uppercase tracking-wide text-foreground">
                                VK VJ
                              </TableHead>
                              <TableHead className="h-12 w-[11%] text-right text-xs font-semibold uppercase tracking-wide text-foreground">
                                % VJ
                              </TableHead>
                              <TableHead className="h-12 w-6 p-0" />
                              <TableHead className="h-12 w-[11%] text-right text-xs font-semibold uppercase tracking-wide text-foreground">
                                VK Plan
                              </TableHead>
                              <TableHead className="h-12 w-[10%] text-right text-xs font-semibold uppercase tracking-wide text-foreground">
                                % Plan
                              </TableHead>
                              <TableHead className="h-12 w-[11%] pr-4 text-right text-xs font-semibold uppercase tracking-wide text-foreground">
                                Entw. %
                              </TableHead>
                            </TableRow>
                          </TableHeader>
                          <TableBody>
                            {selectedMonthlyNode.monthlyValues.map((month) => {
                              const refValue = Math.round(
                                getMonthlyRefValue(
                                  selectedMonthlyNode,
                                  month.date,
                                ),
                              );
                              const planValue = getMonthlyPlanValue(
                                selectedMonthlyNode,
                                month.date,
                              );
                              const planShare =
                                selectedMonthlyTotal === 0
                                  ? 0
                                  : (planValue / selectedMonthlyTotal) * 100;
                              const shareKey = `${selectedMonthlyNodeId!}-${month.date}`;
                              const shareInputValue =
                                monthlyShareDrafts[shareKey] ??
                                formatPercent(planShare);
                              const monthlyPlanInputValue =
                                monthlyPlanDrafts[shareKey] ?? String(planValue);
                              const monthlyPlanFieldKey = `monthly-plan-${shareKey}`;
                              const monthlyShareFieldKey = `monthly-share-${shareKey}`;
                              const monthlyPlanError = inputErrors[monthlyPlanFieldKey];
                              const monthlyShareError = inputErrors[monthlyShareFieldKey];

                              return (
                                <TableRow key={month.date} className="h-12">
                                  <TableCell className="w-[12%] pl-6 text-muted-foreground">
                                    {getMonthLabel(month.date)}
                                  </TableCell>
                                  <TableCell className="w-[28%] pl-4 text-muted-foreground">
                                    Monat
                                  </TableCell>
                                  <TableCell className="w-[11%] text-right font-mono text-sm">
                                    {formatPlanNumber(refValue)}
                                  </TableCell>
                                  <TableCell className="w-[11%] text-right text-sm">
                                    {formatPercent(
                                      getMonthlyRefShare(
                                        selectedMonthlyNode,
                                        month.date,
                                      ),
                                    )}
                                  </TableCell>
                                  <TableCell className="w-6 p-0" />
                                  <TableCell className="w-[11%]">
                                    <div>
                                      <Input
                                        type="text"
                                        inputMode="numeric"
                                        className={`h-8 bg-transparent px-0 text-right font-mono text-sm text-foreground shadow-none focus-visible:ring-0 ${
                                          monthlyPlanError
                                            ? "border-red-500 focus-visible:border-red-500"
                                            : "border-transparent focus-visible:border-transparent"
                                        }`}
                                        value={monthlyPlanInputValue}
                                        onChange={(event) =>
                                          updateMonthlyPlanDraft(
                                            selectedMonthlyNodeId!,
                                            month.date,
                                            event.target.value,
                                          )
                                        }
                                        onBlur={() =>
                                          commitMonthlyPlanDraft(
                                            selectedMonthlyNodeId!,
                                            month.date,
                                          )
                                        }
                                        onKeyDown={(event) => {
                                          if (handleVerticalArrowNavigation(event)) return;
                                          if (event.key === "Enter") {
                                            event.preventDefault();
                                            commitMonthlyPlanDraft(
                                              selectedMonthlyNodeId!,
                                              month.date,
                                            );
                                            if (event.shiftKey) {
                                              focusPreviousEditableInput(event.currentTarget);
                                            } else {
                                              focusNextEditableInput(event.currentTarget);
                                            }
                                            return;
                                          }
                                          if (event.key === "Escape") {
                                            event.preventDefault();
                                            clearFieldError(monthlyPlanFieldKey);
                                            setMonthlyPlanDrafts((prev) => {
                                              const next = { ...prev };
                                              delete next[shareKey];
                                              return next;
                                            });
                                            event.currentTarget.blur();
                                            return;
                                          }
                                        }}
                                        disabled={obj.document.status === "Approved"}
                                      />
                                      {monthlyPlanError ? (
                                        <p className="mt-1 text-right text-[11px] text-red-600">{monthlyPlanError}</p>
                                      ) : null}
                                    </div>
                                  </TableCell>
                                  <TableCell className="w-[10%]">
                                    <div>
                                      <Input
                                        type="text"
                                        inputMode="decimal"
                                        className={`h-8 bg-transparent px-0 text-right text-sm text-foreground shadow-none focus-visible:ring-0 ${
                                          monthlyShareError
                                            ? "border-red-500 focus-visible:border-red-500"
                                            : "border-transparent focus-visible:border-transparent"
                                        }`}
                                        value={shareInputValue}
                                        onChange={(event) =>
                                          updateMonthlyShareDraft(
                                            selectedMonthlyNodeId!,
                                            month.date,
                                            event.target.value,
                                          )
                                        }
                                        onBlur={() =>
                                          commitMonthlyShareDraft(
                                            selectedMonthlyNodeId!,
                                            month.date,
                                            selectedMonthlyTotal,
                                            selectedMonthlyNode.metrics
                                              .planSalesAmount,
                                          )
                                        }
                                        onKeyDown={(event) => {
                                          if (handleVerticalArrowNavigation(event)) return;
                                          if (event.key === "Enter") {
                                            event.preventDefault();
                                            commitMonthlyShareDraft(
                                              selectedMonthlyNodeId!,
                                              month.date,
                                              selectedMonthlyTotal,
                                              selectedMonthlyNode.metrics
                                                .planSalesAmount,
                                            );
                                            if (event.shiftKey) {
                                              focusPreviousEditableInput(event.currentTarget);
                                            } else {
                                              focusNextEditableInput(event.currentTarget);
                                            }
                                            return;
                                          }
                                          if (event.key === "Escape") {
                                            event.preventDefault();
                                            clearFieldError(monthlyShareFieldKey);
                                            setMonthlyShareDrafts((prev) => {
                                              const next = { ...prev };
                                              delete next[shareKey];
                                              return next;
                                            });
                                            event.currentTarget.blur();
                                            return;
                                          }
                                        }}
                                        disabled={obj.document.status === "Approved"}
                                      />
                                      {monthlyShareError ? (
                                        <p className="mt-1 text-right text-[11px] text-red-600">{monthlyShareError}</p>
                                      ) : null}
                                    </div>
                                  </TableCell>
                                  <TableCell className="w-[11%] pr-4 text-right text-foreground">
                                    {formatPercent(
                                      calculateDelta(refValue, planValue),
                                    )}
                                  </TableCell>
                                </TableRow>
                              );
                            })}
                          </TableBody>
                        </Table>
                      </div>
                    </div>
                  </>
                )}
              </div>
            </div>
          )}
        </div>
        {isDetailsDrawerOpen ? (
          <div className="fixed inset-0 z-40 xl:hidden">
            <button
              type="button"
              className="absolute inset-0 bg-black/35"
              aria-label="Ebenendetails schließen"
              onClick={() => setIsDetailsDrawerOpen(false)}
            />
            <div className="absolute right-0 top-0 h-full w-[86vw] max-w-[360px] overflow-y-auto bg-background p-3 shadow-xl">
              <div className="mb-3 flex justify-end">
                <Button
                  type="button"
                  size="sm"
                  variant="outline"
                  onClick={() => setIsDetailsDrawerOpen(false)}
                >
                  Schließen
                </Button>
              </div>
              {renderNodeDetailsPanel()}
            </div>
          </div>
        ) : null}
      </main>
    </div>
  );
}
