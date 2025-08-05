//
//  Item.swift
//  Nirvana
//
//  Created by Akshat Dutt Kaushik on 04/08/25.
//

import Foundation
import SwiftData

@Model
class SongModel {
    let id: UUID
    var name: String
    var artist: String
    var url: URL?
    var imageName: String?
    var isOnline: Bool
    var dateAdded: Date
    
    init(id: UUID = UUID(), name: String, artist: String, url: URL? = nil, imageName: String? = nil, isOnline: Bool = false) {
        self.id = id
        self.name = name
        self.artist = artist
        self.url = url
        self.imageName = imageName
        self.isOnline = isOnline
        self.dateAdded = Date()
    }
}

extension SongModel {
    func toSong() -> Song {
        Song(
            id: self.id,
            url: self.url,
            name: self.name,
            artist: self.artist,
            imageName: self.imageName,
            isOnline: self.isOnline
        )
    }
}

extension Song {
    func toModel() -> SongModel {
        SongModel(
            id: self.id,
            name: self.name,
            artist: self.artist,
            url: self.url,
            imageName: self.imageName,
            isOnline: self.isOnline
        )
    }
}
