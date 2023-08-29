-- Suspicious Bank Accounts --
-- A bank account is suspicious if the total income exceeds the max_income for this account for two or more consecutive months. 
-- The total income of an account in some month is the sum of all its deposits in that month (i.e., transactions of the type 'Creditor').
-- Write an SQL query to report the IDs of all suspicious bank accounts.
-- This problem solved in POstgreSQL

-- Create Accounts table if not exists
CREATE TABLE IF NOT EXISTS Accounts (
    account_id SERIAL PRIMARY KEY,
    max_income INT
);

-- Create Transactions table if not exists
CREATE TABLE IF NOT EXISTS Transactions (
    transaction_id SERIAL PRIMARY KEY,
    account_id INT,
    type VARCHAR(8),
    amount INT,
    day TIMESTAMP
);

-- Truncate tables
TRUNCATE TABLE Accounts;
TRUNCATE TABLE Transactions;

-- Insert data into Accounts table
INSERT INTO Accounts (account_id, max_income) VALUES (3, 21000);
INSERT INTO Accounts (account_id, max_income) VALUES (4, 10400);
INSERT INTO Accounts (account_id, max_income) VALUES (5, 15000);
INSERT INTO Accounts (account_id, max_income) VALUES (6, 8500);

INSERT INTO Transactions (transaction_id, account_id, type, amount, day) VALUES (21,5, 'creditor', 75000, '2022-01-10 09:00:00');
INSERT INTO Transactions (transaction_id, account_id, type, amount, day) VALUES (22,5, 'creditor', 55000, '2022-02-10 08:00:00');
INSERT INTO Transactions (transaction_id, account_id, type, amount, day) VALUES (23,5, 'creditor', 10000, '2022-03-10 07:00:00');
INSERT INTO Transactions (transaction_id, account_id, type, amount, day) VALUES (24,5, 'creditor', 10000, '2022-04-10 06:00:00');
INSERT INTO Transactions (transaction_id, account_id, type, amount, day) VALUES (25,6, 'debtor', 35000, '2022-02-20 14:30:00');
INSERT INTO Transactions (transaction_id, account_id, type, amount, day) VALUES (26,6, 'creditor', 20000, '2022-03-05 16:45:00');
INSERT INTO Transactions (transaction_id, account_id, type, amount, day) VALUES (27,6, 'debtor', 12000, '2022-04-15 11:10:00');
INSERT INTO Transactions (transaction_id, account_id, type, amount, day) VALUES (2, 3, 'creditor', 107100, '2021-06-02 11:38:14');
INSERT INTO Transactions (transaction_id, account_id, type, amount, day) VALUES (4, 4, 'creditor', 10400, '2021-06-20 12:39:18');
INSERT INTO Transactions (transaction_id, account_id, type, amount, day) VALUES (11, 4, 'debtor', 58800, '2021-07-23 12:41:55');
INSERT INTO Transactions (transaction_id, account_id, type, amount, day) VALUES (1, 4, 'creditor', 49300, '2021-05-03 16:11:04');
INSERT INTO Transactions (transaction_id, account_id, type, amount, day) VALUES (15, 3, 'debtor', 75500, '2021-05-23 14:40:20');
INSERT INTO Transactions (transaction_id, account_id, type, amount, day) VALUES (10, 3, 'creditor', 102100, '2021-06-15 10:37:16');
INSERT INTO Transactions (transaction_id, account_id, type, amount, day) VALUES (14, 4, 'creditor', 56300, '2021-07-21 12:12:25');
INSERT INTO Transactions (transaction_id, account_id, type, amount, day) VALUES (19, 4, 'debtor', 101100, '2021-05-09 15:21:49');
INSERT INTO Transactions (transaction_id, account_id, type, amount, day) VALUES (8, 3, 'creditor', 64900, '2021-07-26 15:09:56');
INSERT INTO Transactions (transaction_id, account_id, type, amount, day) VALUES (7, 3, 'creditor', 90900, '2021-06-14 11:23:07');
commit;


select * from Transactions;
select * from Accounts;

--- SQL query to report the IDs of all suspicious bank accounts
select
	r.account_id
from
	(
	select
		s.account_id,
		s.amount,
		s.max_income,
		s.year_month,
		COALESCE(LEAD(s.year_month,1) OVER (PARTITION BY s.account_id ORDER BY s.year_month),s.year_month) as next_year_month
	from
		(
		select 
			t.account_id,
			sum(t.amount) amount,
			a.max_income,
			TO_CHAR(t.day, 'YYYY-MM-01') AS year_month
		from
			Transactions t
			inner join Accounts a on a.account_id = t.account_id
		where
			lower(t.type) = 'creditor'
		group by
			t.account_id,
			a.max_income,
			TO_CHAR(t.day, 'YYYY-MM-01')
		)s
	where 
		s.amount > s.max_income
	)r
where
	EXTRACT(month from r.next_year_month::DATE) - EXTRACT(month from r.year_month::DATE) = 1;









