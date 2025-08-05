//
//  LocalSongsView.swift
//  Nirvana
//
//  Created by Akshat Dutt Kaushik on 06/08/25.
//

import SwiftUI
import SwiftData

struct LocalSongsView: View {
    @ObservedObject var audioPlayer: AudioPlayer
    @Binding var selectedSong: Song?
    @Binding var localSongs: [Song]
    @Binding var queue: [Song]
    @Query private var songModels: [SongModel]
    @Environment(\.modelContext) private var modelContext
    @State private var isFilePickerPresented = false
    @State private var isEditing = false
    @State private var selectedSongIDs: Set<UUID> = []
    @State private var showDeleteAlert = false
    @State private var songToDelete: Song?
    @State private var showToast = false
    @State private var toastMessage = ""
    @State private var searchText = ""
    
    private var filteredSongs: [Song] {
        let defaultId = UUID(uuidString: "00000000-0000-0000-0000-000000000000")!
        let defaultSong = Song(
            id: defaultId,
            url: Bundle.main.url(forResource: "Gangsta_Paradise", withExtension: "mp3")!,
            name: "Gangsta's Paradise",
            artist: "Coolio",
            imageName: "coolio",
            isOnline: false
        )
        
        var songs = [defaultSong]
        let modelSongs = songModels.map { model -> Song in
            print("Converting model to song - ID: \(model.id), Name: \(model.name)")
            return model.toSong()
        }
        songs.append(contentsOf: modelSongs)
        
        if searchText.isEmpty {
            return songs
        }
        return songs.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.artist.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var deleteAlertTitle: String {
        if !selectedSongIDs.isEmpty {
            return "Delete \(selectedSongIDs.count) Songs?"
        } else if let song = songToDelete {
            return "Delete \(song.name)?"
        }
        return "Delete Song?"
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(filteredSongs) { song in
                            SongRowView(
                                song: song,
                                isSelected: selectedSong?.id == song.id,
                                isEditing: isEditing,
                                isCheckboxSelected: selectedSongIDs.contains(song.id),
                                onCheckboxTap: {
                                    print("Checkbox tapped for song: \(song.name), ID: \(song.id)")
                                    if !isDefaultSong(song) {
                                        if selectedSongIDs.contains(song.id) {
                                            print("Removing song ID from selection")
                                            selectedSongIDs.remove(song.id)
                                        } else {
                                            print("Adding song ID to selection")
                                            selectedSongIDs.insert(song.id)
                                        }
                                        print("Selected songs count: \(selectedSongIDs.count)")
                                    }
                                },
                                onTap: {
                                    selectedSong = song
                                    if let url = song.url {
                                        audioPlayer.loadAudio(from: url)
                                    }
                                },
                                onAddToQueue: {
                                    addToQueue(song)
                                },
                                onDelete: {
                                    print("Delete requested for song: \(song.name), ID: \(song.id)")
                                    songToDelete = song
                                    showDeleteAlert = true
                                }
                            )
                        }
                    }
                    .padding(.bottom, 100)
                }
                
                if showToast {
                    ToastView(message: toastMessage)
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .zIndex(1)
                }
                
                if filteredSongs.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "music.note.list")
                            .font(.system(size: 48))
                            .foregroundColor(.secondary)
                        Text("No songs found")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Button("Add Songs") {
                            isFilePickerPresented = true
                        }
                        .buttonStyle(.bordered)
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search songs")
            .background(AnimatedGradientView().gradient)
            .navigationTitle("Library")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if !filteredSongs.isEmpty {
                        Button(isEditing ? "Done" : "Edit") {
                            withAnimation {
                                isEditing.toggle()
                                if !isEditing {
                                    selectedSongIDs.removeAll()
                                }
                            }
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        if isEditing && !selectedSongIDs.isEmpty {
                            Button(action: {
                                print("Delete button tapped, selected IDs: \(selectedSongIDs)")
                                showDeleteAlert = true
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                        }
                        
                        Button(action: { isFilePickerPresented = true }) {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
            .sheet(isPresented: $isFilePickerPresented) {
                DocumentPicker { url in
                    handleNewSong(from: url)
                }
            }
            .alert(deleteAlertTitle, isPresented: $showDeleteAlert) {
                Button("Cancel", role: .cancel) {
                    songToDelete = nil
                }
                Button("Delete", role: .destructive) {
                    print("Delete confirmed")
                    if !selectedSongIDs.isEmpty {
                        print("Deleting multiple songs: \(selectedSongIDs)")
                        deleteSongs(selectedSongIDs)
                    } else if let song = songToDelete {
                        print("Deleting single song: \(song.name), ID: \(song.id)")
                        deleteSongs([song.id])
                    }
                }
            } message: {
                Text("This action cannot be undone.")
            }
        }
    }
    
    private func isDefaultSong(_ song: Song) -> Bool {
        song.url == Bundle.main.url(forResource: "Gangsta_Paradise", withExtension: "mp3")
    }
    
    private func addToQueue(_ song: Song) {
        if !queue.contains(where: { $0.id == song.id }) {
            queue.append(song)
            showToastMessage("\(song.name) added to queue")
        }
    }
    
    private func handleNewSong(from url: URL) {
        print("Adding new song from URL: \(url)")
        let songName = url.deletingPathExtension().lastPathComponent
        let id = UUID() // Create a single ID to use
        print("Generated new ID: \(id)")
        
        let newSongModel = SongModel(
            id: id, // Use the same ID
            name: songName,
            artist: "Unknown Artist",
            url: url,
            isOnline: false
        )
        
        print("Created new song model with ID: \(newSongModel.id)")
        modelContext.insert(newSongModel)
        
        do {
            try modelContext.save()
            print("Successfully saved new song to SwiftData")
            showToastMessage("\(songName) added to library")
        } catch {
            print("Error saving song: \(error)")
            showToastMessage("Error adding song")
        }
    }
    
    private func deleteSongs(_ songIds: Set<UUID>) {
        print("\n=== Starting deletion process ===")
        print("Songs to delete: \(songIds.count)")
        print("Current songModels count: \(songModels.count)")
        
        var updatedQueue = queue
        
        for id in songIds {
            print("\nProcessing deletion for ID: \(id)")
            
            if let modelToDelete = songModels.first(where: { $0.id == id }) {
                print("Found model to delete: \(modelToDelete.name)")
                
                if let url = modelToDelete.url {
                    print("Attempting to delete file at: \(url)")
                    do {
                        if FileManager.default.fileExists(atPath: url.path) {
                            try FileManager.default.removeItem(at: url)
                            print("Successfully deleted file")
                        } else {
                            print("File does not exist at path: \(url.path)")
                        }
                    } catch {
                        print("Error deleting file: \(error)")
                    }
                }
                
                print("Removing from SwiftData")
                modelContext.delete(modelToDelete)
                
                print("Updating queue")
                updatedQueue.removeAll(where: { $0.url == modelToDelete.url })
                
                if selectedSong?.url == modelToDelete.url {
                    print("Updating selected song")
                    if let nextSong = updatedQueue.first {
                        selectedSong = nextSong
                        if let url = nextSong.url {
                            audioPlayer.loadAudio(from: url)
                        }
                    } else {
                        print("Setting default song")
                        let defaultSong = Song(
                            url: Bundle.main.url(forResource: "Gangsta_Paradise", withExtension: "mp3")!,
                            name: "Gangsta's Paradise",
                            artist: "Coolio",
                            imageName: "coolio",
                            isOnline: false
                        )
                        selectedSong = defaultSong
                        updatedQueue = [defaultSong]
                        if let url = defaultSong.url {
                            audioPlayer.loadAudio(from: url)
                        }
                    }
                }
            } else {
                print("⚠️ No model found for ID: \(id)")
            }
        }
        
        queue = updatedQueue
        
        do {
            print("\nSaving model context...")
            try modelContext.save()
            print("Successfully saved model context")
            
            DispatchQueue.main.async {
                selectedSongIDs.removeAll()
                songToDelete = nil
                isEditing = false
            }
            
            showToastMessage("Song\(songIds.count > 1 ? "s" : "") deleted")
        } catch {
            print("❌ Error saving context: \(error)")
            showToastMessage("Error deleting song\(songIds.count > 1 ? "s" : "")")
        }
        
        print("\n=== Deletion process completed ===")
        print("Final songModels count: \(songModels.count)")
        print("Final queue count: \(queue.count)")
    }
    
    private func showToastMessage(_ message: String) {
        toastMessage = message
        withAnimation {
            showToast = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showToast = false
            }
        }
    }
}

struct SongRowView: View {
    let song: Song
    let isSelected: Bool
    let isEditing: Bool
    let isCheckboxSelected: Bool
    let onCheckboxTap: () -> Void
    let onTap: () -> Void
    let onAddToQueue: () -> Void
    let onDelete: () -> Void
    
    var isDefaultSong: Bool {
        song.url == Bundle.main.url(forResource: "Gangsta_Paradise", withExtension: "mp3")
    }
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                if isEditing {
                    Button(action: onCheckboxTap) {
                        Image(systemName: isCheckboxSelected ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(isCheckboxSelected ? .blue : .secondary)
                            .imageScale(.large)
                    }
                    .disabled(isDefaultSong)
                }
                
                if let imageName = song.imageName {
                    Image(imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                } else {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.systemGray6))
                        .frame(width: 50, height: 50)
                        .overlay(
                            Text(song.name.prefix(1))
                                .font(.headline)
                                .foregroundColor(.gray)
                        )
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(song.name)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(isSelected ? .indigo : .primary)
                    
                    Text(song.artist)
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "music.note")
                        .foregroundColor(.indigo)
                }
                
                Menu {
                    Button(action: onAddToQueue) {
                        Label("Add to Queue", systemImage: "text.badge.plus")
                    }
                    
                    if !isDefaultSong {
                        Button(role: .destructive, action: onDelete) {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.secondary)
                        .frame(width: 24, height: 24)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(isSelected ? Color.indigo.opacity(0.1) : Color.clear)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}
