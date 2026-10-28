# Life Calendar Wallpaper - Complete Setup Guide for Samsung S23

This guide will walk you through setting up the automatic life calendar wallpaper on your Samsung S23's **lock screen only**.

---

## 📱 What You'll Get

- A beautiful life calendar wallpaper that updates **every day at 12:00 AM**
- Shows your yearly progress with dots (white = completed, orange = today, grey = remaining)
- Displays "XXXd left · X%" at the bottom
- **Lock screen only** - your home screen wallpaper stays unchanged

---

## 📋 Prerequisites

You'll need to install **3 apps** on your Samsung S23:

| App | Where to Get | Purpose |
|-----|--------------|---------|
| **Termux** | F-Droid (NOT Play Store!) | Runs Python scripts |
| **Termux:Tasker** | F-Droid | Connects Tasker to Termux |
| **Tasker** | Play Store (₹350) | Automation scheduler |

> ⚠️ **IMPORTANT**: You MUST install Termux from F-Droid, not Play Store. The Play Store version is outdated and broken.

---

## 🔧 STEP 1: Install F-Droid

F-Droid is an alternative app store for open-source apps.

1. Open Chrome on your S23
2. Go to: **https://f-droid.org**
3. Tap **"Download F-Droid"**
4. Open your Downloads and tap the APK file
5. If prompted, allow Chrome to install unknown apps:
   - Settings → Apps → Chrome → Install unknown apps → Allow
6. Install F-Droid
7. Open F-Droid and let it update its repository (may take 1-2 minutes)

---

## 🔧 STEP 2: Install Termux from F-Droid

1. Open **F-Droid**
2. Search for **"Termux"**
3. Install **Termux** (by Fredrik Fornwall)
4. Also search and install **"Termux:Tasker"**
5. Open Termux once to initialize it

---

## 🔧 STEP 3: Install Tasker from Play Store

1. Open **Play Store**
2. Search for **"Tasker"**
3. Purchase and install **Tasker** (by João Dias)

---

## 🔧 STEP 4: Set Up Termux

Open **Termux** and run these commands one by one:

### 4.1 Update packages
```bash
pkg update && pkg upgrade -y
```
Type `y` and press Enter if prompted.

### 4.2 Install Python
```bash
pkg install python -y
```

### 4.3 Install Pillow (image library)
```bash
pip install Pillow
```

### 4.4 Grant storage access
```bash
termux-setup-storage
```
A popup will appear - tap **"Allow"** to grant storage permission.

### 4.5 Create directories
```bash
mkdir -p ~/life_calendar
mkdir -p ~/.termux/tasker
mkdir -p /storage/emulated/0/Pictures/LifeCalendar
```

### 4.6 Verify installation
```bash
python --version
python -c "from PIL import Image; print('✓ Pillow installed successfully')"
```

You should see the Python version and "✓ Pillow installed successfully".

---

## 🔧 STEP 5: Transfer Python Scripts to Your Phone

### Option A: Using USB Cable (Recommended)

1. Connect your S23 to your computer via USB
2. On your phone, select **"File Transfer / Android Auto"** in the USB popup
3. On your computer, open File Explorer
4. Navigate to your phone → **Internal storage → Download**
5. Copy these files from `c:\Users\yashm\Desktop\life\`:
   - `life_calendar.py`
   - `config.py`
6. Also copy `tasker\life_calendar.sh`

### Option B: Using Google Drive

1. Upload `life_calendar.py`, `config.py`, and `life_calendar.sh` to Google Drive
2. On your phone, download them to your Downloads folder

---

## 🔧 STEP 6: Move Files to Correct Locations

Open **Termux** and run:

### 6.1 Copy Python scripts
```bash
cp /storage/emulated/0/Download/life_calendar.py ~/life_calendar/
cp /storage/emulated/0/Download/config.py ~/life_calendar/
```

### 6.2 Copy and set up Tasker trigger script
```bash
cp /storage/emulated/0/Download/life_calendar.sh ~/.termux/tasker/
chmod +x ~/.termux/tasker/life_calendar.sh
```

### 6.3 Verify files are in place
```bash
ls -la ~/life_calendar/
ls -la ~/.termux/tasker/
```

You should see `life_calendar.py` and `config.py` in the first output, and `life_calendar.sh` in the second.

---

## 🔧 STEP 7: Test the Script

In Termux, run:

```bash
cd ~/life_calendar
python life_calendar.py
```

You should see:
```
✓ Wallpaper generated: /storage/emulated/0/Pictures/LifeCalendar/life_calendar.png
  353d left · 3% complete
```

### Verify the image was created:
1. Open your **Gallery** app
2. Go to **Albums → LifeCalendar**
3. You should see the wallpaper image

---

## 🔧 STEP 8: Configure Tasker

### 8.1 Grant Termux:Tasker Permission

1. Open **Termux:Tasker** app
2. It will show instructions - follow them
3. The app needs to be opened once to register with Tasker

### 8.2 Create the Task in Tasker

1. Open **Tasker**
2. If this is your first time, follow the initial setup
3. Go to the **Tasks** tab (bottom of screen)
4. Tap the **+** button to create a new task
5. Name it: `Generate Life Calendar`
6. Tap the checkmark ✓

### 8.3 Add Action 1: Run Termux Script

1. Tap **+** to add an action
2. Select **Plugin** → **Termux:Tasker**
3. Tap the **pencil icon** ✏️ to configure
4. Set:
   - **Executable**: `life_calendar.sh`
   - **Arguments**: (leave empty)
   - **Working Directory**: (leave empty)
   - **Wait for result**: ✓ Enable this
   - **Timeout**: 30 seconds
5. Tap the **back arrow** to save

### 8.4 Add Action 2: Wait

1. Tap **+** to add another action
2. Select **Task** → **Wait**
3. Set **Seconds**: `3`
4. Tap back to save

### 8.5 Add Action 3: Set Lock Screen Wallpaper

1. Tap **+** to add another action
2. Select **Display** → **Set Wallpaper**
3. Configure:
   - **Image**: Tap the folder icon 📁
   - Navigate to: **Pictures → LifeCalendar → life_calendar.png**
   - **Set On**: Select **"Lock Screen"** (NOT "Both" or "Home Screen")
4. Tap back to save

### 8.6 Test the Task

1. In your task, tap the **Play button** ▶️ at the bottom
2. Wait for it to complete
3. Lock your phone and check if the wallpaper updated!

---

## 🔧 STEP 9: Set Up Daily Automation

### 9.1 Create a Time Profile

1. Go to the **Profiles** tab in Tasker
2. Tap **+** to create a new profile
3. Select **Time**
4. Configure:
   - **From**: 12:00 AM (00:00)
   - **To**: 12:00 AM (00:00) (same time)
   - This triggers exactly at midnight
5. Tap back

### 9.2 Link to Your Task

1. Tasker will ask you to select a task
2. Choose **Generate Life Calendar**
3. Tap back to save

### 9.3 Enable the Profile

1. Make sure the profile shows a **green checkmark** (enabled)
2. If it shows grey, tap on it to enable

---

## 🔧 STEP 10: Grant Necessary Permissions

### 10.1 Disable Battery Optimization for Tasker

1. Go to **Settings** → **Apps** → **Tasker**
2. Tap **Battery**
3. Select **"Unrestricted"**

### 10.2 Disable Battery Optimization for Termux

1. Go to **Settings** → **Apps** → **Termux**
2. Tap **Battery**
3. Select **"Unrestricted"**

### 10.3 Allow Tasker to Set Wallpaper

1. Go to **Settings** → **Apps** → **Tasker**
2. Tap **Permissions**
3. Enable **Storage** permission

### 10.4 Lock Tasker in Recent Apps (Optional but Recommended)

1. Open Recent Apps (swipe up and hold)
2. Find Tasker
3. Long-press the Tasker icon
4. Tap **"Lock this app"** 🔒

---

## ✅ STEP 11: Final Verification

### Test 1: Manual Run
1. Open Tasker → Tasks → Generate Life Calendar → Play ▶️
2. Check your lock screen

### Test 2: Wait for Midnight
1. Leave everything running
2. At 12:00 AM, the wallpaper should auto-update

### Check Tomorrow
- Lock your phone in the morning
- The orange dot should have moved to the next position
- The days count should have decreased by 1

---

## 🔧 Troubleshooting

### "Termux:Tasker - No executable found"
```bash
# In Termux, verify the script exists:
ls -la ~/.termux/tasker/life_calendar.sh

# If not found, recreate it:
cat > ~/.termux/tasker/life_calendar.sh << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash
cd ~/life_calendar
python life_calendar.py
EOF
chmod +x ~/.termux/tasker/life_calendar.sh
```

### "Permission denied" when saving wallpaper
```bash
# Grant storage access again:
termux-setup-storage
```

### Wallpaper doesn't update at midnight
1. Check Tasker profile is enabled (green)
2. Check battery optimization is disabled for Tasker and Termux
3. Lock Tasker in recent apps

### Script runs but wallpaper doesn't change
1. In Tasker, verify the wallpaper path is correct
2. Make sure you selected "Lock Screen" not "Both"
3. Try running the task manually

---

## 📁 File Locations Reference

| File | Location on Phone |
|------|-------------------|
| Python scripts | `/data/data/com.termux/files/home/life_calendar/` |
| Tasker script | `/data/data/com.termux/files/home/.termux/tasker/life_calendar.sh` |
| Wallpaper output | `/storage/emulated/0/Pictures/LifeCalendar/life_calendar.png` |

---

## 🎨 Customization

To change colors or dot size, edit the config file in Termux:

```bash
nano ~/life_calendar/config.py
```

- `DOT_TODAY = "#ff5533"` - Change orange dot color
- `DOT_REMAINING = "#555555"` - Change grey dot color
- `DOT_DIAMETER = 46` - Change dot size
- `DOT_SPACING = 68` - Change spacing between dots

After editing, save with `Ctrl+X`, then `Y`, then `Enter`.

---

## 🎉 You're Done!

Your Samsung S23 lock screen will now automatically update every day at midnight with your life calendar progress.

**Enjoy tracking your year!** 📅
