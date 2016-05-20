//
//  ViewController.swift
//  HelloMetal
//
//  Created by Main Account on 10/2/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import UIKit
import Metal
import QuartzCore

class ViewController: UIViewController {
    
    var device: MTLDevice! = nil
    var metalLayer: CAMetalLayer! = nil
    var objectToDraw: Cube!
    var cube2: Cube!
    var pipelineState: MTLRenderPipelineState! = nil
    var commandQueue: MTLCommandQueue! = nil
    var timer: CADisplayLink! = nil
    var projectionMatrix: Matrix4!
    var lastFrameTimestamp: CFTimeInterval = 0.0
    let panSensivity:Float = 5.0
    var lastPanLocation: CGPoint!
    var Control: Bool = true
    var AxeZ: Float = -6.0
    
    
    let vertexData:[Float] = [
        0.0, 1.0, 0.0,
        -1.0, -1.0, 0.0,
        1.0, -1.0, 0.0]
    
    override func viewDidLoad() {
        projectionMatrix = Matrix4.makePerspectiveViewAngle(Matrix4.degreesToRad(85.0), aspectRatio: Float(self.view.bounds.size.width / self.view.bounds.size.height), nearZ: 0.01, farZ: 100.0)
        super.viewDidLoad()
        device = MTLCreateSystemDefaultDevice()
        metalLayer = CAMetalLayer()          // 1
        metalLayer.device = device           // 2
        metalLayer.pixelFormat = .BGRA8Unorm // 3
        metalLayer.framebufferOnly = true    // 4
        metalLayer.frame = view.layer.frame  // 5
        view.layer.addSublayer(metalLayer)   // 6
        
        objectToDraw = Cube(device: device)
        cube2 = Cube(device: device)
        
        commandQueue = device.newCommandQueue()
        
        // 1
        let defaultLibrary = device.newDefaultLibrary()
        let fragmentProgram = defaultLibrary!.newFunctionWithName("basic_fragment")
        let vertexProgram = defaultLibrary!.newFunctionWithName("basic_vertex")
        
        // 2
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.vertexFunction = vertexProgram
        pipelineStateDescriptor.fragmentFunction = fragmentProgram
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .BGRA8Unorm
        
        // 3
        
        do {
            pipelineState = try device.newRenderPipelineStateWithDescriptor(pipelineStateDescriptor)
        } catch {
            print("error with device.newRenderPipelineStateWithDescriptor")
        }
        
        timer = CADisplayLink(target: self, selector: Selector("newFrame:"))
        timer.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
        
        self.view.multipleTouchEnabled = true
        
        setupDoubleTapped()
        
        setupDoubleTouches()
        
        setupGestures()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func render() {
        let drawable = metalLayer.nextDrawable()
        var worldModelMatrix = Matrix4()
        worldModelMatrix.translate(0.0, y: 0.0, z: AxeZ)
        worldModelMatrix.rotateAroundX(Matrix4.degreesToRad(0), y: 0.0, z: 0.0)
        
        cube2.positionX += -5.0
        
        cube2.render(commandQueue, pipelineState: pipelineState, drawable: drawable!, parentModelViewMatrix: worldModelMatrix, projectionMatrix: projectionMatrix ,clearColor: nil)
        
        objectToDraw.render(commandQueue, pipelineState: pipelineState, drawable: drawable!, parentModelViewMatrix: worldModelMatrix, projectionMatrix: projectionMatrix ,clearColor: nil)
    }
    
    // 1
    func newFrame(displayLink: CADisplayLink){
        
        if lastFrameTimestamp == 0.0
        {
            lastFrameTimestamp = displayLink.timestamp
        }
        
        // 2
        var elapsed:CFTimeInterval = displayLink.timestamp - lastFrameTimestamp
        lastFrameTimestamp = displayLink.timestamp
        
        // 3
        gameloop(elapsed)
    }
    
    func gameloop(timeSinceLastUpdate: CFTimeInterval) {
        
        // 4
        objectToDraw.updateWithDelta(timeSinceLastUpdate)
        
        // 5
        autoreleasepool {
            self.render()
        }
    }
    
    //MARK: - Gesture related
    // 1
    func setupGestures(){
        var pan = UIPanGestureRecognizer(target: self, action: Selector("pan:"))
        self.view.addGestureRecognizer(pan)
    }
    
    // 2
    func pan(panGesture: UIPanGestureRecognizer){
        if panGesture.state == UIGestureRecognizerState.Changed{
            var tap = UITapGestureRecognizer.self
            
            var pointInView = panGesture.locationInView(self.view)
            // 3
            var xDelta = Float((lastPanLocation.x - pointInView.x)/self.view.bounds.width) * panSensivity
            var yDelta = Float((lastPanLocation.y - pointInView.y)/self.view.bounds.height) * panSensivity
            // 4
            objectToDraw.positionX -= xDelta
            objectToDraw.positionY += yDelta

            //objectToDraw.scale -= xDelta
            lastPanLocation = pointInView
            panGesture.maximumNumberOfTouches = 1
        } else if panGesture.state == UIGestureRecognizerState.Began{
            lastPanLocation = panGesture.locationInView(self.view)
        } 
    }
    
    func setupDoubleTapped() {
        let tap = UITapGestureRecognizer(target: self, action: "doubleTapped")
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
    }
    
    func doubleTapped() {
        if (Control == true){
            Control = false
            AxeZ = -3.0
            
        } else if(Control == false){
            Control = true
            AxeZ = -6.0
        }
    }
    
    func setupDoubleTouches() {
        var pan = UIPanGestureRecognizer(target: self, action: Selector("DoubleTouches:"))
        self.view.addGestureRecognizer(pan)
    }
    
    func DoubleTouches(PanGesture: UIPanGestureRecognizer){
                    PanGesture.minimumNumberOfTouches = 2
        if PanGesture.state == UIGestureRecognizerState.Changed{
            var tap = UITapGestureRecognizer.self
            
            var pointInView = PanGesture.locationInView(self.view)
            // 3
            var xDelta = Float((lastPanLocation.x - pointInView.x)/self.view.bounds.width) * panSensivity
            var yDelta = Float((lastPanLocation.y - pointInView.y)/self.view.bounds.height) * panSensivity
            // 4
            objectToDraw.rotationX -= yDelta
            objectToDraw.rotationY -= xDelta
            lastPanLocation = pointInView
        } else if PanGesture.state == UIGestureRecognizerState.Began{
            lastPanLocation = PanGesture.locationInView(self.view)
        }
    }
    
}