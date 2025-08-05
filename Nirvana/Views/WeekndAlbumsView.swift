//
//  WeekndAlbumsView.swift
//  Nirvana
//
//  Created by Akshat Dutt Kaushik on 06/08/25.
//

import SwiftUI

struct WeekndAlbumsView: View {
    let albums: [Album]
    @ObservedObject var viewModel: OnlineViewModel
    @Binding var localSongs: [Song]
    @Binding var selectedSong: Song?
    @Binding var queue: [Song]
    
    var body: some View {
        ZStack {
            List {
                Section(header: Text("Albums")) {
                    ForEach(albums) { album in
                        HStack(spacing: 10) {
                            AsyncImage(url: URL(string: album.strAlbumThumb ?? "")) { phase in
                                switch phase {
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 60, height: 60)
                                        .clipped()
                                        .cornerRadius(8)
                                case .failure, .empty:
                                    Color(.systemGray6)
                                        .frame(width: 60, height: 60)
                                        .cornerRadius(8)
                                        .overlay(
                                            Text(album.strAlbum.prefix(1))
                                                .font(.headline)
                                                .foregroundColor(.gray)
                                        )
                                @unknown default:
                                    Color(.systemGray6)
                                        .frame(width: 60, height: 60)
                                        .cornerRadius(8)
                                }
                            }
                            
                            VStack(alignment: .leading) {
                                Text(album.strAlbum)
                                    .font(.headline)
                                Text("Released: \(album.intYearReleased)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                        }
                        .padding(.vertical, 4)
                    }
                }
                
                Section(header: Text("Songs (Online - YouTube)")) {
                    ForEach(viewModel.weekndSongs) { song in
                        Button {
                            selectedSong = song

                            if !localSongs.contains(where: { $0.name == song.name }) {
                                localSongs.append(song)
                            }

                            if !queue.contains(where: { $0.name == song.name }) {
                                queue.append(song)
                            }

                            if let youtubeURL = song.youtubeURL {
                                print("Opening YouTube URL: \(youtubeURL)")
                                UIApplication.shared.open(youtubeURL)
                            }
                        } label: {
                            HStack(spacing: 10) {
                                Circle()
                                    .fill(Color(.systemGray6))
                                    .frame(width: 50, height: 50)
                                    .overlay(
                                        Image(systemName: "play.circle")
                                            .font(.system(size: 24))
                                            .foregroundColor(.red)
                                    )
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(song.name)
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    
                                    HStack {
                                        Text(song.artist)
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                        
                                        Spacer()
                                        
                                        if let duration = song.duration {
                                            Text(formatDuration(duration))
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                        
                                        Image(systemName: "globe")
                                            .font(.caption)
                                            .foregroundColor(.blue)
                                    }
                                }
                                
                                Spacer()
                                
                                Menu {
                                    Button(action: {
                                        if !queue.contains(where: { $0.id == song.id }) {
                                            queue.append(song)
                                        }
                                    }) {
                                        Label("Add to Queue", systemImage: "text.badge.plus")
                                    }
                                    
                                    if let youtubeURL = song.youtubeURL {
                                        Button(action: {
                                            UIApplication.shared.open(youtubeURL)
                                        }) {
                                            Label("Open in YouTube", systemImage: "globe")
                                        }
                                    }
                                } label: {
                                    Image(systemName: "ellipsis")
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .listStyle(.plain)
        }
        .background(AnimatedGradientView().gradient)
        .navigationTitle("The Weeknd")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.fetchWeekndSongs()
        }
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}
