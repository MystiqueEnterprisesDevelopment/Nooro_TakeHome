import Foundation

actor AppRepository {
  struct Keys {
    static let cityName = "cityName"
    static let iconURL = "iconURL"
    static let lastTemp = "lastTemperature"
  }
  
  private let baseURLString = "https://api.weatherapi.com/v1"
  
  func getWeatherDetails(forCity city: String) async -> CityWeatherModel? {
    let request = makeGetWeatherForCityRequest(city: city)
    
    do {
      let (data, _) = try await URLSession.shared.data(for: request)
      let decoder = JSONDecoder()
      let result = try decoder.decode(WeatherDetailDTO.self, from: data)
      
      var details: [String: String] = [:]
      
      details["Humidity"] = String(result.current.humidity.rounded()) + "%"
      details["UV"] = String(result.current.uv.rounded()) + "\u{00B0}"
      details["Feels Like"] = String(result.current.feelslike_c.rounded()) + "\u{00B0}"
      
      let temperature = String(result.current.temp_c.rounded())
      let urlForIcon: URL? = correctIconURL(result.current.condition.icon)
      
      return CityWeatherModel(weatherIconURL: urlForIcon, cityName: result.location.name, temperature: temperature, weatherDetails: details)
    } catch {
      return nil
    }
    
  }
  
  private func correctIconURL(_ urlStr: String) -> URL? {
    if urlStr.hasPrefix("https://") {
      return URL(string: urlStr)
    } else {
      if let domain = urlStr.split(separator: "//").first {
        return URL(string: "https://\(domain)")
      } else {
        return nil
      }
    }
  }
  
  func saveCity(_ result: CityWeatherModel) {
    UserDefaults.standard.set(result.cityName, forKey: Keys.cityName)
    UserDefaults.standard.set(result.weatherIconURL, forKey: Keys.iconURL)
    UserDefaults.standard.set(result.temperature, forKey: Keys.lastTemp)
  }
  
  func getPersistedCity() -> PersistedCityModel? {
    if let city = UserDefaults.standard.string(forKey: Keys.cityName),
       let lastTemp = UserDefaults.standard.string(forKey: Keys.lastTemp) {
      
      let icnURLStr = UserDefaults.standard.string(forKey: Keys.iconURL)
      var iconURL: URL? = nil
      
      if let iconURLStr = icnURLStr, let url = URL(string: iconURLStr) {
        iconURL = url
      }
      
      return PersistedCityModel(cityName: city, iconURL: iconURL, temperature: lastTemp)
    }
    
    return nil
  }
  
  func getSearchResults(searchString: String) async -> [CityWeatherModel] {
    guard let weather = await self.getWeatherDetails(forCity: searchString) else {
      return []
    }
    
    return [
      weather
    ]
  }
  
  func makeGetWeatherForCityRequest(city: String) -> URLRequest {
    guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "weather-api-key") as? String else {
      fatalError("Missing api key")
    }
    return URLRequest(url: URL(string: "\(baseURLString)/current.json?key=\(apiKey)&q=\(city)")!)
  }

}


