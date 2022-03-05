import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var gameDelegate: GameDelegate!
    
    var level: Int!
    var locationID: Int!
    
    var hero: Hero!
    var direction: Direction = .bottom
    var bomb: Bomb!
    var megaBomb: Bomb!
        
    var bombsCount = 5
    var enemies = 0
    var stars = 0
    var starsCollected = 0
    var megaBombAvailable: Bool = true
    
    var gameStarted: Bool = false

    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        physicsWorld.contactDelegate = self
        
        let _ = Background(scene: self, location: locationID)
        
        spawnBlocks()
        spawnBricks()
        moveEnemies()
        
        gameDelegate.configureTable(bombs: bombsCount, stars: stars, mega: 1)
        gameStarted = true
    }
    
    override func update(_ currentTime: TimeInterval) {
        let xZone = (hero.position.x - hero.size.width)...(hero.position.x + hero.size.width)
        let yZone = (hero.position.y - hero.size.height)...(hero.position.y + hero.size.height)
        
        enumerateChildNodes(withName: "star") { node , _ in
            if xZone.contains(node.position.x) && yZone.contains(node.position.y) {
                node.removeFromParent()
                self.starsCollected += 1
                self.gameDelegate.collectStar()
            }
        }
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        let enemyContactedHero = (bodyA.categoryBitMask == BitMaskCategories.enemy && bodyB.categoryBitMask == BitMaskCategories.hero) || (bodyB.categoryBitMask == BitMaskCategories.enemy && bodyA.categoryBitMask == BitMaskCategories.hero)
        
        let finished = (bodyA.categoryBitMask == BitMaskCategories.door && bodyB.categoryBitMask == BitMaskCategories.hero) || (bodyB.categoryBitMask == BitMaskCategories.door && bodyA.categoryBitMask == BitMaskCategories.hero)
        
        if finished && starsCollected == stars {
            enumerateChildNodes(withName: "enemy") { node, _ in
                node.isPaused = true
            }
            moveIntoDoor()
        }
        
        if enemyContactedHero {
            self.isPaused = true
            gameDelegate.gameOver(won: false)
        }
    }
    
    func moveIntoDoor() {
        var position = CGPoint()
        enumerateChildNodes(withName: "door") { node, _ in
            guard let door = node as? SKSpriteNode else { return }
            position = door.position
            door.texture = SKTexture(imageNamed: "openDoor")
        }
        
        hero.removeAction(forKey: "move")
        self.hero.physicsBody = nil
        gameStarted = false
        
        var array: [SKTexture] = []
        for i in 1...7 {
            let name = "left" + String(describing: i)
            array.append(.init(imageNamed: name))
        }
        
        let distance = hero.size.width

        let moveLeft = SKAction.moveBy(x: -distance / 7, y: 0, duration: 1/7)
        
        let block = SKAction.run {
            let texture = array.removeFirst()
            self.hero.texture = texture
        }
                
        let moveGroup = SKAction.group([moveLeft, block])
        let repeatGroup = SKAction.repeat(moveGroup, count: 7)
                        
        let fadeOut = SKAction.fadeOut(withDuration: 0.75)
        let group = SKAction.group([repeatGroup, fadeOut])
        
        self.hero.run(group) {
            self.gameDelegate.gameOver(won: true)
        }
    }
    
    
    func spawnBlocks() {
        var horizontalSpace = -(size.width / 2)
        guard let id = self.locationID else { return }
        let imageName = "block" + String(describing: id)
        
        for _ in 1...6 {
            let block = Block(scene: self, imageName: imageName)
            var verticalSpace = (size.height / 2 - (block.size.height * 2 + 9))
            
            horizontalSpace += (block.size.width * 2)
            
            block.position = CGPoint(x: horizontalSpace + block.size.width,
                                     y: verticalSpace)
            
            block.name = "block"
            addChild(block)
                        
            for _ in 2...4 {
                let block = Block(scene: self, imageName: imageName)
                
                verticalSpace -= (block.size.height * 2)
                
                block.position = CGPoint(x: horizontalSpace + block.size.width,
                                         y: verticalSpace)
                
                block.name = "block"
                addChild(block)
            }
        }
    }
    
    func spawnBricks() {
        guard let id = self.locationID else { return }
        let imageName = "brick" + String(describing: id)
        
        for line in 1...9 {
            var horizontalSpace = -(size.width / 2)
            
            var rows = 13
            
            if line % 2 == 0 {
                rows = 7
            }

            for _ in 1...rows {
                let brick = Block(scene: self, imageName: imageName)
                
                var multiplier = CGFloat(Int.random(in: 1...3))
                
                if line %  2 == 0 {
                    multiplier = 2
                }
                
                let verticalSpace = (size.height / 2) - (brick.size.height * CGFloat(line) + 9)
                
                brick.position = CGPoint(x: horizontalSpace + (brick.size.width * 2),
                                         y: verticalSpace )
                
                horizontalSpace += (brick.size.width * multiplier)
                
                let x = brick.position.x
                let spawnLines = 3...7
                
                let width = brick.size.width
                
                let outX = x > ((size.width / 2) - width)
                let inSpawnZone = x > ((size.width / 2) - width * 3) && spawnLines.contains(line)
                
                if !outX && !inSpawnZone {
                    self.spawn(on: brick)
                }

                if line == 5 && hero == nil {
                    self.hero = Hero(scene: self)
                    hero.position.y = verticalSpace
                    
                    let door = Door(scene: self)
                    door.position = CGPoint(x: -(size.width / 2) + (brick.size.width),
                                            y: verticalSpace)
                    
                    addChild(door)
                }
                
            }
        }
        
    }
    
    func spawn(on brick: Block) {
        guard let level = level else { return }
        var range = 3
        
        switch level {
        case 1...4:
            range = 3
        case 5...8:
            range = 4
        case 9...12:
            range = 5
        default:
            break
        }
        
        if Int.random(in: 1...range) != 1 {
            brick.name = "brick"
            addChild(brick)
        } else {
            if Bool.random()  && enemies < 5 {
                let enemy = Enemy(scene: self)
                enemy.position = brick.position
                addChild(enemy)
                enemies += 1
            } else if Int.random(in: 1...3) != 1 && stars < 3 {
                let star = Star(scene: self)
                star.position = brick.position
                addChild(star)
                stars += 1
            }
        }
    }
    
    
    func move(_ direction: Direction) {
        guard gameStarted else { return }
        var x: CGFloat = 0
        var y: CGFloat = 0
        
        var array: [SKTexture] = []
        for i in 1...10 {
            let name = String(describing: direction) + String(describing: i)
            array.append(.init(imageNamed: name))
        }
        
        switch direction {
        case .top:
            y = 10
        case .bottom:
            y = -10
        case .left:
            x = -10
        case .right:
            x = 10
        }
        
        let move = SKAction.moveBy(x: x, y: y, duration: 0.1)
        let block = SKAction.run {
            let texture = array.removeFirst()
            array.append(texture)
            self.hero.texture = texture
        }
        
        let group = SKAction.group([move, block])
        
        hero.run(.repeatForever(group), withKey: "move")
        self.direction = direction
    }
    
    func stop() {
        hero.removeAction(forKey: "move")
        let name = String(describing: direction) + "1"
        hero.texture = .init(imageNamed: name)
    }
    
    
    func moveEnemies() {
        enumerateChildNodes(withName: "enemy") { enemy, _ in
            guard let enemy = enemy as? Enemy else { return }
            
            switch Int.random(in: 1...4) {
            case 1:
                self.moveRigth(node: enemy)
            case 2:
                self.moveLeft(node: enemy)
            case 3:
                self.moveTop(node: enemy)
            case 4:
                self.moveBottom(node: enemy)
            default:
                self.moveLeft(node: enemy)
            }
           
            
        }
        
    }
    
    func moveRigth(node: Enemy) {
        let x = node.position.x
        let distance = node.size.width * 1.5
                
        var array: [SKTexture] = []
        for i in 1...12 {
            let name = "Erigth" + String(describing: i)
            array.append(.init(imageNamed: name))
        }
        
        let moveRigth = SKAction.moveBy(x: distance / 12, y: 0, duration: 0.1)
        
        let block = SKAction.run {
            let texture = array.removeFirst()
            node.texture = texture
        }
        
        let group = SKAction.group([moveRigth, block])
        let repeatGroup = SKAction.repeat(group, count: 12)
        
        node.run(repeatGroup) {
            let passed = node.position.x - x
            
            if passed < distance {
                if Bool.random() {
                    self.moveBottom(node: node)
                } else {
                    self.moveTop(node: node)
                }
            } else {
                if Bool.random() {
                    self.moveLeft(node: node)
                } else {
                    self.moveRigth(node: node)
                }
            }
        }
    }
    
    
    func moveLeft(node: Enemy) {
        let x = node.position.x
        let distance = node.size.width * 1.5
                
        var array: [SKTexture] = []
        for i in 1...12 {
            let name = "Eleft" + String(describing: i)
            array.append(.init(imageNamed: name))
        }

        let moveLeft = SKAction.moveBy(x: -distance / 12, y: 0, duration: 0.1)
        
        let block = SKAction.run {
            let texture = array.removeFirst()
            node.texture = texture
        }
                
        let group = SKAction.group([moveLeft, block])
        let repeatGroup = SKAction.repeat(group, count: 12)
        
        
        node.run(repeatGroup) {
            let passed = x - node.position.x
            
            if passed < distance {
                if Bool.random() {
                    self.moveTop(node: node)
                } else {
                    self.moveBottom(node: node)
                }
            } else {
                if Bool.random() {
                    self.moveRigth(node: node)
                } else {
                    self.moveLeft(node: node)
                }
            }
        }
    }
    
    
    func moveTop(node: Enemy) {
        let y = node.position.y
        let distance = node.size.width * 1.5
        
        var array: [SKTexture] = []
        for i in 1...9 {
            let name = "Etop" + String(describing: i)
            array.append(.init(imageNamed: name))
        }
        
        let moveTop = SKAction.moveBy(x: 0, y: distance / 9, duration: 0.1)
        
        let block = SKAction.run {
            let texture = array.removeFirst()
            node.texture = texture
        }
                
        let group = SKAction.group([moveTop, block])
        let repeatGroup = SKAction.repeat(group, count: 9)
        
        node.run(repeatGroup) {
            let passed = node.position.y - y
            
            if passed < distance {
                if Bool.random() {
                    self.moveRigth(node: node)
                } else {
                    self.moveLeft(node: node)
                }
            } else {
                if Bool.random() {
                    self.moveBottom(node: node)
                } else {
                    self.moveLeft(node: node)
                }
            }
        }
    }
    
    
    func moveBottom(node: Enemy) {
        let y = node.position.y
        let distance = node.size.width * 1.5
        
        var array: [SKTexture] = []
        for i in 1...9 {
            let name = "Ebottom" + String(describing: i)
            array.append(.init(imageNamed: name))
        }
        
        let moveBottom = SKAction.moveBy(x: 0, y: -distance / 9, duration: 0.1)
        
        let block = SKAction.run {
            let texture = array.removeFirst()
            node.texture = texture
        }
        
        let group = SKAction.group([moveBottom, block])
        let repeatGroup = SKAction.repeat(group, count: 9)
        
        node.run(repeatGroup) {
            let passed = y - node.position.y
            
            if passed < distance {
                if Bool.random() {
                    self.moveLeft(node: node)
                } else {
                    self.moveRigth(node: node)
                }
            } else {
                if Bool.random() {
                    self.moveTop(node: node)
                } else {
                    self.moveBottom(node: node)
                }
            }
        }
    }
    
    func drop(megaBomb: Bool) {
        let bomb = Bomb(scene: self)
        bomb.position = hero.position
        
        if megaBomb {
            guard megaBombAvailable else { return }
            megaBombAvailable = false
            bomb.texture = SKTexture(imageNamed: "mega")
            self.megaBomb = bomb
        } else {
            guard bombsCount > 0 else { return }
            bombsCount -= 1
            self.bomb = bomb
        }
        
        addChild(bomb)
    }
    
    func explose(megaBomb: Bool) {
        guard let fire = SKEmitterNode(fileNamed: "Fire") else { return }
        
        var bomb: Bomb!
        
        if megaBomb {
            guard let megaBomb = self.megaBomb else { return }
            bomb = megaBomb
        }  else {
            guard let selfBomb = self.bomb else { return }
            bomb = selfBomb
        }
        var multiplier = 1.8
        
        fire.position = bomb.position
        fire.zPosition = 10
        fire.particleScale = 1.25
        if megaBomb {
            fire.particleScale = 1.75
            multiplier = 2.5
        }
        
        let fadeOut = SKAction.fadeOut(withDuration: 0.3)
        
        let block = SKAction.run {
            self.addChild(fire)
        }
        
        let sound = SKAction.playSoundFileNamed("boom", waitForCompletion: true)
        
        let group = SKAction.group([block, sound])
        
        
        let xZone = (bomb.position.x - bomb.size.width * multiplier)...(bomb.position.x + bomb.size.width * multiplier)
        let yZone = (bomb.position.y - bomb.size.height * multiplier)...(bomb.position.y + bomb.size.height * multiplier)
        
        self.enumerateChildNodes(withName: "brick") { node, _ in
            if xZone.contains(node.position.x) && yZone.contains(node.position.y) {
                node.removeFromParent()
            }
        }
        
        self.enumerateChildNodes(withName: "enemy") { node, _ in
            if xZone.contains(node.position.x) && yZone.contains(node.position.y) {
                node.removeFromParent()
            }
        }
        
        if xZone.contains(hero.position.x) && yZone.contains(hero.position.y) {
            self.gameDelegate.gameOver(won: false)
        }
        
        bomb.run(group) {
            bomb.removeFromParent()
            fire.run(fadeOut) {
                fire.removeFromParent()
            }
        }
    }
    
    
}

