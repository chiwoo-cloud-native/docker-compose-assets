# scylla-6-cluster

데이터 지속성을 위해 로컬 디렉터리를 볼륨으로 마운트하고 있습니다. 운영 환경에서는 스토리지 설계에 유의해야 합니다.


`scylla.yaml`과 `schema` 샘플 파일로 컨테이너 구동시 설정과 스키마, 초기 데이터가 적절히 로드됩니다. 

[scylla.yaml](https://opensource.docs.scylladb.com/stable/operating-scylla/admin.html) 파일은 scylla 데이터베이스 설정을 위한 것이고, schema 샘플 파일은 채팅 애플리케이션을 위한 CQL 명령어를 포함하고 있어.


## 단일 시드 노드 지정

`--seeds=scylla1`와 같이 단일 시드 노드 지정 방식은, 클러스터에 참여하는 모든 노드는 오직 scylla1만을 시드로 사용하여 클러스터 정보를 가져옵니다.

- 장점: 설정이 간단합니다.
- 단점: 만약 scylla1 노드에 장애가 발생하거나 네트워크 이슈로 접근할 수 없는 경우, 새로 클러스터에 참여하려는 노드들이 시드 정보를 얻지 못해 클러스터에 합류하는 데 문제가 발생할 수 있습니다.


## 다중 시드 노드 지정

`--seeds=scylla1,scylla2`와 같이 다중 시드 노드 지정 방식은, 클러스터에 참여하는 노드들은 scylla1과 scylla2 두 개의 시드 노드를 사용하여 클러스터 정보를 검색합니다.

- 장점: 하나의 시드 노드에 장애가 발생하더라도 다른 시드 노드를 통해 클러스터 정보를 획득할 수 있으므로, 부트스트랩 과정의 안정성과 내결함성이 향상됩니다.
- 단점: 클러스터 초기 가십 메시지에 참여하는 시드 노드의 수가 늘어나면 약간의 네트워크 오버헤드가 발생할 수 있으나, 대부분의 경우 두세 개 정도의 시드를 사용하는 것은 문제가 되지 않습니다.
   


## Run

작업 경로가 `scylla-6-cluster` 인지 확인 합니다.

```
cd scylla-6-cluster
```

- start.sh
```
# docker compose 를 구동 합니다.
sh start.sh 


docker exec -it scylla1 /bin/bash 

docker exec -it scylla1 cqlsh -f /tmp/mutant-data.txt

cqlsh -f /mutant-data.txt
```

- manually starting
```
# run
docker-compose up -d

# stop
docker-compose stop

# down
docker-compose down --volumes
```

### Kafka Raft

#### Check Kafka Cluster

```
docker exec -it kafka1 kafka-metadata-quorum --bootstrap-server kafka1:29092 describe --status
docker exec -it kafka3 kafka-metadata-quorum --bootstrap-server kafka3:29092 describe --replication --human-readable
```

#### Create Kafka Topic

```
docker exec -it kafka1 kafka-topics --bootstrap-server kafka1:29092 --create --topic my-topic-test101 --replication-factor 3 --partitions 1 
docker exec -it kafka3 kafka-topics --bootstrap-server kafka3:29092 --describe --topic my-topic-test101
```

#### Test Consumer / Producer  
```
# Consume
docker exec -it kafka2 kafka-console-consumer --bootstrap-server kafka2:29092 --topic my-topic-test101 --from-beginning

# Pruducer
docker exec -it kafka3 kafka-console-producer --bootstrap-server kafka3:29092 --topic my-topic-test101 
> Hello, World!

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

# Sink Codes
curl -X POST 'http://localhost:8083/connectors' -H 'Content-Type: application/json' -d @connect/sink-connector-mysql-codes.json


# 커넥터 삭제 참고 
curl -X DELETE http://localhost:8083/connectors/source-connector-mysql-users
curl -X DELETE http://localhost:8083/connectors/sink-connector-mysql-customer
curl -X DELETE http://localhost:8083/connectors/sink-connector-mysql-board
curl -X DELETE http://localhost:8083/connectors/sink-connector-mysql-codes

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
mysql -udemo -pdemo1234 -Ddemo

select * from users;
select * from demo.customer;
select * from demo.board;

insert into users (id, first_name, last_name, email, residence, lat, lon) values (11, 'seonbo', 'shim', 'seonbo.shim@gmail.com', 'Secho, Seoul City', 33.019, 44.624);

delete from users where id = 4;

update  users set email = 'baraltaran@gmail.com' where id = 3;

select * from common_code;
select * from demo.codes;

insert into common_code (group_code,code,code_name,description) values ('STATUS','REMOVE','Removed','Removed status');

delete from common_code where id = 3;

update common_code set code = 'REMOVE-01' where id = 7;
```

### kafka 토픽의 데이터 확인


- Kafa 토픽 메시지 Consume 확인

```
# Kafa 토픽 리스트 조회 
docker exec -it kafka1 kafka-topics --bootstrap-server kafka1:29092 --list

# 신규 메시지만 소비 
docker exec -it kafka1 kafka-console-consumer --bootstrap-server kafka1:29092 --topic debezium.simplydemo.users
  
# 메시지 모두 소비  
docker exec -it kafka1 kafka-console-consumer --bootstrap-server kafka1:29092 --topic debezium.simplydemo.users --from-beginning  

docker exec -it kafka1 kafka-console-consumer --bootstrap-server kafka1:29092 --topic debezium.simplydemo.common_code --from-beginning  
```


## Appendix

### Topic 제거 및 생성

```
docker exec -it kafka1 /bin/bash

kafka-topics --bootstrap-server kafka1:9092 --list
kafka-topics --delete --topic debezium.simplydemo.users --bootstrap-server kafka1:9092
kafka-topics --create --topic debezium.simplydemo.users --bootstrap-server kafka1:9092 --partitions 3 --replication-factor 1
kafka-console-consumer --topic debezium.simplydemo.users --bootstrap-server kafka1:9092 --from-beginning --property print.key=true
```

### 로컬 플러그인 추가 방법
별도 kafka 플러그인을 설치하려면 plugins 폴더를 만들고 아래와 같이 라이브러리를 추가하면 됩니다.

```
mkdir -p ./plugins
wget https://repo1.maven.org/maven2/io/debezium/debezium-connector-mysql/2.4.0/debezium-connector-mysql-2.4.0-plugin.tar.gz
tar -xzf debezium-connector-mysql-2.4.0-plugin.tar.gz -C ./plugins

# docker-compose.yaml 의 debezium-connect 컨테이너에 볼륨을 마운트 합니다. 예: ./connect/plugins:/kafka/connect/debezium-connector-simplydemo:ro  
```

### kafka 커넥터 플러그인 확인
```
docker exec -it debezium-connect /bin/bash

# 사용 가능한 플러그인 확인
ls -al /kafka/connect
```

### References

- [debezium](https://debezium.io/)
- [FullName Custom Transform](https://github.com/simplydemo/simplydemo-kafka-fullname-transform)
- [real-time-analytics-book](https://github.com/mneedham/real-time-analytics-book.git)
- [Change_Data_Capture_Streaming](https://github.com/nits302/Change_Data_Capture_Streaming)
- [cdc-debezium-kafka](https://github.com/zanty2908/cdc-debezium-kafka.git)

