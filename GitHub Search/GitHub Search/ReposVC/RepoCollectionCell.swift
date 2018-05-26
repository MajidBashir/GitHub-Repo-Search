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
        repoNameLabel?.text = modelObject.name
        repoOwnerNameLabel?.text = modelObject.owner.login
        repoEstimatedSize.text = "\(modelObject.size) Kb"
        self.backgroundColor =  modelObject.has_wiki ?  UIColor.init(red: 200.0/255.0, green: 200.0/255.0, blue: 200.0/255.0, alpha: 1.0)  : UIColor.init(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1.0)
    }
}
