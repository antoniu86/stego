#!/bin/bash
# install.sh — Install stego system-wide (requires sudo)
# Normal users can run the scripts directly from the stego/ folder without installing.

set -e

INSTALL_DIR="/usr/local/share/stego"
BIN_DIR="/usr/local/bin"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/cli"

# ── Colours ────────────────────────────────────────────────────────────────────
RED='\033[91m'
GREEN='\033[92m'
YELLOW='\033[93m'
BOLD='\033[1m'
RESET='\033[0m'

info()    { echo -e "${GREEN}[+]${RESET} $*"; }
warn()    { echo -e "${YELLOW}[!]${RESET} $*"; }
error()   { echo -e "${RED}[✗]${RESET} $*" >&2; }
section() { echo -e "\n${BOLD}── $* ──${RESET}"; }

# ── Require sudo ───────────────────────────────────────────────────────────────
if [[ $EUID -ne 0 ]]; then
    error "This installer must be run with sudo."
    echo ""
    echo "  sudo bash install.sh"
    echo ""
    echo "To use stego without installing, run scripts directly:"
    echo "  python3 cli/cli.py --help"
    exit 1
fi

# ── Verify source scripts exist ────────────────────────────────────────────────
for f in core.py cli.py __init__.py; do
    if [[ ! -f "${SCRIPT_DIR}/${f}" ]]; then
        error "Missing source file: ${SCRIPT_DIR}/${f}"
        error "Run this script from the root of the stego repository."
        exit 1
    fi
done

echo ""
echo -e "${BOLD}Stego — System Installer${RESET}"
echo "Installing to: ${INSTALL_DIR}"
echo "Command:       ${BIN_DIR}/stego"
echo ""

# ── Install system dependencies ────────────────────────────────────────────────
section "Installing dependencies"

apt-get update -qq

info "Installing python3 and python3-pip..."
apt-get install -y python3 python3-pip -qq

# Try the distro package first; fall back to pip
if apt-get install -y python3-cryptography -qq 2>/dev/null; then
    info "cryptography installed via apt."
else
    warn "apt package not available, installing cryptography via pip..."
    pip3 install --quiet cryptography
    info "cryptography installed via pip."
fi

# ── Copy scripts to system folder ──────────────────────────────────────────────
section "Copying scripts"

mkdir -p "${INSTALL_DIR}"
cp "${SCRIPT_DIR}/core.py"       "${INSTALL_DIR}/core.py"
cp "${SCRIPT_DIR}/cli.py"        "${INSTALL_DIR}/cli.py"
cp "${SCRIPT_DIR}/__init__.py"   "${INSTALL_DIR}/__init__.py"

chmod 755 "${INSTALL_DIR}/cli.py"
chmod 644 "${INSTALL_DIR}/core.py"
chmod 644 "${INSTALL_DIR}/__init__.py"

info "Scripts copied to ${INSTALL_DIR}"

# ── Create launcher command ────────────────────────────────────────────────────
section "Registering command"

cat > "${BIN_DIR}/stego" << 'EOF'
#!/bin/bash
exec python3 /usr/local/share/stego/cli.py "$@"
EOF

chmod 755 "${BIN_DIR}/stego"

info "Registered: stego"

# ── Done ───────────────────────────────────────────────────────────────────────
echo ""
echo -e "${GREEN}${BOLD}Installation complete!${RESET}"
echo ""
echo "  stego --help"
echo "  stego hide my_folder -o output.jpg"
echo "  stego show output.jpg -o recovered/"
echo "  stego scan /path/to/files -r"
echo ""
