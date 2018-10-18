//
//  PostController.swift
//  WhyiOS22
//
//  Created by Xavier on 10/17/18.
//  Copyright © 2018 Xavier ios dev. All rights reserved.
//

import Foundation

class PostController: Codable {
    
    //Shared Function
    static let sharedInstance = PostController()
    
    //Source of truth
    var posts: [Post] = []
    
    let baseURL = URL(string: "https://whydidyouchooseios.firebaseio.com/reasons")
    
    enum HTTPMethod: String {
        case put = "PUT"
        case post = "Post"
        case patch = "PATCH"
        case delete = "Delete"
    }
    
    
    //CREATE
     func postReason(with reason: String, name: String, completion: @escaping (Bool) -> Void) {
        let post = Post(name: name, reason: reason)
        // 1) URLSession
        // 2) define the request and build your url from a property coming from your instance of Chat
        guard let  url = baseURL else {
            fatalError("Not a good base url")
        }
        
        let fullURL = url.appendingPathExtension("json")
        
        var request = URLRequest(url: fullURL)
        
        do {
            let data = try JSONEncoder().encode(post)
            request.httpMethod = HTTPMethod.post.rawValue
            request.httpBody = data
        } catch let error {
            print("Error encoding our object \(error) \(error.localizedDescription)")
            completion(false);return
        }
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                print("Error with data task \(error) \(error.localizedDescription)")
                completion(false);return
            }
            
            self.posts.append(post)
            completion(true)
        }
    }
    
     func fetchPost(completion: @escaping (Bool) -> Void) {
        guard let url = baseURL else {
            fatalError("Bad baseURL")
        }
        var request = URLRequest(url: url.appendingPathExtension("json"))
        request.httpMethod = "GET"
        request.httpBody =  nil
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            
            //Check for an error and Handle the error
            if let error = error {
                print("There was an error in \(error) ; \(error.localizedDescription) ")
            }
            
            //If data is there write and do, try Catch to unwrap
            guard let data = data else {completion(false);return}
            do {
                let postDictionary = try JSONDecoder().decode([String: Post].self, from: data)
                
                let postsThatCameBack = postDictionary.compactMap({$0.value})
                self.posts = postsThatCameBack
                completion(true)
            } catch let error {
                print("Error with JSONDecoder \(error) \(error.localizedDescription)")
                completion(false);return
            }
            
            }.resume()
        
    }
}
