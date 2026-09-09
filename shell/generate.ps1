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
$batchCacheFilePath = "./_output/batch_cache.txt"
$FolderName_InferentialData = ""

function GenerateFile([string]$template_path, [string]$output_path, [string]$db_json_path, [string]$table_json_path)
{
    if ($table_json_path.contains("json.handle.cover")) {
        return;
    }
    $line = @(
        $template_path,
        $output_path,
        "db:$db_json_path  table:$table_json_path"
    ) -join " | "
    $line | Out-File -Encoding Default -Append -FilePath $batchCacheFilePath
}

function GenerateFile_DataBaseAndTable([string]$db, [string]$db_json_path, [string]$table_json_path)
{
    $table_name = $table_json_path -replace '^.+[/\\]'
    $table_name = $table_name -replace '\.json$'

    $template_root_path = "./_template"
    $output_root_path = "./_output"
    $list_template = Get-ChildItem -Path $template_root_path -Recurse -Include "*.liquid" -Name
    for ($i_template = 0; $i_template -lt $list_template.Count; $i_template++) {
        if ($list_template.Count -eq 1) {
            $template = $list_template;
        } else {
            $template = $list_template[$i_template]
        }
        if (!$template) {
            continue;
        }
        $template = $template -replace "\\","/"
        $output = $template -replace "_Basic_",$table_name
        $output = $output -replace ".liquid",""

        $template = "$template_root_path/$template"
        $output = "$output_root_path/$db/$table_name/$output"

        GenerateFile $template $output $db_json_path $table_json_path
    }
    $dir_db_output = "./_output/$db";
    if (!(Test-Path $dir_db_output)) {
        Write-Host "[Error] DB Output Dire Not Existent: $dir_db_output, Create ......"
        New-Item -ItemType Directory -Force -Path $dir_db_output
    }
    Invoke-Item $dir_db_output
}

function ReadDataBaseConfig([string]$db)
{
    PrintLineSplit
    # 根据数据库名称找到
    Write-Host "DBName: $db"

    $db_desc_file_path = "./_data/$db/db.json"
    if (!(Test-Path $db_desc_file_path)) {
        Write-Host "[Error] DB Info Not Existent: $db_desc_file_path, Create ......"
        New-Item -ItemType File -Force -Path $db_desc_file_path
    }
    $db_tables_dire = "./_data/$db/$FolderName_InferentialData"
    if (!(Test-Path $db_tables_dire)) {
        Write-Host "[Error] DB Table Under Dire Not Existent: $db_tables_dire, Create ......"
        New-Item -ItemType Directory -Force -Path $db_tables_dire
        continue
    }
    $list_tables = Get-ChildItem -Path $db_tables_dire -Recurse -Include *.json -Name
    for ($i_table = 0; $i_table -lt $list_tables.Count; $i_table++) {
        if ($list_tables.Count -eq 1) {
            $tablejson = $list_tables;
        } else {
            $tablejson = $list_tables[$i_table]
        }
        if (!$tablejson) {
            continue;
        }
        $tablejson = $tablejson -replace "\\","/"
        GenerateFile_DataBaseAndTable $db $db_desc_file_path $db_tables_dire/$tablejson
    }
}

function ReadDataBaseConfigs([string]$cpath)
{
    $config = Get-Content -Path $cpath -Raw | ConvertFrom-Json
    $FolderName_InferentialData = $config.FolderName_InferentialData

    for ($i_db = 0; $i_db -lt $config.DBInfos.Count; $i_db++) {
        $db = $config.DBInfos[$i_db].Name
        if (!$db) {
            continue;
        }
        Write-Host "[Info][$i_db] DB: $db"
    }

    while (1 -eq 1) {
        $input_index_strlist = Read-Host "Please enter Number list english symbol , join"
        if (!$input_index_strlist) {
            continue
        }
        $input_index_list = $input_index_strlist -split ","
        Write-Host "[Info] user input content: $input_index_strlist"
        for ($i_index = 0; $i_index -lt $input_index_list.Count; $i_index++) {
            $index_item = $input_index_list[$i_index]
            $db = $config.DBInfos[$index_item].Name
            if (!$db) {
                continue;
            }
            ReadDataBaseConfig $db
        }
        break
    }
}

# 检查批量缓存文件是否存在
if (Test-Path -Path $batchCacheFilePath) {
    Write-Host "Remove-Item -Force -Path $batchCacheFilePath"
    Remove-Item -Force -Path $batchCacheFilePath
}
Write-Host "New-Item -ItemType File -Force -Path $batchCacheFilePath"
New-Item -ItemType File -Force -Path $batchCacheFilePath

PrintLineSplit

# 读取数据库配置写入配置缓存
ReadDataBaseConfigs $cpath

PrintLineSplit

# 执行批量生成
Write-Host ".\_release\TranslationTemplateCommand.0.0.2-win-x64\TranslationTemplateCommand.exe batch -r $PWD --config $batchCacheFilePath"
.\_release\TranslationTemplateCommand.0.0.2-win-x64\TranslationTemplateCommand.exe batch -r $PWD --config $batchCacheFilePath

PrintLineSplit

# 删除配置文件
if (Test-Path -Path $batchCacheFilePath) {
    Write-Host "Remove-Item -Force -Path $batchCacheFilePath"
    Remove-Item -Force -Path $batchCacheFilePath
}

PrintLineSplit

Set-Location $ExecutePath
if ($PSScriptRoot -eq $ExecutePath) {
    timeout.exe /T -1
}
