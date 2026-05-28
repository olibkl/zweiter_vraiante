# Planning Prototype Backlog

## Workflow
Backlog -> Ready -> In Progress -> Review/Test -> Done

## AL Restructuring Tickets

### FEAT-AL-01 Domain model port parity
- Description: Port core AL entities and keep field semantics in TypeScript/C# adapters.
- Acceptance criteria: `PlanningDocument`, `PlanningNode`, `PlanningMetrics` mappings documented and covered by tests.

### FEAT-AL-02 Service decomposition
- Description: Split legacy AL logic into dedicated services (distribution, rollup, export guards, status flow).
- Acceptance criteria: Each service has isolated tests and no UI dependency.

### FEAT-AL-03 Policy layer extraction
- Description: Move status transitions, readonly guards, and export conditions into a policy layer.
- Acceptance criteria: Invalid transitions are blocked and tested.

### FEAT-AL-04 Integration adapter boundary
- Description: Keep comparison import and export behind adapter interfaces, ready for OData.
- Acceptance criteria: Mock adapter can be replaced without changing UI components.

## UX/Presentation Tickets

### FEAT-UX-01 Tree readability upgrade
- Description: Add visual hierarchy guides, improve expand/collapse controls.
- Acceptance criteria: Users can follow 4+ levels without ambiguity.

### FEAT-UX-02 Explainability tooltips
- Description: Add formula/rounding tooltips for planning percentages and distribution behavior.
- Acceptance criteria: Tooltips explain formula and one numeric example.

### FEAT-UX-03 List/detail consistency
- Description: Keep node and tab state when switching planning and details views.
- Acceptance criteria: No data or context loss after view switches.

## Quality Tickets

### TEST-01 Rollup regression suite
- Description: Test bottom-up rollup over multiple depths and monthly totals.
- Acceptance criteria: Green tests for sum integrity.

### TEST-02 Top-down rounding suite
- Description: Test remainder correction and distribution mode behavior.
- Acceptance criteria: Per-month child sums always equal parent target.

### TEST-03 Workflow guard suite
- Description: Test approved readonly mode, status transitions, and export guard.
- Acceptance criteria: Invalid edits/exports fail deterministically.
