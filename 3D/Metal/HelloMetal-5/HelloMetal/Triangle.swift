import Foundation
import Metal

class Triangle: Node {
    
    init(device: MTLDevice){
        
        let A = Vertex(x:  0.0, y:   0.75, z:   0.25, r:  1.0, g:  0.0, b:  0.0, a:  1.0)
        let B = Vertex(x: -1.0, y:  -1.0, z:   1.0, r:  0.0, g:  1.0, b:  0.0, a:  1.0)
        let C = Vertex(x:  1.0, y:  -1.0, z:   1.0, r:  0.0, g:  0.0, b:  1.0, a:  1.0)
        let S = Vertex(x:  -1.0, y:  -1.0, z:   -1.0, r:  0.0, g:  1.0, b:  0.0, a:  1.0)
        let T = Vertex(x:  1.0, y:  -1.0, z:   -1.0, r:  0.0, g:  0.0, b:  1.0, a:  1.0)
        
        var verticesArray:Array<Vertex> = [
            B,A,C ,S,A,T,
            S,A,B ,T,A,C,
            B,C,T ,B,T,S
            
        ]
        super.init(name: "Triangle", vertices: verticesArray, device: device)
    }
}