import Foundation
import SwiftUI

// Group Id
public var widgetGroupId = "group.weight-mate-widget"

// bundle
var bundle: URL {
            let bundle = Bundle.main
            if bundle.bundleURL.pathExtension == "appex" {
                var url = bundle.bundleURL.deletingLastPathComponent().deletingLastPathComponent()
                url.append(component: "Frameworks/App.framework/flutter_assets")
                return url
            }
        return bundle.bundleURL
}
