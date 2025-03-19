WITH cte_song_pct_female AS (
    SELECT
        br.billboard_observation_date
        , br.song_id
        , br.billboard_rank
        , AVG(art.pct_female) AS song_pct_female
    FROM raw_db.billboard.billboard_ranking br
    INNER JOIN raw_db.billboard.song_to_artist s2a
        ON br.song_id = s2a.song_id
        AND s2a.relationship_type IN ('Lead artist', 'Other main artist')
    LEFT JOIN raw_db.billboard.artist art
        ON s2a.artist_id = art.artist_id
    -- WHERE billboard_observation_date >= (
    --     SELECT MAX(billboard_observation_date)
    --     FROM raw_db.billboard.billboard_ranking
    -- ) - 17
    -- WHERE billboard_observation_date IN ('2024-08-23', '2024-12-31', '2024-04-16')
    GROUP BY 1,2,3
)
SELECT
    billboard_observation_date
    , billboard_rank
    , song_pct_female AS this_song_pct_female
    , SUM(song_pct_female) OVER(
        PARTITION BY billboard_observation_date
        ORDER BY billboard_rank ASC
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
      )
      / COUNT(1) OVER (
          PARTITION BY billboard_observation_date
          ORDER BY billboard_rank ASC
          ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
      ) AS cumulative_pct_female
FROM cte_song_pct_female
GROUP BY 1,2,3
ORDER BY 1 DESC, 2 ASC
