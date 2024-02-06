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
        let config = Realm.Configuration(schemaVersion: 2)
        Realm.Configuration.defaultConfiguration = config
        
        let realm = try! Realm()
        realmData = realm.objects(WordModel.self)
    }
    
    func reloadData() {
        let realm = try! Realm()
        realmData = realm.objects(WordModel.self)
    }
}
