import Foundation

public typealias Major = Int
public typealias Minor = Int
public typealias TypeName = String
public typealias EnumeralName = String
public typealias MemberName = String
public typealias Symbol = String

public struct Version : Codable {
    let major: Major
    let minor: Minor
}

public struct Pull {
    let protocol_: String
    let host: String
    let port: Int
    let path: String
}

public enum RuntimeError {
    case unparsableFormat
    case unrecognizedCall(TypeName)
    case variableLimit
    case langServiceCallLimit(Int)
    case langLambdaLimit(Int)
    case unknownVariable(String)
    case incompatiableType
    case missingMatchCase
    case tooFewArguments
    case tooManyArguments
    case noApiVersion
    case noFluidVersion
    case apiMajorVersionTooLow
    case apiMajorVersionTooHigh
    case fluidMajorVersionTooLow
    case fluidMajorVersionTooHigh
    case fluidMinorVersionTooHigh
    case unparsableMeta
    case unparsableQuery
    case notMember
}

public struct Limits : Codable {
    let variables: Int? = 50
    let serviceCalls: Int? = 50
    let lambdas: Int? = 10
    let expressions: Int? = 100
}

public struct Hooks<Meta,XformMeta> {
    let metaMiddleware: (Meta) -> XformMeta
    let sandboxLimits: (XformMeta) -> Limits
}

public func defaultHooks<Meta>() -> Hooks<Meta,Meta> {
    return Hooks<Meta,Meta>(
        metaMiddleware: { (m: Meta) -> Meta in m },
        sandboxLimits: { (m: Meta) -> Limits in Limits.init() }
    )
}

public enum IndirectOptional<Wrapped> : ExpressibleByNilLiteral {
    indirect case some(Wrapped)
    case none

    public init(nilLiteral: ()) {
      self = .none
    }

    @_inlineable
    public func map<U>(
        _ transform: (Wrapped) throws -> U
    ) rethrows -> IndirectOptional<U> {
        switch self {
        case .some(let y):
            return .some(try transform(y))
        case .none:
            return .none
        }
    }

    @_inlineable
    public func flatMap<U>(
        _ transform: (Wrapped) throws -> IndirectOptional<U>
    ) rethrows -> IndirectOptional<U> {
        switch self {
        case .some(let y):
            return try transform(y)
        case .none:
            return .none
        }
    }
}

extension IndirectOptional : Equatable where Wrapped : Equatable {
    @_inlineable
    public static func ==(lhs: IndirectOptional<Wrapped>, rhs: IndirectOptional<Wrapped>) -> Bool {
        switch (lhs, rhs) {
            case let (.some(l) , .some(r)):
                return l == r
            case (nil, nil):
                return true
            default:
                return false
        }
    }
    @_inlineable
    public static func !=(lhs: IndirectOptional<Wrapped>, rhs: IndirectOptional<Wrapped>) -> Bool {
        return !(lhs == rhs)
    }
}

extension IndirectOptional : Encodable where Wrapped : Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
            case .none: try container.encodeNil()
            case .some(let wrapped): try container.encode(wrapped)
        }
    }
}

public struct Type {
    let n: TypeName
    let p: [Type]
    let o: IndirectOptional<Type>
}

public enum Const {
    case null
    case bool(Bool)
    case string(String)
    case number
}

public enum Infer {
    case null
    case number(NSNumber)
}
