FROM mongo:8.0

RUN openssl rand -base64 756 > /data/configdb/keyfile
RUN chown mongodb:mongodb /data/configdb/keyfile
RUN chmod 400 /data/configdb/keyfile
