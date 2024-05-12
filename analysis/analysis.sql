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
select DATE_FORMAT(`charge end`, '%Y-%m') as month,
	avg(`battery end` - `battery start`) as `battery down`,
	avg(timestampdiff(second, `charge end`, `charge start`)) as `down time`
from cte 
GROUP BY 1
ORDER BY month ;
	

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
select CONCAT(DATE_FORMAT(`charge end`, '%Y-%m'), ' ', WEEK(`charge end`)) as week,
	avg(`battery end` - `battery start`) as `battery down`,
	avg(timestampdiff(second, `charge end`, `charge start`)) as `down time`
from cte 
GROUP BY 1
ORDER BY WEEK ;


-- Month wise charge behaviour
with cte as (
	select DATE_FORMAT(`charge end`, '%Y-%m') as month,
		avg(`battery end` - `battery start`) as `battery charged`,
		avg(timestampdiff(second, `charge start`, `charge end`)) as `time taken`
	from charging
	group by 1
)
select *
from cte 
ORDER BY month ;

-- Week wise charge behaviour
with cte as (
	select CONCAT(DATE_FORMAT(`charge end`, '%Y-%m'), ' ', WEEK(`charge end`)) as week, 
		avg(`battery end` - `battery start`) as `battery charged`,
		avg(timestampdiff(second, `charge start`, `charge end`)) as `time taken`
	from charging
	group by 1
)
select *
from cte 
ORDER BY week ;
