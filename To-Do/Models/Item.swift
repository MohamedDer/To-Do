//
//  Item.swift
//  To-Do
//
//  Created by Mohamed Derkaoui on 12/02/2018.
//  Copyright © 2018 Mohamed Derkaoui. All rights reserved.
//

import Foundation
import FirebaseDatabase
//import Firebase


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
 
    
    static func toBool(string: String) -> Bool? {
        switch string {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return nil
        }
    }

    
    func addItemToDB() -> Void {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("tasks").child(self.id).child("itemText").setValue(self.itemText)
        ref.child("tasks").child(self.id).child("isDone").setValue(self.isDone.description)
    }
    
    func deleteItemFromDB() -> Void {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("tasks").child(self.id).setValue(nil)
    
    }
    
    func switchStateForItem(isDoneInt: Int) -> Void {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        if isDoneInt == 1 {
            ref.child("tasks").child(self.id).child("isDone").setValue("false")
        } else {
            ref.child("tasks").child(self.id).child("isDone").setValue("true")
        }
        
        
    
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





