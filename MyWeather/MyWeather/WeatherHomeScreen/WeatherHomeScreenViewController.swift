//
//  WeatherHomeScreenViewController.swift
//  MyWeather
//
//  Created by Kiasha Rangasamy on 2024/08/13.
//

import UIKit
import CoreData

class WeatherHomeScreenViewController: UIViewController {
    
    var favouriteCityName: String = ""
    
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
    
    private let favouritesModel = WeatherFavouritesScreenViewModel()
    
    private var weatherConditionInit: String = ""
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
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
        favouritesModel.addFavouriteCity(cityName)
        print("Cities Saved to favorites: ")
        print(favouritesModel.getFavouriteCities())
        
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
    func setweatherConditionInit(_ text: String) {
        weatherConditionInit = text
    }
    func getweatherConditionInit() ->String {
        return weatherConditionInit
    }
   
    private lazy var viewModel = WeatherHomeScreenViewModel(repository: WeatherHomeScreenRepository(), delegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupThemeSlider()
        setUpTableView()
        viewModel.weatherStats()
        setupbackgroundImage()
       
//        updateTheme(for: getweatherConditionInit())
        themeSlider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        saveCity.addTarget(self, action: #selector(saveCityButtonTapped(_:)), for: .touchUpInside)
    }
    
    private func setupbackgroundImage() {
        backgroundImage.image = UIImage(named: "forest_sunny")
    }
    
    private func setupThemeSlider() {
        themeSlider.minimumValue = 0
        themeSlider.maximumValue = 1
        themeSlider.value = 0
        themeSlider.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc private func sliderValueChanged(_ sender: UISlider) {
        let themeName = sender.value > 0.5 ? "sea_sunny" : "forest_sunny"
        backgroundImage.image = UIImage(named: themeName)

        let backgroundColour = sender.value > 0.5 ? UIColor.seaTheme : UIColor.sunny
       
        view.backgroundColor = backgroundColour
        tableView.backgroundColor = backgroundColour
        
        // Ensure the table view background is updated
        
        tableView.layer.setNeedsDisplay()
        
        // Reload the table data if needed
        tableView.reloadData()
    }

    private func setUpTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(WeatherHomeScreenTableViewCell.tableViewNib(), forCellReuseIdentifier: TableViewIdentifiers.WeatherHomeScreenTableViewCell)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func updateTheme(for condition: String) {
        
        backgroundImage.image = WeatherResponses.themeForCondition(condition)
        
        view.backgroundColor = WeatherResponses.colorForCondition(condition)
        tableView.backgroundColor = WeatherResponses.colorForCondition(condition)
        
        tableView.reloadData()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "displayFavouritesScreen" {
                if let destinationVC = segue.destination as? WeatherFavouritesScreenViewController {
                    destinationVC.favouriteCityName = self.getCityLocation() ?? ""
                    print( destinationVC.favouriteCityName)
                }
            }
    }
}


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
        
        if viewModel.isCityFavourite(cityName) {
            showAlert(title: "Already Added", message: "\(cityName) is already in your favourites.")
        } else {
            viewModel.addFavouriteCity(cityName)
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
        cell.contentView.backgroundColor = tableView.backgroundColor
        cell.backgroundColor = tableView.backgroundColor
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
                setweatherConditionInit(WeatherResponses.weatherCondition(for: weatherId))
                print(  getweatherConditionInit())
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
        self.loadingSpinner.isHidden = true
    }
    
    func show(error: String) {
        print("An error occured")
    }
}
