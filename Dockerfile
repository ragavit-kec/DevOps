# Use the official Nginx image
FROM nginx:alpine

# Set working directory inside the container
WORKDIR /usr/share/nginx/html

# Remove default Nginx content
RUN rm -rf ./*

# Copy the HTML, CSS, and JS files into the Nginx HTML directory
COPY ./bakery/index.html ./
COPY ./bakery/about.html ./
COPY ./bakery/bakers.html ./
COPY ./bakery/style.css ./
COPY ./bakery/js/app.js ./js/

# Copy images directory to the Nginx HTML folder (if you have images)
COPY ./bakery/images /usr/share/nginx/html/images/

# Expose port 80 for the container
EXPOSE 80

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]
