import Foundation

public struct ServerRequest : Codable {
    let meta: Data
    let query: Data
}

public enum ResponseError {
    case service(Data)
    case runtime(RuntimeError)
}

public enum Response {
    case error(ResponseError)
    case success(Data, Limits)
}
