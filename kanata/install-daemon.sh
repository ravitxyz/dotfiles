#!/bin/bash
set -e

PLIST_PATH="/Library/LaunchDaemons/com.kanata.daemon.plist"
KANATA_BIN="/opt/homebrew/bin/kanata"
KANATA_CFG="/Users/ravit/dotfiles/kanata/home-row-mod-advanced.kbd"

echo "Installing kanata LaunchDaemon..."

# Create the plist
sudo tee "$PLIST_PATH" > /dev/null << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.kanata.daemon</string>
    <key>ProgramArguments</key>
    <array>
        <string>$KANATA_BIN</string>
        <string>--cfg</string>
        <string>$KANATA_CFG</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>StandardOutPath</key>
    <string>/tmp/kanata.log</string>
    <key>StandardErrorPath</key>
    <string>/tmp/kanata.err</string>
</dict>
</plist>
EOF

# Unload if already loaded
sudo launchctl bootout system "$PLIST_PATH" 2>/dev/null || true

# Load the daemon
sudo launchctl bootstrap system "$PLIST_PATH"

echo "Done! Kanata is now running and will auto-start on login."
echo "Logs: /tmp/kanata.log"
echo ""
echo "To stop:   sudo launchctl bootout system $PLIST_PATH"
echo "To start:  sudo launchctl bootstrap system $PLIST_PATH"
echo "To status: sudo launchctl list | grep kanata"
