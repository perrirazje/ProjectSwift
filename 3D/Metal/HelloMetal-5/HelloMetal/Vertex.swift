//
//  Vertex.swift
//  HelloMetal
//
//  Created by Jérémy Perriraz on 04.02.16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import Foundation

struct Vertex{
    
    var x,y,z: Float     // position data
    var r,g,b,a: Float   // color data
    
    func floatBuffer() -> [Float] {
        return [x,y,z,r,g,b,a]
    }
    
};