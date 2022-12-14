-- the following query is based on census data 2011 which is in the form of two tables that are available in the 'data' folder





-- displaying the two tables
SELECT * FROM project..data1;
SELECT * FROM project..data2;


-- 1. number of rows in both the datasets
SELECT COUNT(*)
FROM project..data1;

SELECT COUNT(*)
FROM project..data2;



-- 2. dataset for jharkhand and bihar

SELECT *
FROM project..data1
WHERE project..data1.State IN ('Jharkhand', 'Bihar')
ORDER BY project..data1.State;

SELECT *
FROM project..data2
WHERE project..data2.State IN ('Jharkhand', 'Bihar')
ORDER BY project..data2.State;



-- 3. calculate total population of India
SELECT SUM(project..data2.Population)
FROM project..data2;



-- 4. average growth rate 
SELECT AVG(growth)*100 AS avg_growth
FROM project..data1;



-- 5. average sex ratio state-wise in descending order
SELECT state, CEILING(AVG(sex_ratio)) avg_sex_ratio
FROM project..data1 
GROUP BY state
ORDER BY avg_sex_ratio DESC;



-- 6. states which have average literacy rate above 85%
SELECT state, ROUND(AVG(literacy),2) literacy_rate
FROM project..data1
GROUP BY state HAVING ROUND(AVG(literacy),2) > 85
ORDER BY literacy_rate DESC;



-- 7. bottom three states showing lowest sex ratio

-- 1st method - normal commands
SELECT TOP 3 state, ROUND(AVG(Sex_Ratio),2) AS Avg_Sex_ratio
FROM project..data1
GROUP BY state
ORDER BY Avg_Sex_ratio;

-- 2nd method - using temporary table
DROP TABLE IF EXISTS sex_ratio_table;
CREATE TABLE sex_ratio_table(
	state NVARCHAR(255) PRIMARY KEY,
	sex_ratio FLOAT
);
INSERT INTO sex_ratio_table SELECT state, ROUND(AVG(sex_ratio),1) FROM project..data1
GROUP BY state;
SELECT TOP 3 * FROM sex_ratio_table ORDER BY sex_ratio_table.sex_ratio ASC;



-- 8. Top and bottom 3 states in literacy rate
-- Using temporary tables

DROP TABLE IF EXISTS top_states;
CREATE TABLE top_states(
	states NVARCHAR(255) PRIMARY KEY,
	literacy_rate FLOAT
);
INSERT INTO top_states SELECT state, ROUND(AVG(Literacy),2) FROM project..data1
GROUP BY state;
SELECT TOP 3 * FROM top_states ORDER BY top_states.literacy_rate DESC;



-- 9. states starting with alphabet 'A'
SELECT DISTINCT state FROM project..data1
WHERE state LIKE 'A%';



-- 10. Find number of males and females (using sex_ratio and total_population)

SELECT a.District, a.State, ROUND(a.Sex_ratio*b.Population/(1000 + a.Sex_ratio),0) females, ROUND(1000*b.Population/(1000 + a.Sex_ratio),0) males FROM
	(project..data1 as a INNER JOIN project..data2 as b ON a.District = b.District);


-- state-wise males and females

SELECT d.State, SUM(d.females) num_females, SUM(d.males) num_males FROM
	(SELECT c.District, c.State, ROUND(c.Sex_ratio*c.Population/(1000 + c.Sex_ratio),0) females, ROUND(1000*c.Population/(1000 + c.Sex_ratio),0) males FROM
		(SELECT a.District, a.State, a.Sex_ratio, b.Population FROM project..data1 as a INNER JOIN project..data2 as b ON a.District = b.District) as c) as d
		GROUP BY d.State;



-- 11. Find state-wise literacy rate
SELECT e.State, ROUND(e.literates*100/e.total_population,2) literacy_rate FROM
	(SELECT d.State, SUM(d.Population) total_population, SUM(d.Literates) literates FROM
		(SELECT c.District, c.State, c.Population, ROUND(c.Literacy*c.Population/100, 0) Literates FROM
			(SELECT a.District, a.State, a.Literacy, b.Population 
				FROM project..data1 as a INNER JOIN project..data2 as b
				ON a.District = b.District) as c) as d
				GROUP BY d.State) as e;



-- 12. Find population in previous census (using growth and population)
SELECT c.District, c.State, c.Population, ROUND(c.Population/(1+c.Growth),0) previous_population FROM
	(SELECT a.District, a.State, a.Growth, b.Population 
	FROM project..data1 as a INNER JOIN project..data2 as b
	ON a.District = b.District) as c;
