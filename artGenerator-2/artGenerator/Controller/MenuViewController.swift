//
//  MenuViewController.swift
//  artGenerator
//
//  Created by Nathan Freeman on 3/26/24.
//

import UIKit
import MessageUI

class MenuViewController: UITableViewController, AddItemDelegate, MFMailComposeViewControllerDelegate {
    
    
        func addItemDidAdd(item: ChecklistItem, category: AllItemsList.Category) {
            let rowIndex = allItems.getCorrectList(category: category).count
            allItems.addItem(item: item, category: category)
            switch category {
                case .grid:
                    let indexPath = IndexPath(row: rowIndex, section: AllItemsList.Category.grid.rawValue)
                    let indexPaths = [indexPath]
                    tableView.insertRows(at: indexPaths, with: .automatic)
                default:
                    let indexPath = IndexPath(row: rowIndex, section: AllItemsList.Category.freeDraw.rawValue)
                    let indexPaths = [indexPath]
                    tableView.insertRows(at: indexPaths, with: .automatic)
                }
            }
    
    
    func addItemUpdate(item: ChecklistItem, orig_category: AllItemsList.Category) {
            for category in AllItemsList.Category.allCases {
                let items = allItems.getCorrectList(category: category)
                if let rowIndex = items.firstIndex(of: item) {
                    let indexPath = IndexPath(row: rowIndex, section: category.rawValue)
                    let rowToDelete = indexPath.row > items.count - 1 ? items.count - 1 : indexPath.row
                    allItems.remove(item: item, category: category, index: rowToDelete)
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                    if let cell = tableView.cellForRow(at: indexPath) {
                        setLabel(cell: cell as! ImageTableViewCell, item: item)
                    }
                }
            }
            addItemDidAdd(item: item, category: orig_category)
            updateEntireList()
        }
    
        func addItemDidCancel() {
            navigationController?.popViewController(animated: true)
        }
        
        var allItems = AllItemsList()
    
        @IBOutlet weak var deleteButton: UIBarButtonItem!
    
        
        override func viewDidLoad() {
            super.viewDidLoad()
            deleteButton.isHidden = true
            
            navigationController?.navigationBar.prefersLargeTitles = true
            
            navigationItem.leftBarButtonItem = editButtonItem
            tableView.allowsMultipleSelectionDuringEditing = true
            
        }
        
        override func numberOfSections(in tableView: UITableView) -> Int {
            return AllItemsList.Category.allCases.count
        }
        
        override func setEditing(_ editing: Bool, animated: Bool) {
            super.setEditing(editing, animated: true)
            deleteButton.isHidden = false
            tableView.setEditing(tableView.isEditing, animated: true)
        }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddItemVC" {
            let destinationVC = segue.destination as! CreateFileViewController
                destinationVC.delegate = self
            
        } else if segue.identifier == "toCanvasVC" {
            let destinationVC = segue.destination as! ViewController
            
            if let indexPath = tableView.indexPathForSelectedRow,
               let category = categoryForSectionIndex(indexPath.section) {
                let item = allItems.getCorrectList(category: category)[indexPath.row]
                destinationVC.currentItem = item
                destinationVC.delegate = self
            }
            
        } else if segue.identifier == "toGridVC" {
            let destinationVC = segue.destination as! GridViewController
            
            if let indexPath = tableView.indexPathForSelectedRow,
               let category = categoryForSectionIndex(indexPath.section) {
                let item = allItems.getCorrectList(category: category)[indexPath.row]
                destinationVC.currentItem = item
                destinationVC.delegate = self
            }
        }
    }
    

        override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
            return !tableView.isEditing
        }
        
        // MARK: IBAction funcs
    
        @IBAction func deleteItems(_ sender: Any) {
            if let selectedRows = tableView.indexPathsForSelectedRows {
                for indexPath in selectedRows {
                    if let category = categoryForSectionIndex(indexPath.section) {
                        let items = allItems.getCorrectList(category: category)
                        let rowToDelete = indexPath.row > items.count - 1 ? items.count - 1 : indexPath.row
                        let item = items[rowToDelete]
                        allItems.remove(item: item, category: category, index: rowToDelete)
                    }
                }
                //Updates information in the view
                tableView.beginUpdates()
                tableView.deleteRows(at: selectedRows, with: .automatic)
                tableView.endUpdates()
            }
            deleteButton.isHidden = true
        }
    
    @IBAction func sendEmailButtonTapped(_ sender: UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tableView)
        if let indexPath = self.tableView.indexPathForRow(at: buttonPosition) {
            let checklistItem = allItems.getCorrectList(category: categoryForSectionIndex(indexPath.section)!)[indexPath.row]
            
            if MFMailComposeViewController.canSendMail() {
                print("to here")
                let mailComposeViewController = MFMailComposeViewController()
                mailComposeViewController.mailComposeDelegate = self
                mailComposeViewController.setToRecipients(["recipient@example.com"])
                mailComposeViewController.setSubject("Subject")
                if let image = checklistItem.image {
                    if let imageData = image.pngData() {
                        mailComposeViewController.addAttachmentData(imageData, mimeType: "image/png", fileName: "image.png")
                        let htmlBody = "<p>Email body with image:</p><br><img src='cid:image1'>"
                        mailComposeViewController.setMessageBody(htmlBody, isHTML: true)
                    }
                }
                
                self.present(mailComposeViewController, animated: true, completion: nil)
            } else {
                print("Device is unable to send email in its current state.")
            }
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
        
        // MARK: tableView funcs
        
        override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
            
            if let sourceCategory = categoryForSectionIndex(sourceIndexPath.section), let destinationCategory = categoryForSectionIndex(destinationIndexPath.section) {
                let item = allItems.getCorrectList(category: sourceCategory)[sourceIndexPath.row]
                allItems.move(item: item, sourceCategory: sourceCategory, sourceIndex: sourceIndexPath.row, destinationCategory: destinationCategory, destinationIndex: destinationIndexPath.row)
                tableView.reloadData()
            }
        }
        
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var title: String? = nil
        if let category = categoryForSectionIndex(section) {
            switch category {
            case .freeDraw:
                title = "Free Draw Canvases"
            case .grid:
                title = "Grid Canvas"
            }
        }
        return title
    }
        
        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if let category = categoryForSectionIndex(indexPath.section) {
                _ = allItems.getCorrectList(category: category)[indexPath.row]
                let indexPaths = [indexPath]
                tableView.deleteRows(at: indexPaths, with: .automatic)
            }
        }
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if let category = categoryForSectionIndex(section) {
                let list = allItems.getCorrectList(category: category)
                return list.count
            }
            return 0
        }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath) as! ImageTableViewCell
            
            if let category = categoryForSectionIndex(indexPath.section) {
                let list = allItems.getCorrectList(category: category)
                let item = list[indexPath.row]
                setLabel(cell: cell, item: item)
            }
        
            return cell
        }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
        
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.isEditing {
            return
        }
        
        let category = categoryForSectionIndex(indexPath.section)
        if category == AllItemsList.Category.freeDraw {
            performSegue(withIdentifier: "toCanvasVC", sender: self)
        } else {
            performSegue(withIdentifier: "toGridVC", sender: self)
        }
    }
        
        // MARK: Other funcs
        func setLabel(cell: ImageTableViewCell, item: ChecklistItem) {
            cell.cellImage.image = item.image
            cell.UILabel.text = item.text
        }
    
        func updateEntireList() {
            for category in AllItemsList.Category.allCases {
                let items = allItems.getCorrectList(category: category)
                for item in items {
                    let rowIndex = items.firstIndex(of: item)
                    let indexPath = IndexPath(row: rowIndex!, section: category.rawValue)
                    if let cell = tableView.cellForRow(at: indexPath) {
                        setLabel(cell: cell as! ImageTableViewCell, item: item)
                    }
                }
            }
        }
    
        
        private func categoryForSectionIndex(_ index: Int) ->
            AllItemsList.Category? {
                return AllItemsList.Category(rawValue: index)
            }
        
        private func sectionIndexForCategory(category: AllItemsList.Category) -> Int {
            var index = -1
            for cat in AllItemsList.Category.allCases {
                if cat == category {
                    index = cat.rawValue
                }
            }
            return index
        }
    }
    
