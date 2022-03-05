import UIKit

class LevelsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var levelLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with level: Int, location id: Int) {
        let key = "levelsOpened" + String(describing: id)
        let levelsOpened = UserDefaults.standard.integer(forKey: key)
        
        guard level <= levelsOpened else {
            levelLabel.text = ""
            imageView.image  = UIImage(named: "locked")
            return
        }
        
        levelLabel.text = String(describing: level)
        imageView.image = UIImage(named: "star")
        
    }

}
