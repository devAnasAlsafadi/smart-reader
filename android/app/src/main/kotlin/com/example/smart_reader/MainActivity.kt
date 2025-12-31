package com.example.smart_reader

import org.opencv.core.MatOfDouble
import org.opencv.core.MatOfInt
import org.opencv.core.MatOfFloat

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.util.Log
import org.opencv.core.Scalar

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

import org.opencv.android.OpenCVLoader
import org.opencv.android.Utils
import org.opencv.core.Core
import org.opencv.core.CvType
import org.opencv.core.Mat
import org.opencv.core.Size
import org.opencv.imgproc.Imgproc
import java.io.ByteArrayOutputStream

class MainActivity : FlutterActivity() {

    private val CHANNEL = "image_processing_channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        initOpenCV()

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "enhanceImage" -> {
                    try {
                        val bytes = call.arguments as ByteArray
                        val processed = processImage(bytes)
                        result.success(processed)
                    } catch (e: Exception) {
                        e.printStackTrace()
                        Log.e("ImageProcessing", "Error: ${e.message}")
                        result.error("PROCESS_ERROR", e.message, null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun initOpenCV() {
        val ok = OpenCVLoader.initDebug()
        if (ok) {
            Log.d("OpenCV", "OpenCV loaded successfully")
        } else {
            Log.e("OpenCV", "Failed to load OpenCV")
        }
    }




//    private fun processImage(bytes: ByteArray): ByteArray {
//
//        val bmp = BitmapFactory.decodeByteArray(bytes, 0, bytes.size)
//        val mat = Mat()
//        Utils.bitmapToMat(bmp, mat)
//
//        // 1) Convert to Black & White (Grayscale)
//        Imgproc.cvtColor(mat, mat, Imgproc.COLOR_BGR2GRAY)
//
//        // 2) Gaussian Blur
//        Imgproc.GaussianBlur(mat, mat, Size(5.0, 5.0), 0.0)
//
//        Imgproc.adaptiveThreshold(
//            mat,
//            mat,
//            255.0,
//            Imgproc.ADAPTIVE_THRESH_MEAN_C,
//            Imgproc.THRESH_BINARY,
//            15,
//            7.0
//        )
//
//        Imgproc.dilate(mat, mat, Imgproc.getStructuringElement(Imgproc.MORPH_RECT, Size(2.0, 2.0)))
//
//        // Convert back to bitmap
//        val resultBitmap = Bitmap.createBitmap(mat.cols(), mat.rows(), Bitmap.Config.ARGB_8888)
//        Utils.matToBitmap(mat, resultBitmap)
//
//        val out = ByteArrayOutputStream()
//        resultBitmap.compress(Bitmap.CompressFormat.PNG, 100, out)
//        return out.toByteArray()
//    }
//    private fun processImage(bytes: ByteArray): ByteArray {
//        val bmp = BitmapFactory.decodeByteArray(bytes, 0, bytes.size)
//        val mat = Mat()
//        Utils.bitmapToMat(bmp, mat)
//
//        // 1) تحويل للرمادي
//        Imgproc.cvtColor(mat, mat, Imgproc.COLOR_BGR2GRAY)
//
//        // 2) تحسين التباين (CLAHE) بدلاً من الـ Threshold القاسي
//        val clahe = Imgproc.createCLAHE(2.0, Size(8.0, 8.0))
//        clahe.apply(mat, mat)
//
//        // 3) Inverse Binary Threshold (هام جداً: لجعل الأرقام بيضاء والخلفية سوداء)
//        // استخدم THRESH_BINARY_INV بدلاً من THRESH_BINARY
//        Imgproc.adaptiveThreshold(
//            mat,
//            mat,
//            255.0,
//            Imgproc.ADAPTIVE_THRESH_GAUSSIAN_C,
//            Imgproc.THRESH_BINARY_INV, // عكس الألوان هنا
//            11,
//            2.0
//        )
//
//        // 4) تنظيف الضجيج البسيط (اختياري)
//        val kernel = Imgproc.getStructuringElement(Imgproc.MORPH_RECT, Size(2.0, 2.0))
//        Imgproc.morphologyEx(mat, mat, Imgproc.MORPH_OPEN, kernel)
//
//        // تحويل النتائج
//        val resultBitmap = Bitmap.createBitmap(mat.cols(), mat.rows(), Bitmap.Config.ARGB_8888)
//        Utils.matToBitmap(mat, resultBitmap)
//
//        val out = ByteArrayOutputStream()
//        resultBitmap.compress(Bitmap.CompressFormat.PNG, 100, out)
//        return out.toByteArray()
//    }

// MainActivity.kt

    private fun processImage(bytes: ByteArray): List<ByteArray> {
        val bmp = BitmapFactory.decodeByteArray(bytes, 0, bytes.size)
        val mat = Mat()
        Utils.bitmapToMat(bmp, mat)

        // 1. تحويل للرمادي وعكس الألوان لجعل الأرقام بيضاء
        Imgproc.cvtColor(mat, mat, Imgproc.COLOR_BGR2GRAY)
        Imgproc.adaptiveThreshold(mat, mat, 255.0, Imgproc.ADAPTIVE_THRESH_GAUSSIAN_C, Imgproc.THRESH_BINARY_INV, 11, 2.0)

        // 2. البحث عن الأرقام (Contours)
        val contours = mutableListOf<org.opencv.core.MatOfPoint>()
        val hierarchy = Mat()
        Imgproc.findContours(mat, contours, hierarchy, Imgproc.RETR_EXTERNAL, Imgproc.CHAIN_APPROX_SIMPLE)

        // 3. ترتيب الصناديق من اليسار إلى اليمين
        val digitRects = contours.map { Imgproc.boundingRect(it) }
            .filter { rect -> rect.height > mat.rows() * 0.5 && rect.width < rect.height } // تصفية الضجيج
            .sortedBy { it.x }

        val outputList = mutableListOf<ByteArray>()

        for (rect in digitRects) {
            val digitMat = Mat(mat, rect) // قص الرقم بدقة

            val digitBmp = Bitmap.createBitmap(digitMat.cols(), digitMat.rows(), Bitmap.Config.ARGB_8888)
            Utils.matToBitmap(digitMat, digitBmp)

            val out = ByteArrayOutputStream()
            digitBmp.compress(Bitmap.CompressFormat.PNG, 100, out)
            outputList.add(out.toByteArray())
        }

        return outputList // نرسل قائمة بكل رقم لوحده
    }

}
