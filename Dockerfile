# escape=`

# STAGE 1
# builder image
FROM vochregistry.azurecr.io/voch/storedb-builder:1 AS builder

# Copy sorce code into container and build it with msbuild
WORKDIR C:\src
COPY StoreDB\ .
RUN msbuild StoreDB\StoreDB.sqlproj `
      /p:SQLDBExtensionsRefPath="C:\Microsoft.Data.Tools.Msbuild.10.0.61026\lib\net40" `
      /p:SqlServerRedistPath="C:\Microsoft.Data.Tools.Msbuild.10.0.61026\lib\net40"


# STAGE 2
# db image
FROM microsoft/mssql-server-windows-express
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# download and install DacFramework (for dacpack unpacking)
ADD https://download.microsoft.com/download/D/5/C/D5CFC940-DA21-44D3-84FF-A0FD147F1681/EN/x64/DacFramework.msi /DacFramework.msi
RUN Start-Process -FilePath 'msiexec.exe'                         `
        -ArgumentList '/quiet','/qn','/norestart',                `
                      '/log','\DacFramework.log',                 `
                      '/i','\DacFramework.msi'                    `
        -Wait

# mount point
VOLUME C:\database

# default password, just for demo purposes
ENV sa_password Qwerty123

WORKDIR C:\init
# copy main ps script to image
COPY Initialize-LocalDatabase.ps1 ./

# run script
CMD ./Initialize-LocalDatabase.ps1  -Verbose `
      -sa_password $env:sa_password

# copy dacpac file from builder container (from Stage 1)
COPY --from=builder C:\src\StoreDB\bin\Debug\StoreDB.dacpac .
