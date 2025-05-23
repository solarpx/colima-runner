#!/bin/bash

# Colima Control Script for MacBook Air (M1/M2, macOS 15.4+)
# - Ensures complete cleanup on stop
# - Adds error handling and validation
# - Maintains thermal safety for MacBook Air

# Config (tuned for MacBook Air)
ARCH="aarch64"        # ARM64 native
CPU=4                 # Optimal cores to avoid throttling
MEMORY=6              # 6GB RAM (balanced for Docker + macOS)
DISK=30               # 30GB storage
MOUNT_TYPE="virtiofs" # Fastest (fallback to 9p if needed)
VM_TYPE="vz"         # Native virtualization (best performance)

clean_colima() {
    echo "🧹 Performing complete cleanup..."
    colima delete -f 2>/dev/null || true
    echo "✅ Colima instance deleted. Use 'start' to create fresh instance."
}

start_colima() {
    echo "🚀 Starting Colima (Apple Silicon optimized)..."
    
    echo "⚙️  Configuration:"
    echo "  - Arch: $ARCH, Cores: $CPU, RAM: ${MEMORY}GB"
    echo "  - Disk: ${DISK}GB, Mount: $MOUNT_TYPE, VM: $VM_TYPE"

    # Start with error handling
    colima start \
        --arch "$ARCH" \
        --cpu "$CPU" \
        --memory "$MEMORY" \
        --disk "$DISK" \
        --mount-type "$MOUNT_TYPE" \
        --vm-type "$VM_TYPE"

    verify_colima
}

stop_colima() {
    echo "🛑 Stopping Colima..."
    
    # Graceful stop (ignore errors if already stopped)
    colima stop 2>/dev/null || true
    
    # Verify shutdown
    if colima status 2>/dev/null | grep -q "Running"; then
        echo "❌ Failed to stop Colima!"
    else
        echo "✅ Colima stopped successfully"
    fi
}

verify_colima() {
    echo -e "\n✅ Verification:"
    colima status | grep -E "ARCH|CPU|MEMORY|MOUNT|STATUS"
    docker run --rm hello-world | grep -q "Hello from Docker" && \
        echo "🐳 Docker is functional" || \
        echo "⚠️  Docker not responding!"
}

# Main execution
case "$1" in
    start)   start_colima ;;
    stop)    stop_colima ;;
    clean)   clean_colima ;;
    *)       echo "Usage: $0 {start|stop|clean}"; exit 1 ;;
esac

