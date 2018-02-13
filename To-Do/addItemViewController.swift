//
//  addItemViewController.swift
//  To-Do
//
//  Created by Mohamed Derkaoui on 13/02/2018.
//  Copyright © 2018 Mohamed Derkaoui. All rights reserved.
//

import UIKit

protocol addItemProtocol {
    func newItemToAdd(string: String)
}

class addItemViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    var delegate: addItemProtocol?

    @IBAction func dismissAddItemView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addThisItem(_ sender: Any) {
            delegate?.newItemToAdd(string: textView.text)
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.layer.borderWidth = 2
        textView.layer.borderColor =  #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        textView.layer.cornerRadius = 5

       
        
    }
    
}
