# Flutter Notifications - Preservar clases necesarias para notificaciones
-keep class com.dexterous.flutterlocalnotifications.** { *; }
-keep interface com.dexterous.flutterlocalnotifications.** { *; }

# Firebase (si se usa)
-keep class com.google.firebase.** { *; }
-keep interface com.google.firebase.** { *; }

# Android Support/AndroidX
-keep class androidx.** { *; }
-keep interface androidx.** { *; }

# Timezone library
-keep class kotlin.** { *; }

# Dart
-keep class dart.** { *; }

# Kotlin
-keep class kotlin.** { *; }
-keep class kotlin.Metadata { *; }
-dontwarn kotlin.**
