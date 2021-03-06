import App
import XCTVapor

extension XCTHTTPRequest {
    var miaHeaders: HTTPHeaders {
        MiaHeaders.from(self.headers)
    }
}
