//
//  Models.swift
//  Git Search API
//
//  Created by Majid Bashir on 25/05/2018.
//  Copyright © 2018 Majid Bashir. All rights reserved.
//

import Foundation

struct GitTopLevelModel: Decodable {
    let total_count: Int
    let incomplete_results : Bool
    let items : [GitReposModel]?
}

struct GitReposModel: Decodable {
    let owner: Owner
    let name: String
    let description: String?
    let has_wiki : Bool
    let size : Int
    
    init(repo: Repo){
        self.name = repo.name ?? ""
        let owner = repo.owner ?? ""
        self.owner = Owner(login: owner)
        self.size = Int(repo.size)
        self.has_wiki = repo.has_wiki
        self.description = ""
       // self.description = repo.description
    }
}

struct Owner : Decodable {
    let login :String
}
