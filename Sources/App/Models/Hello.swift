import Vapor

struct Hello: Content {
    var tokenSent: String?
    var pathParamSent: String?
    var queryParamSent: String?
    var riders: [Rider]?
    var message: String

    internal init(tokenSent: String?, pathParamSent: String?, queryParamSent: String?, riders: [Rider]?, message: String) {
        self.tokenSent = tokenSent
        self.pathParamSent = pathParamSent
        self.queryParamSent = queryParamSent
        self.riders = riders
        self.message = message
    }
}
