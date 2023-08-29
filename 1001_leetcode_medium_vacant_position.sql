-- Vacant Position --

drop table if exists job_positions;
create table job_positions
(
	id			int,
	title 		varchar(100),
	groups 		varchar(10),
	levels		varchar(10),
	payscale	int,
	totalpost	int
);
insert into job_positions values (1, 'General manager', 'A', 'l-15', 10000, 1);
insert into job_positions values (2, 'Manager', 'B', 'l-14', 9000, 5);
insert into job_positions values (3, 'Asst. Manager', 'C', 'l-13', 8000, 10);

drop table if exists job_employees;
create table job_employees
(
	id				int,
	name 			varchar(100),
	position_id 	int
);
insert into job_employees values (1, 'John Smith', 1);
insert into job_employees values (2, 'Jane Doe', 2);
insert into job_employees values (3, 'Michael Brown', 2);
insert into job_employees values (4, 'Emily Johnson', 2);
insert into job_employees values (5, 'William Lee', 3);
insert into job_employees values (6, 'Jessica Clark', 3);
insert into job_employees values (7, 'Christopher Harris', 3);
insert into job_employees values (8, 'Olivia Wilson', 3);
insert into job_employees values (9, 'Daniel Martinez', 3);
insert into job_employees values (10, 'Sophia Miller', 3);

select * from job_positions;
select * from job_employees;

--- Solution ---

WITH RECURSIVE CTE_JOB_POSITIONS AS
	(
	SELECT 
		JP.ID,
		JP.TITLE,
		JP.GROUPS,
		JP.LEVELS,
		JP.PAYSCALE,
		JP.TOTALPOST
	FROM
		JOB_POSITIONS JP
	UNION ALL
	
	SELECT
		ID,
		TITLE,
		GROUPS,
		LEVELS,
		PAYSCALE,
		TOTALPOST - 1 AS TOTALPOST
	FROM
		CTE_JOB_POSITIONS
	WHERE
		TOTALPOST > 1
	),
	CTE_JOB_EMPLOYEES AS
	(
	SELECT
		ROW_NUMBER() OVER(PARTITION BY JE.POSITION_ID ORDER BY JE.ID) AS RN,
		JE.ID,
		JE.NAME,
		JE.POSITION_ID
	FROM
		JOB_EMPLOYEES JE
	)
SELECT
	TITLE,
	GROUPS,
	LEVELS,
	PAYSCALE,
	COALESCE(NAME,'Vacant') as NAME
FROM
	CTE_JOB_POSITIONS CJP
	LEFT JOIN CTE_JOB_EMPLOYEES CJE ON CJE.RN = CJP.TOTALPOST AND CJE.POSITION_ID = CJP.ID
ORDER BY
	GROUPS;	
	
	
