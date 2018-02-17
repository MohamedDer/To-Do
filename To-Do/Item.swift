//
//  Item.swift
//  To-Do
//
//  Created by Mohamed Derkaoui on 12/02/2018.
//  Copyright © 2018 Mohamed Derkaoui. All rights reserved.
//

import Foundation


class Item{

var itemText: String
var isDone: Bool
var id: String

init(item: String, isDone: Bool) {
    self.itemText = item
    self.isDone = isDone
    self.id = randomString()
}

    init(item: String, isDone: Bool, id: String) {
        self.itemText = item
        self.isDone = isDone
        self.id = id
    }
    
}


func randomString(length: Int = 5) -> String {
    let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    var randomString: String = ""
    
    for _ in 0..<length {
        let randomValue = arc4random_uniform(UInt32(base.count))
        randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
    }
    return randomString
}



