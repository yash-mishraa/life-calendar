import Foundation
import CoreGraphics
#if canImport(UIKit)
import UIKit

/// Generates the Life Calendar wallpaper for iOS devices.
/// Adapts dynamically to any device screen size, model, and orientation.
public struct LifeCalendarGenerator {

    public enum DeviceModel: String, CaseIterable {
        case iPhone16ProMax = "iPhone 16 / 15 Pro Max (1320x2868)"
        case iPhone16Pro = "iPhone 16 / 15 / 14 Pro (1179x2556)"
        case iPhone16 = "iPhone 16 / 15 / 14 / 13 (1170x2532)"
        case iPhoneSE = "iPhone SE / 8 (750x1334)"
        case iPadPro13 = "iPad Pro 13\" (2064x2752)"
        case iPadAir = "iPad Air / 11\" (1640x2360)"

        public var resolution: (width: CGFloat, height: CGFloat) {
            switch self {
            case .iPhone16ProMax: return (1320, 2868)
            case .iPhone16Pro: return (1179, 2556)
            case .iPhone16: return (1170, 2532)
            case .iPhoneSE: return (750, 1334)
            case .iPadPro13: return (2064, 2752)
            case .iPadAir: return (1640, 2360)
            }
        }
    }

    public struct Progress {
        public let year: Int
        public let totalDays: Int
        public let dayOfYear: Int
        public let daysPassed: Int
        public let daysRemaining: Int
        public let percentage: Int
        
        public static func current(for date: Date = Date(), calendar: Calendar = .current) -> Progress {
            let year = calendar.component(.year, from: date)
            let isLeapYear = (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)
            let totalDays = isLeapYear ? 366 : 365
            let dayOfYear = calendar.ordinality(of: .day, in: .year, for: date) ?? 1
            let daysPassed = max(0, dayOfYear - 1)
            let daysRemaining = max(0, totalDays - dayOfYear)
            let percentage = (daysPassed * 100) / totalDays
            
            return Progress(
                year: year,
                totalDays: totalDays,
                dayOfYear: dayOfYear,
                daysPassed: daysPassed,
                daysRemaining: daysRemaining,
                percentage: percentage
            )
        }
    }

    /// Automatically detects the connected device's native screen size and orientation.
    public static func currentScreenSize() -> (width: CGFloat, height: CGFloat) {
        let screen = UIScreen.main
        let nativeBounds = screen.nativeBounds
        return (nativeBounds.width, nativeBounds.height)
    }

    /// Generates a wallpaper perfectly sized for the target screen dimensions and orientation.
    public static func generateImage(
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        date: Date = Date(),
        calendar: Calendar = .current
    ) -> UIImage {
        let (resolvedW, resolvedH): (CGFloat, CGFloat) = {
            if let w = width, let h = height {
                return (w, h)
            }
            return currentScreenSize()
        }()

        let isLandscape = resolvedW > resolvedH
        let columns = isLandscape ? 25 : 15
        let rows = isLandscape ? 15 : 25

        let progress = Progress.current(for: date, calendar: calendar)
        let bounds = CGRect(x: 0, y: 0, width: resolvedW, height: resolvedH)
        
        let renderer = UIGraphicsImageRenderer(size: bounds.size)
        return renderer.image { ctx in
            let cg = ctx.cgContext
            
            // Background: Deep Jet Black
            cg.setFillColor(UIColor(red: 0x1C/255.0, green: 0x1C/255.0, blue: 0x1C/255.0, alpha: 1.0).cgColor)
            cg.fill(bounds)
            
            // Proportional responsive grid calculations
            let maxGridW = resolvedW * 0.82
            let maxGridH = isLandscape ? (resolvedH * 0.68) : (resolvedH * 0.58)

            let spacingX = maxGridW / CGFloat(columns - 1)
            let spacingY = maxGridH / CGFloat(rows - 1)
            let dotSpacing = min(spacingX, spacingY)
            let dotDiameter = dotSpacing * 0.68

            let gridWidth = CGFloat(columns - 1) * dotSpacing + dotDiameter
            let gridHeight = CGFloat(rows - 1) * dotSpacing + dotDiameter

            let startX = (resolvedW - gridWidth) / 2.0 + (dotDiameter / 2.0)
            let startY = isLandscape ?
                ((resolvedH - gridHeight) / 2.0 - (resolvedH * 0.03)) :
                (resolvedH * 0.20) // Leaves room for dynamic island & lockscreen clock
            
            var dayCounter = 1
            for row in 0..<rows {
                for col in 0..<columns {
                    if dayCounter > progress.totalDays { break }
                    
                    let cx = startX + CGFloat(col) * dotSpacing
                    let cy = startY + CGFloat(row) * dotSpacing
                    let dotRect = CGRect(x: cx - dotDiameter/2.0, y: cy - dotDiameter/2.0, width: dotDiameter, height: dotDiameter)
                    
                    let color: UIColor
                    if dayCounter < progress.dayOfYear {
                        color = .white
                    } else if dayCounter == progress.dayOfYear {
                        color = UIColor(red: 1.0, green: 0x55/255.0, blue: 0x33/255.0, alpha: 1.0) // Accent orange
                    } else {
                        color = UIColor(red: 0x55/255.0, green: 0x55/255.0, blue: 0x55/255.0, alpha: 1.0) // Muted grey
                    }
                    
                    cg.setFillColor(color.cgColor)
                    cg.fillEllipse(in: dotRect)
                    dayCounter += 1
                }
            }
            
            // Bottom stats text: e.g. "351d left · 3%"
            let fontSize: CGFloat = dotDiameter * 1.0
            let font = UIFont.systemFont(ofSize: fontSize, weight: .regular)
            
            let daysText = "\(progress.daysRemaining)d"
            let labelText = " left · "
            let percentText = "\(progress.percentage)%"
            
            let accentColor = UIColor(red: 1.0, green: 0x55/255.0, blue: 0x33/255.0, alpha: 1.0)
            let greyColor = UIColor(red: 0x55/255.0, green: 0x55/255.0, blue: 0x55/255.0, alpha: 1.0)
            
            let fullString = NSMutableAttributedString()
            fullString.append(NSAttributedString(string: daysText, attributes: [
                .font: font,
                .foregroundColor: accentColor
            ]))
            fullString.append(NSAttributedString(string: labelText, attributes: [
                .font: font,
                .foregroundColor: greyColor
            ]))
            fullString.append(NSAttributedString(string: percentText, attributes: [
                .font: font,
                .foregroundColor: greyColor
            ]))
            
            let textSize = fullString.size()
            let textY = resolvedH - (isLandscape ? (resolvedH * 0.08) : (resolvedH * 0.06))
            let textX = (resolvedW - textSize.width) / 2.0
            
            fullString.draw(at: CGPoint(x: textX, y: textY))
        }
    }
}
#endif
