-- Create the Songs table
CREATE OR REPLACE TABLE billboard.song (
    song_id INTEGER PRIMARY KEY
    , song_name TEXT
    , untracked_weeks_on_chart INTEGER DEFAULT 0
    , last_update DATE -- US Eastern Time please
);
