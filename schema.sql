create table `charging` (
	`battery start` int,
	`battery end` int,
	`charge start` datetime,
	`charge end` datetime,
	`timezone` Varchar(10),
	`rn1` int,
	`rn2` int
)
ENGINE = InnoDB
DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ;

create table `data_staging` (
	`state` Varchar(5),
	`battery` int,
	`date` datetime,
	`timezone` Varchar(10),
	`rn` int,
	primary key (`rn`)
)
ENGINE = InnoDB
DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ;


