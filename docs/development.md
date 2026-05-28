# Development Setup

## Prerequisites

- Node.js LTS (recommended: 20.x or newer)
- npm (comes with Node.js)

## Start the Project

The app is located in `apps/planning-web-app`.

```bash
cd apps/planning-web-app
npm install
npm run dev
```

After running the command, the local dev URL is shown in the terminal output (typically `http://localhost:5173`).

## Start with API Source of Truth

```bash
cd apps/planning-api
npm install
npm run dev
```

Then in another terminal:

```bash
cd apps/planning-web-app
cp .env.example .env
```

Set in `.env`:

```env
VITE_PLAN_DATA_MODE=api
VITE_PLAN_API_BASE_URL=http://localhost:3002
```

Start the frontend:

```bash
npm run dev
```

## Git Branching Strategy

For every ticket (Feature, Task, Bug, or Spike), create a dedicated branch.

### Branch Naming Convention

Use the following format:

```
<type>/<issue-number>-<short-description>
```

Types:

- `feature/` — for feature requests
- `task/` — for technical tasks
- `bug/` — for bug fixes
- `spike/` — for research/spike work

Examples:

- `feature/123-user-authentication`
- `bug/456-fix-null-pointer-error`
- `task/789-refactor-api-layer`
- `spike/101-evaluate-auth-library`

### Workflow

1. Create a new branch from `main`:
   ```bash
   git checkout -b feature/123-description
   ```
2. Work on your changes.
3. Push the branch and create a pull request.
4. After review and merge, delete the branch.

## Troubleshooting

- Error "Cannot find type definition file for 'node'":
  - Make sure `npm install` was run in `apps/planning-web-app`.
- Port already in use:
  - Stop the running process or start Vite on a different port.
