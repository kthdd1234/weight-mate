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
    let fontFamily: String
    
    var body: some View {
        HStack {
            SvgCell(name: svgName)
            TextCell(text: title, font: .footnote, isBold: false, isLineThrough: nil, lineThroughColor: nil ,fontFamily: fontFamily)
            Spacer()
            TextCell(text: value, font: .footnote, isBold: true, isLineThrough: nil, lineThroughColor: nil, fontFamily: fontFamily)
        }
    }
}

struct SvgCell: View {
    var name: String
    
    var body: some View {
            Image(name)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 11.5, height: 11.5)
//                .padding(3)
//                .background(Color(red: 243/255, green: 247/255, blue: 254/255))
//                .cornerRadius(3)
    }
}


//  Color(red: 79/255, green: 195/255, blue: 247/255)
