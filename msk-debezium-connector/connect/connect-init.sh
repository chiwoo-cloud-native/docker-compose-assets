#!/usr/bin/env bash

curl -X POST 'http://localhost:8083/connectors' -H 'Content-Type: application/json' -d @source-connector-demosrc.json
curl -X POST 'http://localhost:8083/connectors' -H 'Content-Type: application/json' -d @sink-connector-mysql-customer.json
curl -X POST 'http://localhost:8083/connectors' -H 'Content-Type: application/json' -d @sink-connector-mysql-board.json
