"""
Life Calendar Wallpaper - Configuration
========================================
Exactly matched to reference design.
"""

# =============================================================================
# DISPLAY SETTINGS
# =============================================================================

# Samsung S23 Lock Screen Resolution
SCREEN_WIDTH = 1440
SCREEN_HEIGHT = 3088

# =============================================================================
# COLOR PALETTE (Exact match to reference)
# =============================================================================

# Background (exact match)
BACKGROUND_COLOR = "#1c1c1c"

# Dot Colors (exact match)
DOT_COMPLETED = "#ffffff"      # Pure white - days passed
DOT_REMAINING = "#555555"      # Visible grey - days left
DOT_TODAY = "#ff5533"          # Orange-red - current day

# Text Colors
TEXT_PRIMARY = "#ffffff"       # White text
TEXT_SECONDARY = "#555555"     # Grey for labels (same as dots)
TEXT_ACCENT = "#ff5533"        # Orange accent for day number

# Glow Settings (disabled - flat design)
GLOW_ENABLED = False
GLOW_INTENSITY = 0.0
GLOW_RADIUS = 0

# =============================================================================
# GRID SETTINGS (Exact match to reference)
# =============================================================================

# Grid Layout
GRID_COLUMNS = 15              # Exactly 15 dots per row
GRID_ROWS = 25                 # 25 rows (375 cells, 365 used)

# Dot Dimensions
DOT_DIAMETER = 46              # Dot size
DOT_SPACING = 68               # Space between dot centers

# Grid Positioning
GRID_TOP_MARGIN = 620          # Start higher on screen
GRID_HORIZONTAL_CENTER = True

# =============================================================================
# TYPOGRAPHY (Exact match to reference)
# =============================================================================

# Font Settings
FONT_SIZE_STATS = 46           # Match reference text size
FONT_SIZE_LABEL = 36

# Text Positioning
TEXT_BOTTOM_MARGIN = 180       # Very close to bottom

# Text Format
TEXT_USE_SHORT_FORMAT = True   # "352d left" format

# =============================================================================
# FILE PATHS
# =============================================================================

import os

OUTPUT_DIR = "/storage/emulated/0/Pictures/LifeCalendar"
OUTPUT_FILENAME = "life_calendar.png"
OUTPUT_PATH = f"{OUTPUT_DIR}/{OUTPUT_FILENAME}"

# Development/Local fallback path
DEV_OUTPUT_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "output")
DEV_OUTPUT_PATH = f"{DEV_OUTPUT_DIR}/{OUTPUT_FILENAME}"

# =============================================================================
# ADVANCED SETTINGS
# =============================================================================

PNG_COMPRESSION = 6
ANTIALIAS_ENABLED = True
DEBUG_MODE = False
