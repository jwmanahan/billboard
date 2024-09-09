WITH cte_billboard_lookback AS (
    SELECT DISTINCT
        billboard_observation_date
        , DENSE_RANK()
            OVER (ORDER BY billboard_observation_date DESC) - 1
            AS weeks_ago
    FROM raw_db.billboard.billboard_ranking
)

SELECT
    art.artist_id
    , art.artist_name

    , COUNT_IF(
        s2a.relationship_type = 'Lead artist'
        AND bl.weeks_ago IS NOT NULL
      ) AS recent_weeks_lead_artist
    , COUNT_IF(
        s2a.relationship_type IN ('Lead artist', 'Other main artist')
        AND bl.weeks_ago IS NOT NULL
      ) AS recent_weeks_main_artist
    , COUNT_IF(bl.weeks_ago IS NOT NULL) AS recent_weeks_artist
    , COUNT_IF(s2a.relationship_type = 'Lead artist')
        + SUM(CASE WHEN s2a.relationship_type = 'Lead artist'
                   THEN ss.untracked_weeks_on_chart
              ELSE 0 END
        ) AS all_weeks_lead_artist
    , all_weeks_lead_artist
        + COUNT_IF(s2a.relationship_type = 'Other main artist')
        + SUM(CASE WHEN s2a.relationship_type = 'Other main artist'
                   THEN ss.untracked_weeks_on_chart
              ELSE 0 END
        ) AS all_weeks_main_artist
    , COUNT(1) + SUM(ss.untracked_weeks_on_chart) AS all_weeks_artist

    , COUNT(DISTINCT
        CASE WHEN bl.weeks_ago IS NOT NULL
                  AND s2a.relationship_type = 'Lead artist'
             THEN br.song_id
             ELSE NULL END
      ) AS recent_num_songs_lead_artist
    , COUNT(DISTINCT
        CASE WHEN bl.weeks_ago IS NOT NULL
                  AND s2a.relationship_type IN (
                      'Lead artist'
                      , 'Other main artist'
                  )
             THEN br.song_id
             ELSE NULL END
      ) AS recent_num_songs_main_artist
    , COUNT(DISTINCT
        CASE WHEN bl.weeks_ago IS NOT NULL
        THEN br.song_id
        ELSE NULL END
      ) AS recent_num_songs_artist
    , COUNT(DISTINCT
        CASE WHEN s2a.relationship_type = 'Lead artist'
             THEN br.song_id
             ELSE NULL END
      ) AS all_num_songs_lead_artist
    , COUNT(DISTINCT
        CASE WHEN s2a.relationship_type IN ('Lead artist', 'Other main artist')
             THEN br.song_id
             ELSE NULL END
      ) AS all_num_songs_main_artist
    , COUNT(DISTINCT br.song_id) AS all_num_songs_artist

    , MIN(
        CASE WHEN s2a.relationship_type IN ('Lead artist', 'Other main artist')
                  AND bl.weeks_ago IS NOT NULL
             THEN br.billboard_rank
             ELSE NULL END
      ) AS recent_peak_position_as_main_artist
    , MIN(
        CASE WHEN s2a.relationship_type IN ('Lead artist', 'Other main artist')
             THEN br.billboard_rank
             ELSE NULL END
      ) AS all_peak_position_as_main_artist

    , MIN(br.billboard_observation_date) AS debut_date_in_data -- even if not lead artist

    --, NULL AS cumulative_pct_female
FROM raw_db.billboard.artist art
INNER JOIN raw_db.billboard.song_to_artist s2a
    ON art.artist_id = s2a.artist_id
LEFT JOIN raw_db.billboard.song ss
    ON s2a.song_id = ss.song_id
LEFT JOIN raw_db.billboard.billboard_ranking br
    ON s2a.song_id = br.song_id
LEFT JOIN cte_billboard_lookback bl
    ON br.billboard_observation_date = bl.billboard_observation_date
    AND bl.weeks_ago <= 26 -- arbitrary definition of recency
GROUP BY 1,2
ORDER BY
    recent_weeks_main_artist DESC
    , recent_weeks_lead_artist DESC
    , recent_weeks_artist DESC
    , recent_num_songs_main_artist DESC
    , recent_num_songs_lead_artist DESC
    , recent_num_songs_artist DESC
    , recent_peak_position_as_main_artist ASC
    , all_weeks_main_artist DESC
    , all_weeks_lead_artist DESC
    , all_weeks_artist DESC
    , all_num_songs_main_artist DESC
    , all_num_songs_lead_artist DESC
    , all_num_songs_artist DESC
    , all_peak_position_as_main_artist ASC
    , debut_date_in_data ASC
;
