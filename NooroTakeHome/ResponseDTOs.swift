import Foundation

struct PersistedCityModel {
  var cityName: String
  var iconURL: URL?
  var temperature: String
}

struct LocationDTO: Codable {
  let name: String
}

struct WeatherDetailDTO: Codable {
  let location: LocationDTO
  let current: CurrentWeatherDTO
}

struct ConditionDTO: Codable {
  let text: String
  let icon: String
}

struct CurrentWeatherDTO: Codable {
  let temp_c: Float
  let condition: ConditionDTO
  let uv: Float
  let humidity: Float
  let feelslike_c: Float
}
