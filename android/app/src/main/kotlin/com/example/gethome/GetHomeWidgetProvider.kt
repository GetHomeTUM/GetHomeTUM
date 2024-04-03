package com.example.gethome

import android.content.Context
import android.appwidget.AppWidgetManager
import android.content.SharedPreferences
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.widget.RemoteViews
import com.example.gethome.R
import es.antonborri.home_widget.HomeWidgetPlugin

import es.antonborri.home_widget.HomeWidgetProvider
import java.io.File

class GetHomeWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray, widgetData: SharedPreferences) {
        // Perform any updates or data fetching here
        for (appWidgetId in appWidgetIds) {
           // Get reference to SharedPreferences
           val widgetData = HomeWidgetPlugin.getData(context)
           val views = RemoteViews(context.packageName, R.layout.widget_layout).apply {
               // Get chart image and put it in the widget, if it exists
               val imagePath = widgetData.getString("filename", null)
               val imageFile = File(imagePath)
               val imageExists = imageFile.exists()
               if (imageExists) {
                  val myBitmap: Bitmap = BitmapFactory.decodeFile(imageFile.absolutePath)
                  setImageViewBitmap(R.id.widget_image, myBitmap)
               } else {
                  println("image not found!, looked @: $imagePath")
               }
               // End new code
           }
           appWidgetManager.updateAppWidget(appWidgetId, views)
       }

    }
}
