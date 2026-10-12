#!/bin/bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
cd "$DIR"

echo "🔨 Building Dot for macOS..."
swift build -c release

APP_NAME="Dot"
APP_BUNDLE="$DIR/$APP_NAME.app"
BIN_SOURCE="$DIR/.build/release/$APP_NAME"

echo "📦 Creating $APP_NAME.app bundle..."
rm -rf "$APP_BUNDLE"
mkdir -p "$APP_BUNDLE/Contents/MacOS"
mkdir -p "$APP_BUNDLE/Contents/Resources"

cp "$BIN_SOURCE" "$APP_BUNDLE/Contents/MacOS/$APP_NAME"
chmod +x "$APP_BUNDLE/Contents/MacOS/$APP_NAME"

if [ -f "$DIR/Assets/AppIcon.icns" ]; then
    cp "$DIR/Assets/AppIcon.icns" "$APP_BUNDLE/Contents/Resources/AppIcon.icns"
fi

cat << 'EOF' > "$APP_BUNDLE/Contents/Info.plist"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>Dot</string>
    <key>CFBundleIconFile</key>
    <string>AppIcon</string>
    <key>CFBundleIdentifier</key>
    <string>com.antigravity.dot</string>
    <key>CFBundleName</key>
    <string>Dot</string>
    <key>CFBundleDisplayName</key>
    <string>Dot</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0.0</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>LSMinimumSystemVersion</key>
    <string>14.0</string>
    <key>LSUIElement</key>
    <true/>
    <key>NSHighResolutionCapable</key>
    <true/>
    <key>NSSupportsAutomaticGraphicsSwitching</key>
    <true/>
    <key>NSAppleEventsUsageDescription</key>
    <string>Dot requires Apple Events permissions to automate apps, adjust volume, and perform requested desktop tasks.</string>
</dict>
</plist>
EOF

echo "🔏 Signing application bundle (ad-hoc)..."
codesign --force --deep -s - "$APP_BUNDLE" || true

echo "✨ Successfully created $APP_BUNDLE!"
echo "🚀 To launch Dot, run: open $APP_NAME.app"
