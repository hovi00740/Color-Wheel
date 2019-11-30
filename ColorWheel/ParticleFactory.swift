

import Foundation
import SpriteKit
import GameplayKit

struct ParticleFactory {
    var position: CGPoint?
    var color: UIColor?
    let layer: CGFloat = 2
    let defaultSacle: CGFloat = 1
    let arrayOfParticleColors = ["BlueCircle","GreenCircle","YellowCircle","RedCircle"]
    
    func loadParticle(particle: SKSpriteNode, position: CGPoint){
        particle.position = position
    }
    func createParticle(currentScene: SKScene) -> SKSpriteNode{
        let particle = SKSpriteNode(imageNamed: arrayOfParticleColors[Int.random(in: 0..<4)])
        let randomXStart = random(min: currentScene.size.width * 0.4, max: currentScene.size.width * 0.5)
        let startPoint = CGPoint(x: randomXStart , y: currentScene.size.height * 0.9)
        setParticlePosition(particle: particle, position: startPoint)
        return particle
    }
    
    func setParticlePosition(particle: SKSpriteNode, position: CGPoint){
        particle.position = position
    }
    func moveParticle(endPoint: CGPoint, currentScene: SKScene) -> SKAction{
        return SKAction.move(to: endPoint, duration: 1)
    }
    func rotateParticle(endPoint: CGPoint, particle: SKSpriteNode){
        let distanceBetweenStartAndEndX = endPoint.x - particle.position.x//startPoint.x
        let distanceBetweenStartAndEndY = endPoint.y - particle.position.y
        let amountToRotate = atan2(distanceBetweenStartAndEndY, distanceBetweenStartAndEndX)
        particle.zPosition  = amountToRotate
    }
    
    func generateParticleEndPoint(currentScene: SKScene) -> CGPoint{
        let randomXEnd = random(min: currentScene.size.width * 0.4, max: currentScene.size.width * 0.5)
        let endPoint = CGPoint(x: randomXEnd, y: currentScene.size.height * 0.1)
        return endPoint
    }
    
    func deleteParticle() -> SKAction{
        return SKAction.removeFromParent()
    }
    
    func random() -> CGFloat{
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat{
        return random() * (max - min) + min
    }
    
}

