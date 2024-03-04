import SwiftUI

struct IconTextCell: View {
    let text: String
    let systemName: String
    let iconColor: Color
    let bgColor: Color
    
    var body: some View {
        HStack() {
            IconCell(systemName: systemName, iconColor: iconColor, bgColor: bgColor)
            TextCell(text: text, font: .footnote, isBold: false)
        }
    }
}

struct IconCell: View {
    var systemName: String
    var iconColor: Color
    var bgColor: Color
    
    var body: some View {
            Image(systemName: systemName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 10, height: 10)
                .padding(3)
                .foregroundColor(iconColor)
                .background(bgColor)
                .cornerRadius(3)
    }
}

