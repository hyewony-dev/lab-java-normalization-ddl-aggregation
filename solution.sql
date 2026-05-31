-- Exercise 1: Normalize a Blog Database

DROP TABLE IF EXISTS blog_posts;
DROP TABLE IF EXISTS authors;

CREATE TABLE authors (
                         id INT PRIMARY KEY,
                         name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE blog_posts (
                            id INT PRIMARY KEY,
                            author_id INT NOT NULL,
                            title VARCHAR(100) NOT NULL,
                            word_count INT NOT NULL,
                            views INT NOT NULL,
                            FOREIGN KEY (author_id) REFERENCES authors(id)
);

INSERT INTO authors (id, name) VALUES
                                   (1, 'Maria Charlotte'),
                                   (2, 'Juan Perez'),
                                   (3, 'Gemma Alcocer');

INSERT INTO blog_posts (id, author_id, title, word_count, views) VALUES
                                                                     (1, 1, 'Best Paint Colors', 814, 14),
                                                                     (2, 2, 'Small Space Decorating Tips', 1146, 221),
                                                                     (3, 1, 'Hot Accessories', 986, 105),
                                                                     (4, 1, 'Mixing Textures', 765, 22),
                                                                     (5, 2, 'Kitchen Refresh', 1242, 307),
                                                                     (6, 1, 'Homemade Art Hacks', 1002, 193),
                                                                     (7, 3, 'Refinishing Wood Floors', 1571, 7542);


-- Exercise 2: Normalize an Airline Database

DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS flights;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS aircrafts;

CREATE TABLE aircrafts (
                           id INT PRIMARY KEY,
                           name VARCHAR(100) NOT NULL,
                           total_seats INT NOT NULL
);

CREATE TABLE flights (
                         flight_number VARCHAR(20) PRIMARY KEY,
                         aircraft_id INT NOT NULL,
                         mileage INT NOT NULL,
                         FOREIGN KEY (aircraft_id) REFERENCES aircrafts(id)
);

CREATE TABLE customers (
                           id INT PRIMARY KEY,
                           name VARCHAR(100) NOT NULL,
                           status VARCHAR(20) NOT NULL,
                           total_mileage INT NOT NULL
);

CREATE TABLE bookings (
                          id INT PRIMARY KEY,
                          customer_id INT NOT NULL,
                          flight_number VARCHAR(20) NOT NULL,
                          FOREIGN KEY (customer_id) REFERENCES customers(id),
                          FOREIGN KEY (flight_number) REFERENCES flights(flight_number)
);

INSERT INTO aircrafts (id, name, total_seats) VALUES
                                                  (1, 'Boeing 747', 400),
                                                  (2, 'Airbus A330', 236),
                                                  (3, 'Boeing 777', 264);

INSERT INTO flights (flight_number, aircraft_id, mileage) VALUES
                                                              ('DL143', 1, 135),
                                                              ('DL122', 2, 4370),
                                                              ('DL53', 3, 2078),
                                                              ('DL222', 3, 1765),
                                                              ('DL37', 1, 531);

INSERT INTO customers (id, name, status, total_mileage) VALUES
                                                            (1, 'Agustine Riviera', 'Silver', 115235),
                                                            (2, 'Alaina Sepulvida', 'None', 6008),
                                                            (3, 'Tom Jones', 'Gold', 205767),
                                                            (4, 'Sam Rio', 'None', 2653),
                                                            (5, 'Jessica James', 'Silver', 127656),
                                                            (6, 'Ana Janco', 'Silver', 136773),
                                                            (7, 'Jennifer Cortez', 'Gold', 300582),
                                                            (8, 'Christian Janco', 'Silver', 14642);

INSERT INTO bookings (id, customer_id, flight_number) VALUES
                                                          (1, 1, 'DL143'),
                                                          (2, 1, 'DL122'),
                                                          (3, 2, 'DL122'),
                                                          (4, 1, 'DL143'),
                                                          (5, 3, 'DL122'),
                                                          (6, 3, 'DL53'),
                                                          (7, 1, 'DL143'),
                                                          (8, 4, 'DL143'),
                                                          (9, 1, 'DL143'),
                                                          (10, 3, 'DL222'),
                                                          (11, 5, 'DL143'),
                                                          (12, 4, 'DL143'),
                                                          (13, 6, 'DL222'),
                                                          (14, 7, 'DL222'),
                                                          (15, 5, 'DL122'),
                                                          (16, 4, 'DL37'),
                                                          (17, 8, 'DL222');


-- Exercise 3: SQL Queries

-- Total number of flights
SELECT COUNT(DISTINCT flight_number) FROM flights;

-- Average flight distance
SELECT AVG(mileage) FROM flights;

-- Average number of seats per aircraft
SELECT AVG(total_seats) FROM aircrafts;

-- Average miles flown by customers, grouped by status
SELECT status, AVG(total_mileage)
FROM customers
GROUP BY status;

-- Max miles flown by customers, grouped by status
SELECT status, MAX(total_mileage)
FROM customers
GROUP BY status;

-- Number of aircrafts with Boeing in their name
SELECT COUNT(*)
FROM aircrafts
WHERE name LIKE '%Boeing%';

-- Flights with distance between 300 and 2000 miles
SELECT *
FROM flights
WHERE mileage BETWEEN 300 AND 2000;

-- Average flight distance booked, grouped by customer status
SELECT c.status, AVG(f.mileage)
FROM bookings b
         JOIN customers c ON b.customer_id = c.id
         JOIN flights f ON b.flight_number = f.flight_number
GROUP BY c.status;

-- Most booked aircraft among Gold status members
SELECT a.name, COUNT(*) AS total_bookings
FROM bookings b
         JOIN customers c ON b.customer_id = c.id
         JOIN flights f ON b.flight_number = f.flight_number
         JOIN aircrafts a ON f.aircraft_id = a.id
WHERE c.status = 'Gold'
GROUP BY a.name
ORDER BY total_bookings DESC
    LIMIT 1;