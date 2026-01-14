import pandas as pd
import matplotlib.pyplot as plt

# ===============================
# LOAD DATA
# ===============================
beneficiaries = pd.read_csv("../exports/beneficiaries.csv")
aid = pd.read_csv("../exports/aid_distribution.csv")
impact = pd.read_csv("../exports/post_aid_impact.csv")

print("Data loaded successfully")

# ===============================
# BASIC CLEANING
# ===============================
impact.dropna(inplace=True)

# ===============================
# TOTAL METRICS
# ===============================
total_beneficiaries = beneficiaries['beneficiary_id'].nunique()
total_aided = aid['beneficiary_id'].nunique()
improved_count = impact[impact['employed'] == 'Yes'].shape[0]
struggling_count = impact[impact['struggling'] == 'Yes'].shape[0]

impact_percentage = (improved_count / total_aided) * 100 if total_aided > 0 else 0

print("Total Beneficiaries:", total_beneficiaries)
print("Total Aided:", total_aided)
print("Improved After Aid:", improved_count)
print("Impact Percentage:", round(impact_percentage, 2), "%")

# ===============================
# VISUALIZATION 1: IMPACT STATUS
# ===============================
status_counts = impact['employed'].value_counts()

plt.figure()
status_counts.plot(kind='bar')
plt.title("Employment Improvement After Aid")
plt.xlabel("Employment Improved")
plt.ylabel("Number of Beneficiaries")
plt.show()

# ===============================
# VISUALIZATION 2: STRUGGLING STATUS
# ===============================
struggle_counts = impact['struggling'].value_counts()

plt.figure()
struggle_counts.plot(kind='bar')
plt.title("Beneficiaries Still Struggling")
plt.xlabel("Struggling Status")
plt.ylabel("Number of Beneficiaries")
plt.show()

# ===============================
# PROGRAM-WISE IMPACT ANALYSIS
# ===============================
merged_data = beneficiaries.merge(
    impact, on="beneficiary_id", how="inner"
)

program_impact = merged_data.groupby("program_id")['employed'] \
    .apply(lambda x: (x == 'Yes').sum())

plt.figure()
program_impact.plot(kind='bar')
plt.title("Program-wise Impact Analysis")
plt.xlabel("Program ID")
plt.ylabel("Improved Beneficiaries")
plt.show()

print("Impact analysis completed successfully")
