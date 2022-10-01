docker build -t shatsberg/multi-client -f ./client/Dockerfile ./client
docker build -t shatsberg/multi-server -f ./server/Dockerfile ./server
docker build -t shatsberg/multi-worker -f ./worker/Dockerfile ./worker
docker push shatsberg/multi-client
docker push shatsberg/multi-server
docker push shatsberg/multi-worker
kubectl apply -f k8s
kubectl rollout restart 