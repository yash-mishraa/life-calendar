package com.life.calendar

import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test
import java.util.Calendar

class WallpaperGeneratorTest {

    @Test
    fun testNormalYear2026() {
        val cal = Calendar.getInstance().apply {
            set(Calendar.YEAR, 2026)
            set(Calendar.MONTH, Calendar.JANUARY)
            set(Calendar.DAY_OF_MONTH, 1)
        }
        val progress = WallpaperGenerator.getYearProgress(cal)
        assertEquals(2026, progress.year)
        assertEquals(365, progress.totalDays)
        assertEquals(1, progress.dayOfYear)
        assertEquals(0, progress.daysPassed)
        assertEquals(364, progress.daysRemaining)
        assertEquals(0, progress.percentage)
    }

    @Test
    fun testLeapYear2028() {
        val cal = Calendar.getInstance().apply {
            set(Calendar.YEAR, 2028)
            set(Calendar.MONTH, Calendar.JANUARY)
            set(Calendar.DAY_OF_MONTH, 1)
        }
        val progress = WallpaperGenerator.getYearProgress(cal)
        assertEquals(2028, progress.year)
        assertEquals(366, progress.totalDays)
        assertEquals(1, progress.dayOfYear)
        assertEquals(365, progress.daysRemaining)
    }

    @Test
    fun testYear2031() {
        val cal = Calendar.getInstance().apply {
            set(Calendar.YEAR, 2031)
            set(Calendar.MONTH, Calendar.DECEMBER)
            set(Calendar.DAY_OF_MONTH, 31)
        }
        val progress = WallpaperGenerator.getYearProgress(cal)
        assertEquals(2031, progress.year)
        assertEquals(365, progress.totalDays)
        assertEquals(365, progress.dayOfYear)
        assertEquals(364, progress.daysPassed)
        assertEquals(0, progress.daysRemaining)
        assertTrue(progress.percentage >= 99)
    }

    @Test
    fun testLeapYearCenturyRules() {
        // 2000 is divisible by 400 -> leap year (366 days)
        val cal2000 = Calendar.getInstance().apply {
            set(Calendar.YEAR, 2000)
            set(Calendar.DAY_OF_YEAR, 100)
        }
        assertEquals(366, WallpaperGenerator.getYearProgress(cal2000).totalDays)

        // 2100 is divisible by 100 but not 400 -> normal year (365 days)
        val cal2100 = Calendar.getInstance().apply {
            set(Calendar.YEAR, 2100)
            set(Calendar.DAY_OF_YEAR, 100)
        }
        assertEquals(365, WallpaperGenerator.getYearProgress(cal2100).totalDays)
    }
}
