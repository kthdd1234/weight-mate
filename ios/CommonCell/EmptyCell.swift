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
//            SecondaryCell(text: text, font: .caption, fontFamily: fontFamily)
            TextCell(text: text, font: .caption2, isBold: false, isLineThrough: nil, lineThroughColor: nil, fontFamily: fontFamily)
        }).frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
    }
}
