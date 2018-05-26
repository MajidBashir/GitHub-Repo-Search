//
//  SearchViewController.swift
//  GitHub Search
//
//  Created by Majid Bashir on 25/05/2018.
//  Copyright © 2018 Majid Bashir. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func searchAction(_ sender: UIButton) {
        self.view.endEditing(true)
        // navigate to search Results view controller
        performSegue(withIdentifier: "showResultsSegue", sender: self)

    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // passing searchkey to next view controller
        let vc = segue.destination as! ReposCollectionViewController
        let trimmedString = searchTextField.text!.trimmingCharacters(in: .whitespaces)
        vc.searchText = trimmedString
    }

    
    // check if textfield is empty
    func validateTextField() -> Bool {
        // Trim Whitespaces
        if (searchTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            //Message to Display
            self.showDismissiveAlertMesssage(message: "Please enter some valid text.")
            return false
        }
        return true
    }

}

extension UIViewController {
    
    // MARK: UIAlertController
    func showDismissiveAlertMesssage(message: String) {
        
        let alertController = UIAlertController(title: nil, message: message, preferredStyle:UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
}
