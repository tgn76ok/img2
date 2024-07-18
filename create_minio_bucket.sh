#!/bin/bash

# Variables
MINIO_ACCESS_KEY="AKIAIOSFODNN7EXAMPLE"
MINIO_SECRET_KEY="wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
BUCKET_NAME="mybucket"

# Start MinIO server with Docker
docker run -d -p 9000:9000 -p 9001:9001 --name minio \
  -e "MINIO_ACCESS_KEY=$MINIO_ACCESS_KEY" \
  -e "MINIO_SECRET_KEY=$MINIO_SECRET_KEY" \
  -v /mnt/data:/data \
  -v /mnt/config:/root/.minio \
  minio/minio server /data --console-address ":9001"

# Wait for MinIO server to start
sleep 10

# Download and install mc (MinIO client)
wget https://dl.min.io/client/mc/release/linux-amd64/mc
chmod +x mc
sudo mv mc /usr/local/bin/

# Configure mc to use MinIO server
mc alias set myminio http://localhost:9000 $MINIO_ACCESS_KEY $MINIO_SECRET_KEY

# Create a bucket
mc mb myminio/$BUCKET_NAME

echo "Bucket '$BUCKET_NAME' created successfully on MinIO server."
