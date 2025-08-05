//
//  Extensions.swift
//  Nirvana
//
//  Created by Akshat Dutt Kaushik on 06/08/25.
//

import Foundation

extension Array {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

extension Notification.Name {
    static let audioPlayerDidFinishPlaying = Notification.Name("audioPlayerDidFinishPlaying")
}
