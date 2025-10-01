# Multi-stage build for Foodie Vue.js app
# Stage 1: Build the application
FROM node:20-alpine AS build-stage

# Set working directory
WORKDIR /app

# Copy package files for better Docker layer caching
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy source code
COPY . .

# Build the application for production
RUN npm run build

# Stage 2: Production stage with Nginx
FROM nginx:alpine AS production-stage

# Copy the build output to nginx html directory
COPY --from=build-stage /app/dist /usr/share/nginx/html

# Copy custom nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 80
EXPOSE 80

# Start nginx in foreground
CMD ["nginx", "-g", "daemon off;"]