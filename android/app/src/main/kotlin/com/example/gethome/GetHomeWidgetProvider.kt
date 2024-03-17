import android.content.Context
import android.appwidget.AppWidgetManager
import android.content.SharedPreferences

import es.antonborri.home_widget.HomeWidgetProvider

class GetHomeWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray, widgetData: SharedPreferences) {
        super.onUpdate(context, appWidgetManager, appWidgetIds)
        // Perform any updates or data fetching here
    }
}
