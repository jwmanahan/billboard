-- Create the Data table
CREATE OR REPLACE TABLE billboard.billboard_ranking (
    billboard_ranking_pk TEXT PRIMARY KEY,
    billboard_observation_date DATE NOT NULL,
    billboard_rank INTEGER NOT NULL,
    song_id INTEGER,
    last_update DATE
);
