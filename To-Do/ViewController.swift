//  ViewController.swift
//  To-Do
//
//  Created by Mohamed Derkaoui on 29/01/2018.
//  Copyright © 2018 Mohamed Derkaoui. All rights reserved.


import UIKit
import DLRadioButton

class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    let itemOne = Item(item: "my 1 item", isDone: true)
    let itemTwo = Item(item: "my 2 item", isDone: true)
    let itemThree = Item(item: "my 3 item", isDone: false)
    let itemFour = Item(item: "my 4 item", isDone: false)
    var items: [[Item]]!
    let sections = ["Doing", "Done"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        items = addItems(itemsArray: [itemOne,itemTwo,itemThree,itemFour])
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        cell.textLabel?.text = items[indexPath.section][indexPath.row].item
        if items[indexPath.section][indexPath.row].isDone == true {cell.accessoryType = .checkmark}
        else{cell.accessoryType = .none}
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if items[indexPath[0]][indexPath.row].isDone == true{
            items[indexPath[0]][indexPath.row].isDone = false
            items[0].append(items[1][indexPath.row])
            items[1].remove(at: indexPath.row)
            
            //tableView.cellForRow(at: indexPath)?.accessoryType = .none
            tableView.reloadData()

            
        }else{
            items[indexPath[0]][indexPath.row].isDone = true
            items[1].append(items[0][indexPath.row])
            items[0].remove(at: indexPath.row)
            
            //tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            tableView.reloadData()

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

    func addItems(itemsArray: [Item]) -> [[Item]]{
        var items: [[Item]]!
        items = [[],[]]
        for i in itemsArray{
            if i.isDone == false {
                items[0].append(i)
            }else{
                items[1].append(i)
            }
        }
        print(items)
        return items
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

}
}

