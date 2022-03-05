import UIKit

class MenuViewController: BaseVC {
    
    var musicOff: Bool! {
        didSet {
            if !musicOff {
                playSound()
                UserDefaults.standard.set(false, forKey: "musicOff")
                musicButton.setImage(UIImage(named: "musicOn"), for: .normal)
            } else {
                player?.stop()
                UserDefaults.standard.set(true, forKey: "musicOff")
                musicButton.setImage(UIImage(named: "musicOff"), for: .normal)
            }
        }
    }
    
    @IBOutlet weak var musicButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        musicOff = UserDefaults.standard.bool(forKey: "musicOff")
    }
    
    @IBAction func playTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let identifier = String(describing: LocationsViewController.self)
        
        guard let locationsViewController = storyboard.instantiateViewController(withIdentifier: identifier) as? LocationsViewController else { return }
        
        locationsViewController.modalPresentationStyle = .custom
        locationsViewController.transitioningDelegate = self
        
        present(locationsViewController, animated: true)
    }
    
    
    @IBAction func infoButton(_ sender: UIButton) {
        
        
    }
    
    @IBAction func musicTapped(_ sender: UIButton) {
        musicOff = !musicOff
    }
}
