import SwiftUI

struct IconTextCell: View {
    let name: String
    
    var body: some View {
        HStack() {
            IconCell(name: "sun.max", textColor: tealIconColor, bgColor: tealBgColor)
            TextCell(text: name, font: .footnote, isBold: false)
        }
    }
}

struct IconCell: View {
    var name: String
    var textColor: Color
    var bgColor: Color
    
    var body: some View {
            Image(systemName: name)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 10, height: 10)
                .padding(3)
                .foregroundColor(textColor)
                .background(bgColor)
                .cornerRadius(3)
    }
}

