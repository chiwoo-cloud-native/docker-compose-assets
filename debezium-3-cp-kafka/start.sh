#!/bin/bash

# Step 1: Docker Compose 실행
echo "Starting Docker Compose..."
docker-compose up -d

# Step 2: 모든 서비스가 준비될 때까지 대기
echo "Waiting for services to be healthy..."
while ! docker inspect -f '{{.State.Health.Status}}' debezium-connect | grep -q "healthy"; do
  sleep 5
done

# Step 3: 스크립트 실행
echo "All services are healthy. Executing bootstrap.sh..."
curl -X POST 'http://localhost:8083/connectors' -H 'Content-Type: application/json' -d @connect/source-connector-mysql-users.json
curl -X POST 'http://localhost:8083/connectors' -H 'Content-Type: application/json' -d @connect/sink-connector-mysql-customer.json
curl -X POST 'http://localhost:8083/connectors' -H 'Content-Type: application/json' -d @connect/sink-connector-mysql-board.json
curl -X POST 'http://localhost:8083/connectors' -H 'Content-Type: application/json' -d @connect/sink-connector-mysql-codes.json

