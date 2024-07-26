import Foundation
import WidgetKit
import SwiftUI
import UIKit

func systemName(type: String, key: String) -> String {
    let iconType = planIconTypes[type]!
    let iconName = iconType[key]!
    
    return iconName
}

func bgColor(type: String) -> Color {
    let typeColor = planTypeColors[type]!
    let color = typeColor["background"]!
    
    return color
}

func iconColor(type: String) -> Color {
    let typeColor = planTypeColors[type]!
    let color = typeColor["icon"]!
    
    return color
}

func isWidgetSizeMediumLarge(family: WidgetFamily) -> Bool {
    if(family == .systemMedium || family == .systemLarge){
        return true
    }
    
    return false
}


func isWidgetSizeSmallMedium(family: WidgetFamily) -> Bool {
    if(family == .systemSmall || family == .systemMedium){
        return true
    }
    
    return false
}

func initCutomFont(fontFamily: String) -> Void {
   CTFontManagerRegisterFontsForURL(bundle.appending(path: "assets/fonts/\(fontFamily).woff") as CFURL, CTFontManagerScope.process, nil)
}

func loadJson <T: Decodable>(json: String) -> T {
    print("json => \(json)")
    do {
        let data = json.data(using: .utf8)!
        return try JSONDecoder().decode(T.self, from: Data(data))
      } catch {
          fatalError("Unable to parse json: (error)")
    }
}

func wItemList (family: WidgetFamily, list: [ItemModel]) -> [ItemModel] {
    if isWidgetSizeSmallMedium(family: family) {
        return Array(list.prefix(3))
    }
    
    return Array(list.prefix(10))
}

func wGoalList (family: WidgetFamily, list: [GoalModel]) -> [GoalModel] {
    if isWidgetSizeSmallMedium(family: family) {
        return Array(list.prefix(3))
    }
    
    return Array(list.prefix(10))
}
