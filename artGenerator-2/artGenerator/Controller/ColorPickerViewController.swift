//
//  ColorPickerViewController.swift
//  artGenerator
//
//  Created by Nathan Freeman on 3/26/24.
//

import SwiftUI

protocol UpdateColorDelegate {
    func updateColors(colors: [UIColor])
}

class ColorPickerViewController: UIViewController, UIColorPickerViewControllerDelegate {
    
    @IBOutlet var colorOptions: [UIButton]!
    
    var selectedButtonTag: Int?
    
    enum ColorButtons: Int {
        case colorOne
        case colorTwo
        case colorThree
    }
    
    var delegate: UpdateColorDelegate?
    
    var items: [UIColor] = [UIColor.red, UIColor.yellow, UIColor.blue]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var index = 0
        for button in colorOptions {
            button.backgroundColor = items[index]
           index += 1
        }
    }
    
    @IBAction func pickColor(_ sender: UIButton) {
        selectedButtonTag = sender.tag
        let colorPicker = UIColorPickerViewController()
        colorPicker.delegate = self
        present(colorPicker, animated: true, completion: nil)
    }
    
    @IBAction func confirmButton(_ sender: UIButton) {
        delegate?.updateColors(colors: items)
        self.dismiss(animated: true)
    }
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        // Get the selected color
        let selectedColor = viewController.selectedColor

        let selectedButton = colorOptions.first(where: { $0.tag == selectedButtonTag })

        selectedButton!.backgroundColor = selectedColor
        items.remove(at: selectedButtonTag!)
        items.insert(selectedColor, at: selectedButtonTag!)
    }
}

