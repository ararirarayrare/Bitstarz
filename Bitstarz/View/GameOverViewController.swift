import UIKit

class GameOverViewController: BaseVC {
    
    var won: Bool!
    
    var nextCompletion: (() -> ())!
    var replayCompletion: (() -> ())!
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if won {
            playButton.setImage(UIImage(named: "next"), for: .normal)
            imageView.image = UIImage(named: "win")
        }
    }
    

    @IBAction func replayTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
        if won {
            nextCompletion()
        } else {
            replayCompletion()
        }
    }
    
    @IBAction func menuTapped(_ sender: UIButton) {
        self.view.window?.rootViewController?.dismiss(animated: true)
    }
    
}
