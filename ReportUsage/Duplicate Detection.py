import pandas as pd
# FEIT REPORTSECTIONVIEWS
df = pd.read_csv("Fact ReportSectionViews.csv")
duplicates = df.duplicated()

print("Dubbele waardes, Feit ReportSectionViews:")
print(df[duplicates])

# DIM REPORT
df2 = pd.read_csv("Dim Report.csv")
duplicates2 = df2.duplicated()

print("\n\nDubbele waardes, Dimensie Report:")
print(df2[duplicates2])

# DIM REPORTUSER
df3 = pd.read_csv("Dim ReportUser.csv")
duplicates3 = df3.duplicated()

print("\nDubbele waardes, Dimensie Report User:")
print(df3[duplicates3])

# DIM REPORTSECTION
df4 = pd.read_csv("Dim ReportSection.csv")
duplicates4 = df4.duplicated()

print("\nDubbele waardes, Dimensie Report Section:")
print(df4[duplicates4])

# FACT REPORTVIEWS
df5 = pd.read_csv("Fact ReportViews.csv")
duplicates5 = df5.duplicated()

print("\nDubbele waardes, Feit Report Views:")
print(df5[duplicates5])



# Verwijderen dubbele waardes
df_unique = df.drop_duplicates()
df_unique.to_csv("Fact ReportSectionViews_geendupes.csv", index=False)

# Maken datasets zonder dubbele waardes
df_new = pd.read_csv("Fact ReportSectionViews_geendupes.csv")
duplicates_new = df_new.duplicated()

print("\n\nDubbele waardes? nieuwe Report Section views:")
print(df2[duplicates2])
