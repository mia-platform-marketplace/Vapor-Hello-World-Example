import Vapor

struct HelloController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let helloRoutes = routes
            .grouped(ExampleUserAuthenticator())
            .grouped(User.guardMiddleware())
            .grouped("hello")

        helloRoutes.get(use: index)
        helloRoutes.post(":pathParam", use: post)
        helloRoutes.get("with-riders", use: withRiders)
    }

    func index(req: Request) throws -> Hello {
        let user = try req.auth.require(User.self)
        let helloGetRequest = try req.query.decode(HelloGetRequest.self)

        return Hello(
            tokenSent: user.token,
            pathParamSent: nil,
            queryParamSent: helloGetRequest.queryParam,
            riders: nil,
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
                riders: nil,
                message: "Hello, \(body.firstname) \(body.lastname)!"
            )
        } catch let error as DecodingError {
            throw Error.requestDecodingError("Cannot decode request body - \(error.description)")
        }
    }

    func withRiders(req: Request) throws -> EventLoopFuture<Hello> {
        let user = try req.auth.require(User.self)
        let helloGetRequest = try req.query.decode(HelloGetRequest.self)
        let ridersURI = URI(string: "https://demo.test.mia-platform.eu/v2/riders/")

        return req.client.get(ridersURI, headers: req.miaHeaders)
            .flatMapThrowing { response -> [Rider] in
                if response.status != .ok {
                    throw Error.crudCallError("Cannot get riders")
                }
                do {
                    return try response.content.decode([Rider].self)
                } catch let error as DecodingError {
                    throw Error.modelDecodingError("Cannot decode [Rider] - \(error.description)")
                }
            }
            .map { riders in
                return Hello(
                    tokenSent: user.token,
                    pathParamSent: nil,
                    queryParamSent: helloGetRequest.queryParam,
                    riders: riders,
                    message: "Hello, world!"
                )
            }
    }
}
