//
//  List.swift
//  FetchInterview
//
//  Created by Shrey Gupta on 2/3/23.
//

import Foundation

// model class for List objects
class List {
    let id: Int
    var items: [Item] {
        didSet {
            items = items.sorted { $0.id < $1.id }
        }
    }
    
    init(id: Int, items: [Item]) {
        self.id = id
        self.items = items
    }
}
