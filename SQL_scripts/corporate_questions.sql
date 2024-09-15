-- QUESTIONS ASKED BY CORPORATE


			--- BASIC QUERIES ---


-- Can you provide a list of all employees working in the Scranton branch?"
SELECT e.employee_id, e.employee_name, e.department
FROM employees e
WHERE branch_id = 'B101'; -- B101 represents the Scranton branch


-- We need an employee list from all branches, including their respective branch names.
SELECT b.branch_name AS branch, e.employee_id AS eid, 
       e.employee_name AS name, e.department
FROM branches b
JOIN employees e ON b.branch_id = e.branch_id; 
-- This query joins the branches and employees tables


--Please provide a list of all products we sell, along with their respective prices.
SELECT DISTINCT(product_id), product_name, price
FROM products; 
-- DISTINCT ensures we don't have duplicate product entries


			--- SALES ANALYSIS ---


-- Can you provide a list of salespeople, the number of sales they've made, and the total revenue generated?
SELECT e.employee_name AS salesman,
       COUNT(s.sale_id) AS no_of_sales,
       SUM(s.sale_amount) AS total_revenue_in_USD$
FROM sales s
JOIN employees e ON s.employee_id = e.employee_id
GROUP BY e.employee_name
ORDER BY no_of_sales DESC;


-- We need to know the total sales amount for each branch. Can you provide a report for that?
SELECT b.branch_name,
       SUM(s.sale_amount) AS total_sales_inUSD$
FROM sales s
JOIN branches b ON s.branch_id = b.branch_id
GROUP BY b.branch_name;


-- Show me the top-selling products across all branches.
SELECT p.product_id, p.product_name,
       SUM(s.sale_amount) AS sales_amount
FROM products p
JOIN sales s ON p.product_id = s.product_id
GROUP BY p.product_id, p.product_name
ORDER BY sales_amount DESC;


--Can you tell me every employee's tenure with us up to 2010 for the Stamford branch?
SELECT employee_name,
       DATEDIFF(YEAR, hire_date, '2010-12-31') AS years_with_company
FROM employees
WHERE branch_id LIKE '%201';


--Which employees from both branches are the top performers based on sales?
SELECT e.employee_name,
       SUM(s.sale_amount) AS total_sales,
       RANK() OVER (ORDER BY SUM(s.sale_amount) DESC) AS sales_rank
FROM employees e
JOIN sales s ON e.employee_id = s.employee_id
GROUP BY e.employee_name;


--Can you find out if any sales employees are earning less than the average salary for their department?
SELECT employee_name, salary
FROM employees
WHERE department = 'Sales' AND salary < (
    SELECT AVG(salary)
    FROM employees
    WHERE department LIKE '%Sales%'
);


			--- ADVANCED ANALYSIS ---


-- We need a report showing sales trends for each branch over time.
SELECT b.branch_name, s.sale_date, SUM(s.sale_amount) AS sale_amount
FROM sales s
JOIN branches b ON s.branch_id = b.branch_id
GROUP BY b.branch_name, s.sale_date
ORDER BY s.sale_date;


--Please create a view for frequent access to sales performance by each employee.
DROP VIEW IF EXISTS sales_performance;

CREATE VIEW sales_performance AS
SELECT e.employee_name AS sales_person,
       COUNT(s.sale_id) AS no_of_sales,
       SUM(s.sale_amount) AS total_revenue_in_USD$,
       CAST(ROUND((SUM(s.sale_amount)/COUNT(s.sale_id)),0) AS INT) AS avg_amount_per_sale
FROM sales s
JOIN employees e ON s.employee_id = e.employee_id
GROUP BY e.employee_name;

SELECT *
FROM sales_performance
ORDER BY total_revenue_in_USD$ DESC;
-- This creates a view for easy access to sales performance metrics


--Please send us the list of employees with their respective departments whose salary ranges from 50,000 to 60,000
SELECT employee_name, department, salary
FROM employees
WHERE salary BETWEEN 50000 AND 60000
ORDER BY salary DESC;
-- This query filters employees based on a specific salary range


			--- DATA  RETRIEVAL, GROUPING AND FILTERING ---


-- Retrieve the last 5 records of sales
SELECT TOP 5 s.sale_id, s.sale_date, s.product_id, p.product_name, 
       s.sale_amount, e.employee_name
FROM sales s
JOIN employees e ON e.employee_id = s.employee_id
JOIN products p ON p.product_id = s.product_id
ORDER BY sale_date DESC;


-- Specific Range of Sales Records from 11th to 20th
SELECT s.sale_id, s.sale_date, s.product_id, p.product_name, 
       s.sale_amount, e.employee_name
FROM sales s
JOIN employees e ON e.employee_id = s.employee_id
JOIN products p ON p.product_id = s.product_id
ORDER BY sale_date
OFFSET 10 ROWS
FETCH NEXT 10 ROWS ONLY;


-- Find the maximum and minimum sale amounts per product.
SELECT product_id, MAX(sale_amount) AS max_sale, MIN(sale_amount) AS min_sale
FROM sales
GROUP BY product_id;


--Branches with average salary over a 40000 amount.
SELECT branch_id, AVG(salary) AS avg_salary
FROM employees
GROUP BY branch_id
HAVING AVG(salary) > 40000;


-- Use ROLLUP to get subtotals and grand totals of sales by branch.
SELECT branch_id, SUM(sale_amount) AS total_sales
FROM sales
GROUP BY ROLLUP(branch_id);
-- This query provides a hierarchical summary of sales by branch


-- Use CUBE to get cross-tabulations for sales by branch and product.
SELECT branch_id, product_id, SUM(sale_amount) AS total_sales
FROM sales
GROUP BY CUBE(branch_id, product_id);
-- This query provides a multi-dimensional summary of sales


			--- SUBQUERIES AND COMPLEX JOINS ---


--Retrieve products with sales amounts greater than the average sale amount of all products.
SELECT product_id, product_name
FROM products
WHERE product_id IN (
    SELECT product_id
    FROM sales
    GROUP BY product_id
    HAVING SUM(sale_amount) > (
        SELECT AVG(total_sales)
        FROM (
            SELECT product_id, SUM(sale_amount) AS total_sales
            FROM sales
            GROUP BY product_id
        ) AS subquery
    )
);


-- Can you provide the same list of products, but include the sales amount column with the data
SELECT p.product_id, p.product_name, s.total_sales
FROM products p
JOIN (
    SELECT product_id, SUM(sale_amount) AS total_sales
    FROM sales
    GROUP BY product_id
    HAVING SUM(sale_amount) > (
        SELECT AVG(total_sales)
        FROM (
            SELECT product_id, SUM(sale_amount) AS total_sales
            FROM sales
            GROUP BY product_id
        ) AS subquery
    )
) s ON p.product_id = s.product_id;


-- Can you include the average sales data along with the current data for these products?
WITH AvgSales AS (
    SELECT AVG(total_sales) AS avg_sales
    FROM (
        SELECT product_id, SUM(sale_amount) AS total_sales
        FROM sales
        GROUP BY product_id
    ) AS subquery
)
SELECT p.product_id, p.product_name, s.total_sales, a.avg_sales
FROM products p
JOIN (
    SELECT product_id, SUM(sale_amount) AS total_sales
    FROM sales
    GROUP BY product_id
    HAVING SUM(sale_amount) > (SELECT avg_sales FROM AvgSales)
) s ON p.product_id = s.product_id
CROSS JOIN AvgSales a;
-- This query provides a comprehensive comparison of product performance


-- Find employees who have made sales above the average sales amount for their branch
SELECT branch_id, e.employee_id, e.employee_name
FROM employees e
WHERE EXISTS (
    SELECT 1
    FROM sales s
    WHERE e.employee_id = s.employee_id
    AND s.sale_amount > (
        SELECT AVG(sale_amount)
        FROM sales s2
        WHERE s2.branch_id = e.branch_id
    )
);


			--- COMMON TABLE EXPRESSIONS ---


--Create a CTE to list employees with the highest salaries
WITH HighSalaries AS (
    SELECT TOP 10 employee_id, employee_name, salary
    FROM employees
    ORDER BY salary DESC
)
SELECT * FROM HighSalaries;


--Use a CTE to calculate total sales per branch and then query for branches with sales exceeding a $1MILLION
WITH SalesByBranch AS (
    SELECT s.branch_id, b.branch_name, SUM(s.sale_amount) AS total_sales
    FROM sales s
    JOIN branches b ON s.branch_id = b.branch_id
    GROUP BY s.branch_id, b.branch_name
)
SELECT *
FROM SalesByBranch
WHERE total_sales > 1000000;


			--- WINDOW FUNCTIONS ---


--Assign a unique number to each sale record
SELECT sale_id, employee_id, sale_amount, sale_date,
       ROW_NUMBER() OVER (ORDER BY sale_date) AS row_num
FROM sales;
-- This query assigns a unique, sequential number to each sale


--Use LAG() and LEAD() to compare sales amounts over time for each employee.
SELECT employee_id, sale_id, sale_amount, sale_date,
       LAG(sale_amount) OVER (
           PARTITION BY employee_id ORDER BY sale_date
       ) AS previous_sale,
       LEAD(sale_amount) OVER (
           PARTITION BY employee_id ORDER BY sale_date
       ) AS next_sale
FROM sales;


			--- DATA MODIFICATION ---


--Insert new records into employees and sales tables
INSERT INTO employees (employee_id, employee_name, branch_id, department, hire_date, salary)
VALUES ('E218', 'New Employee', 'B101', 'Sales', '2024-09-01', 55000);

INSERT INTO sales (sale_id, employee_id, product_id, sale_amount, sale_date, branch_id)
VALUES (1001, 'E218', 'P101', 15000, '2024-09-01', 'B101');


--We need to remove an employee and their associated sales records.
-- Deleting sales associated with the employee first because of the foreign key constraint
DELETE FROM sales
WHERE employee_id = 'E218';

-- Now deleting it from the employees table
DELETE FROM employees
WHERE employee_id = 'E218';
-- These queries show how to properly delete related records


--Update product prices and employee salaries
UPDATE products
SET price = 17.99
WHERE product_id = 'P103';

UPDATE employees
SET salary = 62000
WHERE employee_id = 'E101';
-- These queries demonstrate how to update existing records


--Can you summarize the total sales per product by branch?
SELECT branch_id,
    SUM(CASE WHEN product_id = 'P101' THEN sale_amount ELSE 0 END) AS copy_paper_sales,
    SUM(CASE WHEN product_id = 'P102' THEN sale_amount ELSE 0 END) AS ink_sales,
    SUM(CASE WHEN product_id = 'P103' THEN sale_amount ELSE 0 END) AS notebook_sales
FROM sales
GROUP BY branch_id;
--This query provides a cross-tabulation of sales by product and branch
         

			--- SCHEMA MODIFICATION ---


--We need to add a new column to track the email address of each employee.
ALTER TABLE employees
ADD email_address VARCHAR(255);

--We no longer need the email_address column in the employees table. Can you remove it?
ALTER TABLE employees
DROP COLUMN email_address;
