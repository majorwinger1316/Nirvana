//
//  AnimatedGradientView.swift
//  Nirvana
//
//  Created by Akshat Dutt Kaushik on 06/08/25.
//


import SwiftUI

struct AnimatedGradientView: View {
    @State private var offset: Double = 0
    
    private let colors = [
        Color.purple.opacity(0.4),
        Color.bg.opacity(0.4),
        Color.indigo.opacity(0.4)
    ]
    
    var gradient: LinearGradient {
        LinearGradient(
            colors: colors,
            startPoint: UnitPoint(x: 1 + offset * 0.1, y: 0 - offset * 0.1),
            endPoint: UnitPoint(x: 0 - offset * 0.1, y: 1 + offset * 0.1)
        )
    }
    
    var body: some View {
        gradient
            .ignoresSafeArea()
            .onAppear {
                withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                    offset = 1
                }
            }
    }
}
