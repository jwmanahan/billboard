import duckdb
import sys
import os

def find_schema_file(file_name, search_dir):
    # Walk through the directory tree
    for root, dirs, files in os.walk(search_dir):
        if file_name in files:
            return os.path.join(root, file_name)
    return None

if len(sys.argv) < 2:
    print("Usage: python run_schema_configs.py <schema_config.sql>")
    sys.exit(1)

schema_file = sys.argv[1]
project_dir = os.path.dirname(os.path.abspath(__file__))

# Search for the schema file in the entire project directory
schema_file_path = find_schema_file(schema_file, project_dir)

if not schema_file_path:
    print(f"Error: {schema_file} not found in the project directory.")
    sys.exit(1)

db_file = 'raw_db.duckdb'  # or use any other db file you prefer
con = duckdb.connect(db_file)

# Read and execute the schema SQL
with open(schema_file_path, 'r') as f:
    schema_sql = f.read()
    con.execute(schema_sql)
    print(f"Executed {schema_file_path}")

con.close()

#example command
#python table_configs/run_schema_configs.py billboard_schema.sql
