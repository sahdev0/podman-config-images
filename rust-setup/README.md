# 1. Build the image
podman build -t rust-dev-image -f Dockerfile .

# 2. Start the detached container with volumes and environments
podman run -d \
  --name rust-dev \
  -e CARGO_TARGET_DIR=/usr/src/myapp/target \
  -v .:/usr/src/myapp:Z,U \
  -v rust-target-cache:/usr/src/myapp/target \
  -v rust-cargo-cache:/usr/local/cargo/registry \
  rust-dev-image

# 3. Create app
podman exec -it rust-dev cargo new test-app

# 4. Check
podman exec -it -w /usr/src/myapp/test-app rust-dev cargo check

# 5. Run
podman exec -it -w /usr/src/myapp/test-app rust-dev cargo run

# 6. Clean
podman exec -it -w /usr/src/myapp/test-app rust-dev cargo clean


# Check Version
podman exec -it rust-dev cargo --version
