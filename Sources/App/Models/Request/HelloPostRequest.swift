import Vapor

struct HelloPostRequest {
    struct Body: Content {
        var firstname: String
        var lastname: String
    }
}
