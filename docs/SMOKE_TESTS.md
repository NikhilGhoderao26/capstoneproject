# Smoke tests

This document explains the simple smoke-test script included in `scripts/smoke_test.ps1`.

Requirements
- PowerShell (Windows) or pwsh (cross-platform)
- The compose stack must be running (`.\dev.ps1 up`)

Run the script

PowerShell (Windows):

```powershell
.\scripts\smoke_test.ps1
```

Exit codes
- 0: all checks passed
- 2: one or more checks failed

Checks performed
- GET /health on each service (product, order, inventory)
- GET on a sample resource endpoint for each service (/products, /orders, /inventory)
