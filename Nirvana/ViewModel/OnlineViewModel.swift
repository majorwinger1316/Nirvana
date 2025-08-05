//
//  OnlineViewModel.swift
//  Nirvana
//
//  Created by Akshat Dutt Kaushik on 06/08/25.
//

import Foundation

class OnlineViewModel: ObservableObject {
    @Published var coldplayAlbums: [Album] = []
    @Published var weekndAlbums: [Album] = []
    @Published var weekndSongs: [Song] = []
    
    func fetchColdplayDiscography() {
        let urlString = APIConstants.coldplayDiscographyURL
        
        guard let url = URL(string: urlString) else {
            print("Invalid Coldplay URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching Coldplay data: \(error)")
                return
            }
            
            guard let data = data else {
                print("No Coldplay data received")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(DiscographyResponse.self, from: data)
                DispatchQueue.main.async {
                    self.coldplayAlbums = response.album
                }
            } catch {
                print("Error decoding Coldplay JSON: \(error)")
            }
        }.resume()
    }
    
    func fetchWeekndSongs() {
        let urlString = APIConstants.weekndMusicVideosURL
        
        guard let url = URL(string: urlString) else {
            print("Invalid Weeknd Songs URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching Weeknd songs: \(error)")
                return
            }
            
            guard let data = data else {
                print("No song data received")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(MusicVideoResponse.self, from: data)
                DispatchQueue.main.async {
                    self.weekndSongs = response.mvids.compactMap { mvid in
                        guard let youtubeURLString = mvid.strMusicVid,
                              let youtubeURL = URL(string: youtubeURLString) else {
                            print("Invalid or missing YouTube URL for: \(mvid.strTrack)")
                            return nil
                        }

                        let durationInSeconds = (Double(mvid.intDuration) ?? 0.0) / 1000.0
                        
                        return Song(
                            url: nil,
                            name: mvid.strTrack,
                            artist: mvid.strArtist,
                            imageName: nil,
                            isOnline: true,
                            youtubeURL: youtubeURL,
                            duration: durationInSeconds
                        )
                    }
                    print("Fetched \(self.weekndSongs.count) Weeknd songs")
                }
            } catch {
                print("Error decoding songs JSON: \(error)")
            }
        }.resume()
    }
    
    func fetchWeekndAlbums() {
        let urlString = APIConstants.weekndAlbumsURL
        
        guard let url = URL(string: urlString) else {
            print("Invalid Weeknd URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching Weeknd data: \(error)")
                return
            }
            
            guard let data = data else {
                print("No Weeknd data received")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(DiscographyResponse.self, from: data)
                DispatchQueue.main.async {
                    self.weekndAlbums = response.album
                }
            } catch {
                print("Error decoding Weeknd JSON: \(error)")
            }
        }.resume()
    }
}
