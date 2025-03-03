//
//  NetworkClient.swift
//  MovieQuiz
//
//  Created by Валерий on 25.02.2025.
//

import Foundation

struct NetworkClient {
    private enum NetworkError: Error {
        case codeError
    }
    
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        let request = URLRequest(url: url)
 
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                handler(.failure(error))
                return
            }
            
            guard let response = response as? HTTPURLResponse, 200 ..< 300 ~= response.statusCode else {
                handler(.failure(NetworkError.codeError))
                return
            }
            
            guard let data else { return }
            handler(.success(data))
        }
        
        task.resume()
    }
}
