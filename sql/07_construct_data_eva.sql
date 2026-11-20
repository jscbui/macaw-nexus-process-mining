-- 07_construct_data_eva.sql
-- Doel: losse Nexus-registraties omzetten naar duidelijke activiteiten.

-- Rapportbezoeken worden activiteiten
SELECT
    fv.user_key,
    'Rapport bekeken: ' || COALESCE(dr.report_name, 'Onbekend rapport') AS activity,
    fv.start_time AS event_timestamp,
    'report_view' AS event_type,
    dr.report_name,
    NULL AS section_name
FROM fact_report_views fv
LEFT JOIN dim_report dr
    ON fv.report_id = dr.report_id

UNION ALL

-- Sectiebezoeken worden activiteiten
SELECT
    fsv.user_key,
    'Sectie bekeken: ' || COALESCE(ds.section_name, 'Onbekende sectie') AS activity,
    fsv.event_timestamp AS event_timestamp,
    'section_view' AS event_type,
    dr.report_name,
    ds.section_name
FROM fact_report_section_views fsv
LEFT JOIN dim_report_section ds
    ON fsv.report_id = ds.report_id
   AND fsv.section_id = ds.section_id
LEFT JOIN dim_report dr
    ON fsv.report_id = dr.report_id

ORDER BY user_key, event_timestamp;
