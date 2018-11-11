param(
    [Parameter(Mandatory=$false)]
    [string]$sa_password,

    [Parameter(Mandatory=$false)]
    [string]$server,
    
    [Parameter(Mandatory=$false)]
    [string]$user,

    [Parameter(Mandatory=$false)]
    [string]$server_password
    )

if ($server) {
    & ./Initialize-RemoteDatabase.ps1 -server $server -user $user -server_password $server_password
} else {
    & ./Initialize-LocalDatabase.ps1 -sa_password $sa_password
}
