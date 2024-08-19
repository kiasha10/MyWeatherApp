import XCTest
@testable import MyWeather

final class WeatherHomeScreenViewModelTests: XCTestCase {
    
    var viewModel: WeatherHomeScreenViewModel!
    var mockRepository: MockWeatherHomeScreenRepository!
    var mockDelegate: MockViewModelDelegate!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockWeatherHomeScreenRepository()
        mockDelegate = MockViewModelDelegate()
        viewModel = WeatherHomeScreenViewModel(repository: mockRepository, delegate: mockDelegate)
    }
    
    override func tearDown() {
        viewModel = nil
        mockRepository = nil
        mockDelegate = nil
        super.tearDown()
    }
    
    func testFetchWeatherAtIndex() {
        
        let weatherData = WeatherData(
            dt: 12345,
            main: MainWeather(temp: 298.0, temp_min: 295.0, temp_max: 300.0),
            weather: [WeatherDescription(description: "clear sky", icon: "Clear", id: 800, main: "01d")],
            dt_txt: "2024-08-19 12:00:00"
        )
        viewModel.forecast = [weatherData]
        
        let fetchedWeather = viewModel.fetchWeather(at: 0)
        
        XCTAssertEqual(fetchedWeather.dt, weatherData.dt)
        XCTAssertEqual(fetchedWeather.main.temp, weatherData.main.temp)
        XCTAssertEqual(fetchedWeather.weather.first?.id, weatherData.weather.first?.id)
    }
    
    func testNumberOfDays() {

        let weatherData1 = WeatherData(
            dt: 12345,
            main: MainWeather(temp: 298.0, temp_min: 295.0, temp_max: 300.0),
            weather: [WeatherDescription(description: "clear sky", icon: "Clear", id: 800, main: "01d")],
            dt_txt: "2024-08-19 12:00:00"
        )
        let weatherData2 = WeatherData(
            dt: 67890,
            main: MainWeather(temp: 300.0, temp_min: 297.0, temp_max: 303.0),
            weather: [WeatherDescription(description: "few clouds", icon: "Few Clouds", id: 801, main: "02d")],
            dt_txt: "2024-08-20 12:00:00"
        )
        viewModel.forecast = [weatherData1, weatherData2]
        
        let numberOfDays = viewModel.numberOfDays
        
        XCTAssertEqual(numberOfDays, 2)
    }
    
    func testWeatherStatsSuccess() {
        
        let weatherStats = WeatherModel(
            city: City(id: 1, name: "New York", coord: Coordinate(lat: 40.7128, lon: -74.0060)),
            list: [
                WeatherData(
                    dt: 12345,
                    main: MainWeather(temp: 298.0, temp_min: 295.0, temp_max: 300.0),
                    weather: [WeatherDescription(description: "clear sky", icon: "Clear", id: 800, main: "01d")],
                    dt_txt: "2024-08-19 12:00:00"
                ),
                WeatherData(
                    dt: 67890,
                    main: MainWeather(temp: 300.0, temp_min: 297.0, temp_max: 303.0),
                    weather: [WeatherDescription(description: "few clouds", icon: "Few Clouds", id: 800, main: "02d")],
                    dt_txt: "2024-08-20 12:00:00"
                )
            ]
        )
        mockRepository.result = .success(weatherStats)
        

        viewModel.weatherStats()
        
        XCTAssertEqual(viewModel.cityName, "New York")
        XCTAssertEqual(viewModel.forecast.count, 2)
        XCTAssertEqual(viewModel.currentWeather?.main.temp, 299.0)
        XCTAssertTrue(mockDelegate.didReloadView)
    }
    
    func testWeatherStatsFailure() {

        mockRepository.result = .failure(.parsingError)
        
        viewModel.weatherStats()
        
        XCTAssertTrue(mockDelegate.didShowError)
        XCTAssertEqual(mockDelegate.errorMessage, "parsingError")
    }
}

    // MARK: Mock classes

class MockWeatherHomeScreenRepository: WeatherHomeScreenRepositoryType {
    var result: Result<WeatherModel, APIErrors>?
    
    func fetchWeatherForecast(completion: @escaping (Result<WeatherModel, APIErrors>) -> Void) {
        if let result = result {
            completion(result)
        }
    }
}

class MockViewModelDelegate: ViewModelDelegate {
    var didReloadView = false
    var didShowError = false
    var errorMessage: String?
    
    func reloadView() {
        didReloadView = true
    }
    
    func show(error: String) {
        didShowError = true
        errorMessage = error
    }
}
