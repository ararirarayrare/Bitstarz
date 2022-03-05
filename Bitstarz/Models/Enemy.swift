import SpriteKit


class Enemy: SKSpriteNode {
    
    init(scene: SKScene) {
        let texture = SKTexture(imageNamed: "Erigth1")
        
        let height = (scene.size.height - scene.size.height * (140 / 872)) / 9
        let size = CGSize(width: height, height: height)
        
        super.init(texture: texture, color: .clear, size: size)
        
        zPosition = 5
        name = "enemy"
        
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.affectedByGravity = false
        physicsBody?.allowsRotation = false
        
        physicsBody?.categoryBitMask = BitMaskCategories.enemy
        physicsBody?.contactTestBitMask = BitMaskCategories.hero
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
