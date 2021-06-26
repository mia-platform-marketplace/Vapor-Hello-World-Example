import Vapor

enum Error {
    case crudCallError(String)
    case modelDecodingError(String)
    case requestDecodingError(String)
}

extension Error: AbortError {
    var status: HTTPResponseStatus {
        switch self {
        case .crudCallError, .modelDecodingError:
            return .internalServerError
        case .requestDecodingError:
            return .badRequest
        }
    }

    var reason: String {
        switch self {
        case .crudCallError(let message), .modelDecodingError(let message), .requestDecodingError(let message):
            return message
        }
    }
}
