import Foundation
@testable import Data
import XCTest

final class URLTests: XCTestCase {
    
    func testCategoriesURL() {
        XCTAssertEqual(
            URL.buildCategoriesURL().absoluteString,
            "https://raw.githubusercontent.com/leboncoin/paperclip/master/categories.json"
        )
    }
    
    func testListingURL() {
        XCTAssertEqual(
            URL.buildListingURL().absoluteString,
            "https://raw.githubusercontent.com/leboncoin/paperclip/master/listing.json"
        )
    }
}
