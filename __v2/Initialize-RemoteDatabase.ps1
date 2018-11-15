param(
    [string]$server,
    [string]$user,
    [string]$server_password
)

Write-Verbose 'Updatig server...'

# upgrade the database:
$SqlPackagePath = 'C:\Program Files\Microsoft SQL Server\140\DAC\bin\SqlPackage.exe'
& $SqlPackagePath  `
    /a:Script `
    /sf:StoreDB.dacpac `
    /op:create.sql `
    /p:CommentOutSetVarDeclarations=true `
    /tsn:$server /tu:$user /tdn:StoreDB /tp:$server_password 

$SqlCmdVars = "DatabaseName=StoreDB"
Invoke-Sqlcmd -InputFile create.sql -Variable $SqlCmdVars -Verbose `
    -ServerInstance $server `
    -Username $user `
    -Password $server_password `
    -Database 'StoreDB'

Write-Verbose 'Success!'