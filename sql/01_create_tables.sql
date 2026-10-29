
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

