package com.life.calendar

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.app.WallpaperManager
import android.os.Build
import android.util.Log
import java.util.Calendar

/**
 * Receives alarm at midnight and updates the wallpaper.
 * Also handles device boot to reschedule the alarm.
 */
class MidnightAlarmReceiver : BroadcastReceiver() {

    companion object {
        private const val TAG = "LifeCalendar"
        private const val REQUEST_CODE = 1001
        private const val TEST_REQUEST_CODE = 1002
        private var lastUpdateTime = 0L
        private const val MIN_UPDATE_INTERVAL_MS = 5000L

        /**
         * Schedule the midnight alarm for wallpaper update.
         */
        fun scheduleAlarm(context: Context) {
            val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
            
            val intent = Intent(context, MidnightAlarmReceiver::class.java).apply {
                action = "com.life.calendar.UPDATE_WALLPAPER"
            }
            
            val pendingIntent = PendingIntent.getBroadcast(
                context,
                REQUEST_CODE,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )

            // Calculate next midnight
            val midnight = Calendar.getInstance().apply {
                add(Calendar.DAY_OF_YEAR, 1)
                set(Calendar.HOUR_OF_DAY, 0)
                set(Calendar.MINUTE, 0)
                set(Calendar.SECOND, 5)  // 5 seconds after midnight
                set(Calendar.MILLISECOND, 0)
            }

            // Use setExactAndAllowWhileIdle for reliable delivery even in Doze mode
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                alarmManager.setExactAndAllowWhileIdle(
                    AlarmManager.RTC_WAKEUP,
                    midnight.timeInMillis,
                    pendingIntent
                )
            } else {
                alarmManager.setExact(
                    AlarmManager.RTC_WAKEUP,
                    midnight.timeInMillis,
                    pendingIntent
                )
            }

            Log.d(TAG, "Midnight alarm scheduled for: ${midnight.time}")
        }

        /**
         * Schedule a test alarm for 1 minute from now.
         */
        fun scheduleTestAlarm(context: Context) {
            val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
            
            val intent = Intent(context, MidnightAlarmReceiver::class.java).apply {
                action = "com.life.calendar.UPDATE_WALLPAPER"
            }
            
            val pendingIntent = PendingIntent.getBroadcast(
                context,
                TEST_REQUEST_CODE,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )

            // 1 minute from now
            val testTime = System.currentTimeMillis() + 60_000

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                alarmManager.setExactAndAllowWhileIdle(
                    AlarmManager.RTC_WAKEUP,
                    testTime,
                    pendingIntent
                )
            } else {
                alarmManager.setExact(
                    AlarmManager.RTC_WAKEUP,
                    testTime,
                    pendingIntent
                )
            }

            Log.d(TAG, "Test alarm scheduled for 1 minute from now")
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        Log.d(TAG, "Alarm received: ${intent.action}")

        when (intent.action) {
            Intent.ACTION_BOOT_COMPLETED,
            Intent.ACTION_TIMEZONE_CHANGED,
            Intent.ACTION_TIME_CHANGED,
            Intent.ACTION_DATE_CHANGED -> {
                // Device rebooted or local timezone/time changed - update and reschedule for local midnight
                Log.d(TAG, "Time/timezone change detected (${intent.action}), refreshing wallpaper and rescheduling")
                updateWallpaper(context)
                scheduleAlarm(context)
            }
            "com.life.calendar.UPDATE_WALLPAPER" -> {
                // Alarm triggered at local midnight, update wallpaper
                Log.d(TAG, "Local midnight update triggered, updating wallpaper")
                updateWallpaper(context)
                
                // Schedule next local midnight alarm
                scheduleAlarm(context)
            }
        }
    }

    private fun updateWallpaper(context: Context) {
        val now = System.currentTimeMillis()
        if (now - lastUpdateTime < MIN_UPDATE_INTERVAL_MS) {
            Log.d(TAG, "Throttling update request; skipped")
            return
        }
        lastUpdateTime = now

        try {
            val bitmap = WallpaperGenerator.generate(context)
            val wallpaperManager = WallpaperManager.getInstance(context)

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                wallpaperManager.setBitmap(
                    bitmap,
                    null,
                    true,
                    WallpaperManager.FLAG_LOCK or WallpaperManager.FLAG_SYSTEM
                )
            } else {
                wallpaperManager.setBitmap(bitmap)
            }

            val progress = WallpaperGenerator.getYearProgress()
            Log.d(TAG, "Wallpaper updated: ${progress.daysRemaining}d left")
        } catch (e: Exception) {
            Log.e(TAG, "Failed to update wallpaper: ${e.message}")
        }
    }
}
