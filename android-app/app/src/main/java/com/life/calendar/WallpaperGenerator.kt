package com.life.calendar

import android.app.WallpaperManager
import android.content.Context
import android.graphics.*
import java.util.Calendar

/**
 * Generates the Life Calendar wallpaper image.
 * Premium minimalistic design matching the reference.
 */
object WallpaperGenerator {

    // Colors (matching reference exactly)
    private const val COLOR_BACKGROUND = 0xFF1C1C1C.toInt()
    private const val COLOR_DOT_COMPLETED = 0xFFFFFFFF.toInt()
    private const val COLOR_DOT_REMAINING = 0xFF555555.toInt()
    private const val COLOR_DOT_TODAY = 0xFFFF5533.toInt()
    private const val COLOR_TEXT_SECONDARY = 0xFF555555.toInt()
    private const val COLOR_TEXT_ACCENT = 0xFFFF5533.toInt()

    data class YearProgress(
        val year: Int,
        val totalDays: Int,
        val dayOfYear: Int,
        val daysPassed: Int,
        val daysRemaining: Int,
        val percentage: Int
    )

    fun getYearProgress(calendar: Calendar = Calendar.getInstance()): YearProgress {
        val year = calendar.get(Calendar.YEAR)
        val dayOfYear = calendar.get(Calendar.DAY_OF_YEAR)
        
        // Leap year calculation - works dynamically for 2026, 2027, 2028, 2029, 2030, 2031+
        val isLeapYear = when {
            year % 400 == 0 -> true
            year % 100 == 0 -> false
            year % 4 == 0 -> true
            else -> false
        }
        val totalDays = if (isLeapYear) 366 else 365
        
        val daysRemaining = totalDays - dayOfYear
        val daysPassed = dayOfYear - 1
        val percentage = (daysPassed * 100) / totalDays

        return YearProgress(
            year = year,
            totalDays = totalDays,
            dayOfYear = dayOfYear,
            daysPassed = daysPassed,
            daysRemaining = daysRemaining,
            percentage = percentage
        )
    }

    /**
     * Determines the exact native screen dimensions for the current device and orientation.
     */
    fun getTargetDimensions(context: Context): Pair<Int, Int> {
        val metrics = context.resources.displayMetrics
        val screenW = metrics.widthPixels
        val screenH = metrics.heightPixels

        val wallpaperManager = WallpaperManager.getInstance(context)
        val desiredW = wallpaperManager.desiredMinimumWidth
        val desiredH = wallpaperManager.desiredMinimumHeight

        // Use desiredMinimum dimensions if valid and matching orientation, otherwise displayMetrics
        val width = if (desiredW > 0 && desiredW >= screenW) screenW else screenW
        val height = if (desiredH > 0 && desiredH >= screenH) screenH else screenH

        return Pair(width, height)
    }

    /**
     * Generates a pixel-perfect wallpaper tailored to the exact device dimensions and orientation.
     */
    fun generate(context: Context, customWidth: Int? = null, customHeight: Int? = null): Bitmap {
        val (screenWidth, screenHeight) = if (customWidth != null && customHeight != null) {
            Pair(customWidth, customHeight)
        } else {
            getTargetDimensions(context)
        }

        val bitmap = Bitmap.createBitmap(screenWidth, screenHeight, Bitmap.Config.ARGB_8888)
        val canvas = Canvas(bitmap)

        // Draw background
        canvas.drawColor(COLOR_BACKGROUND)

        // Get progress
        val progress = getYearProgress()

        // Responsive orientation adaptation
        val isLandscape = screenWidth > screenHeight
        val columns = if (isLandscape) 25 else 15
        val rows = if (isLandscape) 15 else 25

        val maxGridW = screenWidth * 0.82f
        val maxGridH = if (isLandscape) screenHeight * 0.68f else screenHeight * 0.58f

        val spacingX = maxGridW / (columns - 1)
        val spacingY = maxGridH / (rows - 1)
        val dotSpacing = minOf(spacingX, spacingY)
        val dotDiameter = dotSpacing * 0.68f

        val gridWidth = (columns - 1) * dotSpacing + dotDiameter
        val gridHeight = (rows - 1) * dotSpacing + dotDiameter

        val startX = (screenWidth - gridWidth) / 2f + dotDiameter / 2f
        val startY = if (isLandscape) {
            (screenHeight - gridHeight) / 2f - (screenHeight * 0.03f)
        } else {
            // Generous room for lock screen clock and notifications
            screenHeight * 0.20f
        }

        // Paint for dots
        val dotPaint = Paint().apply {
            isAntiAlias = true
            style = Paint.Style.FILL
        }

        // Draw all dots
        var dayCounter = 1
        for (row in 0 until rows) {
            for (col in 0 until columns) {
                if (dayCounter > progress.totalDays) break

                val x = startX + col * dotSpacing
                val y = startY + row * dotSpacing

                dotPaint.color = when {
                    dayCounter < progress.dayOfYear -> COLOR_DOT_COMPLETED
                    dayCounter == progress.dayOfYear -> COLOR_DOT_TODAY
                    else -> COLOR_DOT_REMAINING
                }

                canvas.drawCircle(x, y, dotDiameter / 2f, dotPaint)
                dayCounter++
            }
        }

        // Draw bottom stats text
        val textSize = dotDiameter * 1.0f
        val textPaint = Paint().apply {
            isAntiAlias = true
            this.textSize = textSize
            typeface = Typeface.create("sans-serif", Typeface.NORMAL)
        }

        val textY = screenHeight - (if (isLandscape) screenHeight * 0.08f else screenHeight * 0.06f)

        val daysText = "${progress.daysRemaining}d"
        val labelText = " left · "
        val percentText = "${progress.percentage}%"

        textPaint.color = COLOR_TEXT_ACCENT
        val daysWidth = textPaint.measureText(daysText)
        textPaint.color = COLOR_TEXT_SECONDARY
        val labelWidth = textPaint.measureText(labelText)
        val percentWidth = textPaint.measureText(percentText)

        val totalTextWidth = daysWidth + labelWidth + percentWidth
        var textX = (screenWidth - totalTextWidth) / 2f

        // Draw days (accent color)
        textPaint.color = COLOR_TEXT_ACCENT
        canvas.drawText(daysText, textX, textY, textPaint)
        textX += daysWidth

        // Draw label (grey)
        textPaint.color = COLOR_TEXT_SECONDARY
        canvas.drawText(labelText, textX, textY, textPaint)
        textX += labelWidth

        // Draw percent (grey)
        canvas.drawText(percentText, textX, textY, textPaint)

        return bitmap
    }
}
