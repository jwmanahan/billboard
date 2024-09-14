A collection of resources built to analyze Billboard Top 50 Airplay lists

- Billboard's [stated rules](https://www.billboard.com/billboard-charts-legend/) for when a song becomes ineligible seem arbitrarily enforced. Evidence, originally kept in the archived xlsm file, is in the process of moving to SQL with DuckDB. Most of this repository is the new SQL style, and about six months of data from early 2024 are housed only in the xlsm file

- Contained in Excel/SQL is also visualization of trends by song and artist and a bunch of things like sparkline song rank over time and % female by week

- I maintain a [Spotify playlist](https://open.spotify.com/playlist/2USBpRPrBS3sKOzcucReSh?si=bc5c67c999d54779) with all Billboard Country #1 songs
    - The JSON parser ipynb file ranks artists by #1 songs using this playlist, including batched extraction of data from the Spotify API


## Instructions to use the SQL
1. Clone this repository, open a terminal, and navigate to the folder this repository is cloned to
2. Run `bash install.sh` (Mac) or `install.sh` (Windows) to install necessary packages
3. Making sure you're in the repo directory, run `python table_configs/run_schema_configs.py billboard_schema.sql`
4. Update line 5 of `table_configs/run_table_configs.py` to your full current working directly. If you're using Windows, switch `\` to `\\`
5. Run `python table_configs/run_table_configs.py`
6. Run `python main.py` to create a file named `raw_db.duckdb` in the repository
7. Use DBeaver or your favorite SQL development tool to establish a connection to `raw_db.duckdb`: [instructions](https://duckdb.org/docs/guides/sql_editors/dbeaver.html)
