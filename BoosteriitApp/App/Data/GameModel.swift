import Foundation
import SwiftUI

struct GameItem: Identifiable, Codable {
    let id: UUID
    let title: String
    let imageName: String
    let imageURL: URL?
    let rating: Double
    let category: String
    let info: String
    let rankingScore: Double
}

struct Ranking: Codable {
    let criteria: String
    let topCount: Int
    let top: [UUID]
}

struct GamesData: Codable {
    let games: [GameItem]
    let ranking: Ranking
}

final class GameDataLoader {
    static func load(from filename: String = "games.json") -> GamesData? {
        guard let url = Bundle.main.url(forResource: filename.replacingOccurrences(of: ".json", with: ""), withExtension: "json") else {
            print("games.json not found in bundle")
            return nil
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let gamesData = try decoder.decode(GamesData.self, from: data)
            return gamesData
        } catch {
            print("Failed to load/parse games.json: \(error)")
            return nil
        }
    }

    // Convenience: return top N games based on ranking.top order
    static func topGames(from data: GamesData) -> [GameItem] {
        var lookup = Dictionary(uniqueKeysWithValues: data.games.map { ($0.id, $0) })
        return data.ranking.top.compactMap { lookup[$0] }
    }
}
