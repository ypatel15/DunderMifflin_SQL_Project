-- Inserting data into Branch table
INSERT INTO branches(branch_id,branch_name,manager_name) VALUES
('B101','Scranton','Michael Scott'),
('B201','Stamford','Josh Porter');

-- Inserting data into Products table
INSERT INTO Products (product_id, product_name, price) VALUES
('P101', 'Copy Paper (500 Sheets)', 7.99),
('P102', 'Printer Ink Cartridge', 29.99),
('P103', 'Office Notebooks (Pack of 5)', 12.49);

-- Inserting data into Employees table
INSERT INTO Employees (employee_id, employee_name, branch_id, department, hire_date, salary) VALUES
('E101', 'Jim Halpert','B101','Sales', '2005-05-01', 50000.00),
('E102', 'Pam Beesly','B101','Admin', '2005-05-01', 35000.00),
('E103', 'Dwight Schrute','B101','Sales', '2005-05-01', 55000.00),
('E104', 'Michael Scott','B101','Management', '2004-03-01', 60000.00),
('E105', 'Angela Martin','B101','Accounting', '2005-07-01', 47000.00),
('E106', 'Oscar Martinez','B101','Accounting', '2005-09-01', 48000.00),
('E107', 'Kevin Malone','B101','Accounting', '2005-08-01', 46000.00),
('E108', 'Toby Flenderson','B101','HR', '2004-05-01', 45000.00),
('E109', 'Andy Bernard','B201','Sales', '2006-06-01', 48000.00),
('E110', 'Karen Filippelli','B201','Sales', '2006-06-01', 47000.00),
('E111', 'Ryan Howard','B101', 'Admin', '2005-05-01', 42000.00),
('E112', 'Holly Flax','B201', 'HR', '2007-01-01', 49000.00),
('E113', 'Darryl Philbin','B101','Warehouse', '2006-03-01', 36000.00),
('E114', 'Stanley Hudson','B101','Sales', '2005-06-01', 50000.00),
('E115', 'Kelly Kapoor','B101','Customer Service', '2005-07-01', 45000.00),
('E116', 'Creed Bratton','B101','Quality Assurance', '2005-03-01', 47000.00),
('E117','Josh Porter','B101','Management', '2004-02-01',57000.00); 

-- Inserting data into Sales table
INSERT INTO Sales (sale_id, employee_id,product_id, sale_amount, sale_date, branch_id) VALUES
('S101','E101','P101', 39950.23, '2007-01-05','B101'),
('S102','E103','P102', 30899.70,  '2007-02-10','B101'),
('S103','E109','P103', 24980.25, '2007-03-15','B201'),
('S104','E101','P101', 47940.75, '2007-04-20','B101'),
('S105','E103','P102', 119960.40,'2007-05-25','B101'),
('S106','E109','P103', 31225.23, '2007-06-30','B201'),
('S107','E101','P101',55930.10, '2007-07-05','B101'),
('S108','E109','P103', 149950.45, '2007-08-10','B201'),
('S109','E103','P101', 18735.31,  '2007-09-15','B101'),
('S110','E101','P102', 63920.42,'2007-10-20','B101'),
('S111','E110','P102', 104965.67,'2007-11-25','B201'),
('S112','E101','P103', 37470.64 , '2007-12-30','B101'),
('S113','E110','P102', 71910.11,'2008-01-10','B201'),
('S114','E101','P101', 164945.77,'2008-02-15','B101'),
('S115','E109','P102', 24980.00,'2008-03-20','B201'),
('S116','E110','P103', 87990.35,'2008-04-25','B201'),
('S117','E103','P102', 209930.75,'2008-05-30','B101'),
('S118','E110','P101', 31225.00,'2008-06-10','B201'),
('S119','E103','P103', 111860.85,'2008-07-15','B101'),
('S120','E101','P102', 194935.25, '2008-08-20','B101'),
('S121','E114','P101', 79900.71,'2008-09-25','B101'),
('S122','E110','P102', 134955.55, '2008-10-30','B201'),
('S123','E101','P101', 37470.66, '2008-11-05','B101'),
('S124','E103','P101', 95880.33,'2008-12-10','B101'),
('S125','E101','P101', 179940.60,'2008-12-15','B101');
