//
//  ViewModel.swift
//  BoosteriitApp
//
//  Created by leonard Borrego on 18/10/25.
//

import Foundation

final class ViewModel: ObservableObject {
    @Published var games: [GameItem] = []
    @Published var featuredGames: [GameItem] = []
    @Published var categories: [String] = []

    func fetchGames(from filename: String = "games.json") {
        DispatchQueue.global(qos: .userInitiated).async {
            if let data = GameDataLoader.load(from: filename) {
                let games = data.games
                let featured = GameDataLoader.topGames(from: data)

                let rawCats = games.map { item -> String in
                    let first = item.category.split(separator: "/").first?.trimmingCharacters(in: .whitespacesAndNewlines) ?? item.category
                    return first
                }
                let unique = Array(Set(rawCats)).sorted()
                let all = ["All"] + unique

                DispatchQueue.main.async {
                    self.games = games
                    self.featuredGames = featured
                    self.categories = all
                }
            } else {
                DispatchQueue.main.async {
                    self.games = []
                    self.featuredGames = []
                    self.categories = ["All"]
                }
            }
        }
    }
}
