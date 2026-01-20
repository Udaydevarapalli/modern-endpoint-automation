# SCCM Model-Based Hardware Inventory Report (SQL)

This SQL query is designed for Microsoft SCCM / MECM environments to generate **model-based hardware inventory reports**.

It is useful for identifying specific device models for:
- Hardware lifecycle planning
- Model-targeted application deployments
- OS upgrade readiness (e.g., Windows 11)
- Driver or BIOS targeting
- Compliance and troubleshooting

---

## 📌 What This Query Reports

The query returns the following details:
- Device Name
- Last Logged-On User
- Manufacturer
- Model
- SCCM Client Version
- Operating System
- Last Logon Timestamp
- Active Directory Site

It filters results to **specific HP device models**, but can be easily customized.

---

## 🧩 Data Sources Used

- `v_R_System`
- `v_GS_COMPUTER_SYSTEM`

These views ensure the report reflects **current client inventory data**.

---

## 🛠 Customization Notes

You can modify the model filters in the `WHERE` clause to match your environment, for example:

```sql
CS.Model0 LIKE '%EliteBook%'
CS.Model0 LIKE '%ProBook%'
CS.Model0 LIKE '%EliteDesk%'
