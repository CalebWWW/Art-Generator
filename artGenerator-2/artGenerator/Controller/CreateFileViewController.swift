//
//  CreateFileViewController.swift
//  artGenerator
//
//  Created by Nathan Freeman on 3/26/24.
//

import UIKit

protocol AddItemDelegate {
    func addItemDidCancel()
    func addItemDidAdd(item: ChecklistItem, category: AllItemsList.Category)
    func addItemUpdate(item: ChecklistItem, orig_category: AllItemsList.Category)
}

class CreateFileViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var nameFileField: UITextField!
    
    var freeCanvasModeEnabled = true
    
    var newCategory : AllItemsList.Category?
    
    var delegate: AddItemDelegate?
    
    @IBOutlet weak var sampleImageView: UIImageView!
    
    var preloadedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newCategory = AllItemsList.Category.freeDraw
        preloadedImage = UIImage(named: "BlankImage")
        
        nameFileField.delegate = self
        navigationItem.largeTitleDisplayMode = .never
    }
    
    @IBAction func freeCanvasMode(_ sender: UISwitch) {
        freeCanvasModeEnabled = !freeCanvasModeEnabled
        newCategory = newCategory == AllItemsList.Category.grid
        ?  AllItemsList.Category.freeDraw
        :  AllItemsList.Category.grid
    }
    
    @IBAction func createButton(_ sender: Any) {
        if let itemText = nameFileField.text , let image = preloadedImage {
            let item = ChecklistItem(text: itemText, image: image)
            delegate?.addItemDidAdd(item: item, category: newCategory!)
            dismiss(animated: true)
        }
    }
    
    @IBAction func importImageButton(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            preloadedImage = pickedImage
            sampleImageView.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameFileField.endEditing(true)
        return true
    }
}
