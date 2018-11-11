# syncnet

# builder
docker image build --tag vochregistry.azurecr.io/voch/storedb-builder:v1 --file Dockerfile.builder .
docker push vochregistry.azurecr.io/voch/storedb-builder:v1

# db image
docker image build --tag vochregistry.azurecr.io/voch/storedb:v1 --file Dockerfile .

docker container run --detach --name storedb -p 1433:1433 vochregistry.azurecr.io/voch/storedb:v1

docker run -d --name storedb -p 1433:1433 -e remote_db_server=storedb.database.windows.net -e remote_db_user=voch -e remote_db_password=Qwerty123 vochregistry.azurecr.io/voch/storedb

docker stop $(docker ps -aq)
docker rm $(docker ps -aq)