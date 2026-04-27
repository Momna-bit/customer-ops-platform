-- ============================================================================
-- CUSTOMER OPS PLATFORM - EXTERNAL STAGES & DATA LOADING
-- File: 03_load_external_data.sql
-- Purpose: Configure Azure and AWS stages, load data
-- ============================================================================
 
USE WAREHOUSE CUSTOMER_OPS_WH;
USE SCHEMA CUSTOMER_OPS_DB.RAW;
 
-- ============================================================================
-- SECTION 1: AZURE BLOB STORAGE STAGE
-- ============================================================================
-- Create stage for Azure Blob Storage
-- Replace [YOUR_AZURE_SAS_TOKEN_HERE] with your actual token before running
 
CREATE OR REPLACE STAGE AZURE_BLOB_STAGE
    URL = 'azure://customeropsstore.blob.core.windows.net/raw-data'
    CREDENTIALS = (
        AZURE_SAS_TOKEN = '[YOUR_AZURE_SAS_TOKEN_HERE]'
    )
    FILE_FORMAT = (
        TYPE = CSV
        SKIP_HEADER = 1
        FIELD_OPTIONALLY_ENCLOSED_BY = '"'
        NULL_IF = ('', 'NULL', 'nan')
        DATE_FORMAT = 'YYYY-MM-DD'
    );
 
-- Verify Azure stage connection
LIST @CUSTOMER_OPS_DB.RAW.AZURE_BLOB_STAGE;
 
-- ============================================================================
-- SECTION 2: AWS S3 STAGE
-- ============================================================================
-- Create stage for AWS S3
-- Replace credentials with your actual AWS keys before running
 
CREATE OR REPLACE STAGE AWS_S3_STAGE
    URL = 's3://customer-ops-raw-data/'
    CREDENTIALS = (
        AWS_KEY_ID = '[YOUR_AWS_KEY_ID_HERE]'
        AWS_SECRET_KEY = '[YOUR_AWS_SECRET_KEY_HERE]'
    )
    FILE_FORMAT = (
        TYPE = CSV
        SKIP_HEADER = 1
        FIELD_OPTIONALLY_ENCLOSED_BY = '"'
        NULL_IF = ('', 'NULL', 'nan')
        DATE_FORMAT = 'YYYY-MM-DD'
    );
 
-- Verify AWS S3 stage connection
LIST @CUSTOMER_OPS_DB.RAW.AWS_S3_STAGE;
 
-- ============================================================================
-- SECTION 3: LOAD DATA FROM S3 
-- ============================================================================
 
-- Load Customers data from S3
COPY INTO CUSTOMER_RAW
    FROM @AWS_S3_STAGE/customers_clean.csv
    FILE_FORMAT = (
        TYPE = CSV
        SKIP_HEADER = 1
        FIELD_OPTIONALLY_ENCLOSED_BY = '"'
        NULL_IF = ('', 'NULL', 'nan')
        DATE_FORMAT = 'YYYY-MM-DD'
    )
    ON_ERROR = 'CONTINUE';
 
-- Load Interactions data from S3
COPY INTO INTERACTIONS_RAW
    FROM @AWS_S3_STAGE/interactions_clean.csv
    FILE_FORMAT = (
        TYPE = CSV
        SKIP_HEADER = 1
        FIELD_OPTIONALLY_ENCLOSED_BY = '"'
        NULL_IF = ('', 'NULL', 'nan')
        DATE_FORMAT = 'YYYY-MM-DD'
    )
    ON_ERROR = 'CONTINUE';
 
-- Load Outcomes data from S3
COPY INTO OUTCOMES_RAW
    FROM @AWS_S3_STAGE/outcomes_clean.csv
    FILE_FORMAT = (
        TYPE = CSV
        SKIP_HEADER = 1
        FIELD_OPTIONALLY_ENCLOSED_BY = '"'
        NULL_IF = ('', 'NULL', 'nan')
        DATE_FORMAT = 'YYYY-MM-DD'
    )
    ON_ERROR = 'CONTINUE';
 
-- Load Service Events data from S3
COPY INTO SERVICE_EVENTS_RAW
    FROM @AWS_S3_STAGE/service_events_clean.csv
    FILE_FORMAT = (
        TYPE = CSV
        SKIP_HEADER = 1
        FIELD_OPTIONALLY_ENCLOSED_BY = '"'
        NULL_IF = ('', 'NULL', 'nan')
        DATE_FORMAT = 'YYYY-MM-DD'
    )
    ON_ERROR = 'CONTINUE';
 
-- Load Surveys data from S3
COPY INTO SURVEYS_RAW
    FROM @AWS_S3_STAGE/surveys_clean.csv
    FILE_FORMAT = (
        TYPE = CSV
        SKIP_HEADER = 1
        FIELD_OPTIONALLY_ENCLOSED_BY = '"'
        NULL_IF = ('', 'NULL', 'nan')
        DATE_FORMAT = 'YYYY-MM-DD'
    )
    ON_ERROR = 'CONTINUE';
 
-- ============================================================================
-- SECTION 4: VERIFY DATA LOAD
-- ============================================================================
 
SELECT 'CUSTOMER_RAW' AS TABLE_NAME, COUNT(*) AS ROW_COUNT FROM CUSTOMER_RAW
UNION ALL
SELECT 'INTERACTIONS_RAW', COUNT(*) FROM INTERACTIONS_RAW
UNION ALL
SELECT 'OUTCOMES_RAW', COUNT(*) FROM OUTCOMES_RAW
UNION ALL
SELECT 'SERVICE_EVENTS_RAW', COUNT(*) FROM SERVICE_EVENTS_RAW
UNION ALL
SELECT 'SURVEYS_RAW', COUNT(*) FROM SURVEYS_RAW;
 
-- Sample data verification
SELECT TOP 5 * FROM CUSTOMER_RAW;
SELECT TOP 5 * FROM INTERACTIONS_RAW;
 