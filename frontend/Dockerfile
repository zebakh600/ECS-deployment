FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install --silent
COPY . .
# API URL injected at build time
ARG REACT_APP_API_URL
ENV REACT_APP_API_URL=$REACT_APP_API_URL
RUN npm run build
 
FROM nginx:alpine
COPY --from=builder /app/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

# FROM node:18-alpine AS builder
# WORKDIR /app
# COPY package*.json ./
# RUN npm install --silent
# COPY . .
# ENV REACT_APP_API_URL=https://ecs.zeba.click
# RUN npm run build

# FROM nginx:alpine
# COPY --from=builder /app/build /usr/share/nginx/html
# COPY nginx.conf /etc/nginx/conf.d/default.conf
# EXPOSE 80
# CMD ["nginx", "-g", "daemon off;"]