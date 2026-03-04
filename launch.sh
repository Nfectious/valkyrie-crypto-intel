#!/bin/bash
# ============================================================
# VALKYRIE CRYPTO INTEL — Quick Launch Script
# ============================================================
set -e

echo ""
echo "██╗   ██╗ █████╗ ██╗     ██╗  ██╗██╗   ██╗██████╗ ██╗███████╗"
echo "██║   ██║██╔══██╗██║     ██║ ██╔╝╚██╗ ██╔╝██╔══██╗██║██╔════╝"
echo "██║   ██║███████║██║     █████╔╝  ╚████╔╝ ██████╔╝██║█████╗  "
echo "╚██╗ ██╔╝██╔══██║██║     ██╔═██╗   ╚██╔╝  ██╔══██╗██║██╔══╝  "
echo " ╚████╔╝ ██║  ██║███████╗██║  ██╗   ██║   ██║  ██║██║███████╗"
echo "  ╚═══╝  ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝╚═╝╚══════╝"
echo ""
echo "  CRYPTO INTEL MONITOR — Quick Launch"
echo "============================================================"
echo ""

# Check Docker
if ! command -v docker &> /dev/null; then
    echo "❌ Docker not found. Install Docker first: https://docs.docker.com/get-docker/"
    exit 1
fi

if ! command -v docker compose &> /dev/null; then
    echo "❌ Docker Compose not found. Install Docker Compose first."
    exit 1
fi

cd "$(dirname "$0")/docker"

# Check .env exists
if [ ! -f .env ]; then
    echo "⚙️  No .env found. Creating from example..."
    cp .env.example .env
    echo ""
    echo "📝 Edit docker/.env with your Trading Forge API URL before continuing."
    echo "   nano docker/.env"
    echo ""
    read -p "Press Enter after editing .env to continue, or Ctrl+C to exit..."
fi

echo ""
echo "🚀 Launching Valkyrie..."
docker compose up -d

echo ""
echo "⏳ Waiting for services..."
sleep 5

echo ""
echo "============================================================"
echo "✅ VALKYRIE IS LIVE"
echo ""
echo "   Dashboard: http://localhost/valkyrie/"
echo "   Ollama:    http://localhost:11434"
echo ""
echo "📡 Add trading pairs in the dashboard and hit START"
echo "🤖 Model pull running in background (qwen3-coder:30b ~18GB)"
echo "   Check progress: docker logs valkyrie-ollama-pull -f"
echo ""
echo "To stop: docker compose -f docker/docker-compose.yml down"
echo "============================================================"
