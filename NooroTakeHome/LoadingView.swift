import SwiftUI

struct LoadingView: View {
  let message: String
  
  var body: some View {
    VStack {
      Spacer()
      ProgressView()
      Text(message)
        .font(.headline)
      Spacer()
    }
    .padding()
  }
}
