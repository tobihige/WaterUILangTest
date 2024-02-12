//
//  WordDetailView.swift
//  WaterUI
//
//  Created by tobihige on 2024/02/09.
//

import SwiftUI
import RealmSwift

struct WordDetailView: View {
    
    var theNumberOfAttempts: Int
    
    var body: some View {
        Rectangle()
            .foregroundColor(Color.cardColor.opacity(0.9))
            .frame(width: 350, height: 500)
            .cornerRadius(15)
            .shadow(radius: 20)
            .overlay {
                
                VStack {
                    Text("テスト回数")
                    Text("\(theNumberOfAttempts)")
                }
            }
    }
}
