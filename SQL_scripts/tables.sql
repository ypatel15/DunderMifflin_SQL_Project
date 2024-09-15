-- Creating tables

-- Branch Table
CREATE TABLE branches (
	branch_id VARCHAR(06) PRIMARY KEY NOT NULL,
	branch_name VARCHAR(100) UNIQUE,
	manager_name VARCHAR(100) NOT NULL
	);

-- Product Table
CREATE TABLE products (
	product_id  VARCHAR(06) PRIMARY KEY,
	product_name VARCHAR(100) NOT NULL,
	price float NOT NULL
	);

-- Employees Table
CREATE TABLE employees (
    employee_id VARCHAR(06) PRIMARY KEY NOT NULL,
    employee_name VARCHAR(100) NOT NULL,
    branch_id VARCHAR(06) NOT NULL,
    department VARCHAR(100) NOT NULL,
    hire_date DATE NOT NULL,
    salary DECIMAL(15, 2) NOT NULL,
    CONSTRAINT fke_branch FOREIGN KEY (branch_id)
    REFERENCES branches(branch_id)
	);

-- Sales Table
CREATE TABLE sales (
    sale_id VARCHAR(06) PRIMARY KEY NOT NULL,
    employee_id VARCHAR(06) NOT NULL,
    product_id VARCHAR(06) NOT NULL,
    sale_amount DECIMAL(15, 2) NOT NULL,
    sale_date DATE NOT NULL,
    branch_id VARCHAR(06) NOT NULL,
    CONSTRAINT fks_employee FOREIGN KEY (employee_id)
    REFERENCES employees(employee_id) ,
    CONSTRAINT fks_product FOREIGN KEY (product_id)
    REFERENCES products(product_id),
    CONSTRAINT fks_branch FOREIGN KEY (branch_id)
    REFERENCES branches(branch_id)
	);
