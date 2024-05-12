use battery ;

truncate table data_staging ;

set global local_infile = 1 ;

LOAD DATA LOCAL INFILE 'charging.csv'
  INTO TABLE data_staging
  FIELDS TERMINATED BY ',' ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  IGNORE 1 LINES 
  (@state,@date,@timezone,@battery,@rn)
  set state = @state,
  	battery = @battery,
  	date = @date,
  	timezone = @timezone,
  	rn = @rn ;

delete from data_staging where state='';

update data_staging set battery=null, date=null,timezone=null
where battery=0 or timezone='' ;

with cte as (
	select state,
		date,
		round(avg(battery) over(partition by state order by rn rows between unbounded preceding and current row),0) as battery,
		timezone,
		rn
	from data_staging
)
update data_staging d
	join cte c
		on d.rn=c.rn
		and d.battery is null
	set d.battery = c.battery ;
	
	
truncate table charging ;

insert into charging (`battery start`, `battery end`, `charge start`, `charge end`, timezone, rn1, rn2) 
select a.battery as `battery start`,
	b.battery as `battery end`,
	a.date as `charge start`,
	b.date as `charge end`,
	a.timezone,
	a.rn as `rn1`,
	b.rn as `rn2`
from data_staging a 
	join data_staging b 
		on a.rn+1 = b.rn 
			and b.rn%2=0 ;
