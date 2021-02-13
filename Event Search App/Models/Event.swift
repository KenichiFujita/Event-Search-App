//
//  Event.swift
//  Event Search App
//
//  Created by Kenichi Fujita on 2/12/21.
//

import Foundation

struct Event: Decodable{

    let id: Int
    let title: String
    let datetimeLocal: Date
    let venue: Venue
    let performers: [Performer]

}

extension Event {

    var place: String {
        if let city = venue.city, let state = venue.state {
            return "\(city), \(state)"
        }
        return ""
    }

}

struct Venue: Decodable {

    let state: String?
    let city: String?

}

struct Performer: Decodable {

    let image: String?

}
