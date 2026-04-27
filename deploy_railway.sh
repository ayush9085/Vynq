#!/bin/bash
#
# Deploy Vynk to Railway
#
# Usage:
#   ./deploy_railway.sh                    # Interactive setup
#   ./deploy_railway.sh --backend          # Deploy backend only
#   ./deploy_railway.sh --frontend         # Build frontend only
#   ./deploy_railway.sh --logs             # View backend logs
#

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() {
  echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
  echo -e "${GREEN}[✓]${NC} $1"
}

log_warn() {
  echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
  echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Railway CLI is installed
check_railway() {
  if ! command -v railway &> /dev/null; then
    log_error "Railway CLI not found!"
    echo ""
    echo "Install it with:"
    echo "  npm i -g @railway/cli"
    echo ""
    echo "Then login:"
    echo "  railway login"
    exit 1
  fi
  log_success "Railway CLI found"
}

# Build Flutter web
build_frontend() {
  log_info "Building Flutter web app..."
  cd frontend
  flutter pub get
  flutter build web --release
  cd ..
  log_success "Frontend built successfully"
}

# Copy frontend to backend static folder (optional)
copy_frontend() {
  log_info "Copying frontend to backend static folder..."
  mkdir -p backend/static
  rm -rf backend/static/*
  cp -r frontend/build/web/* backend/static/
  log_success "Frontend copied to backend/static"
}

# Deploy backend
deploy_backend() {
  log_info "Deploying backend to Railway..."
  log_info "Make sure you've pushed your code to Git first!"
  echo ""
  echo "Steps:"
  echo "  1. Go to railway.app"
  echo "  2. Create new project"
  echo "  3. Connect GitHub repo"
  echo "  4. Select root directory: /"
  echo "  5. Add MongoDB service (via Marketplace)"
  echo "  6. Set MONGODB_URL environment variable"
  echo "  7. Deploy!"
  echo ""
  read -p "Press enter when ready..."
}

# Deploy frontend
deploy_frontend() {
  log_info "Deploying frontend to Railway..."
  log_info "Option 1: Serve from backend (included in above deploy)"
  log_info "Option 2: Separate frontend service"
  echo ""
  echo "If deploying as separate service:"
  echo "  1. Go to railway.app"
  echo "  2. Add service → GitHub"
  echo "  3. Select vynk repo, frontend folder"
  echo "  4. Deploy!"
  echo ""
  read -p "Press enter when ready..."
}

# View logs
view_logs() {
  log_info "Viewing backend logs..."
  railway logs -t backend
}

# Interactive setup
interactive_setup() {
  echo ""
  echo "╔════════════════════════════════════════╗"
  echo "║   Vynk Railway Deployment Helper       ║"
  echo "╚════════════════════════════════════════╝"
  echo ""

  check_railway

  echo ""
  echo "What would you like to do?"
  echo ""
  echo "  1) Full setup (build + deploy)"
  echo "  2) Build frontend only"
  echo "  3) Deploy backend"
  echo "  4) Deploy frontend"
  echo "  5) View logs"
  echo "  6) Exit"
  echo ""

  read -p "Enter choice (1-6): " choice

  case $choice in
    1)
      log_info "Starting full deployment setup..."
      build_frontend
      echo ""
      log_warn "Next: Push your code to Git, then follow these steps:"
      deploy_backend
      ;;
    2)
      build_frontend
      ;;
    3)
      deploy_backend
      ;;
    4)
      deploy_frontend
      ;;
    5)
      view_logs
      ;;
    6)
      log_info "Exiting"
      exit 0
      ;;
    *)
      log_error "Invalid choice"
      exit 1
      ;;
  esac
}

# Parse command line arguments
if [[ $# -eq 0 ]]; then
  interactive_setup
elif [[ "$1" == "--backend" ]]; then
  check_railway
  deploy_backend
elif [[ "$1" == "--frontend" ]]; then
  build_frontend
elif [[ "$1" == "--logs" ]]; then
  check_railway
  view_logs
elif [[ "$1" == "--help" ]]; then
  echo "Vynk Railway Deployment Script"
  echo ""
  echo "Usage: ./deploy_railway.sh [OPTION]"
  echo ""
  echo "Options:"
  echo "  (no args)     Interactive menu"
  echo "  --backend     Setup backend deployment"
  echo "  --frontend    Build frontend"
  echo "  --logs        View backend logs"
  echo "  --help        Show this help"
else
  log_error "Unknown option: $1"
  echo "Run './deploy_railway.sh --help' for usage"
  exit 1
fi
