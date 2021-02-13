//
//  SearchViewModelTests.swift
//  Event Search AppTests
//
//  Created by Kenichi Fujita on 2/13/21.
//

import XCTest
@testable import Event_Search_App

class SearchViewModelTests: XCTestCase {

    var session: URLSessionMock!
    var api: SeatGeekAPI!
    var viewModel: SearchViewModelType!

    override func setUpWithError() throws {
        session = URLSessionMock()
        api = SeatGeekAPI(session: session)
        viewModel = SearchViewModel(api: api)

        viewModel.outputs.reloadData = {
            XCTFail()
        }
        viewModel.outputs.showInstruction = { _ in
            XCTFail()
        }
    }

    override func tearDownWithError() throws {
        session.data = nil
        session.error = nil
    }

    var data: Data {
        return try! Foundation.Data(contentsOf: URL(fileURLWithPath: Bundle(for: SearchViewModelTests.self).path(forResource: "SuccessfulEventsData", ofType: "json")!))
    }

    var noData: Data {
        return try! Foundation.Data(contentsOf: URL(fileURLWithPath: Bundle(for: SearchViewModelTests.self).path(forResource: "NoEventsData", ofType: "json")!))
    }

    func testViewDidLoad() {
        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 1
        viewModel.outputs.showInstruction = { _ in
            expectation.fulfill()
        }
        viewModel.inputs.viewDidLoad()
        wait(for: [expectation], timeout: 1)
    }

    func testTextDidChange_WithError() {
        session.error = NSError(domain: "Test Error", code: 0)
        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 2
        viewModel.outputs.showInstruction = { _ in
            expectation.fulfill()
        }
        viewModel.inputs.viewDidLoad()
        viewModel.inputs.textDidChange(searchText: "test")
        wait(for: [expectation], timeout: 2)
    }

    func testTextDidChange_WhenSuccessfulDataFetched() {
        session.data = data
        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 2
        viewModel.outputs.showInstruction = { _ in
            expectation.fulfill()
        }
        viewModel.outputs.reloadData = {
            XCTAssertTrue(Thread.isMainThread)
            let dateComponents = DateComponents(timeZone: TimeZone(abbreviation: "UTC"),
                                                year: 2020,
                                                month: 1,
                                                day: 1,
                                                hour: 0,
                                                minute: 0)
            XCTAssertEqual(self.viewModel.outputs.events.count, 1)
            XCTAssertEqual(self.viewModel.outputs.events[0].id, 12345)
            XCTAssertEqual(self.viewModel.outputs.events[0].title, "Test Event")
            XCTAssertEqual(self.viewModel.outputs.events[0].datetimeLocal, Calendar.current.date(from: dateComponents))
            XCTAssertEqual(self.viewModel.outputs.events[0].venue.state, "Test State")
            XCTAssertEqual(self.viewModel.outputs.events[0].venue.city, "Test City")
            XCTAssertEqual(self.viewModel.outputs.events[0].performers[0].image, "https://seatgeek.com/images/test_image/123456789/huge.jpg")
            expectation.fulfill()
        }
        viewModel.inputs.viewDidLoad()
        viewModel.inputs.textDidChange(searchText: "test")
        wait(for: [expectation], timeout: 2)
    }

    func testTextDidChange_WithNoEvent() {
        session.data = noData
        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 2
        viewModel.outputs.showInstruction = { _ in
            XCTAssertTrue(Thread.isMainThread)
            expectation.fulfill()
        }
        viewModel.inputs.viewDidLoad()
        viewModel.inputs.textDidChange(searchText: "test")
        wait(for: [expectation], timeout: 1)
    }

    func testTextDidChange_WhenTaskCancelled() {
        let dataTask = URLSessionDataTaskMock()
        let api = SeatGeekAPIMock(dataTask: dataTask)
        let viewModel = SearchViewModel(api: api)
        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 2
        viewModel.outputs.showInstruction = { _ in
            expectation.fulfill()
        }
        // reloadData should be called only one time as it does nothing when task is cancelled.
        viewModel.outputs.reloadData = {
            expectation.fulfill()
        }
        viewModel.inputs.viewDidLoad()
        viewModel.inputs.textDidChange(searchText: "test")
        XCTAssertFalse(dataTask.cancelled)
        // This textDidChange will cancel the previous one.
        viewModel.inputs.textDidChange(searchText: "test")
        XCTAssertTrue(dataTask.cancelled)
        wait(for: [expectation], timeout: 3)
    }

}

final class SeatGeekAPIMock: SeatGeekAPI {

    let dataTask: URLSessionDataTaskMock

    init(dataTask: URLSessionDataTaskMock) {
        self.dataTask = dataTask
    }

    let event = Event(id: 0, title: "test", datetimeLocal: Date(), venue: Venue(state: nil, city: nil), performers: [])

    override func search(_ searchText: String, completionHandler: @escaping (Result<[Event], SeatGeekAPIError>) -> Void) -> URLSessionDataTaskProtocol? {
        // completionHandler is called delayed to simulate the fetching data process.
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            if self.dataTask.cancelled {
                self.dataTask.cancelled = false
                completionHandler(.failure(.cancel))
            } else {
                completionHandler(.success([self.event]))
            }
        }
        return dataTask
    }

}
