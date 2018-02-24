import Foundation

public struct EvalConfig {
    let limits: Limits
    var langServiceCallLimit: Int
    var langLambdaCount: Int
    var langExprCount: Int
    let apiCall: (ApiCall) -> Val
}

indirect public enum Expr {
    case ref(ExprRef)
}

public enum ExprUnVal {
    case const(Const)
    case unWrap(ExprUnWrap)
    case unStruct(ExprUnStruct)
    case unEnumeral(ExprUnEnumeral)
}

public struct ExprUnWrap {
    let w: Expr
}

public struct ExprUnStruct {
    let m: [MemberName: Expr]
}

public struct ExprUnEnumeral {
    let tag: EnumeralName
    let m: [MemberName: Expr]?
}

public struct ExprRef {
    let symbol: Symbol
}

public struct ExprIf {
    let cond: Expr
    let true_: Expr
    let false_: Expr
}

public struct ExprIfLet {
    let symbol: Symbol
    let option: Expr
    let some: Expr
    let none: Expr
}

public struct ExprGet {
    let path: [String]
    let expr: Expr
}

public struct ExprSet {
    let path: [String]
    let src: Expr
    let dest: Expr
}

public enum ExprMatchCase {
    case tag(Expr)
    case members(Symbol, Expr)
}

public struct ExprMatch {
    let enumeral: Expr
    let cases: [EnumeralName: ExprMatchCase]
}

public struct ExprDefine {
    let var_: Symbol
    let expr: Expr
}

public struct ExprLambda {
    let params: [(Symbol, Type)]
    let expr: Expr
}

typealias ExprFn = (EvalConfig, [Expr]) -> Expr

public struct ExprList {
    let list: [Expr]
}

public struct ExprTuple {
    let tuple: [Expr]
}

public struct ExprDo {
    let exprs: [Expr]
}

public struct ExprFnCall {
    let fn: Expr
    let args: [Expr]
}

public enum ApiUnCall {
    case hollowUnCall(ExprHollowUnCall)
    case wrapUnCall(ExprWrapUnCall)
    case structUnCall(ExprStructUnCall)
    case enumerationUnCall(ExprEnumerationUnCall)
}

public struct ExprHollowUnCall {
    let n: TypeName
}

public struct ExprWrapUnCall {
    let n: TypeName
    let w: Expr
}

public struct ExprStructUnCall {
    let n: TypeName
    let m: Expr
}

public struct ExprEnumerationUnCall {
    let n: TypeName
    let e: Expr
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
