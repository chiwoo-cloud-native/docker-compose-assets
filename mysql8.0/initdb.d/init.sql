CREATE DATABASE simplydemo;

CREATE USER 'simplydemo'@'%' IDENTIFIED BY 'simplydemo1234';

GRANT ALL PRIVILEGES ON simplydemo.* TO 'simplydemo'@'%';

FLUSH PRIVILEGES;

use simplydemo;

CREATE TABLE customer (
                      id INT AUTO_INCREMENT PRIMARY KEY,
                      name VARCHAR(100) NOT NULL,
                      age INT NOT NULL,
                      email VARCHAR(255) UNIQUE,
                      phone VARCHAR(15),
                      address TEXT,
                      created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                      is_active BOOLEAN DEFAULT TRUE,
                      role ENUM('Admin', 'User', 'Guest') DEFAULT 'User'
);

INSERT INTO customer (name, age, email, phone, address, role) VALUES
    ('Alice', 30, 'alice@example.com', '123-456-7890', '123 Main St', 'Admin'),
    ('Bob', 25, 'bob@example.com', '987-654-3210', '456 Elm St', 'User'),
    ('Charlie', 35, 'charlie@example.com', '555-555-5555', '789 Oak St', 'Guest'),
    ('Diana', 28, 'diana@example.com', '111-222-3333', '321 Maple St', 'User'),
    ('Eve', 40, 'eve@example.com', '666-777-8888', '654 Pine St', 'Admin'),
    ('Frank', 32, 'frank@example.com', '444-333-2222', '987 Cedar St', 'User'),
    ('Grace', 29, 'grace@example.com', '333-444-5555', '159 Spruce St', 'Guest'),
    ('Hank', 27, 'hank@example.com', '222-111-0000', '753 Birch St', 'User'),
    ('Ivy', 31, 'ivy@example.com', '777-888-9999', '951 Walnut St', 'Admin'),
    ('Jack', 26, 'jack@example.com', '999-000-1111', '258 Chestnut St', 'Guest')
;