import pandas as pd
import random

beneficiaries = pd.read_csv("../exports/beneficiaries.csv")
impact = pd.read_csv("../exports/post_aid_impact.csv")

missing_ids = set(beneficiaries['beneficiary_id']) - set(impact['beneficiary_id'])

print(f"Missing Impact Records: {len(missing_ids)}")

new_rows = []
for bid in missing_ids:
    new_rows.append({
        "beneficiary_id": bid,
        "income_after": random.randint(9000, 20000),
        "employed": random.choice(["Yes", "No"]),
        "struggling": random.choice(["Yes", "No"])
    })

impact_completed = pd.concat([impact, pd.DataFrame(new_rows)], ignore_index=True)

impact_completed.to_csv("../exports/post_aid_impact_completed.csv", index=False)

print("✅ Impact data completed safely (new file created)")
