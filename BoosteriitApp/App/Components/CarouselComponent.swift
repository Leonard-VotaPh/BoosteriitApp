//
//  CarouselComponent.swift
//  BoosteriitApp
//
//  Created by leonard Borrego on 17/10/25.
//

import SwiftUI

struct CarouselComponent: View {
    // Use GameItem data from JSON
    var gameItems: [GameItem] = []
    @State private var currentIndex: Int = 0
    @State private var favorites: Set<Int> = []
    private let carouselHeight: CGFloat = 200

    var body: some View {
        GeometryReader { geometry in
            let spacing: CGFloat = 20
            let leftPadding: CGFloat = 16
            let cardWidth = max(0, geometry.size.width - 2 * (leftPadding + spacing / 2))

            TabView(selection: $currentIndex) {
                ForEach(Array(gameItems.enumerated()), id: \.offset) { index, item in
                    ZStack(alignment: .topTrailing) {
                        carouselImage(item: item, width: cardWidth, height: carouselHeight)
                        Rectangle()
                            .fill(Color.clear)
                            .frame(width: cardWidth, height: carouselHeight)
                            .cornerRadius(12)
                            .overlay(
                                VStack {
                                    Spacer()
                                    HStack {
                                        VStack(alignment: .leading, spacing: 6) {
                                            Text(item.title)
                                                .font(.system(size: 16, weight: .bold))
                                                .foregroundColor(.white)
                                                .lineLimit(1)

                                            HStack(spacing: 8) {
                                                Image(systemName: "star.fill")
                                                    .font(.system(size: 12))
                                                    .foregroundColor(.yellow)
                                                Text(String(format: "%.1f", item.rating))
                                                    .font(.system(size: 13))
                                                    .foregroundColor(.white.opacity(0.9))

                                                Text("•")
                                                    .foregroundColor(.white.opacity(0.8))

                                                Text(item.category)
                                                    .font(.system(size: 12))
                                                    .foregroundColor(.white.opacity(0.85))
                                            }
                                        }
                                        Spacer()
                                    }
                                    .padding()
                                    .background(LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.0), Color.black.opacity(0.45)]), startPoint: .top, endPoint: .bottom))
                                }
                                .cornerRadius(12)
                            )

                        Button(action: { toggleFavorite(index: index) }) {
                            Image(systemName: favorites.contains(index) ? "heart.fill" : "heart")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(10)
                                .background(Color.black.opacity(0.35))
                                .clipShape(Circle())
                        }
                        .padding(10)
                        .accessibilityLabel(favorites.contains(index) ? "Eliminar de favoritos" : "Añadir a favoritos")
                    }
                    .frame(width: cardWidth, height: carouselHeight)
                    .cornerRadius(12)
                    .padding(.horizontal, spacing / 2)
                    .shadow(color: Color.black.opacity(0.18), radius: 8, x: 0, y: 4)
                    .scaleEffect(index == currentIndex ? 1.0 : 0.94)
                    .animation(.spring(response: 0.35, dampingFraction: 0.8), value: currentIndex)
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            .frame(height: carouselHeight)
        }
        .frame(height: carouselHeight)
    }

    // New helper to reduce view-body complexity
    @ViewBuilder
    private func carouselImage(item: GameItem, width: CGFloat, height: CGFloat) -> some View {
        #if canImport(Kingfisher)
        if let url = item.imageURL {
            KFImage.url(url)
                .resizable()
                .cancelOnDisappear(true)
                .placeholder {
                    Color.gray.opacity(0.12)
                }
                .scaledToFill()
                .frame(width: width, height: height)
                .clipped()
        } else {
            Image(item.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: width, height: height)
                .clipped()
        }
        #else
        if let url = item.imageURL {
            let urlString = url.absoluteString.removingPercentEncoding ?? url.absoluteString
            if ImageUtils.isDataURL(urlString) {
                if let fileURL = ImageUtils.cachedFileURL(fromDataURL: urlString) {
                    if #available(iOS 15.0, *) {
                        AsyncImage(url: fileURL) { phase in
                            switch phase {
                            case .empty:
                                Color.gray.opacity(0.12)
                            case .success(let image):
                                image.resizable().scaledToFill()
                            case .failure:
                                Image(item.imageName).resizable().scaledToFill()
                            @unknown default:
                                Color.gray.opacity(0.12)
                            }
                        }
                        .frame(width: width, height: height)
                        .clipped()
                    } else {
                        if let ui = UIImage(contentsOfFile: fileURL.path) {
                            Image(uiImage: ui).resizable().scaledToFill().frame(width: width, height: height).clipped()
                        } else {
                            Image(item.imageName).resizable().scaledToFill().frame(width: width, height: height).clipped()
                        }
                    }
                } else if let decoded = ImageUtils.imageFromDataURL(urlString) {
                    decoded
                        .resizable()
                        .scaledToFill()
                        .frame(width: width, height: height)
                        .clipped()
                        .onAppear {
                            DispatchQueue.global(qos: .utility).async {
                                _ = ImageUtils.cachedFileURL(fromDataURL: urlString)
                            }
                        }
                } else {
                    if #available(iOS 15.0, *) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                Color.gray.opacity(0.12)
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                            case .failure:
                                Image(item.imageName)
                                    .resizable()
                                    .scaledToFill()
                            @unknown default:
                                Color.gray.opacity(0.12)
                            }
                        }
                        .frame(width: width, height: height)
                        .clipped()
                    } else {
                        Image(item.imageName)
                            .resizable()
                            .scaledToFill()
                            .frame(width: width, height: height)
                            .clipped()
                    }
                }
            } else {
                if #available(iOS 15.0, *) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            Color.gray.opacity(0.12)
                        case .success(let image):
                            image.resizable().scaledToFill()
                        case .failure:
                            Image(item.imageName).resizable().scaledToFill()
                        @unknown default:
                            Color.gray.opacity(0.12)
                        }
                    }
                    .frame(width: width, height: height)
                    .clipped()
                } else {
                    Image(item.imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: width, height: height)
                        .clipped()
                }
            }
        } else {
            Image(item.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: width, height: height)
                .clipped()
        }
        #endif
    }

    private func toggleFavorite(index: Int) {
        if favorites.contains(index) {
            favorites.remove(index)
        } else {
            favorites.insert(index)
        }
    }
}


struct CarouselComponent_Previews: PreviewProvider {
    static var previews: some View {
        let sample = [
            GameItem(id: UUID(), title: "Grand Theft Auto V", imageName: "gta", imageURL: URL(string: "https://images.igdb.com/igdb/image/upload/t_cover_big/co1r3v.jpg"), rating: 4.8, category: "Action / Open World", info: "Release: 2013 · Multi-platform · 170M+ copies sold", rankingScore: 98.5),
            GameItem(id: UUID(), title: "Gran Turismo 7", imageName: "gt", imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/en/4/45/Gran_Turismo_7_cover.jpg"), rating: 4.3, category: "Racing", info: "Release: 2022 · PS4/PS5", rankingScore: 89.4),
            GameItem(id: UUID(), title: "EA Sports FC 24", imageName: "fifa", imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/en/0/0a/EA_Sports_FC_24_cover.jpg"), rating: 4.0, category: "Sports / Simulation", info: "Release: 2023 · Football simulation", rankingScore: 86.2)
        ]

        CarouselComponent(gameItems: sample)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
