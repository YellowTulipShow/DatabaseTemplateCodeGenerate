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

$DownloadDir = "_release"

[string[]]$DownloadUrls = @(
    "https://github.com/YellowTulipShow/DatabaseStructurePullTool/releases/download/v0.0.3/PullDataBaseData-0.0.3-win-x64.zip",
    "https://github.com/YellowTulipShow/NetTemplate/releases/download/v0.0.2/TranslationTemplateCommand.0.0.2-win-x64.zip"
)

PrintLineSplit

# 创建下载目录
if (-not (Test-Path $DownloadDir)) {
    New-Item -ItemType Directory -Path $DownloadDir -Force | Out-Null
    Write-Host "创建目录: $DownloadDir"
}

foreach ($DownloadUrl in $DownloadUrls) {

    $AssetName = $DownloadUrl -replace '^http[^\n]+/', ''
    $ExtractFolderName = $AssetName -replace '\.zip$', ''
    $ExtractPath = Join-Path -Path $DownloadDir -ChildPath $ExtractFolderName

    # 下载文件
    $ZipPath = Join-Path -Path $DownloadDir -ChildPath $AssetName
    if (Test-Path $ZipPath) {
        Write-Host "已存在文件, 无需重复下载: $ZipPath"
    } else {
        Write-Host "正在下载: $DownloadUrl"
        Write-Host "保存到: $ZipPath"

        try {
            Invoke-WebRequest -Uri $DownloadUrl -OutFile $ZipPath -ErrorAction Stop
            Write-Host "下载完成!"
        } catch {
            Write-Error "下载失败: $_"
            exit 1
        }
    }

    # 解压缩
    Write-Host "正在解压到: $ExtractPath"

    # 如果目标文件夹已存在，先删除（避免旧文件残留）
    if (Test-Path $ExtractPath) {
        Remove-Item -Path $ExtractPath -Recurse -Force
        Write-Host "已删除旧目录: $ExtractPath"
    }

    try {
        Expand-Archive -Path $ZipPath -DestinationPath $ExtractPath -ErrorAction Stop
        Write-Host "解压完成!"
    } catch {
        Write-Error "解压失败: $_"
        exit 1
    }
}

PrintLineSplit

Set-Location $ExecutePath
if ($PSScriptRoot -eq $ExecutePath) {
    timeout.exe /T -1
}
