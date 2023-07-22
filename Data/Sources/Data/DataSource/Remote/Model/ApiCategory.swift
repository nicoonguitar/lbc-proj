import Foundation

/*
 Int / Int64 should not matter on a 64bit platform
 https://stackoverflow.com/a/27440158/2616318
 
 Float is 32bits so it holds 8 positions max
 price=xxxxxx.xx -> 999999.99
 */

struct ApiCategory: Decodable, Equatable {
    
    let id: Int64
    
    let name: String
}
