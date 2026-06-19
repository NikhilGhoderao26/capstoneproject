<#
Simple smoke-test script for the local capstoneproject stack.
Checks /health on each service and a sample resource endpoint.
Exits with code 0 when all checks pass, non-zero otherwise.
#>

param(
  [int]$TimeoutSec = 5
)

$services = @{
  product = @{ base = 'http://localhost:5000'; resource = '/products' }
  order = @{ base = 'http://localhost:5001'; resource = '/orders' }
  inventory = @{ base = 'http://localhost:5002'; resource = '/inventory' }
}

$failed = @()

Write-Host "Running smoke tests against services..."

foreach ($name in $services.Keys) {
  $base = $services[$name].base
  $healthUrl = "$base/health"
  $resourceUrl = "$base$($services[$name].resource)"

  Write-Host "\nTesting $name service: $base"

  Try {
    $h = Invoke-WebRequest -Uri $healthUrl -UseBasicParsing -TimeoutSec $TimeoutSec -ErrorAction Stop
    if ($h.StatusCode -eq 200) { Write-Host "  /health => 200 OK" } else { Write-Host "  /health => $($h.StatusCode)"; $failed += "$name /health ($($h.StatusCode))" }
  } Catch {
    Write-Host "  /health failed: $($_.Exception.Message)"; $failed += "$name /health (error)"
  }

  Try {
    $r = Invoke-WebRequest -Uri $resourceUrl -UseBasicParsing -TimeoutSec $TimeoutSec -ErrorAction Stop
    if ($r.StatusCode -ge 200 -and $r.StatusCode -lt 300) { Write-Host "  $($services[$name].resource) => $($r.StatusCode)" } else { Write-Host "  $($services[$name].resource) => $($r.StatusCode)"; $failed += "$name $($services[$name].resource) ($($r.StatusCode))" }
  } Catch {
    Write-Host "  $($services[$name].resource) failed: $($_.Exception.Message)"; $failed += "$name $($services[$name].resource) (error)"
  }
}

Write-Host "\nSmoke test summary:"
if ($failed.Count -eq 0) {
  Write-Host "  All checks passed ✅"
  exit 0
} else {
  Write-Host "  Failures detected:"; $failed | ForEach-Object { Write-Host "   - $_" }
  exit 2
}
