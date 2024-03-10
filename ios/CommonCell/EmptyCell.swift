//
//  EmptyCell.swift
//  Runner
//
//  Created by 김동현 on 3/2/24.
//

import SwiftUI

struct EmptyCell: View {
    let svgName: String
    let text: String
    let fontFamily: String
    
    var body: some View {
        VStack(alignment: .center, spacing: 10, content: {
            Image(svgName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
            SecondaryCell(text: text, font: .caption, fontFamily: fontFamily)
        }).frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
    }
}
