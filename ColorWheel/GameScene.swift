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
    
    
    override func didMove(to view: SKView) {
        wheelFactory.loadWheel(currentScene: self)
        self.physicsWorld.contactDelegate = self
        self.addChild(wheelFactory.wheel)
        startNewLevel()
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
        let particleEndPoint = particleFactory.generateParticleEndPoint(currentScene: self)
        let particleSequence = SKAction.sequence([particleFactory.moveParticle(endPoint: particleEndPoint, currentScene: self),particleFactory.deleteParticle()])
        particle.run(particleSequence)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in:self)
            let node = atPoint(location)
            if node.name == "wheel" {
                let dx = location.x - node.position.x
                let dy = location.y - node.position.y
                // Store angle and current time
                startingAngle = atan2(dy, dx)
                startingTime = touch.timestamp
                node.physicsBody?.angularVelocity = 0
            }
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in:self)
            let node = atPoint(location)
            if node.name == "wheel" {
                let dx = location.x - node.position.x
                let dy = location.y - node.position.y


                let angle = atan2(dy, dx)
                guard startingAngle != nil else {return}
                // Calculate angular velocity; handle wrap at pi/-pi
                var deltaAngle = angle - startingAngle!
                if abs(deltaAngle) > CGFloat.pi {
                    if (deltaAngle > 0) {
                        deltaAngle = deltaAngle - CGFloat.pi //* 2
                    }
                    else {
                        deltaAngle = deltaAngle + CGFloat.pi //* 2
                    }
                }
                let dt = CGFloat(touch.timestamp - startingTime!)
                let velocity = deltaAngle / dt

                node.physicsBody?.angularVelocity = velocity

                startingAngle = angle
                print(angle)
                if(angle > 0 && angle < CGFloat(Float.pi/2)){
                    print("RED")
                }
                else if(angle > CGFloat(Float.pi/2) && angle < CGFloat(Float.pi)){
                    print("GREEN")
                }
                else if(angle > CGFloat(Float.pi) && angle < CGFloat(Float.pi*1.5)){
                    print("BLUE")
                }
                else if(angle > CGFloat(Float.pi*1.5) && angle < CGFloat(Float.pi*2)){
                    print("YELLOW")
                }
                startingTime = touch.timestamp
            }
        }
    }



    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

        //startingAngle = nil
        //startingTime = nil
    }
}
