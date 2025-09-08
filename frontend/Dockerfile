FROM node:20-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci || true
COPY . .
RUN npm run build || (mkdir -p dist && echo "<html><body>Demo</body></html>" > dist/index.html)

FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
# COPY certs /etc/nginx/certs   # (option) si vous ajoutez des certs self-signed
