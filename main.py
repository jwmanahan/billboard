import duckdb
import pandas as pd
import os

# Print the current working directory to verify the script's location
print("Current Working Directory:", os.getcwd())

# Load the datasets with the correct path
data_path = 'source_data/data.csv'
songs_path = 'source_data/songs.csv'
artists_path = 'source_data/artists.csv'

# Load the data into Pandas DataFrames
data_df = pd.read_csv(data_path)
songs_df = pd.read_csv(songs_path)
artists_df = pd.read_csv(artists_path)

# Connect to the DuckDB database file
con = duckdb.connect('raw_db.duckdb')

# Insert the data into the DuckDB tables within the 'billboard' schema
con.execute("INSERT INTO billboard.Data SELECT * FROM data_df")

con.execute("INSERT INTO billboard.Songs SELECT * FROM songs_df")

con.execute("INSERT INTO billboard.Artists SELECT * FROM artists_df")

# Close the connection
con.close()

#command python main.py
