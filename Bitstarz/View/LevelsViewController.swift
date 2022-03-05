import UIKit

class LevelsViewController: BaseVC {
    
    var locationID: Int!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellName = String(describing: LevelsCollectionViewCell.self)
        let cellNib = UINib(nibName: cellName, bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: cellName)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let id = self.locationID else { return }
        let key = "levelsOpened" + String(describing: id)
        let levelsOpened = UserDefaults.standard.integer(forKey: key)
        let indexPath = IndexPath(item: levelsOpened - 1, section: 0)
        
        collectionView.scrollToItem(at: indexPath,
                                    at: [.centeredVertically, .centeredHorizontally] ,
                                    animated: true)
        
    }
    
    
    @IBAction func backTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    

}

extension LevelsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = String(describing: LevelsCollectionViewCell.self)
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? LevelsCollectionViewCell else { return UICollectionViewCell() }
        
        cell.configure(with: indexPath.item + 1, location: locationID)
        
        return cell
    }
}

extension LevelsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset = 110.0
        return UIEdgeInsets(top: inset, left: inset / 2,
                            bottom: inset, right: inset / 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let level = (indexPath.item + 1)
        guard let id = self.locationID else { return }
        let key = "levelsOpened" + String(describing: id)
        let levelsOpened = UserDefaults.standard.integer(forKey: key)
        guard level <= levelsOpened else { return }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let identifier = String(describing: GameViewController.self)
        
        guard let gameViewController = storyboard.instantiateViewController(withIdentifier: identifier) as? GameViewController else { return }
        
        gameViewController.level = level
        gameViewController.locationID = self.locationID
        
        gameViewController.modalPresentationStyle = .custom
        gameViewController.transitioningDelegate = self
        
        present(gameViewController, animated: true)
    }
}

extension LevelsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = collectionView.frame.height - 220
        
        return CGSize(width: height,
                      height: height)
    }
}

