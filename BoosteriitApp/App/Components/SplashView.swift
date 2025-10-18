import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    @State private var scale: CGFloat = 0.6
    @State private var opacity: Double = 0.0

    var body: some View {
        Group {
            if isActive {
                HomeView()
            } else {
                ZStack {
                    LinearGradient(
                        gradient: Gradient(colors: [AppColors.gradientStart, AppColors.gradientEnd]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .ignoresSafeArea()

                    VStack(spacing: 12) {
                        Image(systemName: "gamecontroller.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 96, height: 96)
                            .foregroundColor(.white)
                            .scaleEffect(scale)
                            .opacity(opacity)

                        Text("Boosteriit")
                            .font(.title2).bold()
                            .foregroundColor(.white.opacity(0.95))
                    }
                }
                .onAppear {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                        scale = 1.0
                        opacity = 1.0
                    }

                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
                        withAnimation(.easeOut(duration: 0.45)) {
                            isActive = true
                        }
                    }
                }
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
