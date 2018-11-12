param([string]$sa_password)

# start the service
Write-Verbose 'Starting SQL Server'
start-service MSSQL`$SQLEXPRESS

if ($sa_password -ne "_") {
	Write-Verbose 'Changing SA login credentials'
    $sqlcmd = "ALTER LOGIN sa with password='$sa_password'; ALTER LOGIN sa ENABLE;"
    Invoke-Sqlcmd -Query $sqlcmd -ServerInstance ".\SQLEXPRESS" 
}

# attach data files if they exist: 
$mdfPath = 'c:\database\StoreDB_Primary.mdf'
if ((Test-Path $mdfPath) -eq $true) {
    $sqlcmd = "CREATE DATABASE StoreDB ON (FILENAME = N'$mdfPath')"
    $ldfPath = 'c:\database\StoreDB_Primary.ldf'
    if ((Test-Path $mdfPath) -eq $true) {
        $sqlcmd =  "$sqlcmd, (FILENAME = N'$ldfPath')"
    }
    $sqlcmd = "$sqlcmd FOR ATTACH;"
    Write-Verbose "Invoke-Sqlcmd -Query $($sqlcmd) -ServerInstance '.\SQLEXPRESS'"
    Invoke-Sqlcmd -Query $sqlcmd -ServerInstance ".\SQLEXPRESS"
}

# deploy or upgrade the database:
$SqlPackagePath = 'C:\Program Files\Microsoft SQL Server\140\DAC\bin\SqlPackage.exe'
& $SqlPackagePath  `
    /sf:StoreDB.dacpac `
    /a:Script /op:create.sql /p:CommentOutSetVarDeclarations=true `
    /tsn:.\SQLEXPRESS /tdn:StoreDB /tu:sa /tp:$sa_password 

$SqlCmdVars = "DatabaseName=StoreDB", "DefaultFilePrefix=StoreDB", "DefaultDataPath=c:\database\", "DefaultLogPath=c:\database\"  
Invoke-Sqlcmd -InputFile create.sql -Variable $SqlCmdVars -Verbose

# relay SQL event logs to Docker
$lastCheck = (Get-Date).AddSeconds(-2) 
while ($true) { 
    Get-EventLog -LogName Application -Source "MSSQL*" -After $lastCheck | Select-Object TimeGenerated, EntryType, Message	 
    $lastCheck = Get-Date 
    Start-Sleep -Seconds 2 
}
