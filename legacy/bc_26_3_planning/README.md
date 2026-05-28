# BC 26.3 Planning Legacy

This folder contains the legacy code package from `BC_26_3_Planning.zip`, prepared for practical development work.

## Structure

- `BC_26_3_Planning.zip`
  - Original delivery archive (kept untouched).
- `raw/`
  - Unchanged extracted source snapshot.
  - Current source root: `raw/Planning/`
- `organized/`
  - Development-friendly structure grouped by domain and AL object type.
- `scripts/rebuild-organized.sh`
  - Rebuilds `organized/` from `raw/` deterministically.

## Organized Layout

`organized/` is grouped as:

- Domain:
  - `core-planning`
  - `fashion-statistic`
  - `scenario`
- Object type (per domain):
  - `codeunits`, `pages`, `tables`, `queries`, `reports`, `enums`, `xmlports`, `misc`

## Current Inventory

Total AL files in `raw/`: 78  
Total AL files in `organized/`: 78

By domain/type:

- `core-planning/codeunits`: 12
- `core-planning/enums`: 1
- `core-planning/pages`: 29
- `core-planning/queries`: 2
- `core-planning/reports`: 2
- `core-planning/tables`: 19
- `core-planning/xmlports`: 1
- `fashion-statistic/codeunits`: 1
- `fashion-statistic/pages`: 1
- `fashion-statistic/tables`: 1
- `fashion-statistic/xmlports`: 1
- `scenario/codeunits`: 1
- `scenario/pages`: 4
- `scenario/tables`: 3

## Usage

Rebuild the organized tree after any change in `raw/`:

```bash
bash legacy/bc_26_3_planning/scripts/rebuild-organized.sh
```

Recommended workflow:

1. Keep `raw/` as archive-compatible baseline.
2. Use `organized/` for navigation, analysis, and incremental migration work.
3. Re-run the script whenever `raw/` changes.
