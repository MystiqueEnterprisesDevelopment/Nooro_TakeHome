import SwiftUI

final class ImageContainer {
  let img: Image
  
  init(img: Image) {
    self.img = img
  }
}

final class ImageCache {
  static let shared = ImageCache()
  private let cache: NSCache<NSString, ImageContainer> = NSCache<NSString,ImageContainer>()
  
  func cacheImage(url: URL, image: Image) -> Image {
    let container = ImageContainer(img: image)
    let key: NSString = NSString(string: url.absoluteString)
    cache.setObject(container, forKey: key)
    return container.img
  }
  
  func image(forURL url: URL) -> Image? {
    let key = NSString(string: url.absoluteString)
    return cache.object(forKey: key)?.img
  }
}

struct AsyncCachableImage: View {
  let url: URL
  
  private let imageCache = ImageCache.shared
  
  var body: some View {
    main()
  }
  
  @ViewBuilder
  private func main() -> some View {
    if let cachedImage =  imageCache.image(forURL: url) {
      cachedImage
        .resizable()
        .scaledToFit()
        .aspectRatio(contentMode: .fit)
    } else {
      AsyncImage(url: url) { phase in
        if let image = phase.image {
          imageCache.cacheImage(url: url, image: image)
            .resizable()
            .scaledToFit()
            .aspectRatio(contentMode: .fit)
         } else if phase.error != nil {
            errorImage
         } else {
             placeholder
         }
      }
    }
  }
  
  private let placeholder: some View = {
    Image(systemName: "hourglass.circle")
      .resizable()
      .scaledToFit()
      .aspectRatio(contentMode: .fit)
  }()
  
  private let errorImage: some View = {
    Image(systemName: "hazardsign")
      .resizable()
      .scaledToFit()
      .aspectRatio(contentMode: .fit)
  }()
}
