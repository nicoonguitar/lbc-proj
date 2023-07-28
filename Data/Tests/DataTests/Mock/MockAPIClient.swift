import Foundation
@testable import Data

final class MockAPIClient: APIClient {
    
    var categories: [ApiCategory] = []
    
    var items: [ApiClassifiedAd] = []
    
    func categories() async throws -> [ApiCategory] {
        categories
    }
    
    func classifiedAds() async throws -> [ApiClassifiedAd] {
        items
    }
}

