import SwiftUI

struct ProductRowView: View {
    let item: GameItem
    var isSelected: Bool = false

    var body: some View {
        ZStack {
            // Background: transparent when not selected, white card when selected
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(isSelected ? Color.white : Color.clear)
                .shadow(color: isSelected ? Color.black.opacity(0.06) : Color.clear, radius: isSelected ? 8 : 0, x: 0, y: 4)

            HStack(spacing: 12) {
                // Use AsyncImage if imageURL available, else local asset fallback
                ZStack {
                    if let url = item.imageURL {
                        if #available(iOS 15.0, *) {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .empty:
                                    Color.gray.opacity(0.2)
                                case .success(let image):
                                    image.resizable().scaledToFill()
                                case .failure:
                                    Image(item.imageName)
                                        .resizable()
                                        .scaledToFill()
                                @unknown default:
                                    Color.gray.opacity(0.2)
                                }
                            }
                        } else {
                            // Fallback for earlier iOS: try local asset
                            Image(item.imageName)
                                .resizable()
                                .scaledToFill()
                        }
                    } else {
                        if UIImage(named: item.imageName) != nil {
                            Image(item.imageName)
                                .resizable()
                                .scaledToFill()
                        } else {
                            Image("game_placeholder")
                                .resizable()
                                .scaledToFill()
                        }
                    }
                }
                .frame(width: 56, height: 56)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

                VStack(alignment: .leading, spacing: 6) {
                    Text(item.title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)

                    Text(item.category)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.secondary)

                    HStack(spacing: 12) {
                        HStack(spacing: 6) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 12))
                                .foregroundColor(.yellow)
                            Text(String(format: "%.1f", item.rating))
                                .font(.system(size: 13))
                                .foregroundColor(.secondary)
                        }

                        HStack(spacing: 6) {
                            Image(systemName: "info.circle")
                                .font(.system(size: 12))
                                .foregroundColor(.secondary)
                            Text(item.info)
                                .font(.system(size: 13))
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                        }
                    }
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 8) {
                    Text(String(format: "%.0f", item.rankingScore))
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(AppColors.icon)

                    Button(action: {
                        // Acción del botón "Play" (rellenar según necesidad)
                    }) {
                        Text("Play")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(
                                LinearGradient(gradient: Gradient(colors: [AppColors.gradientStart, AppColors.gradientEnd]), startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                            .clipShape(Capsule())
                    }
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 14)
        }
        .frame(height: 100)
    }
}

struct ProductRowView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            LinearGradient(gradient: Gradient(stops: [
                .init(color: Color(red: 0.98, green: 0.94, blue: 0.99), location: 0.0),
                .init(color: Color(red: 0.92, green: 0.95, blue: 1.0), location: 1.0)
            ]), startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()

            VStack(spacing: 12) {
                ProductRowView(item: GameItem(id: UUID(), title: "Grand Theft Auto V", imageName: "gta", imageURL: URL(string: "https://images.igdb.com/igdb/image/upload/t_cover_big/co1r3v.jpg"), rating: 4.8, category: "Action / Open World", info: "Release: 2013 · Multi-platform · 170M+ copies sold", rankingScore: 98.5))
                ProductRowView(item: GameItem(id: UUID(), title: "Gran Turismo 7", imageName: "gt", imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/en/4/45/Gran_Turismo_7_cover.jpg"), rating: 4.3, category: "Racing", info: "Release: 2022 · PS4/PS5", rankingScore: 89.4))
                ProductRowView(item: GameItem(id: UUID(), title: "EA Sports FC 24", imageName: "fifa", imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/en/0/0a/EA_Sports_FC_24_cover.jpg"), rating: 4.0, category: "Sports / Simulation", info: "Release: 2023 · Football simulation", rankingScore: 86.2))
            }
            .padding()
        }
    }
}
