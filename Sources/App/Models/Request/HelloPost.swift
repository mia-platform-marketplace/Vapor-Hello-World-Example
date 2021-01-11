import Vapor

struct HelloPost {
    struct Body: Content {
        var firstname: String
        var lastname: String
    }
}
