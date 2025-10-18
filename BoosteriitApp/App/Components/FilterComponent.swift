//
//  FilterComponent.swift
//  BoosteriitApp
//
//  Created by leonard Borrego on 18/10/25.
//

import SwiftUI

struct FilterComponent: View {
    var categories: [String] = []
    @Binding var selectedCategory: String

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(categories, id: \.self) { category in
                    Button(action: {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                            selectedCategory = category
                        }
                    }) {
                        Text(category)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(selectedCategory == category ? .white : AppColors.filterText)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 14)
                            .background(
                                Group {
                                    if selectedCategory == category {
                                        LinearGradient(gradient: Gradient(colors: [AppColors.gradientStart, AppColors.gradientEnd]), startPoint: .topLeading, endPoint: .bottomTrailing)
                                    } else {
                                        Color.white.opacity(0.08)
                                    }
                                }
                            )
                            .clipShape(Capsule())
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 16)
        }
        .frame(height: 48)
    }
}

struct FilterComponent_Previews: PreviewProvider {
    static var previews: some View {
        StatefulPreviewWrapper("All") { binding in
            FilterComponent(categories: ["All","Action","Family","Puzzle","Adventure"], selectedCategory: binding)
                .previewLayout(.sizeThatFits)
                .padding()
        }
    }
}

// Small helper to preview bindings
struct StatefulPreviewWrapper<Value: Equatable, Content: View>: View {
    @State var value: Value
    var content: (Binding<Value>) -> Content
    init(_ value: Value, content: @escaping (Binding<Value>) -> Content) {
        _value = State(initialValue: value)
        self.content = content
    }
    var body: some View { content($value) }
}
