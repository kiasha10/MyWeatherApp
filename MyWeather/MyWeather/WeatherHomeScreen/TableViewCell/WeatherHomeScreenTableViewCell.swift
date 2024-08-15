//
//  WeatherHomeScreenTableViewCell.swift
//  MyWeather
//
//  Created by Kiasha Rangasamy on 2024/08/13.
//

import UIKit

class WeatherHomeScreenTableViewCell: UITableViewCell {

    var weatherViewController: WeatherHomeScreenViewController?
    
    // MARK: IBOutlets
    
    @IBOutlet weak var dayOfWeek: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var temperature: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(city: City) {
        weatherViewController?.setCityLocation("\(city.name)")
    }
    
    func configure(weather: WeatherData) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = dateFormatter.date(from: weather.dt_txt) {
            dateFormatter.dateFormat = "EEEE"
            let dayOfWeekString = dateFormatter.string(from: date)
            dayOfWeek.text = dayOfWeekString
        } else {
            dayOfWeek.text = "Invalid Date"
        }

        let tempInCelsius = weather.main.temp - 273.15
        temperature.text = String(format: "%.1f°C", tempInCelsius)
        weatherViewController?.setMainTemp("\(weather.main.temp)")
        print(weatherViewController?.getMainTemp())
        weatherViewController?.setMinTemp("\(weather.main.temp_min)")
        weatherViewController?.setMaxTemp("\(weather.main.temp_max)")
        weatherViewController?.setCurrentTemp("\(weather.main.temp)")
        weatherViewController?.setCurrentTemp("\(weather.weather.description)")
    }
    
    

    static func tableViewNib() -> UINib {
        UINib(nibName: TableViewIdentifiers.WeatherHomeScreenTableViewCell, bundle: nil)
    }
}
