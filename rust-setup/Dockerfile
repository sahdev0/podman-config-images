# Use the full official standard image (contains all tools/libraries)
FROM docker.io/library/rust:1.98

# Install sudo to handle non-root execution permissions smoothly
RUN apt-get update && apt-get install -y sudo && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Dynamic host user integration for Fedora mapping
ARG USER_ID=1000
ARG GROUP_ID=1000
RUN groupadd -g ${GROUP_ID} developer && \
    useradd -u ${USER_ID} -g developer -m -s /bin/bash developer && \
    echo "developer ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER developer

# Container-side Rust workspace
WORKDIR /workspace

# Keep development container running in background
CMD ["tail", "-f", "/dev/null"]
