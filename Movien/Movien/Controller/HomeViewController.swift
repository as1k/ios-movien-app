//
//  HomeViewController.swift
//  Movien
//
//  Created by Асыланбек Нурмухамбет on 4/29/21.
//  Copyright © 2021 kbtu.edu.as1k.kz. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    var categories = [
        "",
        "Top Rated".localized(),
        "Now Playing".localized(),
        "Trending".localized(),
        "Popular Celebrities".localized()
    ]
    
    @IBOutlet weak var mainTableView: UITableView!
    
    let client = Service()
    var movies: [Movie] = []
   
    
    var cancelRequest: Bool = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cancelRequest = false
        
        if NetworkCheck.isConnectedToNetwork() {
            print("You have internet connection!".localized())
        } else {
            print("No internet connection!".localized())
            connectionAlert()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTableView.reloadData()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cancelRequest = true
    }
    
}

extension HomeViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "upcomingCell") as!  UpcomingRow
            return cell
        }
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "topRatedCell") as! TopRatedRow
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! NowPlayingRow
            return cell
        } else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "trendingCell") as! TrendingRow
        
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell") as! ActorsRow
            return cell
        }
    }
    

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.darkGray
        header.textLabel?.font = UIFont(name: "Mosk Normal 400", size: 24)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return nil
        } else {
           return categories[section]
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 395
        }
        if indexPath.section == 4 {
            return 90
        }
        return 145
    }
}

extension String {
    func localized() -> String {
        return NSLocalizedString(
            self,
            tableName: "Localizable",
            bundle: .main,
            value: self,
            comment: self
        )
    }
}
