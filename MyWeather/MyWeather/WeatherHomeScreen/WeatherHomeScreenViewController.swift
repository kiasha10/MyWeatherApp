//
//  WeatherHomeScreenViewController.swift
//  MyWeather
//
//  Created by Kiasha Rangasamy on 2024/08/13.
//

import UIKit
import CoreData

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
    var favouriteCityName: String = ""
    private let favouritesModel = WeatherFavouritesScreenViewModel()
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
//        var currentCity: String = "New York"
    
    @IBAction func saveCityButtonTapped(_ sender: UIButton) {
        saveCurrentCityToFavourites()
    }
    
    private func saveCurrentCityToFavourites() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("Failed to retrieve AppDelegate")
            return
        }
        
        guard let cityName = getCityLocation() else {
            showAlert(title: "Error", message: "City Name Not Found")
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        
        let weatherForecast = WeatherForecast(context: context)
        
        weatherForecast.cityLocation = cityName
        favouritesModel.addFavoriteCity(cityName)
        print("Cities Saved to favorites: ")
        print(favouritesModel.getFavoriteCities())
        
        
        do {
            try context.save()
            showAlert(title: "Success", message: "City has been saved to Favourites")
        } catch {
            showAlert(title: "Error", message: "Failed to add City to Favourites")
        }
    }

    
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
    
    func getFavouriteCity() -> String? {
        return favouriteCityName
    }
    
    func setFavoriteCity(_ text: String) -> String? {
        favouriteCityName=text
        return favouriteCityName
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
        setUpTableView()
        viewModel.weatherStats()
//        tableView.dataSource = self
//        tableView.delegate = self
        saveCity.addTarget(self, action: #selector(saveCityButtonTapped(_:)), for: .touchUpInside)
    }
    
    private func setUpTableView() {
        tableView.register(WeatherHomeScreenTableViewCell.tableViewNib(), forCellReuseIdentifier: TableViewIdentifiers.WeatherHomeScreenTableViewCell)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "displayFavouritesScreen" {
                if let destinationVC = segue.destination as? WeatherFavouritesScreenViewController {
                    // Pass the favorite city name or other relevant data
                    destinationVC.favouriteCityName = self.getCityLocation() ?? ""
                    print( destinationVC.favouriteCityName)
                }
            }
    }
}


//override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    if segue.identifier == "displayFavouritesScreen" {
//        if let destinationVC = segue.destination as? WeatherFavouritesScreenViewController {
//            // Pass the favorite city name
//            destinationVC.favouriteCityName = self.getCityLocation() ?? ""
//            
//            // Pass the current temperature
//            if let currentTempText = currentTemp.text,
//               let currentTempValue = Double(currentTempText.replacingOccurrences(of: "°C", with: "")) {
//                destinationVC.currentTemperature = currentTempValue
//            }
//            
//            // Pass the weather condition
//            destinationVC.weatherCondition = self.getWeatherCondition() ?? ""
//        }
//    }
//}

extension WeatherHomeScreenViewController : UITableViewDelegate, UITableViewDataSource {
    
    func goToFavoritesButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: SegueIdentifiers.favouritesScreenIdentifier, sender: self)
    }
    
    func addToFavoritesButtonTapped(_ sender: UIButton) {
        guard let cityName = getCityLocation() else {
            showAlert(title: "Error", message: "City Name Not Found")
            return
        }

        let viewModel = WeatherFavouritesScreenViewModel()
        
        if viewModel.isCityFavorite(cityName) {
            showAlert(title: "Already Added", message: "\(cityName) is already in your favourites.")
        } else {
            viewModel.addFavoriteCity(cityName)
            showAlert(title: "Success", message: "\(cityName) has been added to your favorites.")
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
        print(viewModel.cityName)
        
        if let currentWeather = viewModel.currentWeather {
            let tempCelsius = fahrenheitToCelsius(currentWeather.main.temp) / 10
            setMainTemp(String(format: "%.1f°C", tempCelsius))
            
            if let weatherId = currentWeather.weather.first?.id {
                print(weatherId)
                setWeatherCondition(WeatherResponses.weatherCondition(for: weatherId).capitalized)
                print(WeatherResponses.weatherCondition(for: weatherId).capitalized)
            }
            
            let minTempCelsius = fahrenheitToCelsius(currentWeather.main.temp_min) / 10
            let maxTempCelsius = fahrenheitToCelsius(currentWeather.main.temp_max) / 10
            let currentTemp = fahrenheitToCelsius(currentWeather.main.temp) / 10
          
            setMinTemp(String(format: "%.1f°C", minTempCelsius))
            setMaxTemp(String(format: "%.1f°C", maxTempCelsius))
            setCurrentTemp(String(format: "%.1f°C", currentTemp))
        }
        
        tableView.reloadData()
    }
    
    func show(error: String) {
        print("An error occured")
    }
}
