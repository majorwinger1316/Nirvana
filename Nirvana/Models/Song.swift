//
//  Song.swift
//  Nirvana
//
//  Created by Akshat Dutt Kaushik on 06/08/25.
//

import Foundation

struct Song: Identifiable, Equatable {
    let id: UUID
    let url: URL?
    let name: String
    let artist: String
    let imageName: String?
    let isOnline: Bool
    let youtubeURL: URL?
    let duration: TimeInterval?
    
    init(id: UUID? = nil, url: URL?, name: String, artist: String, imageName: String?, isOnline: Bool, youtubeURL: URL? = nil, duration: TimeInterval? = nil) {
        self.id = id ?? UUID()
        self.url = url
        self.name = name
        self.artist = artist
        self.imageName = imageName
        self.isOnline = isOnline
        self.youtubeURL = youtubeURL
        self.duration = duration
    }
    
    static func == (lhs: Song, rhs: Song) -> Bool {
        return lhs.id == rhs.id
    }
}

enum LoopMode {
    case none
    case one
    case all
}
