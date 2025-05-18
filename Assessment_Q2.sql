use adashi_staging;

WITH monthly_transactions AS (
    SELECT
        savings_savingsaccount.owner_id,
        DATE_FORMAT(savings_savingsaccount.transaction_date, '%Y-%m-01') AS txn_month,
        COUNT(*) AS txn_count
    FROM
        savings_savingsaccount
    WHERE
        savings_savingsaccount.transaction_date IS NOT NULL
        AND savings_savingsaccount.confirmed_amount IS NOT NULL
    GROUP BY
        savings_savingsaccount.owner_id,
        DATE_FORMAT(savings_savingsaccount.transaction_date, '%Y-%m-01')
),

avg_txn_per_customer AS (
    SELECT
        monthly_transactions.owner_id,
        ROUND(AVG(monthly_transactions.txn_count), 2) AS avg_txn_per_month
    FROM
        monthly_transactions
    GROUP BY
        monthly_transactions.owner_id
),

categorized_customers AS (
    SELECT
        users_customuser.id AS user_id,
        IFNULL(avg_txn_per_customer.avg_txn_per_month, 0) AS avg_txn_per_month,
        CASE
            WHEN IFNULL(avg_txn_per_customer.avg_txn_per_month, 0) >= 10 THEN 'High Frequency'
            WHEN IFNULL(avg_txn_per_customer.avg_txn_per_month, 0) BETWEEN 3 AND 9 THEN 'Medium Frequency'
			ELSE 'Low Frequency'
        END AS frequency_category
    FROM
        users_customuser
    LEFT JOIN
        avg_txn_per_customer
        ON users_customuser.id = avg_txn_per_customer.owner_id
)

SELECT
    categorized_customers.frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(categorized_customers.avg_txn_per_month), 2) AS avg_transactions_per_month
FROM
    categorized_customers
GROUP BY
    categorized_customers.frequency_category
ORDER BY
    FIELD(categorized_customers.frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');