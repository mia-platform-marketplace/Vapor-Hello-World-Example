import Vapor
 
public struct MiaHeaders {
    private static let requestIdKey = "x-request-id"
    private static let userIdKey = Environment.get("USERID_HEADER_KEY") ?? "miauserid"
    private static let groupsKey = Environment.get("GROUPS_HEADER_KEY") ?? "miausergroups"
    private static let clientTypeKey = Environment.get("CLIENTTYPE_HEADER_KEY") ?? "client-type"
    private static let backofficeKey = Environment.get("BACKOFFICE_HEADER_KEY") ?? "isbackoffice"
    private static let userPropertiesKey = Environment.get("USER_PROPERTIES_HEADER_KEY") ?? "miauserproperties"
    private static let additionalHeaderKeys = Environment.get("ADDITIONAL_HEADERS_TO_PROXY")?
        .components(separatedBy: ",")
        .map { $0.trimmingCharacters(in: [" "]) }
        ?? []
    
    private static let miaHeaderKeys = [requestIdKey, userIdKey, groupsKey, clientTypeKey, backofficeKey, userPropertiesKey] + additionalHeaderKeys
    
    private static func addHeader(withKey key: String, from originalHeaders: HTTPHeaders, to headers: inout HTTPHeaders) {
        let headerValue = originalHeaders.first(name: key)
        if let headerValue = headerValue {
            headers.add(name: key, value: headerValue)
        }
    }
    
    public static func from(_ requestHeaders: HTTPHeaders) -> HTTPHeaders {
        miaHeaderKeys.reduce(into: HTTPHeaders()) { headers, miaHeaderKey in
            addHeader(withKey: miaHeaderKey, from: requestHeaders, to: &headers)
        }
    }
}

extension Request {
    var miaHeaders: HTTPHeaders {
        MiaHeaders.from(self.headers)
    }
}
