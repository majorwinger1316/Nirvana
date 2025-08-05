//
//  ToastView.swift
//  Nirvana
//
//  Created by Akshat Dutt Kaushik on 06/08/25.
//


import SwiftUI

struct ToastView: View {
    let message: String
    
    var body: some View {
        Text(message)
            .font(.subheadline)
            .padding()
            .background(Color.black.opacity(0.7))
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.top, 50)
            .transition(.opacity)
            .zIndex(1)
    }
}