//
//  SeatGeekAPI.swift
//  Event Search App
//
//  Created by Kenichi Fujita on 2/12/21.
//

import Foundation

enum SeatGeekAPIError: Error {

    case invalidURL
    case domainError
    case cancel
    case decodingError
    case unknown

}


class SeatGeekAPI {

    let session: URLSessionProtocol

    init(session: URLSessionProtocol = URLSession(configuration: .default)) {
        self.session = session
    }

    @discardableResult func search(_ searchText: String, completionHandler: @escaping (Result<[Event], SeatGeekAPIError>) -> Void) -> URLSessionDataTaskProtocol? {
        guard let url = buildURL(with: searchText) else {
            completionHandler(.failure(.invalidURL))
            return nil
        }
        return session.dataTask(url: url) { (data, response, error) in
            guard let data = data else {
                if let error = error {
                    if (error as NSError).code == NSURLErrorCancelled {
                        completionHandler(.failure(.cancel))
                    } else {
                        completionHandler(.failure(.domainError))
                    }
                } else {
                    completionHandler(.failure(.unknown))
                }
                return
            }
            do {
                let searchResponse = try JSONDecoder.eventSearch.decode(SearchResponse.self, from: data)
                completionHandler(.success(searchResponse.events))
            }
            catch {
                completionHandler(.failure(.decodingError))
            }
        }
    }

    private func buildURL(with searchText: String) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.seatgeek.com"
        urlComponents.path = "/2/events"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "MjE1MzM3NzF8MTYxMjY1MTAxNC4zNzc3MjU"),
            URLQueryItem(name: "q", value: searchText.replacingOccurrences(of: " ", with: "+").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
        ]
        return urlComponents.url
    }

}

private struct SearchResponse: Decodable {

    let events: [Event]
    
}

extension JSONDecoder {

    static var eventSearch: JSONDecoder {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }

}
