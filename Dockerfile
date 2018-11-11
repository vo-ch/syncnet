# escape=`

# STAGE 1
# builder image
FROM dockersamples/assets-db-builder1 AS builder

WORKDIR C:\src
COPY src\Assets.Database-v1\ .
RUN msbuild Assets.Database.sqlproj `
      /p:SQLDBExtensionsRefPath="C:\Microsoft.Data.Tools.Msbuild.10.0.61026\lib\net40" `
      /p:SqlServerRedistPath="C:\Microsoft.Data.Tools.Msbuild.10.0.61026\lib\net40"


# STAGE 2
# db image
FROM microsoft/mssql-server-windows-express
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

ADD https://download.microsoft.com/download/D/5/C/D5CFC940-DA21-44D3-84FF-A0FD147F1681/EN/x64/DacFramework.msi /DacFramework.msi
RUN Start-Process -FilePath 'msiexec.exe'                         `
        -ArgumentList '/quiet','/qn','/norestart',                `
                      '/log','\DacFramework.log',                 `
                      '/i','\DacFramework.msi'                    `
        -Wait

VOLUME C:\database
ENV sa_password Qwerty123

WORKDIR C:\init
COPY Initialize-Database.ps1 Update-Database.ps1 Apply-Database.ps1 ./

CMD ./Apply-Database.ps1  -Verbose `
      -sa_password $env:sa_password `
      -user $env:remote_db_user `
      -server $env:remote_db_server `
      -server_password $env:remote_db_password

COPY --from=builder C:\src\bin\Debug\Assets.Database.dacpac .
