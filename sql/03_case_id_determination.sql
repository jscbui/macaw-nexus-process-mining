
-- 03_case_id_determination.sql
-- Macaw Nexus Process Mining
-- Doel: onderzoeken hoe gebruikersactiviteiten gekoppeld kunnen worden.

-- 1. Controleer hoeveel activiteiten iedere gebruiker heeft.
SELECT
    user_key,
    COUNT(*) AS aantal_rapportbezoeken,
    MIN(start_time) AS eerste_bezoek,
    MAX(end_time) AS laatste_bezoek
FROM fact_report_views
GROUP BY user_key
ORDER BY aantal_rapportbezoeken DESC;


-- 2. Controleer of gebruikers meerdere rapporten bezoeken.
SELECT
    user_key,
    COUNT(DISTINCT report_id) AS verschillende_rapporten,
    COUNT(*) AS aantal_bezoeken
FROM fact_report_views
GROUP BY user_key
ORDER BY verschillende_rapporten DESC;


-- 3. Controleer het tijdsverschil tussen opeenvolgende rapportbezoeken.
-- Dit helpt onderzoeken of activiteiten mogelijk tot dezelfde sessie behoren.
WITH activiteiten AS (
    SELECT
        user_key,
        report_id,
        start_time,
        end_time,
        LAG(end_time) OVER (
            PARTITION BY user_key
            ORDER BY start_time
        ) AS vorig_einde
    FROM fact_report_views
)
SELECT
    user_key,
    report_id,
    start_time,
    end_time,
    vorig_einde,
    start_time - vorig_einde AS tijd_tussen_activiteiten
FROM activiteiten
ORDER BY user_key, start_time;


-- 4. Controleer of rapport- en sectieactiviteiten aan elkaar te koppelen zijn.
SELECT
    COUNT(*) AS gekoppelde_activiteiten
FROM fact_report_section_views fs
JOIN dim_report_section ds
    ON fs.report_id = ds.report_id
   AND fs.section_id = ds.section_id;
