# Start from the latest golang base image
FROM golang:latest as builder

# Add maintainer info
LABEL maintainer="Alejandro Rodríguez <aj.softwaredeveloper@gmail.com>"

# Set the Current Working Directory inside the container
WORKDIR /app

# Copy go mod and sum files
# COPY: Copy files or folders from source to the dest path in the image's 
# filesystem.
COPY go.mod go.sum ./

# Download all dependencies. Dependencies will be cached if the go.mod and 
# go.sum files are not changed
# RUN: Execute any commands on top of the current image as a new layer and 
# commit the results.
RUN go mod download

# Copy the source from the current directory to the Working Directory 
# inside the container
COPY . .

# Build the Go app
# RUN go build -o myApp .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o myApp .

######## Start a new stage from scratch #######
FROM alpine:latest  

RUN apk --no-cache add ca-certificates

WORKDIR /root/

# Copy the Pre-built binary file from the previous stage
COPY --from=builder /app/myApp .

# Build Args
# ARG: Define a variable with an optional default value that users can 
# override at build-time when using docker build.
ARG LOG_DIR=/app/logs

# Create Log Directory
RUN mkdir -p ${LOG_DIR}

# Environment Variables
ENV LOG_FILE_LOCATION=${LOG_DIR}/trace.log 

# Expose port 1919 to the outside world
# 1919 is the port configured in the code of myApp
EXPOSE 1919

# Declare volumes to mount
VOLUME [${LOG_DIR}]

# Command to run the executable
CMD ["./myApp"]