import Foundation

protocol APIClient: AnyObject {
    
    func categories() async throws -> [ApiCategory]
    
    func classifiedAds() async throws -> [ApiClassifiedAd]
}
