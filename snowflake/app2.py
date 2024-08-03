import json
import streamlit as st
import pandas as pd
import streamlit.components_v1 as components
import graphs, formats, charts, animated

st.set_page_config(layout='wide')
st.title('Hierarchial Data Viewer')
st.caption('Display your hieararchial data with charts and graphs.')

tabSource, tabFormat, tabGraph, tabChart, TabAnim = st.tabs(
    ['Source', 'Format', 'Graph', 'Chart', 'Animated'])

with tabSource:
    filename = './data/employee-manager-extended.csv'
    df = pd.read_csv(filename).convert_dtypes()
    st.dataframe(df)

with tabFormat:
    sel = st.selectbox(
        "Select a data format:",
        options=["JSON", "XML", "YAML", "JSON Path"])

    root = formats.getJson(df)
    if sel == "JSON":
        jsn = json.dumps(root, indent=2)
        st.code(jsn, language="json", line_numbers=True)
    elif sel == "XML":
        xml = formats.getXml(root)
        st.code(xml, language="xml", line_numbers=True)
    elif sel == "YAML":
        yaml = formats.getYaml(root)
        st.code(yaml, language="yaml", line_numbers=True)
    elif sel == "JSON Path":
        jsn = json.dumps(formats.getPath(root, []), indent=2)
        st.code(jsn, language="json", line_numbers=True)


with tabGraph:
    graph = graphs.getEdges(df)
    url = graphs.getUrl(graph)
    st.link_button('Visualise Online', url)
    st.graphviz_chart(graph)

with tabChart:
    labels = df[df.columns[0]]
    parents = df[df.columns[1]]

    sel = st.selectbox(
        'Select a chart type:',
        options=['Treemap', 'Icicle', 'Sunburst', 'Sankey'])
    if sel == 'Treemap':
        fig = charts.makeTreemap(labels, parents)
    elif sel == 'Icicle':
        fig = charts.makeIcicle(labels, parents)
    elif sel == 'Sunburst':
        fig = charts.makeSunburst(labels, parents)
    else:
        fig = charts.makeSankey(labels, parents)
    st.plotly_chart(fig, use_container_width=True)

with tabAnim:
    sel = st.selectbox(
        "Select a D3 chart type:",
        options=["Collapsible Tree", "Linear Dendrogram",
            "Radial Dendrogram", "Network Graph"])
    if sel == "Collapsible Tree":
        filename = animated.makeCollapsibleTree(df)
    elif sel == "Linear Dendrogram":
        filename = animated.makeLinearDendrogram(df)
    elif sel == "Radial Dendrogram":
        filename = animated.makeRadialDendrogram(df)
    elif sel == "Network Graph":
        filename = animated.makeNetworkGraph(df)

    with open(filename, 'r', encoding='utf-8') as f:
        components.html(f.read(), height=2200, width=1000)
