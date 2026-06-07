#!/bin/bash
# ─────────────────────────────────────────────────────────────────────────────
#  release.sh — Bumps version, builds, zips, and publishes a GitHub Release
#
#  Usage:   sh release.sh <version> "<release notes...>"
#  Example: sh release.sh 2.1.5 "Fix battery percentage rounding on QC Ultra 2"
#
#  What it does:
#    1. Writes <version> into Info.plist (CFBundleVersion + CFBundleShortVersionString)
#    2. Runs build.sh (compiles, signs, bundles)
#    3. Zips QCCommand.app
#    4. Creates a GitHub release (tag vX.Y.Z) on QC-Commands/qccommand-releases
#       with the zip attached and standard install instructions appended
#    5. Commits the version bump to the source repo (does NOT push — review first)
#
#  Requires: gh CLI authenticated, git remote "origin" pointing at qccommand
# ─────────────────────────────────────────────────────────────────────────────
set -euo pipefail

BOLD='\033[1m'; GREEN='\033[0;32m'; RED='\033[0;31m'; GRAY='\033[0;90m'; NC='\033[0m'

RELEASES_REPO="QC-Commands/qccommand-releases"

if [ $# -lt 2 ]; then
    echo -e "${RED}Usage: sh release.sh <version> \"<what's new...>\"${NC}"
    echo "Example: sh release.sh 2.1.5 \"Fix battery percentage rounding\""
    exit 1
fi

VERSION="$1"
WHATS_NEW="$2"

if ! [[ "$VERSION" =~ ^[0-9]+\.[0-9]+(\.[0-9]+)?$ ]]; then
    echo -e "${RED}✗ Version must look like 2.1.5 or 2.1${NC}"
    exit 1
fi

echo ""
echo -e "${BOLD}QC Command — Release ${VERSION}${NC}"
echo "─────────────────────────────────"

# ── 1. Bump Info.plist ───────────────────────────────────────────────────────

echo -n "  Setze Version in Info.plist … "
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion ${VERSION}" Info.plist
/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString ${VERSION}" Info.plist
echo -e "${GREEN}✓${NC}"

# ── 2. Build ──────────────────────────────────────────────────────────────────

echo ""
sh build.sh
echo ""

# ── 3. Zip ────────────────────────────────────────────────────────────────────

ZIP_NAME="QCCommand-${VERSION}.zip"
echo -n "  Erstelle ${ZIP_NAME} …  "
rm -f "$ZIP_NAME"
ditto -c -k --sequesterRsrc --keepParent QCCommand.app "$ZIP_NAME"
echo -e "${GREEN}✓${NC}"

# ── 4. GitHub Release ─────────────────────────────────────────────────────────

NOTES=$(cat <<EOF
## What's new
${WHATS_NEW}

## Installation
1. Download \`${ZIP_NAME}\` below and unzip it
2. Move \`QCCommand.app\` to \`/Applications\`
3. **If macOS says "QCCommand is damaged and can't be opened"** — known Gatekeeper quirk with ad-hoc signed apps; the app is *not* actually damaged. Open Terminal and run:
   \`\`\`
   xattr -cr /Applications/QCCommand.app
   \`\`\`
   Then open the app normally.
4. Grant Bluetooth permission when prompted. For shortcuts, also grant Input Monitoring + Accessibility (the Shortcuts tab walks you through it).
EOF
)

echo -n "  Veröffentliche Release v${VERSION} …  "
gh release create "v${VERSION}" "$ZIP_NAME" \
    --repo "$RELEASES_REPO" \
    --title "QC Command ${VERSION}" \
    --notes "$NOTES" >/dev/null
echo -e "${GREEN}✓${NC}"

rm -f "$ZIP_NAME"

# ── 5. Commit version bump (no push — review first) ─────────────────────────

echo -n "  Committe Versionsbump …       "
git add Info.plist
git commit -q -m "Bump version to ${VERSION}" || true
echo -e "${GREEN}✓${NC}"

# ── Fertig ────────────────────────────────────────────────────────────────────

echo ""
echo -e "${GREEN}${BOLD}✅ Release v${VERSION} veröffentlicht${NC}"
echo ""
echo "  Release:  https://github.com/${RELEASES_REPO}/releases/tag/v${VERSION}"
echo ""
echo -e "${GRAY}  Hinweis: Versionsbump wurde committet, aber NICHT gepusht.${NC}"
echo -e "${GRAY}           Quellcode-Änderungen separat committen/pushen, dann: git push${NC}"
echo ""
