-- 08_format_datetime_eva.sql
-- Doel: datum en tijd uniform maken en controleren.

-- 1. Rapportbezoeken tonen met één vast datum/tijd-formaat
SELECT
    user_key,
    report_id,
    TO_CHAR(start_time, 'YYYY-MM-DD HH24:MI:SS') AS start_timestamp,
    TO_CHAR(end_time, 'YYYY-MM-DD HH24:MI:SS') AS end_timestamp,
    dataset_name
FROM fact_report_views
ORDER BY user_key, start_time;


-- 2. Sectiebezoeken tonen met hetzelfde datum/tijd-formaat
SELECT
    user_key,
    report_id,
    section_id,
    TO_CHAR(event_timestamp, 'YYYY-MM-DD HH24:MI:SS') AS event_timestamp
FROM fact_report_section_views
ORDER BY user_key, event_timestamp;


-- 3. Controle op ontbrekende tijden bij rapportbezoeken
SELECT
    COUNT(*) FILTER (WHERE start_time IS NULL) AS ontbrekende_starttijden,
    COUNT(*) FILTER (WHERE end_time IS NULL) AS ontbrekende_eindtijden
FROM fact_report_views;


-- 4. Controle: eindtijd mag niet vóór starttijd liggen
SELECT
    user_key,
    report_id,
    start_time,
    end_time
FROM fact_report_views
WHERE end_time < start_time;


-- 5. Controle op ontbrekende tijd bij sectiebezoeken
SELECT
    COUNT(*) FILTER (WHERE event_timestamp IS NULL) AS ontbrekende_event_tijden
FROM fact_report_section_views;
