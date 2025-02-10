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



-- SOURCE

CREATE DATABASE IF NOT EXISTS demosrc;
use demosrc;

CREATE USER 'kafkasrc'@'%' IDENTIFIED WITH mysql_native_password BY 'DeMoKafkaSrc1234%%';
GRANT ALL PRIVILEGES ON demosrc.* TO 'kafkasrc'@'%';
GRANT SELECT, RELOAD, SHOW DATABASES, REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO 'kafkasrc'@'%';

FLUSH PRIVILEGES;

CREATE TABLE IF NOT EXISTS demosrc.products
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

INSERT INTO demosrc.products (name, description, category, price, image)
VALUES
    ('Smartphone', 'A high-end smartphone with great features', 'Electronics', 699.99, 'https://example.com/images/smartphone.jpg'),
    ('Laptop', 'A lightweight laptop for work and play', 'Electronics', 1299.99, 'https://example.com/images/laptop.jpg'),
    ('Headphones', 'Noise-cancelling headphones for immersive sound', 'Accessories', 199.99, 'https://example.com/images/headphones.jpg'),
    ('Camera', 'DSLR camera for professional photography', 'Electronics', 899.99, 'https://example.com/images/camera.jpg'),
    ('Backpack', 'Durable and waterproof backpack for travel', 'Accessories', 49.99, 'https://example.com/images/backpack.jpg'),
    ('Gaming Console', 'Next-gen gaming console with stunning graphics', 'Gaming', 499.99, 'https://example.com/images/console.jpg'),
    ('Smartwatch', 'Fitness tracking and notifications on your wrist', 'Wearables', 249.99, 'https://example.com/images/smartwatch.jpg'),
    ('Coffee Maker', 'Brew the perfect cup of coffee every time', 'Home Appliances', 99.99, 'https://example.com/images/coffeemaker.jpg'),
    ('Electric Scooter', 'Eco-friendly electric scooter for urban commuting', 'Transport', 399.99, 'https://example.com/images/scooter.jpg'),
    ('Desk Lamp', 'LED desk lamp with adjustable brightness', 'Home & Office', 29.99, 'https://example.com/images/desklamp.jpg');



-- SINK

CREATE DATABASE IF NOT EXISTS demosink;
use demosink;

CREATE USER 'kafkasink'@'%' IDENTIFIED WITH mysql_native_password BY 'DeMoKafkaSinker1234%%';
GRANT ALL PRIVILEGES ON demosink.* TO 'kafkasink'@'%';
GRANT SELECT, RELOAD, SHOW DATABASES, REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO 'kafkasink'@'%';

FLUSH PRIVILEGES;


CREATE TABLE IF NOT EXISTS demosink.productinfo
(
    id                  SERIAL PRIMARY KEY,
    name                VARCHAR(100),
    description         VARCHAR(500),
    category            VARCHAR(100),
    price               FLOAT,
    created_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

