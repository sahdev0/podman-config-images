#!/bin/bash

# Dynamically export variables for Podman Compose mapping
export HOST_UID=$(id -u)
export HOST_GID=$(id -g)
export RUST_WORKSPACE=$(pwd)

# Name of the active running container defined in your compose file
CONTAINER_NAME="rust-dev"

# Helper function to ensure the container environment is up and running
ensure_running() {
  if [ "$(podman container inspect -f '{{.State.Running}}' "$CONTAINER_NAME" 2>/dev/null)" != "true" ]; then
    echo "🔄 Dev container is not running. Booting it up now..."
    podman compose up -d
    # Give Podman a brief second to initialize the background process
    sleep 1
  fi
}

case "$1" in
  init)
    # Check if the container is already alive and running
    if [ "$(podman container inspect -f '{{.State.Running}}' "$CONTAINER_NAME" 2>/dev/null)" = "true" ]; then
      echo "ℹ️  Container '$CONTAINER_NAME' is already up and running. Skipping build/start."
    else
      echo "⚙️  Building the standard Rust dev container..."
      podman compose build
      echo "🚀 Starting the container environment in the background..."
      podman compose up -d
      sleep 1
    fi

    # Check if a project is already initialized by looking for Cargo.toml
    if [ ! -f "Cargo.toml" ]; then
      echo "📦 Initializing your cargo project..."
      podman exec -it "$CONTAINER_NAME" cargo init --bin .
      echo "✅ Complete! 'src/main.rs' has been created."
    else
      echo "ℹ️  Cargo.toml already exists. Skipping initialization."
    fi
    ;;

  shell)
    ensure_running
    echo "💻 Entering container environment..."
    podman exec -it "$CONTAINER_NAME" bash
    ;;

  run)
    ensure_running
    podman exec -it "$CONTAINER_NAME" cargo run "${@:2}"
    ;;

  test)
    ensure_running
    podman exec -it "$CONTAINER_NAME" cargo test "${@:2}"
    ;;

  clippy)
    ensure_running
    podman exec -it "$CONTAINER_NAME" cargo clippy "${@:2}"
    ;;

  fmt)
    ensure_running
    podman exec -it "$CONTAINER_NAME" cargo fmt "${@:2}"
    ;;

  cargo)
    ensure_running
    podman exec -it "$CONTAINER_NAME" cargo "${@:2}"
    ;;

  up)
    echo "🚀 Booting background environment..."
    podman compose up -d
    ;;

  down)
    echo "🛑 Halting services..."
    podman compose down
    ;;

  clean)
    echo "🧹 Deep cleaning containers and resetting volumes..."
    podman compose down -v
    ;;

  *)
    echo "Usage: $0 {init|up|down|shell|run|test|clippy|fmt|cargo [args]|clean}"
    exit 1
    ;;
esac
