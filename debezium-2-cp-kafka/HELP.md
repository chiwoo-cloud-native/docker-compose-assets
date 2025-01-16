# debezium-2-cp-kafka

Kafka Zookeeper 기반의 Debezium CDC 를 처리하는 샘플 입니다. 

## Run
```
cd debezium-2-cp-kafka

# run
docker-compose up -d

# stop
docker-compose stop
```

### mysql

```
# Terminal
docker exec -it mysql /bin/bash

# IN-Terminal
mysql> mysql -p"mysql1234" -D simplydemo
mysql> mysql -u simplydemo -p"simplydemo1234" -D simplydemo
mysql> show tables;
mysql> select * from customer;
```

## Debezium

### Debezium 커넥터 서비스 확인
```
curl -s http://localhost:8083
```

### Debezium UI 대시보드

[Debezium UI](http://localhost:8090) 대시보드를 통해 커넥트를 확인 가능합니다. 


### Debezium mysql-source 커넥터 추가

`debezium-source-connector-mysql-users` 소스 커넥터를 추가 합니다. 

```
# source 커넥터 추가
curl -X POST 'http://localhost:8083/connectors' \
-H 'Content-Type: application/json' \
-d @connect/debezium-source-connector-mysql-users.json

# source 커넥터 삭제 
curl -X DELETE http://localhost:8083/connectors/debezium-source-connector-mysql-users
```

### mysql의 users 테이블에 샘플 데이터 적재 

```
docker exec -it mysql /bin/bash

mysql -usimplydemo -psimplydemo1234 -Dsimplydemo

INSERT INTO users (first_name, last_name, email, residence, lat, lon)
VALUES ('seonbo3', 'shim', 'seonbo.shim@gmail.com', 'Secho, Seoul City', 33.019, 44.624);
```

### kafka 토픽의 데이터 확인

- Kafa 토픽 리스트 조회 

```
docker exec -it broker \
  kafka-topics --bootstrap-server broker:29092 --list
```

- Kafa 토픽 메시지 Consume 확인  

```
# 신규 메시지만 소비 
docker exec -it broker \
  kafka-console-consumer --bootstrap-server broker:29092 \
  --topic debezium.simplydemo.users --from-beginning
  
# 전체 메시지 모두를 소비  
docker exec -it broker \
  kafka-console-consumer --bootstrap-server broker:29092 \
  --topic debezium.simplydemo.users \
  --from-beginning  
```


## Appendix

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

- [debezium-ui](http://localhost:8090/) UI 화면 확인 




## Down

```
docker-compose down
```


## Example

```
version: '3'
services:
  mysql-80:
    image: mysql/mysql-server:8.0
    volumes:
      - ./docker-entrypoint-initdb.d/:/docker-entrypoint-initdb.d/
    ports:
      - "3308:3306"
    command: ["mysqld", "--default-authentication-plugin=mysql_native_password"]
    environment:
      - MYSQL_ROOT_PASSWORD="Mysql123$"
  my-app:
    image: your/myapp
    env_file:
      - myapp.env
    environment:
      - DBHOST=mysql-80
    ports:
      - "8080:8080"
    depends_on:
      - mysql-80
```

- [myapp.env]
```
DBNAME=simplydemo
DBUSER=simplydemo
DBPASS=Simplydemo123$
```