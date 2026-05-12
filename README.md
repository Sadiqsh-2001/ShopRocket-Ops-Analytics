# 🚀 ShopRocket — E-Commerce Operations Analytics

### _Why is customer satisfaction declining despite revenue growth?_

> End-to-end analytics project built on 100K+ orders using Python, PostgreSQL, and Tableau.  
> Identifies root causes of delivery failures, revenue leakage, and customer dissatisfaction — with actionable business recommendations.

---

## 🧩 The Business Problem

ShopRocket, a Brazilian e-commerce platform, was experiencing a troubling pattern:

- 📦 Order volumes were **growing 8x** from 2017 to 2018
- ⭐ Yet **customer review scores** remained low for a significant portion of orders
- 🚚 **Delivery delays** were frequent but untracked at the carrier and city level
- 💸 **Revenue leakage** from cancellations and SLA breaches had no visibility

**Central Question:**
> _"Where exactly is the operations breakdown happening, and what is its measurable impact on customer satisfaction and revenue?"_

---

## 🔍 How We Solved It — 3-Layer Analysis

### Layer 1 — Delivery Operations: Where is the system failing?

| Finding | Metric |
|---|---|
| Delhivery SLA breach rate | **18.59%** — 3x higher than competitors |
| Salvador city breach rate | **22.65%** — 1 in 4 orders delivered late |
| Distance from Sao Paulo | Directly correlates with delivery degradation |

**Insight:** Delivery failure is not random — it is concentrated in specific carriers and cities.

---

### Layer 2 — Customer Impact: Does delivery failure drive dissatisfaction?

| Review Score | Avg Delivery Days | SLA Breach Rate |
|---|---|---|
| ⭐ 1 star | 20.85 days | 29.36% |
| ⭐⭐⭐ 3 stars | 13.80 days | 13.83% |
| ⭐⭐⭐⭐⭐ 5 stars | 10.22 days | 6.92% |

**Insight:** On-time delivery is the single strongest driver of customer satisfaction. Every day of delay directly reduces review scores.

---

### Layer 3 — Revenue Impact: What is the business cost?

| Metric | Value |
|---|---|
| Orders cancelled or unavailable | **1,234 orders (1.24%)** |
| Top revenue category | health_beauty — **R$1.25M** |
| Highest avg order value | watches_gifts — **R$201/order** |
| Platform revenue growth | **8x in 18 months** |

**Insight:** At scale, even a 1.24% cancellation rate represents significant revenue leakage — concentrated in specific cities and carriers that can be targeted for improvement.

---

## 💡 Business Recommendations

1. **Renegotiate Delhivery SLA contract** — Their 18.59% breach rate vs 6.87% industry average suggests either capacity issues or lack of penalty clauses. Reducing to 7% breach rate would recover ~3,500 at-risk orders annually.

2. **Build city-level delivery monitoring** — Salvador, Porto Alegre, and Rio de Janeiro consistently underperform. Dedicated fulfillment centers or regional carrier partnerships needed.

3. **Prioritize on-time delivery over speed** — Data shows customers reward consistency (5-star = 2.8 days early) more than absolute speed. Set realistic promised delivery days.

---

## 🛠️ Tech Stack

| Tool | Purpose |
|------|---------|
| Python (Pandas, Matplotlib, Seaborn) | Data ingestion, EDA, demand forecasting |
| PostgreSQL + pgAdmin | Data warehousing, 8 business SQL queries |
| Tableau Desktop | Interactive operations dashboard |
| Jupyter Notebook | Analysis notebooks |
| GitHub | Version control & portfolio hosting |

---

## 📁 Project Structure

```
ShopRocket-Ops-Analytics/
│
├── notebooks/
│   ├── 01_data_ingestion.ipynb       # Schema exploration, synthetic column generation
│   ├── 02_eda.ipynb                  # Exploratory Data Analysis & visualizations
│   ├── 03_seller_analysis.ipynb      # Seller segmentation & performance
│   └── 04_demand_forecasting.ipynb   # Facebook Prophet demand forecasting
│
├── sql_queries/
│   └── shoprocket_analysis_queries.sql  # 8 business SQL queries with insights
│
├── dashboard/
│   ├── ShopRocket_Dashboard.twbx     # Tableau packaged workbook
│   └── dashboard_preview.png         # Dashboard screenshot
│
├── data/                             # Dataset instructions (CSVs excluded)
└── README.md
```

---

## 📊 Dashboard Preview

![ShopRocket Dashboard](dashboard/dashboard_preview.png)

---

## 📓 Notebooks Summary

| # | Notebook | Key Output |
|---|---|---|
| 01 | data_ingestion | Cleaned dataset, synthetic carrier & SLA columns |
| 02 | eda | 7 business charts, delivery & revenue trends |
| 03 | seller_analysis | Seller tier segmentation, performance ranking |
| 04 | demand_forecasting | Facebook Prophet model, demand predictions |

---

## 🗄️ Dataset

- Source: [Olist Brazilian E-Commerce — Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)
- Size: 99,441 orders | 112,650 order items | 99,224 reviews | 3,095 sellers
- Place CSVs in `data/processed/` folder before running notebooks

---

## ✅ Project Status

🟢 **Complete** — Python notebooks, PostgreSQL queries, Tableau dashboard

---

## 👤 Author

**Sadique Shoaib**  
Data Analyst | Bengaluru, India  
[GitHub](https://github.com/Sadiqsh-2001) • [LinkedIn](https://www.linkedin.com/in/sadique-shoaib)
