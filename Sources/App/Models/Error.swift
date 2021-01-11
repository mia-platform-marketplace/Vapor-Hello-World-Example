import Vapor

enum Error {
    case CRUDCallError(String)
    case ModelDecodingError(String)
    case RequestDecodingError(String)
}

extension Error: AbortError {
    var status: HTTPResponseStatus {
        switch self {
        case .CRUDCallError,
             .ModelDecodingError:
            return .internalServerError
        case .RequestDecodingError:
            return .badRequest
        }
    }
    
    var reason: String {
        switch self {
        case .CRUDCallError(let message),
             .ModelDecodingError(let message),
             .RequestDecodingError(let message):
            return message
        }
    }
}
