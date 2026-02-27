#!/bin/bash

set -e  # Stop immediately if a command fails

echo "🧹 Running make clean..."
make clean

echo "🔨 Running make build..."
make build

echo "🔍 Detecting variable font..."
VF_PATH=$(ls fonts/variable/*.ttf)

if [ -z "$VF_PATH" ]; then
  echo "❌ No variable font found in fonts/variable/"
  exit 1
fi

echo "📦 Variable font found: $VF_PATH"

echo "🛠 Rebuilding STAT + cleaning name table..."
python3 scripts/fix_STAT_and_name_STRICH.py

echo "🧪 Running FontBakery..."
fontbakery check-googlefonts "$VF_PATH" \
  -x fontdata_namecheck \
  -x googlefonts/STAT/axisregistry \
  --html fb-report.html

echo ""
echo "✅ Build + fix + QA completed."