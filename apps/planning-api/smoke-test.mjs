const base = process.env.SMOKE_BASE_URL ?? "http://localhost:3002";

const assert = (condition, message) => {
  if (!condition) {
    throw new Error(message);
  }
};

const run = async () => {
  const health = await fetch(`${base}/health`);
  assert(health.ok, `health failed (${health.status})`);

  const planId = "smoke-plan-001";
  const payload = {
    plan: {
      document: {
        planId,
        planName: "Smoke Plan",
        planningType: "Umsatz",
        description: "smoke",
        status: "Draft",
        lastModified: new Date().toISOString(),
      },
      data: [],
    },
  };

  const create = await fetch(`${base}/api/plans/${planId}`, {
    method: "PUT",
    headers: {
      "content-type": "application/json",
      "if-match": '"0"',
      "x-dev-role": "Planner",
      "x-dev-user": "smoke-user",
    },
    body: JSON.stringify(payload),
  });
  assert(create.ok, `create failed (${create.status})`);

  const get = await fetch(`${base}/api/plans/${planId}`, {
    headers: { "x-dev-role": "Planner" },
  });
  assert(get.ok, `get failed (${get.status})`);

  const etag = get.headers.get("etag");
  assert(Boolean(etag), "etag missing");

  // Concurrency check
  const staleUpdate = await fetch(`${base}/api/plans/${planId}`, {
    method: "PUT",
    headers: {
      "content-type": "application/json",
      "if-match": '"0"',
      "x-dev-role": "Planner",
      "x-dev-user": "smoke-user",
    },
    body: JSON.stringify(payload),
  });
  assert(staleUpdate.status === 412, `expected 412, got ${staleUpdate.status}`);

  // Status transition
  const submit = await fetch(`${base}/api/plans/${planId}/status`, {
    method: "POST",
    headers: {
      "content-type": "application/json",
      "if-match": etag,
      "x-dev-role": "Reviewer",
      "x-dev-user": "smoke-reviewer",
    },
    body: JSON.stringify({ status: "InReview" }),
  });
  assert(submit.ok, `status transition failed (${submit.status})`);

  // eslint-disable-next-line no-console
  console.log("planning-api smoke test passed");
};

run().catch((error) => {
  // eslint-disable-next-line no-console
  console.error(error);
  process.exit(1);
});

