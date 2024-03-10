//
//  WidgetContainer.swift
//  Runner
//
//  Created by 김동현 on 3/2/24.
//

import SwiftUI

struct BackgroundWidget: View {
    var body: some View {
        Image("CloudyApple")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(minWidth: 0, maxWidth: .infinity)
            .edgesIgnoringSafeArea(.all)
    }
}
