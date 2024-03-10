import SwiftUI

struct HeaderCell: View {
    let title: String
    let secondary: String
    let fontFamily: String
    
    var body: some View {
            HStack(){
                TextCell(text: title, font: .subheadline, isBold: true, isLineThrough: false, lineThroughColor: nil, fontFamily: fontFamily)
                Spacer()
                SecondaryCell(text: secondary, font: .caption2, fontFamily: fontFamily)
            }.padding(.bottom, 10)
    }
}
