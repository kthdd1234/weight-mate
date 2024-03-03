//
//  HeaderCell.swift
//  Runner
//
//  Created by 김동현 on 3/2/24.
//

import SwiftUI

struct HeaderCell: View {
    let title: String
    let secondary: String
    
    var body: some View {
            HStack(){
                TextCell(text: title, font: .headline, isBold: true)
                Spacer()
                SecondaryCell(text: secondary, font: .caption2)
            }.padding(.bottom, 10)
    }
}
