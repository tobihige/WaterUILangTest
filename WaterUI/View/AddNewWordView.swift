//
//  AddNewWordView.swift
//  WaterUI
//
//  Created by tobihige on 2023/10/01.
//

import SwiftUI
import RealmSwift

struct AddNewWordView: View {
    
    @State private var englishWordText: String = ""
    @State private var japaneseWordText: String = ""
    @State private var learningLevel: Double = 50
    @State private var lastUpdated: String = ""
    @Binding var addNewWordSheetIsActive: Bool
    
    private let maxCharacterCount = 20
    
    let realm = try! Realm()
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        GeometryReader { geometry in
            VStack(alignment: .center) {
                Spacer()
                Text("新しい単語を追加")
                    .font(.system(size: 30, weight: .medium, design: .default))
                
                Spacer()
                
                VStack {
                    TextField("英語", text: Binding(
                        get: { self.englishWordText },
                        set: {
                            self.englishWordText = String($0.prefix(maxCharacterCount))
                        }
                    ))
                    .textCase(.lowercase)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .font(.system(size: 30, weight: .medium, design: .rounded))
                    .padding()
                    .frame(width: geometry.size.width * 0.7, height: 50)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    
                    
                    TextField("日本語", text: Binding(
                        get: { self.japaneseWordText },
                        set: {
                            self.japaneseWordText = String($0.prefix(maxCharacterCount))
                        }
                    ))
                    .font(.system(size: 30, weight: .medium, design: .rounded))
                    .padding()
                    .frame(width: geometry.size.width * 0.7, height: 50)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                }
                
                Spacer()
                
                VStack {
                    Text("習熟度\(Int(learningLevel))")
                    
                    Slider(value: $learningLevel, in: 0...100, step: 1)
                        .padding()
                        .frame(width: geometry.size.width * 0.7)
                }
                
                Spacer()
                
                Button("追加") {
                    
                    saveToRealm()
                    addNewWordSheetIsActive = false
                    
                }
                .font(.system(size: 30, weight: .medium, design: .default))
                .padding()
                .frame(width: 140, height: 70)
                .foregroundColor(.white)
                .background(
                    Circle()
                        .fill(Color.blue)
                )
            }
            .frame(maxWidth: .infinity)
        }
        
    }
    
    private func saveToRealm() {
        // Realmへのデータ保存処理をここに追加
        guard !englishWordText.isEmpty, !japaneseWordText.isEmpty else {
            print("English or Japanese word is empty. Not saving to Realm.")
            return
        }
        
        let existingWord = realm.objects(WordModel.self).filter("wordInEnglish == %@", englishWordText).first
        
        guard existingWord == nil else {
            print("English word already exists in Realm. Not saving.")
            return
        }
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yMMMdHms", options: 0, locale: Locale(identifier: "ja_JP"))
        lastUpdated = dateFormatter.string(from: date)
        
        //xポジションをランダムにする。値の範囲は30から画面幅-30までの間とする
        let bounds = UIScreen.main.bounds
        let screenWidth = Int(bounds.width)
        let xPosition = Int.random(in: 30..<screenWidth-30)
        
        let dataToAdd = WordCardModel(
            wordInEnglish: englishWordText,
            wordInJapanese: japaneseWordText,
            xPosition: CGFloat(xPosition),
            yPosition: 100, //yPositionは特に使わないがダミーで入れている
            learningLevel: learningLevel,
            lastUpdated: lastUpdated)
        
        let newWordModel = WordModel(wordCardModel: dataToAdd)
        
        let realm = try! Realm()
        
        do {
            try realm.write {
                realm.add(newWordModel)
            }
            print("Word added to Realm.")
        } catch {
            print("Error adding word to Realm: \(error)")
        }
    }
}
