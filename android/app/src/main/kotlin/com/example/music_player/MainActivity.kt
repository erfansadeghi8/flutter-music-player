package com.example.music_player

import android.content.Intent
import android.os.Bundle
import com.ryanheise.audioservice.AudioServiceActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : AudioServiceActivity() {
    private val TAG = "MainActivity"
    private val CHANNEL = "com.example.music_player/notification_action"
    private var methodChannel: MethodChannel? = null
    private var pendingAction: String? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).apply {
            setMethodCallHandler { call, result ->
                when (call.method) {
                    "getInitialAction" -> {
                        result.success(pendingAction)
                        pendingAction = null // Clear after reading
                    }
                    else -> result.notImplemented()
                }
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        handleIntent(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        handleIntent(intent)
    }

    private fun handleIntent(intent: Intent?) {
        val action = intent?.getStringExtra("notification_action")
        if (action != null) {
            pendingAction = action
            // Notify Dart side that there's a pending action
            methodChannel?.invokeMethod("onNotificationAction", action)
        }
    }
}