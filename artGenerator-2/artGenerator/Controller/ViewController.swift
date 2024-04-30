//
//  ViewController.swift
//  artGenerator
//
//  Created by Nathan Freeman on 2/17/24.
//

import UIKit
import SwiftUI

class ViewController: UIViewController, UpdateColorDelegate {
    
    func updateColors(colors: [UIColor]) {
        items = colors
        var index = 0
        for button in buttonCollection {
            button.backgroundColor = items[index]
            index += 1
        }
    }
    
    
    @IBOutlet weak var CanvasView :CanvasView!
    
    var delegate :AddItemDelegate?
    
    var currentImage: UIImage!
    var currentName = ""
    weak var currentItem: ChecklistItem?
    var savedImage: UIImageView!
    
    @IBOutlet var buttonCollection: [UIButton]!
    
    enum ColorButtons: Int {
        case colorOne
        case colorTwo
        case colorThree
    }
    
    var items: [UIColor] = [UIColor.red, UIColor.yellow, UIColor.blue]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentName = currentItem!.text
        savedImage = UIImageView(frame: UIScreen.main.bounds)
        savedImage.image = currentItem!.image!
        savedImage.contentMode = .scaleAspectFill
        view.addSubview(savedImage)
        view.sendSubviewToBack(savedImage)
        if let image = savedImage.image, image != UIImage(named: "BlankImage") {
            // The image in savedImage is not "BlankImage"
            CanvasView.alpha = 0.5
        }
        
        
        var index = 0
        for button in buttonCollection {
            button.backgroundColor = items[index]
            index += 1
        }
    }

    @IBAction func Download(_ sender: UIButton) {
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, false, UIScreen.main.scale)
        self.view.drawHierarchy(in: self.view.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let item = currentItem {
            item.text = currentName
            item.image = image
            delegate?.addItemUpdate(item: item, orig_category: AllItemsList.Category.freeDraw)
        }
        self.dismiss(animated: true)
    }
    
    @IBAction func Undo(_ sender: UIButton) {
        CanvasView.undoDraw()
    }
    
    @IBAction func Reset(_ sender: UIButton) {
        CanvasView.clearCanvasView()
        savedImage.image = UIImage(named: "BlankImage")
    }
    
    @IBAction func goHome(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func OpacitySlider(_ sender: UISlider) {
        CanvasView.strokeOpacity = CGFloat(sender.value)
    }
    
    @IBAction func BrushSizeSlider(_ sender: UISlider) {
        CanvasView.strokeWidth = CGFloat(sender.value)
    }
    
    @IBAction func colorSelected(_ sender: UIButton) {
        switch sender.tag {
        case ColorButtons.colorOne.rawValue:
            print("color one")
            CanvasView.strokeColor = items[0]
        case ColorButtons.colorTwo.rawValue:
            print("color two")
            CanvasView.strokeColor = items[1]
        case ColorButtons.colorThree.rawValue:
            print("color three")
            CanvasView.strokeColor = items[2]
        default:
            print("error has occured")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toColorPickerVC" {
            let destinationVC = segue.destination as! ColorPickerViewController
            destinationVC.items = items
            destinationVC.delegate = self
        }
    }
}
