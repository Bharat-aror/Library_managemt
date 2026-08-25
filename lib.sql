CREATE TABLE branch(
    branch_id VARCHAR(10) PRIMARY KEY,
    manager_id	VARCHAR(10),
    branch_address	VARCHAR(100),
    contact_no VARCHAR(10)

);
ALTER TABLE branch
ALTER COLUMN contact_no TYPE VARCHAR(20) 
CREATE TABLE employees(
    emp_id VARCHAR(10) PRIMARY KEY,	
    emp_name VARCHAR(30),	
    position VARCHAR(20),	
    salary	INT,
    branch_id VARCHAR(30) --fk


);
CREATE TABLE books(
    isbn VARCHAR(20) PRIMARY KEY,	
    book_title	VARCHAR(75),
    category VARCHAR(20),
    rental_price float(20), 	
    status	VARCHAR(20),
    author	VARCHAR(40),
    publisher VARCHAR(60)

);
CREATE TABLE members(
    member_id VARCHAR(20) PRIMARY KEY,	
    member_name	VARCHAR(30),
    member_address	VARCHAR(70),
    reg_date date

);
CREATE TABLE issue_books(
    issued_id VARCHAR(20) PRIMARY KEY,	
    issued_member_id VARCHAR(20), 	--FK
    issued_book_name VARCHAR(50), 	
    issued_date	date,
    issued_book_isbn VARCHAR(25),	--FK
    issued_emp_id VARCHAR(20) --FK

);
ALTER TABLE issue_books
ALTER COLUMN issued_book_name TYPE VARCHAR(100)

CREATE TABLE return_st(
    return_id VARCHAR(10) PRIMARY KEY,	
    issued_id VARCHAR(15), --fk	
    return_book_name VARCHAR(75),	
    return_date	date,
    return_book_isbn VARCHAR(20)

);

INSERT INTO issue_books(issued_id, issued_member_id, issued_book_name, issued_date, issued_book_isbn, issued_emp_id)
VALUES
('IS151', 'C118', 'The Catcher in the Rye', CURRENT_DATE - INTERVAL '24 days',  '978-0-553-29698-2', 'E108'),
('IS152', 'C119', 'The Catcher in the Rye', CURRENT_DATE - INTERVAL '13 days',  '978-0-553-29698-2', 'E109'),
('IS153', 'C106', 'Pride and Prejudice', CURRENT_DATE - INTERVAL '7 days',  '978-0-14-143951-8', 'E107'),
('IS154', 'C105', 'The Road', CURRENT_DATE - INTERVAL '32 days',  '978-0-375-50167-0', 'E101');

-- Adding new column in return_status

ALTER TABLE return_st
ADD Column book_quality VARCHAR(15) DEFAULT('Good');

UPDATE return_st
SET book_quality = 'Damaged'
WHERE issued_id 
    IN ('IS112', 'IS117', 'IS118');
SELECT * FROM return_st;

--Foreign Keys
ALTER TABLE issue_books
ADD CONSTRAINT fk_members
FOREIGN KEY (issued_member_id)
REFERENCES members(member_id);

ALTER TABLE issue_books
ADD CONSTRAINT fk_book_id
FOREIGN KEY (issued_book_isbn)
REFERENCES books(isbn);

ALTER TABLE issue_books
ADD CONSTRAINT fk_emp_id
FOREIGN KEY (issued_emp_id)
REFERENCES employees(emp_id);

ALTER TABLE return_st
ADD CONSTRAINT fk_issue_id
FOREIGN KEY (issued_id)
REFERENCES issue_books(issued_id);

ALTER TABLE employees
ADD CONSTRAINT fk_brance_id
FOREIGN KEY (branch_id)
REFERENCES branch(branch_id);

-- inserting 
INSERT INTO 
    books(isbn, book_title, category, rental_price, status, author, publisher)
VALUES('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');

-- updating
UPDATE members
SET member_address = '125 main st'
WHERE member_id = 'C101';
SELECT * FROM members
    
-- Delete record

Delete FROM return_st
WHERE issued_id = 'IS121'
SELECT * FROM return_st


SELECT * 
FROM issue_books
WHERE issued_emp_id = 'E101'

SELECT 
    issued_emp_id,
    count(*) 
FROM issue_books
GROUP BY issued_emp_id 
HAVING COUNT(*) > 1

--each book and total times it has been issued--
CREATE TABLE books_counts AS
SELECT ib.issued_book_name, ib.issued_book_isbn, COUNT(ib.issued_id) AS total
FROM issue_books as ib 
JOIN books as b
ON ib.issued_book_isbn = b.isbn
GROUP BY ib.issued_id, ib.issued_book_name;

--find all books in a specifit category--

SELECT * 
FROM
    books
WHERE category = 'Classic';    

--total rental income for each book--

SELECT
     bk.category,
     sum(bk.rental_price),
    count(*)
FROM books as bk
JOIN issue_books as ib
ON bk.isbn = ib.issued_book_isbn
GROUP BY 1;

--List members who registered in last 180 days--

SELECT *
FROM members
WHERE reg_date >= CURRENT_DATE - INTERVAL '180 days'

--List Employees with Their Branch Manager's Name and their branch details--

SELECT 
    e.emp_id,
    e.emp_name,
    b.*,
    e2.emp_name as Manager
FROM employees as e
JOIN branch as b
ON e.branch_id = b.branch_id
JOIN employees as e2
on e2.emp_id = b.manager_id

--Create a Table of Books with Rental Price Above a Certain Threshold--
CREATE TABLE expensive_books AS  
SELECT *
FROM books  
WHERE rental_price >= 5.00;

SELECT* from expensive_books

--Retrieve the List of Books Not Yet Returned--

SELECT 
    ib.issued_book_name,
    ib.issued_date
FROM issue_books as ib    
LEFT JOIN return_st as rs
ON ib.issued_id = rs.issued_id 
WHERE return_id is NULL;

-- Identify Members with Overdue Books --
--issued st, member info, issue book, return st, 
SELECT 
    ib.issued_id,
    ib.issued_date,
    rs.return_date,
    CURRENT_DATE - issued_date as overdew
FROM 
    issue_books as ib
JOIN 
    members as m
ON m.member_id = ib.issued_member_id
JOIN 
    books as bk
ON bk.isbn = ib.issued_book_isbn
LEFT JOIN
     return_st as rs
ON ib.issued_id = rs.issued_id
WHERE 
    return_date is NULL
    AND (CURRENT_DATE - issued_date) > 30

--Task 14--

CREATE OR REPLACE PROCEDURE add_return_records(p_return_id VARCHAR(50), p_issued_id VARCHAR(50), p_book_quality VARCHAR(10))
LANGUAGE plpgsql
AS $$

DECLARE 
    v_isbn VARCHAR(50);
    v_book_name VARCHAR(50);

BEGIN
    INSERT INTO return_st(return_id, issued_id, return_date, book_quality)
    VALUES 
        (p_return_id, p_issued_id, CURRENT_DATE, p_book_quality);

        SELECT
            issued_book_isbn,
            issued_book_name
        INTO
            v_isbn,
            v_book_name
        FROM
            issue_books
        WHERE 
            issued_id = p_issued_id;
        UPDATE Books

        SET status = 'Yes'
        WHERE isbn = v_isbn;               

        RAISE NOTICE 'Thankyoy for returning book : %', v_book_name;

END;
$$        

SELECT * FROM books
WHERE isbn = '978-0-307-58837-1';

SELECT * FROM issue_books
WHERE issued_book_isbn = '978-0-307-58837-1';

CALL add_return_records('RS138', 'IS135', 'Good');


/*Create a query that generates a performance
report for each branch, showing the number
of books issued, the number of books returned,
and the total revenue generated from book rentals.*/

CREATE TABLE branch_reports
AS
    SELECT 
        b.branch_id,
        b.manager_id,
        count(ib.issued_id) as total_books_issued,
        count(rs.return_id) as total_books_returned,
        count(bk.rental_price) as total_revenue
    FROM 
        issue_books as ib
    JOIN employees as emp
    ON ib.issued_emp_id = emp.emp_id
    JOIN branch as b
    ON emp.branch_id = b.branch_id
    LEFT JOIN return_st as rs
    ON ib.issued_id = rs.issued_id
    JOIN Books AS bk
    ON bk.isbn = ib.issued_book_isbn

    GROUP BY 1;

SELECT * from branch_reports   

/*Use the CREATE TABLE AS (CTAS) statement
to create a new table active_members
containing members who have issued at 
least one book in the last 2 months.*/ 
CREATE TABLE active_members
AS 
SELECT * FROM Members
WHERE member_id IN(
    SELECT DISTINCT issued_member_id
    FROM
         issue_books
    WHERE
         issued_date > CURRENT_DATE - INTERVAL '2 months');

SELECT * FROM active_members;    

/*Write a query to find the top 3 employees who have processed the most book issues. 
Display the employee name, number of books processed, and their branch.*/
SELECT
     emp.emp_name,
    COUNT(ib.issued_id),
    b.*
FROM employees emp
JOIN issue_books as ib
ON emp.emp_id = ib.issued_emp_id
JOIN branch as b
ON emp.branch_id = b.branch_id

GROUP BY 1,3;

/*Objective: Create a stored procedure to manage the status of books in a library system. 
*/


CREATE OR REPLACE PROCEDURE issue_bookss(p_issued_id VARCHAR(10), p_issued_member_id VARCHAR(30), p_issued_book_isbn VARCHAR(30), p_issued_emp_id VARCHAR(10))
LANGUAGE plpgsql
AS $$

DECLARE
-- all the variabable
    v_status VARCHAR(10);

BEGIN
-- all the code
    -- checking if book is available 'yes'
    SELECT 
        status 
        INTO
        v_status
    FROM books
    WHERE isbn = p_issued_book_isbn;

    IF v_status = 'yes' THEN

        INSERT INTO issue_books(issued_id, issued_member_id, issued_date, issued_book_isbn, issued_emp_id)
        VALUES
        (p_issued_id, p_issued_member_id, CURRENT_DATE, p_issued_book_isbn, p_issued_emp_id);

        UPDATE books
            SET status = 'no'
        WHERE isbn = p_issued_book_isbn;

        RAISE NOTICE 'Book records added successfully for book isbn : %', p_issued_book_isbn;


    ELSE
        RAISE NOTICE 'Sorry to inform you the book you have requested is unavailable book_isbn: %', p_issued_book_isbn;
    END IF;
END;
$$

-- Testing The function
SELECT * FROM books; 
-- "978-0-553-29698-2" -- yes
-- "978-0-375-41398-8" -- no
SELECT * FROM issued_status;

CALL issue_bookss('IS155', 'C108', '978-0-553-29698-2', 'E104');
CALL issue_bookss('IS156', 'C108', '978-0-375-41398-8', 'E104');

SELECT * FROM books
WHERE isbn = '978-0-553-29698-2'

