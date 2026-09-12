# Use explicit version tagging instead of 'slim' to avoid unexpected breaking updates
FROM docker.io/library/rust:slim

# Fix 1: Added --no-install-recommends and explicit apt cleanup to keep image size small
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    pkg-config \
    libssl-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/myapp

CMD ["tail", "-f", "/dev/null"]
