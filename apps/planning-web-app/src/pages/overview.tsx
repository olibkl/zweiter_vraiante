import { usePlanStore } from "@/store/usePlanStore";
import { useState } from "react";
import {
  Card,
  CardHeader,
  CardTitle,
  CardContent,
  CardFooter,
} from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Plus } from "lucide-react";
import { Link } from "react-router-dom";
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

export default function Overview() {
  const allPlans = usePlanStore((state) => state.allPlans);
  const drafts = allPlans.filter((obj) => obj.document.status === "Draft");
  const inReview = allPlans.filter((obj) => obj.document.status === "InReview");
  const approved = allPlans.filter((obj) => obj.document.status === "Approved");

  const [filter, setFilter] = useState<
    "all" | "drafts" | "inReview" | "approved"
  >("all");

  let filteredPlans = allPlans;
  if (filter === "drafts") filteredPlans = drafts;
  else if (filter === "inReview") filteredPlans = inReview;
  else if (filter === "approved") filteredPlans = approved;

  const renderPlanCards = (plans: PlanningObject[]) =>
    plans.map((obj) => (
      <Card key={obj.document.planId} className="flex flex-col h-[16.75rem]">
        <CardHeader>
          <CardTitle>{obj.document.planName}</CardTitle>
        </CardHeader>
        <CardContent className="flex-1 pb-0">
          <div className="space-y-3">
            <div className="space-y-1 text-sm text-muted-foreground">
              <p>ID: {obj.document.planId}</p>
              <p className="truncate">Plantyp: {obj.document.planningType}</p>
              <p>Zuletzt bearbeitet: {formatDate(obj.document.lastModified)}</p>
            </div>
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
              {obj.document.status === "Approved"
                ? "Freigegeben"
                : obj.document.status === "InReview"
                  ? "In Prüfung"
                  : "Entwurf"}
            </Badge>
          </div>
        </CardContent>
        <CardFooter className="p-0 px-6 py-1">
          <Button asChild className="w-full">
            <Link to={`/workspace/${obj.document.planId}`}>Öffnen</Link>
          </Button>
        </CardFooter>
      </Card>
    ));

  return (
    <div>
      <div className="py-6 pt-4">
        <div className="flex items-center justify-between gap-4">
          <h1 className="text-3xl font-bold">Planübersicht</h1>
          <Button asChild size="icon" aria-label="Plan hinzufügen">
            <Link to="/setup">
              <Plus className="h-4 w-4" />
            </Link>
          </Button>
        </div>
        <div className="flex gap-1 mt-6">
          <Button
            variant={filter === "all" ? "default" : "outline"}
            onClick={() => setFilter("all")}
            className="text-sm px-3 h-8 rounded-full"
          >
            Alle Pläne
          </Button>
          <Button
            variant={filter === "drafts" ? "default" : "outline"}
            onClick={() => setFilter("drafts")}
            className="text-sm px-3 h-8 rounded-full"
          >
            Entwürfe
          </Button>
          <Button
            variant={filter === "inReview" ? "default" : "outline"}
            onClick={() => setFilter("inReview")}
            className="text-sm px-3 h-8 rounded-full"
          >
            In Prüfung
          </Button>
          <Button
            variant={filter === "approved" ? "default" : "outline"}
            onClick={() => setFilter("approved")}
            className="text-sm px-3 h-8 rounded-full"
          >
            Freigegeben
          </Button>
        </div>
      </div>
      <div className="py-2">
        <div className="grid w-full gap-4 sm:grid-cols-2 xl:grid-cols-4">
          {renderPlanCards(filteredPlans)}
        </div>
      </div>
    </div>
  );
}
