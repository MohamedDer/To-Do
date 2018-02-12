//  ViewController.swift
//  To-Do
//
//  Created by Mohamed Derkaoui on 29/01/2018.
//  Copyright © 2018 Mohamed Derkaoui. All rights reserved.


import UIKit
import DLRadioButton

class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    let itemOne = Item(item: "my one item", isDone: true)
    let itemTwo = Item(item: "my two item", isDone: true)
    let itemThree = Item(item: "my three item", isDone: true)
    let itemFour = Item(item: "my four item", isDone: false)

    var items = [Item]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        items = [itemOne, itemTwo, itemThree, itemFour]

        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as  UITableViewCell
        cell.textLabel?.text = items[indexPath.row].item
        if items[indexPath.row].isDone == false {cell.accessoryType = .none}
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark
        {            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            print("none cell in row \(indexPath)")
}        else
{           tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            print("check cell in row \(indexPath)")

}    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

