import SpriteKit


class Background: SKSpriteNode {
    
    init(scene: SKScene, location id: Int) {
        let imageName = "background" + String(describing: id)
        let texture = SKTexture(imageNamed: imageName)
        super.init(texture: texture, color: .clear, size: scene.size)
        
        self.position = .zero
        self.zPosition = 0
        
        scene.addChild(self)
        
        let borderImageName = "borders" + String(describing: id)
        let borders = SKSpriteNode(imageNamed: borderImageName)
        borders.position = .zero
        borders.size = scene.size
        borders.zPosition = 1
        
        scene.addChild(borders)

        // PHYSICS BODIES
        
        let sceneHeight = scene.size.height
        let sceneWidth = scene.size.width
        
        let sideSize = CGSize(width: sceneWidth * 0.088,
                              height: sceneHeight)
        
        let left = SKSpriteNode(texture: nil, color: .clear, size: sideSize)
        left.position = CGPoint(x: (-sceneWidth + sideSize.width) / 2,
                                y: 0)
        
        let right = SKSpriteNode(texture: nil, color: .clear, size: sideSize)
        right.position = CGPoint(x: (sceneWidth - sideSize.width) / 2,
                                y: 0)
        
        let size = CGSize(width: sceneWidth,
                          height: sceneHeight * 0.062)
        
        
        let top = SKSpriteNode(texture: nil, color: .clear, size: size)
        top.position = CGPoint(x: 0,
                               y: (sceneHeight - size.height) / 2)
        
        let bottom = SKSpriteNode(texture: nil, color: .clear, size: size)
        bottom.position = CGPoint(x: 0,
                                  y: (-sceneHeight + size.height) / 2 + 5)
        
        [left, right, top, bottom].forEach { border in
            border.physicsBody = SKPhysicsBody(rectangleOf: border.size)
            border.physicsBody?.isDynamic = false
            border.physicsBody?.pinned = true
            border.physicsBody?.allowsRotation = false
            
            border.zPosition = 1
            
            scene.addChild(border)
        }
    
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
