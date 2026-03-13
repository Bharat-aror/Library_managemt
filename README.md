# Library Management System (SQL Project)

## Project Overview
This project demonstrates the implementation of a Library Management System using SQL and PostgreSQL. It focuses on database design, data manipulation, and advanced querying techniques. The system manages book issuance, returns, member records, employees, and branch operations.

---
## ER Diagram
<img width="1557" height="803" alt="image" src="https://github.com/user-attachments/assets/420f569f-e1d4-434a-ab85-5521d60710bd" />

##  Objectives

### Database Setup
- Designed and created relational tables for:
  - Branches  
  - Employees  
  - Members  
  - Books  
  - Issued Status  
  - Return Status  
- Established primary and foreign key relationships to maintain data integrity.

###  CRUD Operations
- Implemented Create, Read, Update, and Delete operations.
- Managed book availability and transaction records.
- Updated book status automatically upon issuance and return.

### CTAS (Create Table As Select)
- Created new tables using query results.
- Generated report tables for analysis and performance tracking.

### Advanced SQL Queries
- Developed complex queries using:
  - JOIN operations
  - Aggregation functions (COUNT, SUM)
  - GROUP BY and filtering
  - Conditional logic
- Generated branch performance reports including:
  - Number of books issued
  - Number of books returned
  - Total rental revenue

---

### Skills Demonstrated
- Database Schema Design
- Relational Data Modeling
- Stored Procedures (PL/pgSQL)
- Conditional Logic (IF/ELSE)
- Query Optimization
- Data Analysis using SQL

---
## How to Run (PostgreSQL)

### 1) Create database
```bash
createdb library_db
```

### 2) Run the SQL script
```bash
psql -d library_db -f lib.sql
```

### 3) Import CSV data (optional)
From inside `psql`:
```sql
\copy branch FROM 'branch.csv' WITH (FORMAT csv, HEADER true);
\copy employees FROM 'employees.csv' WITH (FORMAT csv, HEADER true);
\copy books FROM 'books.csv' WITH (FORMAT csv, HEADER true);
\copy members FROM 'members.csv' WITH (FORMAT csv, HEADER true);
\copy issue_books FROM 'issued_status.csv' WITH (FORMAT csv, HEADER true);
\copy return_st FROM 'return_status.csv' WITH (FORMAT csv, HEADER true);
```

> Note: If your CSV files do not contain headers, replace `HEADER true` with `HEADER false`
and provide explicit column lists.
---
## 👨‍💻 Author
Bharat Arora  
MSc Data Science Student
