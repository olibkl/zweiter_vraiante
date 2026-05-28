import { useMemo, useState } from "react";
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
import {
  countPlanningPeriodRecords,
  validatePlanningRange,
  yearPeriod,
} from "@/lib/planning-period";
import { usePlanStore } from "@/store/usePlanStore";
import type { SelectedHierarchy } from "@/types/planning";

const fieldClassName =
  "text-sm mt-2 block w-full border border-gray-300 rounded-md shadow-sm focus:ring focus:ring-opacity-50 px-3 py-2 h-[36px]";
const withError = (base: string, hasError?: boolean) =>
  hasError ? `${base} border-red-500 focus:border-red-500 focus:ring-red-300` : base;
const required = <span className="ml-1 text-red-600">*</span>;
const errorHint = <p className="mt-1 text-xs text-red-600">Pflichtfeld</p>;

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
  const [fieldErrors, setFieldErrors] = useState<Record<string, boolean>>({});

  const [selectedHierarchyPreset, setSelectedHierarchyPreset] = useState("");
  const [hierarchies, setHierarchies] = useState<SelectedHierarchy[]>([]);

  const currentYear = new Date().getFullYear();
  const availableFiscalYears = useMemo(
    () => Array.from({ length: 21 }, (_, idx) => String(currentYear - 10 + idx)),
    [currentYear],
  );
  const availableComparisonYears = useMemo(
    () => availableFiscalYears.filter((year) => year !== fiscalYear),
    [availableFiscalYears, fiscalYear],
  );

  const hierarchyPresets = useMemo(
    () => [
      {
        key: "fashion-core",
        name: "Fashion Core",
        values: [
          {
            segment: "Bekleidung",
            family: "Herrenbekleidung",
            className: "Outerwear",
          },
        ],
      },
      {
        key: "fashion-basics",
        name: "Fashion Basics",
        values: [
          {
            segment: "Bekleidung",
            family: "Herrenbekleidung",
            className: "Basics",
          },
        ],
      },
      {
        key: "shoes-core",
        name: "Shoes Core",
        values: [
          {
            segment: "Schuhe",
            family: "New Family 1",
            className: "New Class 1",
          },
        ],
      },
    ],
    [],
  );

  const planningRecordCount = countPlanningPeriodRecords(planningPeriod);
  const referenceRecordCount = countPlanningPeriodRecords(referencePeriod);

  const clearFieldError = (key: string) =>
    setFieldErrors((current) => ({ ...current, [key]: false }));

  const applyPreset = (presetKey: string) => {
    setSelectedHierarchyPreset(presetKey);
    clearFieldError("hierarchies");
    const preset = hierarchyPresets.find((item) => item.key === presetKey);
    if (!preset) return;
    setHierarchies(preset.values);
  };

  const handleSubmit = (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    const trimmedPlanId = planningNumber.trim();

    const nextErrors: Record<string, boolean> = {
      planningNumber: !trimmedPlanId,
      planName: !planName.trim(),
      description: !description.trim(),
      fiscalYear: !fiscalYear,
      comparisonYear: !comparisonYear,
      kpis: kpis.length === 0,
      hierarchies: hierarchies.length === 0 || !selectedHierarchyPreset,
    };
    setFieldErrors(nextErrors);
    if (Object.values(nextErrors).some(Boolean)) {
      toast.error("Bitte Pflichtfelder prüfen.");
      return;
    }

    const duplicatePlanId = allPlans.some((plan) => plan.document.planId === trimmedPlanId);
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
      toast.error("Planungsperiode und Referenzperiode müssen gleich viele Monate enthalten.");
      return;
    }

    const newPlanId = setPlanSetup({
      planId: trimmedPlanId,
      name: planName.trim(),
      description: description.trim(),
      fiscalYear,
      comparisonYear,
      planningPeriod,
      referencePeriod,
      kpis,
      hierarchies,
    });
    navigate(`/workspace/${newPlanId}`);
  };

  return (
    <div className="flex h-full flex-col">
      <div className="shrink-0 py-6 pt-4">
        <h1 className="text-3xl font-bold">Neuen Plan erstellen</h1>
      </div>
      <div className="max-w-full py-1">
        <form onSubmit={handleSubmit} className="flex w-full flex-col gap-6">
          <div className="grid w-full grid-cols-1 gap-6 md:grid-cols-[minmax(180px,220px)_minmax(260px,1fr)_auto_auto] md:items-end">
            <div>
              <label className="block text-sm font-medium">Planungsnummer{required}</label>
              <input
                type="text"
                value={planningNumber}
                onChange={(event) => {
                  setPlanningNumber(event.target.value);
                  clearFieldError("planningNumber");
                }}
                className={withError(fieldClassName, fieldErrors.planningNumber)}
                placeholder="z. B. PLN-2026-001"
              />
              {fieldErrors.planningNumber ? errorHint : null}
            </div>

            <div>
              <label className="block text-sm font-medium">Name{required}</label>
              <input
                type="text"
                value={planName}
                onChange={(event) => {
                  setPlanName(event.target.value.slice(0, 54));
                  clearFieldError("planName");
                }}
                maxLength={54}
                className={withError(fieldClassName, fieldErrors.planName)}
                placeholder="Geben Sie den Namen des Plans ein..."
              />
              {fieldErrors.planName ? errorHint : null}
            </div>

            <div>
              <label className="block text-sm font-medium">Geschäftsjahr{required}</label>
              <Select
                value={fiscalYear}
                onValueChange={(value) => {
                  setFiscalYear(value);
                  clearFieldError("fiscalYear");
                  setPlanningPeriod(yearPeriod(value));
                  if (comparisonYear === value) {
                    setComparisonYear("");
                    setReferencePeriod(yearPeriod(""));
                  }
                }}
              >
                <SelectTrigger
                  className={withError(
                    "mt-2 w-[7rem] border-gray-300 shadow-sm h-[42px] px-3",
                    fieldErrors.fiscalYear,
                  )}
                >
                  <SelectValue placeholder="Jahr" />
                </SelectTrigger>
                <SelectContent align="start" className="!w-[7rem] !min-w-[7rem]">
                  {availableFiscalYears.map((year) => (
                    <SelectItem key={year} value={year}>
                      {year}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
              {fieldErrors.fiscalYear ? errorHint : null}
            </div>

            <div>
              <label className="block text-sm font-medium">Vergleichsjahr{required}</label>
              <Select
                value={comparisonYear}
                onValueChange={(value) => {
                  setComparisonYear(value);
                  clearFieldError("comparisonYear");
                  setReferencePeriod(yearPeriod(value));
                }}
              >
                <SelectTrigger
                  className={withError(
                    "mt-2 w-[7rem] border-gray-300 shadow-sm h-[42px] px-3",
                    fieldErrors.comparisonYear,
                  )}
                >
                  <SelectValue placeholder="Jahr" />
                </SelectTrigger>
                <SelectContent align="start" className="!w-[7rem] !min-w-[7rem]">
                  {availableComparisonYears.map((year) => (
                    <SelectItem key={year} value={year}>
                      {year}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
              {fieldErrors.comparisonYear ? errorHint : null}
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
                    className={fieldClassName}
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
                    className={fieldClassName}
                  />
                </label>
                <label className="text-sm font-medium">
                  Einheit
                  <input
                    type="text"
                    value="Monat"
                    readOnly
                    className={`${fieldClassName} bg-muted text-muted-foreground`}
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
                    className={fieldClassName}
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
                    className={fieldClassName}
                  />
                </label>
                <label className="text-sm font-medium">
                  Einheit
                  <input
                    type="text"
                    value="Monat"
                    readOnly
                    className={`${fieldClassName} bg-muted text-muted-foreground`}
                  />
                </label>
              </div>
            </section>
          </div>

          <div className="w-full">
            <label className="block text-sm font-medium">Beschreibung{required}</label>
            <textarea
              value={description}
              onChange={(event) => {
                setDescription(event.target.value);
                clearFieldError("description");
              }}
              rows={4}
              className={withError(
                "text-sm mt-2 block w-full resize-y rounded-md border border-gray-300 px-3 py-2 shadow-sm focus:ring focus:ring-opacity-50",
                fieldErrors.description,
              )}
              placeholder="Geben Sie eine kurze Beschreibung ein..."
            />
            {fieldErrors.description ? errorHint : null}
          </div>

          <div className="w-full">
            <label className="block text-sm font-medium">Hierarchie-Vorlage{required}</label>
            <Select value={selectedHierarchyPreset} onValueChange={applyPreset}>
              <SelectTrigger
                className={withError(
                  "mt-2 w-full border-gray-300 shadow-sm h-[42px] px-3",
                  fieldErrors.hierarchies,
                )}
              >
                <SelectValue placeholder="Hierarchie auswählen" />
              </SelectTrigger>
              <SelectContent align="start">
                {hierarchyPresets.map((preset) => (
                  <SelectItem key={preset.key} value={preset.key}>
                    {preset.name}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
            {fieldErrors.hierarchies ? errorHint : null}
            {hierarchies.length > 0 ? (
              <div className="mt-4 rounded border bg-muted/20 px-3 py-2 text-sm">
                Aktiv: {hierarchies[0].segment} &gt; {hierarchies[0].family} &gt;{" "}
                {hierarchies[0].className}
              </div>
            ) : null}
          </div>

          <div>
            <label className="block text-sm font-medium">Typ{required}</label>
            <div className={withError("mt-2 flex flex-col gap-1 rounded p-1", fieldErrors.kpis)}>
              {["Menge", "Umsatz"].map((kpi) => (
                <label key={kpi} className="inline-flex items-center">
                  <input
                    type="radio"
                    name="kpi"
                    value={kpi}
                    checked={kpis.length === 1 && kpis[0] === kpi}
                    onChange={(event) => {
                      setKpis(event.target.checked ? [kpi] : []);
                      clearFieldError("kpis");
                    }}
                    className="h-4 w-4 text-blue-600"
                  />
                  <span className="ml-3 text-sm text-gray-700">{kpi}</span>
                </label>
              ))}
            </div>
            {fieldErrors.kpis ? errorHint : null}
          </div>

          <div className="mt-2 flex w-full justify-start gap-3">
            <Button type="button" variant="outline" onClick={() => navigate("/")}>
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
