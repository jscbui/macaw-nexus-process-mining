
-- 02_data_selection.sql
-- Macaw Nexus Process Mining
-- Doel: controleren welke data beschikbaar is.

-- 1. Aantal rijen per tabel
SELECT 'dim_report' AS tabel, COUNT(*) AS aantal_rijen
FROM dim_report

UNION ALL

SELECT 'dim_report_user', COUNT(*)
FROM dim_report_user

UNION ALL

SELECT 'fact_report_views', COUNT(*)
FROM fact_report_views

UNION ALL

SELECT 'dim_report_section', COUNT(*)
FROM dim_report_section

UNION ALL

SELECT 'fact_report_section_views', COUNT(*)
FROM fact_report_section_views;


-- 2. Beschikbare rapporten
SELECT
    report_id,
    report_name
FROM dim_report
ORDER BY report_name;


-- 3. Beschikbare secties
SELECT
    report_id,
    section_id,
    section_name
FROM dim_report_section
ORDER BY report_id, section_id;
