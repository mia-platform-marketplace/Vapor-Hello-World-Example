@testable import App
import XCTVapor

final class MiaHeadersProxyTests: XCTestCase {
    func testMiaHeadersProxy() throws {
        Environment.process.ADDITIONAL_HEADERS_TO_PROXY = "header-to-proxy-1, header-to-proxy-2"
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        // swiftlint:disable trailing_closure
        // MARK: - miaHeaders is empty when no headers are present
        try app.test(.GET, "proxy-headers", headers: [:], beforeRequest: { req in
            XCTAssertEqual(req.miaHeaders, HTTPHeaders())
        })

        // MARK: - miaHeaders contains the correct headers when x-request-id has a value
        var headers: HTTPHeaders = ["x-request-id": "1234abcd"]
        try app.test(.GET, "proxy-headers", headers: headers, beforeRequest: { req in
            XCTAssertEqual(req.miaHeaders, headers)
        })

        // MARK: - miaHeaders contains the correct headers when miauserid has a value
        headers = ["userid": "miauserid"]
        try app.test(.GET, "proxy-headers", headers: headers, beforeRequest: { req in
            XCTAssertEqual(req.miaHeaders, headers)
        })

        // MARK: - miaHeaders contains the correct headers when miausergroups has a value
        headers = ["usergroups": "miausergroups"]
        try app.test(.GET, "proxy-headers", headers: headers, beforeRequest: { req in
            XCTAssertEqual(req.miaHeaders, headers)
        })

        // MARK: - miaHeaders contains the correct headers when client-type has a value
        headers = ["clienttype": "type"]
        try app.test(.GET, "proxy-headers", headers: headers, beforeRequest: { req in
            XCTAssertEqual(req.miaHeaders, headers)
        })

        // MARK: - miaHeaders contains the correct headers when isbackoffice has a value
        headers = ["isbackoffice": "true"]
        try app.test(.GET, "proxy-headers", headers: headers, beforeRequest: { req in
            XCTAssertEqual(req.miaHeaders, headers)
        })

        // MARK: - miaHeaders contains the correct headers when miauserproperties has a value
        headers = ["userproperties": "property"]
        try app.test(.GET, "proxy-headers", headers: headers, beforeRequest: { req in
            XCTAssertEqual(req.miaHeaders, headers)
        })

        // MARK: - miaHeaders contains the correct headers when all platform headers have value
        let allMiaHeaders: HTTPHeaders = [
            "x-request-id": "1234abcd",
            "userid": "miauserid",
            "usergroups": "miausergroups",
            "clienttype": "type",
            "isbackoffice": "true",
            "userproperties": "property"
        ]
        try app.test(.GET, "proxy-headers", headers: allMiaHeaders, beforeRequest: { req in
            XCTAssertEqual(req.miaHeaders, allMiaHeaders)
        })

        // MARK: - miaHeaders contains only headers to proxy when there are more
        headers = [
            "x-request-id": "1234abcd",
            "userid": "miauserid",
            "usergroups": "miausergroups",
            "clienttype": "type",
            "isbackoffice": "true",
            "userproperties": "property",
            "some-other-header": "other"
        ]
        try app.test(.GET, "proxy-headers", headers: headers, beforeRequest: { req in
            XCTAssertEqual(req.miaHeaders, allMiaHeaders)
        })

        // MARK: - miaHeaders contains the additional headers to proxy if present
        headers = [
            "x-request-id": "1234abcd",
            "userid": "miauserid",
            "usergroups": "miausergroups",
            "clienttype": "type",
            "isbackoffice": "true",
            "userproperties": "property",
            "header-to-proxy-1": "proxy-1",
            "header-to-proxy-2": "proxy-2"
        ]
        try app.test(.GET, "proxy-headers", headers: headers, beforeRequest: { req in
            XCTAssertEqual(req.miaHeaders, headers)
        })
    }
}
