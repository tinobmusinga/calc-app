# -------------------------------
# 1. Build React frontend (Vite)
# -------------------------------
FROM node:18 AS frontend-build

WORKDIR /app/front-end
COPY front-end/package*.json ./
RUN npm install
COPY front-end/ ./
RUN npm run build   # outputs static files to /app/front-end/dist

# -------------------------------
# 2. Prepare backend
# -------------------------------
FROM node:18-slim AS backend

WORKDIR /app

# Copy backend dependencies
COPY back-end/package*.json ./back-end/
WORKDIR /app/back-end
RUN npm install --production

# Copy backend source code
COPY back-end/ ./ 

# Copy built frontend into backend (so backend can serve static files)
COPY --from=frontend-build /app/front-end/dist ./public

# Expose port 8080 for Cloud Run
EXPOSE 8080

# Start backend server
CMD ["node", "server.js"]
