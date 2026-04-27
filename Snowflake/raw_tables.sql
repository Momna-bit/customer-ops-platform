-- ============================================================================
-- CUSTOMER OPS PLATFORM - CREATE RAW TABLES
-- File: 02_create_raw_tables.sql
-- Purpose: Create all raw data tables
-- ============================================================================
 
USE WAREHOUSE CUSTOMER_OPS_WH;
USE SCHEMA CUSTOMER_OPS_DB.RAW;
 
-- Create CUSTOMER_RAW table
CREATE OR REPLACE TABLE CUSTOMER_RAW (
    CUSTOMER_ID     NUMBER,
    CUSTOMER_NAME   STRING,
    AGE_GROUP       STRING,
    GENDER          STRING,
    CITY            STRING,
    PROVINCE        STRING,
    SEGMENT         STRING,
    SIGNUP_DATE     DATE,
    CONTRACT_TYPE   STRING,
    TENURE_MONTHS   NUMBER
);
 
-- Create INTERACTIONS_RAW table
CREATE OR REPLACE TABLE INTERACTIONS_RAW (
    INTERACTION_ID      STRING,
    CUSTOMER_ID         NUMBER,
    CASE_ID             STRING,
    INTERACTION_DATE    DATE,
    CHANNEL             STRING,
    ISSUE_TYPE          STRING,
    ISSUE_SUBTYPE       STRING,
    PRIORITY            STRING,
    AGENT_ID            STRING,
    INTERACTION_STATUS  STRING
);
 
-- Create OUTCOMES_RAW table
CREATE OR REPLACE TABLE OUTCOMES_RAW (
    OUTCOME_ID              STRING,
    CASE_ID                 STRING,
    CUSTOMER_ID             NUMBER,
    RESOLVED_FLAG           NUMBER,
    RESOLUTION_TIME_HOURS   FLOAT,
    REPEAT_CONTACT_30D_FLAG NUMBER,
    REFUND_FLAG             NUMBER,
    CHURN_RISK_FLAG         NUMBER,
    SLA_BREACH_FLAG         NUMBER,
    FINAL_STATUS            STRING
);
 
-- Create SERVICE_EVENTS_RAW table
CREATE OR REPLACE TABLE SERVICE_EVENTS_RAW (
    EVENT_ID            STRING,
    CASE_ID             STRING,
    CUSTOMER_ID         NUMBER,
    CREATED_DATE        DATE,
    ASSIGNED_DATE       TIMESTAMP_NTZ,
    FIRST_RESPONSE_DATE TIMESTAMP_NTZ,
    RESOLVED_DATE       TIMESTAMP_NTZ,
    TEAM_NAME           STRING,
    ROOT_CAUSE          STRING,
    ESCALATION_FLAG     NUMBER
);
 
-- Create SURVEYS_RAW table
CREATE OR REPLACE TABLE SURVEYS_RAW (
    SURVEY_ID           STRING,
    CUSTOMER_ID         NUMBER,
    CASE_ID             STRING,
    SURVEY_DATE         DATE,
    CSAT_SCORE          NUMBER,
    NPS_GROUP           STRING,
    SENTIMENT_LABEL     STRING,
    FEEDBACK_TEXT       STRING,
    RESPONSE_CHANNEL    STRING,
    RESPONDED_FLAG      NUMBER
);
 
-- Verify all tables were created
SHOW TABLES IN SCHEMA CUSTOMER_OPS_DB.RAW;
 
-- Describe each table structure
DESC TABLE CUSTOMER_RAW;
DESC TABLE INTERACTIONS_RAW;
DESC TABLE OUTCOMES_RAW;
DESC TABLE SERVICE_EVENTS_RAW;
DESC TABLE SURVEYS_RAW;