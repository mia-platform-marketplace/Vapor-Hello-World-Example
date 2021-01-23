import XCTVapor
import App

extension XCTHTTPRequest {
    var miaHeaders: HTTPHeaders {
        MiaHeaders.from(self)
    }
}
