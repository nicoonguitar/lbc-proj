import Foundation
import UIKit

enum ImageLoaderError: Error, Equatable {
    case badImage
}

actor ImageLoader {
    enum State {
        case inProgress(Task<UIImage, Error>)
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
