//
//  HomeView.swift
//  BoosteriitApp
//
//  Created by leonard Borrego on 17/10/25.
//

import SwiftUI

struct HomeView: View {
    @State private var selectedIndex: Int = 0

    var body: some View {
        ZStack {
            background
            VStack(spacing: 0) {
                CustomHeader()
                    .frame(maxWidth: .infinity)
                Group {
                    switch selectedIndex {
                    case 0:
                        HomeTabView()
                    case 1:
                        MessagesView()
                    case 2:
                        PlaceholderView(title: "Gifts")
                    case 3:
                        PlaceholderView(title: "Settings")
                    default:
                        HomeTabView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                CustomTabView(selectedIndex: $selectedIndex)
            }
        }
    }

    @ViewBuilder
    private var background: some View {
        LinearGradient(gradient: Gradient(stops: [
            .init(color: Color(red: 0.88, green: 0.88, blue: 0.99), location: 0.0),
            .init(color: Color(red: 0.75, green: 0.82, blue: 0.99), location: 0.25),
            .init(color: Color(red: 0.98, green: 0.84, blue: 0.94), location: 0.6),
            .init(color: Color(red: 0.99, green: 0.97, blue: 0.99), location: 1.0)
        ]), startPoint: .topLeading, endPoint: .bottomTrailing)
        .ignoresSafeArea()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
