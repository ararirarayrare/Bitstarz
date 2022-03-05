import SpriteKit


class Hero: SKSpriteNode {
    
    
    init(scene: SKScene) {
        let texture = SKTexture(imageNamed: "bottom1")
        
        let height = (scene.size.height - scene.size.height * (180 / 872)) / 9
        let size = CGSize(width: height, height: height)
        
        super.init(texture: texture, color: .clear, size: size)
        
        zPosition = 5
        position = CGPoint(x: scene.size.width / 2 - height * 2.2,
                           y: 0)
        
        physicsBody = SKPhysicsBody(texture: texture, size: size)
        physicsBody?.affectedByGravity = false
        physicsBody?.allowsRotation = false
        
        physicsBody?.categoryBitMask = BitMaskCategories.hero
        physicsBody?.contactTestBitMask = BitMaskCategories.enemy | BitMaskCategories.door
        
        scene.addChild(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
