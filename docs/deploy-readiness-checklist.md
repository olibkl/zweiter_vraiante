# Deploy Readiness Checklist (Microsoft + Dataverse)

## Implementiert in diesem Stand

- Server-seitige API als Source of Truth (`apps/planning-api`)
- Concurrency ueber `ETag`/`If-Match`
- Rollen-Gates in API (`Planner`, `Reviewer`, `Approver`)
- Azure AD Token-Pfad vorbereitet (`AUTH_MODE=azure`)
- File-basierte Persistenz in der API (`PLAN_STORE_FILE`)
- Frontend API-Client + Data-Mode Flag (`local` vs `api`)
- Draft-first Eingabefluss mit eindeutigem Commit ueber `Aktualisieren`
- E2E-Test-Grundgeruest (`apps/planning-web-app/e2e`)

## Vor Go-Live noch erledigen

- Dataverse Tabellen physisch anlegen und Feldmapping finalisieren
- API Persistenz von lokaler Datei auf Dataverse/DB umstellen
- Azure AD App Registration + Scopes + Rollenclaims verifizieren
- CI Pipeline um API-Mode E2E erweitern (`npm run test:e2e`)
- Secrets/Env in Azure (App Service / Static Web Apps) setzen
- Monitoring: Application Insights + Error Alerts

## Ziel-Architektur (kurz)

- `planning-web-app` -> `planning-api` (Bearer Token)
- `planning-api` -> Dataverse
- Dataverse ist finale Datenquelle fuer Plan-Header, Nodes, Monthly Values, Status/History
