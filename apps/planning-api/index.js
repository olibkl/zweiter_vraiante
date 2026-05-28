import cors from "cors";
import express from "express";
import { authMiddleware, requireAnyRole } from "./auth.js";
import { toDataverseEnvelope } from "./dataverse-mapping.js";
import { getPlan, listPlans, putPlan, transitionStatus } from "./store.js";

const app = express();
const port = Number(process.env.PORT ?? 3002);
const authMode = process.env.AUTH_MODE ?? "dev";
const corsOrigins = (process.env.CORS_ORIGINS ?? "")
  .split(",")
  .map((entry) => entry.trim())
  .filter(Boolean);

if (
  authMode === "azure" &&
  (!process.env.AZURE_AD_ISSUER || !process.env.AZURE_AD_AUDIENCE)
) {
  throw new Error(
    "AUTH_MODE=azure requires AZURE_AD_ISSUER and AZURE_AD_AUDIENCE.",
  );
}

app.use(
  cors({
    origin: corsOrigins.length > 0 ? corsOrigins : true,
  }),
);
app.use(express.json({ limit: "2mb" }));

const sendSuccess = (res, payload, etag) => {
  if (etag !== undefined) {
    res.setHeader("ETag", `"${etag}"`);
  }
  return res.json({ ok: true, data: payload });
};

const sendError = (res, status, code, message, details) =>
  res.status(status).json({
    ok: false,
    error: {
      code,
      message,
      ...(details ? { details } : {}),
    },
  });

app.get("/health", (_req, res) => {
  return res.json({
    status: "ok",
    service: "planning-api",
    authMode,
    now: new Date().toISOString(),
  });
});

app.use("/api", authMiddleware);

app.get(
  "/api/plans",
  requireAnyRole("Planner", "Reviewer", "Approver"),
  (_req, res) => {
    return sendSuccess(res, { items: listPlans() });
  },
);

app.get(
  "/api/plans/:planId",
  requireAnyRole("Planner", "Reviewer", "Approver"),
  (req, res) => {
    const { planId } = req.params;
    const entry = getPlan(planId);
    if (!entry) {
      return sendError(res, 404, "NOT_FOUND", "Plan nicht gefunden.");
    }
    return sendSuccess(
      res,
      {
        plan: entry.plan,
        envelope: toDataverseEnvelope(entry.plan, entry.version),
      },
      entry.version,
    );
  },
);

app.put("/api/plans/:planId", requireAnyRole("Planner"), (req, res) => {
  const { planId } = req.params;
  const incomingPlan = req.body?.plan;
  if (!incomingPlan?.document?.planId) {
    return sendError(res, 400, "BAD_REQUEST", "request.body.plan fehlt.");
  }

  const ifMatch = req.header("if-match");
  const expectedVersion = Number(String(ifMatch ?? "").replace(/"/g, ""));
  if (!Number.isFinite(expectedVersion)) {
    return sendError(
      res,
      428,
      "PRECONDITION_REQUIRED",
      "If-Match Header mit ETag-Version erforderlich.",
    );
  }

  const result = putPlan({
    planId,
    incomingPlan,
    expectedVersion,
    userId: req.user?.id ?? "unknown-user",
  });

  if (!result.ok) {
    if (result.error === "PRECONDITION_FAILED") {
      return sendError(
        res,
        412,
        result.error,
        "Versionskonflikt: Plan wurde zwischenzeitlich geaendert.",
        { currentVersion: result.currentVersion },
      );
    }
    return sendError(res, 400, result.error, "Ungueltige Anfrage.");
  }

  return sendSuccess(
    res,
    {
      plan: result.plan,
      envelope: toDataverseEnvelope(result.plan, result.version),
    },
    result.version,
  );
});

app.post(
  "/api/plans/:planId/status",
  requireAnyRole("Reviewer", "Approver"),
  (req, res) => {
    const { planId } = req.params;
    const { status } = req.body ?? {};

    const ifMatch = req.header("if-match");
    const expectedVersion = Number(String(ifMatch ?? "").replace(/"/g, ""));
    if (!Number.isFinite(expectedVersion)) {
      return sendError(
        res,
        428,
        "PRECONDITION_REQUIRED",
        "If-Match Header mit ETag-Version erforderlich.",
      );
    }

    const result = transitionStatus({
      planId,
      status,
      expectedVersion,
      userId: req.user?.id ?? "unknown-user",
    });

    if (!result.ok) {
      if (result.error === "NOT_FOUND") {
        return sendError(res, 404, "NOT_FOUND", "Plan nicht gefunden.");
      }
      if (result.error === "PRECONDITION_FAILED") {
        return sendError(
          res,
          412,
          result.error,
          "Versionskonflikt: Plan wurde zwischenzeitlich geaendert.",
          { currentVersion: result.currentVersion },
        );
      }
      return sendError(
        res,
        400,
        result.error,
        result.error === "INVALID_TRANSITION"
          ? `Ungueltiger Statuswechsel: ${result.from} -> ${result.to}`
          : "Ungueltiger Status",
      );
    }

    return sendSuccess(
      res,
      {
        plan: result.plan,
        envelope: toDataverseEnvelope(result.plan, result.version),
      },
      result.version,
    );
  },
);

app.listen(port, () => {
  // eslint-disable-next-line no-console
  console.log(`planning-api listening on http://localhost:${port}`);
});

app.use((error, _req, res, _next) => {
  // eslint-disable-next-line no-console
  console.error(error);
  return sendError(
    res,
    500,
    "INTERNAL_SERVER_ERROR",
    "Unerwarteter Serverfehler.",
  );
});
