import SwiftUI

struct EmptyStateModel {
  let headline: String
  let subtitle: String
}

struct EmptyStateView: View {
  let emptyStateViewModel: EmptyStateModel
  
  var body: some View {
    VStack(spacing: 16.0, content:  {
      Spacer()
      Text(emptyStateViewModel.headline)
        .font(.largeTitle)
      Text(emptyStateViewModel.subtitle)
        .font(.headline)
      Spacer()
    })
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    .padding()
  }
}
