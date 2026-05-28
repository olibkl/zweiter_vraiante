# Azure Deploy Runbook

## 1) Frontend (`planning-web-app`)

- Build command: `npm run build`
- Output: `apps/planning-web-app/dist`
- Target: Azure Static Web Apps or App Service (Nginx container)

Required app settings:

- `VITE_PLAN_DATA_MODE=api`
- `VITE_PLAN_API_BASE_URL=https://<your-api-host>`

## 2) API (`planning-api`)

- Start command: `node index.js`
- Health endpoint: `/health`

Required app settings (dev fallback):

- `PORT=3002`
- `AUTH_MODE=dev`
- `CORS_ORIGINS=https://<your-frontend-host>`

Required app settings (production):

- `AUTH_MODE=azure`
- `AZURE_AD_ISSUER=https://login.microsoftonline.com/<tenant-id>/v2.0`
- `AZURE_AD_AUDIENCE=api://<app-id-or-client-id>`
- `CORS_ORIGINS=https://<your-frontend-host>`

## 3) Dataverse Integration Step

Before production cutover:

- Replace in-memory store (`apps/planning-api/store.js`) with Dataverse adapter.
- Keep API contracts unchanged (`/api/plans`, ETag flow), only persistence layer swaps.

## 4) CI Gates (already added)

- Web: lint + unit tests + build
- API: syntax check + smoke test

Workflow file:

- `.github/workflows/ci.yml`

## 5) Post-deploy verification

1. `GET /health` returns `status=ok`.
2. Frontend opens and loads plan list/detail.
3. Edit + `Aktualisieren` persists.
4. Reload keeps values.
5. Parallel edit conflict returns `412` and is handled.

