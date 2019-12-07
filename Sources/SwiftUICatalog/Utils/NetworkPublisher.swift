//
//  NetworkPublisher.swift
//  stores.native
//
//  Created by Takuya Yokoyama on 2019/10/27.
//  Copyright © 2019 chocoyama. All rights reserved.
//

import Foundation
import Combine

public struct NetworkPublisher {
    
    private static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        return decoder
    }()
    
    public static func publish(_ request: URLRequest) -> AnyPublisher<Data, Error> {
        if let requestUrlString = request.url?.absoluteString {
            Logger.info("request \(requestUrlString) start")
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap({ (data, response) -> Data in
                if let requestUrlString = request.url?.absoluteString,
                    let rawResponse = String(data: data, encoding: .utf8) {
                    Logger.info("response of \(requestUrlString) is \n\(rawResponse)")
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    if (200..<300).contains(httpResponse.statusCode) {
                        return data
                    } else {
                        throw NetworkError.invalidServerResponse
                    }
                } else {
                    throw NetworkError.unknown
                }
            })
            .retry(1)
            .eraseToAnyPublisher()
    }
    
    public static func publish<T: NetworkRequest>(_ request: T) -> AnyPublisher<T.NetworkResponse, Error> {
        self.publish(request.build())
            .decode(type: T.NetworkResponse.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
}

public enum NetworkError: Error {
    case invalidServerResponse
    case unknown
}

public protocol NetworkRequest {
    associatedtype NetworkResponse: Codable
    var endpoint: String { get }
    var httpMethod: HTTPMethod { get }
    var queryItems: [URLQueryItem]? { get }
    func build() -> URLRequest
}

public extension NetworkRequest {
    func build() -> URLRequest {
        var components = URLComponents(string: endpoint)
        if let queryItems = queryItems {
            components?.queryItems = queryItems
        }
        let url = components?.url
        var request = URLRequest(url: url!)
        request.httpMethod = httpMethod.rawValue
        return request
    }
}

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POSt"
}
