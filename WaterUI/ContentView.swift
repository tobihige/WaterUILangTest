//
//  ContentView.swift
//  WaterUI
//
//  Created by tobihige on 2023/07/09.
//

import SwiftUI
import RealmSwift

struct ContentView: View {
    
    @State var progress: CGFloat = 0.8
    @State var phase: CGFloat = 0.0
    @State var location = CGPoint(x: 100, y: 600)
    @State var isShowAlert = false
    @State var isActive = false
    @State var addNewWordSheetIsActive = false
    @State var presentWordList = false
    @State var wordButtonTitle: WordModel?
    @State var selectedWord: WordModel?
    
    @State private var isCardVisible = true
    @State private var wordShouldAnimate = false
    
    @State private var isWordListViewVisible = false
    @State private var wordsShouldBeUpdated = false
    
    @ObservedObject var wordDataViewModel = WordDataViewModel()
    @State private var wordModels: [WordModel] = []
    
    let realm = try! Realm()
    
    @State private var words: Results<WordModel> = try! Realm().objects(WordModel.self)
    
    
    var body: some View {
        
        GeometryReader { geometry in
            ZStack {
                buildLayout(geometry: geometry)
                
            }//ZStackここまで
            
            
        }.onAppear(){
            print(Realm.Configuration.defaultConfiguration.fileURL!)
            isActive = false
            
            setUpAnimation()
        }
        .sheet(isPresented: $isWordListViewVisible) {
            wordListView()
        }
    }
    
    
    func updateLearningLevel(_ word: WordModel, level: CGFloat) {
        try! realm.write {
            word.learningLevel = Double(level)
        }
    }
    
    private func buildLayout(geometry: GeometryProxy) -> some View {
        
        ZStack {
            
                LinearGradient(gradient: Gradient(colors: [.purple.opacity(0.3), .orange]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
            
            
                WaterWave(progress: 0.8, phase: self.phase)
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [.cyan, .purple]),
                        startPoint: UnitPoint(x: 0.5, y: 0),
                        endPoint: UnitPoint(x: 0.5, y: 1)
                    ))
                    .ignoresSafeArea()

                WaterWave3(progress: 0.8, phase: 0.2)
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [.cyan, .blue]),
                        startPoint: UnitPoint(x: 0.5, y: 0),
                        endPoint: UnitPoint(x: 0.5, y: 1)
                    ))
                    .ignoresSafeArea()
                    .opacity(0.6)
            

            if let realmData = wordDataViewModel.realmData {
                
                ForEach(realmData, id: \.id) { word in
                    
                    Text(word.wordInEnglish)
                        .foregroundColor(.white)
                        .background {
                            Rectangle()
                                .background(Color.blue)
                                .opacity(0.5)
                        }
                        .position(x: word.xPosition,
                                  y: (geometry.size.height * 0.2) + (geometry.size.height * 0.8 * (word.learningLevel / 100)))
                        .offset(y: wordShouldAnimate ? -5 : 0)
                        .font(.system(size: 20, weight: .medium, design: .monospaced))
                        .onAppear() {
                            withAnimation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true))
                            {
                                wordShouldAnimate = true // アニメーションを開始
                            }
                        }
                        .onTapGesture {
                            selectedWord = word
                            isCardVisible = true

                        }
                }
            }
            
                if let word = selectedWord {

                    TinderCardView(
                        card: CardModel(id: word.id,
                                        wordInEnglish: word.wordInEnglish,
                                        wordInJapanese: word.wordInJapanese,
                                        learningLevel: word.learningLevel,
                                        theNumberOfAttempts: word.theNumberOfAttempts
                                       ),
                        wordDataViewModel: wordDataViewModel,
                        isCardVisible: $isCardVisible
                    )
                }


            Button {
                isWordListViewVisible = true

            } label: {
                Image(systemName: "list.bullet")
                    .font(.system(size: 30))
            }
            .position(x: 30, y: 30)

        }
    }
    
    private func setUpAnimation() {
        withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: false)){
            self.phase = .pi * 2
        }
    }
    
    private func wordListView() -> some View {
        WordListView(words: words)
            .onDisappear {
                words = try! Realm().objects(WordModel.self)
            }
    }
}

//色の拡張
extension Color {
    static let cardColor = Color("CardColor")
}
