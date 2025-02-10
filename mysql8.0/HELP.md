# mysql 서버 설치

## Run
```
chmod 755 docker-entrypoint-initdb.d/init.sql


# run
docker-compose up -d

# Terminal
docker exec -it mysql8 /bin/bash

# IN-Terminal
mysql -u simplydemo -p"simplydemo1234" -D simplydemo

mysql> show tables;
mysql> select * from customer;

mysql -u kafkasrc -p"DeMoKafkaSrc1234%%" -D demosrc
mysql> show tables;
mysql> select * from demosrc.products;

mysql -u kafkasink -p"DeMoKafkaSinker1234%%" -D demosink
mysql> show tables;
mysql> select * from demosink.productinfo;

# stop
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