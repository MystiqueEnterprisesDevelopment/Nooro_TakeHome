import SwiftUI

@MainActor
class HomeViewModel: ObservableObject, SearchResultViewEventHandler {
  @Published var viewState: ViewState = .Loading("Loading...")
  @Published var searchString: String = ""

  private var searchResults: [SearchResultItem] = []
  private let repository = AppRepository()
  
  func startLoading() async {
    self.viewState = .Loading("Loading...")
    
    guard let savedCity = await repository.getPersistedCity() else {
      self.viewState = .EmptyState(EmptyStateModel(headline: "No City Selected", subtitle: "Please Search for a City"))
      return
    }
    
    self.viewState = .Loading("Loading weather for \(savedCity.cityName)...")

    guard let weather = await repository.getWeatherDetails(forCity: savedCity.cityName) else {
      self.viewState = .EmptyState(EmptyStateModel(headline: "Could not load weather for \(savedCity.cityName)", subtitle: "Please Try Searching again"))
      return
    }
    
    self.viewState = .CityWeatherDetail(weather)
  }
  
  func processSearch() async {
    self.viewState = .Loading("Searching for \(searchString)")
    let results = await repository.getSearchResults(searchString: searchString)
    self.viewState = .SearchResult(results)
  }
  
  func processSearchResultItemSelection(_ item: CityWeatherModel) async {
    await repository.saveCity(item)
    searchString = ""
    self.viewState = .CityWeatherDetail(item)
  }
  
}
