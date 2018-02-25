import Foundation
import SwiftyJSON

public struct ServerRequest {
    let meta: JSON
    let query: JSON
}

public enum ResponseError {
    case service(JSON)
    case runtime(RuntimeError)
}

public enum Response {
    case error(ResponseError)
    case success(JSON, Limits)
}
