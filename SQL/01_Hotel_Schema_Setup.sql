CREATE TABLE IF NOT EXISTS users (
    user_id       VARCHAR(50) PRIMARY KEY,
    name          VARCHAR(100),
    phone_number  VARCHAR(15),
    mail_id       VARCHAR(100),
    billing_address VARCHAR(200)
);

CREATE TABLE IF NOT EXISTS bookings (
    booking_id    VARCHAR(50) PRIMARY KEY,
    booking_date  DATETIME,
    room_no       VARCHAR(50),
    user_id       VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS items (
    item_id       VARCHAR(50) PRIMARY KEY,
    item_name     VARCHAR(100),
    item_rate     DECIMAL(10,2)
);

CREATE TABLE IF NOT EXISTS booking_commercials (
    id            VARCHAR(50) PRIMARY KEY,
    booking_id    VARCHAR(50),
    bill_id       VARCHAR(50),
    bill_date     DATETIME,
    item_id       VARCHAR(50),
    item_quantity DECIMAL(10,2)
);

-- ----------------------
-- Sample Data
-- ----------------------

INSERT INTO users VALUES
('u001', 'John Doe',   '9700000001', 'john@example.com', 'Hyderabad'),
('u002', 'Jane Smith', '9700000002', 'jane@example.com', 'Mumbai'),
('u003', 'Ravi Kumar', '9700000003', 'ravi@example.com', 'Chennai');

INSERT INTO bookings VALUES
('bk001', '2021-09-10 10:00:00', 'rm-101', 'u001'),
('bk002', '2021-11-01 14:00:00', 'rm-102', 'u001'),
('bk003', '2021-11-15 09:00:00', 'rm-103', 'u002'),
('bk004', '2021-10-05 11:00:00', 'rm-104', 'u003'),
('bk005', '2021-11-20 16:00:00', 'rm-105', 'u003');

INSERT INTO items VALUES
('itm001', 'Tawa Paratha', 18.00),
('itm002', 'Mix Veg',      89.00),
('itm003', 'Dal Fry',      75.00),
('itm004', 'Paneer Curry', 120.00),
('itm005', 'Rice',         40.00);

INSERT INTO booking_commercials VALUES
('bc001', 'bk002', 'bl001', '2021-11-01 12:00:00', 'itm001', 3),
('bc002', 'bk002', 'bl001', '2021-11-01 12:00:00', 'itm002', 1),
('bc003', 'bk003', 'bl002', '2021-11-15 15:00:00', 'itm003', 2),
('bc004', 'bk003', 'bl002', '2021-11-15 15:00:00', 'itm004', 1),
('bc005', 'bk004', 'bl003', '2021-10-05 11:00:00', 'itm001', 5),
('bc006', 'bk004', 'bl003', '2021-10-05 11:00:00', 'itm002', 10),
('bc007', 'bk005', 'bl004', '2021-11-20 17:00:00', 'itm004', 3),
('bc008', 'bk005', 'bl004', '2021-11-20 17:00:00', 'itm005', 2),
('bc009', 'bk001', 'bl005', '2021-09-10 13:00:00', 'itm003', 4),
('bc010', 'bk001', 'bl005', '2021-09-10 13:00:00', 'itm005', 1);


