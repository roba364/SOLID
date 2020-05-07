//
//  NetworkService.swift
//  MVP-project(SOLID+UnitTests)
//
//  Created by SofiaBuslavskaya on 23/04/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import UIKit

protocol NetworkServiceProtocol {
    func getComments(completion: @escaping (Result<[Comment]?, Error>) -> Void)
}

class NetworkService: NetworkServiceProtocol {
    func getComments(completion: @escaping (Result<[Comment]?, Error>) -> Void) {
        
        let urlString = "https://jsonplaceholder.typicode.com/comments"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            
            guard let data = data else { return }
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            do {
                let obj = try JSONDecoder().decode([Comment].self, from: data)
                print(obj)
                completion(.success(obj))
            } catch let error {
                completion(.failure(error))
            }
            
        }
    }
}
