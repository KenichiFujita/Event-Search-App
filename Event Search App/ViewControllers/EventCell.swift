//
//  EventCell.swift
//  Event Search App
//
//  Created by Kenichi Fujita on 2/12/21.
//

import UIKit
import Kingfisher

class EventCell: UITableViewCell {

    @IBOutlet weak var eventImageView: UIImageView!

    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var placeLabel: UILabel!

    @IBOutlet weak var dateTimeLabel: UILabel!

    @IBOutlet weak var favoriteTagImageView: UIImageView!

    private var imageDownloadTask: DownloadTask?

    override func awakeFromNib() {
        super.awakeFromNib()

        eventImageView.layer.cornerRadius = 15
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        imageDownloadTask?.cancel()
        eventImageView.image = nil
        titleLabel.text = nil
        placeLabel.text = nil
        dateTimeLabel.text = nil
        favoriteTagImageView.isHidden = true
    }

    func configure(with event: Event, inFavorite: Bool) {
        if !event.performers.isEmpty, let urlString = event.performers[0].image {
            imageDownloadTask = eventImageView.kf.setImage(with: URL(string: urlString))
        }
        titleLabel.text = event.title
        placeLabel.text = event.place
        dateTimeLabel.text = "\(event.datetimeLocal.formattedDate)\n\(event.datetimeLocal.formattedTime)"
        favoriteTagImageView.isHidden = !inFavorite
    }

}
