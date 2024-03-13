import SwiftUI

struct EmptyCell: View {
    let svgName: String
    let text: String
    let fontFamily: String
    
    var body: some View {
        VStack(alignment: .center, spacing: 15, content: {
            Image(svgName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
            Text(text)
                .fontWeight(.regular)
                .font(Font.custom(fontFamily, size: 12))
                .foregroundColor(emptyColor)
                .lineLimit(1)
        }).frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
    }
}
