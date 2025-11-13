FROM node:18 AS build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Serve React build with Nginx
# ... your existing build stage remains the same

FROM nginx:stable-alpine
COPY --from=build /app/build /usr/share/nginx/html

# overwrite default nginx config to add pro

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]


