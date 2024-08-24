import duckdb
import pandas as pd
import os

# Print the current working directory to verify the script's location
print("Current Working Directory:", os.getcwd())

# Load the datasets with the correct path
data_path = 'source_data/data.csv'
song_path = 'source_data/song.csv'
artist_path = 'source_data/artist.csv'

# Load the data into Pandas DataFrames
data_df = pd.read_csv(data_path)
song_df = pd.read_csv(song_path)
artist_df = pd.read_csv(artist_path)

# Connect to the DuckDB database file
con = duckdb.connect('raw_db.duckdb')

# Insert the data into the DuckDB tables within the 'billboard' schema
con.execute("INSERT INTO billboard.data SELECT * FROM data_df")

con.execute("INSERT INTO billboard.song SELECT * FROM song_df")

con.execute("INSERT INTO billboard.artist SELECT * FROM artist_df")

# Close the connection
con.close()

#command python main.py
