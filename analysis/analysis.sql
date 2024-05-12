-- SQL Query Language


-- Month wise discharge behaviour
with cte as (
	select a.`battery end`,
		b.`battery start`,
		a.`charge end`,
		b.`charge start`
	from charging a 
		join charging b 
			on a.rn1 +3 = b.rn2
)
select YEAR(`charge end`) as YEAR,
	MONTHNAME(`charge end`) AS MONTH,
	avg(`battery end` - `battery start`) as `battery down`,
	TIME_FORMAT(SEC_TO_TIME(avg(timestampdiff(second, `charge end`, `charge start`))), '%Hh:%im:%ss') as `down time`
from cte 
GROUP BY 1, 2 
ORDER BY YEAR DESC,
	CASE WHEN MONTH='January' then 1
		WHEN MONTH='February' then 2
		WHEN MONTH='March' then 3
		WHEN MONTH='April' then 4
		WHEN MONTH='May' then 5
		WHEN MONTH='June' then 6
		WHEN MONTH='July' then 7
		WHEN MONTH='August' then 8
		WHEN MONTH='September' then 9
		WHEN MONTH='October' then 10
		WHEN MONTH='November' then 11
		WHEN MONTH='December' then 12
	ELSE 13 END ;
	

-- Week wise discharge behaviour
with cte as (
	select a.`battery end`,
		b.`battery start`,
		a.`charge end`,
		b.`charge start`
	from charging a 
		join charging b 
			on a.rn1 +3 = b.rn2
)
select YEAR(`charge end`) as YEAR,
	MONTHNAME(`charge end`) AS MONTH,
	WEEK(`charge end`) as WEEK,
	avg(`battery end` - `battery start`) as `battery down`,
	TIME_FORMAT(SEC_TO_TIME(avg(timestampdiff(second, `charge end`, `charge start`))), '%Hh:%im:%ss') as `down time`
from cte 
GROUP BY 1, 2, 3 
ORDER BY YEAR DESC,
	CASE WHEN MONTH='January' then 1
		WHEN MONTH='February' then 2
		WHEN MONTH='March' then 3
		WHEN MONTH='April' then 4
		WHEN MONTH='May' then 5
		WHEN MONTH='June' then 6
		WHEN MONTH='July' then 7
		WHEN MONTH='August' then 8
		WHEN MONTH='September' then 9
		WHEN MONTH='October' then 10
		WHEN MONTH='November' then 11
		WHEN MONTH='December' then 12
	ELSE 13 END,
		WEEK desc ;