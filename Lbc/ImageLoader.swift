import Foundation
import UIKit

enum ImageLoaderError: Error, Equatable {
    case badImage
}

/// The ImageLoader is a Swift implementation of an image loader with asynchronous capabilities using Swift's async and await pattern.
/// It allows you to fetch images from remote URLs and cache them for efficient reuse.
/// The loader is implemented as an actor, ensuring safe concurrent access to its internal state.
actor ImageLoader {
    
    /// An enumeration representing the state of an image loading operation.
    enum State {
        ///  Indicates that an image loading task is in progress and provides a Task representing the ongoing asynchronous image fetching operation.
        case inProgress(Task<UIImage, Error>)
        /// Indicates that the image has been successfully fetched and provides the fetched UIImage.
        case fetched(UIImage)
    }
    
    private let urlSession: URLSession
    
    private var images: [URL: State]
    
    static let shared: ImageLoader = .init(
        urlSession: .shared,
        images: [:]
    )
    
    init(
        urlSession: URLSession,
        images: [URL : State]
    ) {
        self.urlSession = urlSession
        self.images = images
    }
    
    public func fetch(_ url: URL) async throws -> UIImage {
        if let status = images[url] {
            switch status {
            case .fetched(let image):
                return image
            case .inProgress(let task):
                return try await task.value
            }
        }
        
        let task: Task<UIImage, Error> = Task {
            let request = URLRequest(url: url)
            let (imageData, _) = try await urlSession.data(for: request)
            guard let image = UIImage(data: imageData) else {
                throw ImageLoaderError.badImage
            }
            return image
        }
        
        images[url] = .inProgress(task)
        
        let image = try await task.value
        
        images[url] = .fetched(image)
        return image
    }
}
