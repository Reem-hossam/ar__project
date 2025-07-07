# Sceneform keep rules
-keep class com.google.ar.** { *; }
-keep class com.google.sceneform.** { *; }
-keep class com.google.devtools.build.** { *; }


# Prevent stripping of required AR classes
-dontwarn com.google.ar.sceneform.**
-dontwarn com.google.sceneform.**
-dontwarn com.google.devtools.**
