import Foundation

struct Progress {
    let year: Int
    let totalDays: Int
    let dayOfYear: Int
    let daysPassed: Int
    let daysRemaining: Int
    let percentage: Int

    static func current(for date: Date = Date(), calendar: Calendar = .current) -> Progress {
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

// Test 2026 Normal Year
var cal = Calendar(identifier: .gregorian)
cal.timeZone = TimeZone(secondsFromGMT: 0)!
var comps = DateComponents()
comps.year = 2026
comps.month = 1
comps.day = 1
let date2026 = cal.date(from: comps)!
let p2026 = Progress.current(for: date2026, calendar: cal)
assert(p2026.year == 2026, "Year should be 2026")
assert(p2026.totalDays == 365, "Total days in 2026 should be 365")
assert(p2026.dayOfYear == 1, "Jan 1 is day 1")
assert(p2026.daysPassed == 0, "0 days passed")
assert(p2026.daysRemaining == 364, "364 days remaining")
assert(p2026.percentage == 0, "0% on day 1")

// Test 2028 Leap Year
comps.year = 2028
let date2028 = cal.date(from: comps)!
let p2028 = Progress.current(for: date2028, calendar: cal)
assert(p2028.year == 2028, "Year should be 2028")
assert(p2028.totalDays == 366, "Total days in 2028 should be 366")
assert(p2028.daysRemaining == 365, "365 days remaining on Jan 1 2028")

// Test 2031 Year End
comps.year = 2031
comps.month = 12
comps.day = 31
let date2031 = cal.date(from: comps)!
let p2031 = Progress.current(for: date2031, calendar: cal)
assert(p2031.year == 2031, "Year should be 2031")
assert(p2031.totalDays == 365, "Total days in 2031 should be 365")
assert(p2031.daysRemaining == 0, "0 days remaining on Dec 31")
assert(p2031.percentage >= 99, "99% on Dec 31")

print("✓ All Swift unit tests passed successfully!")
