-- 09_process_mining_eventlog_eva.sql
-- Doel: één eventlog maken dat klaar is om als CSV te exporteren.
-- Let op: UserKey is hier een voorlopige case-id, omdat de bron geen echte sessie-id bevat.

WITH event_log AS (

    -- Rapportbezoeken toevoegen als events
    SELECT
        'user_' || fv.user_key AS case_id,
        'Rapport bekeken: ' || COALESCE(dr.report_name, 'Onbekend rapport') AS activity,
        TO_CHAR(fv.start_time, 'YYYY-MM-DD"T"HH24:MI:SS') AS event_timestamp,
        fv.user_key,
        dr.report_name,
        NULL AS section_name,
        'report_view' AS event_type
    FROM fact_report_views fv
    LEFT JOIN dim_report dr
        ON fv.report_id = dr.report_id
    WHERE fv.start_time IS NOT NULL

    UNION ALL

    -- Sectiebezoeken toevoegen als events
    SELECT DISTINCT
        'user_' || fsv.user_key AS case_id,
        'Sectie bekeken: ' || COALESCE(ds.section_name, 'Onbekende sectie') AS activity,
        TO_CHAR(fsv.event_timestamp, 'YYYY-MM-DD"T"HH24:MI:SS') AS event_timestamp,
        fsv.user_key,
        dr.report_name,
        ds.section_name,
        'section_view' AS event_type
    FROM fact_report_section_views fsv
    LEFT JOIN dim_report_section ds
        ON fsv.report_id = ds.report_id
       AND fsv.section_id = ds.section_id
    LEFT JOIN dim_report dr
        ON fsv.report_id = dr.report_id
    WHERE fsv.event_timestamp IS NOT NULL
)

SELECT
    case_id AS "case:concept:name",
    activity AS "concept:name",
    event_timestamp AS "time:timestamp",
    user_key,
    report_name,
    section_name,
    event_type
FROM event_log
ORDER BY case_id, event_timestamp;
