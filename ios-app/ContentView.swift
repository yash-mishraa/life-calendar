import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

public struct ContentView: View {
    @State private var progress = LifeCalendarGenerator.Progress.current()
    @State private var showingSavedAlert = false
    @State private var showingAutomationSheet = false

    private let backgroundColor = Color(red: 0x1C/255.0, green: 0x1C/255.0, blue: 0x1C/255.0)
    private let accentOrange = Color(red: 1.0, green: 0x55/255.0, blue: 0x33/255.0)
    private let mutedGrey = Color(red: 0x55/255.0, green: 0x55/255.0, blue: 0x55/255.0)

    public init() {}

    public var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()

            VStack(spacing: 24) {
                // Header
                VStack(spacing: 4) {
                    Text("LIFE CALENDAR")
                        .font(.system(size: 13, weight: .semibold, design: .default))
                        .tracking(3)
                        .foregroundColor(mutedGrey)
                    
                    Text("\(String(progress.year))")
                        .font(.system(size: 28, weight: .bold, design: .default))
                        .foregroundColor(.white)
                }
                .padding(.top, 16)

                // Dot grid preview
                DotGridView(progress: progress)
                    .frame(maxWidth: 320, maxHeight: 440)
                    .padding()
                    .background(Color.black)
                    .cornerRadius(18)
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(Color(white: 0.15), lineWidth: 1)
                    )

                // Stats footer
                HStack(spacing: 4) {
                    Text("\(progress.daysRemaining)d")
                        .foregroundColor(accentOrange)
                        .fontWeight(.medium)
                    Text("left ·")
                        .foregroundColor(mutedGrey)
                    Text("\(progress.percentage)% complete")
                        .foregroundColor(mutedGrey)
                }
                .font(.system(size: 16))

                Text("Updates automatically at local midnight")
                    .font(.system(size: 13))
                    .foregroundColor(mutedGrey)

                Spacer()

                // Actions
                VStack(spacing: 12) {
                    Button(action: saveWallpaperToPhotos) {
                        HStack {
                            Image(systemName: "arrow.down.to.line")
                            Text("Save Wallpaper to Photos")
                        }
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(Color.white)
                        .cornerRadius(14)
                    }

                    Button(action: { showingAutomationSheet = true }) {
                        HStack {
                            Image(systemName: "bolt.fill")
                            Text("Set Midnight Automation")
                        }
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color(red: 0x14/255.0, green: 0x14/255.0, blue: 0x14/255.0))
                        .cornerRadius(14)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color(white: 0.18), lineWidth: 1)
                        )
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 20)
            }
        }
        .alert("Wallpaper Saved", isPresented: $showingSavedAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("The 4K Retina wallpaper has been saved to your Photos. You can now set it as your Lock Screen & Home Screen.")
        }
        .sheet(isPresented: $showingAutomationSheet) {
            AutomationGuideView(accentOrange: accentOrange)
        }
    }

    private func saveWallpaperToPhotos() {
        #if canImport(UIKit)
        let image = LifeCalendarGenerator.generateImage()
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        showingSavedAlert = true
        #endif
    }
}

struct DotGridView: View {
    let progress: LifeCalendarGenerator.Progress
    private let columns = 15
    private let rows = 25
    private let accentOrange = Color(red: 1.0, green: 0x55/255.0, blue: 0x33/255.0)

    var body: some View {
        GeometryReader { geo in
            let spacing: CGFloat = geo.size.width / CGFloat(columns + 1)
            let dotSize: CGFloat = spacing * 0.65

            Canvas { ctx, size in
                var dayCounter = 1
                for row in 0..<rows {
                    for col in 0..<columns {
                        if dayCounter > progress.totalDays { break }

                        let x = spacing * CGFloat(col) + spacing / 2.0
                        let y = spacing * CGFloat(row) + spacing / 2.0
                        let rect = CGRect(x: x, y: y, width: dotSize, height: dotSize)

                        let color: Color
                        if dayCounter < progress.dayOfYear {
                            color = .white
                        } else if dayCounter == progress.dayOfYear {
                            color = accentOrange
                        } else {
                            color = Color(white: 0.35)
                        }

                        ctx.fill(Path(ellipseIn: rect), with: .color(color))
                        dayCounter += 1
                    }
                }
            }
        }
    }
}

struct AutomationGuideView: View {
    let accentOrange: Color
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            Color(red: 0x12/255.0, green: 0x12/255.0, blue: 0x12/255.0).ignoresSafeArea()

            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text("Auto-Update at 12:00 AM")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                    Spacer()
                    Button("Done") { dismiss() }
                        .foregroundColor(accentOrange)
                }
                .padding(.top, 16)

                Text("Apple iOS strictly requires the native Shortcuts app for background wallpaper updates without user intervention:")
                    .foregroundColor(.gray)
                    .font(.subheadline)

                VStack(alignment: .leading, spacing: 14) {
                    StepRow(number: "1", title: "Open Apple Shortcuts", description: "Tap the 'Automation' tab at the bottom.")
                    StepRow(number: "2", title: "New Automation", description: "Choose 'Time of Day' -> Set to 12:00 AM, Daily, and 'Run Immediately' (Don't Ask).")
                    StepRow(number: "3", title: "Set Wallpaper", description: "Select 'Life Calendar' shortcut or choose the daily saved photo as Lock Screen & Home Screen wallpaper.")
                }

                Spacer()
            }
            .padding(24)
        }
    }
}

struct StepRow: View {
    let number: String
    let title: String
    let description: String

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Text(number)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.black)
                .frame(width: 24, height: 24)
                .background(Color.white)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                Text(description)
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
            }
        }
    }
}
