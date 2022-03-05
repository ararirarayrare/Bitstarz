import SpriteKit

class Door: SKSpriteNode {
    
    init(scene: SKScene) {
        let texture = SKTexture(imageNamed: "door")
        
        let width = (scene.size.width - scene.size.width * (195 / 1077)) / 13
        let height = (scene.size.height - scene.size.height * (110 / 872)) / 10
                
        let blockSize = CGSize(width: width, height: height)
        
        super.init(texture: texture, color: .clear, size: blockSize)
        
        name = "door"
        
        zPosition = 4
        
        physicsBody = SKPhysicsBody(rectangleOf: blockSize)
        physicsBody?.allowsRotation = false
        physicsBody?.pinned = true
        physicsBody?.isDynamic = false
        
        physicsBody?.categoryBitMask = BitMaskCategories.door
        physicsBody?.contactTestBitMask = BitMaskCategories.hero
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
