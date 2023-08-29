import pandas as pd
from sqlalchemy import create_engine

# Note: table names and databases should all be lowercase with no special characters

# # Read Excel file
# excel_file = './CovidVaccinations.xlsx'
# df = pd.read_excel(excel_file)

# # Save as CSV
# csv_file = './CovidVaccinations.csv'
# df.to_csv(csv_file, index=False)

connection_string = "postgresql://postgres:POSTGRESQLPASSWORDHERE@localhost:5432/covid" # just change covid to database name in future and add password
engine = create_engine(connection_string)

# Read CSV
csv_file = './CovidVaccinations.csv'
df = pd.read_csv(csv_file)

# Specify desired table name
table_name = 'vaccinations'

# Import data into PostgreSQL
df.to_sql(table_name, con=engine, index=False, if_exists='replace')