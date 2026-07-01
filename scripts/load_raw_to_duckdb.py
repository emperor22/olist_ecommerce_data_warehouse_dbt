from pathlib import Path
import csv
import duckdb

PROJECT_ROOT = Path(__file__).resolve().parents[1]
RAW_DIR = PROJECT_ROOT / "data" / "raw"
CLEAN_DIR = PROJECT_ROOT / "data" / "cleaned"
DB_PATH = PROJECT_ROOT / "data" / "olist.duckdb"

FILES = {
    "raw_olist_customers": "olist_customers_dataset.csv",
    "raw_olist_geolocation": "olist_geolocation_dataset.csv",
    "raw_olist_order_items": "olist_order_items_dataset.csv",
    "raw_olist_order_payments": "olist_order_payments_dataset.csv",
    "raw_olist_order_reviews": "olist_order_reviews_dataset.csv",
    "raw_olist_orders": "olist_orders_dataset.csv",
    "raw_olist_products": "olist_products_dataset.csv",
    "raw_olist_sellers": "olist_sellers_dataset.csv",
    "raw_product_category_translation": "product_category_name_translation.csv",
}

def normalize_line(line):
    line = line.rstrip("\n\r")
    # Remove trailing semicolons from malformed exports like "...";;;
    while line.endswith(";"):
        line = line[:-1]
    # Handle whole-line quoted rows where inner quotes are doubled:
    # "order_id,""customer_id"",""...""
    if line.startswith('"') and line.endswith('"') and ',""' in line:
        line = line[1:-1].replace('""', '"')
    return line

def normalize_csv(src, dest):
    dest.parent.mkdir(parents=True, exist_ok=True)
    with src.open("r", encoding="utf-8-sig", errors="replace", newline="") as f_in, \
         dest.open("w", encoding="utf-8", newline="") as f_out:
        for line in f_in:
            f_out.write(normalize_line(line) + "\n")

def main():
    if not RAW_DIR.exists():
        raise FileNotFoundError(f"missing raw data directory: {RAW_DIR}")

    DB_PATH.parent.mkdir(parents=True, exist_ok=True)
    CLEAN_DIR.mkdir(parents=True, exist_ok=True)

    con = duckdb.connect(str(DB_PATH))
    con.execute("create schema if not exists raw")

    for table_name, filename in FILES.items():
        src = RAW_DIR / filename
        if not src.exists():
            raise FileNotFoundError(f"missing required file: {src}")

        cleaned = CLEAN_DIR / filename
        normalize_csv(src, cleaned)

        con.execute(f"drop table if exists raw.{table_name}")
        con.execute(f"""
            create table raw.{table_name} as
            select *
            from read_csv_auto('{cleaned.as_posix()}', header=true, sample_size=-1, ignore_errors=false)
        """)
        row_count = con.execute(f"select count(*) from raw.{table_name}").fetchone()[0]
        print(f"loaded raw.{table_name}: {row_count:,} rows")

    con.close()

if __name__ == "__main__":
    main()
