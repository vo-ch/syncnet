# escape=`
FROM microsoft/dotnet-framework:4.7.2-sdk-windowsservercore-1803

#use powershell
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop';"]

# download nuget and install msbuild data tools
ADD "https://dist.nuget.org/win-x86-commandline/v4.7.1/nuget.exe" "C:\TEMP\nuget.exe"
RUN "C:\TEMP\nuget.exe" install Microsoft.Data.Tools.Msbuild -Version 10.0.61026

# set correct path vars
ENV MSBUILD_PATH="C:\Program Files (x86)\Microsoft Visual Studio\2017\BuildTools\MSBuild\15.0\Bin"
RUN $env:PATH = $env:MSBUILD_PATH + ';' + $env:PATH; `
    [Environment]::SetEnvironmentVariable('PATH', $env:PATH, [EnvironmentVariableTarget]::Machine)
