# Use official Golang image as a base
FROM golang:1.21

# Set the working directory inside the container
WORKDIR /app

# Copy go.mod and go.sum first (for dependency caching)
COPY web_socket/src/go.mod web_socket/src/go.sum ./

# Download dependencies
RUN go mod download

# Copy the entire project
COPY web_socket/src .

# Build the Go application
RUN go build -o main .

# Expose the application port
EXPOSE 3001

# Run the application
CMD ["./main"]
