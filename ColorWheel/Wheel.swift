//
//  Wheel.swift
//  ColorWheel
//
//  Created by Dwayne Anthony on 12/1/19.
//  Copyright © 2019 Dwayne Anthony. All rights reserved.
//

import Foundation
import UIKit
import GameplayKit

struct Wheel{
    let wheel = SKSpriteNode(imageNamed: "ColorWheel")
    let wheelLayer = 2
    
    func loadWheel(currentScene: SKScene){
        let centeredBelowTheScreen = CGPoint(x: currentScene.size.width/2, y: (currentScene.size.height*0.05 + wheel.size.height))
        wheel.setScale(2)
        wheel.position = centeredBelowTheScreen
        wheel.zPosition = CGFloat(2)
        wheel.physicsBody = SKPhysicsBody(circleOfRadius: wheel.size.height/2)
        wheel.physicsBody!.affectedByGravity = false
        //wheel.physicsBody!.pinned
        //wheel.physicsBody!.angularDamping = 4
        wheel.name = "wheel"
        
        
    }
}
