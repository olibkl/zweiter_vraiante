FROM node:24-alpine AS build
WORKDIR /app

ARG VITE_PLAN_DATA_MODE=local
ARG VITE_PLAN_API_BASE_URL=

COPY package.json package-lock.json ./
RUN npm ci

COPY . .
ENV VITE_PLAN_DATA_MODE=${VITE_PLAN_DATA_MODE}
ENV VITE_PLAN_API_BASE_URL=${VITE_PLAN_API_BASE_URL}
RUN npm run build

FROM nginx:1.27-alpine
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
