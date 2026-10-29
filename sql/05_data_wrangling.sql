
-- 05_data_wrangling.sql
-- Macaw Nexus Process Mining
-- Doel: rapportbezoeken voorbereiden voor het event log.

-- 1. Maak een overzicht van rapportbezoeken met rapportnamen
SELECT
    fv.user_key,
    fv.report_id,
    dr.report_name,
    fv.start_time,
    fv.end_time,
    fv.dataset_name
FROM fact_report_views fv
LEFT JOIN dim_report dr
    ON fv.report_id = dr.report_id
ORDER BY fv.user_key, fv.start_time;

-- 2. Controleer de duur van rapportbezoeken
SELECT
    user_key,
    report_id,
    start_time,
    end_time,
    end_time - start_time AS bezoekduur
FROM fact_report_views
WHERE start_time IS NOT NULL
  AND end_time IS NOT NULL
ORDER BY bezoekduur DESC;

-- 3. Bereid opeenvolgende rapportbezoeken per gebruiker voor
SELECT
    user_key,
    report_id,
    start_time,
    end_time,
    LAG(report_id) OVER (
        PARTITION BY user_key
        ORDER BY start_time
    ) AS vorig_report_id,
    LAG(end_time) OVER (
        PARTITION BY user_key
        ORDER BY start_time
    ) AS vorig_einde
FROM fact_report_views
ORDER BY user_key, start_time;
