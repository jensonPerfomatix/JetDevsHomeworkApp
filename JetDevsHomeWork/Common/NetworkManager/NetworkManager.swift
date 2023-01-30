//
//  NetworkManager.swift
//  JetDevsHomeWork
//
//  Created by Jenson John on 30/01/23.
//

import Foundation

public typealias Parameters = [String: Any]

class NetworkManager {

    /// These are the errors this class might return
    enum ManagerErrors: Error {
        case invalidResponse
        case invalidStatusCode(Int)
    }

    /// The request method you like to use
    enum HttpMethod: String {
        case get
        case post

        var method: String { rawValue.uppercased() }
    }

    /// Request data from an endpoint
    /// - Parameters:
    ///   - url: the URL
    ///   - httpMethod: The HTTP Method to use, either get or post in this case
    ///   - completion: The completion closure, returning a Result of either the generic type or an error
    func request<T: Decodable>(fromURL url: URL, httpMethod: HttpMethod = .get, params: Parameters = [:], completion: @escaping (Result<T, Error>) -> Void) {

        let completionOnMain: (Result<T, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }

        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.method
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        if httpMethod != .get {
            guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else {
                debugPrint("body params not valid")
                return
            }
            request.httpBody = httpBody
        }

        let urlSession = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                completionOnMain(.failure(error))
                return
            }

            guard let urlResponse = response as? HTTPURLResponse else { return completionOnMain(.failure(ManagerErrors.invalidResponse)) }
            if !(200..<300).contains(urlResponse.statusCode) {
                return completionOnMain(.failure(ManagerErrors.invalidStatusCode(urlResponse.statusCode)))
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if #available(iOS 13.0, *) {
                    if let xAcc = httpResponse.allHeaderFields["X-Acc"] as? String {
                        print("xAcc: \(xAcc)")
                        // Save locally
                        let data = Data(from: (xAcc))
                        let status = KeychainManager.save(key: "xAcc", data: data)
                        print("Saved xAcc locally status: \(status)")
                    }
                } else {
                    if let xAcc = httpResponse.allHeaderFields["X-Acc"] as? String {
                        print("xAcc: \(xAcc)")
                        // Save locally
                        let data = Data(from: (xAcc))
                        let status = KeychainManager.save(key: "xAcc", data: data)
                        print("Saved xAcc locally status: \(status)")
                    }
                }
            }
            
            guard let data = data else { return }
            do {
                let user = try JSONDecoder().decode(T.self, from: data)
                completionOnMain(.success(user))
            } catch {
                debugPrint("Could not translate the data to the requested type. Reason: \(error.localizedDescription)")
                completionOnMain(.failure(error))
            }
        }
        
        urlSession.resume()
    }
}
