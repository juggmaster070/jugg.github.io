# Stage 1: Build the static website
FROM node:18-alpine AS builder

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy source files
COPY . .

# Build the static site (outputs to live directory)
RUN npm run live

# Stage 2: Serve with nginx
FROM nginx:alpine

# Copy built static files from builder stage
COPY --from=builder /app/live /usr/share/nginx/html

# Copy custom nginx configuration if needed (optional)
# COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]

