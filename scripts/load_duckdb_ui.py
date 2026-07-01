import duckdb

conn = duckdb.connect("my_data.duckdb")

conn.execute("CALL start_ui();")

print("DuckDB UI is running on http://localhost:4213")
input("Press Enter to close the UI and exit...")