
-- 04_event_log_validation.sql
-- Macaw Nexus Process Mining
-- Doel: controleren of de activiteiten geschikt zijn voor een event log.

-- 1. Controleer ontbrekende waarden in rapportbezoeken
SELECT
    COUNT(*) AS totaal,
    COUNT(*) FILTER (WHERE user_key IS NULL) AS ontbrekende_user_key,
    COUNT(*) FILTER (WHERE report_id IS NULL) AS ontbrekende_report_id,
    COUNT(*) FILTER (WHERE start_time IS NULL) AS ontbrekende_starttijd,
    COUNT(*) FILTER (WHERE end_time IS NULL) AS ontbrekende_eindtijd
FROM fact_report_views;

-- 2. Controleer of eindtijd vóór starttijd ligt
SELECT *
FROM fact_report_views
WHERE end_time < start_time;

-- 3. Controleer of activiteiten hetzelfde tijdstip hebben
SELECT user_key, start_time, COUNT(*) AS aantal
FROM fact_report_views
GROUP BY user_key, start_time
HAVING COUNT(*) > 1
ORDER BY aantal DESC;

-- 4. Controleer ontbrekende waarden in sectiebezoeken
SELECT
    COUNT(*) AS totaal,
    COUNT(*) FILTER (WHERE user_key IS NULL) AS ontbrekende_user_key,
    COUNT(*) FILTER (WHERE report_id IS NULL) AS ontbrekende_report_id,
    COUNT(*) FILTER (WHERE section_id IS NULL) AS ontbrekende_section_id,
    COUNT(*) FILTER (WHERE event_timestamp IS NULL) AS ontbrekende_timestamp
FROM fact_report_section_views;

-- 5. Controleer of sectiebezoeken bij een bekende rapportsectie horen
SELECT COUNT(*) AS sectiebezoeken_zonder_match
FROM fact_report_section_views fs
LEFT JOIN dim_report_section ds
    ON fs.report_id = ds.report_id
   AND fs.section_id = ds.section_id
WHERE ds.section_id IS NULL;
