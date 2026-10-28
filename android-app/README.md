# Life Calendar - Android App

A beautiful, minimalistic life calendar app that sets a daily-updating wallpaper on your lock screen.

## Features

- 📅 **Year Progress Visualization**: Dot grid showing days passed, today, and remaining
- 🔄 **Auto-Updates**: Wallpaper refreshes automatically at midnight
- 🔒 **Lock Screen Only**: Sets wallpaper on lock screen without changing home screen
- 🎨 **Premium Design**: Dark theme with orange accent, matching your reference design
- ⚡ **Zero Configuration**: Just install, tap "Set Wallpaper", done!

---

## Building the APK

### Prerequisites

1. **Android Studio** (latest version recommended)
   - Download from: https://developer.android.com/studio

### Build Steps

1. **Open Android Studio**

2. **Open the Project**
   - File → Open
   - Navigate to: `c:\Users\yashm\Desktop\life\android-app`
   - Click OK and wait for Gradle sync

3. **Build the APK**
   - Build → Build Bundle(s) / APK(s) → Build APK(s)
   - Wait for build to complete

4. **Find the APK**
   - Click "locate" in the notification popup
   - Or navigate to: `android-app/app/build/outputs/apk/debug/app-debug.apk`

5. **Transfer to Phone**
   - Copy `app-debug.apk` to your phone
   - Install it (enable "Install from unknown sources" if prompted)

---

## Usage

1. **Open the App**
   - Find "Life Calendar" in your app drawer

2. **Preview**
   - The app shows a preview of your wallpaper

3. **Set Wallpaper**
   - Tap "Set Wallpaper" button
   - Done! Your lock screen now shows the life calendar

4. **Auto-Updates**
   - The app schedules daily updates at midnight
   - No need to open the app again

---

## Troubleshooting

### APK won't install
- Enable "Install from unknown sources" in Settings → Security

### Wallpaper doesn't update at midnight
- Disable battery optimization for Life Calendar in Settings → Apps → Life Calendar → Battery → Unrestricted

### Build fails
- File → Sync Project with Gradle Files
- Build → Clean Project, then Build → Rebuild Project

---

## Technical Details

- **Min SDK**: Android 8.0 (API 26)
- **Target SDK**: Android 14 (API 34)
- **Language**: Kotlin
- **Scheduling**: WorkManager for reliable background updates
- **Resolution**: 1440 × 3088 (Samsung S23 optimized)

---

## Customization

To change colors or settings, edit `WallpaperGenerator.kt`:

```kotlin
private const val COLOR_DOT_TODAY = 0xFFFF5533.toInt()  // Orange
private const val DOT_DIAMETER = 46f
private const val DOT_SPACING = 68f
```

Rebuild the APK after changes.
