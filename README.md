# Customer Churn Analysis (Prepping for Synthesia Interview)

In this project, I aim to create an ELT pipeline using dbt-core, Airbye and Snowflake to serve customer churn data I found on Kaggle. My goal is to prepare for my interview with Synthesia hence why I put more focus on dbt since this is a core part of their stack. I also named this whole thang "Synthesia" for that reason.

_If y'all are reading this, I hope it is convincing enough to show my skills_ 😉

## Project Goal

To provide a structured and reliable dataset for business analysts to understand customer behavior and churn patterns, ensuring data quality and usability.

## Technologies Used

*   **Data Source:** .csv from Kaggle stored in an S3 bucket on AWS (`customer_churn.csv`)
*   **Data Ingestion (EL):** Set up connections in Airbyte (to extract from S3 and load into Snowflake)
*   **Data Warehouse:** Snowflake
*   **Data Transformation (T):** dbt Core (for defining, testing, and documenting transformations)

## Data Flow & Architecture

The pipeline follows a layered (medallion) architecture within Snowflake:

1.  **Raw Layer (`SYNTHESIA_DB.RAW`):** Data is extracted from AWS S3 via Airbyte and loaded directly into this schema, preserving its original state (`CUSTOMER_CHURN_RAW` table).
2.  **Staging Layer (`SYNTHESIA_DB.STAGING`):** Raw data is lightly transformed here using dbt (`stg_customer_churn` model). This layer focuses on:
    *   Renaming columns to `snake_case` (e.g., "TOTAL SPEND" to `total_spend`).
    *   Safe type casting (e.g., `TENURE` and `CHURN` from `VARCHAR` to `NUMBER` using `TRY_TO_NUMBER`).
    *   Excluding Airbyte metadata columns so the analysts can focus on the actual data.
3.  **Analytics Mart Layer (`SYNTHESIA_DB.ANALYTICS`):** This is the final consumption layer built by dbt (`mart_customer_churn` model). It provides business-friendly data by:
    *   Deriving new metrics (e.g., `customer_tenure_segment`).
    *   Creating clear flags (e.g., `has_churned_flag`, `is_total_spend_missing_or_zero`).
    *   Ensuring data is ready for direct analysis.

## dbt Project Overview

*   **`dbt_project.yml`:** Configures project settings, profiles, and defines schema layering for models (staging models as views, analytics models as tables).
*   **`models/sources.yml`:** Defines the raw `CUSTOMER_CHURN_RAW` table as a dbt source, enabling lineage tracking.
*   **`models/staging/stg_customer_churn.sql`:** The staging model for initial data cleaning and standardization.
*   **`models/analytics/mart_customer_churn.sql`:** The final analytics mart model for business consumption, implementing derived metrics and flags.
*   **`models/schema.yml`:** Contains column descriptions and data quality tests (unique, not-null, accepted values, range checks) for both staging and mart models.
*   **`packages.yml`:** Specifies external dbt packages used for advanced testing (`dbt_utils`, `dbt_expectations`).

## Getting Started

1.  **Prerequisites:**
    *   Docker Desktop (for Airbyte)
    *   Snowflake account (with `SYNTHESIA_WH`, `SYNTHESIA_DB`, `RAW`, `STAGING`, `ANALYTICS` schemas configured. Included `snowflake_config.sql` file for reference)
    *   AWS S3 bucket with `customer_churn.csv` and an IAM user with `AmazonS3ReadOnlyAccess`.
    *   Python 3.13.3 or later (I'm using 3.13.3)

2.  **Clone the project:**
    ```bash
    git clone https://github.com/carlosofnyc/synthesia.git

    cd synthesia/synthesia_dbt
    ```
    *Note: The actual dbt project is in the `synthesia_dbt` subfolder.*

3.  **Set up Python & install dbt-core:**
    ```bash
    python3 -m venv venv
    source venv/bin/activate
    pip3 install dbt-core dbt-snowflake
    ```

4.  **Install dbt Packages:**
    ```bash
    dbt deps
    ```

## Running the Project

virtual environment is active (`source venv/bin/activate`) and we're on the `synthesia_dbt` directory

1.  **Build Models:**
    ```bash
    dbt run
    ```
    (This will create `stg_customer_churn` and `mart_customer_churn` in Snowflake)

2.  **Run Data Quality Tests:**
    ```bash
    dbt test
    ```

3.  **Generate & Serve Documentation:**
    ```bash
    dbt docs generate
    dbt docs serve # Opens in your browser at http://localhost:8080
    ```