A collection of resources built to analyze Billboard Top 50 Airplay lists

- I maintain a [Spotify playlist](https://open.spotify.com/playlist/2USBpRPrBS3sKOzcucReSh?si=bc5c67c999d54779) with all Billboard Country #1 songs
    - The ipynb file ranks artists by #1 songs using this playlist, including batched extraction of data from the Spotify API

- Billboard's [stated rules](https://www.billboard.com/billboard-charts-legend/) for when a song becomes ineligible seem arbitrarily enforced. Evidence, originally kept in the xlsm file, is in the process of moving to SQL with DuckDB. The rest of this repository is both the legacy Excel style and new SQL style in parallel while working on this transition

- Contained in Excel/SQL is also visualization of trends by song and artist and a bunch of things like sparkline song rank over time and % female by week
