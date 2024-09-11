# Use an official Ubuntu image as the base
FROM ubuntu:20.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary dependencies (adjust this based on your actual project needs)
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    nodejs \
    npm \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json for dependency installation
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Run the build-assets command (replace with your actual build command)
RUN npm run build-assets

# Define a volume to share the output with the host file system
VOLUME ["/app/dist"]

# Entry point (optional, could be used if you want the container to keep running)
CMD ["bash"]
