import Vapor

struct Datetime: Content {
    var datetime: String
    var timezone: String
}
