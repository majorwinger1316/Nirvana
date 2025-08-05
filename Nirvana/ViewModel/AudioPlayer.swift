//
//  AudioPlayer.swift
//  Nirvana
//
//  Created by Akshat Dutt Kaushik on 06/08/25.
//


import Foundation
import AVFoundation

class AudioPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate {
    @Published var isPlaying = false
    @Published var currentTime: Double = 0
    @Published var duration: Double = 0
    private var audioPlayer: AVAudioPlayer?
    private var timer: Timer?
    
    override init() {
        super.init()
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }
    
    func loadAudio(from url: URL) {
        do {
            let fileURL = try saveToDocumentsDirectory(from: url)
            audioPlayer = try AVAudioPlayer(contentsOf: fileURL)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
            duration = audioPlayer?.duration ?? 0
            audioPlayer?.numberOfLoops = 0
            updateCurrentTime()
        } catch {
            print("Error loading audio from URL: \(error)")
        }
    }
    
    func togglePlayback() {
        if isPlaying {
            audioPlayer?.pause()
            timer?.invalidate()
        } else {
            audioPlayer?.play()
            startTimer()
        }
        isPlaying.toggle()
    }
    
    func stop() {
        audioPlayer?.stop()
        timer?.invalidate()
        isPlaying = false
        currentTime = 0
    }
    
    func seek(to time: Double) {
        audioPlayer?.currentTime = time
        currentTime = time
    }
    
    func setLooping(_ shouldLoop: Bool) {
        audioPlayer?.numberOfLoops = shouldLoop ? -1 : 0
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self, let player = self.audioPlayer else { return }
            self.currentTime = player.currentTime
            if !player.isPlaying && self.isPlaying {
                self.isPlaying = false
                self.timer?.invalidate()
            }
        }
    }
    
    private func updateCurrentTime() {
        currentTime = audioPlayer?.currentTime ?? 0
    }
    
    private func saveToDocumentsDirectory(from url: URL) throws -> URL {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationURL = documentsURL.appendingPathComponent(url.lastPathComponent)
        if FileManager.default.fileExists(atPath: destinationURL.path) {
            try FileManager.default.removeItem(at: destinationURL)
        }
        try FileManager.default.copyItem(at: url, to: destinationURL)
        return destinationURL
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            isPlaying = false
            timer?.invalidate()
            NotificationCenter.default.post(name: .audioPlayerDidFinishPlaying, object: nil)
        }
    }
}