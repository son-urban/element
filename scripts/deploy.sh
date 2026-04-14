#!/bin/bash
set -e

# Load nvm if available
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
nvm use 16 2>/dev/null || true

MODE=${1:-dev}
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
cd "$PROJECT_DIR"

URBANA_JS="../src/UrbanA/ui/js/element_ui.js"
URBANA_CSS="../src/UrbanA/ui/css/style/theme/index.css"
URBANA_FONTS_DIR="../src/UrbanA/ui/css/style/theme/fonts"

echo "=== Building Element UI ($MODE) ==="

# Step 1: Generate entry files
echo "[1/3] Generating entry files..."
node build/bin/iconInit.js
node build/bin/build-entry.js
node build/bin/i18n.js
node build/bin/version.js

# Step 2: Build JS bundle (uses webpack API with proper exit)
echo "[2/3] Building JS bundle..."
node scripts/build-js.js "$MODE"

# Step 3: Build CSS theme
echo "[3/3] Building CSS theme..."
mkdir -p lib/theme-chalk/fonts
if [ "$MODE" = "prod" ]; then
  npx sass packages/theme-chalk/src/index.scss lib/theme-chalk/index.css --no-source-map --style compressed
else
  npx sass packages/theme-chalk/src/index.scss lib/theme-chalk/index.css --no-source-map --style expanded
fi
cp packages/theme-chalk/src/fonts/* lib/theme-chalk/fonts/

# Step 4: Deploy to UrbanA
echo "=== Deploying to UrbanA ==="
cp lib/index.js "$URBANA_JS"
cp lib/theme-chalk/index.css "$URBANA_CSS"
mkdir -p "$URBANA_FONTS_DIR"
cp lib/theme-chalk/fonts/* "$URBANA_FONTS_DIR/"

echo "=== Done! ==="
echo "  JS:  $URBANA_JS ($(wc -c < lib/index.js | tr -d ' ') bytes)"
echo "  CSS: $URBANA_CSS ($(wc -c < lib/theme-chalk/index.css | tr -d ' ') bytes)"
