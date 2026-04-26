# Customer & Operations Intelligence Platform

An end-to-end cloud data platform that ingests raw customer and operations data from **AWS S3** and **Azure Blob Storage**, transforms it through a three-layer architecture in **Snowflake**, and serves an interactive **Power BI** dashboard with KPIs, churn risk analysis, and customer satisfaction metrics.

---

## Architecture

```
AWS S3 (customer-ops-raw-data)       Azure Blob Storage (customeropsstore)
         ↓                                        ↓
   AWS_S3_STAGE                          AZURE_BLOB_STAGE
         ↓                                        ↓
              Snowflake — CUSTOMER_OPS_DB
              ├── RAW schema (5 source tables)
              ├── TRANSFORM schema (cleaning layer)
              └── MART schema (MART_CASE_SUMMARY view)
                           ↓
                  Power BI Dashboard (cloud-connected)
```

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Cloud Storage | AWS S3, Azure Blob Storage |
| Data Warehouse | Snowflake (X-Small warehouse) |
| BI & Visualization | Power BI Desktop |
| Languages | SQL, Python |
| Data Format | CSV |

---

## Project Structure

```
customer-ops-platform/
├── data/
│   └── cleaned/
│       ├── customers_clean.csv
│       ├── interactions_clean.csv
│       ├── outcomes_clean.csv
│       ├── service_events_clean.csv
│       └── surveys_clean.csv
├── snowflake/
│   ├── 01_setup.sql          -- Warehouse, database, schemas
│   ├── 02_raw_tables.sql     -- 5 raw table definitions
│   ├── 03_stages.sql         -- Internal, Azure, and AWS stages
│   ├── 04_copy_into.sql      -- Load CSVs into RAW tables
│   └── 05_mart_view.sql      -- MART_CASE_SUMMARY join view
├── powerbi/
│   └── customer_ops_dashboard.pbix
└── README.md
```

---

## Data Model

### Source Tables (RAW schema)

| Table | Rows | Description |
|-------|------|-------------|
| CUSTOMER_RAW | 10 | Customer demographics and contract info |
| INTERACTIONS_RAW | 10 | Support channel interactions per case |
| OUTCOMES_RAW | 10 | Resolution flags, churn risk, SLA breaches |
| SERVICE_EVENTS_RAW | 10 | Team assignments and response timestamps |
| SURVEYS_RAW | 10 | CSAT scores, NPS groups, sentiment labels |

### Reporting View (MART schema)

`MART_CASE_SUMMARY` joins all 5 source tables on `CASE_ID` and `CUSTOMER_ID`, producing 36 columns including:

- Customer segment, province, contract type, tenure
- Channel, issue type, priority, agent
- Resolution time, repeat contact flag, churn risk flag
- CSAT score, NPS group, sentiment label
- Derived fields: `HIGH_RISK_FLAG`, `CSAT_BAND`, `RESPONSE_TIME_MINS`, `FULL_CYCLE_HOURS`

---

## KPIs & Dashboard

The Power BI dashboard connects directly to `CUSTOMER_OPS_DB.MART.MART_CASE_SUMMARY` and displays:

- **Total Cases** — 10
- **Avg CSAT Score** — 3.40
- **Avg Resolution Time** — 4.83 hours
- **Total Customers** — 10
- **Cases by Status** — Resolved vs Open breakdown
- **Interactions by Channel** — Phone, Chat, Email
- **Repeat Contact Rate by Final Status** — Open 50% vs Resolved 13%

---

## Setup Instructions

### Prerequisites
- Snowflake account (free trial at snowflake.com)
- AWS account (free tier at aws.amazon.com)
- Azure account (free trial at portal.azure.com)
- Power BI Desktop

### Step 1 — Snowflake Setup
```sql
-- Run in order:
-- 01_setup.sql    → creates warehouse, database, schemas
-- 02_raw_tables.sql → creates 5 raw tables
-- 03_stages.sql   → creates internal, Azure, AWS stages
-- 04_copy_into.sql → loads data into raw tables
-- 05_mart_view.sql → creates reporting mart view
```

### Step 2 — AWS S3
1. Create S3 bucket: `customer-ops-raw-data`
2. Upload all 5 CSV files
3. Create IAM user `snowflake-s3-user` with `AmazonS3FullAccess`
4. Generate access keys and update `03_stages.sql`

### Step 3 — Azure Blob Storage
1. Create Storage Account: `customeropsstore`
2. Create container: `raw-data`
3. Upload all 5 CSV files
4. Generate SAS token and update `03_stages.sql`

### Step 4 — Power BI
1. Open Power BI Desktop
2. Get Data → Snowflake
3. Server: `<account>.snowflakecomputing.com`
4. Warehouse: `CUSTOMER_OPS_WH`
5. Load `CUSTOMER_OPS_DB.MART.MART_CASE_SUMMARY`

---

## Key Learnings

- Designed a **three-layer Snowflake architecture** (RAW → TRANSFORM → MART)
- Integrated **multi-cloud storage** (AWS S3 + Azure Blob) as raw data landing zones
- Built a **star-schema style reporting mart** joining 5 source tables
- Connected **Power BI directly to Snowflake** replacing local CSV dependencies
- Defined and implemented **operational KPIs** including churn risk, SLA breach rate, and repeat contact rate

---

## Author

Momna Ali  
[LinkedIn](https://linkedin.com/in/momnaali) | [GitHub](https://github.com/momnaali)
