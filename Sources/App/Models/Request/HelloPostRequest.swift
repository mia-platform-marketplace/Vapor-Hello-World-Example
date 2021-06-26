import Vapor

enum HelloPostRequest {
    struct Body: Content {
        var firstname: String
        var lastname: String
    }
}

extension HelloPostRequest.Body: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("firstname", as: String.self, is: .ascii && .count(3...))
        validations.add("lastname", as: String.self, is: .ascii && .count(3...))
    }
}
