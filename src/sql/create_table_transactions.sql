DROP TABLE IF EXISTS STV2023100639__STAGING.transactions CASCADE;
DROP PROJECTION IF EXISTS STV2023100639__STAGING.transactions_proj1 CASCADE;

CREATE TABLE STV2023100639__STAGING.transactions(
    operation_id 					uuid NOT NULL,
    account_number_from 			int not null,
    account_number_to 				int not null,
    currency_code 					int not null,
    country 						varchar(2000) not null,
    status 							varchar (500) not null,
    transaction_type 				varchar (500) not null,
    amount 							int not null, 
    transaction_dt 					timestamp, 
    CONSTRAINT C_PRIMARY PRIMARY KEY (operation_id, status, transaction_dt)  DISABLED) 
ORDER BY operation_id
SEGMENTED BY HASH(operation_id,transaction_dt) ALL NODES
PARTITION BY transaction_dt::DATE;
 
    
CREATE PROJECTION STV2023100639__STAGING.transactions_proj1 (
 operation_id,
 account_number_from,
 account_number_to,
 currency_code,
 country,
 status,
 transaction_type,
 amount,
 transaction_dt)
AS
 SELECT transactions.operation_id,
 		transactions.account_number_from,
        transactions.account_number_to,
        transactions.currency_code,
        transactions.country,
        transactions.status,
        transactions.transaction_type,
        transactions.amount,
        transactions.transaction_dt
   FROM STV2023100639__STAGING.transactions
  ORDER BY transactions.transaction_dt
SEGMENTED BY hash( transactions.transaction_dt) ALL NODES KSAFE 1;