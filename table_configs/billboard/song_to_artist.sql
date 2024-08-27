-- Create the song_to_artist table
CREATE OR REPLACE TABLE billboard.song_to_artist (
    song_to_artist_pk TEXT PRIMARY KEY
    , song_id INTEGER NOT NULL
    , artist_id INTEGER NOT NULL
    , relationship_type TEXT NOT NULL
    , relationship_conjunction TEXT
    , relationship_index INTEGER
    , last_update DATE -- US Eastern Time please
    -- , CONSTRAINT fk_song FOREIGN KEY(song_id) REFERENCES billboard.song(song_id)
    -- , CONSTRAINT fk_artist
    --     FOREIGN KEY(artist_id)
    --     REFERENCES billboard.artist(artist_id)
    -- TO TEST:
        -- This file being alphabetically before song disallows the foreign key
            -- Is best fix to move all FKs to their own final script?
        -- FKs constrain what order tables can be dropped in.
            -- Consider when building a script to change database that starts with drop all
);
