//
//  CardModel.swift
//  WaterUI
//
//  Created by tobihige on 2023/10/01.
//

import Foundation

struct CardModel: Identifiable {
    
    let id: String
    //    let title: String
    let wordInEnglish: String
    let wordInJapanese: String
    var learningLevel: Double
    var theNumberOfAttempts: Int
    
}
