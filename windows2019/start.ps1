if (-not (Test-Path Env:AZP_URL)) {
  Write-Error "error: missing AZP_URL environment variable"
  exit 1
}

if (-not (Test-Path Env:AZP_TOKEN_FILE)) {
  if (-not (Test-Path Env:AZP_TOKEN)) {
    Write-Error "error: missing AZP_TOKEN environment variable"
    exit 1
  }

  $Env:AZP_TOKEN_FILE = "\azp\.token"
  $Env:AZP_TOKEN | Out-File -FilePath $Env:AZP_TOKEN_FILE
}

Remove-Item Env:AZP_TOKEN

if ((Test-Path Env:AZP_WORK) -and -not (Test-Path $Env:AZP_WORK)) {
  New-Item $Env:AZP_WORK -ItemType directory | Out-Null
}

New-Item "\azp\agent" -ItemType directory | Out-Null

# Let the agent ignore the token env variables
$Env:VSO_AGENT_IGNORE = "AZP_TOKEN,AZP_TOKEN_FILE"

Set-Location agent

Write-Host "0. Download and Install Python 3.8.0" -ForegroundColor Cyan

$wc1 = New-Object System.Net.WebClient
$wc1.DownloadFile("https://www.python.org/ftp/python/3.8.0/python-3.8.0-amd64.exe", "$(Get-Location)\python-3.8.0.exe")
$Command = "$(Get-Location)\python-3.8.0.exe /quiet InstallAllUsers=0 PrependPath=1 Include_test=0 TargetDir=C:\azp\agent\_work\_tool\Python\3.8.0\x64"
Invoke-Expression $Command
#New-Item -Path "C:\azp\agent\_work\_tool\Python\3.8.0" -Name "x64.complete" -ItemType "file"

Write-Host "1. Determining matching Azure Pipelines agent..." -ForegroundColor Cyan

$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$(Get-Content ${Env:AZP_TOKEN_FILE})"))
$package = Invoke-RestMethod -Headers @{Authorization=("Basic $base64AuthInfo")} "$(${Env:AZP_URL})/_apis/distributedtask/packages/agent?platform=win-x64&`$top=1"
$packageUrl = $package[0].Value.downloadUrl

Write-Host $packageUrl

Write-Host "2. Downloading and installing Azure Pipelines agent..." -ForegroundColor Cyan

$wc = New-Object System.Net.WebClient
$wc.DownloadFile($packageUrl, "$(Get-Location)\agent.zip")

Expand-Archive -Path "agent.zip" -DestinationPath "\azp\agent"

try
{
  Write-Host "3. Configuring Azure Pipelines agent..." -ForegroundColor Cyan

  .\config.cmd --unattended `
    --agent "$(if (Test-Path Env:AZP_AGENT_NAME) { ${Env:AZP_AGENT_NAME} } else { ${Env:computername} })" `
    --url "$(${Env:AZP_URL})" `
    --auth PAT `
    --token "$(Get-Content ${Env:AZP_TOKEN_FILE})" `
    --pool "$(if (Test-Path Env:AZP_POOL) { ${Env:AZP_POOL} } else { 'Default' })" `
    --work "$(if (Test-Path Env:AZP_WORK) { ${Env:AZP_WORK} } else { '_work' })" `
    --replace

  Write-Host "3.1. Configuring Python Cache..." -ForegroundColor Cyan
  New-Item -Path "C:\azp\agent\_work\_tool\Python\3.8.0" -Name "x64.complete" -ItemType "file"
  
  Write-Host "4. Running Azure Pipelines agent..." -ForegroundColor Cyan
  .\run.cmd
}
finally
{
  Write-Host "Cleanup. Removing Azure Pipelines agent..." -ForegroundColor Cyan
  
  .\config.cmd remove --unattended `
    --auth PAT `
    --token "$(Get-Content ${Env:AZP_TOKEN_FILE})"
}