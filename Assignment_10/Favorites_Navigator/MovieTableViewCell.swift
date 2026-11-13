//
//  MovieTableViewCell.swift
//  Favorites_Navigator
//
//  Created by Балнур on 11.11.2026.
//


import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!

    func configure(with movie: FavoriteItem) {
        posterImageView.image = UIImage(named: movie.imageName)
        movieTitleLabel.text = movie.title
    }
}
