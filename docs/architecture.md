# Architecture

```text
Olist CSV files
    ↓
Python loader
    ↓
DuckDB raw schema
    ↓
dbt staging models
    ↓
dbt intermediate models
    ↓
core facts and dimensions
    ↓
business marts
```