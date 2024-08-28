-- Create artist table
CREATE OR REPLACE TABLE billboard.artist (
    artist_id INTEGER PRIMARY KEY
    , artist_name TEXT
    , pct_female FLOAT
    , last_update DATE -- US Eastern Time please
);
