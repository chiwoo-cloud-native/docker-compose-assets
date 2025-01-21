CREATE DATABASE IF NOT EXISTS simplydemo;
use simplydemo;

CREATE USER 'simplydemo'@'%' IDENTIFIED WITH mysql_native_password BY 'simplydemo1234';
GRANT ALL PRIVILEGES ON simplydemo.* TO 'simplydemo'@'%';
GRANT SELECT, RELOAD, SHOW DATABASES, REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO 'simplydemo'@'%';

FLUSH PRIVILEGES;

CREATE TABLE IF NOT EXISTS simplydemo.common_code (
    ID                  INT AUTO_INCREMENT PRIMARY KEY,
    GROUP_CODE          VARCHAR(50) NOT NULL COMMENT '코드 그룹',
    CODE                VARCHAR(50) NOT NULL COMMENT '개별 코드',
    CODE_NAME           VARCHAR(100) NOT NULL COMMENT '코드 이름',
    DESCRIPTION         VARCHAR(255) DEFAULT NULL COMMENT '설명',
    CREATED_AT          TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '생성 일시',
    UPDATED_AT          TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정 일시',
    UNIQUE KEY          unique_group_code (GROUP_CODE, CODE)
) COMMENT='공통 코드 테이블';

LOAD DATA INFILE '/var/lib/mysql-files/data/common_code.csv' INTO TABLE simplydemo.common_code
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
IGNORE 1 LINES
(group_code,code,code_name,description);


CREATE TABLE IF NOT EXISTS simplydemo.users
(
    id                  SERIAL PRIMARY KEY,
    first_name          VARCHAR(255),
    last_name           VARCHAR(255),
    email               VARCHAR(255),
    residence           VARCHAR(500),
    lat                 DECIMAL(10, 8),
    lon                 DECIMAL(10, 8),
    created_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS simplydemo.products
(
    id                  SERIAL PRIMARY KEY,
    name                VARCHAR(100),
    description         VARCHAR(500),
    category            VARCHAR(100),
    price               FLOAT,
    image               VARCHAR(200),
    created_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

LOAD DATA INFILE '/var/lib/mysql-files/data/products.csv' INTO TABLE simplydemo.products
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
IGNORE 1 LINES
( name,description,price,category,image );

LOAD DATA INFILE '/var/lib/mysql-files/data/users-mini.csv' INTO TABLE simplydemo.users
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
IGNORE 1 LINES
( first_name,last_name,email,residence,lat,lon );


CREATE DATABASE IF NOT EXISTS demo;
use demo;

CREATE USER 'demo'@'%' IDENTIFIED WITH mysql_native_password BY 'demo1234';
GRANT ALL PRIVILEGES ON demo.* TO 'demo'@'%';
GRANT SELECT, RELOAD, SHOW DATABASES, REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO 'demo'@'%';

FLUSH PRIVILEGES;


CREATE TABLE IF NOT EXISTS demo.customer
(
    id                  SERIAL PRIMARY KEY,
    first_name          VARCHAR(255),
    last_name           VARCHAR(255),
    email               VARCHAR(255),
    created_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS demo.board
(
    num                 SERIAL PRIMARY KEY,
    subject             VARCHAR(255),
    contents            VARCHAR(500),
    user_id             BIGINT NOT NULL,
    last_name           VARCHAR(255),
    full_name           VARCHAR(255),
    nick                VARCHAR(255),
    email               VARCHAR(255),
    twitter             VARCHAR(255),
    viewcnt             INT DEFAULT 0,
    user_type           VARCHAR(10),
    created_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS demo.codes (
    id                  INT AUTO_INCREMENT PRIMARY KEY,
    code_group          VARCHAR(50) NOT NULL COMMENT '코드 그룹',
    code                VARCHAR(50) NOT NULL COMMENT '개별 코드',
    code_name           VARCHAR(100) NOT NULL COMMENT '코드 이름',
    description         VARCHAR(255) DEFAULT NULL COMMENT '설명',
    created_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '생성 일시',
    updated_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정 일시',
    UNIQUE KEY          unique_group_code (code_group, code)
) COMMENT='공통 코드 테이블';