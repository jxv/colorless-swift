import Foundation

public indirect enum Ast {
    case ref(Ref)
    case if_(If)
    case iflet(Iflet)
    case get(Get)
    case set(Set)
    case define(Define)
    case match(Match)
    case lambda(Lambda)
    case tuple(Tuple)
    case do_(Do)
    case fnCall(FnCall)
    case wrapCall(WrapCall)
    case structCall(StructCall)
    case enumerationCall(EnumerationCall)
    case hollowCall(HollowCall)
    case enumeral(Enumeral)
    case struct_(Struct)
    case wrap(Wrap)
    case const(Const)
}

public struct Ref {
    let symbol: Symbol
}

public struct If {
    let cond: Ast
    let true_: Ast
    let false_: Ast
}

public struct Iflet {
    let symbol: Symbol
    let option: Ast
    let some: Ast
    let none: Ast
}

public struct Get {
    let path: [String]
    let val: Ast
}

public struct Set {
    let path: [String]
    let src: Ast
    let dest: Ast
}

public struct Define {
    let var_: Symbol
    let expr: Ast
}

public enum MatchCase {
    case tag(EnumeralName, Ast)
    case members(EnumeralName, Symbol, Ast)
}

public struct Match {
    let enumeral: Ast
    let cases: [MatchCase]
}

public struct Lambda {
    let args: [(Symbol, Type)]
    let expr: Ast
}

public struct List {
    let list: [Ast]
}

public struct Tuple {
    let tuple: [Ast]
}

public struct Do {
    let vals: [Ast]
}

public struct FnCall {
    let fn: Ast
    let args: [Ast]
}

public struct EnumerationCall {
    let n: TypeName
    let e: Ast
}

public struct WrapCall {
    let n: TypeName
    let w: Ast
}

public struct StructCall {
    let n: TypeName
    let m: Ast
}

public struct HollowCall {
    let n: TypeName
}

public struct Enumeral {
    let tag: EnumeralName
    let m: [MemberName: Ast]?
}

public struct Struct {
    let m: [MemberName: Ast]
}

public struct Wrap {
    let w: Ast
}
