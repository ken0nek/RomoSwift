//
//  ViewController.swift
//  RomoSwift
//
//  Created by Ken Tominaga on 11/8/14.
//  Copyright (c) 2014 Ken Tominaga. All rights reserved.
//

import UIKit

class ViewController: UIViewController, RMCoreDelegate{

    var romo: RMCharacter?
    var robot: RMCoreRobotRomo3?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        romo = RMCharacter.Romo()
        romo?.expression = RMCharacterExpressionCurious
        romo?.emotion = RMCharacterEmotionScared
        romo?.lookAtPoint(RMPoint3D(x: -1.0, y: -1.0, z: 0.5), animated: true)
        
        RMCore.setDelegate(self)
        
        // Iを通常通りに使うことができる
        let con = RMCoreControllerPID()
        con.I = 5
        println(con.I)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        romo?.addToSuperview(self.view)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        romo?.removeFromSuperview()
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let touchLocation = touches.anyObject()?.locationInView(self.view)
        lookAtPoint(touchLocation!)
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        let touchLocation = touches.anyObject()?.locationInView(self.view)
        lookAtPoint(touchLocation!)
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        romo?.lookAtDefault()
        
        let numberOfExpressions: UInt32 = 19
        let numberOfEmotions: UInt32 = 7
        
        let randomExpression = RMCharacterExpression(arc4random_uniform(numberOfExpressions) + 1)
        let randomEmotion = RMCharacterEmotion(arc4random_uniform(numberOfExpressions) + 1)
        
        romo?.setExpression(randomExpression, withEmotion: randomEmotion)
    }
    
    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
        romo?.lookAtDefault()
    }
    
    func lookAtPoint(touchLocation: CGPoint) {
        // Maxiumum distance from the center of the screen = half the width
        let w_2 = self.view.frame.size.width / 2
        
        // Maximum distance from the middle of the screen = half the height
        let h_2 = self.view.frame.size.height / 2
        
        // Ratio of horizontal location from center
        let x = (touchLocation.x - w_2) / w_2
        
        // Ratio of vertical location from middle
        let y = (touchLocation.y - h_2) / h_2
        
        // Since the touches are on Romo's face, they
        let z: CGFloat = 0.0
        
        // Romo expects a 3D point
        // x and y between -1 and 1, z between 0 and 1
        // z controls how far the eyes diverge
        // (z = 0 makes the eyes converge, z = 1 makes the eyes parallel)
        let lookPoint = RMPoint3D(x: x, y: y, z: z)
        
        // Tell Romo to look at the point
        // We don't animate because lookAtTouchLocation: runs at many Hertz
        romo?.lookAtPoint(lookPoint, animated: false)
    }
    
    // MARK: RMCoreDelegate
    
    func robotDidConnect(robot: RMCoreRobot!) {
        if robot.drivable && robot.headTiltable && robot.LEDEquipped {
            self.robot = robot as? RMCoreRobotRomo3
        }
    }
    
    func robotDidDisconnect(robot: RMCoreRobot!) {
        if robot == self.robot {
            self.robot = nil;
        }
    }


}

