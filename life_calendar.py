#!/usr/bin/env python3
"""
Life Calendar Wallpaper Generator
==================================
A premium, minimalistic life calendar that generates a daily-updating
wallpaper showing the year's progress as an elegant dot grid.

Matched to reference design.

Author: Yash
Device: Samsung S23 (1440 x 3088)
"""

import os
import sys
from datetime import datetime, date
from PIL import Image, ImageDraw, ImageFilter, ImageFont

# Try to import config, fall back to defaults if not available
try:
    import config as cfg
except ImportError:
    # Default configuration if config.py is not found
    class cfg:
        SCREEN_WIDTH = 1440
        SCREEN_HEIGHT = 3088
        BACKGROUND_COLOR = "#1a1a1a"
        DOT_COMPLETED = "#ffffff"
        DOT_REMAINING = "#4a4a4a"
        DOT_TODAY = "#ff6633"
        TEXT_PRIMARY = "#ffffff"
        TEXT_SECONDARY = "#666666"
        TEXT_ACCENT = "#ff6633"
        GLOW_ENABLED = False
        GLOW_INTENSITY = 0.0
        GLOW_RADIUS = 0
        GRID_COLUMNS = 15
        GRID_ROWS = 25
        DOT_DIAMETER = 52
        DOT_SPACING = 72
        GRID_TOP_MARGIN = 650
        FONT_SIZE_STATS = 52
        TEXT_BOTTOM_MARGIN = 280
        TEXT_USE_SHORT_FORMAT = True
        OUTPUT_DIR = "/storage/emulated/0/Pictures/LifeCalendar"
        OUTPUT_FILENAME = "life_calendar.png"
        DEV_OUTPUT_DIR = "c:/Users/yashm/Desktop/life/output"
        DEBUG_MODE = False


def hex_to_rgb(hex_color: str) -> tuple:
    """Convert hex color to RGB tuple."""
    hex_color = hex_color.lstrip('#')
    return tuple(int(hex_color[i:i+2], 16) for i in (0, 2, 4))


def hex_to_rgba(hex_color: str, alpha: int = 255) -> tuple:
    """Convert hex color to RGBA tuple."""
    rgb = hex_to_rgb(hex_color)
    return (*rgb, alpha)


def get_year_progress() -> dict:
    """
    Calculate the current year's progress.
    
    Returns:
        dict with keys:
            - year: current year
            - total_days: total days in year (365 or 366)
            - day_of_year: current day number (1-366)
            - days_passed: days completed (day_of_year - 1)
            - days_remaining: days left including today
            - percentage: percentage of year completed
    """
    today = date.today()
    year = today.year
    
    # Check if leap year
    is_leap = (year % 4 == 0 and year % 100 != 0) or (year % 400 == 0)
    total_days = 366 if is_leap else 365
    
    # Day of year (1-indexed)
    day_of_year = today.timetuple().tm_yday
    
    # Days passed (completed days, not including today)
    days_passed = day_of_year - 1
    
    # Days remaining (including today)
    days_remaining = total_days - days_passed
    
    # Percentage completed
    percentage = (days_passed / total_days) * 100
    
    return {
        'year': year,
        'total_days': total_days,
        'day_of_year': day_of_year,
        'days_passed': days_passed,
        'days_remaining': days_remaining,
        'percentage': percentage
    }


def draw_dot(draw: ImageDraw.Draw, x: int, y: int, 
             diameter: int, color: str) -> None:
    """Draw a single dot at the specified position."""
    rgba = hex_to_rgba(color)
    radius = diameter // 2
    draw.ellipse(
        [x - radius, y - radius, x + radius, y + radius],
        fill=rgba
    )


def get_font(size: int) -> ImageFont.FreeTypeFont:
    """
    Get a font, with fallback to default if custom font not available.
    """
    # Try common sans-serif fonts (Windows, Android, Linux)
    font_names = [
        # Windows fonts - prefer clean sans-serif
        "C:/Windows/Fonts/segoeui.ttf",      # Segoe UI
        "C:/Windows/Fonts/arial.ttf",        # Arial
        "C:/Windows/Fonts/calibri.ttf",      # Calibri
        # Android fonts
        "/system/fonts/Roboto-Regular.ttf",
        "/system/fonts/Roboto-Medium.ttf",
        "/system/fonts/NotoSans-Regular.ttf",
        # Linux fonts
        "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf",
        # Termux fonts
        "/data/data/com.termux/files/usr/share/fonts/TTF/DejaVuSans.ttf",
    ]
    
    for font_name in font_names:
        try:
            return ImageFont.truetype(font_name, size)
        except (OSError, IOError):
            continue
    
    # Fall back to default font (may be very small)
    try:
        return ImageFont.load_default()
    except:
        return None


def generate_wallpaper(output_path: str = None, width: int = None, height: int = None) -> str:
    """
    Generate the life calendar wallpaper tailored to exact resolution and orientation.
    
    Args:
        output_path: Optional custom output path
        width: Optional custom screen width (default: cfg.SCREEN_WIDTH)
        height: Optional custom screen height (default: cfg.SCREEN_HEIGHT)
    
    Returns:
        Path to the generated image
    """
    # Get year progress data
    progress = get_year_progress()
    
    # Resolve dimensions
    width = width or cfg.SCREEN_WIDTH
    height = height or cfg.SCREEN_HEIGHT
    is_landscape = width > height
    
    # Proportional grid layout
    cols = 25 if is_landscape else 15
    rows = 15 if is_landscape else 25
    
    max_grid_w = width * 0.82
    max_grid_h = height * 0.68 if is_landscape else height * 0.58
    
    spacing_x = max_grid_w / (cols - 1)
    spacing_y = max_grid_h / (rows - 1)
    spacing = min(spacing_x, spacing_y)
    dot_diameter = int(spacing * 0.68)
    
    grid_width = (cols - 1) * spacing + dot_diameter
    grid_height = (rows - 1) * spacing + dot_diameter
    
    # Calculate starting position (centered horizontally)
    start_x = int((width - grid_width) / 2 + dot_diameter / 2)
    start_y = int((height - grid_height) / 2 - (height * 0.03) if is_landscape else height * 0.20)
    
    # Create base image with dark background
    image = Image.new('RGBA', (width, height), hex_to_rgba(cfg.BACKGROUND_COLOR))
    draw = ImageDraw.Draw(image)
    
    # Calculate positions for all dots
    total_days = progress['total_days']
    day_of_year = progress['day_of_year']
    
    day_counter = 1
    for row in range(rows):
        for col in range(cols):
            if day_counter > total_days:
                break
            
            x = int(start_x + col * spacing)
            y = int(start_y + row * spacing)
            
            if day_counter < day_of_year:
                # Completed day (white)
                draw_dot(draw, x, y, dot_diameter, cfg.DOT_COMPLETED)
            elif day_counter == day_of_year:
                # Today (orange)
                draw_dot(draw, x, y, dot_diameter, cfg.DOT_TODAY)
            else:
                # Remaining day (grey)
                draw_dot(draw, x, y, dot_diameter, cfg.DOT_REMAINING)
            
            day_counter += 1
    
    # Draw bottom text
    font_size = max(14, int(dot_diameter * 0.95))
    font_stats = get_font(font_size)
    
    # Prepare text components
    days_left = progress['days_remaining']
    percentage = int(progress['percentage'])
    
    # Short format: "352d left · 3%"
    text_days = f"{days_left}d"
    text_label = " left · "
    text_percent = f"{percentage}%"
    
    # Calculate text positioning
    text_y = int(height - (height * 0.08 if is_landscape else height * 0.06))
    
    if font_stats:
        # Get text sizes
        bbox_days = draw.textbbox((0, 0), text_days, font=font_stats)
        bbox_label = draw.textbbox((0, 0), text_label, font=font_stats)
        bbox_percent = draw.textbbox((0, 0), text_percent, font=font_stats)
        
        width_days = bbox_days[2] - bbox_days[0]
        width_label = bbox_label[2] - bbox_label[0]
        width_percent = bbox_percent[2] - bbox_percent[0]
        
        total_text_width = width_days + width_label + width_percent
        
        # Center the text
        text_x = (width - total_text_width) // 2
        
        # Draw each part with different colors
        # Days number (accent - orange)
        draw.text((text_x, text_y), text_days, 
                  fill=hex_to_rgba(cfg.TEXT_ACCENT), font=font_stats)
        text_x += width_days
        
        # Label (secondary - grey)
        draw.text((text_x, text_y), text_label,
                  fill=hex_to_rgba(cfg.TEXT_SECONDARY), font=font_stats)
        text_x += width_label
        
        # Percentage (secondary - grey, matching reference)
        draw.text((text_x, text_y), text_percent,
                  fill=hex_to_rgba(cfg.TEXT_SECONDARY), font=font_stats)
    else:
        # Fallback: simple centered text
        full_text = f"{days_left}d left · {percentage}%"
        draw.text((width // 2, text_y), full_text,
                  fill=hex_to_rgba(cfg.TEXT_PRIMARY), anchor="mm")
    
    # Determine output path
    if output_path is None:
        # Check if running on Android (Termux)
        if os.path.exists('/data/data/com.termux'):
            output_dir = cfg.OUTPUT_DIR
        else:
            output_dir = cfg.DEV_OUTPUT_DIR
        
        os.makedirs(output_dir, exist_ok=True)
        output_path = os.path.join(output_dir, cfg.OUTPUT_FILENAME)
    else:
        os.makedirs(os.path.dirname(output_path), exist_ok=True)
    
    # Convert to RGB for PNG (remove alpha)
    final_image = Image.new('RGB', image.size, hex_to_rgb(cfg.BACKGROUND_COLOR))
    final_image.paste(image, mask=image.split()[3])
    
    # Save the image
    final_image.save(output_path, 'PNG', optimize=True)
    
    print(f"✓ Wallpaper generated: {output_path}")
    print(f"  {days_left}d left · {percentage}% complete")
    
    return output_path


DEVICE_PRESETS = {
    'iphone16promax': (1320, 2868),
    'iphone16pro': (1179, 2556),
    'iphone16': (1170, 2532),
    'iphonese': (750, 1334),
    's24ultra': (1440, 3120),
    's24': (1080, 2340),
    'pixel9pro': (1344, 2992),
    'pixel9': (1080, 2400),
    'ipad': (2064, 2752),
}


def main():
    """Main entry point with device model and orientation support."""
    import argparse
    parser = argparse.ArgumentParser(description="Generate Life Calendar Wallpaper for any device and orientation.")
    parser.add_argument("output", nargs="?", default=None, help="Output file path")
    parser.add_argument("--model", choices=list(DEVICE_PRESETS.keys()), default=None, help="Preset device model")
    parser.add_argument("--width", type=int, default=None, help="Exact screen width in pixels")
    parser.add_argument("--height", type=int, default=None, help="Exact screen height in pixels")
    parser.add_argument("--landscape", action="store_true", help="Generate in landscape orientation")
    
    args = parser.parse_args()
    
    w, h = None, None
    if args.model:
        w, h = DEVICE_PRESETS[args.model]
    elif args.width and args.height:
        w, h = args.width, args.height
        
    if args.landscape and w and h:
        if w < h:
            w, h = h, w
    
    try:
        generate_wallpaper(output_path=args.output, width=w, height=h)
        return 0
    except Exception as e:
        print(f"✗ Error generating wallpaper: {e}")
        if getattr(cfg, 'DEBUG_MODE', False):
            import traceback
            traceback.print_exc()
        return 1


if __name__ == "__main__":
    sys.exit(main())
