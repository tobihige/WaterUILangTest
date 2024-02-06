//
//  WordModel.swift
//  WaterUI
//
//  Created by tobihige on 2023/10/01.
//

import Foundation
import RealmSwift

class WordModel: Object, Identifiable {
    @Persisted(primaryKey: true) var id = UUID().uuidString
    @Persisted var wordInEnglish: String
    @Persisted var wordInJapanese: String
    @Persisted var xPosition: Double
    @Persisted var yPosition: Double
    @Persisted var learningLevel: Double = 0.0
    @Persisted var lastUpdated: String
    @Persisted var theNumberOfAttempts: Int
    
    // Create a custom initializer to convert from WordCardModel to WordModel
    convenience init(wordCardModel: WordCardModel) {
        self.init()
        self.wordInEnglish = wordCardModel.wordInEnglish
        self.wordInJapanese = wordCardModel.wordInJapanese
        self.xPosition = Double(wordCardModel.xPosition)
        self.yPosition = Double(wordCardModel.yPosition)
        self.learningLevel = Double(wordCardModel.learningLevel)
        self.lastUpdated = wordCardModel.lastUpdated
        self.theNumberOfAttempts = wordCardModel.theNumberOfAttempts
    }
}
