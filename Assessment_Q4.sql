use adashi_staging;

SELECT 
    users_customuser.id AS customer_id,
    CONCAT(users_customuser.first_name, ' ', users_customuser.last_name) AS name,
    TIMESTAMPDIFF(MONTH, users_customuser.date_joined, CURDATE()) AS tenure_months,
    IFNULL(SUM(savings_savingsaccount.confirmed_amount), 0) / 100 AS total_transactions,
    ROUND(
        (
            (IFNULL(SUM(savings_savingsaccount.confirmed_amount), 0) / 100)
            / NULLIF(TIMESTAMPDIFF(MONTH, users_customuser.date_joined, CURDATE()), 0)
        ) * 12 * 0.001,
        2
    ) AS estimated_clv
FROM 
    users_customuser
LEFT JOIN 
    savings_savingsaccount ON users_customuser.id = savings_savingsaccount.owner_id
GROUP BY 
    users_customuser.id, users_customuser.first_name, users_customuser.last_name, users_customuser.date_joined
ORDER BY 
    estimated_clv DESC;