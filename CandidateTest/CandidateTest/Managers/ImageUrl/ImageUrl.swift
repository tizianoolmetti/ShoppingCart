//
//  ImageUrl.swift
//  CandidateTest
//
//  Created by Tom Olmetti on 15/11/2024.
//

import SwiftUI

struct ImageUrl<Placeholder: View, LoadedImage: View>: View {
    // MARK: Properties
    private let url: String
    private let placeholderContent: () -> Placeholder
    private let loadedContent: (UIImage) -> LoadedImage
    
    // MARK: - State Object
    @StateObject private var imageLoader: ImageLoader
    
    // MARK: Initialization
    init(
        _ url: String,
        cache: ImageCaching = ImageCache.shared,
        @ViewBuilder placeholder: @escaping () -> Placeholder,
        @ViewBuilder content: @escaping (UIImage) -> LoadedImage
    ) {
        self.url = url
        self.placeholderContent = placeholder
        self.loadedContent = content
        _imageLoader = StateObject(wrappedValue: ImageLoader(cache: cache))
    }
    
    // MARK: Body
    var body: some View {
        Group {
            if let image = imageLoader.image {
                loadedContent(image)
                    .transition(.opacity.combined(with: .scale(scale: 0.95)))
            } else {
                placeholderContent()
            }
        }
        .animation(.easeInOut(duration: 0.3), value: imageLoader.image != nil)
        .onAppear {
            imageLoader.loadImage(from: url)
        }
        .onDisappear {
            imageLoader.cancel()
        }
    }
}

// MARK: - Convenience Initializers
extension ImageUrl where Placeholder == AnyView, LoadedImage == AnyView {
    init(
        _ url: String,
        cache: ImageCaching = ImageCache.shared
    ) {
        self.init(
            url,
            cache: cache,
            placeholder: {
                AnyView(
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .overlay(
                            ProgressView()
                        )
                )
            },
            content: { image in
                AnyView(
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                )
            }
        )
    }
}

// MARK: - Image Caching Protocol
protocol ImageCaching {
    func set(_ image: UIImage, for key: String)
    func get(_ key: String) -> UIImage?
}

// MARK: - Default Image Cache
final class ImageCache: ImageCaching {
    // MARK: - Properties
    static let shared = ImageCache()
    private let cache = NSCache<NSString, UIImage>()
    
    // MARK: - Initialization
    private init() {
        cache.countLimit = 100 // Maximum number of images
        cache.totalCostLimit = 1024 * 1024 * 100 // 100 MB
    }
    
    // MARK: - Methods
    func set(_ image: UIImage, for key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
    
    func get(_ key: String) -> UIImage? {
        cache.object(forKey: key as NSString)
    }
}

// MARK: - Image Loader
final class ImageLoader: ObservableObject {
    // MARK: Published
    @Published private(set) var image: UIImage?
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?
    
    // MARK: Properties
    private let cache: ImageCaching
    private var cancellable: URLSessionDataTask?
    
    // MARK: Initialization
    init(cache: ImageCaching) {
        self.cache = cache
    }
    
    // MARK: Methods
    func loadImage(from urlString: String) {
        if let cachedImage = cache.get(urlString) {
            self.image = cachedImage
            return
        }
        
        guard let url = URL(string: urlString) else {
            self.error = URLError(.badURL)
            return
        }
        
        cancellable?.cancel()
        isLoading = true
        error = nil
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.error = error
                    return
                }
                
                guard let data = data,
                      let image = UIImage(data: data) else {
                    self?.error = URLError(.cannotDecodeRawData)
                    return
                }
                
                self?.cache.set(image, for: urlString)
                self?.image = image
            }
        }
        
        self.cancellable = task
        task.resume()
    }
    
    func cancel() {
        cancellable?.cancel()
        isLoading = false
    }
    
    deinit {
        cancel()
    }
}
