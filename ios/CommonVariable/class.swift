import SwiftUI

class ItemStore: ObservableObject {
    @Published var itemList: [ItemModel]
    
    init(itemList: [ItemModel] = []) {
        self.itemList = itemList
    }
}
