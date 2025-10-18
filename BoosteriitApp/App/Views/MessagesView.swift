//
//  MessagesView.swift
//  BoosteriitApp
//
//  Created by leonard Borrego on 17/10/25.
//

import SwiftUI

struct MessagesView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("Mensajes")
                .font(.system(size: 28, weight: .bold))
                .multilineTextAlignment(.center)
            Spacer()
        }
        .padding()
        .navigationTitle("Mensajes")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PlaceholderView: View {
    let title: String
    var body: some View {
        VStack {
            Spacer()
            Text(title)
                .font(.system(size: 28, weight: .bold))
                .multilineTextAlignment(.center)
            Spacer()
        }
        .padding()
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MessagesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MessagesView()
        }
    }
}
