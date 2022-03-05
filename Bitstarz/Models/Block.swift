import SpriteKit


class Block: SKSpriteNode {
    
    init(scene: SKScene, imageName: String) {
        let texture = SKTexture(imageNamed: imageName)
        
        let width = (scene.size.width - scene.size.width * (195 / 1077)) / 13
        let height = (scene.size.height - scene.size.height * (130 / 872)) / 9
                
        let blockSize = CGSize(width: width, height: height)
        
        super.init(texture: texture, color: .clear, size: blockSize)
        
        zPosition = 2
        
        physicsBody = SKPhysicsBody(rectangleOf: blockSize)
        physicsBody?.allowsRotation = false
        physicsBody?.pinned = true
        physicsBody?.isDynamic = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
