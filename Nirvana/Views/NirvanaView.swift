//
//  NirvanaView.swift
//  Nirvana
//
//  Created by Akshat Dutt Kaushik on 06/08/25.
//

import SwiftUI

struct OnlineView: View {
    @ObservedObject var viewModel: OnlineViewModel
    @State private var searchText = ""
    @FocusState private var isSearchBarFocused: Bool
    @Binding var localSongs: [Song]
    @Binding var selectedSong: Song?
    @Binding var queue: [Song]
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var filteredColdplayAlbums: [Album] {
        if searchText.isEmpty {
            return viewModel.coldplayAlbums
        }
        
        let searchTermLowercased = searchText.lowercased()
        return viewModel.coldplayAlbums.filter { album in
            album.strAlbum.lowercased().contains(searchTermLowercased)
        }
    }
    
    var allAlbums: [Album] {
        return viewModel.weekndAlbums + viewModel.coldplayAlbums
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        // The Weeknd Albums Section
                        Section {
                            ForEach(viewModel.weekndAlbums.filter { $0.strAlbumThumb != nil && !$0.strAlbumThumb!.isEmpty }, id: \.id) { album in
                                AlbumCardView(
                                    album: album,
                                    artist: "The Weeknd",
                                    onTap: {
                                        let onlineSong = Song(
                                            url: nil,
                                            name: album.strAlbum,
                                            artist: "The Weeknd",
                                            imageName: nil,
                                            isOnline: true,
                                            youtubeURL: nil
                                        )
                                        
                                        if !localSongs.contains(where: { $0.name == onlineSong.name && $0.isOnline }) {
                                            localSongs.append(onlineSong)
                                        }
                                        selectedSong = onlineSong
                                    },
                                    onNavigate: {
                                        // Navigate to detailed view
                                    }
                                )
                            }
                            
                            // Coldplay Albums Section
                            ForEach(viewModel.coldplayAlbums.filter { $0.strAlbumThumb != nil && !$0.strAlbumThumb!.isEmpty }, id: \.id) { album in
                                AlbumCardView(
                                    album: album,
                                    artist: "Coldplay",
                                    onTap: {
                                        let onlineSong = Song(
                                            url: nil,
                                            name: album.strAlbum,
                                            artist: "Coldplay",
                                            imageName: nil,
                                            isOnline: true,
                                            youtubeURL: nil
                                        )
                                        
                                        if !localSongs.contains(where: { $0.name == onlineSong.name && $0.isOnline }) {
                                            localSongs.append(onlineSong)
                                        }
                                        selectedSong = onlineSong
                                    },
                                    onNavigate: {
                                        // Navigate to detailed view for Coldplay if needed
                                    }
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
                
                if isSearchBarFocused || !searchText.isEmpty {
                    ScrollView {
                        VStack(alignment: .leading) {
                            
                            LazyVGrid(columns: columns, spacing: 16) {
                                ForEach(filteredColdplayAlbums) { album in
                                    Button(action: {
                                        let onlineSong = Song(
                                            url: nil,
                                            name: album.strAlbum,
                                            artist: "Coldplay",
                                            imageName: nil,
                                            isOnline: true,
                                            youtubeURL: nil
                                        )
                                        
                                        if !localSongs.contains(where: { $0.name == onlineSong.name && $0.isOnline }) {
                                            localSongs.append(onlineSong)
                                        }
                                        selectedSong = onlineSong
                                    }) {
                                        VStack(alignment: .leading, spacing: 8) {
                                            AsyncImage(url: URL(string: album.strAlbumThumb ?? "")) { phase in
                                                switch phase {
                                                case .success(let image):
                                                    image
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(height: 160)
                                                        .clipped()
                                                        .cornerRadius(12)
                                                case .failure, .empty:
                                                    Rectangle()
                                                        .fill(Color(.systemGray6))
                                                        .frame(height: 160)
                                                        .cornerRadius(12)
                                                        .overlay(
                                                            Text(album.strAlbum.prefix(1))
                                                                .font(.title)
                                                                .foregroundColor(.gray)
                                                        )
                                                @unknown default:
                                                    Rectangle()
                                                        .fill(Color(.systemGray6))
                                                        .frame(height: 160)
                                                        .cornerRadius(12)
                                                }
                                            }
                                            
                                            VStack(alignment: .leading, spacing: 2) {
                                                Text(album.strAlbum)
                                                    .font(.headline)
                                                    .lineLimit(2)
                                                    .multilineTextAlignment(.leading)
                                                
                                                Text("Coldplay • \(album.intYearReleased)")
                                                    .font(.caption)
                                                    .foregroundColor(.secondary)
                                                    .lineLimit(1)
                                            }
                                        }
                                        .foregroundColor(.primary)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal)
                            Spacer()
                        }
                        .padding(.top)
                        .background(Color(.systemBackground).opacity(0.95))
                    }
                }
            }
            .background(AnimatedGradientView().gradient)
            .navigationTitle("Nirvana")
            .onAppear {
                viewModel.fetchColdplayDiscography()
                viewModel.fetchWeekndAlbums()
            }
            .searchable(text: $searchText, prompt: "Search albums")
        }
    }
}

struct AlbumCardView: View {
    let album: Album
    let artist: String
    let onTap: () -> Void
    let onNavigate: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                ZStack(alignment: .topTrailing) {
                    AsyncImage(url: URL(string: album.strAlbumThumb ?? "")) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(height: 180)
                                .clipped()
                                .cornerRadius(16)
                        case .failure, .empty:
                            Rectangle()
                                .fill(Color(.systemGray6))
                                .frame(height: 180)
                                .cornerRadius(16)
                                .overlay(
                                    VStack {
                                        Image(systemName: "music.note")
                                            .font(.title)
                                            .foregroundColor(.gray)
                                        Text(album.strAlbum.prefix(1))
                                            .font(.title2)
                                            .foregroundColor(.gray)
                                    }
                                )
                        @unknown default:
                            Rectangle()
                                .fill(Color(.systemGray6))
                                .frame(height: 180)
                                .cornerRadius(16)
                        }
                    }
                    
                    // Online indicator
                    HStack {
                        Spacer()
                        VStack {
                            Image(systemName: "globe")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white)
                                .padding(8)
                                .background(Circle().fill(Color.black.opacity(0.7)))
                            Spacer()
                        }
                    }
                    .padding(12)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(album.strAlbum)
                        .font(.system(size: 16, weight: .semibold))
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    HStack {
                        Text(artist)
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text(album.intYearReleased)
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    }
                }
            }
            .foregroundColor(.primary)
        }
        .buttonStyle(PlainButtonStyle())
        .contextMenu {
            Button(action: onTap) {
                Label("Play Album", systemImage: "play.fill")
            }
            
            if artist == "The Weeknd" {
                Button(action: onNavigate) {
                    Label("View Songs", systemImage: "list.bullet")
                }
            }
        }
    }
}
