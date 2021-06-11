//
//  Api.swift
//  PokemonTCG Art Searcher
//
//  Created by david florczak on 22/04/2021.
//
import Foundation


/*
 
 https://api.pokemontcg.io/v2/<resource>
 
 resource list:
 /cards
 /cards/:id
 /sets
 /sets/:id
 /types
 /subtypes
 /supertypes
 /rarities
 
 
 "\(url)&appid=\(key) "
 
 https://api.pokemontcg.io/v2/sets
 get list of sets
 take list of id
 pick random id
 https://api.pokemontcg.io/v2/cards?q=set.id:\(RANDOMID)&appid=93a93370-1e60-4cf8-9dbe-38e5ec9fb42b
 take list of cards in set
 pick random number
 get cardNUmber data[randomNumber].number
 
 https://images.pokemontcg.io/ + RANDOM ID/ + randomNumber +_hires.png
 pageSize
 */

struct CardSetList: Codable {
    public var data: [CardSet]
}

struct CardSet: Codable, Identifiable {
    public var id: String
    
    func getCardList() -> [Card] {
        var cardList: [Card] = []
        DispatchQueue.global().async {
        let url = URL(string: "https://api.pokemontcg.io/v2/cards?q=set.id:\(id)&appid=\(key)")!
        
        URLSession.shared.dataTask(with: url) {(data, _, error) in
            do {
                if let cardListData = data {
                    let decodedData = try JSONDecoder().decode(CardList.self, from: cardListData)
                    cardList = decodedData.data
                } else {
                    print("no Data")
                }
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
        }
        return cardList
    }
}

struct CardList: Codable {
    public var data: [Card]
}

struct Card: Codable, Identifiable {
    var id: String
    var number: String
    var name: String
    var artist: String
}

class FetchSetsList: ObservableObject {
    @Published var cardSetsList = CardSetList(data: [])
    
    init() {
        let url = URL(string: "https://api.pokemontcg.io/v2/sets")!
        
        URLSession.shared.dataTask(with: url) {(data, _, error) in
            do {
                if let cardSetListData = data {
                    let decodedData = try JSONDecoder().decode(CardSetList.self, from: cardSetListData)
                    DispatchQueue.main.async {
                        self.cardSetsList = decodedData
                    }
                } else {
                    print("No Data")
                }
            } catch {
                print(error.localizedDescription)
            }
            
        }.resume()
    }
}


//class FetchCardsListFromSet: ObservableObject {
//    @Published var cardList: [Card] = []
//
//    init(set: String) {
//        let url = URL(string: "https://api.pokemontcg.io/v2/cards?q=set.id:\(set)&appid=\(key)")!
//
//        URLSession.shared.dataTask(with: url) {(data, _, error) in
//            do {
//                if let cardListData = data {
//                    let decodedData = try JSONDecoder().decode(CardList.self, from: cardListData)
//                    DispatchQueue.main.async {
//                        self.cardList = decodedData.data
//                    }
//                } else {
//                    print("no Data")
//                }
//            } catch {
//                print(error.localizedDescription)
//            }
//        }.resume()
//    }
//}
