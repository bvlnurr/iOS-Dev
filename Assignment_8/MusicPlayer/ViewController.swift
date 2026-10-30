//
//  ViewController.swift
//  MusicPlayer
//
//  Created by Балнур on 29.10.2026.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    
    private let tracks = TrackLibrary.tracks
    
    private var currentTrackIndex = 0
    private var audioPlayer: AVAudioPlayer?
    private var isPlaying = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playPauseButton.layer.cornerRadius = 30
        playPauseButton.clipsToBounds = true
        
        updateUI()
        loadCurrentTrack()
    }
    
    
    
    private func updateUI() {
        let track = tracks[currentTrackIndex]
        
        titleLabel.text = track.title
        artistLabel.text = track.artist
        coverImageView.image = UIImage(
            named: track.coverImageName
        )
        
        let iconName = isPlaying
                    ? "pause.fill"
                    : "play.fill"
        
        playPauseButton.setImage(
            UIImage(systemName: iconName),
            for: .normal)
        
    }
    
    
    
    @discardableResult
    private func loadCurrentTrack() -> Bool {
        audioPlayer?.stop()
        audioPlayer = nil
        
        let track = tracks[currentTrackIndex]
        
        guard let url = Bundle.main.url(
            forResource: track.fileName,
            withExtension: "mp3"
        )else{
            print("Audio file not found: \(track.fileName)")
            isPlaying = false
            updateUI()
            return false
        }
        
        do{
            audioPlayer = try AVAudioPlayer(
                contentsOf: url
            )
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
            
            return true
            
            
        }catch{
            print("Failed to load audio:\(error)")
            isPlaying = false
            updateUI()
            return false
            
        }
        
    }
    
    private func playCurrentTrack() {
        guard let player = audioPlayer else{
            isPlaying = false
            updateUI()
            return
        }
        
        isPlaying = player.play()
        updateUI()
        
    }
    
    private func pauseCurrentTrack() {
        audioPlayer?.pause()
        isPlaying = false
        updateUI()
    }
    
    
    
    
    @IBAction func previousTapped(_ sender: UIButton) {
        switchTrack(by: -1)
    }
    
    
    @IBAction func playPauseTapped(_ sender: UIButton) {
        if isPlaying{
            pauseCurrentTrack()
        }else{
            playCurrentTrack()
        }
        
        
    }
    
    
    @IBAction func nextTapped(_ sender: UIButton) {
        switchTrack(by: 1)
    }
    
    private func switchTrack(by offset: Int) {
        let shouldContinuePlaying = isPlaying
        
        currentTrackIndex = (
            currentTrackIndex + offset + tracks.count
        )%tracks.count
        
        isPlaying = false
        updateUI()
        
        let loaded = loadCurrentTrack()
        
        if shouldContinuePlaying && loaded{
            playCurrentTrack()
        }
        
    }
    
}

extension ViewController: AVAudioPlayerDelegate{
    func audioPlayerDidFinishPlaying(
        _ player: AVAudioPlayer,
        successfully flag: Bool) {
        isPlaying = true
        switchTrack(by: 1)
    }
}

