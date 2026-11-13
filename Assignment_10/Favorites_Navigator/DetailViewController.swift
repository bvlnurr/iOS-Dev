//
//  DetailViewController.swift
//  Favorites_Navigator
//
//  Created by Балнур on 10.11.2026.
//

import UIKit

class DetailViewController: UIViewController {

    var item: FavoriteItem?

    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var ratingStackView: UIStackView!
    @IBOutlet weak var descriptionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let item else { return }

        navigationItem.title = item.title
        navigationItem.largeTitleDisplayMode = .never

        movieImageView.image = UIImage(named: item.sceneImageName)
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
        descriptionLabel.text = item.description

        for (index, view) in ratingStackView.arrangedSubviews.enumerated() {
            guard let star = view as? UIImageView else { continue }

            let symbolName = index < item.rating ? "star.fill" : "star"

            star.image = UIImage(systemName: symbolName)
            star.tintColor = .systemYellow
        }
    }
}


