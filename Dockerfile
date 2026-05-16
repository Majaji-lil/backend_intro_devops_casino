# ---------- Stage 1: Dependencias ----------
FROM node:20-alpine AS deps

WORKDIR /app

COPY package*.json ./

RUN npm install --omit=dev

# ---------- Stage 2: Runtime ----------
FROM node:20-alpine

WORKDIR /app

COPY --from=deps /app/node_modules ./node_modules
COPY . .

ENV NODE_ENV=production

EXPOSE 3000

# Usuario no root
USER node

# Healthcheck
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s CMD wget --quiet --tries=1 --spider http://localhost:3000/health || exit 1

CMD ["npm", "start"]