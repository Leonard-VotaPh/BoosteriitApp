import SwiftUI

struct HomeTabView: View {
    @StateObject private var viewModel = ViewModel()
    @State private var selectedProductID: UUID? = nil
    @State private var selectedCategory: String = "All"

    var body: some View {
        VStack {
            Text("Browse Games")
                .font(.system(size: 24, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)

            FilterComponent(categories: viewModel.categories, selectedCategory: $selectedCategory)
                .padding(.top, 4)
                .padding(.bottom, 4)

            let fallbackNames = ["gta", "gt", "fifa"]
            let fallbackItems = fallbackNames.map { name in
                GameItem(id: UUID(), title: name.capitalized, imageName: name, imageURL: nil, rating: 4.0, category: "-", info: "", rankingScore: 0)
            }

            let carouselItems = viewModel.featuredGames.isEmpty ? fallbackItems : viewModel.featuredGames

            CarouselComponent(gameItems: carouselItems)
                .frame(height: 180)
                .padding(.horizontal)

            Text("Top Games")
                .font(.system(size: 24, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            products()

            Spacer()
        }
        .navigationTitle("Inicio")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.fetchGames()
        }
    }

    @ViewBuilder
    private func products() -> some View {
        ScrollView {
            LazyVStack(spacing: 6) {
                let filteredGames: [GameItem] = {
                    if selectedCategory == "All" { return viewModel.games }
                    return viewModel.games.filter { item in
                        let main = item.category.split(separator: "/").first?.trimmingCharacters(in: .whitespacesAndNewlines) ?? item.category
                        return main == selectedCategory
                    }
                }()

                ForEach(filteredGames) { item in
                    ProductRowView(item: item, isSelected: item.id == selectedProductID)
                        .padding(.horizontal, 8)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                if selectedProductID == item.id {
                                    selectedProductID = nil
                                } else {
                                    selectedProductID = item.id
                                }
                            }
                        }
                }
            }
            .padding(.vertical, 4)
        }
    }
}

struct HomeTabView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            HomeTabView()
        }
    }
}
