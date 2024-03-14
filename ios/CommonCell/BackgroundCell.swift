import SwiftUI

struct BackgroundCell: View {
    var body: some View {
        Image("CloudyApple")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(minWidth: 0, maxWidth: .infinity)
            .edgesIgnoringSafeArea(.all)
    }
}
