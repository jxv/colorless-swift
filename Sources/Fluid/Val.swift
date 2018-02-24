import Foundation

public indirect enum Val {
    case infer(Infer)
    case prim(Prim)
    case apiVal(ApiVal)
    case list([Val])
}

public indirect enum ApiVal {
    case struct_(ValStruct)
    case enumeral(ValEnumeral)
}

public struct ValWrap {
    let w: Val
}

public struct ValStruct {
    let m: [MemberName: Val]
}

public struct ValEnumeral {
    let tag: EnumeralName
    let m: [MemberName: Val]?
}
