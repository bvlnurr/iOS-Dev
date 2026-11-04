//
//  ViewController.swift
//  Favorites List
//
//  Created by Балнур on 02.11.2026.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        FavoriteData.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath) as! FavoriteCell
        cell.configure(with: FavoriteData.items[indexPath.row])
        return cell
    }
}
