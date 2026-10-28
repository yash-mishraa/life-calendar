import os
import unittest
from datetime import date
from life_calendar import get_year_progress, generate_wallpaper, DEVICE_PRESETS
from PIL import Image

class TestLifeCalendar(unittest.TestCase):

    def test_year_progress_keys(self):
        progress = get_year_progress()
        for key in ['year', 'total_days', 'day_of_year', 'days_passed', 'days_remaining', 'percentage']:
            self.assertIn(key, progress)
        self.assertIn(progress['total_days'], [365, 366])
        self.assertEqual(progress['days_passed'] + progress['days_remaining'], progress['total_days'])

    def test_presets_exist(self):
        self.assertIn('iphone16promax', DEVICE_PRESETS)
        self.assertIn('s24ultra', DEVICE_PRESETS)
        self.assertIn('pixel9pro', DEVICE_PRESETS)
        for name, (w, h) in DEVICE_PRESETS.items():
            self.assertGreater(w, 500)
            self.assertGreater(h, 500)

    def test_generate_wallpaper_portrait_and_landscape(self):
        out_dir = "output/test_run"
        os.makedirs(out_dir, exist_ok=True)
        
        p_path = os.path.join(out_dir, "portrait.png")
        l_path = os.path.join(out_dir, "landscape.png")
        
        generate_wallpaper(p_path, width=1080, height=2400)
        generate_wallpaper(l_path, width=2400, height=1080)
        
        self.assertTrue(os.path.exists(p_path))
        self.assertTrue(os.path.exists(l_path))
        
        with Image.open(p_path) as img:
            self.assertEqual(img.size, (1080, 2400))
            
        with Image.open(l_path) as img:
            self.assertEqual(img.size, (2400, 1080))
            
        # Cleanup
        os.remove(p_path)
        os.remove(l_path)
        os.rmdir(out_dir)

if __name__ == '__main__':
    unittest.main()
