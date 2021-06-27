import Vapor

struct Hello: Content {
    var tokenSent: String?
    var pathParamSent: String?
    var queryParamSent: String?
    var datetime: Datetime?
    var message: String
}
