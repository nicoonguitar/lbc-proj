import Foundation

protocol APIClient: AnyObject {
    
    func categories() async throws -> [ApiCategory]
    
    func items() async throws -> [ApiClassifiedAd]
}
