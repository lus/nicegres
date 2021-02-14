FROM postgres
COPY create-setups.sh /docker-entrypoint-initdb.d
