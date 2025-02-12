-- schema.cql (채팅 애플리케이션 스키마 예제)

-- 1. 키스페이스 생성
CREATE KEYSPACE IF NOT EXISTS chat_app
    WITH replication = {'class': 'SimpleStrategy', 'replication_factor': '3'};

-- 2. 클라이언트 정보를 저장하는 테이블 (사용자 식별)
CREATE TABLE IF NOT EXISTS chat_app.clients (
                                                client_id uuid PRIMARY KEY,
                                                client_name text,
                                                registered_at timestamp
);

-- 3. 대화 세션(컨텍스트) 정보를 저장하는 테이블
CREATE TABLE IF NOT EXISTS chat_app.conversations (
                                                      conversation_id uuid PRIMARY KEY,
                                                      client_id uuid,
                                                      topic text,
                                                      started_at timestamp,
                                                      last_updated timestamp
);

-- 4. 메시지 내역을 저장하는 테이블 (대화 흐름을 시간 순으로 정렬)
CREATE TABLE IF NOT EXISTS chat_app.messages (
                                                 conversation_id uuid,
                                                 message_id timeuuid,
                                                 sender text,
                                                 content text,
                                                 created_at timestamp,
                                                 PRIMARY KEY (conversation_id, message_id)
) WITH CLUSTERING ORDER BY (message_id ASC);

-- 5. 기초 데이터 삽입
-- 샘플 클라이언트 (예시 UUID: '123e4567-e89b-12d3-a456-426614174000')
INSERT INTO chat_app.clients (client_id, client_name, registered_at)
VALUES ('123e4567-e89b-12d3-a456-426614174000', 'Sample Client', toTimestamp(now()));

-- 샘플 대화 세션 (예시 UUID: '123e4567-e89b-12d3-a456-426614174001')
INSERT INTO chat_app.conversations (conversation_id, client_id, topic, started_at, last_updated)
VALUES ('123e4567-e89b-12d3-a456-426614174001', '123e4567-e89b-12d3-a456-426614174000', 'General Chat', toTimestamp(now()), toTimestamp(now()));

-- 샘플 메시지 삽입: 클라이언트의 첫 메시지
INSERT INTO chat_app.messages (conversation_id, message_id, sender, content, created_at)
VALUES ('123e4567-e89b-12d3-a456-426614174001', now(), 'client', 'Hello, how are you?', toTimestamp(now()));

-- 샘플 메시지 삽입: 서버(LLM)의 응답
INSERT INTO chat_app.messages (conversation_id, message_id, sender, content, created_at)
VALUES ('123e4567-e89b-12d3-a456-426614174001', now(), 'server', 'I am fine, thank you!', toTimestamp(now()));
