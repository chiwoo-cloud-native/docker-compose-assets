# scylla-6-single

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

작업 경로가 `scylla-6-single` 인지 확인 합니다.

```
cd scylla-6-single
```

- start.sh
```
# docker compose 를 구동 합니다.
sh start.sh 

docker exec -it scylla /bin/bash 
docker exec -it scylla cqlsh -f /tmp/mutant-data.txt
```

## cqlsh

### 전체 키스페이스 목록 보기
```
DESCRIBE KEYSPACES;
```

### 특정 키스페이스의 상세 정보 보기
```
DESCRIBE KEYSPACE chat_app;
```

### 전체 테이블 목록 조회 (현재 사용 중인 키스페이스 기준)
```
DESCRIBE TABLES;
```

### 전체 스키마(DML 포함) 출력
```
DESCRIBE SCHEMA;
```

### 데이터 조회 (SELECT)
```
SELECT * FROM chat_app.clients;
```

### 특정 컬럼만 조회 (SELECT)
```
SELECT client_id, client_name FROM chat_app.clients;
```
 

### 조건을 사용한 조회 (WHERE 절)
```
SELECT * FROM chat_app.clients WHERE client_id = 22222222-2222-2222-2222-222222222222;
```
 

### LIMIT 사용 (SELECT)
```
SELECT * FROM chat_app.clients
LIMIT 10;
```
 

### TTL(Time To Live) 설정하여 저장 (INSERT)
```
INSERT INTO chat_app.clients ( client_id, client_name, registered_at)
VALUES (33333333-3333-3333-3333-333333333333, 'Symplesims', toTimestamp(now()))
USING TTL 86400;
```
 