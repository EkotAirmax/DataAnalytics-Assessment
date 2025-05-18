# DataAnalytics-Assessment

BEFORE ATTEMPTING THE QUESTIONS IN THIS ASSESSMENT, HERE ARE A FEW THINGS I DID TO HELP ME BETTER UNDERSTAND THE DATABASE 'adashi_staging':
1. Checked each table to see how the list of columns relate with each other.
2. Checked for already established connection between the table (if any).
3. Created foreign keys using the 'hint' provided as a guide.
4. Altered the tables by renaming specific columns to allow for a more presentable output after attempting each question in the assessment.


QUESTION 1: HIGH-VALUE CUSTOMERS WITH MULTIPLE PRODUCTS 

To find customers who have both a funded savings plan and a funded investment plan:
1. Use savings_savingsaccount to find confirmed deposits.
2. Join with plans_plan to check if the plan is a savings (is_regular_savings = 1) or investment (is_a_fund = 1).
3. Join with users_customuser to get customer info.
4. Group by user and plan type, then filter for users who have at least one of each (savings and investment).
5. Sum their deposits and sort by total deposits (in Naira).

This approach allows the business to quickly identify customers with both savings and an
investment plans.


QUESTION 2: TRANSACTION FREQUENCY ANALYSIS

The following was done to segment customers based on how often they performed monthly transactions using transaction data:
1. Count each customer's transactions per month.
2. Calculate their average monthly transactions.
3. Categorize them as:
  *High Frequency* (≥10)
  *Medium Frequency* (3–9)
  *Low Frequency* (≤2)
4. Include all users, even those with no transactions.
5. Group results to show the number of customers and average transactions per category.

Running the query resulted in a summary showing how active different customer groups are, thereby helping the finance team with segmentation.

QUESTION 3: ACCOUNT INACTIVITY ALERT

The following was done to identify inactive accounts:
1. Selected all active savings and investment plans.
2. Found the latest successful inflow (deposit) date for each plan.
3. Joined the two to match each plan with its last inflow.
4. Filtered for plans with no inflow in over 1 year (or no inflow at all).

The resulting query gives a list of plans that have been inactive for over 1 year (365 days).



QUESTION 4: CUSTOMER LIFETIME VALUE (CLV) ESTIMATION

The following was considered to estimate how valuable each customer is over time, based on how long they’ve had an account and how much they’ve deposited (i.e. total transaction volume):
1. Calculated account tenure in months from `date_joined` to today.
2. Sumed total transactions of `confirmed_amount` from deposits, converted from kobo to naira.
3. The below CLV Formula was used in calculation:

          CLV = (total_transactions / tenure_months) * 12 * 0.001

   The CLV formula assumes a 0.1% profit per transaction and annualizes the average monthly transaction value. It results in an estimated CLV sorted from highest to lowest.


CHALLENGES

1. Identifying the exact column(s) that was required to address each question.
2. Writing each queries and subqueries
3. Time constraint to complete the task.
