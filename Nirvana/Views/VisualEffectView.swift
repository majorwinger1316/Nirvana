//
//  VisualEffectView.swift
//  Nirvana
//
//  Created by Akshat Dutt Kaushik on 06/08/25.
//


import SwiftUI

struct VisualEffectView: UIViewRepresentable {
    let effect: UIVisualEffect
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: effect)
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = effect
    }
}