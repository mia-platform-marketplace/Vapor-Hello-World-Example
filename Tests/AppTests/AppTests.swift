@testable import App
import XCTVapor

final class AppTests: XCTestCase {
    func testHelloWorld() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        try app.test(.GET, "hello?token=invalid", afterResponse: { res in
            XCTAssertEqual(res.status, .unauthorized)
        })
        
        try app.test(.GET, "hello?token=good", afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let hello = try res.content.decode(Hello.self)
            XCTAssertEqual(hello.message, "Hello, world!")
        })
    }
}
