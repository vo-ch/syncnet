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
    /sf:Assets.Database.dacpac `
    /op:create.sql `
    /p:CommentOutSetVarDeclarations=true `
    /tsn:$server /tu:$user /tdn:AssetsDB /tp:$server_password 

$SqlCmdVars = "DatabaseName=AssetsDB"
Invoke-Sqlcmd -InputFile create.sql -Variable $SqlCmdVars -Verbose `
    -ServerInstance 'assetsdb.database.windows.net' `
    -Username $user `
    -Password $server_password `
    -Database 'AssetsDB'
