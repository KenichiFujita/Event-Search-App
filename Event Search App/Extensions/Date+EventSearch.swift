//
//  Date+EventSearch.swift
//  Event Search App
//
//  Created by Kenichi Fujita on 2/12/21.
//

import Foundation

extension Date {

    var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "EEEE, d MMM yyyy"
        return dateFormatter.string(from: self)
    }

    var formattedTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: self)
    }

}
