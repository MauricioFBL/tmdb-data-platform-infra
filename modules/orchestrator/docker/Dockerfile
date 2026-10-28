FROM apache/airflow:3.3.2-python3.12

RUN pip install --no-cache-dir \
    "apache-airflow==3.3.2" \
    "apache-airflow-providers-amazon" \
    "apache-airflow-providers-postgres" \
    --constraint \
    "https://raw.githubusercontent.com/apache/airflow/constraints-3.3.2/constraints-3.12.txt"