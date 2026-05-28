# GitHub Board Work Packages (Beterna Schema)

## Workflow
Backlog -> Ready -> In Progress -> Review/Test -> Done

## Milestone Mapping (M1-M7)

- M1 Planning domain scaffold: Done
- M2 Line generation from layout: Done
- M3 Import comparison data: Partially done (mock integration done, OData open)
- M4 Distribute and roll-up logic: Done (prototype logic)
- M5 Review and approval: Done (status and write protection)
- M6 Export/write-back: Partially done (export contract done, OData write-back open)
- M7 Traceability and tests: Partially done (change log + unit tests + E2E base)

## Feature Items

### FEAT-M1-001 Planning domain model and tree runtime
- Type: Feature
- Priority: Must
- Assignee: `TBD`
- Status: Done
- Description: Planung als Baumstruktur mit Knotenebenen (Total, Segment, Family, Class, Brick), Plan-Header und Kennzahlen in TypeScript umgesetzt.
- Acceptance Criteria:
  - Plan kann als hierarchische Struktur geladen und in der UI dargestellt werden.
  - Jeder Knoten enthaelt Monatswerte, Referenzwerte und Planwerte.
  - Planstatus und Metadaten sind im Modell verfuegbar.

### FEAT-M2-001 Editable planning grid with list and detail context
- Type: Feature
- Priority: Must
- Assignee: `TBD`
- Status: Done
- Description: Listenansicht mit editierbaren Feldern fuer `VK PLAN`, `% PLAN` und Monatswerte plus Kontext fuer selektierten Knoten.
- Acceptance Criteria:
  - Nutzer kann Werte pro Knoten und Monat erfassen.
  - Selektionskontext zeigt Pfad, Level und Kernkennzahlen.
  - Navigation zwischen Listen- und Detailsicht bleibt konsistent.

### FEAT-M3-001 Comparison import integration (mock adapter)
- Type: Feature
- Priority: Should
- Assignee: `TBD`
- Status: Done
- Description: Vergleichsdatenimport fuer ausgewaehltes Vergleichsjahr ueber Integrationsadapter umgesetzt.
- Acceptance Criteria:
  - Vergleichsjahr kann gesetzt und importiert werden.
  - Referenzwerte werden im aktiven Plan sichtbar.
  - Importfehler werden als User-Feedback ausgegeben.

### FEAT-M4-001 Top-down distribution and roll-up invariants
- Type: Feature
- Priority: Must
- Assignee: `TBD`
- Status: Done
- Description: Verteilungslogik und Bottom-up Aggregation umgesetzt, inkl. Restwertkorrektur.
- Acceptance Criteria:
  - Aenderung auf Elternknoten verteilt sich konsistent auf Kinder.
  - Summe der Kinder entspricht nach Recalculate dem Elternzielwert.
  - Monatsverteilung bleibt numerisch stabil.

### FEAT-M5-001 Review and approval status workflow
- Type: Feature
- Priority: Must
- Assignee: `TBD`
- Status: Done
- Description: Statusfluss `Draft -> InReview -> Approved` mit Schutzregeln implementiert.
- Acceptance Criteria:
  - Unerlaubte Statuswechsel sind blockiert.
  - Freigegebene Plaene sind read-only fuer Eingaben.
  - Statuswechsel ist testbar und reproduzierbar.

### FEAT-M6-001 Export contract and release guard
- Type: Feature
- Priority: Should
- Assignee: `TBD`
- Status: Done
- Description: Export nur fuer freigegebene Plaene und exportfaehiger Payloadvertrag integriert.
- Acceptance Criteria:
  - Export ist vor Freigabe gesperrt.
  - Nach Freigabe ist Export moeglich.
  - Fehlerfaelle liefern klare Meldungen.

### FEAT-M7-001 Change log and traceability in workspace
- Type: Feature
- Priority: Should
- Assignee: `TBD`
- Status: Done
- Description: Letzte Aenderungen als protokollierter Verlauf in der UI umgesetzt.
- Acceptance Criteria:
  - Bei erfolgreichem Commit werden Aenderungen mit Zeitstempel geloggt.
  - Sichtbare Historie ist begrenzt und performant.
  - Verlauf ist fuer Demo/Review nachvollziehbar.

### FEAT-DEP-001 API source of truth with optimistic concurrency
- Type: Feature
- Priority: Must
- Assignee: `TBD`
- Status: Done
- Description: Express API mit `ETag`/`If-Match`, Rollen-Gates und stabilisiertem Commit-Flow angebunden.
- Acceptance Criteria:
  - Frontend kann Plan ueber API laden und speichern.
  - Konflikte liefern `412 PRECONDITION_FAILED`.
  - API ist als Source of Truth im `api`-Modus nutzbar.

### FEAT-DEP-002 File-based API persistence
- Type: Feature
- Priority: Must
- Assignee: `TBD`
- Status: Done
- Description: API speichert Plaene dateibasiert (`PLAN_STORE_FILE`) mit atomischen Writes.
- Acceptance Criteria:
  - Werte bleiben nach API-Neustart erhalten.
  - Versionen/ETags bleiben konsistent.
  - Persistenzpfad ist per ENV konfigurierbar.

## Task Items

### TASK-ENG-001 Draft-first edit flow with single commit point
- Type: Task
- Priority: Must
- Assignee: `TBD`
- Status: Done
- Description: Eingaben bleiben lokal als Entwurf; finaler Schreibpunkt ist der Button `Aktualisieren`.
- Acceptance Criteria:
  - `Enter` bestaetigt Entwurf im Feld ohne Sofort-Commit.
  - `Aktualisieren` uebernimmt ausstehende Werte gesammelt.
  - Bei `Approved` sind Eingaben deaktiviert.

### TASK-ENG-002 Keyboard UX and focus navigation
- Type: Task
- Priority: Should
- Assignee: `TBD`
- Status: Done
- Description: Pfeiltasten und Enter-Navigation in editierbaren Feldern verbessert.
- Acceptance Criteria:
  - `ArrowUp`/`ArrowDown` wechseln kontrolliert zum naechsten Feld.
  - `Enter` bestaetigt Eingabe und fuehrt Fokus weiter.
  - Escape verwirft den lokalen Feldentwurf.

### TASK-ENG-003 E2E harness and CI hardening baseline
- Type: Task
- Priority: Should
- Assignee: `TBD`
- Status: Done
- Description: Playwright-Grundtests und CI-Anbindung fuer Kernflow eingerichtet.
- Acceptance Criteria:
  - Mindestens ein E2E-Test prueft Workspace-Controls.
  - API-Modus kann fuer E2E automatisiert gestartet werden.
  - CI fuehrt Web-Lint/Test/Build aus.

### TASK-OPS-001 Deploy runbook and readiness checklist
- Type: Task
- Priority: Should
- Assignee: `TBD`
- Status: Done
- Description: Dokumente fuer Deploy-Pfad Richtung Microsoft/Dataverse erstellt.
- Acceptance Criteria:
  - Runbook enthaelt Konfiguration und Schritte.
  - Readiness-Checklist unterscheidet erledigt vs offen.
  - Offene Punkte fuer Dataverse/Azure AD sind explizit benannt.

## Bug Items

### BUG-VAL-001 Value snap-back after save
- Type: Bug
- Priority: Must
- Assignee: `TBD`
- Status: Done
- Description: Werte sprangen nach Enter/Aktualisieren auf alte Werte zurueck (Race bei mehreren API-Writes).
- Acceptance Criteria:
  - Nach `Aktualisieren` bleiben Werte stabil.
  - Nach Reload bleibt der gespeicherte Wert erhalten.
  - Konfliktfall wird als Nutzerhinweis sichtbar behandelt.

### BUG-UX-001 Tree state collapse after update
- Type: Bug
- Priority: Should
- Assignee: `TBD`
- Status: Done
- Description: Aufgeklappte Ebenen gingen beim Aktualisieren verloren.
- Acceptance Criteria:
  - Expand/Collapse Zustand bleibt ueber Commit erhalten.
  - Nutzerkontext bleibt in der aktuellen Drilldown-Ebene.

### BUG-TEXT-001 Inconsistent umlaut rendering
- Type: Bug
- Priority: Should
- Assignee: `TBD`
- Status: Done
- Description: Einzelne UI-Texte zeigten fehlerhafte Umlaute bzw. uneinheitliche Schreibweisen.
- Acceptance Criteria:
  - Relevante UI-Texte sind sprachlich konsistent.
  - Keine sichtbaren Encoding-Artefakte in Kernbereichen.

## Spike Items

### SPIKE-ARCH-001 Porting strategy AL -> SPA services
- Type: Spike
- Priority: Must
- Assignee: `TBD`
- Status: Done
- Description: Untersuchung und Aufteilung der AL-Fachlogik in Frontend-Services/Store/Policies.
- Acceptance Criteria:
  - Mapping AL-Funktionen zu SPA-Modulen dokumentiert.
  - Kritische Regeln (Roll-up, Top-down, Status) identifiziert.
  - Umsetzungspfade fuer M1-M5 abgeleitet.

### SPIKE-AUTH-001 Azure AD integration approach
- Type: Spike
- Priority: Should
- Assignee: `TBD`
- Status: Done
- Description: Analyse fuer spaetere Azure AD Anbindung (dev/azure mode, Rollenclaims, Tokenfluss).
- Acceptance Criteria:
  - Auth-Modi sind technisch vorbereitet.
  - Mindestanforderungen fuer produktiven Tokenpfad sind dokumentiert.
  - Risiken fuer Go-Live sind benannt.

### SPIKE-DATA-001 Dataverse/OData integration path
- Type: Spike
- Priority: Should
- Assignee: `TBD`
- Status: In Progress
- Description: Zielmapping von Plan-Header/Nodes/Monthly Values zu Dataverse/OData finalisieren.
- Acceptance Criteria:
  - Tabellen- und Feldmapping liegt final vor.
  - Konflikt- und Versionsstrategie fuer Dataverse ist definiert.
  - Read/Write-Pfade fuer M6 sind abgestimmt.

## Definition of Ready / Done Check

### DoR (Kurzcheck pro Item)
- Nutzermehrwert und Zielbild beschrieben
- Akzeptanzkriterien klar und testbar
- Technische Abhaengigkeiten bekannt

### DoD (Kurzcheck pro Item)
- Code gemerged
- Tests/Lint gruen
- Doku minimal aktualisiert
