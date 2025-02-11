-- SOURCE

CREATE DATABASE IF NOT EXISTS demosrc;
use demosrc;

CREATE USER 'kafkasrc'@'%' IDENTIFIED WITH mysql_native_password BY 'kafkasrc1234%';
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
    ('Desk Lamp', 'LED desk lamp with adjustable brightness', 'Home & Office', 29.99, 'https://example.com/images/desklamp.jpg')
;



-- SINK

CREATE DATABASE IF NOT EXISTS demosink;
use demosink;

CREATE USER 'kafkasink'@'%' IDENTIFIED WITH mysql_native_password BY 'kafkasink1234';
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

