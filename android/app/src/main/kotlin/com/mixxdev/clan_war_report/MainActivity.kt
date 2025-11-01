package com.mixxdev.clan_war_reporter

import android.os.Build
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import androidx.core.view.WindowCompat
import androidx.core.view.WindowInsetsControllerCompat

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Enable edge-to-edge rendering so the app can display correctly on Android 15+ (SDK 35)
        // This is safe on older Android versions and provides backward compatibility.
        WindowCompat.setDecorFitsSystemWindows(window, false)

        // Configure system bars behavior: allow swipe to reveal.
        val insetsController = WindowInsetsControllerCompat(window, window.decorView)
        insetsController.systemBarsBehavior = WindowInsetsControllerCompat.BEHAVIOR_SHOW_BARS_BY_SWIPE

        // Optionally set light/dark appearance depending on your theme. Leave default for now.
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Intercept platform channel calls that set system UI overlay styles on Android 15+.
        // Flutter framework (PlatformPlugin) normally handles `SystemChrome.setSystemUIOverlayStyle`
        // by calling Window.setStatusBarColor / setNavigationBarColor which are restricted on Android 15.
        // We register a handler that no-ops that specific method for SDK >= 35 to avoid using those APIs.
        if (Build.VERSION.SDK_INT >= 35) {
            MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "flutter/platform")
                .setMethodCallHandler { call, result ->
                    if (call.method == "SystemChrome.setSystemUIOverlayStyle") {
                        // Ignore attempts to set system UI colors from Flutter on Android 15+.
                        result.success(null)
                    } else {
                        result.notImplemented()
                    }
                }
        }
    }
}
