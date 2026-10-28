#!/data/data/com.termux/files/usr/bin/bash
# =============================================================================
# Life Calendar Wallpaper - Tasker Trigger Script
# =============================================================================
# This script is called by Tasker via Termux:Tasker plugin.
# Place this file at: ~/.termux/tasker/life_calendar.sh
# =============================================================================

# Navigate to script directory
cd ~/life_calendar || exit 1

# Run the Python script
python life_calendar.py

# Exit with Python's exit code
exit $?
