//
//  GradientCheck.swift
//  SparrowCodeSwiftUIBootcamp_Task9
//
//  Created by Валерий Зазулин on 25.03.2024.
//

import SwiftUI

struct GradientCheck: View {
    var body: some View {
        Rectangle()
            .fill(
                RadialGradient(
                    colors: [.yellow, .red],
                    center: .center,
                    startRadius: 95,
                    endRadius: 110
                )
            )
            .overlay(
                Circle()
                    .fill(.red)
                    .frame(width: 100, height: 100)
                    .offset(y: 170)
            )
    }
}

#Preview {
    GradientCheck()
}
