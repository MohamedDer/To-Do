//  ViewController.swift
//  To-Do
//
//  Created by Mohamed Derkaoui on 29/01/2018.
//  Copyright © 2018 Mohamed Derkaoui. All rights reserved.


import UIKit

class ViewController: UIViewController {
    
    var items:[String]=[]
    
    @IBOutlet weak var mTextField: UITextField!
    @IBOutlet weak var mItemsLabel: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func addItem(_ sender: Any) {
        if mTextField.text == "" {
            return
        }
        items.append(mTextField.text!)
        mItemsLabel.text=""
        for item in items{
            mItemsLabel.text.append(" - "+item+"\n")
        }
        mTextField.resignFirstResponder()
        mTextField.text=""
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

