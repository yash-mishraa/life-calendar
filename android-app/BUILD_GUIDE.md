# Life Calendar - Android App Build Guide

Since Android Studio is not installed on your system, here are **two options** to build the APK:

---

## Option 1: Build with Android Studio (Recommended)

### Step 1: Download Android Studio
1. Go to: https://developer.android.com/studio
2. Download Android Studio (about 1 GB)
3. Install it (takes 10-15 minutes)

### Step 2: Open the Project
1. Launch Android Studio
2. Click **"Open"**
3. Navigate to: `c:\Users\yashm\Desktop\life\android-app`
4. Click **OK**
5. Wait for Gradle sync to complete (first time takes a few minutes)

### Step 3: Build the APK
1. Go to **Build** menu → **Build Bundle(s) / APK(s)** → **Build APK(s)**
2. Wait for the build to complete
3. Click **"locate"** in the popup to find your APK

### Step 4: Install on Phone
1. Connect your Samsung S23 via USB
2. Copy `app-debug.apk` to your phone
3. Open the APK and install it
4. Enable "Install from unknown sources" if prompted

---

## Option 2: Build Online (No Installation Required)

If you don't want to install Android Studio, you can use an online build service:

### Using GitHub + GitHub Actions

1. Create a GitHub account (if you don't have one)
2. Create a new repository
3. Upload the `android-app` folder contents
4. I can provide a GitHub Actions workflow that builds the APK automatically

Would you like me to set this up?

---

## Option 3: Pre-built APK (Fastest)

If you have access to another computer with Android Studio, or if you want me to guide you through building on a cloud service, let me know!

---

## What the App Does

Once installed:
1. Open the app
2. Tap **"Set Wallpaper"**
3. Done! ✓

The app will:
- Set the life calendar as your **lock screen only**
- Auto-update every night at midnight
- Survive phone restarts

---

## Files Created

```
android-app/
├── app/
│   ├── src/main/
│   │   ├── java/com/life/calendar/
│   │   │   ├── MainActivity.kt           # Main UI
│   │   │   ├── WallpaperGenerator.kt     # Draws the calendar
│   │   │   ├── WallpaperUpdateWorker.kt  # Background updates
│   │   │   └── BootReceiver.kt           # Restart handling
│   │   ├── res/
│   │   │   ├── layout/activity_main.xml  # App layout
│   │   │   ├── values/                   # Colors, strings, theme
│   │   │   └── drawable/                 # Buttons, icons
│   │   └── AndroidManifest.xml           # App permissions
│   └── build.gradle.kts                  # App dependencies
├── build.gradle.kts                      # Project config
├── settings.gradle.kts                   # Module settings
└── README.md                             # This file
```
