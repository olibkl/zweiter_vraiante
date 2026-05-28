import { useState, useMemo } from "react";
import { X } from "lucide-react";
import { toast } from "sonner";
import { Button } from "@/components/ui/button";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { useNavigate } from "react-router-dom";
import { planningObjects } from "@/lib/planning-data";
import {
  countPlanningPeriodRecords,
  validatePlanningRange,
  yearPeriod,
} from "@/lib/planning-period";
import { usePlanStore } from "@/store/usePlanStore";
import type { PlanningNode } from "@/types/planning";

export default function Setup() {
  const navigate = useNavigate();
  const setPlanSetup = usePlanStore((state) => state.setPlanSetup);
  const allPlans = usePlanStore((state) => state.allPlans);
  const [planningNumber, setPlanningNumber] = useState("");
  const [planName, setPlanName] = useState("");
  const [description, setDescription] = useState("");
  const [fiscalYear, setFiscalYear] = useState("");
  const [comparisonYear, setComparisonYear] = useState("");
  const [planningPeriod, setPlanningPeriod] = useState(yearPeriod(""));
  const [referencePeriod, setReferencePeriod] = useState(yearPeriod(""));
  const [kpis, setKpis] = useState<string[]>([]);

  const [selectedSegment, setSelectedSegment] = useState("");
  const [selectedFamily, setSelectedFamily] = useState("");
  const [selectedClass, setSelectedClass] = useState("");
  // Liste der hinzugefügten Hierarchien
  const [hierarchies, setHierarchies] = useState<
    { segment: string; family: string; className: string }[]
  >([]);

  const mockPlanningObject = planningObjects[0];

  const availableSegments = useMemo(() => {
    return mockPlanningObject.data
      .filter((node) => node.level === "Segment")
      .map((node) => node.name);
  }, [mockPlanningObject]);

  const selectedSegmentNode = useMemo(() => {
    return mockPlanningObject.data.find(
      (node) => node.level === "Segment" && node.name === selectedSegment,
    );
  }, [mockPlanningObject, selectedSegment]);

  const availableFamilies = useMemo(() => {
    if (!selectedSegmentNode) {
      return [];
    }

    return (selectedSegmentNode.children ?? [])
      .filter((node: PlanningNode) => node.level === "Family")
      .map((node: PlanningNode) => node.name);
  }, [selectedSegmentNode]);

  const selectedFamilyNode = useMemo(() => {
    if (!selectedSegmentNode) {
      return undefined;
    }

    return (selectedSegmentNode.children ?? []).find(
      (node: PlanningNode) =>
        node.level === "Family" && node.name === selectedFamily,
    );
  }, [selectedSegmentNode, selectedFamily]);

  const availableClasses = useMemo(() => {
    if (!selectedFamilyNode) {
      return [];
    }

    return (selectedFamilyNode.children ?? [])
      .filter((node: PlanningNode) => node.level === "Class")
      .map((node: PlanningNode) => node.name);
  }, [selectedFamilyNode]);

  const maxPlanNameLength = 54;
  const planNameFieldClassName =
    "text-sm mt-2 block w-full border border-gray-300 rounded-md shadow-sm focus:ring focus:ring-opacity-50 px-3 py-2 h-[36px]";
  const currentYear = new Date().getFullYear();
  const availableFiscalYears = useMemo(
    () =>
      Array.from({ length: 21 }, (_, index) =>
        String(currentYear - 10 + index),
      ),
    [currentYear],
  );

  const buildHierarchyKey = (hierarchy: {
    segment: string;
    family: string;
    className: string;
  }) => `${hierarchy.segment}|${hierarchy.family}|${hierarchy.className}`;

  const selectedHierarchyCandidate =
    selectedSegment && selectedFamily && selectedClass
      ? {
          segment: selectedSegment,
          family: selectedFamily,
          className: selectedClass,
        }
      : null;

  const isSelectedHierarchyDuplicate = selectedHierarchyCandidate
    ? hierarchies.some(
        (hierarchy) =>
          buildHierarchyKey(hierarchy) ===
          buildHierarchyKey(selectedHierarchyCandidate),
      )
    : false;

  const availableComparisonYears = useMemo(
    () => availableFiscalYears.filter((year) => year !== fiscalYear),
    [availableFiscalYears, fiscalYear],
  );
  const planningRecordCount = countPlanningPeriodRecords(planningPeriod);
  const referenceRecordCount = countPlanningPeriodRecords(referencePeriod);

  const handleAddHierarchy = () => {
    if (selectedHierarchyCandidate) {
      if (isSelectedHierarchyDuplicate) {
        toast.error("Diese Produkthierarchie ist bereits gewählt.");
        return;
      }

      setHierarchies((prev) => [...prev, selectedHierarchyCandidate]);
      setSelectedSegment("");
      setSelectedFamily("");
      setSelectedClass("");
    }
  };

  const handleRemoveHierarchy = (hierarchyKey: string) => {
    setHierarchies((prev) =>
      prev.filter((hierarchy) => buildHierarchyKey(hierarchy) !== hierarchyKey),
    );
  };

  const handleSubmit = (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    const trimmedPlanId = planningNumber.trim();

    if (
      trimmedPlanId &&
      planName &&
      description &&
      fiscalYear &&
      comparisonYear &&
      hierarchies.length > 0 &&
      kpis.length
    ) {
      const duplicatePlanId = allPlans.some(
        (plan) => plan.document.planId === trimmedPlanId,
      );

      if (duplicatePlanId) {
        toast.error("Die Planungsnummer existiert bereits.");
        return;
      }

      if (fiscalYear === comparisonYear) {
        toast.error("Geschäftsjahr und Vergleichsjahr müssen unterschiedlich sein.");
        return;
      }

      const planningRangeError = validatePlanningRange(
        planningPeriod.startDate,
        planningPeriod.endDate,
      );
      const referenceRangeError = validatePlanningRange(
        referencePeriod.startDate,
        referencePeriod.endDate,
      );

      if (planningRangeError || referenceRangeError) {
        toast.error(planningRangeError ?? referenceRangeError);
        return;
      }

      if (planningRecordCount !== referenceRecordCount) {
        toast.error(
          "Planungsperiode und Referenzperiode muessen gleich viele Monate enthalten.",
        );
        return;
      }

      const newPlanId = setPlanSetup({
        planId: trimmedPlanId,
        name: planName,
        description,
        fiscalYear,
        comparisonYear,
        planningPeriod,
        referencePeriod,
        kpis,
        hierarchies, // wird im Store ggf. angepasst
      });

      navigate(`/workspace/${newPlanId}`);
    } else {
      toast.error("Bitte füllen Sie alle Felder aus.");
    }
  };

  return (
    <div className="flex flex-col h-full">
      <div className="py-6 pt-4 shrink-0">
        <h1 className="text-3xl font-bold">Neuen Plan erstellen</h1>
      </div>
      <div className="py-1 max-w-full">
        <form onSubmit={handleSubmit} className="flex w-full flex-col gap-6">
          <div className="grid w-full grid-cols-1 gap-6 md:grid-cols-[minmax(180px,220px)_minmax(260px,1fr)_auto_auto] md:items-end">
            <div>
              <label className="block text-sm font-medium">
                Planungsnummer
              </label>
              <input
                type="text"
                value={planningNumber}
                onChange={(e) => setPlanningNumber(e.target.value)}
                className={planNameFieldClassName}
                placeholder="z. B. PLN-2026-001"
              />
            </div>

            <div>
              <label className="block text-sm font-medium">Name</label>
              <input
                type="text"
                value={planName}
                onChange={(e) =>
                  setPlanName(e.target.value.slice(0, maxPlanNameLength))
                }
                maxLength={maxPlanNameLength}
                className={planNameFieldClassName}
                placeholder="Geben Sie den Namen des Plans ein..."
              />
            </div>

            <div>
              <label className="block text-sm font-medium">Geschäftsjahr</label>
              <Select
                value={fiscalYear}
                onValueChange={(value) => {
                  setFiscalYear(value);
                  setPlanningPeriod(yearPeriod(value));
                  if (comparisonYear === value) {
                    setComparisonYear("");
                    setReferencePeriod(yearPeriod(""));
                  }
                }}
              >
                <SelectTrigger className="mt-2 w-[7rem] border-gray-300 shadow-sm h-[42px] px-3">
                  <SelectValue placeholder="Jahr" />
                </SelectTrigger>
                <SelectContent
                  align="start"
                  className="!w-[7rem] !min-w-[7rem]"
                >
                  {availableFiscalYears.map((year) => (
                    <SelectItem key={year} value={year}>
                      {year}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>

            <div>
              <label className="block text-sm font-medium">
                Vergleichsjahr
              </label>
              <Select
                value={comparisonYear}
                onValueChange={(value) => {
                  setComparisonYear(value);
                  setReferencePeriod(yearPeriod(value));
                }}
              >
                <SelectTrigger className="mt-2 w-[7rem] border-gray-300 shadow-sm h-[42px] px-3">
                  <SelectValue placeholder="Jahr" />
                </SelectTrigger>
                <SelectContent
                  align="start"
                  className="!w-[7rem] !min-w-[7rem]"
                >
                  {availableComparisonYears.map((year) => (
                    <SelectItem key={year} value={year}>
                      {year}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
          </div>
          <div className="grid w-full grid-cols-1 gap-6 lg:grid-cols-2">
            <section className="border-t pt-4">
              <div className="mb-3 flex items-center justify-between gap-3">
                <h2 className="text-sm font-semibold">Planungsperiode</h2>
                <span className="text-xs text-muted-foreground">
                  {planningRecordCount} Monate
                </span>
              </div>
              <div className="grid grid-cols-1 gap-4 sm:grid-cols-[1fr_1fr_8rem]">
                <label className="text-sm font-medium">
                  Startdatum
                  <input
                    type="date"
                    value={planningPeriod.startDate}
                    onChange={(event) =>
                      setPlanningPeriod((period) => ({
                        ...period,
                        startDate: event.target.value,
                      }))
                    }
                    className={planNameFieldClassName}
                  />
                </label>
                <label className="text-sm font-medium">
                  Enddatum
                  <input
                    type="date"
                    value={planningPeriod.endDate}
                    onChange={(event) =>
                      setPlanningPeriod((period) => ({
                        ...period,
                        endDate: event.target.value,
                      }))
                    }
                    className={planNameFieldClassName}
                  />
                </label>
                <label className="text-sm font-medium">
                  Einheit
                  <input
                    type="text"
                    value="Monat"
                    readOnly
                    className={`${planNameFieldClassName} bg-muted text-muted-foreground`}
                  />
                </label>
              </div>
            </section>
            <section className="border-t pt-4">
              <div className="mb-3 flex items-center justify-between gap-3">
                <h2 className="text-sm font-semibold">Referenzperiode</h2>
                <span className="text-xs text-muted-foreground">
                  {referenceRecordCount} Monate
                </span>
              </div>
              <div className="grid grid-cols-1 gap-4 sm:grid-cols-[1fr_1fr_8rem]">
                <label className="text-sm font-medium">
                  Startdatum
                  <input
                    type="date"
                    value={referencePeriod.startDate}
                    onChange={(event) =>
                      setReferencePeriod((period) => ({
                        ...period,
                        startDate: event.target.value,
                      }))
                    }
                    className={planNameFieldClassName}
                  />
                </label>
                <label className="text-sm font-medium">
                  Enddatum
                  <input
                    type="date"
                    value={referencePeriod.endDate}
                    onChange={(event) =>
                      setReferencePeriod((period) => ({
                        ...period,
                        endDate: event.target.value,
                      }))
                    }
                    className={planNameFieldClassName}
                  />
                </label>
                <label className="text-sm font-medium">
                  Einheit
                  <input
                    type="text"
                    value="Monat"
                    readOnly
                    className={`${planNameFieldClassName} bg-muted text-muted-foreground`}
                  />
                </label>
              </div>
            </section>
          </div>
          <div className="w-full">
            <label className="block text-sm font-medium">Beschreibung</label>
            <textarea
              value={description}
              onChange={(e) => setDescription(e.target.value)}
              rows={4}
              className="text-sm mt-2 block w-full resize-y rounded-md border border-gray-300 px-3 py-2 shadow-sm focus:ring focus:ring-opacity-50"
              placeholder="Geben Sie eine kurze Beschreibung ein..."
            />
          </div>
          <div className="w-full">
            <label className="block text-sm font-medium">
              Produkthierarchie(n)
            </label>
            <div className="grid w-full grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-3">
              <div className="w-full">
                <Select
                  value={selectedSegment}
                  onValueChange={(value) => {
                    setSelectedSegment(value);
                    setSelectedFamily("");
                    setSelectedClass("");
                  }}
                >
                  <SelectTrigger className="mt-2 w-full border-gray-300 shadow-sm h-[42px] px-3">
                    <SelectValue placeholder="Segment auswählen" />
                  </SelectTrigger>
                  <SelectContent align="start">
                    {availableSegments.map((segment) => (
                      <SelectItem key={segment} value={segment}>
                        {segment}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>
              <div className="w-full">
                <Select
                  value={selectedFamily}
                  onValueChange={(value) => {
                    setSelectedFamily(value);
                    setSelectedClass("");
                  }}
                  disabled={!selectedSegment}
                >
                  <SelectTrigger className="mt-2 w-full border-gray-300 shadow-sm h-[42px] px-3 disabled:opacity-50">
                    <SelectValue placeholder="Familie auswählen" />
                  </SelectTrigger>
                  <SelectContent align="start">
                    {availableFamilies.map((family) => (
                      <SelectItem key={family} value={family}>
                        {family}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>
              <div className="w-full">
                <Select
                  value={selectedClass}
                  onValueChange={setSelectedClass}
                  disabled={!selectedFamily}
                >
                  <SelectTrigger className="mt-2 w-full border-gray-300 shadow-sm h-[42px] px-3 disabled:opacity-50">
                    <SelectValue placeholder="Klasse auswählen" />
                  </SelectTrigger>
                  <SelectContent align="start">
                    {availableClasses.map((className) => (
                      <SelectItem key={className} value={className}>
                        {className}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>
            </div>
            <div className="mt-3 flex items-center gap-2">
              <Button
                type="button"
                variant="secondary"
                size="sm"
                onClick={handleAddHierarchy}
                disabled={
                  !(selectedSegment && selectedFamily && selectedClass) ||
                  isSelectedHierarchyDuplicate
                }
              >
                + Hinzufügen
              </Button>
            </div>
            {hierarchies.length > 0 && (
              <div className="mt-5">
                <div className="mb-2 text-xs font-semibold">Gewählt</div>
                <ul className="flex flex-col gap-1">
                  {hierarchies.map((h) => {
                    const hierarchyKey = buildHierarchyKey(h);
                    return (
                    <li
                      key={hierarchyKey}
                      className="flex w-fit items-center gap-2 rounded bg-gray-100 px-2 py-1 text-sm"
                    >
                      <span>
                        {h.segment} &gt; {h.family} &gt; {h.className}
                      </span>
                      <button
                        type="button"
                        className="ml-2 text-gray-400 hover:text-red-500"
                        onClick={() => handleRemoveHierarchy(hierarchyKey)}
                        aria-label="Entfernen"
                      >
                        <X size={16} />
                      </button>
                    </li>
                  );
                  })}
                </ul>
              </div>
            )}
          </div>
          <div>
            <label className="block text-sm font-medium">Typ</label>
            <div className="mt-2 flex flex-col gap-1">
              {["Menge", "Umsatz"].map((kpi) => (
                <div key={kpi}>
                  <label className="inline-flex items-center">
                    <input
                      type="radio"
                      name="kpi"
                      value={kpi}
                      checked={kpis.length === 1 && kpis[0] === kpi}
                      onChange={(e) => {
                        if (e.target.checked) {
                          setKpis([kpi]);
                        } else {
                          setKpis([]);
                        }
                      }}
                      className="h-4 w-4 text-blue-600"
                    />
                    <span className="ml-3 text-gray-700 text-sm">{kpi}</span>
                  </label>
                </div>
              ))}
            </div>
          </div>
          <div className="mt-2 flex w-full justify-start gap-3">
            <Button
              type="button"
              variant="outline"
              onClick={() => navigate("/")}
            >
              Abbrechen
            </Button>
            <Button type="submit" className="w-25">
              Erstellen
            </Button>
          </div>
        </form>
      </div>
    </div>
  );
}
