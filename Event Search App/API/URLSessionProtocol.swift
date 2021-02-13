//
//  URLSessionProtocol.swift
//  Event Search App
//
//  Created by Kenichi Fujita on 2/12/21.
//

import Foundation

// This protocol is to mock URLSession to inject for unit test.
protocol URLSessionProtocol {
    func dataTask(url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}

protocol URLSessionDataTaskProtocol {
    func cancel()
}

extension URLSession: URLSessionProtocol {

    // This method is identical with the original method of URLSession.
    func dataTask(url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        let task = dataTask(with: url, completionHandler: completionHandler)
        task.resume()
        return task
    }

}

extension URLSessionDataTask: URLSessionDataTaskProtocol { }
