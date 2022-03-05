import SpriteKit


class Star: SKSpriteNode {
    
    init(scene: SKScene) {
        let texture = SKTexture(imageNamed: "star")
        
        let height = ((scene.size.height - scene.size.height * (100 / 872)) / 9) * 0.75
        let size = CGSize(width: height, height: height)
        
        super.init(texture: texture, color: .clear, size: size)
        
        zPosition = 4
        name = "star"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
