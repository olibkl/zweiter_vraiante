# PACA Planning Repository

## Project Structure

- `apps/`: Active applications and tools (e.g., planning-web-app, planning-api).
- `docs/`: Project documentation.
- `legacy/`: Archived resources.
- `.github/ISSUE_TEMPLATE/`: Issue templates.

Development start guide: `docs/development.md`.
Deploy readiness guide: `docs/deploy-readiness-checklist.md`.
Azure deploy runbook: `docs/deploy-runbook-azure.md`.

## Git Workflow

For every ticket (Feature, Task, Bug, Spike), create a dedicated branch following the naming convention:

```
<type>/<issue-number>-<short-description>
```

**Example:** `feature/123-user-authentication`, `bug/456-fix-error`

For detailed instructions, see [docs/development.md](docs/development.md#git-branching-strategy).

## Legacy

Historical data like `BC_26_3_Planning.zip` can be found in `legacy/archives/`.
