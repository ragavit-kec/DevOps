# Use the official Nginx image
FROM nginx:alpine

# Install git to clone the repository
RUN apk update && apk add --no-cache git

# Set working directory
WORKDIR /usr/share/nginx/html

# Remove default Nginx files
RUN rm -rf ./*

# Clone the GitHub repository
RUN git clone https://github.com/ragavit-kec/DevOps.git /tmp/devops

# Copy the contents of the Bakery folder into the Nginx HTML directory
RUN cp -r /tmp/devops/Bakery/* /usr/share/nginx/html/

# Expose port 80 (inside container)
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
