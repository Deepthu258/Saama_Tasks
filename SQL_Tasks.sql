Task1:
--1) Cities frequently visited?
SELECT CITY_NAME 
FROM (SELECT A.City_id_visited, NVL(B.CITY_NAME,'UNKNOWN') AS CITY_NAME 
      FROM VISITS A LEFT JOIN CITY B 
	  ON (A.City_id_visited=B.City_id) 
	  GROUP BY City_id_visited,CITY_NAME 
	  HAVING count(*)>${Minimum Number of Visits});

--2) Customers visited more than 1 city?
SELECT Customer_name 
FROM (SELECT A.Customer_name,B.City_id_visited 
      FROM CUSTOMER A JOIN VISITS B 
	  ON (A.Customer_id=B.Customer_id)) 
	  GROUP BY Customer_name 
	  HAVING count(*)>1;
	  
--3) Cities visited breakdown by gender?
SELECT A.Gender,COUNT(*) Number_of_Cities_Visited
FROM CUSTOMER A JOIN VISITS B 
ON (A.Customer_id=B.Customer_id)) 
GROUP BY A.Gender;
	  
--4) List the city names that are not visited by every customer and order them by the expense budget in ascending order?
SELECT City_name 
FROM CITY 
WHERE City_id in (SELECT City_id_visited 
                  FROM (SELECT DISTINCT Customer_id,City_id_visited FROM VISITS) 
				  GROUP by City_id_visited 
				  having count(*)!=(SELECT COUNT(DISTINCT Customer_id) FROM CUSTOMER)
ORDER BY Expense;

--5) Visit/travel Percentage for every customer?
SELECT A.Customer_name,
100*ratio_to_report(count(B.City_id_visited)) over (partition by A.Customer_name) AS percentage
FROM CUSTOMER A LEFT JOIN VISITS B 
ON (A.Customer_id=B.Customer_id));

--6) Total expense incurred by customers on their visits?
SELECT A.Customer_name,SUM(C.Expense) 
FROM CUSTOMER A 
LEFT JOIN VISITS B ON (A.Customer_id=B.Customer_id)
LEFT JOIN CITY C ON (B.City_id_visited=C.City_id)
GROUP BY A.Customer_name;


--7) list the Customer details along with the city they first visited and the date of visit?

SELECT * FROM
(SELECT A.*,C.City_name,
 RANK() over (Partition By A.Customer_name,B.City_id_visited ORDER BY B.Date_visited) RNK
 FROM CUSTOMER A 
 LEFT JOIN VISITS B ON (A.Customer_id=B.Customer_id)
 LEFT JOIN CITY C ON (B.City_id_visited=C.City_id))
WHERE RNK=1;