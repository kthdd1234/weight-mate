//
//  SvgTextCell.swift
//  Runner
//
//  Created by 김동현 on 3/2/24.
//

import SwiftUI

struct SvgTextCell: View {
    let svgName: String
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            SvgCell(name: svgName)
            TextCell(text: title, font: .footnote, isBold: false)
            Spacer()
            TextCell(text: value, font: .footnote, isBold: true)
        }
    }
}

struct SvgCell: View {
    var name: String
    
    var body: some View {
            Image(name)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 10, height: 10)
                .padding(3)
                .background(.white)
                .cornerRadius(3)
    }
}
