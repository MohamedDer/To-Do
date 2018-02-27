//  ViewController.swift
//  To-Do
//
//  Created by Mohamed Derkaoui on 29/01/2018.
//  Copyright © 2018 Mohamed Derkaoui. All rights reserved.


import UIKit
import FirebaseDatabase
import PromiseKit
import SwiftyJSON

class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource ,addItemProtocol {


    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var mytableview: UITableView!

    var itemsRaw: [Item] = [] // contains items loaded from the firebase db
    var items: [[Item]]! // contains 2 arrays : first one for in progress items and the second on for the done items
    let sections = ["In progress", "Done"]
    var ref: DatabaseReference!



override func viewDidLoad() {
    super.viewDidLoad()
    Database.database().isPersistenceEnabled = true
    items = [[],[]]
    mytableview.layer.cornerRadius = 10
    indicator?.hidesWhenStopped = true
    indicator?.startAnimating()
    
    ref = Database.database().reference()

    FirebaeAPI.getItemsFromDB().then{ allItemsNode -> Void in
        
        // populating itemsRaw from the fetched "tasks" branch
        var iterator = 0
        while ( iterator < allItemsNode.count){
            let itemID = allItemsNode.allKeys[iterator] as! String
            let itemNode = allItemsNode.value(forKey: itemID) as! NSDictionary
            // extracting node data and converting to Item
            let itemText = itemNode.value(forKey: "itemText")! as! String
            let itemIsDone = itemNode.value(forKey: "isDone")! as! String
            self.itemsRaw.append(Item(item: itemText, isDone: Item.toBool(string: itemIsDone)!,id: itemID))
            print("item : \(self.itemsRaw[iterator].itemText) added in  raw")
            iterator += 1
        }
        
        }.then{ _ -> Void in
            self.items = self.addItems(itemsArray: self.itemsRaw)
            // updating UI with loaded data
            self.mytableview.reloadData()
            self.indicator.stopAnimating()
        }.catch{ _ -> Void in
            print("error from the catch scope ")
            // I ll do a propmt  mssg here
            self.indicator.stopAnimating()
    }
}
    
   
    
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if  segue.identifier == "addItemSegue" {
        let navVC = segue.destination as? UINavigationController
        let additemVC = navVC?.viewControllers.first as! addItemViewController
        additemVC.delegate = self
    }
}

func newItemToAdd(string: String) {
    let itemToAdd = Item(item: string, isDone: false)
    items[0].append(itemToAdd)
    itemToAdd.addItemToDB()
    mytableview.reloadData()
}


func numberOfSections(in tableView: UITableView) -> Int {
    return sections.count
}

func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return sections[section]
}

    
func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    let header = view as! UITableViewHeaderFooterView
    if let textlabel = header.textLabel {
        textlabel.font = textlabel.font.withSize(20)
        textlabel.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    }
}



func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 return items[section].count

}


func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{

    // Custom apppearence for each type of items
    let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
    cell.textLabel?.text = items[indexPath.section][indexPath.row].itemText
    if items[indexPath.section][indexPath.row].isDone == true {
        cell.accessoryType = .checkmark
        cell.textLabel?.font = UIFont(name: "Oriya Sangam MN", size: 15)
        cell.textLabel?.textColor = #colorLiteral(red: 0.06581701013, green: 0.1067036318, blue: 1, alpha: 1)
    }
    else{
        cell.accessoryType = .none
        cell.textLabel?.font = UIFont(name: "Oriya Sangam MN", size: 17)
        cell.textLabel?.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)  }
        return cell

}

func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
    // toggle items if selected
    if items[indexPath[0]][indexPath.row].isDone == true{
        //updating firebase db
        items[indexPath[0]][indexPath.row].switchStateForItem(isDoneInt: 1)
        //updating local data
        items[indexPath[0]][indexPath.row].isDone = false
        items[0].append(items[1][indexPath.row])
        items[1].remove(at: indexPath.row)
    }else{
        //updating firebase db
        items[indexPath[0]][indexPath.row].switchStateForItem(isDoneInt: 0)
        //updating local data
        items[indexPath[0]][indexPath.row].isDone = true
        items[1].append(items[0][indexPath.row])
        items[0].remove(at: indexPath.row)
    }
    // update UI with animation
    UIView.transition(with: tableView,
                  duration: 0.35,
                  options: [.transitionCrossDissolve],
                  animations: { self.mytableview.reloadData() })
}

func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
        //updating firebase db
        items[indexPath[0]][indexPath.row].deleteItemFromDB()
        // remove the item from the local data
        items[indexPath[0]].remove(at: indexPath.row)
        // delete the tableview row
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



}

