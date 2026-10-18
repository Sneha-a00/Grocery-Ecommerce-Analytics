# Grocery E-Commerce Analytics

## Project Overview
This capstone project analyzes online grocery shopping data to understand customer purchasing behavior, product reordering, customer segmentation, cross-selling opportunities, and shopping patterns.

## Tools Used
- **DuckDB / SQL:** Data querying and analysis
- **Python:** Data analysis and reorder prediction
- **Power BI:** Interactive dashboard and business insights

## Business Questions
1. Which products have the highest reorder rates?
2. How can customers be segmented by shopping behavior?
3. Which products are frequently purchased together?
4. When do customers place orders?
5. Can historical purchasing behavior help predict future reorders?

## Key Findings
- Bananas had an 84.35% reorder rate in the analyzed purchase records.
- Loyal customers had the highest average reorder rate among the identified customer segments.
- Frequently purchased product pairs revealed opportunities for cross-selling.
- Customer order frequency helped identify groups with different retention opportunities.
- The reorder prediction model highlighted the importance of purchase recency and reorder history.

## Project Files
- `grocery_analysis.sql` — SQL analysis
- Python notebook — analysis and model development
- CSV files — KPI summaries, customer segments, product pairs, demand patterns, and model results

## Dashboard
The Power BI dashboard contains four pages:
1. Executive Overview
2. Customer Segmentation & Retention
3. Product & Reorder Insights
4. Demand & Retention Insights

## Business Recommendations
- Prioritize popular repeat-purchase products in inventory planning.
- Use relevant product recommendations to encourage cross-selling.
- Develop targeted campaigns for occasional and developing customers.
- Use shopping patterns to support operational planning.
- Evaluate prediction-model performance before using it for automated decisions.

## Limitations
The reorder model had low precision, so its predictions should be improved and validated before being used in business operations.

---
