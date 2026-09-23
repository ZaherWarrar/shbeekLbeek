# Guava / Google Places SDK — annotations not present on Android.
-dontwarn com.google.j2objc.annotations.ReflectionSupport
-dontwarn com.google.j2objc.annotations.RetainedWith
-dontwarn com.google.j2objc.annotations.**

# Keep Google Maps / Places SDK classes in release builds.
-keep class com.google.android.libraries.places.** { *; }
-keep class com.google.android.gms.maps.** { *; }
-keep class com.google.common.** { *; }
-keepclassmembers class * {
    @com.google.android.gms.common.annotation.KeepName <fields>;
}