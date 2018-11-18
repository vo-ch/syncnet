# syncnet

Inspired by https://github.com/docker/labs/tree/master/windows/sql-server

# commands to run in powershell

# db first install
docker run -d --rm -p 1433:1433 -e sa_password=Qwerty123 -e ACCEPT_EULA=Y microsoft/mssql-server-windows-express

# builder
docker image build --tag vochregistry.azurecr.io/voch/storedb-builder:1 --file Dockerfile.builder .

# db image
docker image build --tag vochregistry.azurecr.io/voch/storedb:1 .

docker container run --rm --detach --name storedb -p 1433:1433 vochregistry.azurecr.io/voch/storedb:1
docker container run --rm --detach --name storedb -p 1433:1433 --volume dbdata:C:\database vochregistry.azurecr.io/voch/storedb:1

docker image build --tag vochregistry.azurecr.io/voch/storedb:2 .
docker container run --rm --detach --name storedb -p 1433:1433 --volume dbdata:C:\database vochregistry.azurecr.io/voch/storedb:2

# remote db

docker image build --tag vochregistry.azurecr.io/voch/storedb:3 --file Dockerfile.v2 .
docker run --rm --name storedb -p 1433:1433 -e remote_db_server=<serveraddres> -e remote_db_user=<login> -e remote_db_password=<password> vochregistry.azurecr.io/voch/storedb:3