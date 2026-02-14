# Flutter Notifications - Preservar COMPLETAMENTE el plugin y sus clases internas
-keep class com.dexterous.flutterlocalnotifications.** { *; }
-keep interface com.dexterous.flutterlocalnotifications.** { *; }
-keepclassmembers class com.dexterous.flutterlocalnotifications.** { *; }
-keepclasseswithmembers class com.dexterous.flutterlocalnotifications.** { *; }

# Preservar clases anónimas internas del plugin (necesario para callbacks)
-keepclassmembers class com.dexterous.flutterlocalnotifications.*$* { *; }

# GSON - Preservar completamente para evitar problemas de tipos genéricos
-keep class com.google.gson.** { *; }
-keep interface com.google.gson.** { *; }
-keep class com.google.gson.stream.** { *; }
-keep class com.google.gson.reflect.** { *; }
-keepclassmembers class com.google.gson.** { *; }
-keepclasseswithmembers class com.google.gson.** { *; }
-dontwarn com.google.gson.**
-dontwarn sun.misc.**

# Preserve all inner classes of gson
-keepclassmembers class ** {
    *** **(java.lang.reflect.Type);
}

# Preserve all classes and members that use generic types
-keepclassmembers class * {
    *** **(java.util.List);
    *** **(java.util.ArrayList);
    *** **(java.util.LinkedList);
    *** **(java.util.HashMap);
    *** **(java.lang.String);
}

# Preserve all Serializable classes and interfaces
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# Firebase (si se usa)
-keep class com.google.firebase.** { *; }
-keep interface com.google.firebase.** { *; }

# Android Support/AndroidX
-keep class androidx.** { *; }
-keep interface androidx.** { *; }
-keepclassmembers class androidx.** { *; }

# Timezone library
-keep class kotlin.** { *; }

# Dart
-keep class dart.** { *; }

# Kotlin
-keep class kotlin.** { *; }
-keep class kotlin.Metadata { *; }
-keep class kotlin.jvm.** { *; }
-dontwarn kotlin.**

# Preserve enum constants
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}
