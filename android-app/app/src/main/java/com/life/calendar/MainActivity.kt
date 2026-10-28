package com.life.calendar

import android.app.WallpaperManager
import android.os.Build
import android.os.Bundle
import android.widget.Button
import android.widget.ImageView
import android.widget.TextView
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity

class MainActivity : AppCompatActivity() {

    private lateinit var previewImage: ImageView
    private lateinit var statusText: TextView
    private lateinit var applyButton: Button
    private lateinit var testButton: Button

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        previewImage = findViewById(R.id.previewImage)
        statusText = findViewById(R.id.statusText)
        applyButton = findViewById(R.id.applyButton)
        testButton = findViewById(R.id.testButton)

        // Generate preview
        generatePreview()

        // Apply button
        applyButton.setOnClickListener {
            applyWallpaper()
        }

        // Test button - schedules alarm for 1 minute from now
        testButton.setOnClickListener {
            MidnightAlarmReceiver.scheduleTestAlarm(this)
            Toast.makeText(
                this, 
                "⏰ Test alarm set for 1 minute!\nLock your phone and wait...", 
                Toast.LENGTH_LONG
            ).show()
        }

        // Schedule midnight alarm for auto-updates
        MidnightAlarmReceiver.scheduleAlarm(this)
    }

    private fun generatePreview() {
        val bitmap = WallpaperGenerator.generate(this)
        previewImage.setImageBitmap(bitmap)
        
        val progress = WallpaperGenerator.getYearProgress()
        statusText.text = "📅 ${progress.daysRemaining}d left · ${progress.percentage}% complete\n" +
                "🔄 Auto-updates daily at midnight"
    }

    private fun applyWallpaper() {
        try {
            val bitmap = WallpaperGenerator.generate(this)
            val wallpaperManager = WallpaperManager.getInstance(this)
            
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                // Set both home screen and lock screen
                wallpaperManager.setBitmap(
                    bitmap,
                    null,
                    true,
                    WallpaperManager.FLAG_LOCK or WallpaperManager.FLAG_SYSTEM
                )
                Toast.makeText(this, "✓ Lock & Home screen wallpaper set!", Toast.LENGTH_SHORT).show()
            } else {
                // Older devices - set both
                wallpaperManager.setBitmap(bitmap)
                Toast.makeText(this, "✓ Wallpaper set!", Toast.LENGTH_SHORT).show()
            }
        } catch (e: Exception) {
            Toast.makeText(this, "Error: ${e.message}", Toast.LENGTH_LONG).show()
        }
    }
}
