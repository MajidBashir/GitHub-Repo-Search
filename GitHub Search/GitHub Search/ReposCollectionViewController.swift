//
//  ViewController.swift
//  GitHub Search
//
//  Created by Majid Bashir on 25/05/2018.
//  Copyright © 2018 Majid Bashir. All rights reserved.
//

import UIKit
import Foundation

class ReposCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var searchText = String()
    var searchResults :[GitReposModel] =  Array()
    var repoViewModel: GitReposModel!
    
    @IBOutlet weak var reposCollectionView: UICollectionView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Repositories Found"

        GitHubAPI.searchRepositories(name: searchText) { (success, responseArray, error) in
            DispatchQueue.main.async {
                if((responseArray) != nil){
                    self.searchResults = (responseArray)!
                    self.reposCollectionView.reloadData()
                } else{
                    self.title = "No Repositories"
                }
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return searchResults.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! RepoCollectionCell
        
        let item : GitReposModel = searchResults[indexPath.row]
            cell.populateDatafromModel(modelObject: item)
        
        return cell
    }
    
}

extension ReposCollectionViewController {
   
    func showAlertWith(title: String, message: String, style: UIAlertControllerStyle = .alert) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let action = UIAlertAction(title: title, style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
}


