# Model Choice Rationale

## Goal
Select a model setup that is cost-aware, predictable for coding tasks, and robust for iterative student project delivery.

## Why this model profile
- Strong code editing reliability for multi-file refactoring and test-first iterations.
- Good instruction following for strict constraints (status policies, export guards, rounding rules).
- Stable long-context behavior across repeated milestone work.

## Token and cost strategy
- Keep prompts task-focused and split work by milestone (`M2`, `M4`, `M5`, `M7`).
- Reuse shared helper modules to reduce repeated generated code.
- Prefer compact tests with high-signal assertions over verbose snapshots.
- Avoid unnecessary tool calls and bulk file dumps unless needed.

## Research notes for ticket discussion
- Engineering productivity improves when logic is moved into testable pure modules.
- Adapter boundaries reduce rework when switching from mock data to OData.
- Guard policies in store/domain reduce risk compared to UI-only restrictions.

## Decision summary
- Frontend-first business logic for prototype speed and demonstrability.
- Adapter-oriented architecture for future Microsoft/OData deployment path.
- Unit tests as mandatory gate for each logic milestone.
