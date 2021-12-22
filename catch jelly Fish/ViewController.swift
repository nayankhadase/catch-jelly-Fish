//
//  ViewController.swift
//  catch jelly Fish
//
//  Created by Nayan Khadase on 22/12/21.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var play: UIButton!
    @IBOutlet weak var reset: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
   
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        sceneView.debugOptions = [.showFeaturePoints, .showWorldOrigin]
        sceneView.autoenablesDefaultLighting = true
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(getNewJellyFish))
        sceneView.addGestureRecognizer(tapGesture)
        
        
    }
    
    @objc func getNewJellyFish(recognizer: UITapGestureRecognizer){
        
        let tapSceneView = recognizer.view as! SCNView
        let location = recognizer.location(in: tapSceneView)
        let hitResult = tapSceneView.hitTest(location)
        if !hitResult.isEmpty{
            let node = hitResult[0].node
            if node.animationKeys.isEmpty{
                
                self.addAnimation(node: node)
            }
            
        }
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    @IBAction func playBtnPressed(_ sender: UIButton) {
        
        self.addNode()
        sender.isEnabled = false
    }
    
    @IBAction func resetBtnPressed(_ sender: UIButton) {
        
    }
    
    
    func addNode(){
        let scnScene = SCNScene(named: "art.scnassets/Jellyfish.scn")!
        if let scnNode = scnScene.rootNode.childNode(withName: "Sphere", recursively: false){
            scnNode.position = SCNVector3(x: Float(randomNumber(firstNumber: -1, secondNumber: 1)), y: Float(randomNumber(firstNumber: -0.5, secondNumber: 0.5)), z: Float(randomNumber(firstNumber: -1, secondNumber: 1)))
            sceneView.scene.rootNode.addChildNode(scnNode)
        }
    }
    func addAnimation(node: SCNNode){
        let spin = CABasicAnimation(keyPath: "position")
        spin.fromValue = node.presentation.position
        spin.toValue = SCNVector3(x: node.presentation.position.x - 0.2, y: node.presentation.position.y - 0.2, z: node.presentation.position.z - 0.2)
        spin.repeatCount = 9
        spin.duration = 0.05
        spin.autoreverses = true
        node.addAnimation(spin, forKey: "position")
    }
    
    
    // MARK: - ARSCNViewDelegate

}
func randomNumber(firstNumber: CGFloat, secondNumber: CGFloat) -> CGFloat{
    return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNumber - secondNumber) + min(firstNumber, secondNumber)
}
