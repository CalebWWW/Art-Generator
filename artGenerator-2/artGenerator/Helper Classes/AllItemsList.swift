//
//  AllItemsList.swift
//  artGenerator
//
//  Created by Nathan Freeman on 3/26/24.
//

import Foundation
import UIKit

class AllItemsList {
    
    enum Category: Int, CaseIterable {
        case grid
        case freeDraw
    }
    
    private var allGridDraw: [ChecklistItem] = []
    private var allFreeDraw: [ChecklistItem] = []
    
    var preloadedImage = UIImage(named: "BlankImage")
    
    func addItem(name: String) -> ChecklistItem {
        let item = ChecklistItem(text: name, image: preloadedImage!)
        allFreeDraw.append(item)
        return item
    }
    
    func getCorrectList(category: Category) -> [ChecklistItem] {
        switch category {
        case .freeDraw:
            return allFreeDraw
        case .grid:
            return allGridDraw
        }
    }
    
    init() {
        //var item = ChecklistItem(text: "sample", image: preloadedImage!)
        //allFreeDraw.append(item)
        
        //item = ChecklistItem(text: "sampleGrid", image: preloadedImage!)
        //allGridDraw.append(item)
    }
    
    func addItem(item: ChecklistItem, category: Category, index: Int = -1) {
        switch category {
        case .freeDraw:
            if index < 0 {
                allFreeDraw.append(item)
            } else {
                allFreeDraw.insert(item, at: index)
            }
        case .grid:
            if index < 0 {
                allGridDraw.append(item)
            } else {
                allGridDraw.insert(item, at: index)
            }
        }
    }
        
    func move(item: ChecklistItem, sourceCategory: Category, sourceIndex: Int, destinationCategory: Category, destinationIndex: Int) {
            remove(item: item, category: sourceCategory, index: sourceIndex)
            addItem(item: item, category: destinationCategory, index: destinationIndex)
    }
        
    func remove(item: ChecklistItem, category: Category, index: Int = -1) {
        switch category {
        case .grid:
            allGridDraw.remove(at: index)
        case .freeDraw:
            allFreeDraw.remove(at: index)
        }
        print(String(index))
    }
    
    func removeSpecificItem(items: [ChecklistItem], chosenList: inout [ChecklistItem]) {
        for item in items {
            if let index = chosenList.firstIndex(of: item) {
                chosenList.remove(at: index)
            }
        }
    }
}
