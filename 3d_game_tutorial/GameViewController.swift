//
//  GameViewController.swift
//  3d_game_tutorial
//
//  Created by Alex Stevenson on 11/16/17.
//  Copyright © 2017 Alex Stevenson. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {

    var gameView:SCNView!
    var gameScene:SCNScene!
    var cameraNode:SCNNode!
    var targetCreationTime:TimeInterval = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        initScene()
        initCamera()

    }
    
    func initView() {
        gameView = self.view as! SCNView //casting this to a view so we can work with it
        gameView.allowsCameraControl = true //allows us to manipulate the camera gameView.autoenablesDefaultLighting = true //lights are hard, just set to default
    }

    
    func initScene() {
        gameScene = SCNScene() //initialize the scene
        gameView.scene = gameScene //add game scene to the game view that we initialized above
        gameView.isPlaying = true //automatically start playing/animating instead of being paused
        
        //leave extra line here for later
    }
    
    func initCamera() {
        cameraNode = SCNNode() //initialize the cam
        cameraNode.camera = SCNCamera() //tell it what to treat camera as
        cameraNode.position = SCNVector3(x: 0, y:5, z:10) //position camera in 3d Space
    }


    @objc
    
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

}
