import SwiftUI

struct HeaderCell: View {
    let title: String
    let secondary: String
    
    var body: some View {
            HStack(){
                TextCell(text: title, font: .subheadline, isBold: true, isLineThrough: false, lineThroughColor: nil)
                Spacer()
                SecondaryCell(text: secondary, font: .caption2)
            }.padding(.bottom, 10)
    }
}
