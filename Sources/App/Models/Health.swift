import Vapor

struct Health: Content {
    var serviceName: String
    var version: String
    var status: Status

    enum Status: String, Content {
        case OK
        case KO
    }

    init(serviceName: String, version: String, status: Status) {
        self.serviceName = serviceName
        self.version = version
        self.status = status
    }
}
