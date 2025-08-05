//
//  MiniPlayerView.swift
//  Nirvana
//
//  Created by Akshat Dutt Kaushik on 06/08/25.
//

import SwiftUI

struct MiniPlayerView: View {
    @ObservedObject var audioPlayer: AudioPlayer
    let selectedSong: Song
    let localSongs: [Song]
    @Binding var isPlayerModalPresented: Bool
    let nextAction: () -> Void
    let previousAction: () -> Void
    let animation: Namespace.ID
    @State private var offset: CGFloat = 0
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                isPlayerModalPresented = true
            }
        }) {
            HStack(spacing: 16) {
                // Album Art
                Group {
                    if let imageName = selectedSong.imageName {
                        Image(imageName)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 48, height: 48)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .shadow(radius: 2)
                    } else {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.systemGray6))
                            .frame(width: 48, height: 48)
                            .overlay(
                                Text(selectedSong.name.prefix(1))
                                    .font(.headline)
                                    .foregroundColor(.gray)
                            )
                    }
                }
                .matchedGeometryEffect(id: "songImage", in: animation)
                
                // Song Info with fixed width
                VStack(alignment: .leading, spacing: 2) {
                    Text(selectedSong.name)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    
                    Text(selectedSong.artist)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                .frame(maxWidth: UIScreen.main.bounds.width * 0.3, alignment: .leading)
                
                Spacer()
                
                // Playback Controls
                HStack(spacing: 20) {
                    Button(action: previousAction) {
                        Image(systemName: "backward.fill")
                            .font(.system(size: 20))
                            .foregroundColor(selectedSong.isOnline ? .gray : .primary)
                    }
                    .disabled(selectedSong.isOnline || localSongs.count <= 1)
                    
                    Button(action: {
                        withAnimation(.spring(response: 0.3)) {
                            audioPlayer.togglePlayback()
                        }
                    }) {
                        Image(systemName: audioPlayer.isPlaying ? "pause.fill" : "play.fill")
                            .font(.system(size: 24))
                            .foregroundColor(selectedSong.isOnline ? .gray : .primary)
                    }
                    .disabled(selectedSong.isOnline)
                    
                    Button(action: nextAction) {
                        Image(systemName: "forward.fill")
                            .font(.system(size: 20))
                            .foregroundColor(selectedSong.isOnline ? .gray : .primary)
                    }
                    .disabled(selectedSong.isOnline || localSongs.count <= 1)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                ZStack {
                    VisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
                    Color.primary.opacity(0.05)
                }
                .clipShape(RoundedRectangle(cornerRadius: 16))
            )
            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(ScaleButtonStyle())
        .foregroundColor(.clear)
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.spring(), value: configuration.isPressed)
    }
}
