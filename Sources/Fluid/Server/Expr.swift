import Foundation

public struct EvalConfig {
    let limits: Limits
    var langServiceCallCount: Int
    var langLambdaCount: Int
    var langExprCount: Int
    let apiCall: (ApiCall) -> Val
}

indirect public enum ServerExpr {
  case ref(ServerExprRef)
  case unVal(ServerExprUnVal)
  case val(Val)
  case if_(ServerExprIf)
  case iflet(ServerExprIflet)
  case get(ServerExprGet)
  case set(ServerExprSet)
  case match(ServerExprMatch)
  case define(ServerExprDefine)
  case lambda(ServerExprLambda)
  case list(ServerExprList)
  case tuple(ServerExprTuple)
  case fn(ServerExprFn)
  case fnCall(ServerExprFnCall)
  case do_(ServerExprDo)
  case apiUnCall(ApiUnCall)
}

public struct ServerExprRef {
    let symbol: Symbol
}

public enum ServerExprUnVal {
    case const(Const)
    case unWrap(ServerExprUnWrap)
    case unStruct(ServerExprUnStruct)
    case unEnumeral(ServerExprUnEnumeral)
}

public struct ServerExprUnWrap {
    let w: ServerExpr
}

public struct ServerExprUnStruct {
    let m: [MemberName: ServerExpr]
}

public struct ServerExprUnEnumeral {
    let tag: EnumeralName
    let m: [MemberName: ServerExpr]?
}

public struct ServerExprIf {
    let cond: ServerExpr
    let true_: ServerExpr
    let false_: ServerExpr
}

public struct ServerExprIflet {
    let symbol: Symbol
    let option: ServerExpr
    let some: ServerExpr
    let none: ServerExpr
}

public struct ServerExprGet {
    let path: [String]
    let expr: ServerExpr
}

public struct ServerExprSet {
    let path: [String]
    let src: ServerExpr
    let dest: ServerExpr
}

public enum ServerExprMatchCase {
    case tag(ServerExpr)
    case members(Symbol, ServerExpr)
}

public struct ServerExprMatch {
    let enumeral: ServerExpr
    let cases: [EnumeralName: ServerExprMatchCase]
}

public struct ServerExprDefine {
    let var_: Symbol
    let expr: ServerExpr
}

public struct ServerExprLambda {
    let params: [(Symbol, Type)]
    let expr: ServerExpr
}

public struct ServerExprFn {
  let run: (EvalConfig, [ServerExpr]) -> ServerExpr
}

public struct ServerExprList {
    let list: [ServerExpr]
}

public struct ServerExprTuple {
    let tuple: [ServerExpr]
}

public struct ServerExprDo {
    let exprs: [ServerExpr]
}

public struct ServerExprFnCall {
    let fn: ServerExpr
    let args: [ServerExpr]
}

public enum ApiUnCall {
    case hollowUnCall(ServerExprHollowUnCall)
    case wrapUnCall(ServerExprWrapUnCall)
    case structUnCall(ServerExprStructUnCall)
    case enumerationUnCall(ServerExprEnumerationUnCall)
}

public struct ServerExprHollowUnCall {
    let n: TypeName
}

public struct ServerExprWrapUnCall {
    let n: TypeName
    let w: ServerExpr
}

public struct ServerExprStructUnCall {
    let n: TypeName
    let m: ServerExpr
}

public struct ServerExprEnumerationUnCall {
    let n: TypeName
    let e: ServerExpr
}

public enum ApiCall {
    case hollow(TypeName)
    case struct_(TypeName, ValStruct)
    case enumeration(TypeName, ValEnumeral)
    case wrap(TypeName, ValWrap)
}

public func apiCallName(apiCall: ApiCall) -> TypeName {
    switch (apiCall) {
        case .hollow(let n):
            return n
        case .struct_(let n, _):
            return n
        case .enumeration(let n, _):
            return n
        case .wrap(let n, _):
            return n
    }
}

//

public struct ApiParser<Api> {
    let hollow: [TypeName: Api]
    let struct_: [TypeName: (Val) -> Api?]
    let enumeration: [TypeName: (Val) -> Api?]
    let wrap: [TypeName: (Val) -> Api?]
}
