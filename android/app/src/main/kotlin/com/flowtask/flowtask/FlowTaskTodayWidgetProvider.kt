package com.flowtask.flowtask

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.view.View
import android.widget.RemoteViews
import org.json.JSONObject

class FlowTaskTodayWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            appWidgetManager.updateAppWidget(appWidgetId, buildViews(context))
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        if (
            intent.action == Intent.ACTION_TIME_CHANGED ||
            intent.action == Intent.ACTION_TIMEZONE_CHANGED ||
            intent.action == Intent.ACTION_DATE_CHANGED
        ) {
            updateAll(context)
        }
    }

    companion object {
        const val PREFS_NAME = "FlowTaskWidget"
        const val SNAPSHOT_KEY = "today_snapshot"

        fun updateAll(context: Context) {
            val manager = AppWidgetManager.getInstance(context)
            val component = ComponentName(context, FlowTaskTodayWidgetProvider::class.java)
            val ids = manager.getAppWidgetIds(component)
            for (id in ids) {
                manager.updateAppWidget(id, buildViews(context))
            }
        }

        private fun buildViews(context: Context): RemoteViews {
            val snapshot = readSnapshot(context)
            val views = RemoteViews(context.packageName, R.layout.flowtask_today_widget)
            val count = snapshot?.optInt("dueTodayCount", 0) ?: 0
            val displayMode = snapshot?.optString("displayMode", "countOnly") ?: "countOnly"
            val titles = snapshot?.optJSONArray("nextDueTodayTasks")
            val canShowTitles = displayMode == "countAndTitles"

            views.setTextViewText(R.id.widget_count, count.toString())
            views.setTextViewText(
                R.id.widget_subtitle,
                if (count == 1) "task due today" else "tasks due today"
            )
            setTitle(views, R.id.widget_task_1, titles?.optString(0), canShowTitles)
            setTitle(views, R.id.widget_task_2, titles?.optString(1), canShowTitles)
            setTitle(views, R.id.widget_task_3, titles?.optString(2), canShowTitles)
            views.setOnClickPendingIntent(
                R.id.widget_root,
                pendingIntent(context, deepLinkFor(snapshot))
            )
            return views
        }

        private fun setTitle(
            views: RemoteViews,
            viewId: Int,
            title: String?,
            canShowTitles: Boolean
        ) {
            if (canShowTitles && !title.isNullOrBlank()) {
                views.setViewVisibility(viewId, View.VISIBLE)
                views.setTextViewText(viewId, "• $title")
            } else {
                views.setViewVisibility(viewId, View.GONE)
            }
        }

        private fun readSnapshot(context: Context): JSONObject? {
            val value = context
                .getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
                .getString(SNAPSHOT_KEY, null)
            return if (value.isNullOrBlank()) null else JSONObject(value)
        }

        private fun deepLinkFor(snapshot: JSONObject?): Uri {
            return when (snapshot?.optString("tapDestination", "today")) {
                "addTask" -> Uri.parse("flowtask://add")
                "calendar" -> Uri.parse("flowtask://calendar")
                else -> Uri.parse("flowtask://today")
            }
        }

        private fun pendingIntent(context: Context, uri: Uri): PendingIntent {
            val intent = Intent(Intent.ACTION_VIEW, uri, context, MainActivity::class.java)
            val flags = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
            } else {
                PendingIntent.FLAG_UPDATE_CURRENT
            }
            return PendingIntent.getActivity(context, 0, intent, flags)
        }
    }
}
