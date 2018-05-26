//
//  CoreDataManager.swift
//  GitHub Search
//
//  Created by Majid Bashir on 25/05/2018.
//  Copyright © 2018 Majid Bashir. All rights reserved.
//

import Foundation
import CoreData
import UIKit


class CoredataManager  {
    
    private func createRepoEntityFrom(gitRepo: GitReposModel) -> NSManagedObject? {
        
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        if let repo = NSEntityDescription.insertNewObject(forEntityName: "Repo", into: context) as? Repo {
            
            repo.name = gitRepo.name
            repo.owner = gitRepo.owner.login
            repo.size = Int64(gitRepo.size)
            repo.has_wiki = gitRepo.has_wiki
            return repo
        }
        return nil
    }
    
    func saveInCoreDataWith(array: [GitReposModel]) {
        _ = array.map{ self.createRepoEntityFrom(gitRepo: $0)}
        do {
            try CoreDataStack.sharedInstance.persistentContainer.viewContext.save()
        } catch let error {
            print(error)
        }
    }
}
