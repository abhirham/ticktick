package com.flowtask.flowtask

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.json.JSONArray
import org.json.JSONObject

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "flowtask/widget_bridge"
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "publishTodaySnapshot" -> {
                    val arguments = call.arguments
                    if (arguments !is Map<*, *>) {
                        result.error("invalid_payload", "Widget payload was invalid", null)
                        return@setMethodCallHandler
                    }
                    val snapshot = jsonFrom(arguments).toString()
                    getSharedPreferences(FlowTaskTodayWidgetProvider.PREFS_NAME, MODE_PRIVATE)
                        .edit()
                        .putString(FlowTaskTodayWidgetProvider.SNAPSHOT_KEY, snapshot)
                        .apply()
                    FlowTaskTodayWidgetProvider.updateAll(this)
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun jsonFrom(values: Map<*, *>): JSONObject {
        val json = JSONObject()
        for ((key, value) in values) {
            json.put(key.toString(), jsonValue(value))
        }
        return json
    }

    private fun jsonValue(value: Any?): Any {
        return when (value) {
            null -> JSONObject.NULL
            is List<*> -> JSONArray(value)
            is Map<*, *> -> jsonFrom(value)
            else -> value
        }
    }
}
