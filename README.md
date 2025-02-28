This repositoy is forked from https://github.com/CUHK-SE-Group/train-ticket, before starting setup install the necessary tools in the development guide (helm, skaffold, minikube).

## Setup with Minikube

1. Start the Docker Registry

```bash
docker run -d -p 5000:5000 --name registry registry:2.7
```

2. Build Train Ticket

compiles TrainTicket images 
JAVA 8 JDK is required to build and compile
```bash
mvn clean package -Dmaven.test.skip=true
```

3. Build and Push Docker Images to Registry
```bash
source build.sh
```
Expect this to take a while to build. Currently, build.sh pushes images to a registry on localhost. They can be found by running ```docker images```

4. Initialize Helm
```bash
helm dependency build manifests/helm/generic_service
```

5. Start a Kubernetes Cluster
Train ticket runs ~47 microservices, so memory must be reallocated based on the environment. You can find this configuration file at /manifest/helm/generic_service/values.yaml
Change values for CPU and memory in resources to reflect your environment. 
Once changed, run
```bash
minikube start --insecure-registry="host.minikube.internal:5000" --memory <memory in mb> --cpus <#cpus>
```

7. Make Deployment
```bash
helm install ts manifests/helm/generic_service -n ts --create-namespace --set global.monitoring=opentelemtry --set skywalking.enabled=false --set global.image.tag=latest --set global.image.repository=host.minikube.internal:5000
```

8. Start Reverse Proxy
```bash
#get minikube ip
minikube ip

#start reverse proxy
nohup caddy reverse-proxy --from :8080 --to <minikube_IP>:30080 &
```
starts Caddy as a reverse proxy; Caddy will listen for incoming requests on port 8080 of the local machine
and forward incoming requests to <minikube_IP>:30080; minikube instance is usually listening on port 30080

9. Now you can access Train Ticket through a web browser
```bash
ip route | default
```
This should show you the ip, just go to http://<iproute>:8080