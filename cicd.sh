# export DOCKER_PASSWORD='LolaMeodChamen@500K!'
# export DOCKER_ID='shatsberg'
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_ID" --password-stdin
docker build -t shatsberg/multi-client ./client
docker push shatsberg/multi-client&
docker build -t shatsberg/multi-nginx ./nginx
docker push shatsberg/multi-nginx&
docker build -t shatsberg/multi-server ./server
docker push shatsberg/multi-server&
docker build -t shatsberg/multi-worker ./worker
docker push shatsberg/multi-worker&