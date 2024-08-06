//
//  APIServices.swift
//  APISampleSwiftUI
//
//  Created by Dona Maria Peter on 04/06/24.
//

import Foundation
import UIKit

class APIService {
    
    //static: This means that the method belongs to the class itself rather than to instances of the class. You can call this method on APIService directly without needing to create an instance.
    
  //  This part specifies a generic type parameter T.
  //  T: Decodable means that the type T must conform to the Decodable protocol. This ensures that whatever type is passed to this method can be decoded from JSON.
    
    //(from urlString: String, ...): This is the parameter list for the method.
   // from urlString: String: The method takes a single argument urlString which is a String representing the URL from which data should be fetched.
    //An asynchronous operation is one that allows a program to continue running while it waits for the operation to complete.This is in contrast to a synchronous operation, which blocks the program until the operation finishes.
    //completion: The name of the completion handler parameter.
   // @escaping: Indicates that the closure escapes the scope of the function. This is necessary because the closure will be called after the asynchronous network request completes.
   // (Result<T, Error>) -> Void: The type of the completion handler. It is a closure that takes a Result type as its argument and returns Void (nothing).
   // Result<T, Error>: This is an enumeration that can be either .success(T) or .failure(Error).
   // .success(T): Indicates the operation was successful, with a value of type T.
    //  .failure(Error): Indicates the operation failed, with an Error.
    
    
    static func fetchData<T: Decodable>(from urlString: String, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
                return
            }

            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }

    static func fetchImage(from urlString: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data, let image = UIImage(data: data) else {
                completion(.failure(NSError(domain: "Invalid image data", code: 0, userInfo: nil)))
                return
            }

            completion(.success(image))
        }
        task.resume()
    }
}
