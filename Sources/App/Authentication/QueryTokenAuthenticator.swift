import Vapor

struct User: Authenticatable {
    var token: String
}

struct QueryParamTokenAuthenticator: RequestAuthenticator {
    func authenticate(request: Request) -> EventLoopFuture<Void> {
        if let token: String = request.query["token"], token != "invalid" {
            request.auth.login(User(token: token))
        }
        return request.eventLoop.makeSucceededFuture(())
    }
}
