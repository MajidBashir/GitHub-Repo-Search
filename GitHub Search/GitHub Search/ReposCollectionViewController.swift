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
    
   // MARK: -  NSFetch Result Controller will work here
    
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
    
    // MARK: - Properties

    var searchText = String()
    var searchResults :[GitReposModel] =  Array()
    var repoViewModel: GitReposModel!
    var currentPage = 0
    var totalRecords = 0
    var isOnline = true
    var isFetching  = false
    var modeButton = UIButton()
    
    let manager = CoredataManager()
    
    @IBOutlet weak var reposCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Repositories Found"
        self.makeRequestForSearchReposWith()
        
        modeButton = UIButton(type: .system)
        modeButton.setTitle("Offline", for: .normal)
        modeButton.titleLabel?.textColor = .blue
        modeButton.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        modeButton.addTarget(self, action: #selector(self.modeChange(_:)), for: .touchUpInside)
        let item2 = UIBarButtonItem(customView: modeButton)
        
        self.navigationItem.setRightBarButtonItems([item2], animated: true)
        
    }
    
    // MARK: - Functions

    fileprivate func makeRequestForSearchReposWith() {
        self.isFetching = true
        GitHubAPI.searchRepositories(name: searchText, currentPage: currentPage) { [weak self] (success, completeModel, error) in
            DispatchQueue.main.async {
                self?.isFetching = false
                if let dataModel = completeModel {
                    if let items = dataModel.items{
                        self?.manager.saveInCoreDataWith(array: items)
                        self?.searchResults.append(contentsOf: items)
                    }
                    self?.totalRecords = dataModel.total_count
                    if (dataModel.total_count > 0){
                        self?.currentPage = (self?.searchResults.count)! / 10
                        self?.reposCollectionView.reloadData()
                    } else {
                        self?.showAlertWith(title: "No Results", message: "Please check offline mode to get previously stored results.")
                    }
                } else {
                    
                }
            }
        }
    }
    
    @IBAction func modeChange(_ sender: UIBarButtonItem) {
        isOnline = !isOnline
        let title = isOnline ? "Online" : "Offline"
        modeButton.setTitle(title, for: .normal)
        
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
    
    // MARK: - UICollectionViewDelegate
    
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
        let action = UIAlertAction(title: "Thanks", style: .default) { (action) in
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

