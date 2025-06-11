WITH source_data AS (
    SELECT *
    FROM {{ source('raw_data', 'CUSTOMER_CHURN_RAW') }} -- reference to the sources.yml fils
)
SELECT
    CUSTOMERID AS customer_id,
    AGE AS age,
    GENDER AS gender,
    TRY_TO_NUMBER(TENURE) AS tenure,
    "TOTAL SPEND" AS total_spend,
    "PAYMENT DELAY" AS payment_delay,
    "SUPPORT CALLS" AS support_calls,
    "CONTRACT LENGTH" AS contract_length,
    "USAGE FREQUENCY" AS usage_frequency,
    "LAST INTERACTION" AS last_interaction,
    "SUBSCRIPTION TYPE" AS subscription_type,
    TRY_TO_NUMBER(CHURN) AS churn_status,
    _AIRBYTE_RAW_ID AS airbyte_raw_id,
    _AIRBYTE_EXTRACTED_AT AS airbyte_extracted_at,
    _AIRBYTE_META AS airbyte_meta,
    _AIRBYTE_GENERATION_ID AS airbyte_generation_id
FROM source_data