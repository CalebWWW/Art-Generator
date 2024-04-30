//
//  GridViewController.swift
//  artGenerator
//
//  Created by Nathan Freeman on 4/14/24.
//

import UIKit
import SwiftUI

extension UIView {
    func takeScreenshot() -> UIImage {
             // Begin context
          UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
             // Draw view in that context
             drawHierarchy(in: self.bounds, afterScreenUpdates: true)
             // And finally, get image
         let image = UIGraphicsGetImageFromCurrentImageContext()
             UIGraphicsEndImageContext()

             if (image != nil) {
                 return image!
             }
             return UIImage()
         }
}

class GridViewController: UIViewController, UpdateColorDelegate {
    
    @IBOutlet var canvasButtons: [UIButton]!
    
    var savedImage: UIImageView!
    
    func updateColors(colors: [UIColor]) {
        items = colors
        var index = 0
        for button in buttonCollection {
            button.backgroundColor = items[index]
            index += 1
        }
    }
    
    var delegate :AddItemDelegate?
    
    var currentImageView: UIImageView!
    var currentName = ""
    weak var currentItem: ChecklistItem?
    
    var gridMode = 0
    
    @IBOutlet var buttonCollection: [UIButton]!
    
    enum ColorButtons: Int {
        case colorOne
        case colorTwo
        case colorThree
    }
    
    var items: [UIColor] = [UIColor.red, UIColor.yellow, UIColor.blue]
    
    var selectedColor: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentName = currentItem!.text
        savedImage = UIImageView(frame: UIScreen.main.bounds)
        savedImage.image = currentItem!.image!
        savedImage.contentMode = .scaleAspectFill
        view.addSubview(savedImage)
        view.sendSubviewToBack(savedImage)
        
        var index = 0
        for button in buttonCollection {
            button.backgroundColor = items[index]
            index += 1
        }
        
        for button in canvasButtons {
            button.backgroundColor = .clear
        }
        
        selectedColor = items[0]
    }

    @IBAction func canvasClicked(_ sender: UIButton) {
        sender.backgroundColor = selectedColor
    }
    
    @IBAction func Download(_ sender: UIButton) {
        
        guard let view = self.view else {
             return
         }
        for button in canvasButtons {
            button.layer.borderColor = UIColor.clear.cgColor
            button.layer.cornerRadius = 0.0
        }
        let screenshot = view.takeScreenshot()
        if let item = currentItem {
            item.text = currentName
            item.image = screenshot
            delegate?.addItemUpdate(item: item, orig_category: AllItemsList.Category.grid)
        }
        self.dismiss(animated: true)
    
    }
    
    @IBAction func toColorPicker(_ sender: Any) {
        performSegue(withIdentifier: "toColorPickerVC", sender: self)
    }
    
    @IBAction func GridMode(_ sender: UIButton) {
        if gridMode == 0 {
            for button in canvasButtons {
                button.layer.borderWidth = 3.0
                button.layer.borderColor = UIColor.black.cgColor
                button.layer.cornerRadius = 5.0
                gridMode = 1
            }
        } else if gridMode == 1 {
            for button in canvasButtons {
                button.layer.borderWidth = 1.0
                button.layer.borderColor = UIColor.black.cgColor
                button.layer.cornerRadius = 0.0
                gridMode = 2
            }
        } else {
            for button in canvasButtons {
                button.layer.borderColor = UIColor.clear.cgColor
                button.layer.cornerRadius = 0.0
                gridMode = 0
            }
        }
    }
    
    @IBAction func Reset(_ sender: UIButton) {
        for button in canvasButtons {
            button.backgroundColor = .clear
        }
        savedImage.image = UIImage(named: "BlankImage")
    }
    
    @IBAction func goHome(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func colorSelected(_ sender: UIButton) {
            switch sender.tag {
            case ColorButtons.colorOne.rawValue:
                print("color one")
                selectedColor = items[0]
            case ColorButtons.colorTwo.rawValue:
                print("color two")
                selectedColor = items[1]
            case ColorButtons.colorThree.rawValue:
                print("color three")
                selectedColor = items[2]
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
