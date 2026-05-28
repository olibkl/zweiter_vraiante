# planning-api

Express API als server-seitige Source of Truth fuer den Planning-Prototyp.

## Features

- Plan-CRUD Einstieg (`GET/PUT /api/plans/:planId`)
- Optimistic Concurrency per `ETag` + `If-Match`
- Status-Transition Endpoint (`POST /api/plans/:planId/status`)
- Rollen-Gates (`Planner`, `Reviewer`, `Approver`)
- Auth-Modi:
  - `AUTH_MODE=dev` (Header-basiert fuer lokale Entwicklung)
  - `AUTH_MODE=azure` (Azure AD JWT via JWKS)
- Dataverse-ready Envelope (`contractVersion`, `version`, `planHeader`, `nodes`)
- File-basierte Persistenz (`PLAN_STORE_FILE`) mit atomischem Write (tmp + rename)

## Lokal starten

```bash
cd apps/planning-api
npm install
npm run dev
```

Healthcheck:

```bash
curl http://localhost:3002/health
```

## Dev Auth Header

- `x-dev-role: Planner,Reviewer,Approver`
- `x-dev-user: <id>`

## Concurrency Beispiel

1. `GET /api/plans/:id` -> `ETag: "5"`
2. `PUT /api/plans/:id` mit `If-Match: "5"`
3. Bei Parallelaenderung: `412 PRECONDITION_FAILED`

## Persistenz

- Default-Datei: `apps/planning-api/data/plan-store.json`
- Optional ueberschreiben via `PLAN_STORE_FILE`
- Daten bleiben ueber API-Neustarts erhalten
