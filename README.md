# Azure Devops Agents
Windows and Ubuntu images for azure devops agents.

[![Build Status](https://phmonte.visualstudio.com/AzureDevopsAgents/_apis/build/status/phmonte.azuredevops-agents?branchName=main)](https://phmonte.visualstudio.com/AzureDevopsAgents/_build/latest?definitionId=13&branchName=main)

## windows
Installations:
- Python 3.8.0 - works with the python task "Use Python" (https://docs.microsoft.com/en-us/azure/devops/pipelines/tasks/tool/use-python-version?view=azure-devops)

- .NET Core SDK last LTS version (currently 3.1)

- Git 2.31.1

- Chocolatey (https://chocolatey.org/install.ps1)

Example:
docker run -e AZP_URL=YOUR_URL_HERE -e AZP_TOKEN=YOUR_TOKEN_HERE -e AZP_AGENT_NAME=YOUR_AGENT_NAME phmonte/azdevops-agent-win-python-cache:latest

## ubuntu 18.04
Installations:
- Python 3.8.0 - works with the python task "Use Python" (https://docs.microsoft.com/en-us/azure/devops/pipelines/tasks/tool/use-python-version?view=azure-devops)

- .NET Core SDK 5.0

- Powershell 7.1.3-1

Example:
docker run -e AZP_URL=YOUR_URL_HERE -e AZP_TOKEN=YOUR_TOKEN_HERE -e AZP_AGENT_NAME=YOUR_AGENT_NAME phmonte/azdevops-agent-ubuntu1804-python-cache:latest
