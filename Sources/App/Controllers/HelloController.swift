import Vapor

struct HelloController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let helloRoutes = routes
            .grouped(ExampleUserAuthenticator())
            .grouped(User.guardMiddleware())
            .grouped("hello")

        helloRoutes.get(use: index)
        helloRoutes.post(":pathParam", use: post)
        helloRoutes.get("with-datetime", use: withDatetime)
    }

    func index(req: Request) throws -> Hello {
        let user = try req.auth.require(User.self)
        let helloGetRequest = try req.query.decode(HelloGetRequest.self)

        return Hello(
            tokenSent: user.token,
            pathParamSent: nil,
            queryParamSent: helloGetRequest.queryParam,
            datetime: nil,
            message: "Hello, world!"
        )
    }

    func post(req: Request) throws -> Hello {
        let user = try req.auth.require(User.self)
        do {
            try HelloPostRequest.Body.validate(content: req)
            let body = try req.content.decode(HelloPostRequest.Body.self)

            return Hello(
                tokenSent: user.token,
                pathParamSent: req.parameters.get("pathParam"),
                queryParamSent: nil,
                datetime: nil,
                message: "Hello, \(body.firstname) \(body.lastname)!"
            )
        } catch let error as DecodingError {
            throw Error.requestDecodingError("Cannot decode request body - \(error.description)")
        }
    }

    func withDatetime(req: Request) throws -> EventLoopFuture<Hello> {
        let user = try req.auth.require(User.self)
        let helloGetRequest = try req.query.decode(HelloGetRequest.self)
        let datetimeURI = URI(string: "http://worldtimeapi.org/api/ip")

        return req.client.get(datetimeURI, headers: req.miaHeaders)
            .flatMapThrowing { response -> Datetime in
                if response.status != .ok {
                    throw Error.crudCallError("Cannot get datetime")
                }
                do {
                    return try response.content.decode(Datetime.self)
                } catch let error as DecodingError {
                    throw Error.modelDecodingError("Cannot decode Datetime - \(error.description)")
                }
            }
            .map { datetime in
                return Hello(
                    tokenSent: user.token,
                    pathParamSent: nil,
                    queryParamSent: helloGetRequest.queryParam,
                    datetime: datetime,
                    message: "Hello, world!"
                )
            }
    }
}
