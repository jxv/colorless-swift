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

public func fromAst(ast: Ast) -> ServerExpr {
    switch (ast) {
        case .ref(let ref):
            return ServerExpr.ref(ServerExprRef(symbol: ref.symbol))
        case .if_(let if_):
            return ServerExpr.if_(ServerExprIf(
              cond: fromAst(ast: if_.cond),
              true_: fromAst(ast: if_.true_),
              false_: fromAst(ast: if_.false_)))
        case .iflet(let iflet):
            return ServerExpr.iflet(ServerExprIflet(
              symbol: iflet.symbol,
              option: fromAst(ast: iflet.option),
              some: fromAst(ast: iflet.some),
              none: fromAst(ast: iflet.none)))
        case .get(let get):
            return ServerExpr.get(ServerExprGet(
                path: get.path,
                expr: fromAst(ast: get.ast)))
        case .set(let set):
            return ServerExpr.set(ServerExprSet(
                path: set.path,
                src: fromAst(ast: set.src),
                dest: fromAst(ast: set.dest)))
        case .define(let define):
            return ServerExpr.define(ServerExprDefine(
                var_: define.var_,
                expr: fromAst(ast: define.expr)))
        case .match(let match):
            return ServerExpr.match(ServerExprMatch(
                enumeral: fromAst(ast: match.enumeral),
                cases: fromAstMatchCases(cases: match.cases)))
        case .lambda(let lambda):
            return ServerExpr.lambda(ServerExprLambda(
                params: lambda.args,
                expr: fromAst(ast: lambda.expr)))
        case .tuple(let tuple):
            return ServerExpr.tuple(ServerExprTuple(
                tuple: tuple.tuple.map { fromAst(ast: $0) } ))
        case .do_(let do_):
            return ServerExpr.do_(ServerExprDo(
                exprs: do_.vals.map { fromAst(ast: $0) }))
        case .fnCall(let fnCall):
            return ServerExpr.fnCall(ServerExprFnCall(
                fn: fromAst(ast: fnCall.fn),
                args: fnCall.args.map { fromAst(ast: $0) }))
        case .hollowCall(let hollowCall):
            return ServerExpr.apiUnCall(ApiUnCall.hollowUnCall(ServerExprHollowUnCall(
                n: hollowCall.n)))
        case .wrapCall(let wrapCall):
            return ServerExpr.apiUnCall(ApiUnCall.wrapUnCall(ServerExprWrapUnCall(
                n: wrapCall.n,
                w: fromAst(ast: wrapCall.w))))
        case .structCall(let structCall):
            return ServerExpr.apiUnCall(ApiUnCall.structUnCall(ServerExprStructUnCall(
                n: structCall.n,
                m: fromAst(ast: structCall.m))))
        case .enumerationCall(let enumerationCall):
            return ServerExpr.apiUnCall(ApiUnCall.enumerationUnCall(ServerExprEnumerationUnCall(
                n: enumerationCall.n,
                e: fromAst(ast: enumerationCall.e))))
        case .enumeral(let enumeral):
            return ServerExpr.unVal(ServerExprUnVal.unEnumeral(ServerExprUnEnumeral(
                tag: enumeral.tag,
                m: enumeral.m.map {
                      members in Dictionary(uniqueKeysWithValues:
                          members.map {
                              member in (member.key, fromAst(ast: member.value)) }) } )))
        case .struct_(let struct_):
            return ServerExpr.unVal(ServerExprUnVal.unStruct(ServerExprUnStruct(
                m: Dictionary(uniqueKeysWithValues:
                    struct_.m.map {
                        member in (member.key, fromAst(ast: member.value)) }))))
        case .wrap(let wrap):
            return ServerExpr.unVal(ServerExprUnVal.unWrap(ServerExprUnWrap(w: fromAst(ast: wrap.w))))
        case .const(let const):
            return ServerExpr.unVal(ServerExprUnVal.const(const))
    }
}

public func fromAstMatchCases(cases: [AstMatchCase]) -> [EnumeralName: ServerExprMatchCase] {
    return Dictionary(uniqueKeysWithValues: cases.map {
        switch ($0) {
            case .tag(let name, let ast):
                return (name, ServerExprMatchCase.tag(fromAst(ast: ast)))
            case .members(let name, let sym, let ast):
                return (name, ServerExprMatchCase.members(sym, fromAst(ast: ast)))
        }
    })
}

//

public struct ApiParser<Api> {
    let hollow: [TypeName: Api]
    let struct_: [TypeName: (Val) -> Api?]
    let enumeration: [TypeName: (Val) -> Api?]
    let wrap: [TypeName: (Val) -> Api?]
}
