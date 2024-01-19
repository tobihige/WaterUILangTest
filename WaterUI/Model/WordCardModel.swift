//
//  WordCardModel.swift
//  WaterUI
//
//  Created by tobihige on 2023/10/01.
//

import Foundation
import SwiftUI

struct WordCardModel: Identifiable, Equatable {
    
    var id = UUID()
    var wordInEnglish: String
    var wordInJapanese: String
    var xPosition: CGFloat
    var yPosition: CGFloat
    var learningLevel: CGFloat = 0.0
    
    @State var offset: CGSize = CGSize(width: 0, height: -10.0)
    
    static func == (lhs: WordCardModel, rhs: WordCardModel) -> Bool {
        return lhs.id == rhs.id
    }
}
