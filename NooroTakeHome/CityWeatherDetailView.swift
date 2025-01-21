import SwiftUI

struct WeatherDetails: Identifiable {
  let id = UUID().hashValue
  let header: String
  let body: String
}

struct CityWeatherModel: Identifiable {
  let id = UUID().hashValue
  let weatherIconURL: URL?
  let cityName: String
  let temperature: String
  var weatherDetails: [WeatherDetails] = []
}

struct CityWeatherDetailView: View {
  let viewModel: CityWeatherModel
  
  var body: some View {
    VStack(spacing: 16, content: {
      Spacer()
      imageIcon
      HStack(content: {
        Text(viewModel.cityName)
          .font(Font.system(size: 30, weight: .bold))
        Image(systemName: "location.fill")
          .font(.title)
          .frame(width: 25, height: 25)
      })
    
      HStack(content: {
        Text(viewModel.temperature)
          .font(Font.system(size: 30, weight: .bold))
        Image(systemName: "degreesign.celsius")
          .font(.title)
      })
      
      weatherDetails
      Spacer()
    })
    .padding()
  }
  
  @ViewBuilder
  private var imageIcon: some View {
    if let url = viewModel.weatherIconURL {
      AsyncCachableImage(url: url)
        .frame(maxWidth: 100, maxHeight: 100)
    } else {
      Image(systemName: "cloud.moon.rain.fill")
        .resizable()
        .frame(maxWidth: 100, maxHeight: 100)
    }
  }
  
  @ViewBuilder
  private var weatherDetails: some View {
    HStack(spacing: 16.0, content: {
      ForEach(viewModel.weatherDetails) { item in
        VStack(alignment: .center, spacing: 16.0, content: {
          Text(item.header)
            .foregroundStyle(Color.gray)
          Text(item.body)
            .foregroundStyle(Color.gray)
        })
      }
    })
    
    .padding(24)
    .background(
      RoundedRectangle(cornerRadius: 20)
        .foregroundStyle(Color(UIColor.secondarySystemBackground))
    )
    .padding(24)
  }
}

