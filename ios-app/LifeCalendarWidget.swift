import WidgetKit
import SwiftUI

/// WidgetKit implementation for iOS Lock Screen & Home Screen.
/// Automatically updates at midnight in the device's local timezone using TimelineProvider.
public struct LifeCalendarTimelineProvider: TimelineProvider {
    public typealias Entry = CalendarEntry

    public struct CalendarEntry: TimelineEntry {
        public let date: Date
        public let progress: LifeCalendarGenerator.Progress
    }

    public func placeholder(in context: Context) -> CalendarEntry {
        CalendarEntry(date: Date(), progress: LifeCalendarGenerator.Progress.current())
    }

    public func getSnapshot(in context: Context, completion: @escaping (CalendarEntry) -> Void) {
        let entry = CalendarEntry(date: Date(), progress: LifeCalendarGenerator.Progress.current())
        completion(entry)
    }

    public func getTimeline(in context: Context, completion: @escaping (Timeline<CalendarEntry>) -> Void) {
        let currentDate = Date()
        let currentEntry = CalendarEntry(date: currentDate, progress: LifeCalendarGenerator.Progress.current(for: currentDate))

        // Schedule next reload for next local midnight (00:00:05)
        var calendar = Calendar.current
        calendar.timeZone = .current // User's local timezone
        
        let nextMidnight = calendar.nextDate(
            after: currentDate,
            matching: DateComponents(hour: 0, minute: 0, second: 5),
            matchingPolicy: .nextTime
        ) ?? currentDate.addingTimeInterval(86400)

        let timeline = Timeline(entries: [currentEntry], policy: .after(nextMidnight))
        completion(timeline)
    }
}

public struct LifeCalendarWidgetEntryView: View {
    var entry: LifeCalendarTimelineProvider.Entry
    @Environment(\.widgetFamily) var family

    public var body: some View {
        ZStack {
            Color(red: 0x1C/255.0, green: 0x1C/255.0, blue: 0x1C/255.0).ignoresSafeArea()

            VStack(spacing: 8) {
                DotGridView(progress: entry.progress)
                    .padding(8)

                HStack(spacing: 4) {
                    Text("\(entry.progress.daysRemaining)d")
                        .foregroundColor(Color(red: 1.0, green: 0x55/255.0, blue: 0x33/255.0))
                        .fontWeight(.semibold)
                    Text("left · \(entry.progress.percentage)%")
                        .foregroundColor(Color(red: 0x55/255.0, green: 0x55/255.0, blue: 0x55/255.0))
                }
                .font(.system(size: 11))
            }
        }
    }
}

public struct LifeCalendarWidget: Widget {
    public let kind: String = "LifeCalendarWidget"

    public init() {}

    public var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: LifeCalendarTimelineProvider()) { entry in
            LifeCalendarWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Life Calendar")
        .description("Yearly progress dot grid updated daily at midnight.")
        .supportedFamilies([.systemMedium, .systemLarge, .accessoryRectangular])
    }
}
