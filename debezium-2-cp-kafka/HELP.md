# debezium-2-cp-kafka

Kafka Zookeeper 환경에서 Debezium CDC를 통해 From 테이블에서 To 테이블로 테이터스트림을 통해 프로비저닝하는 샘플 프로젝트 입니다.

## Run
```
cd debezium-2-cp-kafka

# run
docker-compose up -d

# stop
docker-compose stop

# down
docker-compose down --volumes
```

### mysql

```
# Terminal
docker exec -it mysql /bin/bash

# in-terminal
mysql> mysql -p"mysql1234" -D simplydemo
mysql> show databases;
mysql> select * from simplydemo.users;
```

## Debezium

### Debezium 커넥터 서비스 확인
```
curl -s http://localhost:8083
```

### Debezium UI 대시보드

[Debezium UI](http://localhost:8090) 대시보드를 통해 커넥트를 확인 가능합니다. 


### Debezium Source/Sink 커넥터 추가

Debezium Source 및 Sink 커넥터를 순서대로 추가합니다.  

```
# Source Users
curl -X POST 'http://localhost:8083/connectors' -H 'Content-Type: application/json' -d @connect/source-connector-mysql-users.json

# Sink Customer
curl -X POST 'http://localhost:8083/connectors' -H 'Content-Type: application/json' -d @connect/sink-connector-mysql-customer.json

# Sink Board
curl -X POST 'http://localhost:8083/connectors' -H 'Content-Type: application/json' -d @connect/sink-connector-mysql-board.json


# 커넥터 삭제 참고 
curl -X DELETE http://localhost:8083/connectors/source-connector-mysql-users
curl -X DELETE http://localhost:8083/connectors/sink-connector-mysql-customer
curl -X DELETE http://localhost:8083/connectors/sink-connector-mysql-board
```

- 로그를 통해 커넥터 동작을 상세하게 확인할 수 있습니다.

```
docker exec -it debezium-connect tail -f logs/connect-service.log
```

- [io.debezium.connector.mysql.MySqlConnector](https://debezium.io/documentation/reference/stable/connectors/mysql.html)
- [io.debezium.connector.jdbc.JdbcSinkConnector](https://debezium.io/documentation/reference/stable/connectors/jdbc.html)

## 커텍터를 통한 메시징 테스트

users 테이블 Source 에서 marketing 테이블 Target 으로 적재하는 기능을 확인합니다. 

### mysql의 users 테이블에 샘플 데이터 적재 

```
docker exec -it mysql /bin/bash

mysql -usimplydemo -psimplydemo1234 -Dsimplydemo

INSERT INTO users (first_name, last_name, email, residence, lat, lon) VALUES ('seonbo', 'shim', 'seonbo.shim@gmail.com', 'Secho, Seoul City', 33.019, 44.624);


select * from users;
select * from demo.customer;
select * from demo.board;
```

### kafka 토픽의 데이터 확인


- Kafa 토픽 메시지 Consume 확인  

```
# Kafa 토픽 리스트 조회 
docker exec -it broker kafka-topics --bootstrap-server broker:9092 --list

# 신규 메시지만 소비 
docker exec -it broker kafka-console-consumer --bootstrap-server broker:9092 --topic debezium.simplydemo.users
  
# 메시지 모두 소비  
docker exec -it broker kafka-console-consumer --bootstrap-server broker:9092 --topic debezium.simplydemo.users --from-beginning  
```


## Appendix

### Topic 제거 및 생성

```
docker exec -it broker /bin/bash

kafka-topics --bootstrap-server broker:9092 --list
kafka-topics --delete --topic debezium.simplydemo.users --bootstrap-server broker:9092
kafka-topics --create --topic debezium.simplydemo.users --bootstrap-server broker:9092 --partitions 3 --replication-factor 1
kafka-console-consumer --topic debezium.simplydemo.users --bootstrap-server broker:9092 --from-beginning --property print.key=true
```

### 로컬 플러그인 추가 방법
별도 kafka 플러그인을 설치하려면 plugins 폴더를 만들고 아래와 같이 라이브러리를 추가하면 됩니다.

```
mkdir -p ./plugins
wget https://repo1.maven.org/maven2/io/debezium/debezium-connector-mysql/2.4.0/debezium-connector-mysql-2.4.0-plugin.tar.gz
tar -xzf debezium-connector-mysql-2.4.0-plugin.tar.gz -C ./plugins

# docker-compose.yaml 의 debezium-connect 컨테이너에 볼륨을 마운트 합니다. 예: ./plugins:/kafka/connect  
```

### kafka 커넥터 플러그인 확인
```
docker exec -it debezium-connect /bin/bash

# 사용 가능한 플러그인 확인
ls -al /kafka/connect
```

### real-time-analytics-book

- [real-time-analytics-book](https://github.com/mneedham/real-time-analytics-book.git)
- [Change_Data_Capture_Streaming](https://github.com/nits302/Change_Data_Capture_Streaming)
- [cdc-debezium-kafka](https://github.com/zanty2908/cdc-debezium-kafka.git)

