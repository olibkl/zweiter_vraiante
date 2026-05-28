import type { PlanningObject, PlanningStatus } from "@/types/planning";

type ApiPlanResponse = {
  plan?: PlanningObject;
  data?: {
    plan?: PlanningObject;
  };
};

export class PlanApiError extends Error {
  status: number;

  code?: string;

  constructor(message: string, status: number, code?: string) {
    super(message);
    this.name = "PlanApiError";
    this.status = status;
    this.code = code;
  }
}

const API_BASE_URL =
  import.meta.env.VITE_PLAN_API_BASE_URL?.replace(/\/$/, "") ?? "";

const etagCache = new Map<string, string>();

const ensureApiBaseUrl = () => {
  if (!API_BASE_URL) {
    throw new Error("VITE_PLAN_API_BASE_URL ist nicht gesetzt.");
  }
};

export const isApiModeEnabled = () =>
  (import.meta.env.VITE_PLAN_DATA_MODE ?? "local") === "api";

const readApiError = async (response: Response): Promise<PlanApiError> => {
  let payload: { error?: string; message?: string } | undefined;
  try {
    payload = (await response.json()) as { error?: string; message?: string };
  } catch {
    payload = undefined;
  }
  const message =
    payload?.message ?? `API request fehlgeschlagen (${response.status}).`;
  return new PlanApiError(message, response.status, payload?.error);
};

const readPlanPayload = (payload: ApiPlanResponse): PlanningObject => {
  const plan = payload.plan ?? payload.data?.plan;
  if (!plan) {
    throw new PlanApiError("API Antwort enthaelt keinen Plan.", 500, "INVALID_PAYLOAD");
  }
  return plan;
};

export const loadPlanFromApi = async (planId: string): Promise<PlanningObject> => {
  ensureApiBaseUrl();
  const response = await fetch(`${API_BASE_URL}/api/plans/${planId}`, {
    headers: {
      "x-dev-role": "Planner,Reviewer,Approver",
      "x-dev-user": "frontend-user",
    },
  });
  if (!response.ok) {
    throw await readApiError(response);
  }
  const etag = response.headers.get("etag");
  if (etag) {
    etagCache.set(planId, etag);
  }
  const payload = (await response.json()) as ApiPlanResponse;
  return readPlanPayload(payload);
};

export const savePlanToApi = async (plan: PlanningObject): Promise<PlanningObject> => {
  ensureApiBaseUrl();
  const planId = plan.document.planId;
  const etag = etagCache.get(planId) ?? '"0"';
  const response = await fetch(`${API_BASE_URL}/api/plans/${planId}`, {
    method: "PUT",
    headers: {
      "content-type": "application/json",
      "if-match": etag,
      "x-dev-role": "Planner",
      "x-dev-user": "frontend-user",
    },
    body: JSON.stringify({ plan }),
  });
  if (!response.ok) {
    throw await readApiError(response);
  }
  const nextEtag = response.headers.get("etag");
  if (nextEtag) {
    etagCache.set(planId, nextEtag);
  }
  const payload = (await response.json()) as ApiPlanResponse;
  return readPlanPayload(payload);
};

export const transitionPlanStatusApi = async (
  planId: string,
  status: PlanningStatus,
): Promise<PlanningObject> => {
  ensureApiBaseUrl();
  const etag = etagCache.get(planId);
  if (!etag) {
    throw new Error("Kein ETag vorhanden. Bitte Plan zuerst laden.");
  }
  const response = await fetch(`${API_BASE_URL}/api/plans/${planId}/status`, {
    method: "POST",
    headers: {
      "content-type": "application/json",
      "if-match": etag,
      "x-dev-role": "Reviewer,Approver",
      "x-dev-user": "frontend-user",
    },
    body: JSON.stringify({ status }),
  });
  if (!response.ok) {
    throw await readApiError(response);
  }
  const nextEtag = response.headers.get("etag");
  if (nextEtag) {
    etagCache.set(planId, nextEtag);
  }
  const payload = (await response.json()) as ApiPlanResponse;
  return readPlanPayload(payload);
};
