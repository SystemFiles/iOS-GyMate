//
//  SpriteScene.swift
//  GyMate
//
//  Created by Malik Sheharyaar Talhat on 2019-11-29.
//  Copyright © 2019 The Burrito Boys. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

///Used to add animated scene in the background during the exercise
class SpriteScene: SKScene {
    var background = SKSpriteNode(imageNamed: "Background")
    var sceneFrames: [SKTexture]?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func didMove(to view: SKView) {
        background.position = CGPoint(x: frame.size.width/2, y: frame.size.width/3.5)
        background.alpha = 1
        addChild(background)
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(starScene), SKAction.wait(forDuration: 0.2)])))
    }
    override init(size: CGSize) {
        super.init(size: size)
        self.backgroundColor = UIColor.white
        var frames:[SKTexture] = []
        //Path
        let starAtlas = SKTextureAtlas(named: "SceneImages")
        //Interate over the frames
        for index in 0 ... 2 {
            let textureName = "star_\(index)"
            let texture = starAtlas.textureNamed(textureName)
            frames.append(texture)
        }
        //Add frames to the scene
        self.sceneFrames = frames

    }
    //Scene frame attributes
    func starScene() {
        let texture = self.sceneFrames![0]
        let star = SKSpriteNode(texture: texture)
        
        star.size = CGSize(width: 15, height: 15)
        
        let randomBeeYPositionGenerator = GKRandomDistribution(lowestValue: 20, highestValue: Int(self.frame.size.height))
        let yPosition = CGFloat(randomBeeYPositionGenerator.nextInt())
        
        let rightToLeft = arc4random() % 2 == 0
        
        let xPosition = rightToLeft ? self.frame.size.width + star.size.width / 2 : -star.size.width / 2
        
        star.position = CGPoint(x: xPosition, y: yPosition)
        
        if rightToLeft {
            star.xScale = -1
        }
        
        self.addChild(star)
        
        star.run(SKAction.repeatForever(SKAction.animate(with: self.sceneFrames!, timePerFrame: 0.3, resize: false, restore: true)))
        
        var distanceToCover = self.frame.size.width + star.size.width
        
        if rightToLeft {
            distanceToCover *= -1
        }
        
        let time = TimeInterval(abs(distanceToCover / 140))
        
        let moveAction = SKAction.moveBy(x: distanceToCover, y: 0, duration: time)
        
        let removeAction = SKAction.run {
            star.removeAllActions()
            star.removeFromParent()
        }
        
        let allActions = SKAction.sequence([moveAction, removeAction])
        //bee.run(SKAction.sequence([moveAction,removeAction]))
        star.run(allActions)
        
        
        
    }
}
