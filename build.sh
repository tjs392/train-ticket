for dir in $(find . -maxdepth 2 -type f -name Dockerfile -exec dirname {} \;); do
  echo "Building Docker image in directory: $dir"
  IMAGE_NAME=$(basename "$dir")
  docker build -t 127.0.0.1:5000/$IMAGE_NAME:latest "$dir"
  docker push 127.0.0.1:5000/$IMAGE_NAME:latest
 done
