FROM node:22-trixie

WORKDIR /usr/local/nodeapp

COPY package.json .
COPY nodeapp.js .
COPY models ./models
COPY views ./views

RUN npm install .

CMD ["node", "nodeapp.js"]