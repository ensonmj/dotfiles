# ==========================================================
# WSL Networking Auto-Recovery (DHCP / Automatic IP)
# ==========================================================

# Ensure running as Administrator
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "ERROR: This script must be run as Administrator!" -ForegroundColor Red
    pause
    exit
}

# --- CONFIGURATION ---
#$adapter = "Ethernet"  # Change this if your adapter name is different (e.g. "Wi-Fi")
$adapter = "Wi-Fi"

$maxAttempts = 15
$attempt = 0
$success = $false

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "WSL Auto-Recovery Script (DHCP Mode)" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

while (-not $success -and $attempt -lt $maxAttempts) {
    $attempt++
    Write-Host "--- Attempt $attempt of $maxAttempts ---" -ForegroundColor Yellow
    
    # 1. Shutdown WSL
    Write-Host "[1/6] Shutting down WSL..." -ForegroundColor Cyan
    wsl --shutdown
    Start-Sleep -Seconds 2
    
    # 2. Flush ARP Cache (Safe reset)
    Write-Host "[2/6] Flushing Network State..." -ForegroundColor Cyan
    netsh interface ip delete arpcache | Out-Null
    
    # 3. Restart HNS
    Write-Host "[3/6] Restarting Host Network Service..." -ForegroundColor Cyan
    try {
        Stop-Service hns -Force -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 1
        Start-Service hns -ErrorAction Stop
    } catch {
        Write-Host "Warning: HNS restart encountered an issue, continuing..." -ForegroundColor Yellow
    }
    
    # 4. Enable Automatic IP (DHCP)
    Write-Host "[4/6] Setting Adapter '$adapter' to Automatic (DHCP)..." -ForegroundColor Cyan
    
    # Ensure adapter is up
    netsh interface set interface $adapter admin=enable 2>$null
    Start-Sleep -Seconds 1
    
    # Set IP and DNS to DHCP
    netsh interface ipv4 set address name=$adapter source=dhcp 2>$null
    netsh interface ipv4 set dns name=$adapter source=dhcp 2>$null
    
    if ($LASTEXITCODE -ne 0) { 
        # Ignore error if it's already DHCP, but log just in case
        Write-Host "  > Info: Adapter might already be in DHCP mode." -ForegroundColor DarkGray 
    }
    
    # 5. Start WSL and capture output (Fixed Encoding)
    Write-Host "[5/6] Starting WSL and checking for errors..." -ForegroundColor Cyan
    
    # We capture output as a raw array, then sanitize it
    $rawOutput = wsl echo "WSL_STARTED" 2>&1
    
    # Convert to single string and remove Null bytes
    $cleanOutput = ($rawOutput | ForEach-Object { $_.ToString() }) -join "`n"
    $cleanOutput = $cleanOutput -replace "`0", "" 

    # 6. Check for errors
    Write-Host "[6/6] Analyzing WSL startup..." -ForegroundColor Cyan
    
    $hasError = ($cleanOutput -like "*0x8007054f*") -or 
                ($cleanOutput -like "*Failed to configure network*") -or 
                ($cleanOutput -like "*falling back to networkingMode*") -or
                ($cleanOutput -like "*internal error*")

    if ($hasError) {
        Write-Host "ERROR DETECTED: WSL networking issue still present." -ForegroundColor Red
        Write-Host "Error details:" -ForegroundColor DarkGray
        Write-Host $cleanOutput -ForegroundColor DarkGray
        Write-Host "Retrying in 4 seconds..." -ForegroundColor Yellow
        Write-Host ""
        wsl --shutdown
        Start-Sleep -Seconds 4
        
    } else {
        if ($cleanOutput -like "*WSL_STARTED*") {
            Write-Host "SUCCESS! WSL started cleanly." -ForegroundColor Green
            Write-Host "Output: $cleanOutput" -ForegroundColor DarkGray
            $success = $true
        } else {
            Write-Host "ERROR: WSL start was ambiguous. Retrying." -ForegroundColor Red
            Write-Host "Output: $cleanOutput" -ForegroundColor DarkGray
        }
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan

if ($success) {
    Write-Host "WSL is now running successfully!" -ForegroundColor Green
    Write-Host "Network is set to Automatic (DHCP)." -ForegroundColor Green
    Write-Host ""
    Write-Host "Press Ctrl+C to stop the script." -ForegroundColor DarkGray
    
    # Keep the script running to maintain WSL
    while ($true) {
        Start-Sleep -Seconds 30
        $check = wsl echo "alive" 2>&1
        if ($check -notmatch "alive") {
            Write-Host "WSL appears to have stopped. Exiting loop..." -ForegroundColor Red
            break
        }
    }
} else {
    Write-Host "FAILED: Could not resolve WSL networking after $maxAttempts attempts." -ForegroundColor Red
}
pause