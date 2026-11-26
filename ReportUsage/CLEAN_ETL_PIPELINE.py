from pathlib import Path
import pandas as pd

# Veilige ETL: bronbestanden blijven altijd hetzelfde.
project_map = Path(__file__).resolve().parent
raw_map = project_map.parent.parent / "Nexus - Semester 3" / "02. Data Understanding" / "Raw_data"
output_map = project_map / "ETL_OUTPUT"
output_map.mkdir(exist_ok=True)

def map_of(ids, prefix):
    return {old_id: f"{prefix}_{n}" for n, old_id in enumerate(ids, start=1)}

def resolved_or_unknown(column, mapping):
    return column.map(mapping).fillna("Unknown")

def split_timestamp(df, source, date_col, time_col):
    value = pd.to_datetime(df[source], dayfirst=True, errors="coerce")
    df[date_col] = value.dt.strftime("%d-%m-%Y").where(value.notna(), "Unknown")
    df[time_col] = value.dt.strftime("%H:%M:%S").where(value.notna(), "Unknown")

# EXTRACT: nieuwe lijst plus de oude lijst. De oude bevat ook Model Documentation.
new_reports = pd.read_csv(project_map.parent / "Dim Report v2.csv", sep=";", encoding="utf-8-sig").rename(columns={"ReportGuid": "ReportId"})
old_reports = pd.read_csv(raw_map / "Dim Report.csv", encoding="utf-8-sig")
df_report = pd.concat([new_reports, old_reports], ignore_index=True).drop_duplicates("ReportId")
df_section = pd.read_csv(raw_map / "Dim ReportSection.csv", encoding="utf-8-sig")
df_user = pd.read_csv(raw_map / "Dim ReportUser.csv", encoding="utf-8-sig")
df_section_views = pd.read_csv(raw_map / "Fact ReportSectionViews.csv", encoding="utf-8-sig")
df_report_views = pd.read_csv(raw_map / "Fact ReportViews.csv", encoding="utf-8-sig")

report_map = map_of(df_report["ReportId"], "report")
section_map = map_of(df_section["SectionId"], "reportsection")
user_map = map_of(df_user["UserKey"], "user")

# TRANSFORM: de userdatum in Nederlandse volgorde zetten.
days = {"Monday":"maandag", "Tuesday":"dinsdag", "Wednesday":"woensdag", "Thursday":"donderdag", "Friday":"vrijdag", "Saturday":"zaterdag", "Sunday":"zondag"}
months = {"January":"januari", "February":"februari", "March":"maart", "April":"april", "May":"mei", "June":"juni", "July":"juli", "August":"augustus", "September":"september", "October":"oktober", "November":"november", "December":"december"}
original_date = df_user["_date_to"].copy()
date = pd.to_datetime(df_user["_date_to"], format="%A, %B %d, %Y", errors="coerce")
dutch_date = date.dt.day_name().map(days) + ", " + date.dt.day.astype("Int64").astype(str) + " " + date.dt.month_name().map(months) + " " + date.dt.year.astype("Int64").astype(str)
df_user["_date_to"] = dutch_date.where(date.notna(), original_date)

for df, col, mapping in [(df_report,"ReportId",report_map), (df_section,"ReportId",report_map), (df_section,"SectionId",section_map), (df_user,"UserKey",user_map), (df_user,"Direct Line Manager",user_map), (df_section_views,"ReportId",report_map), (df_section_views,"SectionId",section_map), (df_section_views,"UserKey",user_map), (df_report_views,"ReportId",report_map), (df_report_views,"UserKey",user_map)]:
    df[col] = resolved_or_unknown(df[col], mapping)

split_timestamp(df_section_views, "Timestamp", "Datum", "Tijd")
split_timestamp(df_report_views, "StartTime", "StartDatum", "StartTijd")
split_timestamp(df_report_views, "EndTime", "EindDatum", "EindTijd")

quality = pd.DataFrame([
    {"Dataset":"Fact ReportSectionViews", "Rijen":len(df_section_views), "Exact dubbele rijen":int(df_section_views.duplicated().sum()), "Unknown ReportId":int((df_section_views.ReportId == "Unknown").sum()), "Unknown SectionId":int((df_section_views.SectionId == "Unknown").sum()), "Unknown UserKey":int((df_section_views.UserKey == "Unknown").sum())},
    {"Dataset":"Fact ReportViews", "Rijen":len(df_report_views), "Exact dubbele rijen":int(df_report_views.duplicated().sum()), "Unknown ReportId":int((df_report_views.ReportId == "Unknown").sum()), "Unknown SectionId":"n.v.t.", "Unknown UserKey":int((df_report_views.UserKey == "Unknown").sum())}
])

for name, df in [("Dim_Report_clean.csv",df_report), ("Dim_ReportSection_clean.csv",df_section), ("Dim_ReportUser_clean.csv",df_user), ("Fact_ReportSectionViews_clean.csv",df_section_views), ("Fact_ReportViews_clean.csv",df_report_views), ("Data_quality_report.csv",quality)]:
    df.to_csv(output_map / name, index=False, encoding="utf-8-sig")

print(quality.to_string(index=False))
print(df_section_views[["Timestamp", "Datum", "Tijd"]].head(3).to_string(index=False))
