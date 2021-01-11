import Vapor

struct HelloGet: Content {
    var token: String?
    var queryParam: String?
}
