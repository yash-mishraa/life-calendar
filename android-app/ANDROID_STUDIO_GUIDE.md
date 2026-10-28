# Life Calendar APK - Complete Android Studio Guide

A step-by-step guide for first-time Android Studio users.

---

## 📥 PART 1: Installing Android Studio

### Step 1.1: Download
1. Go to: https://developer.android.com/studio
2. Click the big green **"Download Android Studio"** button
3. Accept the terms and click **"Download"**
4. Wait for the download (~1 GB file)

### Step 1.2: Run the Installer
1. Open the downloaded file: `android-studio-xxxx-windows.exe`
2. Click **"Yes"** if Windows asks for permission

### Step 1.3: Installation Wizard
Follow these screens:

| Screen | What to do |
|--------|------------|
| Welcome | Click **Next** |
| Choose Components | Keep all checked ✓, click **Next** |
| Install Location | Keep default, click **Next** |
| Choose Start Menu Folder | Keep default, click **Install** |
| Installing... | Wait (5-10 minutes) |
| Completing | Make sure "Start Android Studio" is checked ✓, click **Finish** |

---

## 🚀 PART 2: First-Time Setup (After Installation)

### Step 2.1: Welcome Screen
1. Android Studio opens with **"Welcome to Android Studio"**
2. Click **"Do not import settings"** (since you're new)
3. Click **OK**

### Step 2.2: Setup Wizard
1. You'll see **"Android Studio Setup Wizard"**
2. Click **Next**

### Step 2.3: Install Type
1. Select **"Standard"** (recommended)
2. Click **Next**

### Step 2.4: Select UI Theme
1. Choose **"Darcula"** (dark theme) or **"Light"**
2. Click **Next**

### Step 2.5: Verify Settings
1. Shows what will be downloaded (Android SDK, etc.)
2. Click **Next**

### Step 2.6: License Agreement
1. Click on **"android-sdk-license"** on the left
2. Click **"Accept"** on the right
3. Click on **"android-sdk-preview-license"** (if shown)
4. Click **"Accept"**
5. Click **Finish**

### Step 2.7: Downloading Components
1. Wait for downloads to complete (10-20 minutes depending on internet)
2. You'll see progress bars for SDK, Emulator, etc.
3. When done, click **Finish**

---

## 📂 PART 3: Opening the Life Calendar Project

### Step 3.1: Welcome Screen
1. After setup, you'll see the **Welcome to Android Studio** screen
2. Click **"Open"** (NOT "New Project")

### Step 3.2: Navigate to Project Folder
1. A file browser opens
2. Navigate to: `C:\Users\yashm\Desktop\life\android-app`
3. Click on the **"android-app"** folder to select it
4. Click **OK**

### Step 3.3: Trust the Project
1. A popup asks "Trust and Open Project?"
2. Click **"Trust Project"**

### Step 3.4: Wait for Gradle Sync
1. Android Studio opens with the project
2. At the bottom, you'll see **"Gradle sync..."** with a progress bar
3. **WAIT for this to complete** (first time takes 5-10 minutes)
4. You'll see messages downloading dependencies
5. When done, the bottom bar will be clear

### Step 3.5: If You See Errors
If you see red error messages:
1. Click on **File** menu → **Sync Project with Gradle Files**
2. Wait for sync to complete
3. If still errors, try: **Build** menu → **Clean Project**, then **Build** → **Rebuild Project**

---

## 🔨 PART 4: Building the APK

### Step 4.1: Start the Build
1. Click on the **Build** menu (top menu bar)
2. Click on **Build Bundle(s) / APK(s)**
3. Click on **Build APK(s)**

### Step 4.2: Wait for Build
1. Bottom of screen shows progress: **"Gradle Build Running..."**
2. Wait 1-2 minutes
3. When done, a popup appears in bottom-right corner

### Step 4.3: Find Your APK
1. In the popup, click **"locate"**
2. File Explorer opens to the APK location
3. Your APK file is: **app-debug.apk**

**Or navigate manually to:**
```
C:\Users\yashm\Desktop\life\android-app\app\build\outputs\apk\debug\app-debug.apk
```

---

## 📱 PART 5: Installing on Your Samsung S23

### Step 5.1: Transfer the APK

**Option A: USB Cable**
1. Connect your S23 to computer with USB cable
2. On your phone, a popup appears - select **"File Transfer"**
3. On computer, open File Explorer
4. Find your phone (left sidebar)
5. Open **Internal storage** → **Download**
6. Copy `app-debug.apk` here

**Option B: Google Drive / Email**
1. Upload `app-debug.apk` to Google Drive
2. On your phone, open Google Drive
3. Download the APK

### Step 5.2: Install the APK

1. On your phone, open **Files** or **My Files** app
2. Go to **Downloads**
3. Tap on **app-debug.apk**
4. If prompted about "Install unknown apps":
   - Tap **Settings**
   - Enable **"Allow from this source"**
   - Go back and tap **Install**
5. Tap **Open** when installation completes

---

## ✅ PART 6: Using the App

### First Time Setup
1. Open the **Life Calendar** app
2. You'll see a preview of your wallpaper
3. Tap **"Set Wallpaper"**
4. Done! ✓

### What Happens Now
- Your lock screen shows the life calendar
- The app auto-updates every night at midnight
- You never need to open the app again!

### Verify It Works
1. Lock your phone (press power button)
2. You should see your life calendar wallpaper!
3. White dots = days passed
4. Orange dot = today  
5. Grey dots = remaining days

---

## 🔧 Troubleshooting

### "Gradle sync failed"
1. File → **Sync Project with Gradle Files**
2. If still failing, check your internet connection

### "SDK location not found"
1. File → **Project Structure** → **SDK Location**
2. It should auto-detect. If not, close Android Studio and reopen.

### "Build failed"
1. Build → **Clean Project**
2. Build → **Rebuild Project**

### APK won't install on phone
1. Go to phone **Settings** → **Apps** → **Special access** → **Install unknown apps**
2. Find the app you're using to install (Files/Drive)
3. Enable **Allow from this source**

### Wallpaper doesn't show on lock screen
1. Make sure you tapped "Set Wallpaper" in the app
2. Some Samsung phones: Settings → Wallpaper → check if it's applied

---

## 📋 Quick Reference

| Task | Location |
|------|----------|
| Open project | File → Open → `C:\Users\yashm\Desktop\life\android-app` |
| Build APK | Build → Build Bundle(s) / APK(s) → Build APK(s) |
| Find APK | `app\build\outputs\apk\debug\app-debug.apk` |
| Clean build | Build → Clean Project |
| Sync Gradle | File → Sync Project with Gradle Files |

---

## 🎉 You Did It!

Once you've completed these steps, you'll have:
- ✅ A working Life Calendar app on your phone
- ✅ Automatic daily updates at midnight
- ✅ Lock screen only (home screen unchanged)
- ✅ No need for Termux, Tasker, or any other apps!

**Enjoy tracking your year!** 📅
