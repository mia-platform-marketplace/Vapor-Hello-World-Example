import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    if let port = Environment.get("HTTP_PORT") {
        app.http.server.configuration.port = Int(port) ?? 8080
    }

    // register routes
    try routes( app )
}
