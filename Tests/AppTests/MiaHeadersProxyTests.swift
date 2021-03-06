@testable import App
import XCTVapor

final class MiaHeadersProxyTests: XCTestCase {
    func testMiaHeadersProxy() throws {
        Environment.process.ADDITIONAL_HEADERS_TO_PROXY = "header-to-proxy-1, header-to-proxy-2"
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        // MARK: - miaHeaders is empty when no headers are present
        try app.test(.GET, "proxy-headers", headers: [:], beforeRequest: { req in
            XCTAssertEqual(req.miaHeaders, HTTPHeaders())
        })
        
        // MARK: - miaHeaders contains the correct headers when x-request-id has a value
        var headers: HTTPHeaders = ["x-request-id": "1234abcd"]
        try app.test(.GET, "proxy-headers", headers: headers,  beforeRequest: { req in
            XCTAssertEqual(req.miaHeaders, headers)
        })
        
        // MARK: - miaHeaders contains the correct headers when miauserid has a value
        headers = ["miauserid": "userid"]
        try app.test(.GET, "proxy-headers", headers: headers,  beforeRequest: { req in
            XCTAssertEqual(req.miaHeaders, headers)
        })
        
        // MARK: - miaHeaders contains the correct headers when miausergroups has a value
        headers = ["miausergroups": "usergroups"]
        try app.test(.GET, "proxy-headers", headers: headers,  beforeRequest: { req in
            XCTAssertEqual(req.miaHeaders, headers)
        })
        
        // MARK: - miaHeaders contains the correct headers when client-type has a value
        headers = ["client-type": "type"]
        try app.test(.GET, "proxy-headers", headers: headers,  beforeRequest: { req in
            XCTAssertEqual(req.miaHeaders, headers)
        })
        
        // MARK: - miaHeaders contains the correct headers when isbackoffice has a value
        headers = ["isbackoffice": "true"]
        try app.test(.GET, "proxy-headers", headers: headers,  beforeRequest: { req in
            XCTAssertEqual(req.miaHeaders, headers)
        })
        
        // MARK: - miaHeaders contains the correct headers when miauserproperties has a value
        headers = ["miauserproperties": "property"]
        try app.test(.GET, "proxy-headers", headers: headers,  beforeRequest: { req in
            XCTAssertEqual(req.miaHeaders, headers)
        })
        
        // MARK: - miaHeaders contains the correct headers when all platform headers have value
        let allMiaHeaders: HTTPHeaders = [
            "x-request-id": "1234abcd",
            "miauserid": "userid",
            "miausergroups": "usergroups",
            "client-type": "type",
            "isbackoffice": "true",
            "miauserproperties": "property"
        ]
        try app.test(.GET, "proxy-headers", headers: allMiaHeaders,  beforeRequest: { req in
            XCTAssertEqual(req.miaHeaders, allMiaHeaders)
        })
        
        // MARK: - miaHeaders contains only headers to proxy when there are more
        headers = [
            "x-request-id": "1234abcd",
            "miauserid": "userid",
            "miausergroups": "usergroups",
            "client-type": "type",
            "isbackoffice": "true",
            "miauserproperties": "property",
            "some-other-header": "other"
        ]
        try app.test(.GET, "proxy-headers", headers: headers,  beforeRequest: { req in
            XCTAssertEqual(req.miaHeaders, allMiaHeaders)
        })
        
        // MARK: - miaHeaders contains the additional headers to proxy if present
        headers = [
            "x-request-id": "1234abcd",
            "miauserid": "userid",
            "miausergroups": "usergroups",
            "client-type": "type",
            "isbackoffice": "true",
            "miauserproperties": "property",
            "header-to-proxy-1": "proxy-1",
            "header-to-proxy-2": "proxy-2"
        ]
        try app.test(.GET, "proxy-headers", headers: headers, beforeRequest: { req in
            XCTAssertEqual(req.miaHeaders, headers)
        })
    }
}
