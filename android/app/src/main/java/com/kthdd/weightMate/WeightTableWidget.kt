package com.kthdd.weightMate

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin

class WeightTableWidget : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }
    override fun onEnabled(context: Context) {}
    override fun onDisabled(context: Context) {}
    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)

        if (intent.action == AppWidgetManager.ACTION_APPWIDGET_UPDATE) {
            val appWidgetManager = AppWidgetManager.getInstance(context)
            val appWidgetIds = intent.getIntArrayExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS)

            if (appWidgetIds != null) {
                appWidgetManager.notifyAppWidgetViewDataChanged(appWidgetIds, R.id.table_list)
            }
        }
    }
}

internal fun updateAppWidget(
    context: Context,
    appWidgetManager: AppWidgetManager,
    appWidgetId: Int
) {
    val views = RemoteViews(context.packageName, R.layout.weight_table_widget)
    val intent = Intent(context, TableWidgetService::class.java)
    val widgetData = HomeWidgetPlugin.getData(context)

    val emptyText = widgetData.getString("emptyText", null)

    val dateTitleName =  widgetData.getString("dateTitleName", null)
    val currentTitleName = widgetData.getString("currentTitleName", null)
    val beforeTitleName = widgetData.getString("beforeTitleName" ,null)
    val startTitleName = widgetData.getString("startTitleName" ,null)

    val openAppIntent = Intent(context, MainActivity::class.java).apply {
        addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
    }

    val pendingIntent = PendingIntent.getActivity(
        context, 0, openAppIntent,
        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
    )

    val clickIntent = Intent(context, MainActivity::class.java)
    val pendingIntentTemplate = PendingIntent.getActivity(
        context, 0, clickIntent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
    )

    views.setPendingIntentTemplate(R.id.table_list, pendingIntentTemplate)
    views.setOnClickPendingIntent(R.id.widget_root, pendingIntent)

    views.setTextViewText(R.id.title_date, dateTitleName)
    views.setTextViewText(R.id.title_current, currentTitleName)
    views.setTextViewText(R.id.title_before, beforeTitleName)
    views.setTextViewText(R.id.title_start, startTitleName)

    views.setTextViewText(R.id.empty_text, emptyText)
    views.setEmptyView(R.id.table_list, R.id.empty_text)

    views.setRemoteAdapter(R.id.table_list, intent)
    appWidgetManager.updateAppWidget(appWidgetId, views)
}