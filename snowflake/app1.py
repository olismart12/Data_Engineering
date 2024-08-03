import streamlit as st
st.title('Hierarchial Data Viewer')


import pandas as pd
filename = './data/employee-manager-extended.csv'
df = pd.read_csv(filename).convert_dtypes()
st.dataframe(df)

# Get getEdges from graphs.py (hiearchical)
import graphs
graph = graphs.getEdges(df)
st.graphviz_chart(graph)