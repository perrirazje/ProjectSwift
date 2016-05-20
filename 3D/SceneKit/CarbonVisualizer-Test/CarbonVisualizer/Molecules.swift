/*
* Copyright (c) 2014 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import Foundation
import SceneKit

class Molecules {
    class func Pyramid() -> SCNGeometry {
        // 1
        let Pyramid = SCNPyramid(width: 5.0, height: 5.0, length: 5.0)
        
        // 2
        Pyramid.firstMaterial!.diffuse.contents = UIColor.darkGrayColor()
        
        // 3
        Pyramid.firstMaterial!.specular.contents = UIColor.whiteColor()
        
        // 4
        return Pyramid
    }
    class func Pyramid2() -> SCNGeometry {
        // 1
        let Pyramid2 = SCNPyramid(width: 5.0, height: 5.0, length: 5.0)
        
        // 2
        Pyramid2.firstMaterial!.diffuse.contents = UIColor.darkGrayColor()
        
        // 3
        Pyramid2.firstMaterial!.specular.contents = UIColor.whiteColor()
        
        // 4
        return Pyramid2
    }
    class func allPyra() -> SCNNode {
        let PyraNode = SCNNode()
        
        let PyramidNode = SCNNode(geometry: Pyramid())
        PyramidNode.position = SCNVector3Make(-5, 0, 0)
        PyraNode.addChildNode(PyramidNode)
        
        let Pyramid2Node = SCNNode(geometry: Pyramid2())
        Pyramid2Node.position = SCNVector3Make(0, 0, 0)
        PyraNode.addChildNode(Pyramid2Node)
        
        return PyraNode
    }

}
