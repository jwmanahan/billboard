import streamlit as st # pip install running into an error on Windows
import duckdb

conn = duckdb.connect(database = 'raw_db.duckdb', read_only=True)

st.set_page_config(layout = 'wide')

st.title('Test: Billboard top 50')
