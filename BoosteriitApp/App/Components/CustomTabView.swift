import SwiftUI

struct CustomTabView: View {
    @Binding var selectedIndex: Int
    private let icons = ["house.fill", "envelope.fill", "gift.fill", "gearshape.fill"]

    var body: some View {
        HStack(spacing: 32) {
            ForEach(0..<icons.count, id: \ .self) { i in
                Button(action: {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                        selectedIndex = i
                    }
                }) {
                    Image(systemName: icons[i])
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(selectedIndex == i ? AppColors.icon : AppColors.icon.opacity(0.85))
                        .frame(width: 44, height: 44)
                        .background(
                            ZStack {
                                if selectedIndex == i {
                                    Circle()
                                        .fill(AppColors.chipBackground)
                                        .frame(width: 44, height: 44)
                                        .scaleEffect(1.06)
                                        .shadow(color: Color.black.opacity(0.12), radius: 6, x: 0, y: 3)
                                }
                            }
                        )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            LinearGradient(gradient: Gradient(colors: [AppColors.gradientStart,
                                                       AppColors.gradientEnd]),
                           startPoint: .top,
                           endPoint: .bottom)
                .opacity(1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: Color.black.opacity(0.18), radius: 12, x: 0, y: 8)
        .padding(.horizontal, 24)
        .padding(.bottom, 10)
    }

    private func safeAreaBottom() -> CGFloat {
        guard let window = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .flatMap({ $0.windows })
                .first(where: { $0.isKeyWindow }) else { return 0 }
        return window.safeAreaInsets.bottom
    }
}

struct CustomTabView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VStack {
                Spacer()
                CustomTabView(selectedIndex: .constant(0))
            }
            .background(Color(UIColor.systemBackground))
            .previewLayout(.sizeThatFits)
            .padding()
        }
    }
}
