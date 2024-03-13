import Foundation
import SwiftUI

public var themeColor: Color = Color(red: 58/255, green: 61/255, blue: 118/255)

public var tealBgColor : Color = Color(red: 224/255, green: 242/255, blue: 241/255)
public var tealIconColor : Color = Color(red: 77/255, green: 182/255, blue: 172/255)

public var lightBlueBgColor: Color = Color(red: 225/255, green: 245/255, blue: 254/255)
public var lightBlueIconColor: Color = Color(red: 79/255, green: 195/255, blue: 247/255)

public var brwonBgColor: Color = Color(red: 239/255, green: 235/255, blue: 233/255)
public var brwonIconColor: Color = Color(red: 161/255, green: 136/255, blue: 127/255)

public var emptyColor: Color = Color(red: 121/255, green: 134/255, blue: 203/255)

public var dietColors = ["background": tealBgColor, "icon": tealIconColor]
public var exerciseColors = ["background": lightBlueBgColor, "icon": lightBlueIconColor]
public var lifeColors = ["background": brwonBgColor, "icon": brwonIconColor]

public var planTypeColors = ["PlanTypeEnum.diet": dietColors, "PlanTypeEnum.exercise": exerciseColors, "PlanTypeEnum.lifestyle": lifeColors]
