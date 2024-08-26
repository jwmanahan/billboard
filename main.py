import duckdb
import pandas as pd
import os

# Print the current working directory to verify the script's location
print("Current Working Directory:", os.getcwd())

# Load the datasets with the correct path
data_path = 'source_data/data.csv'
song_path = 'source_data/song.csv'
artist_path = 'source_data/artist.csv'
song_to_artist_path = 'source_data/song_to_artist.csv'

# Load the data into Pandas DataFrames
data_df = pd.read_csv(data_path)
song_df = pd.read_csv(song_path)
artist_df = pd.read_csv(artist_path)
song_to_artist_df = pd.read_csv(song_to_artist_path)

# Connect to the DuckDB database file
con = duckdb.connect('raw_db.duckdb')

# Insert the data into the DuckDB tables within the 'billboard' schema
for tbl_name in ['data', 'song', 'artist', 'song_to_artist']:
    con.execute(f"INSERT INTO billboard.{tbl_name} SELECT * FROM {tbl_name}_df")

# Close the connection
con.close()

#command python main.py
