# Life Calendar for iOS (SwiftUI & WidgetKit)

A minimalist year-in-progress calendar wallpaper & widget for iPhone.

## ✨ Features
- **365/366 Dot Grid**: Completed days in white, current day in vivid orange (`#FF5533`), remaining days in subtle dark grey (`#555555`).
- **Dynamic Year Progression**: Automatically handles leap years (e.g. 2028 with 366 days) and any year through 2031+.
- **WidgetKit Support**: Native Lock Screen and Home Screen widgets that refresh at **12:00 AM local time** via `TimelineProvider`.
- **Apple Shortcut Automation**: Daily midnight wallpaper update workflow that runs silently in the background on iOS 16, 17, and 18.
- **Apple Jet Black Aesthetic**: Designed using San Francisco typography and Apple dark mode design principles.

## 🚀 How to Run in Xcode
1. Open Xcode and create a new iOS SwiftUI App named `LifeCalendar`.
2. Add the source files from `ios-app/` into the project:
   - `LifeCalendarApp.swift`
   - `ContentView.swift`
   - `LifeCalendarGenerator.swift`
   - `LifeCalendarWidget.swift` (add to Widget Extension)
3. Select your iPhone or Simulator and press **Run** (Cmd + R).

## ⏰ Midnight Automation on iOS
Because Apple sandboxes third-party background wallpaper changes, iOS users can enable zero-touch midnight wallpaper refresh with Apple Shortcuts:
1. Open the native **Shortcuts** app on iPhone.
2. Tap the **Automation** tab -> **New Automation**.
3. Choose **Time of Day** -> set to **12:00 AM**, **Daily**, and select **Run Immediately** (toggle off "Notify When Run").
4. Add the action **Set Wallpaper** with the Life Calendar image or shortcut.
