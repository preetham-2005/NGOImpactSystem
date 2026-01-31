import pandas as pd
import matplotlib.pyplot as plt

plt.switch_backend('TkAgg')

beneficiaries = pd.read_csv("../exports/beneficiaries.csv")
aid = pd.read_csv("../exports/aid_distribution.csv")
impact = pd.read_csv("../exports/post_aid_impact.csv")

# Clean Yes/No values
impact['employed'] = impact['employed'].astype(str).str.strip().str.capitalize()
impact['struggling'] = impact['struggling'].astype(str).str.strip().str.capitalize()

print("Data loaded successfully")

# TOTAL METRICS
total_beneficiaries = beneficiaries['beneficiary_id'].nunique()
total_aided = aid['beneficiary_id'].nunique()
improved_count = impact[impact['employed'] == 'Yes'].shape[0]

total_impact_records = impact.shape[0]
impact_percentage = (improved_count / total_impact_records) * 100 if total_impact_records > 0 else 0

print("Impact Percentage:", round(impact_percentage, 2), "%")

# Employment Improvement Graph
plt.figure()
impact['employed'].value_counts(dropna=False).plot(kind='bar')
plt.title("Employment Improvement After Aid")
plt.show()

# Struggling Graph
plt.figure()
impact['struggling'].value_counts(dropna=False).plot(kind='bar')
plt.title("Beneficiaries Still Struggling")
plt.show()

# Program-wise Impact
merged_data = beneficiaries.merge(impact, on="beneficiary_id", how="left")

program_impact = merged_data.groupby("program_id")['employed'] \
    .apply(lambda x: (x == 'Yes').sum())

plt.figure()
program_impact.plot(kind='bar')
plt.title("Program-wise Impact Analysis")
plt.show()

print("Impact analysis completed successfully")
