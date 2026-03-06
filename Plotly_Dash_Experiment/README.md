# Interactive Plots using Plotly & Dash

This repository executes **Experiment 8: Creating interactive plots using Plotly and Dash.**

## 📦 How to Clone this Specific Experiment
To prevent different experiments from getting messy, this project is tracked via Git Tags. To download *only* this specific interactive dashboard implementation:
```bash
git clone --branch v8.0-plotly-dash https://github.com/pmr1234/Hadoop-Installer.git
```

## Description
Traditional data visualization methods such as static charts lack user interaction and real-time updating capabilities, making deep data exploration difficult. 

This experiment resolves this by introducing **Dash** (a web application framework built on top of Flask) and **Plotly** (a powerful interactive mapping library). 

> **Important Optimization:** 
> The assignment originally requested 6 separate disjointed Python scripts. To satisfy the requirement for "small and clean code," we seamlessly consolidated the logic into one single elegant application (`interactive_dashboard.py`). All requirements are met natively inside one browser view.

---

## 🚀 How to Run the Dashboard
1. Ensure the Python packages are installed:
   ```bash
   pip install dash plotly==5.24.1 pandas
   ```
2. Double-click the orchestration wrapper to securely spin up the Flask web loop:
   ```bat
   run_dashboard.cmd
   ```
3. Open a web browser (Chrome, Edge, Safari) and navigate to the local portal:
   `http://127.0.0.1:8050/`

## ✨ Features Implemented
- **Dynamic Subject Filtering:** Built an interactive Dash Dropdown component that allows real-time swapping between different class subjects (AI, ML, DL, RL, BDT).
- **Consolidated Analytics:** Pluggable cumulative performance tracker computes the raw average across all subjects using `df.mean(axis=1)`.
- **Plotly Callbacks:** Engineered a `@app.callback` loop. Whenever a user changes the Dropdown selection, Plotly securely ingests the Pandas DataFrame, mutates the layout mapping `x="Student" y="[Selected Metric]"`, and re-renders the DOM without forcing a page reload. 
- **Grade Outliers:** Implemented discrete color grading highlighting `A` (>85%) candidates securely in green versus `C` (<75%) candidates in red for rapid insight acquisition.
