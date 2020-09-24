#!/bin/sh
#docker run --restart=unless-stopped -p 80:80 -p 443:443 --name rancher rancher/rancher:v2.3.2
export SHA=$(git rev-parse HEAD)
helm repo add airflow https://marclamberti.github.io/airflow-eks-helm-chart
helm repo update
helm show values airflow/airflow > values.yaml
helm install -f values.yaml --kube-context kind-airflow-cluster airflow airflow/airflow


docker build -t airflow-image:1.0.0 .
docker tag airflow-image:1.0.0 localhost:5000/airflow-image:1.0.0
docker push localhost:5000/airflow-image:1.0.0


docker build -t airflow-image:$SHA .
docker tag airflow-image:$SHA localhost:5000/airflow-image:$SHA
docker push localhost:5000/airflow-image:$SHA

#docker push localhost:5000/airflow-image:latest

kubectl port-forward svc/airflow-webserver 8080:8080 --context kind-airflow-cluster