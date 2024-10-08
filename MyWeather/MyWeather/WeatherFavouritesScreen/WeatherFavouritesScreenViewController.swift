//
//  WeatherFavouritesScreenViewController.swift
//  MyWeather
//
//  Created by Kiasha Rangasamy on 2024/08/15.
//

import UIKit

class WeatherFavouritesScreenViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel = WeatherFavouritesScreenViewModel()
    var favouriteCityName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        tableView.reloadData()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(WeatherFavouritesScreenTableViewCell.self, forCellReuseIdentifier: SegueIdentifiers.favouritesScreenIdentifier)
    }
}

extension WeatherFavouritesScreenViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getFavouriteCities().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SegueIdentifiers.favouritesScreenIdentifier, for: indexPath) as? WeatherFavouritesScreenTableViewCell else {
            return UITableViewCell()
        }
        let city = viewModel.getFavouriteCities()[indexPath.row]        
        cell.configure(with: city)
        return cell
    }
    
}
