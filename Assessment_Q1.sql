use adashi_staging;

SELECT 
    users_customuser.id AS user_id,
concat(
			users_customuser.first_name, ' ',
			users_customuser.last_name
			) AS Name,
    COUNT(CASE WHEN plans_plan.is_regular_savings = 1 THEN 1 END) AS savings_count,
    COUNT(CASE WHEN plans_plan.is_a_fund = 1 THEN 1 END) AS investment_count,
    ROUND(SUM(savings_savingsaccount.confirmed_amount) / 100 , 2) AS total_deposits
FROM users_customuser
JOIN savings_savingsaccount
    ON savings_savingsaccount.owner_id = users_customuser.id
JOIN plans_plan
    ON savings_savingsaccount.plan_id = plans_plan.id
WHERE savings_savingsaccount.confirmed_amount > 0
  AND (plans_plan.is_regular_savings = 1 OR plans_plan.is_a_fund = 1)
GROUP BY user_id, Name
HAVING savings_count > 0 AND investment_count > 0
ORDER BY total_deposits DESC;