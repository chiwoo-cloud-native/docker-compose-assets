# msk-debezium-connector


```

docker compose down connect
docker-compose -f docker-compose-local.yaml up -d


docker exec -it mysql /bin/bash

mysql -h localhost -u kafkasrc -p'kafkasrc1234%' -D demosrc 
mysql -h kafka -u kafkasrc -p'kafkasrc1234%' -D demosrc 

mysql -h mysqlsvc -u kafkasrc -pkafkasrc1234% -D demosrc

mysql -h localhost -u mysql -p'root1234' -Dmysql 

kafka-topics.sh --create --bootstrap-server BOOTSTRAP_SERVER_STRING --replication-factor 1 --partitions 1 --topic TOPIC_NAME




select * from demosink.productinfo;



```

## Run
```
# run
docker-compose up -d


# MySQL
docker exec -it mysqlsvc /bin/bash
mysql -u kfc -pkfc1234 -D demosrc
 

# stop
docker-compose down
```


### connector 재 시작
```
docker compose down connect
docker compose up connect -d
```


### Source 커넥터 추가
```
# 추가 
curl -X POST 'http://localhost:8083/connectors' -H 'Content-Type: application/json' -d @connect/source-connector-demosrc.json

# 로그레밸 조정 
curl -X PUT http://localhost:8083/connectors/loggers/org.apache.kafka.connect -H "Content-Type:application/json" -d '{"level": "DEBUG"}'

# 상태 확인 
curl http://localhost:8083/connectors/source-connector-demosrc/status

# 제거
curl -X DELETE http://localhost:8083/connectors/source-connector-demosrc

```

### Sink 커넥터 추가
```
# 추가 
curl -X POST 'http://localhost:8083/connectors' -H 'Content-Type: application/json' -d @connect/sink-connector-productinfo.json

# 상태 확인 
curl http://localhost:8083/connectors/sink-connector-productinfo/status

# 제거
curl -X DELETE http://localhost:8083/connectors/sink-connector-productinfo

# 로그레밸 조정 
curl -X PUT http://localhost:8083/connectors/loggers/org.apache.kafka.connect -H "Content-Type:application/json" -d '{"level": "DEBUG"}'


```

## kafka CLI


### Topic 관리



```
export CLASSPATH=$(find /Users/seonbo.shim/opt/kafka_2.13-3.6.2/libsext -name "*.jar" | tr "\n" ":")$CLASSPATH
export BOOTSTRAP_SERVERS="b-1.symplydemomsk.175802.c3.kafka.ap-northeast-2.amazonaws.com:9098,b-2.symplydemomsk.175802.c3.kafka.ap-northeast-2.amazonaws.com:9098"
export PATH="$PATH:/Users/seonbo.shim/opt/kafka_2.13-3.6.2/bin"

# Topic 생성
kafka-topics.sh --create --topic MyTestTopic111 --bootstrap-server $BOOTSTRAP_SERVERS --replication-factor 2 --partitions 1 --command-config client.properties

# Topic 삭제
kafka-topics.sh --delete --topic connect-configs  --bootstrap-server $BOOTSTRAP_SERVERS --command-config client.properties  
kafka-topics.sh --delete --topic connect-offsets  --bootstrap-server $BOOTSTRAP_SERVERS --command-config client.properties  
kafka-topics.sh --delete --topic connect-status  --bootstrap-server $BOOTSTRAP_SERVERS --command-config client.properties  
kafka-topics.sh --delete --topic history.schema-changes  --bootstrap-server $BOOTSTRAP_SERVERS --command-config client.properties  
kafka-topics.sh --delete --topic simply  --bootstrap-server $BOOTSTRAP_SERVERS --command-config client.properties  








# Topic 목록 조회 
kafka-topics.sh --list --bootstrap-server $BOOTSTRAP_SERVERS --command-config client.properties
kafka-topics.sh --list --bootstrap-server $BOOTSTRAP_SERVERS --command-config client.properties









kafka-topics.sh --delete --topic simply --bootstrap-server $BOOTSTRAP_SERVERS --command-config client.properties
kafka-topics.sh --delete --topic history.schema-changes --bootstrap-server $BOOTSTRAP_SERVERS --command-config client.properties
kafka-topics.sh --delete --topic connect-status --bootstrap-server $BOOTSTRAP_SERVERS --command-config client.properties
kafka-topics.sh --delete --topic connect-offsets --bootstrap-server $BOOTSTRAP_SERVERS --command-config client.properties
kafka-topics.sh --delete --topic connect-configs --bootstrap-server $BOOTSTRAP_SERVERS --command-config client.properties
```


### Topic 데이터 확인

```
kafka-console-consumer --topic __consumer_offsets --from-beginning --property print.key=true --bootstrap-server $BOOTSTRAP_SERVERS --command-config client.properties
```


### ACL 정책 조정 

```
kafka-acls.sh --list --bootstrap-server $BOOTSTRAP_SERVERS --command-config client.properties


kafka-acls.sh --authorizer-propertieszookeeper.connect=b-1.symplydemomsk.175802.c3.kafka.ap-northeast-2.amazonaws.com:2182 \
  --add --allow-principal User:ANONYMOUS --operation ALL --cluster \
  --command-config client.properties

--authorizer-propertieszookeeper.connect=example-ZookeeperConnectString --add --allow-principal User:ANONYMOUS --operation ALL --cluster


kafka-topics.sh --describe --topic history.database-changes --bootstrap-server $BOOTSTRAP_SERVERS --command-config client.properties

docker compose logs -f | grep -i -E 'failed|denied|creation'

```

### 특정 Consumer 그룹 초기화
```

kafka-consumer-groups.sh --bootstrap-server $BOOTSTRAP_SERVERS --command-config client.properties \
  --describe --group myConnector

kafka-consumer-groups.sh --bootstrap-server $BOOTSTRAP_SERVERS --command-config client.properties \
  --group myConnector --reset-offsets --to-earliest --execute --all-topics
  
kafka-topics.sh --bootstrap-server $BOOTSTRAP_SERVERS --describe --topic __consumer_offsets

kafka-topics.sh --bootstrap-server $BOOTSTRAP_SERVERS --describe --topic __consumer_offsets
```

- [Amazon MSK Cluster Connection Issue](https://repost.aws/knowledge-center/msk-cluster-connection-issues)