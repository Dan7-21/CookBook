import SwiftUI
import Foundation



struct Recipe: Identifiable {
    let id = UUID()
    var title: String
    var time: String
    var description: String
    var isFavorite: Bool = false
}

