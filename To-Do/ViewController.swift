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
    var items: [[Item]]!

    let sections = ["Doing", "Done"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        items = [[itemOne,itemTwo, itemThree], [itemFour]]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count

    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
  

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].count

    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
//        let indexPathforSection = IndexPath(row: indexPath.row, section: 0)

        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        cell.textLabel?.text = items[indexPath.section][indexPath.row].item
        if items[indexPath.section][indexPath.row].isDone == false {cell.accessoryType = .none}
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        print(" indexpath \(indexPath)")
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{ tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // remove the item from the data model
            items[indexPath[0]].remove(at: indexPath.row)
            
            // delete the table view row
            tableView.deleteRows(at: [indexPath], with: .fade)
            
    }
    
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

}
}

