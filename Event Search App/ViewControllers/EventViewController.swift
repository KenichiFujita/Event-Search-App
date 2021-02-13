//
//  EventViewController.swift
//  Event Search App
//
//  Created by Kenichi Fujita on 2/12/21.
//

import UIKit

class EventViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var eventImageView: UIImageView!

    @IBOutlet weak var dateTimeLabel: UILabel!

    @IBOutlet weak var placeLabel: UILabel!

    var event: Event?

    var favoritesStore: FavoritesStore?

    let favoriteBarButtonItem = FavoriteBarButtonItem(image: UIImage(named: "heart.fill"), style: .plain, target: nil, action: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        favoriteBarButtonItem.target = self
        favoriteBarButtonItem.action = #selector(didTapFavoriteBarButton)
        navigationItem.rightBarButtonItem = favoriteBarButtonItem

        if let event = event {
            titleLabel.text = event.title
            dateTimeLabel.text = "\(event.datetimeLocal.formattedDate), \(event.datetimeLocal.formattedTime)"
            placeLabel.text = event.place
            if !event.performers.isEmpty, let urlString = event.performers[0].image {
                eventImageView.kf.setImage(with: URL(string: urlString))
            }
            if let favoritesStore = favoritesStore {
                favoriteBarButtonItem.inFavorite = favoritesStore.has(id: event.id)
            }
        }

    }

    @objc private func didTapFavoriteBarButton() {
        guard let id = event?.id, let favoritesStore = favoritesStore else { return }
        if favoritesStore.has(id: id) {
            favoritesStore.remove(id: id)
        } else {
            favoritesStore.add(id: id)
        }
        favoriteBarButtonItem.inFavorite = favoritesStore.has(id: id)
    }

}

final class FavoriteBarButtonItem: UIBarButtonItem {

    var inFavorite: Bool = false {
        didSet {
            tintColor = inFavorite ? .systemPink : .systemGray
        }
    }

}
