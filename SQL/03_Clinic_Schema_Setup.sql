CREATE TABLE IF NOT EXISTS clinics (
    cid         VARCHAR(50) PRIMARY KEY,
    clinic_name VARCHAR(100),
    city        VARCHAR(100),
    state       VARCHAR(100),
    country     VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS customer (
    uid    VARCHAR(50) PRIMARY KEY,
    name   VARCHAR(100),
    mobile VARCHAR(15)
);

CREATE TABLE IF NOT EXISTS clinic_sales (
    oid          VARCHAR(50) PRIMARY KEY,
    uid          VARCHAR(50),
    cid          VARCHAR(50),
    amount       DECIMAL(12,2),
    datetime     DATETIME,
    sales_channel VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS expenses (
    eid         VARCHAR(50) PRIMARY KEY,
    cid         VARCHAR(50),
    description VARCHAR(200),
    amount      DECIMAL(12,2),
    datetime    DATETIME
);

-- Sample Data

INSERT INTO clinics VALUES
('cnc-001', 'HealthFirst Clinic',  'Hyderabad', 'Telangana',      'India'),
('cnc-002', 'CareWell Clinic',     'Hyderabad', 'Telangana',      'India'),
('cnc-003', 'MediCure Clinic',     'Mumbai',    'Maharashtra',    'India'),
('cnc-004', 'LifeLine Clinic',     'Chennai',   'Tamil Nadu',     'India'),
('cnc-005', 'WellnessHub Clinic',  'Bengaluru', 'Karnataka',      'India');

INSERT INTO customer VALUES
('uid-001', 'Arun Sharma',  '9800000001'),
('uid-002', 'Priya Reddy',  '9800000002'),
('uid-003', 'Karan Mehta',  '9800000003'),
('uid-004', 'Neha Joshi',   '9800000004'),
('uid-005', 'Suresh Babu',  '9800000005');

INSERT INTO clinic_sales VALUES
('ord-001', 'uid-001', 'cnc-001', 24999.00, '2021-01-10 10:00:00', 'online'),
('ord-002', 'uid-002', 'cnc-001', 15000.00, '2021-01-15 11:00:00', 'offline'),
('ord-003', 'uid-003', 'cnc-002', 30000.00, '2021-02-05 09:00:00', 'online'),
('ord-004', 'uid-001', 'cnc-002', 12000.00, '2021-02-20 14:00:00', 'sodat'),
('ord-005', 'uid-004', 'cnc-003', 50000.00, '2021-03-10 16:00:00', 'offline'),
('ord-006', 'uid-005', 'cnc-003', 18000.00, '2021-03-25 12:00:00', 'online'),
('ord-007', 'uid-002', 'cnc-004', 22000.00, '2021-04-05 10:30:00', 'sodat'),
('ord-008', 'uid-003', 'cnc-005', 40000.00, '2021-04-18 15:00:00', 'offline'),
('ord-009', 'uid-001', 'cnc-001', 35000.00, '2021-09-12 09:00:00', 'online'),
('ord-010', 'uid-004', 'cnc-002', 28000.00, '2021-09-20 11:00:00', 'sodat');

INSERT INTO expenses VALUES
('exp-001', 'cnc-001', 'First-aid supplies',    5000.00,  '2021-01-05 08:00:00'),
('exp-002', 'cnc-001', 'Staff salaries',         80000.00, '2021-01-31 08:00:00'),
('exp-003', 'cnc-002', 'Medicines stock',         20000.00, '2021-02-10 09:00:00'),
('exp-004', 'cnc-002', 'Equipment maintenance',  8000.00,  '2021-02-25 10:00:00'),
('exp-005', 'cnc-003', 'Staff salaries',         90000.00, '2021-03-31 08:00:00'),
('exp-006', 'cnc-003', 'Utilities',              3000.00,  '2021-03-28 07:00:00'),
('exp-007', 'cnc-004', 'Rent',                   15000.00, '2021-04-01 08:00:00'),
('exp-008', 'cnc-005', 'Medicines stock',         25000.00, '2021-04-15 09:00:00'),
('exp-009', 'cnc-001', 'Medicines stock',         10000.00, '2021-09-08 09:00:00'),
('exp-010', 'cnc-002', 'Utilities',               5000.00, '2021-09-15 07:00:00');
