import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  #if DEBUG
  private var storeCaptureChannel: FlutterMethodChannel?
  private var storeCaptureRegistrar: FlutterPluginRegistrar?
  #endif

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    #if DEBUG
    registerStoreCapture(with: engineBridge)
    #endif
  }

  #if DEBUG
  // Capture the live native window at the requested test state. The host driver
  // receives these bytes after all tests, when the original screen is gone.
  private func registerStoreCapture(with engineBridge: FlutterImplicitEngineBridge) {
    storeCaptureChannel?.setMethodCallHandler(nil)
    storeCaptureRegistrar = engineBridge.pluginRegistry.registrar(forPlugin: "StoreCaptureDebug")
    let channel = FlutterMethodChannel(
      name: "com.appsbay.chess_room/store_capture",
      binaryMessenger: engineBridge.applicationRegistrar.messenger()
    )
    channel.setMethodCallHandler { [weak self] call, result in
      guard call.method == "capture" else {
        result(FlutterMethodNotImplemented)
        return
      }
      guard let self = self else {
        result(FlutterError(code: "capture_unavailable", message: "Capture engine is unavailable.", details: nil))
        return
      }
      self.captureStoreScreenshot(result: result)
    }
    storeCaptureChannel = channel
  }

  private func captureStoreScreenshot(result: FlutterResult) {
    // Flutter's default platform-channel handler runs on the main thread.
    guard Thread.isMainThread else {
      result(FlutterError(code: "capture_wrong_thread", message: "Capture requires the main thread.", details: nil))
      return
    }
    guard let flutterWindow = storeCaptureRegistrar?.viewController?.viewIfLoaded?.window else {
      result(FlutterError(code: "capture_not_ready", message: "Flutter's native window is not attached.", details: nil))
      return
    }
    let window = flutterWindow.windowScene?.windows.first(where: { $0.isKeyWindow }) ?? flutterWindow
    guard !window.isHidden && !window.bounds.isEmpty else {
      result(FlutterError(code: "capture_not_ready", message: "The native window is not visible.", details: nil))
      return
    }

    let format = UIGraphicsImageRendererFormat()
    format.opaque = true
    format.preferredRange = .standard
    format.scale = window.screen.scale
    let renderer = UIGraphicsImageRenderer(bounds: window.bounds, format: format)
    var drewHierarchy = false
    let image = renderer.image { context in
      context.cgContext.setFillColor((window.backgroundColor ?? .black).cgColor)
      context.cgContext.fill(window.bounds)
      drewHierarchy = window.drawHierarchy(in: window.bounds, afterScreenUpdates: true)
    }
    guard drewHierarchy, let png = image.pngData() else {
      result(FlutterError(code: "capture_failed", message: "The native window could not be captured.", details: nil))
      return
    }
    result(FlutterStandardTypedData(bytes: png))
  }
  #endif
}
