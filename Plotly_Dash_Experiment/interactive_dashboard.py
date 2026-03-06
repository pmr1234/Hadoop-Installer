import pandas as pd
from dash import Dash, dcc, html, Input, Output
import plotly.express as px

# =====================================================================
# Experiment 8: Interactive Plotly & Dash Dashboard (Optimized Version)
# =====================================================================

# 1. Dataset Initialization
data = {
    "Student Name": [
        "Aarav", "Diya", "Rahul", "Sneha", "Karthik", "Ananya", "Vikram", "Pooja", "Rohit", "Meena",
        "Suresh", "Kavya", "Arjun", "Nisha", "Manoj", "Priya", "Amit", "Neha", "Ravi", "Lakshmi",
        "Sanjay", "Divya", "Nitin", "Swathi", "Deepak", "Bhavya", "Harsha", "Isha", "Varun", "Keerthi"
    ],
    "AI":  [85,78,90,88,76,92,80,84,75,89,82,91,87,79,74,86,90,83,77,88,81,92,78,85,80,87,84,89,76,90],
    "ML":  [82,75,88,85,74,90,78,81,72,87,80,89,85,76,72,84,88,80,75,86,79,90,76,83,78,85,82,87,74,88],
    "DL":  [80,72,85,82,70,88,75,79,70,85,78,87,83,74,70,82,85,78,72,84,76,88,73,80,75,83,79,85,71,86],
    "RL":  [78,70,82,80,68,85,72,76,68,82,75,84,80,72,68,78,82,75,70,80,74,85,71,78,72,80,76,82,69,84],
    "BDT": [84,76,89,86,75,91,79,83,74,88,81,90,86,78,73,85,89,82,76,87,80,91,77,84,79,86,83,88,75,89]
}

df = pd.DataFrame(data)

# Calculate dynamic averages and grades globally so it's ready for any callbacks
df["Percentage"] = df[["AI", "ML", "DL", "RL", "BDT"]].mean(axis=1).round(1)

def assign_grade(p):
    if p >= 85: return "A"
    elif p >= 75: return "B"
    else: return "C"

df["Grade"] = df["Percentage"].apply(assign_grade)


# 2. Main Dash Web Application Setup
app = Dash(__name__)

# 3. Create Sleek User Interface Layout
app.layout = html.Div(
    style={"width": "80%", "margin": "auto", "fontFamily": "Segoe UI, Tahoma, Geneva, Verdana, sans-serif"},
    children=[
        
        # Header Section
        html.Div(
            style={"textAlign": "center", "padding": "20px", "backgroundColor": "#f8f9fa", "borderRadius": "10px", "marginBottom": "20px"},
            children=[
                html.H1("Student Academic Performance Dashboard", style={"color": "#2c3e50"}),
                html.P("Experiment 8: Interactive Data Visualization using Plotly & Dash", style={"color": "#7f8c8d"})
            ]
        ),
        
        # Interactive Controls
        html.Div(
            style={"display": "flex", "justifyContent": "space-around", "padding": "20px", "backgroundColor": "#ffffff", "boxShadow": "0 4px 8px rgba(0,0,0,0.1)", "borderRadius": "10px"},
            children=[
                
                # Subject Selector
                html.Div(
                    style={"width": "45%"},
                    children=[
                        html.Label("Analysis Mode: View Subject Target", style={"fontWeight": "bold", "marginBottom": "10px", "display": "block"}),
                        dcc.Dropdown(
                            id="subject-dropdown",
                            options=[
                                {"label": "Artificial Intelligence (AI)", "value": "AI"},
                                {"label": "Machine Learning (ML)", "value": "ML"},
                                {"label": "Deep Learning (DL)", "value": "DL"},
                                {"label": "Reinforcement Learning (RL)", "value": "RL"},
                                {"label": "Big Data Technology (BDT)", "value": "BDT"},
                                {"label": "Cumulative Percentage", "value": "Percentage"}
                            ],
                            value="AI",
                            clearable=False,
                            style={"width": "100%", "cursor": "pointer"}
                        )
                    ]
                )
            ]
        ),
        
        # Graphing Canvas
        html.Div(
            style={"marginTop": "30px", "backgroundColor": "#ffffff", "padding": "20px", "boxShadow": "0 4px 8px rgba(0,0,0,0.1)", "borderRadius": "10px"},
            children=[
                dcc.Graph(id="interactive-graph")
            ]
        )
    ]
)


# 4. Interactive Callbacks (Real-time update logic)
@app.callback(
    Output("interactive-graph", "figure"),
    Input("subject-dropdown", "value")
)
def update_dashboard(selected_metric):
    """
    Dynamically renders a Plotly Bar Chart whenever the user changes the dropdown.
    """
    
    # Generate the bar chart figure
    fig = px.bar(
        df,
        x="Student Name",
        y=selected_metric,
        color="Grade",
        color_discrete_map={"A": "#2ecc71", "B": "#f1c40f", "C": "#e74c3c"},
        title=f"Class Performance: {selected_metric}",
        hover_data={"Percentage": True, "Grade": True}
    )
    
    # Customize layout to look clean
    fig.update_layout(
        xaxis_title="Student Directory",
        yaxis_title="Metric Score",
        xaxis_tickangle=-45,
        yaxis_range=[60, 100],
        plot_bgcolor="white",
        paper_bgcolor="white",
        margin=dict(t=50, b=100, l=50, r=50)
    )
    
    fig.update_yaxes(showgrid=True, gridwidth=1, gridcolor='LightGray')
    
    return fig


# 5. Launch the Web Server
if __name__ == "__main__":
    print("\n[INFO] Starting Dash Server! Open http://127.0.0.1:8050/ in your browser.\n")
    app.run(debug=True, use_reloader=False) 
