//
//  WeatherHomeScreenViewController.swift
//  MyWeather
//
//  Created by Kiasha Rangasamy on 2024/08/13.
//

import UIKit

class WeatherHomeScreenViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var saveCity: UIButton!
    @IBOutlet private weak var themeSlider: UISlider!
    @IBOutlet private weak var favouritesButton: UIButton!
    @IBOutlet private weak var cityLocation: UILabel!
    @IBOutlet private weak var backgroundImage: UIImageView!
    @IBOutlet private weak var mainTemp: UILabel!
    @IBOutlet private weak var weatherCondition: UILabel!
    @IBOutlet private weak var minTemp: UILabel!
    @IBOutlet private weak var currentTemp: UILabel!
    @IBOutlet private weak var maxTemp: UILabel!
    @IBOutlet private weak var loadingSpinner: UIActivityIndicatorView!
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: Getters
    
    func getCityLocation() -> String? {
        return cityLocation.text
    }
    
    func getBackgroundImage() -> UIImage? {
        return backgroundImage.image
    }
    
    func getMainTemp() -> String? {
        return mainTemp.text
    }
    
    func getWeatherCondition() -> String? {
        return weatherCondition.text
    }
    
    func getMinTemp() -> String? {
        return minTemp.text
    }
    
    func getCurrentTemp() -> String? {
        return currentTemp.text
    }
    
    func getMaxTemp() -> String? {
        return maxTemp.text
    }
    
    // MARK: Setters
    
    func setCityLocation(_ text: String) {
        cityLocation.text = text
    }
    
    func setBackgroundImage(_ image: UIImage) {
        backgroundImage.image = image
    }
    
    func setMainTemp(_ text: String) {
        mainTemp.text = text
    }
    
    func setWeatherCondition(_ text: String) {
        weatherCondition.text = text
    }
    
    func setMinTemp(_ text: String) {
        minTemp.text = text
    }
    
    func setCurrentTemp(_ text: String) {
        currentTemp.text = text
    }
    
    func setMaxTemp(_ text: String) {
        maxTemp.text = text
    }
    
    
    private lazy var viewModel = WeatherHomeScreenViewModel(repository: WeatherHomeScreenRepository(), delegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        viewModel.weatherStats()
        setUpTableView()
    }
    
    private func setUpTableView() {
        tableView.register(WeatherHomeScreenTableViewCell.tableViewNib(), forCellReuseIdentifier: TableViewIdentifiers.WeatherHomeScreenTableViewCell)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFavoritesSegue" {
            if let destinationVC = segue.destination as? WeatherFavouritesScreenViewController {
            }
        }
    }
}

extension WeatherHomeScreenViewController : UITableViewDelegate, UITableViewDataSource {
    
    func goToFavoritesButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "showFavoritesSegue", sender: self)
    }
    
    func addToFavoritesButtonTapped(_ sender: UIButton) {
        let cityName = "Zocca"
        let viewModel = WeatherFavouritesScreenViewModel()
        
        if viewModel.isCityFavorite(cityName) {
            let alert = UIAlertController(title: "Already Added", message: "\(cityName) is already in your favorites.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        } else {
            viewModel.addFavoriteCity(cityName)
            let alert = UIAlertController(title: "Success", message: "\(cityName) has been added to your favorites.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfDays
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewIdentifiers.WeatherHomeScreenTableViewCell, for: indexPath) as? WeatherHomeScreenTableViewCell else {
            return UITableViewCell()
        }
        let weatherData = viewModel.fetchWeather(at: indexPath.row)
        cell.configure(weather: weatherData)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension WeatherHomeScreenViewController: ViewModelDelegate {
    func reloadView() {
        setCityLocation(viewModel.cityName)
        
        
        if let currentWeather = viewModel.currentWeather {
            let tempCelsius = fahrenheitToCelsius(currentWeather.main.temp) / 10
            setMainTemp(String(format: "%.1f°C", tempCelsius))
            
            if let weatherCondition = currentWeather.weather.first?.description {
                setWeatherCondition(weatherCondition.capitalized)
            }
            
            let minTempCelsius = fahrenheitToCelsius(currentWeather.main.temp_min) / 10
            let maxTempCelsius = fahrenheitToCelsius(currentWeather.main.temp_max) / 10
            
            setMinTemp(String(format: "%.1f°C", minTempCelsius))
            setMaxTemp(String(format: "%.1f°C", maxTempCelsius))
        }
        
        tableView.reloadData()
    }
    
    func show(error: String) {
        print("An error occured")
    }
}
