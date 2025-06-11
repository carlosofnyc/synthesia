WITH stg_churn AS (

    SELECT
        customer_id,
        age,
        gender,
        tenure,
        total_spend,
        payment_delay,
        support_calls,
        contract_length,
        usage_frequency,
        last_interaction,
        subscription_type,
        churn_status
    FROM {{ ref('stg_customer_churn') }}
)
SELECT
    customer_id,
    age,
    gender,
    tenure,
    total_spend,
    payment_delay,
    support_calls,
    contract_length,
    usage_frequency,
    last_interaction,
    subscription_type,
    CASE
        WHEN tenure < 12 THEN 'New Customer (0-11 months)'
        WHEN tenure BETWEEN 12 AND 36 THEN 'Mid-Term Customer (1-3 years)'
        ELSE 'Long-Term Customer (3+ years)'
    END AS customer_tenure_segment,

    CASE
        WHEN churn_status = 1 THEN TRUE
        ELSE FALSE
    END AS has_churned_flag,

    CASE
        WHEN total_spend IS NULL OR TRY_TO_NUMBER(total_spend) <= 0 THEN TRUE
        ELSE FALSE
    END AS is_total_spend_missing_or_zero,
    churn_status as raw_churn_status

FROM stg_churn