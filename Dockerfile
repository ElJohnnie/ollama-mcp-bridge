FROM node:18

WORKDIR /app

RUN npm install -g @modelcontextprotocol/server-filesystem \
    @modelcontextprotocol/server-brave-search \
    @modelcontextprotocol/server-github \
    @modelcontextprotocol/server-memory

COPY .env package.json package-lock.json tsconfig.json ./
COPY tests ./tests

RUN npm install

COPY src/ ./src/

COPY bridge_config.json ./bridge_config.json

RUN npm run build

RUN mkdir -p /app/workspace
VOLUME /app/workspace

EXPOSE 3000

CMD ["node", "dist/main.js"]