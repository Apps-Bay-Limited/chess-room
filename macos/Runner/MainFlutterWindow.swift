import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    // The board and menus are laid out for a portrait-leaning window, the same
    // proportions the iOS build ships with.
    self.setContentSize(NSSize(width: 540, height: 900))
    self.contentMinSize = NSSize(width: 420, height: 640)
    self.center()

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
