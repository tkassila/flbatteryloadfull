# Estä varoitukset androidx.window-laajennuksista, joita ei käytetä
-dontwarn androidx.window.**
-dontwarn androidx.window.extensions.**
-dontwarn androidx.window.sidecar.**

# Play Core deferred components warnings (not used in this app)
-dontwarn com.google.android.play.core.**

# Säilytä Kotlin Coroutines ja metodien parametrit/allekirjoitukset JNI/reflection-kutsuille
-dontobfuscate
-keepattributes *Annotation*,Signature,InnerClasses,EnclosingMethod

# Flutter and plugins reflection rules
-keep class io.flutter.** { *; }
-keep interface io.flutter.** { *; }
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugins.** { *; }

# Kotlin stdlib & coroutines (estää Continuation-parametrien muokkaamisen)
-keep class kotlin.** { *; }
-keep class kotlinx.coroutines.** { *; }
-keep class kotlin.coroutines.** { *; }

# SharedPreferences plugin
-keep class io.flutter.plugins.sharedpreferences.** { *; }
-keep interface io.flutter.plugins.sharedpreferences.** { *; }

# Battery Plus plugin
-keep class dev.fluttercommunity.plus.battery.** { *; }

# Flutter Local Notifications
-keep class com.dexterous.flutterlocalnotifications.** { *; }

# Audio Players
-keep class xyz.luan.audioplayers.** { *; }

# Flutter Background Service
-keep class id.flutter.flutter_background_service.** { *; }

# Permission Handler
-keep class com.baseflow.permissionhandler.** { *; }

# Keep all generated plugin registrant
-keep class io.flutter.plugins.GeneratedPluginRegistrant { *; }
