import UIKit
import SpriteKit
import GameplayKit

class GameViewController: BaseVC {
    
    var locationID: Int!
    
    var scene: GameScene!
    var level: Int!
    
    var stars: Int!
    var starsCollected: Int! {
        didSet {
            guard let starsCollected = starsCollected else { return }
            guard let stars = stars else { return }
            starsCountLabel.text = "\(starsCollected) / \(stars)"
        }
    }
    
    var bombs: Int!
    var bombsLeft: Int! {
        didSet {
            guard let bombsLeft = bombsLeft else { return }
            guard let bombs = bombs else { return }
            bombsCountLabel.text = "\(bombsLeft) / \(bombs)"
        }
    }
    
    var megaBombs: Int!
    var megaBombsLeft: Int! {
        didSet {
            guard let megaBombsLeft = megaBombsLeft else { return }
            guard let megaBombs = megaBombs else { return }
            megaCountLabel.text = "\(megaBombsLeft) / \(megaBombs)"
        }
    }
    
    var bombDropped: Bool = false
    var megaBombDropped: Bool = false
    
    @IBOutlet weak var bombsCountLabel: UILabel!
    @IBOutlet weak var starsCountLabel: UILabel!
    @IBOutlet weak var megaCountLabel: UILabel!
    
    @IBOutlet weak var leftX: NSLayoutConstraint!
    @IBOutlet weak var rigthX: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadGame()
    }
    
    @IBAction func dropMegaBomb(_ sender: UIButton) {
        if megaBombDropped {
            scene.explose(megaBomb: true)
        } else {
            scene.drop(megaBomb: true)
            megaBombsLeft -= 1
        }
        megaBombDropped = !megaBombDropped
    }
    
    @IBAction func dropBomb(_ sender: UIButton) {
        if bombDropped {
            scene.explose(megaBomb: false)
        } else {
            scene.drop(megaBomb: false)
            bombsLeft -= 1
        }
        bombDropped = !bombDropped
    }
    
    @IBAction func moveTop(_ sender: UIButton) {
        scene.move(.top)
    }
    
    @IBAction func moveBottom(_ sender: UIButton) {
        scene.move(.bottom)
    }
    
    @IBAction func moveRigth(_ sender: UIButton) {
        scene.move(.right)
    }
    
    @IBAction func moveLeft(_ sender: UIButton) {
        scene.move(.left)
    }
        
    @IBAction func stopped(_ sender: UIButton) {
        scene.stop()
    }
    

    @IBAction func canceled(_ sender: UIButton) {
        scene.stop()
    }
    
    @IBAction func backTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
        scene = nil
    }
    
    func loadGame() {
        if let view = self.view as! SKView? {
            scene = GameScene()
            
            scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            scene.scaleMode = .resizeFill
            
            scene.gameDelegate = self
            scene.level = self.level
            guard let id = self.locationID else { return }
            scene.locationID = id
            
            view.presentScene(scene)
        }
        configure()
    }
    
    
    func configure() {
        self.bombDropped = false
        self.megaBombDropped = false
        
        let aspectRatio = UIScreen.main.bounds.height / UIScreen.main.bounds.width
        if aspectRatio > 0.5 {
            self.leftX.constant = 69
            self.rigthX.constant = -65
            
            [starsCountLabel, bombsCountLabel, megaCountLabel].forEach { label in
                label?.font = UIFont(name: "Copperplate Bold", size: 14)
            }
        }
    }
    
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.landscapeLeft, .landscapeRight]
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}


extension GameViewController: GameDelegate {
    func gameOver(won: Bool) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let identifier = String(describing: GameOverViewController.self)
        
        guard let gameOverViewController = storyboard.instantiateViewController(withIdentifier: identifier) as? GameOverViewController else { return }
        
        guard let id = self.locationID else { return }
        let key = "levelsOpened" + String(describing: id)
        let levelsOpened = UserDefaults.standard.integer(forKey: key)
        
        if won && level == levelsOpened {
            UserDefaults.standard.set(level + 1, forKey: key)
        }
        
        gameOverViewController.won = won
        gameOverViewController.replayCompletion = loadGame
        
        gameOverViewController.nextCompletion = {
            self.level += 1
            self.loadGame()
        }
        
        gameOverViewController.modalPresentationStyle = .custom
        gameOverViewController.transitioningDelegate = self
        
        present(gameOverViewController, animated: true)
        
    }
    
    func configureTable(bombs: Int, stars: Int, mega: Int) {
        self.bombs = bombs
        self.bombsLeft = bombs
        
        self.stars = stars
        self.starsCollected = 0
        
        self.megaBombs = mega
        self.megaBombsLeft = mega
    }
    
    func collectStar() {
        starsCollected += 1
    }
}
