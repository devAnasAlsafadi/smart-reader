# Keep ML Kit text recognition
-keep class com.google.mlkit.** { *; }
-keep class com.google.android.gms.** { *; }

# Prevent stripping of ML Kit language-specific recognizers
-keep class com.google.mlkit.vision.text.chinese.** { *; }
-keep class com.google.mlkit.vision.text.japanese.** { *; }
-keep class com.google.mlkit.vision.text.korean.** { *; }
-keep class com.google.mlkit.vision.text.devanagari.** { *; }

# Keep flutter cameraX
-keep class io.flutter.plugins.camerax.** { *; }
-keep interface io.flutter.plugins.camerax.** { *; }

# Keep default Camera classes
-keep class androidx.camera.** { *; }
-keep interface androidx.camera.** { *; }

# Keep Tesseract if you're using native libs
-keep class com.googlecode.tesseract.android.** { *; }
