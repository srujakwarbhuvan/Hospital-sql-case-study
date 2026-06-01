CREATE DATABASE IF NOT EXISTS hospital_db;
USE hospital_db;

USE hospital_db;

CREATE TABLE departments (
  dept_id    INT PRIMARY KEY AUTO_INCREMENT,
  dept_name  VARCHAR(100) NOT NULL,
  floor_no   INT
);

CREATE TABLE doctors (
  doctor_id     INT PRIMARY KEY AUTO_INCREMENT,
  name          VARCHAR(100) NOT NULL,
  specialization VARCHAR(100),
  dept_id       INT,
  joining_date  DATE,
  FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

CREATE TABLE patients (
  patient_id    INT PRIMARY KEY AUTO_INCREMENT,
  name          VARCHAR(100) NOT NULL,
  age           INT,
  gender        ENUM('Male','Female','Other'),
  city          VARCHAR(100),
  blood_group   VARCHAR(5),
  registered_on DATE
);

CREATE TABLE appointments (
  appt_id    INT PRIMARY KEY AUTO_INCREMENT,
  patient_id INT,
  doctor_id  INT,
  dept_id    INT,
  appt_date  DATE,
  status     ENUM('Completed','No-Show','Cancelled','Scheduled'),
  FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
  FOREIGN KEY (doctor_id)  REFERENCES doctors(doctor_id),
  FOREIGN KEY (dept_id)    REFERENCES departments(dept_id)
);

CREATE TABLE billing (
  bill_id      INT PRIMARY KEY AUTO_INCREMENT,
  patient_id   INT,
  appt_id      INT,
  amount       DECIMAL(10,2),
  paid_on      DATE,
  payment_mode ENUM('Cash','Card','Insurance','UPI'),
  FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
  FOREIGN KEY (appt_id)    REFERENCES appointments(appt_id)
);

CREATE TABLE admissions (
  admission_id   INT PRIMARY KEY AUTO_INCREMENT,
  patient_id     INT,
  admit_date     DATE,
  discharge_date DATE,
  ward           VARCHAR(50),
  bed_no         INT,
  FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
);

USE hospital_db;

CREATE TABLE departments (
  dept_id    INT PRIMARY KEY AUTO_INCREMENT,
  dept_name  VARCHAR(100) NOT NULL,
  floor_no   INT
);

CREATE TABLE doctors (
  doctor_id     INT PRIMARY KEY AUTO_INCREMENT,
  name          VARCHAR(100) NOT NULL,
  specialization VARCHAR(100),
  dept_id       INT,
  joining_date  DATE,
  FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

CREATE TABLE patients (
  patient_id    INT PRIMARY KEY AUTO_INCREMENT,
  name          VARCHAR(100) NOT NULL,
  age           INT,
  gender        ENUM('Male','Female','Other'),
  city          VARCHAR(100),
  blood_group   VARCHAR(5),
  registered_on DATE
);

CREATE TABLE appointments (
  appt_id    INT PRIMARY KEY AUTO_INCREMENT,
  patient_id INT,
  doctor_id  INT,
  dept_id    INT,
  appt_date  DATE,
  status     ENUM('Completed','No-Show','Cancelled','Scheduled'),
  FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
  FOREIGN KEY (doctor_id)  REFERENCES doctors(doctor_id),
  FOREIGN KEY (dept_id)    REFERENCES departments(dept_id)
);

CREATE TABLE billing (
  bill_id      INT PRIMARY KEY AUTO_INCREMENT,
  patient_id   INT,
  appt_id      INT,
  amount       DECIMAL(10,2),
  paid_on      DATE,
  payment_mode ENUM('Cash','Card','Insurance','UPI'),
  FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
  FOREIGN KEY (appt_id)    REFERENCES appointments(appt_id)
);

CREATE TABLE admissions (
  admission_id   INT PRIMARY KEY AUTO_INCREMENT,
  patient_id     INT,
  admit_date     DATE,
  discharge_date DATE,
  ward           VARCHAR(50),
  bed_no         INT,
  FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
);

USE hospital_db;

INSERT INTO departments (dept_name, floor_no) VALUES
('Cardiology', 2), ('Neurology', 3), ('Orthopedics', 1),
('Oncology', 4), ('General Medicine', 1), ('Pediatrics', 2);

INSERT INTO doctors (name, specialization, dept_id, joining_date) VALUES
('Dr. Anil Mehta',    'Cardiologist',    1, '2015-06-01'),
('Dr. Priya Sharma',  'Neurologist',     2, '2017-03-15'),
('Dr. Ravi Kumar',    'Orthopedician',   3, '2013-09-10'),
('Dr. Sunita Joshi',  'Oncologist',      4, '2018-01-20'),
('Dr. Deepak Singh',  'General Physician',5,'2019-07-05'),
('Dr. Kavita Nair',   'Pediatrician',    6, '2020-02-28'),
('Dr. Arjun Patel',   'Cardiologist',    1, '2016-11-11'),
('Dr. Meena Reddy',   'Neurologist',     2, '2021-04-01');

INSERT INTO patients (name, age, gender, city, blood_group, registered_on) VALUES
('Rahul Verma',     34, 'Male',   'Nagpur',  'B+',  '2022-01-10'),
('Sneha Patil',     28, 'Female', 'Pune',    'A+',  '2022-03-05'),
('Manoj Gupta',     52, 'Male',   'Mumbai',  'O+',  '2021-11-20'),
('Anita Desai',     45, 'Female', 'Nashik',  'AB+', '2022-06-15'),
('Rohit Shah',      60, 'Male',   'Nagpur',  'B-',  '2020-08-30'),
('Pooja Iyer',      22, 'Female', 'Pune',    'A-',  '2023-01-12'),
('Vikram Joshi',    41, 'Male',   'Mumbai',  'O-',  '2021-05-18'),
('Rekha Nair',      55, 'Female', 'Nagpur',  'AB-', '2022-09-01'),
('Suresh Rao',      38, 'Male',   'Nashik',  'B+',  '2023-03-22'),
('Kavya Menon',     30, 'Female', 'Pune',    'A+',  '2022-12-07'),
('Ajay Pandey',     47, 'Male',   'Mumbai',  'O+',  '2021-07-14'),
('Nisha Tiwari',    35, 'Female', 'Nagpur',  'B+',  '2023-05-30');

INSERT INTO appointments (patient_id, doctor_id, dept_id, appt_date, status) VALUES
(1,1,1,'2023-01-15','Completed'),(1,7,1,'2023-04-20','Completed'),
(1,1,1,'2023-08-10','Completed'),(2,2,2,'2023-02-18','No-Show'),
(2,6,6,'2023-05-25','Completed'),(3,3,3,'2023-01-30','Completed'),
(3,5,5,'2023-06-14','Completed'),(3,3,3,'2023-09-01','Cancelled'),
(4,4,4,'2023-03-10','Completed'),(4,4,4,'2023-07-22','Completed'),
(5,1,1,'2023-02-05','Completed'),(5,7,1,'2023-05-18','No-Show'),
(5,1,1,'2023-10-03','Completed'),(6,6,6,'2023-04-11','Completed'),
(7,2,2,'2023-03-28','Completed'),(7,5,5,'2023-08-16','No-Show'),
(8,4,4,'2023-06-07','Completed'),(8,4,4,'2023-11-15','Completed'),
(9,3,3,'2023-02-22','Completed'),(10,6,6,'2023-05-30','Completed'),
(10,2,2,'2023-09-12','Completed'),(11,5,5,'2023-01-08','Completed'),
(11,1,1,'2023-07-04','Cancelled'),(12,8,2,'2023-04-19','Completed'),
(12,6,6,'2023-10-28','Completed'),(1,5,5,'2024-01-10','Completed'),
(3,1,1,'2024-02-14','Completed'),(5,2,2,'2024-03-20','Completed');

INSERT INTO billing (patient_id, appt_id, amount, paid_on, payment_mode) VALUES
(1,1,1500.00,'2023-01-15','Card'),   (1,2,1800.00,'2023-04-20','UPI'),
(1,3,1600.00,'2023-08-10','Insurance'),(3,6,2200.00,'2023-01-30','Cash'),
(3,7,900.00, '2023-06-14','UPI'),   (4,9,5500.00,'2023-03-10','Insurance'),
(4,10,5000.00,'2023-07-22','Insurance'),(5,11,1700.00,'2023-02-05','Card'),
(5,13,1900.00,'2023-10-03','Card'), (6,14,800.00,'2023-04-11','Cash'),
(7,15,3200.00,'2023-03-28','Insurance'),(8,17,6000.00,'2023-06-07','Insurance'),
(8,18,5500.00,'2023-11-15','Insurance'),(9,19,2100.00,'2023-02-22','UPI'),
(10,20,750.00,'2023-05-30','Cash'), (10,21,3100.00,'2023-09-12','Card'),
(11,22,1100.00,'2023-01-08','Cash'),(12,24,2800.00,'2023-04-19','UPI'),
(12,25,2600.00,'2023-10-28','Card'),(2,5,700.00,'2023-05-25','Cash'),
(1,26,1400.00,'2024-01-10','UPI'),  (3,27,1950.00,'2024-02-14','Card'),
(5,28,3300.00,'2024-03-20','Insurance');

INSERT INTO admissions (patient_id, admit_date, discharge_date, ward, bed_no) VALUES
(3,'2023-01-30','2023-02-05','General',  12),
(4,'2023-03-10','2023-03-18','Oncology', 3),
(5,'2023-02-05','2023-02-09','Cardiac',  7),
(7,'2023-03-28','2023-04-04','Neurology',15),
(8,'2023-06-07','2023-06-20','Oncology', 4),
(11,'2023-01-08','2023-01-12','General', 9),
(3,'2023-09-05','2023-09-10','General',  12),
(5,'2023-10-06','2023-10-11','Cardiac',  6),
(4,'2024-01-15','2024-01-25','Oncology', 2),
(8,'2024-02-10','2024-02-22','Oncology', 5);

SELECT 'departments' AS tbl, COUNT(*) AS rows FROM departments
UNION ALL
SELECT 'doctors',     COUNT(*) FROM doctors
UNION ALL
SELECT 'patients',    COUNT(*) FROM patients
UNION ALL
SELECT 'appointments',COUNT(*) FROM appointments
UNION ALL
SELECT 'billing',     COUNT(*) FROM billing
UNION ALL
SELECT 'admissions',  COUNT(*) FROM admissions;

SELECT * FROM admissions;\

-- Top 5 departments by revenue-- 
SELECT
    d.dept_name,
    COUNT(b.bill_id)      AS total_bills,
    SUM(b.amount)         AS total_revenue,
    ROUND(AVG(b.amount),2) AS avg_bill
FROM billing b
JOIN appointments a  ON b.appt_id    = a.appt_id
JOIN departments d   ON a.dept_id    = d.dept_id
GROUP BY d.dept_name
ORDER BY total_revenue DESC
LIMIT 5;


-- Which doctors have the highest appointment cancellation / no-show rate? -- 
SELECT
    doc.name,
    COUNT(*)                                         AS total_appts,
    SUM(CASE WHEN a.status = 'No-Show' THEN 1 ELSE 0 END)  AS no_shows,
    ROUND(
      100.0 * SUM(CASE WHEN a.status = 'No-Show' THEN 1 END)
              / COUNT(*), 2
    )                                                AS no_show_pct
FROM appointments a
JOIN doctors doc ON a.doctor_id = doc.doctor_id
GROUP BY doc.name
HAVING total_appts > 2
ORDER BY no_show_pct DESC;

--  Is hospital revenue growing or declining month by month?
WITH monthly_rev AS (
    SELECT
        DATE_FORMAT(paid_on, '%Y-%m') AS month,
        SUM(amount)                   AS revenue
    FROM billing
    GROUP BY month
)
SELECT
    month,
    revenue,
    LAG(revenue) OVER (ORDER BY month)  AS prev_month,
    ROUND(
      100.0 * (revenue - LAG(revenue) OVER (ORDER BY month))
              / LAG(revenue) OVER (ORDER BY month), 2
    )                                   AS mom_growth_pct
FROM monthly_rev
ORDER BY month;

-- Which wards have long stays, and are patients being readmitted within 30 days?

WITH stay_data AS (
    SELECT
        a1.patient_id,
        a1.ward,
        a1.admit_date,
        a1.discharge_date,
        DATEDIFF(a1.discharge_date, a1.admit_date) AS los_days,
        MIN(a2.admit_date)                          AS next_admit
    FROM admissions a1
    LEFT JOIN admissions a2
           ON a1.patient_id   = a2.patient_id
          AND a2.admit_date   > a1.discharge_date
    GROUP BY a1.admission_id, a1.patient_id, a1.ward,
             a1.admit_date, a1.discharge_date
)
SELECT
    ward,
    ROUND(AVG(los_days), 1)                      AS avg_los,
    COUNT(*)                                      AS total_admissions,
    SUM(
      CASE
        WHEN DATEDIFF(next_admit, discharge_date) <= 30
        THEN 1 ELSE 0
      END
    )                                             AS readmissions_30d,
    ROUND(
      100.0 * SUM(
        CASE
          WHEN DATEDIFF(next_admit, discharge_date) <= 30
          THEN 1 ELSE 0
        END
      ) / COUNT(*), 2
    )                                             AS readmission_rate
FROM stay_data
GROUP BY ward
ORDER BY readmission_rate DESC;


-- Which doctors handle the most patients in each department?
SELECT
    d.dept_name,
    doc.name,
    COUNT(a.appt_id)   AS patient_load,
    RANK() OVER (
      PARTITION BY d.dept_id
      ORDER BY COUNT(a.appt_id) DESC
    )                  AS dept_rank
FROM appointments a
JOIN doctors     doc ON a.doctor_id = doc.doctor_id
JOIN departments d   ON doc.dept_id = d.dept_id
GROUP BY d.dept_id, d.dept_name, doc.doctor_id, doc.name
ORDER BY d.dept_name, dept_rank;

-- Which patients visit frequently AND spend above average?\

WITH patient_stats AS (
    -- Total visits and spend per patient
    SELECT
        p.patient_id,
        p.name,
        p.city,
        COUNT(DISTINCT a.appt_id)  AS visit_count,
        COALESCE(SUM(b.amount), 0) AS total_spent
    FROM patients p
    LEFT JOIN appointments a ON p.patient_id = a.patient_id
    LEFT JOIN billing      b ON a.appt_id    = b.appt_id
    GROUP BY p.patient_id, p.name, p.city
),
avg_spend AS (
    
    SELECT AVG(total_spent) AS hospital_avg
    FROM patient_stats
    WHERE visit_count > 0
)

SELECT
    ps.name,
    ps.city,
    ps.visit_count,
    ps.total_spent,
    ROUND(ps.total_spent / a.hospital_avg, 2) AS spend_vs_avg
FROM patient_stats ps
CROSS JOIN avg_spend a
WHERE ps.visit_count >= 3
  AND ps.total_spent > a.hospital_avg
ORDER BY ps.total_spent DESC;