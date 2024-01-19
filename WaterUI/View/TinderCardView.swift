import SwiftUI
import RealmSwift


struct TinderCardView: View {
    var card: CardModel
    
    @ObservedObject var wordDataViewModel = WordDataViewModel()
    
    @State private var translation: CGSize = .zero
    @State private var swipeThreshold: CGFloat = 100
    @State private var isJapaneseVisible = false
    @Binding var isCardVisible: Bool
    
    var body: some View {
        if isCardVisible {
            ZStack {
                Rectangle()
                    .foregroundColor(Color.cardColor.opacity(0.9))
                    .frame(width: 350, height: 500)
                    .cornerRadius(15)
                    .shadow(radius: 20)
                    .overlay {
                        
                        VStack {
                            
                            Text("\(card.wordInEnglish)")
                                .font(.system(size: 50, weight: .medium, design: .default))
                                .foregroundColor(Color.white)
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                            
                            Spacer()
                            
                            if isJapaneseVisible {
                                
                                Text("\(card.wordInJapanese)")
                                    .font(.system(size: 50, weight: .medium, design: .default))
                                    .foregroundColor(Color.white)
                                    .padding(.horizontal, 20)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                
                            } else {
                                
                                Text("")
                                    .font(.system(size: 50, weight: .medium, design: .default))
                                    .foregroundColor(Color.white)
                                    .padding(.horizontal, 20)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                
                            }
                            
                            HStack {
                                
                                VStack {
                                    
                                    Text("うろ覚え")
                                        .font(.system(size: 20, weight: .light, design: .monospaced))
                                    
                                    Image(systemName: "arrowshape.turn.up.backward")
                                        .font(.system(size: 40))
                                    
                                    Text("左スワイプ")
                                        .font(.system(size: 13, weight: .light, design: .monospaced))
                                    
                                }
                                .foregroundColor(Color.white)
                                .padding(20)
                                
                                Spacer()
                                
                                
                                VStack {
                                    
                                    Text("覚えた")
                                        .font(.system(size: 20, weight: .light, design: .monospaced))
                                    
                                    
                                    Image(systemName: "arrowshape.turn.up.forward")
                                        .font(.system(size: 40))
                                        .foregroundColor(.white)
                                    
                                    Text("右スワイプ")
                                        .font(.system(size: 13, weight: .light, design: .monospaced))
                                }
                                .foregroundColor(Color.white)
                                .padding(20)
                                
                            }//HStackここまで
                            
                        }//VStackここまで
                        
                    }//overlayここまで
            }
            .offset(x: translation.width, y: translation.height)
            .rotationEffect(.degrees(Double(translation.width / 10)))
            .onTapGesture {
                isJapaneseVisible.toggle()
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        self.translation = value.translation
                        print(translation.width)
                        
                    }
                    .onEnded { value in
                        withAnimation {
                            if abs(self.translation.width) > self.swipeThreshold {
                                // フリックした方向に応じてカードを左右にスワイプする
                                if self.translation.width > 0 {
                                    // 右にスワイプした場合の処理（お気に入りへの追加など）
                                    
                                    isJapaneseVisible = false
                                    
                                    var newCard = card
                                    
                                    if newCard.learningLevel == 100 {
                                        wordDataViewModel.reloadData()
                                        
                                    } else {
                                        newCard.learningLevel += 1
                                    }
                                    
                                    
                                    
                                    let realm = try! Realm()
                                    
                                    guard let targetWord =  realm.objects(WordModel.self).filter("id == %@", newCard.id).last else { return }
                                    
                                    do {
                                        try realm.write {
                                            targetWord.learningLevel = newCard.learningLevel
                                        }
                                    } catch {
                                        print("Error saving to Realm")
                                    }
                                    
                                    wordDataViewModel.reloadData()
                                    
                                } else {
                                    // 左にスワイプした場合の処理（スキップなど）
                                    
                                    isJapaneseVisible = false
                                    
                                    var newCard = card
                                    
                                    if card.learningLevel == 0 {
                                        
                                    } else {
                                        newCard.learningLevel -= 1
                                    }
                                    
                                    
                                    let realm = try! Realm()
                                    
                                    guard let targetWord =  realm.objects(WordModel.self).filter("id == %@", newCard.id).last else { return }
                                    
                                    do {
                                        try realm.write {
                                            targetWord.learningLevel = newCard.learningLevel
                                        }
                                    } catch {
                                        print("Error saving to Realm")
                                    }
                                    
                                    wordDataViewModel.reloadData()
                                }
                                // 次のカードへ進むためにカードを非表示にする
                                
                                self.translation = .zero
                                self.isCardVisible = false
                            } else {
                                self.translation = .zero
                            }
                        }
                    }
            )
        }
    }
}
