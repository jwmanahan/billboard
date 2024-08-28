WITH cte_billboard_lookback AS (
    SELECT DISTINCT
        billboard_observation_date
        , DENSE_RANK() OVER (ORDER BY billboard_observation_date DESC) - 1 weeks_ago
    FROM raw_db.billboard.billboard_ranking
)

SELECT
    art.artist_id
    , art.artist_name
   
    , COUNT_IF(s2a.relationship_type = 'Lead artist' AND bl.weeks_ago IS NOT NULL) AS recent_weeks_lead_artist
    /*, recent_weeks_lead_artist
        + COUNT_IF(s2a.relationship_type = 'Other main artist' AND bl.weeks_ago IS NOT NULL)
        AS recent_weeks_main_artist
    , recent_weeks_main_artist + NULL AS recent_weeks_artist
    , COUNT_IF(s2a.relationship_type = 'Lead artist')
        + IFF(s2a.relationship_type = 'Lead artist', ss.weeks_on_chart_before_tracking_start, 0)
        AS all_weeks_lead_artist
    , all_weeks_lead_artist
        + COUNT_IF(s2a.relationship_type = 'Other main artist')
        + IFF(s2a.relationship_type = 'Other main artist', ss.weeks_on_chart_before_tracking_start, 0)
        AS all_weeks_main_artist
    , all_weeks_main_artist
        + COUNT_IF(s2a.relationship_type = 'Featured artist')
        + IFF(s2a.relationship_type = 'Featured artist', ss.weeks_on_chart_before_tracking_start, 0)
        AS all_weeks_artist

    , NULL AS recent_num_songs_lead_artist
    , recent_num_songs_lead_artist + NULL AS recent_num_songs_main_artist
    , recent_num_songs_main_artist + NULL AS recent_num_songs_artist
    , NULL AS all_num_songs_lead_artist
    , all_num_songs_lead_artist + NULL AS all_num_songs_main_artist
    , all_num_songs_main_artist + NULL AS all_num_songs_artist

    , NULL AS recent_peak_position_as_main_artist
    , NULL AS all_peak_position_as_main_artist
    , NULL AS debut_date_in_data
   
    , NULL AS cumulative_pct_female
    */
FROM raw_db.billboard.artist art
INNER JOIN raw_db.billboard.song_to_artist s2a
    ON art.artist_id = s2a.artist_id
LEFT JOIN raw_db.billboard.song ss
    ON s2a.song_id = ss.song_id
-- TODO: Split here for normalization to aggregate num_songs before 1:m with billboard ranks by week
LEFT JOIN raw_db.billboard.billboard_ranking br
    ON s2a.song_id = br.song_id
LEFT JOIN cte_billboard_lookback bl
    ON br.billboard_observation_date = bl.billboard_observation_date
    AND bl.weeks_ago <= 25 -- arbitrary definition of recency
GROUP BY 1,2
ORDER BY
    --recent_weeks_main_artist DESC
    --,
    recent_weeks_lead_artist DESC
    /*, recent_weeks_artist DESC
    , recent_num_songs_main_artist DESC
    , recent_num_songs_lead_artist DESC
    , recent_num_songs_artist DESC
    , recent_peak_position_as_main_artist ASC
    , recent_weeks_main_artist DESC
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
    , all_weeks_main_artist DESC
    , all_weeks_lead_artist DESC
    , all_weeks_artist DESC
    , all_num_songs_main_artist DESC
    , all_num_songs_lead_artist DESC
    , all_num_songs_artist DESC
    , all_peak_position_as_main_artist ASC
    , debut_date_in_data ASC*/
;