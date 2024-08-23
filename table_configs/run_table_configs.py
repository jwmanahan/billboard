import duckdb
import os

# Define the path to your raw table configurations
config_dir = '/Users/ehodo/PycharmProjects/pit_stop_aug_23rd/table_configs/billboard/'

# Specify the DuckDB database file for raw data
db_file = 'raw_db.duckdb'

# Connect to your DuckDB database
con = duckdb.connect(db_file)

# Recursively loop through each SQL file in the directory and subdirectories and execute it
for root, dirs, files in os.walk(config_dir):
    for sql_file in files:
        if sql_file.endswith('.sql'):
            file_path = os.path.join(root, sql_file)
            with open(file_path, 'r') as f:
                sql_script = f.read()
                con.execute(sql_script)
                print(f"Executed {sql_file} from {root}")

# Close the connection
con.close()

#command
# python /Users/ehodo/PycharmProjects/pit_stop_aug_23rd/table_configs/run_table_configs.py