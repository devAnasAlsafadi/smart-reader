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




    private fun processImage(bytes: ByteArray): ByteArray {

        val bmp = BitmapFactory.decodeByteArray(bytes, 0, bytes.size)
        val mat = Mat()
        Utils.bitmapToMat(bmp, mat)

        // 1) Convert to Black & White (Grayscale)
        Imgproc.cvtColor(mat, mat, Imgproc.COLOR_BGR2GRAY)

        // 2) Gaussian Blur
        Imgproc.GaussianBlur(mat, mat, Size(5.0, 5.0), 0.0)

        Imgproc.adaptiveThreshold(
            mat,
            mat,
            255.0,
            Imgproc.ADAPTIVE_THRESH_MEAN_C,
            Imgproc.THRESH_BINARY,
            15,
            7.0
        )

        Imgproc.dilate(mat, mat, Imgproc.getStructuringElement(Imgproc.MORPH_RECT, Size(2.0, 2.0)))

        // Convert back to bitmap
        val resultBitmap = Bitmap.createBitmap(mat.cols(), mat.rows(), Bitmap.Config.ARGB_8888)
        Utils.matToBitmap(mat, resultBitmap)

        val out = ByteArrayOutputStream()
        resultBitmap.compress(Bitmap.CompressFormat.PNG, 100, out)
        return out.toByteArray()
    }




}
