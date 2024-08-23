-- Create the Songs table
CREATE TABLE IF NOT EXISTS billboard.songs (
    song_name TEXT,
    lead_artist_name TEXT,
    list_of_other_main_artists TEXT,
    list_of_featured_artists TEXT,
    number_of_weeks INTEGER
);