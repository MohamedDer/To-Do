//
//  FirebaseAPI.swift
//  To-Do
//
//  Created by Mohamed Derkaoui on 22/02/2018.
//  Copyright © 2018 Mohamed Derkaoui. All rights reserved.
//

import Foundation
import PromiseKit
import FirebaseDatabase

class FirebaeAPI {
    
    
    
    static func getItemsFromDB () -> Promise<NSDictionary> {
        var ref: DatabaseReference!
        return Promise { fulfill, reject in
            ref = Database.database().reference()
            ref.child("tasks").observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let allItemsDictionnary = snapshot.value as? NSDictionary else {
                    print("ne data/task node")
                    reject(NSError(domain: "No tasks node found !", code: 100, userInfo: nil))
                    return
                }
                fulfill(allItemsDictionnary)
            })
        }
    }

    
    
    
}
