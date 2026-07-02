# E-commerce Analytics Warehouse with dbt and DuckDB

## Project overview

This project builds an analytics warehouse from the Olist Brazilian e-commerce dataset using DuckDB and dbt Core.

The goal is to demonstrate a realistic analytics engineering workflow:

```text
Raw CSV files → DuckDB raw schema → dbt staging models → intermediate models → facts/dimensions → business marts → tests/docs
```

## Business context

The dataset represents a Brazilian marketplace with orders, customers, sellers, products, payments, reviews, and delivery timestamps.

The warehouse supports business questions such as:

1. How does daily revenue trend over time?
2. Which sellers generate the most revenue?
3. Which product categories perform best?
4. How often are deliveries late?
5. Do late deliveries correlate with lower review scores?
6. Which customers make repeat purchases?

## Tech stack

- Python
- DuckDB
- dbt Core
- dbt-duckdb
- SQL
- Docker/GitHub Actions ready structure

## Warehouse layers

### Raw layer

Raw tables are loaded directly from CSV files into the DuckDB `raw` schema with minimal transformation.

### Staging layer

Staging models clean one raw source at a time:

- column renaming
- type casting
- timestamp parsing
- standardizing city/state fields
- joining product category translations

### Intermediate layer

Intermediate models contain reusable business logic such as:

- order revenue aggregation
- payment aggregation
- review aggregation
- delivery time calculation
- customer first-order logic

### Core marts

Core fact and dimension tables:

| Model | Grain |
|---|---|
| `fct_orders` | One row per order |
| `fct_order_items` | One row per order item |
| `fct_payments` | One row per payment transaction |
| `fct_reviews` | One row per review |
| `dim_customers` | One row per customer ID |
| `dim_products` | One row per product ID |
| `dim_sellers` | One row per seller ID |
| `dim_date` | One row per calendar date |

### Business marts

Business-ready tables:

- `mart_daily_revenue`
- `mart_seller_performance`
- `mart_delivery_performance`
- `mart_product_category_performance`
- `mart_customer_repeat_purchase`

## Data quality tests

The project includes dbt tests for:

- not-null keys
- unique keys
- accepted values
- relationships between fact and dimension tables
- non-negative revenue values
- valid delivery timestamps

## How to run

### 1. Create environment

```bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

On Windows PowerShell:

```powershell
python -m venv venv
venv\Scripts\Activate.ps1
pip install -r requirements.txt
```

### 2. Add raw CSVs

Place the Olist CSV files inside:

```text
data/raw/
```

Expected files:

```text
olist_customers_dataset.csv
olist_geolocation_dataset.csv
olist_order_items_dataset.csv
olist_order_payments_dataset.csv
olist_order_reviews_dataset.csv
olist_orders_dataset.csv
olist_products_dataset.csv
olist_sellers_dataset.csv
product_category_name_translation.csv
```

### 3. Load raw CSVs into DuckDB

```bash
python scripts/load_raw_to_duckdb.py
```



### 4. Build dbt models

```bash
dbt debug
dbt build
```

### 5. Generate docs and lineage

```bash
dbt docs generate
dbt docs serve
```

## Future improvements

- Add Dagster or Airflow orchestration
- Add incremental loading from a simulated daily source folder
- Add a BI dashboard using Evidence, Metabase, Superset, or Looker Studio
- Add CI using GitHub Actions to run `dbt build`
