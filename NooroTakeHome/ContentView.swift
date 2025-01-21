import SwiftUI

enum ViewState {
  case CityWeatherDetail(CityWeatherModel)
  case SearchResult([CityWeatherModel])
  case EmptyState(EmptyStateModel)
  case Loading(String)
}

struct ContentView: View {
  @StateObject var viewModel: HomeViewModel
  
  var body: some View {
    VStack(content: {
      searchField
      contentBody
    })
    .onAppear(perform: {
      Task {
        await viewModel.startLoading()
      }
    })
  }
  
  @ViewBuilder
  private var contentBody: some View {
    switch viewModel.viewState {
    case .CityWeatherDetail(let model):
      CityWeatherDetailView(viewModel: model)
    case .SearchResult(let results):
      SearchResultsView(eventHandler: viewModel, searchResults: results)
        .background(Color.white)
    case .EmptyState(let emptyStateModel):
      EmptyStateView(emptyStateViewModel: emptyStateModel)
    case .Loading(let message):
      LoadingView(message: message)
    }
  }
  
  @ViewBuilder
  private var searchField: some View {
    HStack(content: {
      TextField("Search...", text: $viewModel.searchString)
        .onSubmit {
          Task {
            await viewModel.processSearch()
          }
        }
      Image(systemName: "magnifyingglass")
        .frame(width: 30, height: 30)
        .onTapGesture {
          Task {
            await viewModel.processSearch()
          }
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
