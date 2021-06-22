import Vapor

struct HealthController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let healthRoutes = routes.grouped("-")
        healthRoutes.get("healthz", use: healthz)
        healthRoutes.get("ready", use: ready)
        healthRoutes.get("check-up", use: checkUp)
    }

    let healthResponse = Health(serviceName: "MyService", version: "1.0.0", status: .OK)

    func healthz(req: Request) throws -> Health {
        return healthResponse
    }

    func ready(req: Request) throws -> Health {
        return healthResponse
    }

    func checkUp(req: Request) throws -> Health {
        // Add your service's dependencies here
        return healthResponse
    }
}
