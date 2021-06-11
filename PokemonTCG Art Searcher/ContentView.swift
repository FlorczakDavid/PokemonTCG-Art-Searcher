//
//  ContentView.swift
//  PokemonTCG Art Searcher
//
//  Created by david florczak on 22/04/2021.
//

import SwiftUI

struct ContentView: View {
    
    @State var isSetToFit = false
    @State private var offset: CGSize = .zero
    
    @ObservedObject var fetchSet = FetchSetsList()
    //    @ObservedObject var fetchCard = FetchCardsListFromSet(set: "")
    
    @State var image = #imageLiteral(resourceName: "pokemonTcgBack")
    
    var body: some View {
        //        VStack {
        //            List(fetch.cardSetsList.data) { data in
        //                Text(data.id)
        //            }
        GeometryReader { geo in
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .ignoresSafeArea()
                .offset(self.offset)
                .onTapGesture(count: 2, perform: {
                    withAnimation {
                        isSetToFit.toggle()
                    }
                })
                .onLongPressGesture {
                    fetchImage(from: fetchSet.cardSetsList.data)
                }
                .gesture(DragGesture().onChanged({ drag in
                    self.offset = drag.translation
                }))
                .ignoresSafeArea()
                .frame(width: isSetToFit ? geo.size.width/8 : geo.size.width, alignment: .center)
        }
        .background(Color.black)
        .ignoresSafeArea(.all)
        //        }
        
    }
    
    func fetchImage(from cardSetList: [CardSet]) {
        
        var randomCard = Card(id: "", number: "0", name: "", artist: "")
        //        var fetchedImage = #imageLiteral(resourceName: "pokemonTcgBack")
        
        if let randomSet = cardSetList.randomElement() {
            DispatchQueue.main.async {
                
                guard let rc = randomSet.getCardList().randomElement()
                else {
                    print("card list not loaded")
                    return
                }
                
                randomCard = rc
                let url = URL(string: "https://images.pokemontcg.io/\(randomSet.id)/\(randomCard.number)_hires.png")
                guard let cardUrl = url else { return }
                do{
                    let imageData: Data = try Data(contentsOf: cardUrl)
                    
                    self.image = UIImage(data: imageData)!
                    
                }catch{
                    print("Unable to load data: \(error)")
                }
                
            }
        }
    }
    
    //    func getSetCardCount(id: String) -> Int {
    //        let fetchList = FetchCardsListFromSet(set: id)
    //        return fetchList.cardList.count
    //    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension CGRect {
    var center: CGPoint { return CGPoint(x: self.midX, y: self.midY) }
}

extension CGPoint {
    static func +(_ first: CGPoint, _ second: CGPoint) -> CGPoint {
        return CGPoint(x: first.x + second.x, y: first.y + second.y)
    }
}
