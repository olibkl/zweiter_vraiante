import { useMemo, useState } from "react";
import { usePlanStore } from "@/store/usePlanStore";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Badge } from "@/components/ui/badge";
import {
  DropdownMenu,
  DropdownMenuCheckboxItem,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { Link, useNavigate } from "react-router-dom";
import { ArrowRight, ArrowUpDown, Filter, Plus, Search } from "lucide-react";
import type { PlanningObject } from "@/types/planning";

function formatDate(dateString: string): string {
  const date = dateString.includes("T")
    ? new Date(dateString)
    : new Date(`${dateString}T00:00:00`);
  return date.toLocaleDateString("de-DE", {
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
  });
}

type SortMode = "modified_desc" | "modified_asc" | "name_asc" | "name_desc";

const getStatusLabel = (status: PlanningObject["document"]["status"]) => {
  if (status === "Approved") return "Freigegeben";
  if (status === "InReview") return "In PrÃ¼fung";
  return "Entwurf";
};

export default function Overview() {
  const navigate = useNavigate();
  const allPlans = usePlanStore((state) => state.allPlans);
  const [searchQuery, setSearchQuery] = useState("");
  const [statusFilter, setStatusFilter] = useState<
    Array<PlanningObject["document"]["status"]>
  >(["Draft", "InReview", "Approved"]);
  const [typeFilter, setTypeFilter] = useState<string[]>([]);
  const [sortMode, setSortMode] = useState<SortMode>("modified_desc");

  const planTypes = useMemo(
    () => Array.from(new Set(allPlans.map((plan) => plan.document.planningType))),
    [allPlans],
  );

  const filteredPlans = useMemo(() => {
    const normalizedQuery = searchQuery.trim().toLowerCase();
    const base = allPlans.filter((plan) => {
      const matchesSearch =
        normalizedQuery.length === 0 ||
        plan.document.planName.toLowerCase().includes(normalizedQuery) ||
        plan.document.planId.toLowerCase().includes(normalizedQuery);
      const matchesStatus = statusFilter.includes(plan.document.status);
      const matchesType =
        typeFilter.length === 0 || typeFilter.includes(plan.document.planningType);
      return matchesSearch && matchesStatus && matchesType;
    });

    const sorted = [...base];
    sorted.sort((a, b) => {
      if (sortMode === "modified_desc") {
        return (
          new Date(b.document.lastModified).getTime() -
          new Date(a.document.lastModified).getTime()
        );
      }
      if (sortMode === "modified_asc") {
        return (
          new Date(a.document.lastModified).getTime() -
          new Date(b.document.lastModified).getTime()
        );
      }
      if (sortMode === "name_asc") {
        return a.document.planName.localeCompare(b.document.planName, "de");
      }
      return b.document.planName.localeCompare(a.document.planName, "de");
    });
    return sorted;
  }, [allPlans, searchQuery, statusFilter, typeFilter, sortMode]);

  const toggleStatus = (status: PlanningObject["document"]["status"]) => {
    setStatusFilter((prev) => {
      if (prev.includes(status)) return prev.filter((item) => item !== status);
      return [...prev, status];
    });
  };

  const toggleType = (planningType: string) => {
    setTypeFilter((prev) => {
      if (prev.includes(planningType)) return prev.filter((item) => item !== planningType);
      return [...prev, planningType];
    });
  };

  const openPlan = (planId: string) => navigate(`/workspace/${planId}`);

  return (
    <div className="space-y-3 py-3">
      <div className="flex items-center justify-between gap-4">
        <h1 className="text-4xl font-bold tracking-tight">Planübersicht</h1>
        <Button asChild size="icon" aria-label="Plan hinzufügen" className="h-9 w-9 rounded-xl">
          <Link to="/setup">
            <Plus className="h-4 w-4" />
          </Link>
        </Button>
      </div>

      <div className="flex flex-wrap items-center gap-2">
        <div className="relative min-w-[280px] flex-1">
          <Search className="pointer-events-none absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
          <Input
            value={searchQuery}
            onChange={(event) => setSearchQuery(event.target.value)}
            placeholder="Plan suchen..."
            className="h-10 pl-9 text-base"
          />
        </div>
        <DropdownMenu>
          <DropdownMenuTrigger asChild>
            <Button variant="outline" size="sm" className="h-10 gap-2 text-base">
              <Filter className="h-4 w-4" />
              Filter
            </Button>
          </DropdownMenuTrigger>
          <DropdownMenuContent align="end" className="w-56">
            <DropdownMenuItem disabled>Status</DropdownMenuItem>
            <DropdownMenuCheckboxItem
              checked={statusFilter.includes("Draft")}
              onCheckedChange={() => toggleStatus("Draft")}
            >
              EntwÃ¼rfe
            </DropdownMenuCheckboxItem>
            <DropdownMenuCheckboxItem
              checked={statusFilter.includes("InReview")}
              onCheckedChange={() => toggleStatus("InReview")}
            >
              In PrÃ¼fung
            </DropdownMenuCheckboxItem>
            <DropdownMenuCheckboxItem
              checked={statusFilter.includes("Approved")}
              onCheckedChange={() => toggleStatus("Approved")}
            >
              Freigegeben
            </DropdownMenuCheckboxItem>
            <DropdownMenuItem disabled className="mt-1">
              Plantyp
            </DropdownMenuItem>
            {planTypes.map((planningType) => (
              <DropdownMenuCheckboxItem
                key={planningType}
                checked={typeFilter.includes(planningType)}
                onCheckedChange={() => toggleType(planningType)}
              >
                {planningType}
              </DropdownMenuCheckboxItem>
            ))}
          </DropdownMenuContent>
        </DropdownMenu>
        <DropdownMenu>
          <DropdownMenuTrigger asChild>
            <Button variant="outline" size="sm" className="h-10 gap-2 text-base">
              <ArrowUpDown className="h-4 w-4" />
              Sortieren
            </Button>
          </DropdownMenuTrigger>
          <DropdownMenuContent align="end">
            <DropdownMenuCheckboxItem
              checked={sortMode === "modified_desc"}
              onCheckedChange={() => setSortMode("modified_desc")}
            >
              Zuletzt bearbeitet (neu zuerst)
            </DropdownMenuCheckboxItem>
            <DropdownMenuCheckboxItem
              checked={sortMode === "modified_asc"}
              onCheckedChange={() => setSortMode("modified_asc")}
            >
              Zuletzt bearbeitet (alt zuerst)
            </DropdownMenuCheckboxItem>
            <DropdownMenuCheckboxItem
              checked={sortMode === "name_asc"}
              onCheckedChange={() => setSortMode("name_asc")}
            >
              Name (A-Z)
            </DropdownMenuCheckboxItem>
            <DropdownMenuCheckboxItem
              checked={sortMode === "name_desc"}
              onCheckedChange={() => setSortMode("name_desc")}
            >
              Name (Z-A)
            </DropdownMenuCheckboxItem>
          </DropdownMenuContent>
        </DropdownMenu>
      </div>

      <div className="overflow-hidden rounded-xl border border-border/90">
        <table className="w-full text-left">
          <thead className="bg-muted/45">
            <tr className="border-b">
              <th className="px-5 py-2.5 text-[0.95rem] font-semibold">Plan</th>
              <th className="px-5 py-2.5 text-[0.95rem] font-semibold">Plan-ID</th>
              <th className="px-5 py-2.5 text-[0.95rem] font-semibold">Plantyp</th>
              <th className="px-5 py-2.5 text-[0.95rem] font-semibold">Zuletzt bearbeitet</th>
              <th className="px-5 py-2.5 text-[0.95rem] font-semibold">Status</th>
              <th className="w-14 px-3 py-2.5" />
            </tr>
          </thead>
          <tbody>
            {filteredPlans.map((obj) => (
              <tr
                key={obj.document.planId}
                className="group border-b bg-background transition-colors hover:bg-slate-200/75"
              >
                <td className="cursor-pointer px-5 py-3 text-[1.02rem] font-medium leading-tight" onClick={() => openPlan(obj.document.planId)}>
                  {obj.document.planName}
                </td>
                <td className="cursor-pointer px-5 py-3 text-[0.98rem] font-mono leading-tight" onClick={() => openPlan(obj.document.planId)}>
                  {obj.document.planId}
                </td>
                <td className="cursor-pointer px-5 py-3 text-[0.98rem] leading-tight" onClick={() => openPlan(obj.document.planId)}>
                  {obj.document.planningType}
                </td>
                <td className="cursor-pointer px-5 py-3 text-[0.98rem] leading-tight" onClick={() => openPlan(obj.document.planId)}>
                  {formatDate(obj.document.lastModified)}
                </td>
                <td className="cursor-pointer px-5 py-3" onClick={() => openPlan(obj.document.planId)}>
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
                        ? "w-fit border-green-400 text-green-700 bg-green-50"
                        : obj.document.status === "InReview"
                          ? "w-fit border-orange-400 text-orange-700 bg-orange-50"
                          : "w-fit"
                    }
                  >
                    {getStatusLabel(obj.document.status)}
                  </Badge>
                </td>
                <td className="px-3 py-3 text-right">
                  <div className="flex items-center justify-end">
                    <Button asChild variant="ghost" size="icon" className="h-8 w-8" aria-label="Plan öffnen">
                      <Link to={`/workspace/${obj.document.planId}`}>
                        <ArrowRight className="h-4 w-4 text-muted-foreground transition-colors group-hover:text-foreground" />
                      </Link>
                    </Button>
                  </div>
                </td>
              </tr>
            ))}
            {filteredPlans.length === 0 ? (
              <tr>
                <td colSpan={6} className="px-6 py-10 text-center text-muted-foreground">
                  Keine PlÃ¤ne fÃ¼r die aktuelle Suche/Filter gefunden.
                </td>
              </tr>
            ) : null}
          </tbody>
        </table>
      </div>
    </div>
  );
}

