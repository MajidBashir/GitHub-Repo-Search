//
//  RepoCollectionCell.swift
//  GitHub Search
//
//  Created by Majid Bashir on 25/05/2018.
//  Copyright © 2018 Majid Bashir. All rights reserved.
//

import UIKit

class RepoCollectionCell: UICollectionViewCell {
   
    @IBOutlet weak var repoNameLabel: UILabel!
    @IBOutlet weak var repoOwnerNameLabel: UILabel!
    @IBOutlet weak var repoEstimatedSize: UILabel!
 
    func populateDatafromModel(modelObject :GitReposModel) {
        repoNameLabel?.text = modelObject.full_name
        repoOwnerNameLabel?.text = modelObject.owner.login
        repoEstimatedSize.text = String(modelObject.forks_count)
        
        //        DispatchQueue.global(qos: .background).async {
        //     }
    }
}
