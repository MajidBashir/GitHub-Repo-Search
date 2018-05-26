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
    @IBOutlet weak var modeButton: UIBarButtonItem!
    
    // NSFetch Result Controller will work here
    
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
    var currentPage = 0
    var totalRecords = 0
    var isOnline = true
    var isFetching  = false
    
    let manager = CoredataManager()
    
    @IBOutlet weak var reposCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Repositories Found"
        self.makeRequestForSearchReposWith()
    }
    
    
    fileprivate func makeRequestForSearchReposWith() {
        self.isFetching = true
        GitHubAPI.searchRepositories(name: searchText, currentPage: currentPage) { [weak self] (success, completeModel, error) in
            DispatchQueue.main.async {
                self?.isFetching = false
                if let dataModel = completeModel {
                    self?.manager.saveInCoreDataWith(array: dataModel.items)
                    self?.searchResults.append(contentsOf: dataModel.items)
                    self?.totalRecords = dataModel.total_count
                    self?.currentPage = (self?.searchResults.count)! / 10
                    self?.reposCollectionView.reloadData()
                } else {
                    
                    print("No Items found")
                }
            }
        }
    }
    
    @IBAction func modeChange(_ sender: UIBarButtonItem) {
        isOnline = !isOnline
        let title = isOnline ? "Online" : "Offline"
        modeButton.title = title
        do {
            try self.fetchedhResultController.performFetch()
            
            print("COUNT FETCHED FIRST: \(String(describing: self.fetchedhResultController.sections?[0].numberOfObjects)))")
            reposCollectionView.reloadData()
            
        } catch let error  {
            print("ERROR: \(error)")
        }
        
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        currentPage = searchResults.count/10
        
        if isOnline{
            return searchResults.count
        }
        else{
            return self.fetchedhResultController.sections?[0].numberOfObjects ?? 0
        }
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
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath){
        if indexPath.item >= searchResults.count - 10 && searchResults.count != totalRecords  {
            if !isFetching{
                self.makeRequestForSearchReposWith()
            }
        }
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


// MARK: - NSFetchedResultsControllerDelegate

extension ReposCollectionViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
    }
}

