import Foundation

public indirect enum Ast {
    case ref(AstRef)
    case if_(AstIf)
    case iflet(AstIflet)
    case get(AstGet)
    case set(AstSet)
    case define(AstDefine)
    case match(AstMatch)
    case lambda(AstLambda)
    case tuple(AstTuple)
    case do_(AstDo)
    case fnCall(AstFnCall)
    case wrapCall(AstWrapCall)
    case structCall(AstStructCall)
    case enumerationCall(AstEnumerationCall)
    case hollowCall(AstHollowCall)
    case enumeral(AstEnumeral)
    case struct_(AstStruct)
    case wrap(AstWrap)
    case const(Const)
}

public struct AstRef {
    let symbol: Symbol
}

public struct AstIf {
    let cond: Ast
    let true_: Ast
    let false_: Ast
}

public struct AstIflet {
    let symbol: Symbol
    let option: Ast
    let some: Ast
    let none: Ast
}

public struct AstGet {
    let path: [String]
    let ast: Ast
}

public struct AstSet {
    let path: [String]
    let src: Ast
    let dest: Ast
}

public struct AstDefine {
    let var_: Symbol
    let expr: Ast
}

public enum AstMatchCase {
    case tag(EnumeralName, Ast)
    case members(EnumeralName, Symbol, Ast)
}

public struct AstMatch {
    let enumeral: Ast
    let cases: [AstMatchCase]
}

public struct AstLambda {
    let args: [(Symbol, Type)]
    let expr: Ast
}

public struct AstList {
    let list: [Ast]
}

public struct AstTuple {
    let tuple: [Ast]
}

public struct AstDo {
    let vals: [Ast]
}

public struct AstFnCall {
    let fn: Ast
    let args: [Ast]
}

public struct AstEnumerationCall {
    let n: TypeName
    let e: Ast
}

public struct AstWrapCall {
    let n: TypeName
    let w: Ast
}

public struct AstStructCall {
    let n: TypeName
    let m: Ast
}

public struct AstHollowCall {
    let n: TypeName
}

public struct AstEnumeral {
    let tag: EnumeralName
    let m: [MemberName: Ast]?
}

public struct AstStruct {
    let m: [MemberName: Ast]
}

public struct AstWrap {
    let w: Ast
}
