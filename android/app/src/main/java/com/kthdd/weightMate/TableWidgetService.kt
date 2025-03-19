package com.kthdd.weightMate

import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import android.widget.RemoteViewsService
import androidx.core.content.ContextCompat
import es.antonborri.home_widget.HomeWidgetPlugin
import org.json.JSONArray
import org.json.JSONTokener

class TableWidgetService : RemoteViewsService() {
    override fun onGetViewFactory(intent: Intent): RemoteViewsFactory {
        return TableRemoteViewsFactory(applicationContext)
    }
}

class TableRemoteViewsFactory(private val context: Context) : RemoteViewsService.RemoteViewsFactory {
    private var widgetItemList: MutableList<WidgetItem> = mutableListOf()

    override fun onCreate() {
        getWidgetItemList()
    }

    override fun onDataSetChanged() {
        widgetItemList.clear()
        getWidgetItemList()
    }

    override fun onDestroy() {
        widgetItemList.clear()
    }

    override fun getCount() = widgetItemList.size

    override fun getViewAt(position: Int): RemoteViews {
        val remoteViews = RemoteViews(context.packageName, R.layout.table_item)
        val widgetItem = widgetItemList[position]

        val beforeColorInt = getColorItem(widgetItem.beforeColorName)
        val startColorInt = getColorItem(widgetItem.startColorName)

        remoteViews.setTextViewText(R.id.item_date, widgetItem.date)
        remoteViews.setTextViewText(R.id.item_current, widgetItem.current)
        remoteViews.setTextViewText(R.id.item_before, widgetItem.before)
        remoteViews.setTextViewText(R.id.item_start, widgetItem.start)

        remoteViews.setTextColor(R.id.item_before, ContextCompat.getColor(context, beforeColorInt.value))
        remoteViews.setTextColor(R.id.item_start, ContextCompat.getColor(context, startColorInt.value))

        val fillInIntent = Intent(context, MainActivity::class.java).apply {
            action = Intent.ACTION_VIEW
            putExtra("ITEM_TEXT", "")
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
        }

        remoteViews.setOnClickFillInIntent(R.id.item_date, fillInIntent)
        remoteViews.setOnClickFillInIntent(R.id.item_current, fillInIntent)
        remoteViews.setOnClickFillInIntent(R.id.item_before, fillInIntent)
        remoteViews.setOnClickFillInIntent(R.id.item_start, fillInIntent)

        return remoteViews
    }

    private fun getWidgetItemList() {
        widgetItemList.clear()

        val widgetData = HomeWidgetPlugin.getData(context)
        val tableItemList = widgetData.getString("tableItemList", null)

        if(tableItemList != null && tableItemList != "") {
            val jsonArray = JSONTokener(tableItemList).nextValue() as JSONArray

            for (i in 1..jsonArray.length()) {
                val index = i - 1
                val obj = jsonArray.getJSONObject(index)

                val date = obj.getString("date")
                val current = obj.getString("current")
                val before = obj.getString("before")
                val start = obj.getString("start")

                val beforeColorName = obj.getString("beforeColorName")
                val startColorName = obj.getString("startColorName")

                val widgetItem = WidgetItem(date, current, before, start, beforeColorName, startColorName)
                widgetItemList.add(widgetItem)
            }
        }
    }


    override fun getLoadingView() = null
    override fun getViewTypeCount() = 1
    override fun getItemId(position: Int) = position.toLong()
    override fun hasStableIds() = true
}