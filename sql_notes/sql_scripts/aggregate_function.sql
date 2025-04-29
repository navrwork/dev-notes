-- SQL Queries Involving Aggregate functions

--
-- Find the Minimum, Maximum, Total, Average Salary by Department
--
  SELECT 
    Department, 
    MIN(Salary) AS MinSalary, 
    MAX(Salary) AS MaxSalary, 
    SUM(Salary) AS TotalSalary, 
    AVG(Salary) AS AverageSalary
  FROM Employee
  GROUP BY Department;


--
-- Count Employees in Each Department
--
  SELECT 
    Department, 
    COUNT(EmployeeID) AS EmployeeCount
  FROM Employee
  GROUP BY Department;


--
-- Find Departments with Total Salary Above a Threshold
-- Note that aggregate functions cannot be used in the WHERE clause.
-- 
  SELECT Department, SUM(Salary) AS TotalSalary
  FROM Employee
  GROUP BY Department
  HAVING SUM(Salary) > 100000;

--
-- Find the number of employees from each city in all departments
--
SELECT
  Department, 
  City, 
  COUNT(Id) AS NumberOfEmployees
FROM Employee
GROUP BY Department, City
ORDER BY COUNT(*);

--
-- Find id, salary and department of the employee who earns the maximum per each department
--
	SELECT 
    e.EmployeeID, e.EmployeeName, e.Department, e.Salary
	FROM Employee e
	WHERE e.Salary = (
	    SELECT MAX(Salary)
	    FROM Employee
	    WHERE Department = e.Department
	);
