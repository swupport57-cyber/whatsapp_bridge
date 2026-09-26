FROM node:20-slim

# ffmpeg for the OGG/Opus conversion.
# ca-certificates + openssl + update-ca-certificates so the Go binary inside
# whatsmeow-node can verify WhatsApp's TLS certificate. The slim image ships
# without a system trust store, which is why the bridge fails to connect.
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      ffmpeg \
      ca-certificates \
      openssl \
 && update-ca-certificates \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY package.json ./
RUN npm install --omit=dev

COPY index.js ./

ENV NODE_ENV=production
EXPOSE 3000

CMD ["node", "index.js"]
