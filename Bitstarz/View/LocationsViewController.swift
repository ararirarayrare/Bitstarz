import UIKit

class LocationsViewController: BaseVC {
    
    
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    @IBAction func backTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let identifier = String(describing: LevelsViewController.self)
        
        guard let levelsViewController = storyboard.instantiateViewController(withIdentifier: identifier) as? LevelsViewController else { return }
        
        guard let id = sender.titleLabel?.text else { return }
        
        levelsViewController.locationID = Int(id)
        
        levelsViewController.modalPresentationStyle = .custom
        levelsViewController.transitioningDelegate = self
        
        present(levelsViewController, animated: true)
    }
    
    func configure() {
        let secondOpen = UserDefaults.standard.integer(forKey: "levelsOpened0") == 12
        let thirdOpen = UserDefaults.standard.integer(forKey: "levelsOpened1") == 12 && secondOpen
        
        if !secondOpen {
//            secondButton.isUserInteractionEnabled = false
//            secondButton.setImage(UIImage(named: "locked1"), for: .normal)
//            secondButton.layer.opacity = 0.5
            lock(button: secondButton)
        }
        
        if !thirdOpen {
//            thirdButton.isUserInteractionEnabled = false
//            thirdButton.setImage(UIImage(named: "locked2"), for: .normal)
//            thirdButton.layer.opacity = 0.5
            lock(button: thirdButton)
        }
    }
    
    func lock(button: UIButton) {
        button.isUserInteractionEnabled = false
        
        button.layer.opacity = 0.25
        
        
        let frame = CGRect(x: button.frame.midX,
                           y: button.frame.maxY,
                           width: button.frame.width * 0.5,
                           height: button.frame.height * 0.5)
        let lock = UIImageView(frame: frame)
        lock.contentMode = .scaleAspectFill
        lock.image = UIImage(named: "lock")
                
        view.addSubview(lock)
    }
    

}
