#!/usr/bin/env bash
#
# ========================================
#  Vynk: Full-Stack Dating App Launcher
# ========================================
#
# This script orchestrates the startup of the entire Vynk application:
#  - FastAPI backend (Port 8000)
#  - Flutter web frontend (Port 8080)
#
# Usage:
#   ./run_all.sh                          # Start all services (idempotent)
#   SKIP_BUILD=1 ./run_all.sh             # Start without rebuilding frontend
#   FORCE_RESTART=1 ./run_all.sh          # Kill existing services and restart
#
# Environment Variables:
#   BACKEND_PORT    - Backend port (default: 8000)
#   FRONTEND_PORT   - Frontend port (default: 8080)
#   SKIP_BUILD      - Skip Flutter build if already compiled (default: 0)
#   FORCE_RESTART   - Force kill and restart all services (default: 0)
#

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKEND_PORT="${BACKEND_PORT:-8000}"
FRONTEND_PORT="${FRONTEND_PORT:-8080}"
SKIP_BUILD="${SKIP_BUILD:-0}"
FORCE_RESTART="${FORCE_RESTART:-0}"

LOCK_DIR="${ROOT_DIR}/.run_all.lock"
LOCK_PID_FILE="${LOCK_DIR}/pid"

BACKEND_LOG="${ROOT_DIR}/backend.log"
FRONTEND_BUILD_LOG="${ROOT_DIR}/frontend_build.log"
FRONTEND_LOG="${ROOT_DIR}/frontend.log"

PYTHON_BIN="${ROOT_DIR}/.venv/bin/python"
if [[ ! -x "${PYTHON_BIN}" ]]; then
  PYTHON_BIN="python3"
fi

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

# Verify required commands exist
require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    log_error "Missing required command: $1"
    exit 1
  fi
}

# Release port by killing existing processes
free_port() {
  local port="$1"
  local pids
  pids="$(lsof -ti tcp:"${port}" 2>/dev/null || true)"
  if [[ -n "${pids}" ]]; then
    log_warn "Releasing port ${port}..."
    # shellcheck disable=SC2086
    kill ${pids} 2>/dev/null || true
    sleep 1
  fi
}

# Cleanup on exit
cleanup() {
  set +e
  if [[ -n "${BACKEND_PID:-}" ]] && kill -0 "${BACKEND_PID}" 2>/dev/null; then
    kill "${BACKEND_PID}" 2>/dev/null || true
  fi
  if [[ -n "${FRONTEND_PID:-}" ]] && kill -0 "${FRONTEND_PID}" 2>/dev/null; then
    kill "${FRONTEND_PID}" 2>/dev/null || true
  fi
  rm -rf "${LOCK_DIR}" 2>/dev/null || true
}

trap cleanup EXIT INT TERM

# Acquire exclusive lock to prevent concurrent runs
acquire_lock() {
  if mkdir "${LOCK_DIR}" 2>/dev/null; then
    echo "$$" >"${LOCK_PID_FILE}"
    return
  fi

  if [[ -f "${LOCK_PID_FILE}" ]]; then
    local existing_pid
    existing_pid="$(cat "${LOCK_PID_FILE}" 2>/dev/null || true)"
    if [[ -n "${existing_pid}" ]] && kill -0 "${existing_pid}" 2>/dev/null; then
      if [[ "${FORCE_RESTART}" == "1" ]]; then
        log_warn "Stopping existing instance (PID ${existing_pid})..."
        kill "${existing_pid}" 2>/dev/null || true
        sleep 2
      else
        if curl -fsS "http://127.0.0.1:${BACKEND_PORT}/health" >/dev/null 2>&1 && \
          curl -fsS "http://127.0.0.1:${FRONTEND_PORT}" >/dev/null 2>&1; then
          log_success "Vynk is already running"
          echo ""
          echo "  Backend:  ${BLUE}http://127.0.0.1:${BACKEND_PORT}${NC}"
          echo "  Frontend: ${BLUE}http://127.0.0.1:${FRONTEND_PORT}${NC}"
          echo "  Docs:     ${BLUE}http://127.0.0.1:${BACKEND_PORT}/docs${NC}"
          echo ""
          echo "  Use ${YELLOW}FORCE_RESTART=1 ./run_all.sh${NC} to restart"
          exit 0
        fi

        log_error "Another instance is running (PID ${existing_pid})"
        echo "Use ${YELLOW}FORCE_RESTART=1 ./run_all.sh${NC} to replace it"
        exit 1
      fi
    fi
  fi

  rm -rf "${LOCK_DIR}" 2>/dev/null || true
  mkdir "${LOCK_DIR}"
  echo "$$" >"${LOCK_PID_FILE}"
}

# Validate environment
log_info "Checking environment..."
require_cmd flutter
require_cmd python3
require_cmd lsof
require_cmd curl
log_success "All dependencies found"

# Check if services already running
if [[ "${FORCE_RESTART}" != "1" ]]; then
  if curl -fsS "http://127.0.0.1:${BACKEND_PORT}/health" >/dev/null 2>&1 && \
    curl -fsS "http://127.0.0.1:${FRONTEND_PORT}" >/dev/null 2>&1; then
    log_success "Vynk is already running"
    echo ""
    echo "  Backend:  ${BLUE}http://127.0.0.1:${BACKEND_PORT}${NC}"
    echo "  Frontend: ${BLUE}http://127.0.0.1:${FRONTEND_PORT}${NC}"
    echo "  Docs:     ${BLUE}http://127.0.0.1:${BACKEND_PORT}/docs${NC}"
    echo ""
    echo "  Use ${YELLOW}FORCE_RESTART=1 ./run_all.sh${NC} to restart"
    exit 0
  fi
fi

acquire_lock
log_success "Lock acquired"

free_port "${BACKEND_PORT}"
free_port "${FRONTEND_PORT}"

# Build Flutter frontend
log_info "Building Flutter web app..."
if [[ "${SKIP_BUILD}" == "1" ]]; then
  log_warn "Skipping Flutter build (SKIP_BUILD=1)"
else
  (
    cd "${ROOT_DIR}/frontend"
    flutter pub get >/dev/null 2>&1
    flutter build web --release >/dev/null 2>&1
  ) 2>&1 | tee "${FRONTEND_BUILD_LOG}" >/dev/null
fi

if [[ ! -f "${ROOT_DIR}/frontend/build/web/index.html" ]]; then
  log_error "Frontend build failed: ${ROOT_DIR}/frontend/build/web/index.html not found"
  echo "Check log: ${FRONTEND_BUILD_LOG}"
  exit 1
fi
log_success "Frontend built"

# Reset logs
: >"${BACKEND_LOG}"
: >"${FRONTEND_LOG}"

# Start backend
log_info "Starting backend on ${BLUE}http://127.0.0.1:${BACKEND_PORT}${NC}..."
(
  cd "${ROOT_DIR}"
  "${PYTHON_BIN}" -m uvicorn backend.app:app --host 0.0.0.0 --port "${BACKEND_PORT}" --log-level info
) >"${BACKEND_LOG}" 2>&1 &
BACKEND_PID=$!

sleep 2

if ! kill -0 "${BACKEND_PID}" 2>/dev/null; then
  log_error "Backend failed to start"
  echo "Log:"
  tail -n 30 "${BACKEND_LOG}" 2>/dev/null || true
  exit 1
fi
log_success "Backend started (PID: ${BACKEND_PID})"

# Start frontend
log_info "Starting frontend on ${BLUE}http://127.0.0.1:${FRONTEND_PORT}${NC}..."
(
  cd "${ROOT_DIR}/frontend/build/web"
  python3 -m http.server "${FRONTEND_PORT}" >/dev/null 2>&1
) >"${FRONTEND_LOG}" 2>&1 &
FRONTEND_PID=$!

sleep 1

if ! kill -0 "${FRONTEND_PID}" 2>/dev/null; then
  log_error "Frontend failed to start"
  echo "Log:"
  tail -n 30 "${FRONTEND_LOG}" 2>/dev/null || true
  exit 1
fi
log_success "Frontend started (PID: ${FRONTEND_PID})"

# Verify backend health
sleep 1
if ! curl -fsS "http://127.0.0.1:${BACKEND_PORT}/health" >/dev/null 2>&1; then
  log_error "Backend health check failed"
  exit 1
fi
log_success "Backend health verified"

# Print success message
echo ""
log_success "Vynk is running!"
echo ""
echo "  ${BLUE}Backend${NC}:  http://127.0.0.1:${BACKEND_PORT}"
echo "  ${BLUE}Frontend${NC}: http://127.0.0.1:${FRONTEND_PORT}"
echo "  ${BLUE}API Docs${NC}: http://127.0.0.1:${BACKEND_PORT}/docs"
echo ""
echo "  Backend Log:  ${BACKEND_LOG}"
echo "  Frontend Log: ${FRONTEND_LOG}"
echo ""
echo "  Press Ctrl+C to stop all services"
echo ""

# Keep script alive
wait
