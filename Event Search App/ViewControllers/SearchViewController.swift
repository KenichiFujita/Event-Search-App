//
//  SearchViewController.swift
//  Event Search App
//
//  Created by Kenichi Fujita on 2/12/21.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var informationLabel: UILabel!

    private let viewModel: SearchViewModelType = SearchViewModel()

    private let favoritesStore = FavoritesStore()

    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = true
        return searchBar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .onDrag
        searchBar.delegate = self
        navigationItem.titleView = searchBar

        bind()
        // ViewController sends UI events to ViewModel
        viewModel.inputs.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Reload tableView to reflect favorites information after returning from EventViewController
        tableView.reloadData()
    }

    private func bind() {

        // ViewController receives actions from ViewModel.
        viewModel.outputs.reloadData = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.tableView.reloadData()
            strongSelf.informationLabel.isHidden = true
        }

        viewModel.outputs.showInstruction = { [weak self] text in
            guard let strongSelf = self else { return }
            strongSelf.informationLabel.text = text
            strongSelf.informationLabel.isHidden = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToEventViewController",
           let destination = segue.destination as? EventViewController,
           let cell = sender as? UITableViewCell,
           let indexPath = tableView.indexPath(for: cell) {
            destination.event = viewModel.outputs.events[indexPath.row]
            destination.favoritesStore = favoritesStore
        }
    }

}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.outputs.events.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath)
        guard let eventCell = cell as? EventCell else {
            return cell
        }
        let event = viewModel.outputs.events[indexPath.row]
        eventCell.configure(with: event, inFavorite: favoritesStore.has(id: event.id))
        return eventCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

extension SearchViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // ViewController sends UI events to ViewModel
        viewModel.inputs.textDidChange(searchText: searchText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }

}
