FROM mcr.microsoft.com/windows/servercore:ltsc2019

WORKDIR /azp

COPY start.ps1 .


##python
RUN powershell.exe -Command \
    $ErrorActionPreference = 'Stop'; \
    wget https://www.python.org/ftp/python/3.8.0/python-3.8.0-amd64.exe -OutFile c:\python-3.8.0.exe

RUN powershell.exe -Command c:\python-3.8.0.exe /quiet InstallAllUsers=0 PrependPath=1 Include_test=0 TargetDir=C:\azp\agent\_work\_tool\Python\3.8.0\x64
RUN powershell.exe New-Item -Path C:\azp\agent\_work\_tool\Python\3.8.0 -Name x64.complete -ItemType file

##chocolatey
RUN powershell -Command Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

##dotnet
#RUN powershell.exe -Command Invoke-WebRequest 'https://dot.net/v1/dotnet-install.ps1' -OutFile 'dotnet-install.ps1';
#RUN powershell.exe -Command Invoke-Expression './dotnet-install.ps1 -Channel LTS'
#RUN powershell.exe -Command Invoke-Expression './dotnet-install.ps1 -Channel LTS -Runtime aspnetcore'

##git
RUN powershell.exe -Command \
    $ErrorActionPreference = 'Stop'; \
    wget https://github.com/git-for-windows/git/releases/download/v2.31.1.windows.1/Git-2.31.1-64-bit.exe -OutFile c:\Git-2.31.1-64-bit.exe ; \
    Start-Process c:\Git-2.31.1-64-bit.exe -ArgumentList '/VERYSILENT /NORESTART /NOCANCEL /SP- /CLOSEAPPLICATIONS /RESTARTAPPLICATIONS /COMPONENTS="icons,ext\reg\shellhere,assoc,assoc_sh' -Wait ; \
    Remove-Item c:\Git-2.31.1-64-bit.exe -Force


CMD powershell .\start.ps1