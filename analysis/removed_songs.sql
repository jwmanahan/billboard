SELECT
    br_old.song_id
    , ss.song_name
    , br_old.billboard_rank AS ranking_before
FROM raw_db.billboard.billboard_ranking br_old
LEFT JOIN billboard.song ss
    ON ss.song_id = br_old.song_id
LEFT JOIN raw_db.billboard.billboard_ranking br_new
    ON br_new.billboard_observation_date = '{0}'
    AND br_new.song_id = br_old.song_id
-- TODO add s2a and artist, and ARRAY_CONSTRUCT if exists in DuckDB
WHERE br_old.billboard_observation_date = '{1}'
AND br_new.song_id IS NULL
ORDER BY ranking_before
