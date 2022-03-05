import AVFoundation

var player: AVAudioPlayer?


func playSound() {
    guard let url = Bundle.main.url(forResource: "backgroundMusic", withExtension: "mp3") else { return }
    
    do {
        try AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback)
        try AVAudioSession.sharedInstance().setActive(true)
        
        player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
        
        guard let player = player else { return }
        
        player.volume = 0.5
        player.numberOfLoops = -1
        
        player.play()
        
    } catch let error {
        print(error.localizedDescription)
    }
    
}
