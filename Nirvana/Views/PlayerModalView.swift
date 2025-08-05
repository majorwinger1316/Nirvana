//
//  PlayerModalView.swift
//  Nirvana
//
//  Created by Akshat Dutt Kaushik on 06/08/25.
//

import SwiftUI

struct PlayerModalView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var audioPlayer: AudioPlayer
    let song: Song?
    @Binding var queue: [Song]
    @Binding var isShuffled: Bool
    @Binding var loopMode: LoopMode
    let nextAction: () -> Void
    let previousAction: () -> Void
    let animation: Namespace.ID
    
    @State private var selectedTab = 0
    @State private var showDeleteAlert = false
    @State private var songToDelete: Song?
    @State private var dragOffset = CGSize.zero
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(.systemBackground).opacity(0.8),
                        Color(.systemBackground)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.down")
                                .foregroundColor(.secondary)
                                .font(.system(size: 20, weight: .medium))
                        }
                        .padding()
                        
                        Spacer()
                        
                        RoundedRectangle(cornerRadius: 2.5)
                            .fill(Color.secondary.opacity(0.3))
                            .frame(width: 36, height: 5)
                        
                        Spacer()

                        Button {
                        } label: {
                            Color.clear
                                .frame(width: 44, height: 44)
                        }
                    }

                    Picker("View", selection: $selectedTab) {
                        Text("Now Playing").tag(0)
                        Text("Queue").tag(1)
                    }
                    .pickerStyle(.segmented)
                    .padding()
                    
                    if selectedTab == 0 {
                        ScrollView {
                            nowPlayingView(geometry: geometry)
                        }
                    } else {
                        queueView
                    }
                }
            }
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        if gesture.translation.height > 0 {
                            dragOffset = gesture.translation
                        }
                    }
                    .onEnded { gesture in
                        if gesture.translation.height > 100 {
                            dismiss()
                        }
                        dragOffset = .zero
                    }
            )
            .offset(y: dragOffset.height)
            .animation(.interactiveSpring(), value: dragOffset)
        }
        .alert("Remove from Queue", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) {
                songToDelete = nil
            }
            Button("Remove", role: .destructive) {
                if let song = songToDelete,
                   let index = queue.firstIndex(where: { $0.id == song.id }) {
                    queue.remove(at: index)
                    songToDelete = nil
                }
            }
        } message: {
            if let song = songToDelete {
                Text("Remove \(song.name) from the queue?")
            }
        }
    }
    
    private func nowPlayingView(geometry: GeometryProxy) -> some View {
        VStack(spacing: 24) {
            Group {
                if let song = song, let imageName = song.imageName {
                    Image(imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width * 0.7, height: geometry.size.width * 0.7)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(radius: 10)
                } else {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(.systemGray6))
                        .frame(width: geometry.size.width * 0.7, height: geometry.size.width * 0.7)
                        .overlay(
                            Text(song?.name.prefix(1) ?? "")
                                .font(.system(size: 60, weight: .bold))
                                .foregroundColor(.gray)
                        )
                        .shadow(radius: 10)
                }
            }
            .matchedGeometryEffect(id: "songImage", in: animation)
            .padding(.top, 32)
            
            VStack(spacing: 8) {
                Text(song?.name ?? "Unknown Song")
                    .font(.system(size: 24, weight: .bold))
                    .multilineTextAlignment(.center)
                
                Text(song?.artist ?? "Unknown Artist")
                    .font(.system(size: 18))
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)

            playbackControls
        }
    }
    
    private var queueView: some View {
        VStack {
            if queue.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "music.note.list")
                        .font(.system(size: 48))
                        .foregroundColor(.secondary)
                    Text("Queue is empty")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Text("Add songs from your library")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxHeight: .infinity)
            } else {
                List {
                    ForEach(queue) { queuedSong in
                        HStack {
                            if let imageName = queuedSong.imageName {
                                Image(imageName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 40, height: 40)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            } else {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color(.systemGray6))
                                    .frame(width: 40, height: 40)
                                    .overlay(
                                        Text(queuedSong.name.prefix(1))
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    )
                            }
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(queuedSong.name)
                                    .font(.system(size: 16, weight: .medium))
                                Text(queuedSong.artist)
                                    .font(.system(size: 14))
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            if song?.id == queuedSong.id {
                                Image(systemName: "music.note")
                                    .foregroundColor(.indigo)
                            }
                            
                            Button {
                                songToDelete = queuedSong
                                showDeleteAlert = true
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .onMove { indices, newOffset in
                        queue.move(fromOffsets: indices, toOffset: newOffset)
                    }
                }
                .listStyle(.plain)
                .toolbar {
                    EditButton()
                }
            }
        }
    }
    
    private var playbackControls: some View {
        VStack(spacing: 20) {
            VStack(spacing: 8) {
                Slider(
                    value: $audioPlayer.currentTime,
                    in: 0...audioPlayer.duration,
                    onEditingChanged: { editing in
                        if !editing {
                            audioPlayer.seek(to: audioPlayer.currentTime)
                        }
                    }
                )
                .accentColor(.indigo)
                
                HStack {
                    Text(formatTime(audioPlayer.currentTime))
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("-\(formatTime(audioPlayer.duration - audioPlayer.currentTime))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal)

            HStack(spacing: 40) {
                Button(action: previousAction) {
                    Image(systemName: "backward.fill")
                        .font(.system(size: 24))
                }
                .disabled(queue.isEmpty)
                
                Button(action: {
                    audioPlayer.togglePlayback()
                }) {
                    Image(systemName: audioPlayer.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.system(size: 50))
                }
                
                Button(action: nextAction) {
                    Image(systemName: "forward.fill")
                        .font(.system(size: 24))
                }
                .disabled(queue.isEmpty)
            }
            .foregroundColor(.indigo)

            HStack(spacing: 50) {
                Button(action: {
                    isShuffled.toggle()
                    if isShuffled {
                        queue.shuffle()
                    }
                }) {
                    Image(systemName: isShuffled ? "shuffle.circle.fill" : "shuffle")
                        .font(.system(size: 20))
                        .foregroundColor(isShuffled ? .indigo : .secondary)
                }
                
                Button(action: {
                    switch loopMode {
                    case .none: loopMode = .all
                    case .all: loopMode = .one
                    case .one: loopMode = .none
                    }
                }) {
                    Image(systemName: loopMode == .none ? "repeat" : loopMode == .all ? "repeat.circle.fill" : "repeat.1.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(loopMode != .none ? .indigo : .secondary)
                }
            }
        }
        .padding(.vertical)
    }
    
    private func formatTime(_ time: Double) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

struct PlaybackButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.6 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(), value: configuration.isPressed)
    }
}

struct QueueItemView: View {
    let song: Song
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            if let imageName = song.imageName {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 40, height: 40)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.systemGray6))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Text(song.name.prefix(1))
                            .font(.caption)
                            .foregroundColor(.gray)
                    )
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(song.name)
                    .font(.system(size: 14, weight: .medium))
                Text(song.artist)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: onDelete) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.secondary)
                    .imageScale(.medium)
            }
        }
        .padding(.horizontal)
        .contentShape(Rectangle())
    }
}
