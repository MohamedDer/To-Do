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

var itemsRaw: [Item] = []
var items: [[Item]]!
let sections = ["In progress", "Done"]
var ref: DatabaseReference!



override func viewDidLoad() {
super.viewDidLoad()

    items = [[],[]]
    mytableview.layer.cornerRadius = 10
    indicator?.hidesWhenStopped = true
    indicator?.startAnimating()

    getItemsFromDB().then{ allItemsNode -> Void in
        print("heeere are we baby \(allItemsNode.description)")
        
        // getting all the nodes from the "tasks" branch
        var iterator = 0
        while ( iterator < allItemsNode.count){

            let itemID = allItemsNode.allKeys[iterator] as! String
            let itemNode = allItemsNode.value(forKey: itemID) as! NSDictionary
            // extracting node data and converting to Item

            let itemText = itemNode.value(forKey: "itemText")! as! String
            let itemIsDone = itemNode.value(forKey: "isDone")! as! String
            self.itemsRaw.append(Item(item: itemText, isDone: self.toBool(string: itemIsDone)!,id: itemID))
            print("item : \(self.itemsRaw[iterator].itemText) added in  raw")
            iterator += 1
        }

        }.then{ _ -> Void in 
            self.items = self.addItems(itemsArray: self.itemsRaw)
            self.mytableview.reloadData()
            self.indicator.stopAnimating()
        }.catch{ _ -> Void in
            print("error from the catch scope")
    }
    


}
    
    func getItemsFromDB () -> Promise<NSDictionary> {
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
    ref.child("tasks").child(itemToAdd.id).child("itemText").setValue(itemToAdd.itemText)
    ref.child("tasks").child(itemToAdd.id).child("isDone").setValue(itemToAdd.isDone.description)
    mytableview.reloadData()
}




func numberOfSections(in tableView: UITableView) -> Int {
    return sections.count
}

func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    //print( items[section].count)
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

    let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
    cell.textLabel?.text = items[indexPath.section][indexPath.row].itemText
    if items[indexPath.section][indexPath.row].isDone == true {
        cell.accessoryType = .checkmark
        cell.textLabel?.font = UIFont(name: "Oriya Sangam MN", size: 16)
        cell.textLabel?.textColor = #colorLiteral(red: 0.06581701013, green: 0.1067036318, blue: 1, alpha: 1)
    }
    else{
        cell.accessoryType = .none
        cell.textLabel?.font = UIFont(name: "Oriya Sangam MN", size: 18)
        cell.textLabel?.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)  }
        return cell

}

func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
    // toggle items if selected
    if items[indexPath[0]][indexPath.row].isDone == true{
        items[indexPath[0]][indexPath.row].isDone = false
        items[0].append(items[1][indexPath.row])
        items[1].remove(at: indexPath.row)

    }else{
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

func toBool(string: String) -> Bool? {
    switch string {
    case "True", "true", "yes", "1":
    return true
    case "False", "false", "no", "0":
    return false
    default:
    return nil
    }
}


}

