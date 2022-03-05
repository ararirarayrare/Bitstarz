import SpriteKit


class Bomb: SKSpriteNode {
    
    init(scene: SKScene) {
        
        let texture = SKTexture(imageNamed: "bomb")
        
        let height = (scene.size.height - scene.size.height * (200 / 872)) / 9
        let size = CGSize(width: height, height: height)
        
        super.init(texture: texture, color: .clear, size: size)
        
        zPosition = 4
        name = "bomb"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
