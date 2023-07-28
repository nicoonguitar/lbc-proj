import Foundation

extension URL {
    static func buildCategoriesURL() -> URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "raw.githubusercontent.com"
        urlComponents.path = "/leboncoin/paperclip/master/categories.json"
        // it's ok to force unwrap as the correct URL initialization is checked by a unit test
        return urlComponents.url!
    }
    
    static func buildItemsURL() -> URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "raw.githubusercontent.com"
        urlComponents.path = "/leboncoin/paperclip/master/listing.json"
        // it's ok to force unwrap as the correct URL initialization is checked by a unit test
        return urlComponents.url!
    }
}

final class APIClientImpl: APIClient {
    
    private let urlSession: URLSession
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        configuration.timeoutIntervalForRequest = 10
        urlSession = URLSession(configuration: configuration)
    }
    
    private func request<T: Decodable>(url: URL) async throws -> T {
        let (data, _) = try await urlSession.data(from: url)
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    func categories() async throws -> [ApiCategory] {
        try await request(url: URL.buildCategoriesURL())
    }
    
    func items() async throws -> [ApiItem] {
        try await request(url: URL.buildItemsURL())
    }
}
