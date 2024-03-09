import SwiftUI

struct TextCell: View {
    let text: String
    let font: Font
    let isBold: Bool
    let isLineThrough: Bool?
    let lineThroughColor: Color?
    let fontFamily: String
    
    var body: some View  {
        Text(text)
            .fontWeight(isBold ? .bold : .regular)
            .font(Font.custom(fontFamily, size: isBold ? 15 : 13))
            .foregroundColor(themeColor)
            .lineLimit(1)
            .strikethrough(isLineThrough == true, pattern: .solid, color: lineThroughColor)
    }
}

