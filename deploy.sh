#!/bin/sh
export SHA=$(git rev-parse HEAD)
docker build -t airflow-image:$SHA .
docker build -t airflow-image:latest .
docker tag airflow-image:$SHA localhost:5000/airflow-image:$SHA
docker tag airflow-image:latest localhost:5000/airflow-image:latest
docker push localhost:5000/airflow-image:$SHA
docker push localhost:5000/airflow-image:latest