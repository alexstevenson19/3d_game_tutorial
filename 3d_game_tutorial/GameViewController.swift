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

class GameViewController: UIViewController, SCNSceneRendererDelegate {

    var gameView:SCNView!
    var gameScene:SCNScene!
    var cameraNode:SCNNode!
    var targetCreationTime:TimeInterval = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        initScene()
        initCamera()
//        createTarget()

    }
    
    func initView() {
        gameView = self.view as! SCNView //casting this to a view so we can work with it
        gameView.allowsCameraControl = true //allows us to manipulate the camera gameView.autoenablesDefaultLighting = true //lights are hard, just set to default
        gameView.autoenablesDefaultLighting = true
        gameView.delegate = self
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
        gameScene.rootNode.addChildNode(cameraNode) //using our camera in the scene
    }

    func createTarget() {
        //will use standard objects in SceneKit as targets here
        let geometry:SCNGeometry = SCNPyramid(width: 1, height: 1, length: 1) //make pyramid
        let randomColor = arc4random_uniform(2) == 0 ? UIColor.green : UIColor.red //upper bound of 2 things in the random, if it is equal to 0, choose green, otherwise choose red. Upper bound is basically a maximum in this case
        geometry.materials.first?.diffuse.contents = randomColor
//        geometry.materials.first?.diffuse.contents = UIColor.blue //just like changing button colors
        
        let geometryNode = SCNNode(geometry: geometry) //making a node for it in order to actually make the object, then passing the geometry pyramid as argument to better clarify what we want to make
        
        geometryNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil) //3 types of bodies, the dynamic option is moving and responds to forces. Choosing nil for the shape makes it fit to whatever we defined the createTarget to be.
        
        if randomColor == UIColor.red{
            geometryNode.name = "enemy"
        } else{
            geometryNode.name = "friend"
        }

        gameScene.rootNode.addChildNode(geometryNode)
        
        let randomDirection:Float = arc4random_uniform(2) == 0 ? -1.0 : 1.0 //randomly move left or right
        let force = SCNVector3(x: randomDirection, y: 15, z:0 ) //adding force in 3 dimensions for our 3d pyramid; use random direction constant we just made to make the shapes move left or right
        
        geometryNode.physicsBody?.applyForce(force, at: SCNVector3(x: 0.05,y: 0.05, z:0.05 ), asImpulse: true) //applying force slightly off center for our object
    }

    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if time > targetCreationTime {
            createTarget() //call createTarget func if time greater than targetCreationTime var we made
            targetCreationTime = time + 0.6 //operation to differentiate/update time and target time
        }
        
        cleanUp()
    }

    func cleanUp () {
        for node in gameScene.rootNode.childNodes {
            if node.presentation.position.y < -2 {
                node.removeFromParentNode() //basically when an object falls below a point it deletes
            }
        }
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
