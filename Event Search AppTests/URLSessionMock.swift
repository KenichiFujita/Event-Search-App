//
//  URLSessionMock.swift
//  Event Search AppTests
//
//  Created by Kenichi Fujita on 2/13/21.
//

import Foundation

final class URLSessionMock: URLSessionProtocol {

    var data: Data?

    var error: Error?

    func dataTask(url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        // completionHandler is called from background in order to mock behavior of URLSession's method.
        DispatchQueue.global().async {
            completionHandler(self.data, nil, self.error)
        }
        return URLSessionDataTaskMock()
    }

}

final class URLSessionDataTaskMock: URLSessionDataTaskProtocol {

    // This property is used to confirm if the task is cancelled. 
    var cancelled: Bool = false

    func cancel() {
        cancelled = true
    }

}
