//
//  SavedViewController.swift
//  Movien
//
//  Created by Асыланбек Нурмухамбет on 5/31/21.
//  Copyright © 2021 kbtu.edu.as1k.kz. All rights reserved.
//

import UIKit

class FavoritesViewContriller: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var movies: [Movie] = []
    let client = Service()
    var cancelRequest: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchFavorites()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    func fetchFavorites() {
        Service.fetchFavorites(with: Api.ACCOUNT_ID) { (movies) in
            guard let fetchedMovies = movies else { return }
            self.movies = fetchedMovies
            print(fetchedMovies)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "savedCell", for: indexPath) as! SavedCell
        let movie = movies[indexPath.row]
        cell.movie = movie
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard movies.count > indexPath.row else { return }
        let movie = movies[indexPath.row]
        guard let detailVC = storyboard?.instantiateViewController(withIdentifier: "movieDetail") as? DetailViewController else { return }
        detailVC.movie = movie
        detailVC.movieID = movie.id
        self.showDetailViewController(detailVC, sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
}
