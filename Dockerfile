# Use the official Nginx image
FROM nginx:alpine

# Set working directory
WORKDIR /usr/share/nginx/html

# Remove default Nginx files
RUN rm -rf ./*

# Copy all files from the Bakery folder into the container
COPY . /usr/share/nginx/html

# Expose port 80 (inside container)
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
