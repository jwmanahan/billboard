-- Create the song_to_artist table
-- TO TEST: does this file being alphabetically before song disallow the foreign key?
    -- If so, consider moving all FKs to their own final script
CREATE OR REPLACE TABLE billboard.song_to_artist (
    song_to_artist_pk TEXT PRIMARY KEY
    , song_id INTEGER NOT NULL
    , artist_id INTEGER NOT NULL
    , relationship_type TEXT NOT NULL
    , relationship_conjunction TEXT
    , relationship_index INTEGER
    , last_update DATE -- US Eastern Time please
    , CONSTRAINT fk_song FOREIGN KEY(song_id) REFERENCES billboard.song(song_id)
    , CONSTRAINT fk_artist
        FOREIGN KEY(artist_id)
        REFERENCES billboard.artist(artist_id)
);
