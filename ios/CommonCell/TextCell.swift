//
//  TextCell.swift
//  Runner
//
//  Created by 김동현 on 3/2/24.
//

import SwiftUI

public var themeColor: Color = Color(red: 58/255, green: 61/255, blue: 118/255)

struct TextCell: View {
    let text: String
    let font: Font
    let isBold: Bool
    
    var body: some View  {
        Text(text).font(font)
            .foregroundColor(themeColor)
            .fontWeight(isBold ? .bold : .regular)
            .lineLimit(1)
    }
}

