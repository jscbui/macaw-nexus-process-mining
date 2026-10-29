import pandas as pd

df = pd.read_csv("Fact ReportSectionViews.csv")
duplicates = df.duplicated()

# Voor de verwijdering
print("Dubbele waardes:")
print(df[duplicates])

# Verwijdering + na verwijdering
df_unique = df.drop_duplicates()
df_unique.to_csv("Fact ReportSectionViews_geendupes.csv", index=False)

df2 = pd.read_csv("Fact ReportSectionViews_geendupes.csv")
duplicates2 = df2.duplicated()
print("Dubbele waardes?:")
print(df2[duplicates2])
