//
//  ViewController.swift
//  GitHub Search
//
//  Created by Majid Bashir on 25/05/2018.
//  Copyright © 2018 Majid Bashir. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class ReposCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    lazy var fetchedhResultController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Repo.self))
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "size", ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: CoreDataStack.sharedInstance.persistentContainer.viewContext,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    
    var searchText = String()
    var searchResults :[GitReposModel] =  Array()
    var repoViewModel: GitReposModel!
    var currentPage = Int()
    var isOnline = true
    
    let manager = CoredataManager()
    
    @IBOutlet weak var reposCollectionView: UICollectionView!
   
    fileprivate func makeRequestForSearchReposWith() {
        GitHubAPI.searchRepositories(name: searchText, currentPage: currentPage) { (success, responseArray, error) in
            DispatchQueue.main.async {
                if((responseArray) != nil) {
                    self.manager.saveInCoreDataWith(array: responseArray!)
                    self.searchResults = responseArray!
                    self.reposCollectionView.reloadData()
                } else {
                    print("No Items found")
                }
            }
        }
    }
    
    @IBAction func modeChange(_ sender: UIButton) {
        isOnline = !isOnline
        let title = isOnline ? "Online" : "Offline"
        sender.setTitle(title, for: .normal)
        do {
            try self.fetchedhResultController.performFetch()
            print("COUNT FETCHED FIRST: \(self.fetchedhResultController.sections?[0].numberOfObjects)")
        } catch let error  {
            print("ERROR: \(error)")
        }
        reposCollectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Repositories Found"

        self.makeRequestForSearchReposWith()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

       currentPage = searchResults.count/10
       return searchResults.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! RepoCollectionCell
        
        var item: GitReposModel
        if isOnline {
            item = searchResults[indexPath.row]
            cell.populateDatafromModel(modelObject: item)
        } else {
            if let repo = fetchedhResultController.object(at: indexPath) as? Repo {
                cell.populateDatafromModel(modelObject: GitReposModel(repo: repo))
            }
        }
        
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

extension ReposCollectionViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
    }
}

