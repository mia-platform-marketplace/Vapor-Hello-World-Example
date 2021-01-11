import Vapor

struct HelloController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let helloRoutes = routes
            .grouped(QueryParamTokenAuthenticator())
            .grouped("hello")
        
        helloRoutes.get(use: index)
        helloRoutes.post(":pathParam", use: post)
        helloRoutes.get("with-riders", use: withRiders)
    }
    
    func index(req: Request) throws -> Hello {
        let user = try req.auth.require(User.self)
        let helloGet = try req.query.decode(HelloGet.self)
        
        return Hello(
            tokenSent: user.token,
            pathParamSent: nil,
            queryParamSent: helloGet.queryParam,
            riders: nil,
            message: "Hello, world!"
        )
    }
    
    func post(req: Request) throws -> Hello {
        let user = try req.auth.require(User.self)
        do {
            let body = try req.content.decode(HelloPost.Body.self)
            return Hello(
                tokenSent: user.token,
                pathParamSent: req.parameters.get("pathParam"),
                queryParamSent: nil,
                riders: nil,
                message: "Hello, \(body.firstname) \(body.lastname)!"
            )
        } catch let error as DecodingError {
            throw Error.RequestDecodingError("Cannot decode request body - \(error.description)")
        }
    }
    
    func withRiders(req: Request) throws -> EventLoopFuture<Hello> {
        let user = try req.auth.require(User.self)
        let helloGet = try req.query.decode(HelloGet.self)
        let ridersURI = URI(string: "https://demo.test.mia-platform.eu/v2/riders/")
        
        return req.client.get(ridersURI)
            .flatMapThrowing { response -> [Rider] in
                if response.status != .ok {
                    throw Error.CRUDCallError("Cannot get riders")
                }
                do {
                    return try response.content.decode([Rider].self)
                } catch let error as DecodingError {
                    throw Error.ModelDecodingError("Cannot decode [Rider] - \(error.description)")
                }
            }
            .map { riders in
                return Hello(
                    tokenSent: user.token,
                    pathParamSent: nil,
                    queryParamSent: helloGet.queryParam,
                    riders: riders,
                    message: "Hello, world!"
                )
            }
    }
}
