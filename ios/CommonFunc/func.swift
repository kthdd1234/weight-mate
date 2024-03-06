import Foundation
import WidgetKit
import SwiftUI

func systemName(type: String, key: String) -> String {
    let iconType = todoIconTypes[type]!
    let iconName = iconType[key]!
    
    return iconName
}

func bgColor(type: String) -> Color {
    let typeColor = todoTypeColors[type]!
    let color = typeColor["background"]!
    
    return color
}

func iconColor(type: String) -> Color {
    let typeColor = todoTypeColors[type]!
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
