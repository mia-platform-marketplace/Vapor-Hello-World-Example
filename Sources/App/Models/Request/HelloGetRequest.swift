import Vapor

struct HelloGetRequest: Content {
    var token: String?
    var queryParam: String?
}
