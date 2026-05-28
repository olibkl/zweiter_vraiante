import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

const plans = new Map();

const clone = (value) => structuredClone(value);

const nextVersion = (current) => (Number.isFinite(current) ? current + 1 : 1);

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const defaultStoreFile = path.resolve(__dirname, "data", "plan-store.json");
const storeFile = process.env.PLAN_STORE_FILE
  ? path.resolve(process.env.PLAN_STORE_FILE)
  : defaultStoreFile;

const ensureStoreDirectory = () => {
  fs.mkdirSync(path.dirname(storeFile), { recursive: true });
};

const persistPlans = () => {
  ensureStoreDirectory();
  const payload = {
    schemaVersion: 1,
    updatedAt: new Date().toISOString(),
    items: [...plans.entries()].map(([planId, entry]) => ({
      planId,
      version: entry.version,
      plan: entry.plan,
    })),
  };
  const tmpFile = `${storeFile}.tmp`;
  fs.writeFileSync(tmpFile, JSON.stringify(payload, null, 2), "utf8");
  fs.renameSync(tmpFile, storeFile);
};

const hydratePlans = () => {
  if (!fs.existsSync(storeFile)) {
    return;
  }
  try {
    const content = fs.readFileSync(storeFile, "utf8");
    const payload = JSON.parse(content);
    const items = Array.isArray(payload?.items) ? payload.items : [];
    items.forEach((item) => {
      if (!item?.planId || !item?.plan) {
        return;
      }
      const version = Number(item.version);
      plans.set(item.planId, {
        version: Number.isFinite(version) && version > 0 ? version : 1,
        plan: item.plan,
      });
    });
  } catch (error) {
    // eslint-disable-next-line no-console
    console.error("Failed to load plan store file:", error);
  }
};

hydratePlans();

export const listPlans = () =>
  [...plans.values()].map((entry) => ({
    planId: entry.plan.document.planId,
    planName: entry.plan.document.planName,
    status: entry.plan.document.status,
    lastModified: entry.plan.document.lastModified,
    version: entry.version,
  }));

export const getPlan = (planId) => {
  const entry = plans.get(planId);
  if (!entry) return null;
  return { plan: clone(entry.plan), version: entry.version };
};

export const putPlan = ({ planId, incomingPlan, expectedVersion, userId }) => {
  const existing = plans.get(planId);
  if (existing && expectedVersion !== existing.version) {
    return { ok: false, error: "PRECONDITION_FAILED", currentVersion: existing.version };
  }

  const version = nextVersion(existing?.version ?? 0);
  const plan = clone(incomingPlan);
  plan.document.planId = planId;
  plan.document.lastModified = new Date().toISOString();
  plan.document.lastModifiedBy = userId;

  plans.set(planId, { plan, version });
  persistPlans();
  return { ok: true, plan: clone(plan), version };
};

const ALLOWED_STATUS = new Set(["Draft", "InReview", "Approved"]);

export const transitionStatus = ({ planId, status, expectedVersion, userId }) => {
  const existing = plans.get(planId);
  if (!existing) return { ok: false, error: "NOT_FOUND" };
  if (expectedVersion !== existing.version) {
    return { ok: false, error: "PRECONDITION_FAILED", currentVersion: existing.version };
  }
  if (!ALLOWED_STATUS.has(status)) {
    return { ok: false, error: "INVALID_STATUS" };
  }

  const from = existing.plan.document.status;
  const valid =
    (from === "Draft" && (status === "Draft" || status === "InReview")) ||
    (from === "InReview" && (status === "Draft" || status === "Approved")) ||
    (from === "Approved" && status === "Draft");

  if (!valid) {
    return { ok: false, error: "INVALID_TRANSITION", from, to: status };
  }

  const plan = clone(existing.plan);
  plan.document.status = status;
  plan.document.lastModified = new Date().toISOString();
  plan.document.lastModifiedBy = userId;
  const version = nextVersion(existing.version);
  plans.set(planId, { plan, version });
  persistPlans();
  return { ok: true, plan: clone(plan), version };
};
