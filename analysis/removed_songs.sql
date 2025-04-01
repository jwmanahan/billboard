SELECT
    br_old.song_id
    , ss.song_name
    , art.artist_name AS lead_artist_name
    , br_old.billboard_rank AS ranking_before
FROM raw_db.billboard.billboard_ranking br_old
LEFT JOIN billboard.song ss
    ON ss.song_id = br_old.song_id
LEFT JOIN raw_db.billboard.billboard_ranking br_new
    ON br_new.billboard_observation_date = '{0}'
    AND br_new.song_id = br_old.song_id
LEFT JOIN raw_db.billboard.song_to_artist s2a
    ON ss.song_id = s2a.song_id
    AND s2a.relationship_type = 'Lead artist' -- TODO add ARRAY_CONSTRUCT if exists in DuckDB
LEFT JOIN raw_db.billboard.artist art
    ON s2a.artist_id = art.artist_id
WHERE br_old.billboard_observation_date = '{1}'
AND br_new.song_id IS NULL
ORDER BY ranking_before
