//
//  GameScene.swift
//  Color Wheel
//
//  Created by Dwayne Anthony on 11/30/19.
//  Copyright © 2019 Dwayne Anthony. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var particleFactory = ParticleFactory()
    let wheelFactory = Wheel()
    var startingAngle:CGFloat?
    var startingTime:TimeInterval?
    let colors = [SKColor.yellow, SKColor.red, SKColor.blue, SKColor.purple]
    var gameScore = 0;
    var numberOfLives = 3;
    var path = UIBezierPath()
    let circleFactory = CircleFactory()
    let scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
    let numberOfLivesLabel = SKLabelNode(fontNamed: "Chalkduster")
    var circle:SKNode?
    
    enum gameState {
        case preGame
        case inGame
        case afterGame
    }
    
    
    
    
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        startNewLevel()
        
        circle = circleFactory.createCircle(numberOfSections: 4)
        circle!.position = CGPoint(x: self.size.width/2, y: self.size.height*0.2)
        circle!.name = "circle"
        circle!.zPosition = 100
        self.addChild(circle!)
        let offsetCircle = SKAction.rotate(byAngle: 0.5 * CGFloat(Double.pi/2), duration: 0)
        circle!.run(offsetCircle)
        
        let ledge = SKNode()
        ledge.position = CGPoint(x: self.size.width/2, y: 180)
        let ledgeBody = SKPhysicsBody(rectangleOf: CGSize(width: 200, height: 10))
        ledgeBody.isDynamic = false
        ledgeBody.categoryBitMask = PhysicsCategory.Quardant
        ledge.physicsBody = ledgeBody
        addChild(ledge)
        
        scoreLabel.text = "Score: \(gameScore)"
        scoreLabel.fontSize = CGFloat(45)
        scoreLabel.fontColor = SKColor.white
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreLabel.position = CGPoint(x: self.size.width*0.15, y: self.size.height*0.9)
        scoreLabel.zPosition = 5
        self.addChild(scoreLabel)
        
        numberOfLivesLabel.text = "Lives: \(numberOfLives)"
        numberOfLivesLabel.fontSize = CGFloat(45)
        numberOfLivesLabel.fontColor = SKColor.white
        numberOfLivesLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        numberOfLivesLabel.position = CGPoint(x: self.size.width*0.85, y: self.size.height*0.9)
        numberOfLivesLabel.zPosition = 5
        self.addChild(numberOfLivesLabel)
    }
    
    
    func createQuadrant() -> UIBezierPath{
        // 1
        let path = UIBezierPath()
        // 2
        path.move(to: CGPoint(x: 0, y: -200))
        // 3
        path.addLine(to: CGPoint(x: 0, y: 0))
        // 4
        path.addArc(withCenter: CGPoint.zero,
                    radius: 0,
                    startAngle: CGFloat(3.0 * Double.pi/2),
                    endAngle: CGFloat(0),
                    clockwise: true)
        // 5
        path.addLine(to: CGPoint(x: 200, y: 0))
        path.addArc(withCenter: CGPoint.zero,
                    radius: 200,
                    startAngle: CGFloat(0.0),
                    endAngle: CGFloat(3.0 * Double.pi/2),
                    clockwise: false)
        return path
    }
    func createColoredCircle(_ path: UIBezierPath, clockwise: Bool) -> SKNode {
        let circle = SKNode()
        circle.name = "circle"
        
        var rotationFactor = CGFloat(Double.pi/2)
        if !clockwise {
            rotationFactor *= -1
        }
        
        for i in 0...3 {
            let section = SKShapeNode(path: path.cgPath)
            section.fillColor = colors[i]
            section.strokeColor = colors[i]
            section.zRotation = rotationFactor * CGFloat(i);
            let sectionBody = SKPhysicsBody(polygonFrom: path.cgPath)
            sectionBody.categoryBitMask = PhysicsCategory.Cirlce
            sectionBody.collisionBitMask = 0
            sectionBody.contactTestBitMask = PhysicsCategory.Particle
            sectionBody.affectedByGravity = false
            section.physicsBody = sectionBody
            
            circle.addChild(section)
        }
        return circle
    }
    
    
    func dieAndRestart(){
        print("Boom!")
        removeFromParent()
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if let nodeA = contact.bodyA.node as? SKShapeNode, let nodeB = contact.bodyB.node as? SKShapeNode {
            if nodeA.fillColor != nodeB.fillColor {
                numberOfLives -= 1
                nodeB.removeFromParent()
            }
            else if nodeA.fillColor == nodeB.fillColor {
                nodeB.removeFromParent()
                gameScore += 1
            }
            scoreLabel.text = "Score: \(gameScore)"
            if(numberOfLives >= 0){
               numberOfLivesLabel.text = "Lives: \(numberOfLives)"
            }
            
        }
    }
    
    func startNewLevel(){
        if self.action(forKey: "spawningParticles") != nil{
            self.removeAction(forKey: "spawningParticles")
        }
        let spawn = SKAction.run(spawnParticle)
        let waitToSpawn = SKAction.wait(forDuration: 2)
        let spawnSequence = SKAction.sequence([waitToSpawn,spawn])
        let spawnForever = SKAction.repeatForever(spawnSequence)
        self.run(spawnForever,withKey: "spawningParticles")
    }
    func spawnParticle(){
        let particle = particleFactory.createParticle(currentScene: self)
        self.addChild(particle)
        let particleBody = SKPhysicsBody(circleOfRadius: 10)
        particleBody.categoryBitMask = PhysicsCategory.Particle
        particleBody.collisionBitMask = 4
        particle.physicsBody = particleBody
        
        let particleEndPoint = particleFactory.generateParticleEndPoint(currentScene: self)
        let particleSequence = SKAction.sequence([particleFactory.moveParticle(endPoint: particleEndPoint, currentScene: self),particleFactory.deleteParticle()])
        particle.run(particleSequence)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Here! Touched")
        let rotateAction = SKAction.rotate(byAngle: 1.0 * CGFloat(Double.pi/2), duration: 0.2)
        circle!.run(rotateAction)
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let rotateAction = SKAction.rotate(byAngle: 1.0 * CGFloat(Double.pi/2), duration: 0.2)
//        circle.run(rotateAction)
    }
    
    
}
