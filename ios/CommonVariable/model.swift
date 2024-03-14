//
//  CommonModel.swift
//  Runner
//
//  Created by 김동현 on 3/13/24.
//

import SwiftUI

struct ItemModel: Hashable, Codable, Identifiable {
    var id: String
    var type: String
    var title: String
    var name: String
}

struct GoalModel: Hashable, Codable, Identifiable {
    var id: String
    var type: String
    var name: String
    var isChecked: Bool
}
