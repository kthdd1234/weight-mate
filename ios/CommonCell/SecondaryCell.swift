//
//  SecondaryCell.swift
//  Runner
//
//  Created by 김동현 on 3/2/24.
//

import SwiftUI
public var disabledColor : Color = Color(red: 128/255, green: 128/255, blue: 128/255)

struct SecondaryCell: View {
    let text: String
    let font: Font
    let fontFamily: String
    
    var body: some View  {
        Text(text).font(Font.custom(fontFamily, size: 10))
            .foregroundColor(.gray)
            .lineLimit(1)
    }
}
