//
//  IconCell.swift
//  Runner
//
//  Created by 김동현 on 3/5/24.
//

import SwiftUI

struct IconCell: View {
    let systemName: String
    let iconSize: CGFloat
    let iconColor: Color
    
    var body: some View {
        Image(systemName: systemName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: iconSize, height: iconSize, alignment: .leading)
            .foregroundColor(iconColor)
    }
}

