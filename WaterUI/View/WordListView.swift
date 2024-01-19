//
//  WordListView.swift
//  WaterUI
//
//  Created by tobihige on 2023/10/01.
//

import SwiftUI
import RealmSwift


enum SortOrder {
    case alphabetical
    case byLearningLevel
}

struct WordListView: View {
    
    @State var words: Results<WordModel> {
        didSet {
                sortedWords = sortWords()
                shouldUpdateList.toggle()
        }
    }
    
    @State private var addNewWordSheetIsActive = false
    @State private var sortOrder: SortOrder = .alphabetical
    @State private var learningLevels: [Double] = []
    @State private var selectedWord: WordModel?
    @State private var shouldUpdateList = false
    @State private var isCardVisible = false
    @ObservedObject var wordDataViewModel = WordDataViewModel()
    
    @State var sortedWords: [WordModel] = try! Realm().objects(WordModel.self).sorted(by: { $0.wordInEnglish < $1.wordInEnglish
    })
    
    private func sortWords() -> [WordModel] {
    
        switch sortOrder {
            
        case .alphabetical:
            return words.sorted(by: { $0.wordInEnglish < $1.wordInEnglish })
            
        case .byLearningLevel:
            return words.sorted(by: { $0.learningLevel < $1.learningLevel })
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                Section(header: headerView) {
                    ForEach(sortedWords, id: \.id) { word in
                        HStack {
                            Text(word.wordInEnglish)
                            Spacer()
                            Text("\(Int(word.learningLevel))")
                            Slider(value: .constant(Double(word.learningLevel)),
                                                               in: 0...100,
                                   step: 1.0).frame(width: 100)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedWord = word
                            isCardVisible = true
                        }
                    }
                    .onDelete(perform: rowRemove)
                }
            }
            .navigationTitle("単語一覧")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        addNewWordSheetIsActive = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu {
                        Button(action: {
                            sortOrder = .alphabetical
                            sortedWords = sortWords()
                            
                        }) {
                            Label("アルファベット順", systemImage: "arrow.up.arrow.down")
                        }
                        Button(action: {
                            sortOrder = .byLearningLevel
                            sortedWords = sortWords()
                        }) {
                            Label("習熟度順", systemImage: "arrow.up.arrow.down")
                        }
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                    }
                }
            }
        }
        .sheet(isPresented: $addNewWordSheetIsActive) {
            AddNewWordView(addNewWordSheetIsActive: $addNewWordSheetIsActive)
                .onDisappear {
                    words = try! Realm().objects(WordModel.self)
                }
        }
        .onAppear {
            learningLevels = words.map { Double($0.learningLevel) }
        }
        
//        ここからwordCardを表示するための処理を追加
        if let word = selectedWord {
            TinderCardView(
                card: CardModel(id: word.id,
                                wordInEnglish: word.wordInEnglish,
                                wordInJapanese: word.wordInJapanese,
                                learningLevel: word.learningLevel
                               ),
                wordDataViewModel: wordDataViewModel,
                isCardVisible: $isCardVisible
            )
        }
    }
    
    @ViewBuilder private var headerView: some View {
        HStack {
            Text("単語一覧")
            Spacer()
            Text("習熟度")
        }
    }
    
    private func rowRemove(offsets: IndexSet) {
        
        guard let index = offsets.first else {
            return
        }
        
        let wordToBeRemoved = sortedWords[index]

        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(wordToBeRemoved)
            }

        } catch {
            print("Error deleting word: \(error)")
        }
        
        sortedWords.remove(atOffsets: offsets)
       
    }
}
