# Hospital-sql-case-study


A end-to-end SQL analytics project on a simulated hospital database.  
Covers real clinical and operational business questions using MySQL — from basic aggregations to window functions, CTEs, and self-joins.

---

## Database Schema

6 tables — `departments`, `doctors`, `patients`, `appointments`, `billing`, `admissions`

```
patients ──── appointments ──── billing
                   │
              doctors ──── departments
patients ──── admissions
```

---

## Tools Used
- MySQL 8.0
- MySQL Workbench

---

## Business Questions & Queries

### 1. Top 5 Departments by Revenue
> Which departments generate the most billing revenue?

```sql
SELECT
    d.dept_name,
    COUNT(b.bill_id)       AS total_bills,
    SUM(b.amount)          AS total_revenue,
    ROUND(AVG(b.amount),2) AS avg_bill
FROM billing b
JOIN appointments a ON b.appt_id = a.appt_id
JOIN departments d  ON a.dept_id = d.dept_id
GROUP BY d.dept_name
ORDER BY total_revenue DESC
LIMIT 5;
```

**Result:** Oncology leads with ₹22,000 total revenue and highest avg bill of ₹5,500 — driven by long treatment cycles and high-cost procedures.

[Screenshots/Departmentrevenue.png](https://github.com/srujakwarbhuvan/Hospital-sql-case-study/blob/main/Screenshots/Department%20revenue.png?raw=true) 

---

### 2. No-Show Rate by Doctor
> Which doctors have the highest appointment no-show rate?

```sql
SELECT
    doc.name,
    COUNT(*)                                          AS total_appts,
    SUM(CASE WHEN a.status = 'No-Show' THEN 1 ELSE 0 END) AS no_shows,
    ROUND(
      100.0 * SUM(CASE WHEN a.status = 'No-Show' THEN 1 ELSE 0 END)
              / COUNT(*), 2
    )                                                 AS no_show_pct
FROM appointments a
JOIN doctors doc ON a.doctor_id = doc.doctor_id
GROUP BY doc.name
HAVING total_appts > 2
ORDER BY no_show_pct DESC;
```

**Result:** Dr. Priya Sharma and Dr. Deepak Singh both show a 25% no-show rate — 1 in 4 appointments missed, indicating a scheduling or follow-up gap.

[Screenshots/No-show rate.png](https://github.com/srujakwarbhuvan/Hospital-sql-case-study/blob/main/Screenshots/No-show%20rate.png?raw=true)


---

### 3. Month-over-Month Revenue Growth
> Is hospital revenue growing or declining month by month?

```sql
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
```

**Result:** Revenue is highly volatile — June 2023 saw a 375% spike while August dropped 68%. No consistent growth trend, suggesting seasonal demand or billing irregularity.

[Screenshots/MoM revenue.png](https://github.com/srujakwarbhuvan/Hospital-sql-case-study/blob/main/Screenshots/MoM%20revenue.png?raw=true)

---

### 4. Doctor Workload Ranking by Department
> Who are the most and least loaded doctors in each department?

```sql
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
```

**Result:** Dr. Anil Mehta handles 3x more patients than Dr. Arjun Patel in Cardiology — a clear workload imbalance that could impact care quality.

[Screenshots/Doctor load.png](https://github.com/srujakwarbhuvan/Hospital-sql-case-study/blob/main/Screenshots/Doctor%20load.png?raw=true)

---

### 5. Average Length of Stay and 30-Day Readmission Rate by Ward
> Which wards have the longest stays and highest readmission rates?

```sql
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
    ROUND(AVG(los_days), 1)      AS avg_los,
    COUNT(*)                      AS total_admissions,
    SUM(
      CASE WHEN DATEDIFF(next_admit, discharge_date) <= 30
      THEN 1 ELSE 0 END
    )                             AS readmissions_30d,
    ROUND(
      100.0 * SUM(
        CASE WHEN DATEDIFF(next_admit, discharge_date) <= 30
        THEN 1 ELSE 0 END
      ) / COUNT(*), 2
    )                             AS readmission_rate
FROM stay_data
GROUP BY ward
ORDER BY readmission_rate DESC;
```

**Result:** Oncology ward has the longest average stay at 10.8 days — nearly double the General ward at 5.0 days — consistent with complex treatment protocols.

[Screenshots/Ward stays.png](https://github.com/srujakwarbhuvan/Hospital-sql-case-study/blob/main/Screenshots/Ward%20stays.png?raw=true)

---

### 6. High-Value Repeat Patients
> Which patients visit 3+ times and spend above the hospital average? (loyalty program targets)

```sql
WITH patient_stats AS (
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
```

**Result:** 3 patients qualify — Rohit Shah (Nagpur) tops the list at ₹6,900 with a spend ratio of 1.44x above average, making him the strongest loyalty program candidate.

[Screenshots/Repeat patients.png](https://github.com/srujakwarbhuvan/Hospital-sql-case-study/blob/main/Screenshots/Repeat%20patients.png?raw=true)

---

## Key Insights

| # | Insight | Business Impact |
|---|---------|-----------------|
| 1 | Oncology generates 40% of total revenue | Prioritize resource allocation here |
| 2 | 25% no-show rate for 2 doctors | Implement reminder system or overbooking policy |
| 3 | Revenue volatile with no clear growth trend | Investigate June spike and August drop |
| 4 | Workload imbalance in Cardiology dept | Redistribute appointments to Dr. Arjun Patel |
| 5 | Oncology avg stay 10.8 days vs 5.0 General | Plan bed capacity accordingly |
| 6 | 3 high-value repeat patients identified | Target for loyalty or premium care program |

---

## SQL Concepts Used

- `GROUP BY`, `ORDER BY`, `HAVING`
- `CASE WHEN` for conditional aggregation
- `JOIN`, `LEFT JOIN` across multiple tables
- `LAG()` window function for MoM comparison
- `RANK()` with `PARTITION BY` for within-group ranking
- CTEs (`WITH`) for modular query structure
- `CROSS JOIN` for scalar value attachment
- Self-join on `admissions` for readmission detection
- `DATEDIFF`, `DATE_FORMAT`, `COALESCE`, `ROUND`
