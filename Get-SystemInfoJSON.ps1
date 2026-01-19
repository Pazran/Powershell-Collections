# ------------------------------------------------------------
#  Get-SystemInfoJSON.ps1   –  One‑liner system inventory JSON
# ------------------------------------------------------------

$hostname  = $env:COMPUTERNAME
$osVersion = (Get-CimInstance Win32_OperatingSystem).Caption
$processor = (Get-CimInstance Win32_Processor).Name

# Total RAM in GB, rounded to two decimals
$totalRamGB = "{0:N2}" -f (
    (Get-CimInstance Win32_PhysicalMemory | Measure-Object Capacity -Sum).Sum / 1GB
)

# ------------------------------------------------------------------
#  Disk usage – build an array of strings then join them with '; '
# ------------------------------------------------------------------
$diskUsage = (Get-PSDrive -PSProvider FileSystem |
                ForEach-Object {
                    $freeGB  = "{0:N2}" -f ($_.Free / 1GB)
                    $totalGB = "{0:N2}" -f (($_.Used + $_.Free) / 1GB)
                    "$($_.Name): Free $freeGB GB / Total $totalGB GB"
                }) -join '; '

# ------------------------------------------------------------------
#  Network adapters – same trick: array ➜ joined string
# ------------------------------------------------------------------
$netAdapters = (Get-NetIPConfiguration |
                   Where-Object { $_.IPv4Address } |
                   ForEach-Object {
                       "$($_.InterfaceAlias) ($($_.IPv4Address.IPAddress))"
                   }) -join '; '

# Assemble the final object – one row, one property per datum
$info = [pscustomobject]@{
    Hostname        = $hostname
    OSVersion       = $osVersion
    Processor       = $processor
    TotalRAMGB      = $totalRamGB
    DiskUsage       = $diskUsage
    NetworkAdapters = $netAdapters
}

# ------------------------------------------------------------------
#  Export to JSON (pretty‑printed, depth=10 for safety)
# ------------------------------------------------------------------
$csvPath = "$env:USERPROFILE\Desktop\SystemInfo.json"
$info | ConvertTo-Json -Depth 10 -Compress:$false | Out-File $csvPath -Encoding UTF8

Write-Host "✅ System info written to:" $csvPath
