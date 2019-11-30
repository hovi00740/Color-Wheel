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
    
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
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
}
