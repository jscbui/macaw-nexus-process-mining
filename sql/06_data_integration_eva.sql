-- 06_data_integration_eva.sql
-- Doel: Nexus-tabellen koppelen en controleren of de relaties kloppen.

-- 1. Rapportbezoeken koppelen aan rapport- en gebruikersinformatie
SELECT
    fv.user_key,
    dr.report_name,
    fv.start_time,
    fv.end_time,
    fv.dataset_name,
    du.professional_level,
    du.team
FROM fact_report_views fv
LEFT JOIN dim_report dr
    ON fv.report_id = dr.report_id
LEFT JOIN dim_report_user du
    ON fv.user_key = du.user_key
ORDER BY fv.user_key, fv.start_time;


-- 2. Sectiebezoeken koppelen aan sectie-, rapport- en gebruikersinformatie
SELECT
    fsv.user_key,
    dr.report_name,
    ds.section_name,
    fsv.event_timestamp,
    du.professional_level,
    du.team
FROM fact_report_section_views fsv
LEFT JOIN dim_report_section ds
    ON fsv.report_id = ds.report_id
   AND fsv.section_id = ds.section_id
LEFT JOIN dim_report dr
    ON fsv.report_id = dr.report_id
LEFT JOIN dim_report_user du
    ON fsv.user_key = du.user_key
ORDER BY fsv.user_key, fsv.event_timestamp;


-- 3. Controle: rapportbezoeken zonder passend rapport
SELECT COUNT(*) AS rapportbezoeken_zonder_match
FROM fact_report_views fv
LEFT JOIN dim_report dr
    ON fv.report_id = dr.report_id
WHERE dr.report_id IS NULL;


-- 4. Controle: sectiebezoeken zonder passende sectie
SELECT COUNT(*) AS sectiebezoeken_zonder_match
FROM fact_report_section_views fsv
LEFT JOIN dim_report_section ds
    ON fsv.report_id = ds.report_id
   AND fsv.section_id = ds.section_id
WHERE ds.section_id IS NULL;
