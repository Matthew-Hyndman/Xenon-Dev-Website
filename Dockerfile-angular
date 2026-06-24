# syntax=docker/dockerfile:1

# FROM node:20-Its-alpine AS build
FROM node:20-alpine AS build
WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .

# for local Evironment
RUN npm run build:local

# for development Environment
# RUN npm run build:Dev

# for production Environment
# RUN npm run build:main

FROM nginx:1-alpine-slim AS runtime

COPY docker/nginx/default.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/dist/amplify-angular-template/browser /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
