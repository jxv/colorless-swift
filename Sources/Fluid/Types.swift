import Foundation

typealias Major = Int
typealias Minor = Int
typealias TypeName = String
typealias EnumeralName = String
typealias MemberName = String
typealias Symbol = String

struct Version {
    let major: Major
    let minor: Minor
}

struct Pull {
    let protocol_: String
    let host: String
    let port: Int
    let path: String
}

enum RuntimeError {
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

struct Limits {
    let variables: Int? = 50
    let serviceCalls: Int? = 50
    let lambdas: Int? = 10
    let expressions: Int? = 100
}

struct Hooks<Meta,XformMeta> {
    let metaMiddleware: (Meta) -> XformMeta
    let sandboxLimits: (XformMeta) -> Limits
}

func defaultHooks<Meta>() -> Hooks<Meta,Meta> {
    return Hooks<Meta,Meta>(
        metaMiddleware: { (m: Meta) -> Meta in m },
        sandboxLimits: { (m: Meta) -> Limits in Limits.init() }
    )
}

enum IndirectOptional<A> {
    indirect case some(A)
    case none
}

struct Type {
    let n: TypeName
    let p: [Type]
    let o: IndirectOptional<Type>
}

enum Const {
    case null
    case bool(Bool)
    case string(String)
    case number
}

enum Infer {
    case null
    case number(NSNumber)
}
