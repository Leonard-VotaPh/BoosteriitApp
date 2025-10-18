//
//  HeaderView.swift
//  BoosteriitApp
//
//  Created by leonard Borrego on 17/10/25.
//

import SwiftUI
import UIKit

struct CustomHeader: View {

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Button(action: {}) {
                        Image(systemName: "line.horizontal.3")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(AppColors.icon)
                            .frame(width: 44, height: 44)
                    }
                    Spacer()
                    Button(action: {}) {
                        Image(systemName: "bell.fill")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(AppColors.icon)
                            .frame(width: 44, height: 44)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
            }
            .padding(.bottom, 12)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    VStack(spacing: 0) {
        CustomHeader()
        Spacer()
    }
    .edgesIgnoringSafeArea(.top)
}
