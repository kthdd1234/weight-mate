# Keep Facebook Ads SDK classes
-keep class com.facebook.** { *; }
-dontwarn com.facebook.**
-keepattributes *Annotation*

# Amazon SDK 관련 경고 무시
-dontwarn com.amazon.**