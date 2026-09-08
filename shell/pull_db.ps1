$ExecutePath = $PWD
Set-Location $PSScriptRoot
Set-Location ..

$OutputEncoding = New-Object -typename System.Text.UTF8Encoding

function PrintLineSplit([string]$path)
{
    Write-Host ""
    Write-Host "======================================================================================="
    Write-Host ""
}

function GenerateFile()
{
    Write-Host "./_release/PullDataBaseData.0.0.2/PullDataBaseData.exe"
    .\_release\PullDataBaseData-0.0.2\PullDataBaseData.exe
}

PrintLineSplit

GenerateFile

PrintLineSplit
Set-Location $ExecutePath
if ($PSScriptRoot -eq $ExecutePath) {
    timeout.exe /T -1
}
