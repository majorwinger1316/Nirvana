//
//  OnlineMusic.swift
//  Nirvana
//
//  Created by Akshat Dutt Kaushik on 06/08/25.
//

import SwiftUI

struct MusicVideo: Codable, Identifiable {
    let id: String
    let strArtist: String
    let strTrack: String
    let intDuration: String
    let strTrackThumb: String?
    let strMusicVid: String?
    let strDescriptionEN: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "idTrack"
        case strArtist
        case strTrack
        case intDuration
        case strTrackThumb
        case strMusicVid
        case strDescriptionEN
    }
}

struct MusicVideoResponse: Codable {
    let mvids: [MusicVideo]
}
