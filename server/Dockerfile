FROM node:18

# Set working directory
WORKDIR /app

# Copy package.json first to install dependencies
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy rest of the code
COPY . .

# Expose port 4000
EXPOSE 4000

# Start backend server
CMD ["node", "index.js"]




