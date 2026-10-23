package com.appsbay.chess_room

import android.content.pm.ApplicationInfo
import android.graphics.Bitmap
import android.graphics.Rect
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.view.PixelCopy
import android.view.Choreographer
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterView
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream

class MainActivity : FlutterActivity() {
    private var storeCaptureChannel: MethodChannel? = null
    private var capturingStoreScreen = false

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // Capture tooling is unavailable in production builds. It captures the
        // actual native window and never reads or writes screenshot files.
        if ((applicationInfo.flags and ApplicationInfo.FLAG_DEBUGGABLE) == 0) return
        storeCaptureChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "com.appsbay.chess_room/store_capture"
        ).also { channel ->
            channel.setMethodCallHandler { call, result ->
                if (call.method == "capture") captureStoreScreen(result)
                else result.notImplemented()
            }
        }
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        storeCaptureChannel?.setMethodCallHandler(null)
        storeCaptureChannel = null
        super.cleanUpFlutterEngine(flutterEngine)
    }

    private fun captureStoreScreen(result: MethodChannel.Result) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) {
            result.error("capture_unsupported", "Window capture requires Android 8 or later.", null)
            return
        }
        if (capturingStoreScreen) {
            result.error("capture_busy", "A native window capture is already running.", null)
            return
        }
        val flutterView = findViewById<FlutterView>(FLUTTER_VIEW_ID)
        val width = flutterView?.width ?: 0
        val height = flutterView?.height ?: 0
        if (isFinishing || isDestroyed || width <= 0 || height <= 0) {
            result.error("capture_unavailable", "The native window is not ready.", null)
            return
        }
        val bitmap = try {
            Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888).also {
                // Select an opaque capture format before acquiring pixels.
                // PNG compression consequently emits RGB instead of RGBA.
                it.setHasAlpha(false)
            }
        } catch (error: Exception) {
            result.error("capture_allocation", error.message, null)
            return
        }
        capturingStoreScreen = true
        val handler = Handler(Looper.getMainLooper())
        var completed = false
        val timeout = Runnable {
            if (!completed) {
                completed = true
                capturingStoreScreen = false
                result.error("capture_timeout", "Native window capture timed out.", null)
            }
        }
        fun finish(bytes: ByteArray?, message: String? = null) {
            if (completed) return
            completed = true
            capturingStoreScreen = false
            handler.removeCallbacks(timeout)
            if (bytes != null) result.success(bytes)
            else result.error("capture_failed", message, null)
        }
        handler.postDelayed(timeout, 5000)
        fun copyPresentedFrame() {
            if (completed) {
                bitmap.recycle()
                return
            }
            val location = IntArray(2)
            flutterView!!.getLocationInWindow(location)
            val rect = Rect(location[0], location[1], location[0] + width, location[1] + height)
            try {
                PixelCopy.request(window, rect, bitmap, { status ->
                    if (completed || status != PixelCopy.SUCCESS) {
                        bitmap.recycle()
                        if (!completed) finish(null, "PixelCopy returned $status.")
                    } else {
                        Thread {
                            try {
                                check(!bitmap.hasAlpha()) { "Native capture unexpectedly contains alpha." }
                                val output = ByteArrayOutputStream()
                                check(bitmap.compress(Bitmap.CompressFormat.PNG, 100, output)) {
                                    "Native PNG encoding failed."
                                }
                                val bytes = output.toByteArray()
                                check(bytes.size > 25 && bytes[25].toInt() == 2) {
                                    "Native PNG capture must use opaque RGB encoding."
                                }
                                handler.post { finish(bytes) }
                            } catch (error: Exception) {
                                handler.post { finish(null, error.message) }
                            } finally {
                                bitmap.recycle()
                            }
                        }.start()
                    }
                }, handler)
            } catch (error: Exception) {
                bitmap.recycle()
                finish(null, error.message)
            }
        }
        fun acquirePresentedFrame() {
            if (completed) {
                bitmap.recycle()
                return
            }
            // Dart schedules a new Flutter frame before calling this channel.
            // Wait for that GPU frame before acquiring the image, otherwise
            // the image view can successfully acquire an older scroll state.
            Choreographer.getInstance().postFrameCallback {
                Choreographer.getInstance().postFrameCallback {
                    if (completed) {
                        bitmap.recycle()
                    } else {
                        val acquired = flutterView!!.acquireLatestImageViewFrame()
                        // The acquired image also needs native composition
                        // before copying the window's displayed pixels.
                        Choreographer.getInstance().postFrameCallback {
                            Choreographer.getInstance().postFrameCallback {
                                if (acquired) copyPresentedFrame() else acquirePresentedFrame()
                            }
                        }
                    }
                }
            }
        }
        acquirePresentedFrame()
    }
}
