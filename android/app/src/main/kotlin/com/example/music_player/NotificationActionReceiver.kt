package com.example.music_player

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.util.Log
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor

class NotificationActionReceiver : BroadcastReceiver() {
    private val TAG = "NotificationActionRcv"

    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.action
        Log.d(TAG, "Received notification action: $action")

        if (action == null) return

        val launchIntent = Intent(context, MainActivity::class.java).apply {
            setAction(action)
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP)
            putExtra("notification_action", action)
        }

        context.startActivity(launchIntent)
    }
}

class NotificationActionPlugin : io.flutter.plugin.common.MethodChannel.MethodCallHandler {
    private val TAG = "NotificationActionPlugin"
    private var methodChannel: io.flutter.plugin.common.MethodChannel? = null

    fun registerWith(flutterEngine: FlutterEngine) {
        methodChannel = io.flutter.plugin.common.MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "com.example.music_player/notification_action"
        ).apply {
            setMethodCallHandler(this@NotificationActionPlugin)
        }
    }

    override fun onMethodCall(
        call: io.flutter.plugin.common.MethodCall,
        result: io.flutter.plugin.common.MethodChannel.Result
    ) {
        when (call.method) {
            "getInitialAction" -> {
                // This will be called from Dart to get the action that launched the app
                // We'll handle this in MainActivity instead
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }
}