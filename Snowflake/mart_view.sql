-- ============================================================================
-- CUSTOMER OPS PLATFORM - ANALYTICS & REPORTING QUERIES
-- File: 05_analytics_queries.sql
-- Purpose: Pre-built queries for Power BI dashboards and reporting
-- ============================================================================
 
USE WAREHOUSE CUSTOMER_OPS_WH;
USE SCHEMA CUSTOMER_OPS_DB.MART;
 
-- ============================================================================
-- QUERY 1: EXECUTIVE DASHBOARD SUMMARY
-- ============================================================================
-- KPI metrics for executive dashboard
 
SELECT 
    COUNT(DISTINCT CUSTOMER_ID) AS TOTAL_CUSTOMERS,
    COUNT(DISTINCT CASE_ID) AS TOTAL_CASES,
    ROUND(AVG(CSAT_SCORE), 2) AS AVG_CSAT,
    ROUND(AVG(RESOLUTION_TIME_HOURS), 2) AS AVG_RESOLUTION_TIME,
    ROUND(SUM(CASE WHEN RESOLVED_FLAG = 1 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS RESOLUTION_RATE_PCT,
    ROUND(SUM(CASE WHEN CHURN_RISK_FLAG = 1 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS CHURN_RISK_PCT,
    ROUND(SUM(CASE WHEN REPEAT_CONTACT_30D_FLAG = 1 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS REPEAT_CONTACT_PCT
FROM MART_CASE_SUMMARY;
 
-- ============================================================================
-- QUERY 2: CASES BY STATUS
-- ============================================================================
-- For "Cases by Status" chart in Power BI
 
SELECT 
    FINAL_STATUS,
    COUNT(DISTINCT CASE_ID) AS CASE_COUNT,
    ROUND(AVG(RESOLUTION_TIME_HOURS), 2) AS AVG_RESOLUTION_TIME,
    ROUND(SUM(CASE WHEN REPEAT_CONTACT_30D_FLAG = 1 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS REPEAT_CONTACT_RATE_PCT
FROM MART_CASE_SUMMARY
GROUP BY FINAL_STATUS
ORDER BY CASE_COUNT DESC;
 
-- ============================================================================
-- QUERY 3: INTERACTIONS BY CHANNEL
-- ============================================================================
-- For channel performance analysis
 
SELECT 
    CHANNEL,
    COUNT(DISTINCT INTERACTION_ID) AS INTERACTION_COUNT,
    COUNT(DISTINCT CUSTOMER_ID) AS UNIQUE_CUSTOMERS,
    ROUND(SUM(CASE WHEN RESOLVED_FLAG = 1 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS RESOLUTION_RATE_PCT,
    ROUND(AVG(RESOLUTION_TIME_HOURS), 2) AS AVG_RESOLUTION_TIME,
    ROUND(AVG(CSAT_SCORE), 2) AS AVG_CSAT_SCORE
FROM MART_CASE_SUMMARY
GROUP BY CHANNEL
ORDER BY INTERACTION_COUNT DESC;
 
-- ============================================================================
-- QUERY 4: ISSUE TYPE ANALYSIS
-- ============================================================================
-- For issue breakdown and trends
 
SELECT 
    ISSUE_TYPE,
    ISSUE_SUBTYPE,
    COUNT(DISTINCT INTERACTION_ID) AS TOTAL_INTERACTIONS,
    ROUND(AVG(RESOLUTION_TIME_HOURS), 2) AS AVG_RESOLUTION_TIME,
    ROUND(SUM(CASE WHEN RESOLVED_FLAG = 1 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS RESOLUTION_RATE_PCT,
    ROUND(SUM(CASE WHEN CHURN_RISK_FLAG = 1 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS CHURN_RISK_RATE_PCT,
    ROUND(AVG(CSAT_SCORE), 2) AS AVG_CSAT_SCORE
FROM MART_CASE_SUMMARY
WHERE ISSUE_TYPE IS NOT NULL
GROUP BY ISSUE_TYPE, ISSUE_SUBTYPE
ORDER BY TOTAL_INTERACTIONS DESC;
 
-- ============================================================================
-- QUERY 5: CUSTOMER SEGMENT ANALYSIS
-- ============================================================================
-- For segment-level metrics
 
SELECT 
    SEGMENT,
    COUNT(DISTINCT CUSTOMER_ID) AS CUSTOMER_COUNT,
    ROUND(AVG(TENURE_MONTHS), 1) AS AVG_TENURE_MONTHS,
    COUNT(DISTINCT CASE_ID) AS TOTAL_CASES,
    ROUND(AVG(CSAT_SCORE), 2) AS AVG_CSAT_SCORE,
    ROUND(SUM(CASE WHEN CHURN_RISK_FLAG = 1 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS CHURN_RISK_RATE_PCT,
    ROUND(SUM(CASE WHEN REPEAT_CONTACT_30D_FLAG = 1 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS REPEAT_CONTACT_RATE_PCT
FROM MART_CASE_SUMMARY
WHERE SEGMENT IS NOT NULL
GROUP BY SEGMENT
ORDER BY CUSTOMER_COUNT DESC;
 
-- ============================================================================
-- QUERY 6: GEOGRAPHIC ANALYSIS
-- ============================================================================
-- For province/region performance
 
SELECT 
    PROVINCE,
    COUNT(DISTINCT CUSTOMER_ID) AS CUSTOMER_COUNT,
    COUNT(DISTINCT CASE_ID) AS TOTAL_CASES,
    ROUND(AVG(RESOLUTION_TIME_HOURS), 2) AS AVG_RESOLUTION_TIME,
    ROUND(AVG(CSAT_SCORE), 2) AS AVG_CSAT_SCORE,
    ROUND(SUM(CASE WHEN SLA_BREACH_FLAG = 1 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS SLA_BREACH_RATE_PCT
FROM MART_CASE_SUMMARY
WHERE PROVINCE IS NOT NULL
GROUP BY PROVINCE
ORDER BY CUSTOMER_COUNT DESC;
 
-- ============================================================================
-- QUERY 7: TIME SERIES - CASES BY DATE
-- ============================================================================
-- For trend analysis over time
 
SELECT 
    INTERACTION_DATE,
    COUNT(DISTINCT CASE_ID) AS NEW_CASES,
    SUM(CASE WHEN RESOLVED_FLAG = 1 THEN 1 ELSE 0 END) AS RESOLVED_CASES,
    ROUND(AVG(RESOLUTION_TIME_HOURS), 2) AS AVG_RESOLUTION_TIME,
    ROUND(AVG(CSAT_SCORE), 2) AS AVG_DAILY_CSAT
FROM MART_CASE_SUMMARY
WHERE INTERACTION_DATE IS NOT NULL
GROUP BY INTERACTION_DATE
ORDER BY INTERACTION_DATE DESC;
 
-- ============================================================================
-- QUERY 8: SLA & ESCALATION ANALYSIS
-- ============================================================================
-- For operational team monitoring
 
SELECT 
    TEAM_NAME,
    COUNT(DISTINCT CASE_ID) AS TOTAL_CASES,
    ROUND(AVG(FULL_CYCLE_HOURS), 2) AS AVG_RESOLUTION_HOURS,
    ROUND(SUM(CASE WHEN ESCALATION_FLAG = 1 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS ESCALATION_RATE_PCT,
    ROUND(SUM(CASE WHEN SLA_BREACH_FLAG = 1 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS SLA_BREACH_RATE_PCT
FROM MART_CASE_SUMMARY
WHERE TEAM_NAME IS NOT NULL
GROUP BY TEAM_NAME
ORDER BY TOTAL_CASES DESC;
 
-- ============================================================================
-- QUERY 9: CHURN RISK & REFUND ANALYSIS
-- ============================================================================
-- For risk management
 
SELECT 
    SEGMENT,
    AGE_GROUP,
    COUNT(DISTINCT CUSTOMER_ID) AS TOTAL_CUSTOMERS,
    ROUND(SUM(CASE WHEN CHURN_RISK_FLAG = 1 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS CHURN_RISK_PCT,
    ROUND(SUM(CASE WHEN REFUND_FLAG = 1 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS REFUND_RATE_PCT,
    ROUND(AVG(CSAT_SCORE), 2) AS AVG_CSAT_SCORE
FROM MART_CASE_SUMMARY
WHERE SEGMENT IS NOT NULL AND AGE_GROUP IS NOT NULL
GROUP BY SEGMENT, AGE_GROUP
ORDER BY CHURN_RISK_PCT DESC;
 
-- ============================================================================
-- QUERY 10: SURVEY RESPONSE ANALYSIS
-- ============================================================================
-- For customer satisfaction insights
 
SELECT 
    SENTIMENT_LABEL,
    NPS_GROUP,
    COUNT(DISTINCT INTERACTION_ID) AS SURVEY_COUNT,
    ROUND(AVG(CSAT_SCORE), 2) AS AVG_CSAT,
    ROUND(SUM(CASE WHEN NPS_GROUP = 'Promoter' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS PROMOTER_PCT,
    ROUND(SUM(CASE WHEN NPS_GROUP = 'Detractor' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS DETRACTOR_PCT,
    ROUND(SUM(CASE WHEN RESPONDED_FLAG = 1 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS RESPONSE_RATE_PCT
FROM MART_CASE_SUMMARY
WHERE SENTIMENT_LABEL IS NOT NULL
GROUP BY SENTIMENT_LABEL, NPS_GROUP
ORDER BY SURVEY_COUNT DESC;
 
-- ============================================================================
-- QUERY 11: ROOT CAUSE ANALYSIS
-- ============================================================================
-- For problem identification
 
SELECT 
    ROOT_CAUSE,
    COUNT(DISTINCT CASE_ID) AS CASE_COUNT,
    ROUND(AVG(FULL_CYCLE_HOURS), 2) AS AVG_RESOLUTION_HOURS,
    ROUND(SUM(CASE WHEN REFUND_FLAG = 1 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS REFUND_RATE_PCT,
    ROUND(AVG(CSAT_SCORE), 2) AS AVG_CSAT_SCORE,
    ROUND(SUM(CASE WHEN HIGH_RISK_FLAG = 1 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS HIGH_RISK_RATE_PCT
FROM MART_CASE_SUMMARY
WHERE ROOT_CAUSE IS NOT NULL
GROUP BY ROOT_CAUSE
ORDER BY CASE_COUNT DESC;
 
-- ============================================================================
-- QUERY 12: HIGH-RISK CUSTOMERS
-- ============================================================================
-- For targeted retention programs
 
SELECT 
    CUSTOMER_ID,
    CUSTOMER_NAME,
    SEGMENT,
    AGE_GROUP,
    PROVINCE,
    TENURE_MONTHS,
    COUNT(DISTINCT CASE_ID) AS TOTAL_CASES,
    ROUND(AVG(CSAT_SCORE), 2) AS AVG_CSAT,
    SUM(CASE WHEN CHURN_RISK_FLAG = 1 THEN 1 ELSE 0 END) AS CHURN_RISK_COUNT,
    SUM(CASE WHEN REPEAT_CONTACT_30D_FLAG = 1 THEN 1 ELSE 0 END) AS REPEAT_CONTACT_COUNT,
    SUM(CASE WHEN REFUND_FLAG = 1 THEN 1 ELSE 0 END) AS REFUND_COUNT
FROM MART_CASE_SUMMARY
WHERE HIGH_RISK_FLAG = 1
GROUP BY CUSTOMER_ID, CUSTOMER_NAME, SEGMENT, AGE_GROUP, PROVINCE, TENURE_MONTHS
ORDER BY CHURN_RISK_COUNT DESC;
 
-- ============================================================================
-- Query Testing / Verification
-- ============================================================================
-- Run individual queries above and copy results to Power BI
-- Each query is optimized for a specific Power BI visualization
 
SELECT CURRENT_TIMESTAMP() AS QUERY_RUN_TIME;