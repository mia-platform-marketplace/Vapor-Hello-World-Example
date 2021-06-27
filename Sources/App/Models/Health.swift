import Vapor

struct Health: Content {
    var serviceName: String
    var version: String
    var status: Status

    enum Status: String, Content {
        case OK
        case KO
    }
}
