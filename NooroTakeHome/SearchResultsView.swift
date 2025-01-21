import SwiftUI

protocol SearchResultViewEventHandler {
  func processSearchResultItemSelection(_ item: CityWeatherModel) async
}

struct SearchResultItem: Identifiable {
  let id = UUID().hashValue
  var iconURL: URL?
  let cityName: String
  let temperature: String
}

struct SearchResultsView: View {
  var eventHandler: SearchResultViewEventHandler
  @State var searchResults: [CityWeatherModel] = []
  
  var body: some View {
    if searchResults.isEmpty {
      EmptyStateView(emptyStateViewModel: EmptyStateModel(headline: "No results", subtitle: "Please search again"))
    } else {
      List(searchResults) { item in
        SearchResultItemView(resultItem: item)
          .listRowSeparator(.hidden)
          .onTapGesture {
            Task {
              await eventHandler.processSearchResultItemSelection(item)
            }
          }
      }
      .scrollContentBackground(.hidden)
      .listRowBackground(Color.clear)
      .background(
        Color.white
      )
    }
  }
}

struct SearchResultItemView: View {
  let resultItem: CityWeatherModel
  
  var body: some View {
    HStack(content: {
      VStack(content: {
        Text(resultItem.cityName)
          .font(.title2)
          .frame(maxWidth: .infinity, alignment: .leading)
        Spacer(minLength: 8)
        Text(resultItem.temperature)
          .font(.largeTitle)
          .frame(maxWidth: .infinity, alignment: .leading)
      })
      Spacer()
      if let url = resultItem.weatherIconURL {
        AsyncCachableImage(url: url)
          .frame(width: 75, height: 75)
      } else {
        Image(systemName: "cloud.moon.rain.fill")
          .resizable()
          .frame(width: 75, height: 75)
      }
    })
    .padding()
    .background(
      RoundedRectangle(cornerRadius: 20)
        .foregroundStyle(Color(UIColor.secondarySystemBackground))
    )
  }
}
