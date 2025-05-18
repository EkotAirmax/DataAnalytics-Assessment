use adashi_staging;

WITH plan_inflows AS (
SELECT
savings_savingsaccount.plan_id,
MAX(savings_savingsaccount.transaction_date) AS last_transaction_date
FROM savings_savingsaccount
WHERE
savings_savingsaccount.confirmed_amount > 0
AND savings_savingsaccount.transaction_status = 'success'
AND savings_savingsaccount.plan_id IS NOT NULL
GROUP BY savings_savingsaccount.plan_id
),

active_plans AS (
SELECT
plans_plan.id AS plan_id,
plans_plan.own_id AS owner_id,
plans_plan.is_regular_savings,
plans_plan.is_a_fund
FROM plans_plan
WHERE
plans_plan.is_deleted = 0
AND plans_plan.is_archived = 0
AND (plans_plan.is_regular_savings = 1 OR plans_plan.is_a_fund = 1)
)

SELECT
active_plans.plan_id,
active_plans.owner_id,
CASE
WHEN active_plans.is_regular_savings = 1 THEN 'savings'
WHEN active_plans.is_a_fund = 1 THEN 'investment'
ELSE 'unknown'
END AS type,
plan_inflows.last_transaction_date,
DATEDIFF(CURRENT_DATE, plan_inflows.last_transaction_date) AS inactivity_days
FROM active_plans
LEFT JOIN plan_inflows ON active_plans.plan_id = plan_inflows.plan_id
WHERE
plan_inflows.last_transaction_date IS NULL
OR plan_inflows.last_transaction_date < (CURRENT_DATE - INTERVAL 365 DAY)
ORDER BY inactivity_days DESC;