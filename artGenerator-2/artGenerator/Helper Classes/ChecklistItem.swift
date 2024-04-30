//
//  ChecklistItem.swift
//  artGenerator
//
//  Created by Nathan Freeman on 3/26/24.
//

import Foundation
import SwiftUI

class ChecklistItem: NSObject {
    var text: String
    var image: UIImage?
    
    init(text: String, image: UIImage) {
        self.text = text
        self.image = image
    }
    
    convenience init(text: String) {
        self.init(text: text, image: UIImage(named: "BlankImage")!)
    }
}
