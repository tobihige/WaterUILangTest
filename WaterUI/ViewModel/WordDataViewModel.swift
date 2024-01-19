//
//  WordDataViewModel.swift
//  WaterUI
//
//  Created by tobihige on 2023/10/01.
//

import SwiftUI
import RealmSwift

class WordDataViewModel: ObservableObject {
    @Published var realmData: Results<WordModel>?
    
    init() {
        let realm = try! Realm()
        realmData = realm.objects(WordModel.self)
    }
    
    func reloadData() {
        let realm = try! Realm()
        realmData = realm.objects(WordModel.self)
    }
}