use battery ;

update charging set `battery start` = `battery end` - (`battery start` - `battery end`) where `battery start` > `battery end` ;

with cte as (
select *, 
	`battery end` - `battery start` as `battery increase`, 
	timestampdiff(second,`charge start`, `charge end`) as `charge time in seconds`,
	timestampdiff(second,`charge start`, `charge end`)/(`battery end` - `battery start`) as `average time` 
from charging 
where `charge start` is not null 
	and `charge end` is not null 
	and `charge start` <> `charge end` 
	and `battery start` <> `battery end`
)
select sum(`charge time in seconds`) / sum(`battery increase`) into @avg from cte;

update charging
set `charge start` = date_sub(`charge end`, interval (`battery end`-`battery start`)*@avg second)
where `charge start` is null and `charge end` is not null ;

update charging
set `charge end` = date_add(`charge start`, interval (`battery end`-`battery start`)*@avg second)
where `charge end` is null and `charge start` is not null ;

update charging
set timezone = 'IST'
where timezone is null ;

select *
INTO OUTFILE '/var/lib/mysql-files/final.csv'
  FIELDS TERMINATED BY ',' 
  OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
from charging ;


