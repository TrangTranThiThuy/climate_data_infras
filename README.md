# MeteoHub – Weather Data Platform

## Overview

MeteoHub is a **data engineering platform** developed for GreenAndCoop, a renewable energy cooperative in Hauts-de-France.

The objective is to collect, transform, validate, and centralize weather data to provide reliable datasets for **energy demand forecasting and renewable energy planning**.

## Architecture

```text
Weather Data Sources
        │
        ▼
       S3
        │
        ▼
     Airbyte
        │
        ▼
   PostgreSQL RDS
        │
        ▼
       dbt
   ┌────┼────┐
   ▼    ▼    ▼
 Staging → Intermediate → Mart
        │
        ▼
  Weather Dataset
```

Infrastructure and orchestration are managed with **Terraform, AWS ECS, EventBridge, and CloudWatch**.

## Data Model

The database is organized around weather stations and their observations:

* `station` — station information
* `weather_underground` — Weather Underground observations
* `infoclimat_hourly` — Infoclimat hourly observations
* `weather_prediction` — weather prediction data

The main relationship is:

```text
station (1) ──────── (N) weather observations
```

Observations are identified by `station_id` and `observed_at`, with data quality checks ensuring valid and non-duplicated records.

## Technologies

* **Python** — data processing
* **AWS S3** — data storage
* **Airbyte** — data ingestion
* **PostgreSQL / Amazon RDS** — data warehouse
* **dbt** — transformation and data quality
* **Docker / ECR** — containerization
* **ECS / EventBridge** — scheduled dbt execution
* **CloudWatch** — monitoring and logs
* **Terraform** — infrastructure as code

## Data Quality

dbt tests are used to validate:

* Primary and foreign key integrity
* Not-null constraints
* Uniqueness of station identifiers
* Uniqueness of observation timestamps
* Source data consistency

The project currently includes **13 automated data quality tests**.

## Objective

The final dataset provides a reliable and structured source of weather data that can be consumed by Data Scientists for **energy forecasting and renewable production planning**.
