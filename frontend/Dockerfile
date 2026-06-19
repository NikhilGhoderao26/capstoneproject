### Multi-stage production build for React app
FROM node:18-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci --silent
COPY . .
RUN npm run build

FROM nginx:stable-alpine
COPY --from=build /app/build /usr/share/nginx/html
# Optional: provide a custom nginx conf if needed (using default for now)
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
