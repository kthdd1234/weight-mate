import SwiftUI

struct TextCell: View {
    let text: String
    let font: Font
    let isBold: Bool
    let isLineThrough: Bool?
    let lineThroughColor: Color?
    
    var body: some View  {
        Text(text).font(font)
            .foregroundColor(themeColor)
            .fontWeight(isBold ? .bold : .regular)
            .lineLimit(1)
            .strikethrough(isLineThrough == true, pattern: .solid, color: lineThroughColor)
    }
}

