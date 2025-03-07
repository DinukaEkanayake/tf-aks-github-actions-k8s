# Build Stage
FROM node:18-alpine AS build
WORKDIR /app
#from local to container
COPY frontend-app/package*.json .
RUN npm install
COPY frontend-app/ .
RUN npm run build
 
# Production Stage
FROM nginx:stable-alpine AS production
COPY --from=build /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]