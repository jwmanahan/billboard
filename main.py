import duckdb
import pandas as pd
import os

# Print the current working directory to verify the script's location
print("Current Working Directory:", os.getcwd())

# Load the datasets with the correct path
song_path = 'source_data/song.csv'
artist_path = 'source_data/artist.csv'
song_to_artist_path = 'source_data/song_to_artist.csv'
billboard_ranking_path = 'source_data/billboard_ranking.csv'

# Load the data into Pandas DataFrames
song_df = pd.read_csv(song_path)
artist_df = pd.read_csv(artist_path)
song_to_artist_df = pd.read_csv(song_to_artist_path)
billboard_ranking_df = pd.read_csv(billboard_ranking_path)

# Connect to the DuckDB database file
con = duckdb.connect('raw_db.duckdb')

# Insert the data into the DuckDB tables within the 'billboard' schema
for tbl_name in ['song', 'artist', 'song_to_artist', 'billboard_ranking']:
    con.execute(f"INSERT INTO billboard.{tbl_name} SELECT * FROM {tbl_name}_df")

# Close the connection
con.close()

#command python main.py
