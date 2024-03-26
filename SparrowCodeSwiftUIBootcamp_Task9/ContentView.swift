//
//  ContentView.swift
//  SparrowCodeSwiftUIBootcamp_Task9
//
//  Created by Валерий Зазулин on 26.03.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var sliderValue: Double = 0.0

        var body: some View {
            VStack {
                LinearGradient(gradient: Gradient(colors: [Color(red: 0.5 + 0.5 * sliderValue, green: 0.5 + 0.5 * sliderValue, blue: 0.5 + 0.5 * sliderValue), .yellow]), startPoint: .leading, endPoint: .trailing)
                    .frame(height: 50)
                    .cornerRadius(8)

                Slider(value: $sliderValue, in: 0...1)
                    .padding()
            }
            .padding()
        }
    
}

#Preview {
    ContentView()
}
