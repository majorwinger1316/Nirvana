//
//  Album.swift
//  Nirvana
//
//  Created by Akshat Dutt Kaushik on 06/08/25.
//


import Foundation

struct Album: Codable, Identifiable {
    let id = UUID()
    let strAlbum: String
    let intYearReleased: String
    let strAlbumThumb: String?
    
    enum CodingKeys: String, CodingKey {
        case strAlbum
        case intYearReleased
        case strAlbumThumb
    }
}

struct DiscographyResponse: Codable {
    let album: [Album]
}