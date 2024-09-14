WITH cte_billboard_lookback AS (
    SELECT DISTINCT
        billboard_observation_date
        , DENSE_RANK()
            OVER (ORDER BY billboard_observation_date DESC) - 1
            AS weeks_ago
    FROM raw_db.billboard.billboard_ranking
)

, cte_song_stats AS (
    SELECT
        ss.song_id
        , COUNT_IF(bl.weeks_ago IS NOT NULL) AS recent_weeks_on_chart
        , COUNT(1) + MAX(ss.untracked_weeks_on_chart) AS all_weeks_on_chart
        , MIN(
            CASE WHEN bl.weeks_ago IS NOT NULL THEN br.billboard_rank END
          ) AS recent_peak_position
        , MIN(br.billboard_rank) AS overall_peak_position
        , MIN(br.billboard_observation_date) AS song_debut_date_in_data
    FROM raw_db.billboard.song ss
    LEFT JOIN raw_db.billboard.billboard_ranking br
        ON ss.song_id = br.song_id
    LEFT JOIN cte_billboard_lookback bl
        ON br.billboard_observation_date = bl.billboard_observation_date
        AND bl.weeks_ago
            BETWEEN {weeks_ago}
            AND {weeks_ago} + 26 -- arbitrary definition of recency
    GROUP BY 1
)

, cte_artist_stats AS (
    SELECT
        art.artist_id
        , art.artist_name
        , -1 * {weeks_ago} AS weeks_ago

        , SUM(CASE WHEN s2a.relationship_type = 'Lead artist'
                   THEN sst.recent_weeks_on_chart
              ELSE 0 END
          ) AS recent_weeks_lead_artist
        , SUM(CASE WHEN s2a.relationship_type IN ('Lead artist', 'Other main artist')
                   THEN sst.recent_weeks_on_chart
              ELSE 0 END
          ) AS recent_weeks_main_artist
        , SUM(sst.recent_weeks_on_chart) AS recent_weeks_artist
        , SUM(CASE WHEN s2a.relationship_type = 'Lead artist'
                   THEN sst.all_weeks_on_chart
              ELSE 0 END
          ) AS all_weeks_lead_artist
        , SUM(CASE WHEN s2a.relationship_type IN ('Lead artist', 'Other main artist')
                   THEN sst.all_weeks_on_chart
              ELSE 0 END
          ) AS all_weeks_main_artist
        , SUM(sst.all_weeks_on_chart) AS all_weeks_artist

        , COUNT_IF(
              s2a.relationship_type = 'Lead artist'
              AND sst.recent_weeks_on_chart > 0
          ) AS recent_num_songs_lead_artist
        , COUNT_IF(
              s2a.relationship_type IN ('Lead artist', 'Other main artist')
              AND sst.recent_weeks_on_chart > 0
          ) AS recent_num_songs_main_artist
        , COUNT_IF(sst.recent_weeks_on_chart > 0) AS recent_num_songs_artist

        , COUNT_IF(
              s2a.relationship_type = 'Lead artist'
              AND sst.all_weeks_on_chart > 0
          ) AS all_num_songs_lead_artist
        , COUNT_IF(
              s2a.relationship_type IN ('Lead artist', 'Other main artist')
              AND sst.all_weeks_on_chart > 0
          ) AS all_num_songs_main_artist
        , COUNT_IF(sst.all_weeks_on_chart > 0) AS all_num_songs_artist

        , MIN(
            CASE WHEN s2a.relationship_type IN ('Lead artist', 'Other main artist')
                 THEN sst.recent_peak_position
                 ELSE NULL END
          ) AS recent_peak_position_as_main_artist
        , MIN(sst.recent_peak_position) AS recent_peak_position
        , MIN(
            CASE WHEN s2a.relationship_type IN ('Lead artist', 'Other main artist')
                 THEN sst.overall_peak_position
                 ELSE NULL END
          ) AS overall_peak_position_as_main_artist
        , MIN(sst.overall_peak_position) AS overall_peak_position

        , MIN(sst.song_debut_date_in_data) AS artist_debut_date_in_data -- even if not lead artist

    FROM raw_db.billboard.artist art
    INNER JOIN raw_db.billboard.song_to_artist s2a
        ON art.artist_id = s2a.artist_id
    INNER JOIN cte_song_stats sst
        ON s2a.song_id = sst.song_id
    GROUP BY 1,2
    HAVING all_num_songs_artist > 0
)

, cte_artist_ranking AS (
    SELECT *
        , ROW_NUMBER() OVER (
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
                , overall_peak_position_as_main_artist ASC
                  -- I care more about overall stats than recent peak featured position
                , recent_peak_position ASC
                , overall_peak_position ASC
                , artist_debut_date_in_data DESC
                , artist_id ASC -- arbitrary final term for consistency between runs
          ) AS artist_rank
     FROM cte_artist_stats
)

SELECT *
    --, NULL AS cumulative_pct_female
FROM cte_artist_ranking
ORDER BY artist_rank ASC
;
