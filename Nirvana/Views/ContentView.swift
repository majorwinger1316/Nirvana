//
//  ContentView.swift
//  Nirvana
//
//  Created by Akshat Dutt Kaushik on 04/08/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var audioPlayer = AudioPlayer()
    @StateObject private var onlineViewModel = OnlineViewModel()
    @State private var selectedSong: Song?
    @State private var isPlayerModalPresented = false
    @State private var queue: [Song] = []
    @State private var localSongs: [Song] = []
    @State private var isShuffled = false
    @State private var loopMode: LoopMode = .none
    @Namespace private var animation
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView {
                OnlineView(
                    viewModel: onlineViewModel, localSongs: $localSongs,
                    selectedSong: $selectedSong,
                    queue: $queue
                )
                .tabItem {
                    Label("Nirvana", systemImage: "music.note")
                }
                
                LocalSongsView(
                    audioPlayer: audioPlayer,
                    selectedSong: $selectedSong,
                    localSongs: $queue,
                    queue: $queue
                )
                .tabItem {
                    Label("Offline", systemImage: "music.note.list")
                }
            }
            .tint(.indigo)
            .background(Color.primary)
            
            if let selectedSong = selectedSong {
                MiniPlayerView(
                    audioPlayer: audioPlayer,
                    selectedSong: selectedSong,
                    localSongs: queue,
                    isPlayerModalPresented: $isPlayerModalPresented,
                    nextAction: { selectNextSong() },
                    previousAction: { selectPreviousSong() },
                    animation: animation
                )
                .padding(.horizontal)
                .background(
                    VisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
                        .cornerRadius(10)
                        .shadow(radius: 5)
                )
                .padding(.horizontal)
                .offset(y: -50)
            }
        }
        .onAppear {
            loadLocalSongs()
        }
        .onReceive(NotificationCenter.default.publisher(for: .audioPlayerDidFinishPlaying)) { _ in
            handleSongFinished()
        }
        .fullScreenCover(isPresented: $isPlayerModalPresented) {
            PlayerModalView(
                audioPlayer: audioPlayer,
                song: selectedSong,
                queue: $queue,
                isShuffled: $isShuffled,
                loopMode: $loopMode,
                nextAction: { selectNextSong() },
                previousAction: { selectPreviousSong() },
                animation: animation
            )
        }
        .onChange(of: selectedSong) { _, newSong in
            handleSongSelection(newSong)
        }
    }
    
    private func handleSongSelection(_ song: Song?) {
        guard let song = song else { return }
        
        if song.isOnline {
            audioPlayer.stop()
            print("Selected online song: \(song.name) - This would open in YouTube/browser")
        } else {
            if let url = song.url {
                audioPlayer.loadAudio(from: url)
            }
        }
    }
    
    private func loadLocalSongs() {
        let defaultSong = Song(
            url: Bundle.main.url(forResource: "Gangsta_Paradise", withExtension: "mp3")!,
            name: "Gangsta's Paradise",
            artist: "Coolio",
            imageName: "coolio",
            isOnline: false
        )

        if selectedSong == nil {
            selectedSong = defaultSong
            queue = [defaultSong]
            if let url = defaultSong.url {
                audioPlayer.loadAudio(from: url)
            }
        }
    }
    
    private func selectNextSong() {
        guard !queue.isEmpty else { return }

        let offlineSongs = queue.filter { !$0.isOnline }
        guard !offlineSongs.isEmpty else { return }
        
        if isShuffled {
            selectRandomOfflineSong(from: offlineSongs)
            return
        }
        
        if let currentSong = selectedSong,
           let currentIndex = offlineSongs.firstIndex(where: { $0.id == currentSong.id }) {
            let nextIndex = (currentIndex + 1) % offlineSongs.count
            selectedSong = offlineSongs[nextIndex]
        } else {
            selectedSong = offlineSongs.first
        }
    }
    
    private func selectPreviousSong() {
        guard !queue.isEmpty else { return }

        let offlineSongs = queue.filter { !$0.isOnline }
        guard !offlineSongs.isEmpty else { return }
        
        if isShuffled {
            selectRandomOfflineSong(from: offlineSongs)
            return
        }
        
        if let currentSong = selectedSong,
           let currentIndex = offlineSongs.firstIndex(where: { $0.id == currentSong.id }) {
            let previousIndex = (currentIndex - 1 + offlineSongs.count) % offlineSongs.count
            selectedSong = offlineSongs[previousIndex]
        } else {
            selectedSong = offlineSongs.last
        }
    }
    
    private func selectRandomOfflineSong(from offlineSongs: [Song]) {
        guard offlineSongs.count > 1 else { return }
        
        var nextIndex = Int.random(in: 0..<offlineSongs.count)
        if let currentSong = selectedSong,
           let currentIndex = offlineSongs.firstIndex(where: { $0.id == currentSong.id }) {
            while nextIndex == currentIndex {
                nextIndex = Int.random(in: 0..<offlineSongs.count)
            }
        }
        
        selectedSong = offlineSongs[nextIndex]
    }
    
    private func handleSongFinished() {
        guard let currentSong = selectedSong, !currentSong.isOnline else { return }
        
        switch loopMode {
        case .none:
            selectNextSong()
        case .one:
            if let url = selectedSong?.url {
                audioPlayer.loadAudio(from: url)
            }
        case .all:
            selectNextSong()
        }
    }
}

#Preview {
    ContentView()
}
