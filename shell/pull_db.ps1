# 设置控制台输出编码为 UTF-8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

$ExecutePath = $PWD
Set-Location $PSScriptRoot
Set-Location ..

function PrintLineSplit([string]$path)
{
    Write-Host ""
    Write-Host "======================================================================================="
    Write-Host ""
}

$cpath = "./_configs/PullDataBaseData-runConfig.json"

function GenerateFile()
{
    Write-Host ".\_release\PullDataBaseData-0.0.3-win-x64\PullDataBaseData.exe $cpath"
    .\_release\PullDataBaseData-0.0.3-win-x64\PullDataBaseData.exe "$cpath"
}

PrintLineSplit

GenerateFile

PrintLineSplit
Set-Location $ExecutePath
if ($PSScriptRoot -eq $ExecutePath) {
    timeout.exe /T -1
}
