import Vapor

struct Rider: Content {
    var _id: String
    var name: String
    var surname: String
    var email: String
    var phone: Int
    var trasportType: String
}
