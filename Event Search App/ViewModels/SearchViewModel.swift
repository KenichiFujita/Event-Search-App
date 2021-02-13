//
//  SearchViewModel.swift
//  Event Search App
//
//  Created by Kenichi Fujita on 2/12/21.
//

import Foundation

// These inputs outputs protocols force authors to reach the viewModel through inputs and outputs each time and that will make consistent style across the entire codebase.
protocol SearchViewModelType {
    var inputs: SearchViewModelInputs { get }
    var outputs: SearchViewModelOutputs { get }
}

protocol SearchViewModelInputs {
    func viewDidLoad()
    func textDidChange(searchText: String)
}

protocol SearchViewModelOutputs: AnyObject {
    var events: [Event] { get set }
    var reloadData: () -> Void { get set }
    var showInstruction: (String) -> Void { get set }
}

// ViewModel receives UI events from ViewController and do logic within ViewModel, then return actions.
final class SearchViewModel: SearchViewModelType, SearchViewModelOutputs {

    let api: SeatGeekAPI

    private var dataTask: URLSessionDataTaskProtocol?

    init(api: SeatGeekAPI = SeatGeekAPI()) {
        self.api = api
    }

    var inputs: SearchViewModelInputs { return self }

    var outputs: SearchViewModelOutputs { return self }

    var events: [Event] = []

    var reloadData: () -> Void = { }

    var showInstruction: (String) -> Void = { _ in }

}

extension SearchViewModel: SearchViewModelInputs {

    func viewDidLoad() {
        showInstruction(InformationText.instruction)
    }

    func textDidChange(searchText: String) {
        dataTask?.cancel()
        if searchText == "" {
            showInstruction(InformationText.instruction)
            return
        }
        dataTask = api.search(searchText) { [weak self] (result) in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedEvents):
                    if fetchedEvents.isEmpty {
                        strongSelf.showInstruction(InformationText.empty)
                    } else {
                        strongSelf.events = fetchedEvents
                        strongSelf.reloadData()
                    }
                case .failure(let error):
                    if error == .cancel {
                        return
                    } else {
                        strongSelf.showInstruction(InformationText.error)
                    }
                }
            }
        }

    }

}

extension SearchViewModel {

    private struct InformationText {

        static var instruction: String {
            "Type word to find events."
        }

        static var empty: String {
            "No events found."
        }

        static var error: String {
            "Sorry. Something went wrong."
        }

    }

}
