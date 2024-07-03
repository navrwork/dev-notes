# SQL Notes

## Reference
* [SQL Aggregate Functions | learnsql.com](https://learnsql.com/blog/aggregate-functions/)

## SQL Aggregate Functions
* Some commonly used aggregate functions: SUM(), COUNT(), AVG(), MIN(), MAX()
* Note that aggregate functions cannot be used in the WHERE clause.
* Aggregate functions act on data that has been grouped using the GROUP BY clause, whereas the WHERE clause filters individual rows before they are grouped.
* COUNT(*) counts all rows in a group, whereas COUNT(expression) counts only the non-NULL values of the supplied expression within a group.


## GROUP BY Clause
* The SQL GROUP BY clause separates your dataset into groups based on matching values in one or more columns; this allows you to apply aggregate functions to each group independently. 
* Syntax: 
  * SELECT
      column1,
      column2,
      aggregate_function(column3)
      FROM table_name
      GROUP BY column1, column2;
  * SELECT
	city,
	AVG(salary) as average_salary
	FROM employee_data
	GROUP BY city;

## HAVING Clause
* In SQL queries containing aggregate functions, the HAVING clause is used to filter results based on the aggregate function result. It enables you to apply conditions to groupings of data after they have been aggregated.
* Example: 
  * SELECT
	product_category,
	SUM(sales_amount) as total_sales
	FROM sales_data
	GROUP BY product_category
	HAVING SUM(sales_amount) > 10000;
  * SELECT
	department,
	AVG(salary) as average_salary
	FROM employee_data
	GROUP BY department
	HAVING AVG(salary) >= 50000;