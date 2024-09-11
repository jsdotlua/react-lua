docker build -t asset-builder .
docker run --rm -v $(pwd)/dist:/app/dist asset-builder
