//
//  Mode.swift
//  PickFalling
//
//  Created by Nathan FALLET on 05/03/2018.
//

import Foundation
import UIKit

class Mode {
    
    var name: String
    var score: Int
    var player: UIImage
    var object: UIImage
    var color: String
    
    init(name: String, score: Int, player: UIImage, object: UIImage) {
        self.name = name
        self.score = score
        self.player = player
        self.object = object
        self.color = "#FFE436"
    }
    
    init(name: String, score: Int, player: UIImage, object: UIImage, color: String) {
        self.name = name
        self.score = score
        self.player = player
        self.object = object
        self.color = color
    }
    
}
