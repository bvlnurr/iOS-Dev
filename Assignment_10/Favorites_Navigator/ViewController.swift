//
//  ViewController.swift
//  Favorites_Navigator
//
//  Created by Балнур on 10.11.2026.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let movies = MovieData.movies
    var filteredMovies: [FavoriteItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "My Movies"

        navigationController?.navigationBar.prefersLargeTitles = true

        tableView.dataSource = self
        tableView.delegate = self
        filteredMovies = movies
        searchBar.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    
    override func prepare(
        for segue: UIStoryboardSegue,
        sender: Any?
    ) {
        super.prepare(for: segue, sender: sender)

        if segue.identifier == "showDetail" {

            guard let detailVC = segue.destination as? DetailViewController,
                  let indexPath = tableView.indexPathForSelectedRow
            else {
                return
            }

            let selectedMovie = filteredMovies[indexPath.row]

            detailVC.item = selectedMovie
        }
    }

}

extension ViewController: UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return filteredMovies.count
    }

    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "MovieCell",
            for: indexPath
        ) as? MovieTableViewCell else {
            return UITableViewCell()
        }

        let movie = filteredMovies[indexPath.row]

        cell.configure(with: movie)

        return cell
    }

}

extension ViewController: UITableViewDelegate {

}


extension ViewController: UISearchBarDelegate {

    func searchBar(
        _ searchBar: UISearchBar,
        textDidChange searchText: String
    ) {
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            filteredMovies = movies
        } else {
            filteredMovies = movies.filter {
                $0.title.localizedCaseInsensitiveContains(searchText)
            }
        }

        tableView.reloadData()
    }

    func searchBarSearchButtonClicked(
        _ searchBar: UISearchBar
    ) {
        searchBar.resignFirstResponder()
    }
}

