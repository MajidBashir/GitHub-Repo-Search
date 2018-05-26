//
//  AppDelegate.swift
//  GitHub Search
//
//  Created by Majid Bashir on 25/05/2018.
//  Copyright © 2018 Majid Bashir. All rights reserved.
//


import Foundation

struct GitHubAPI {
    static func searchRepositories(name: String, currentPage: Int, completion: @escaping (Bool, GitTopLevelModel?, Error?)->Void) {
        
        // The Base url
        
        var searchReposURL = "https://api.github.com/search/repositories?q="
        searchReposURL.append(name)
        searchReposURL.append("&page=\(currentPage)")
        searchReposURL.append("&per_page=10")
        
        let url = NSURL(string: searchReposURL)
        let session = URLSession.shared
        let muableRequest = NSMutableURLRequest(url: url! as URL)
        // As per github API V3
        muableRequest.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: muableRequest as URLRequest, completionHandler: { (data, response, error) -> Void in
            do {
                if let responseData = data {
                    let decoder = JSONDecoder()
                    let completeModel = try decoder.decode(GitTopLevelModel.self, from: responseData)
                    
                    if(completeModel.items.count>0){
                        //Some Data Found
                        completion(true,completeModel,nil)
                    } else{
                        //No Data Found
                        completion(true,nil,nil)
                    }
                } else {
                    completion(true,nil,nil)
                }
                
            } catch {
                //Error Occourred
                completion(false,nil,error)
            }
        })
        task.resume()
    }
}
