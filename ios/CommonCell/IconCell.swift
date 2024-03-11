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

