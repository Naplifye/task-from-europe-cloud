FROM mongo:8.0.13

RUN mkdir -p /etc/mongodb/pki

RUN openssl rand -base64 756 > /etc/mongodb/pki/keyfile
RUN chown mongodb:mongodb /etc/mongodb/pki/keyfile 
RUN chmod 400 /etc/mongodb/pki/keyfile 
