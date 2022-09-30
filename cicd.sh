docker build -t shatsberg/multi-client ./client
docker build -t shatsberg/multi-nginx ./nginx
docker build -t shatsberg/multi-server ./server
docker build -t shatsberg/multi-worker ./worker
docker push shatsberg/multi-client
docker push shatsberg/multi-nginx
docker push shatsberg/multi-server
docker push shatsberg/multi-worker